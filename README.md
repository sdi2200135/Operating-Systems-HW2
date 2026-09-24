# Operating Systems-HW2
# MLFQ Scheduler for xv6-riscv

## Author
Papathanasiou Eleni – 1115202200135

---

## 1. Introduction

This project implements a **Multilevel Feedback Queue (MLFQ) scheduler** for
the **xv6-riscv** operating system, along with a process-monitoring system
based on the `getpinfo()` system call. The MLFQ scheduler replaces the simple
round-robin scheduler of xv6 and provides hierarchical scheduling with four
priority levels, including mechanisms to avoid starvation and to optimize
system responsiveness.

The implementation follows the classic MLFQ rules:

- **4 priority queues** (levels 0–3)
- **Round-robin** within each queue
- **Automatic demotion** when the time slice is exhausted
- **Automatic promotion** after prolonged waiting
- **Priority preservation** on voluntary CPU yield

The project also extends the system with a user program `ps`, similar to its
Linux counterpart, which displays detailed information about all active
processes, including their MLFQ priorities and their states.

---

## 2. Modified Files

### 2.1 Kernel Files

#### `defs.h` – Function declarations
- Added `uint64 sys_getpinfo(void)` in the syscall function list.
- Added prototypes for the MLFQ helper functions used in `proc.c`:
  - `int get_time_slice(int level)` — returns the number of ticks for a given priority level.
  - `int has_to_demote(struct proc* p)` — checks whether a process should be demoted (i.e. its time slice has expired).
  - `int has_to_promote(struct proc* p)` — checks whether a process should be promoted.

#### `param.h` – System and MLFQ parameters
Added the following constants:
- `NQUEUES` — number of queues.
- `TIME_SLICE_0`, `TIME_SLICE_1`, `TIME_SLICE_2`, `TIME_SLICE_3` — time slice for each priority level.
- `PROMO_THRESHOLD` — waiting threshold for promotion (10× the time slice).
- `INIT_RR_INDEX` — initial value for the round-robin index inside each queue.

#### `pstat.h` – Structure for kernel-to-user transfer
New file defining `struct pstat`, used to transfer process information from
the kernel to user space. It contains arrays for all process attributes:
`pid`, `ppid`, `name`, `state`, `priority`, `size`. The `issued` field marks
which entries are valid.

#### `proc.c` – Process implementation and MLFQ scheduler
1. Added the `rr_state[NCPU]` structure with a field
   `last_queued_proc[NQUEUES]`, holding the round-robin state for each CPU
   and each queue level. This allows independent round-robin on each CPU
   (SMP-safe).
2. In `procinit()`, added initialization of `rr_state` for every CPU and
   level with `INIT_RR_INDEX`, preparing the round-robin pointers before use.
3. In `allocproc()`, added initialization of the MLFQ fields so that every
   new process starts at the highest priority (level 0), and reset counters
   so the MLFQ algorithm starts cleanly.
4. In `freeproc()`, added zeroing of the MLFQ fields when a process is
   released, ensuring all fields are cleared when a process becomes `UNUSED`.
5. In `kfork()`, added copying of the MLFQ fields (`priority`,
   `queue_level`, `max_time_slice`) from parent to child, and zeroing of
   `timer_ticks_used` and `wait_timer_ticks`. The child inherits the parent's
   priority and starts with zeroed counters for fair behaviour.
6. In `scheduler()`, the entire scheduling loop was replaced:
   - For every `RUNNABLE` process, `wait_timer_ticks` is incremented and a
     promotion check is performed.
   - The search runs from the highest to the lowest priority, using
     round-robin within each level and switching to the selected process
     via `swtch()`.
   - After execution, a demotion check is performed — but only if the
     process did **not** voluntarily yield the CPU.
7. In `yield()`, added `p->voluntarily_yielded = 1`, marking that the
   process voluntarily gave up the CPU and preventing demotion when a
   process yields before its time slice expires.
8. In `sleep()`, added `p->voluntarily_yielded = 1`, indicating that sleep
   is a form of voluntary CPU yield; the process keeps its priority when it
   wakes up.
9. Added helper functions: `int get_time_slice(int level)`,
   `int has_to_demote(struct proc* p)`, `int has_to_promote(struct proc* p)`.

#### `proc.h` – Process data structures
Added fields to `struct proc`:
- `priority` — MLFQ priority level.
- `timer_ticks_used` — ticks used at the current level (for demotion).
- `wait_timer_ticks` — ticks spent waiting (for promotion).
- `max_time_slice` — maximum time slice for the current level.
- `queue_level` — current queue level.
- `voluntarily_yielded` — flag indicating voluntary CPU yield (to avoid demotion).

#### `syscall.c` – Syscall dispatch
- Added `extern uint64 sys_getpinfo(void)` to the prototypes.
- Added `[SYS_getpinfo] sys_getpinfo` to the syscall table, linking the
  syscall number to its implementation. The `syscalls[]` table is used by
  `syscall()` for dispatch.

#### `syscall.h` – Syscall numbers
Added `#define SYS_getpinfo 22` to assign the new syscall a number for the
syscall stubs.

#### `sysproc.c` – Syscall implementation
- Added `#include "pstat.h"`.
- Implemented `uint64 sys_getpinfo(void)`: it takes the user-space address
  where the data will be written, walks the process table, copies the data
  into a local structure, uses locks to safely access each `struct proc`,
  copies the local structure back to user space via `copyout()`, and returns
  `0` on success or `-1` on failure.

#### `trap.c` – Interrupt and timer-tick handling
Added code in `kerneltrap()` for the timer interrupt case
(`which_dev == 2`). Every time a timer interrupt occurs (every 10 ms), the
`timer_ticks_used` counter of the current process is incremented, enabling
the demotion check when the process exceeds `max_time_slice`. Locking is
required for safe access after an interrupt.

### 2.2 User Files

#### `ps.c` – Process-monitoring program
New file that displays information about all active processes in table form,
converts numeric state values (`pstate`) into human-readable strings, and
filters out unused processes (`isused[i] == 0`).

#### `user.h` – User interfaces
- Added the declaration of `struct pstat`.
- Added the declaration of `int getpinfo(struct pstat*)` to the syscall list.

#### `usys.pl` – Syscall stub generation script
Added the line `entry("getpinfo")`, which generates the assembly stub for the
new syscall and allows user programs to call it through the `ecall`
instruction.

### 2.3 Makefile

Added `$U/_ps` to `UPROGS` so the user program `ps` is built together with
the rest of xv6.

---

## 3. MLFQ Design

### 3.1 Priority levels

There are 4 priority levels (0 = highest, 3 = lowest). Each level has its
own time slice, defined in `param.h` via `TIME_SLICE_0..TIME_SLICE_3`.

### 3.2 Scheduling rules

1. **Round-robin within each queue.** A process that is scheduled runs for
   at most `max_time_slice` ticks before being preempted.
2. **Demotion.** If a process uses up its entire time slice without
   voluntarily yielding, it is moved one level down (to a lower priority).
3. **Promotion.** If a process waits in a queue for longer than
   `PROMO_THRESHOLD` ticks, it is promoted one level up, avoiding starvation.
4. **Voluntary yield preservation.** Calls to `yield()` or `sleep()` set
   `voluntarily_yielded = 1`, so the process is **not** demoted when it
   gives up the CPU before the time slice expires.

### 3.3 SMP considerations

The `rr_state[NCPU]` array stores a per-CPU round-robin index for each
queue level, ensuring that round-robin scheduling is independent per CPU.

### 3.4 Process inheritance

When a new process is created by `fork()`, it inherits its parent's
`priority`, `queue_level`, and `max_time_slice`, but its counters
(`timer_ticks_used`, `wait_timer_ticks`) are reset to zero.

---

## 4. The `ps` Program and `getpinfo()`

### 4.1 `getpinfo()` system call

The new system call `SYS_getpinfo` (number 22) allows a user program to
obtain a snapshot of the process table. The user passes a pointer to a
`struct pstat`, and the kernel fills it with the following per-process
information:

- `pid`, `ppid`
- `name`
- `state` (process state)
- `priority` (MLFQ level)
- `size` (memory size)

### 4.2 `ps` user program

`ps` calls `getpinfo()` and prints a table of all processes. Only entries
with `issued[i] != 0` are shown. Numeric state values are converted into
readable strings (e.g. `RUNNABLE`, `RUNNING`, `SLEEPING`, `ZOMBIE`).

---

## 5. Build & Run

```bash
# Build xv6-riscv (from the xv6 root directory)
make qemu

# Inside the xv6 shell
$ ps
```

`ps` is built as part of `UPROGS` because `$U/_ps` was added to the
Makefile.

---

## 6. Summary of Changes

| File | Purpose |
|------|---------|
| `defs.h` | Syscall + MLFQ helper prototypes |
| `param.h` | MLFQ constants (queues, time slices, promotion threshold) |
| `pstat.h` | Kernel↔user structure for process info |
| `proc.c` | MLFQ scheduler, per-CPU RR state, helper functions |
| `proc.h` | New `struct proc` fields for MLFQ |
| `syscall.c` | Syscall dispatch table entry |
| `syscall.h` | Syscall number `SYS_getpinfo` |
| `sysproc.c` | `sys_getpinfo()` implementation |
| `trap.c` | Timer-tick accounting |
| `ps.c` | User program that prints the process table |
| `user.h` | User-side `pstat` and `getpinfo` declarations |
| `usys.pl` | Syscall stub for `getpinfo` |
| `Makefile` | Added `$U/_ps` to `UPROGS` |
