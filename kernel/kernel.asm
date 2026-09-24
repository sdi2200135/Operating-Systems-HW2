
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	87010113          	addi	sp,sp,-1936 # 80007870 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04a000ef          	jal	ra,80000060 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	0x14d,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd607>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	d7878793          	addi	a5,a5,-648 # 80000df8 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a2:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	ra,8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	7159                	addi	sp,sp,-112
    800000d2:	f486                	sd	ra,104(sp)
    800000d4:	f0a2                	sd	s0,96(sp)
    800000d6:	eca6                	sd	s1,88(sp)
    800000d8:	e8ca                	sd	s2,80(sp)
    800000da:	e4ce                	sd	s3,72(sp)
    800000dc:	e0d2                	sd	s4,64(sp)
    800000de:	fc56                	sd	s5,56(sp)
    800000e0:	f85a                	sd	s6,48(sp)
    800000e2:	f45e                	sd	s7,40(sp)
    800000e4:	f062                	sd	s8,32(sp)
    800000e6:	1880                	addi	s0,sp,112
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while(i < n){
    800000e8:	04c05463          	blez	a2,80000130 <consolewrite+0x60>
    800000ec:	8a2a                	mv	s4,a0
    800000ee:	8aae                	mv	s5,a1
    800000f0:	89b2                	mv	s3,a2
  int i = 0;
    800000f2:	4901                	li	s2,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000f4:	4bfd                	li	s7,31
    int nn = sizeof(buf);
    800000f6:	02000c13          	li	s8,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800000fa:	5b7d                	li	s6,-1
    800000fc:	a025                	j	80000124 <consolewrite+0x54>
    800000fe:	86a6                	mv	a3,s1
    80000100:	01590633          	add	a2,s2,s5
    80000104:	85d2                	mv	a1,s4
    80000106:	f9040513          	addi	a0,s0,-112
    8000010a:	765010ef          	jal	ra,8000206e <either_copyin>
    8000010e:	03650263          	beq	a0,s6,80000132 <consolewrite+0x62>
      break;
    uartwrite(buf, nn);
    80000112:	85a6                	mv	a1,s1
    80000114:	f9040513          	addi	a0,s0,-112
    80000118:	724000ef          	jal	ra,8000083c <uartwrite>
    i += nn;
    8000011c:	0124893b          	addw	s2,s1,s2
  while(i < n){
    80000120:	01395963          	bge	s2,s3,80000132 <consolewrite+0x62>
    if(nn > n - i)
    80000124:	412984bb          	subw	s1,s3,s2
    80000128:	fc9bdbe3          	bge	s7,s1,800000fe <consolewrite+0x2e>
    int nn = sizeof(buf);
    8000012c:	84e2                	mv	s1,s8
    8000012e:	bfc1                	j	800000fe <consolewrite+0x2e>
  int i = 0;
    80000130:	4901                	li	s2,0
  }

  return i;
}
    80000132:	854a                	mv	a0,s2
    80000134:	70a6                	ld	ra,104(sp)
    80000136:	7406                	ld	s0,96(sp)
    80000138:	64e6                	ld	s1,88(sp)
    8000013a:	6946                	ld	s2,80(sp)
    8000013c:	69a6                	ld	s3,72(sp)
    8000013e:	6a06                	ld	s4,64(sp)
    80000140:	7ae2                	ld	s5,56(sp)
    80000142:	7b42                	ld	s6,48(sp)
    80000144:	7ba2                	ld	s7,40(sp)
    80000146:	7c02                	ld	s8,32(sp)
    80000148:	6165                	addi	sp,sp,112
    8000014a:	8082                	ret

000000008000014c <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000014c:	7119                	addi	sp,sp,-128
    8000014e:	fc86                	sd	ra,120(sp)
    80000150:	f8a2                	sd	s0,112(sp)
    80000152:	f4a6                	sd	s1,104(sp)
    80000154:	f0ca                	sd	s2,96(sp)
    80000156:	ecce                	sd	s3,88(sp)
    80000158:	e8d2                	sd	s4,80(sp)
    8000015a:	e4d6                	sd	s5,72(sp)
    8000015c:	e0da                	sd	s6,64(sp)
    8000015e:	fc5e                	sd	s7,56(sp)
    80000160:	f862                	sd	s8,48(sp)
    80000162:	f466                	sd	s9,40(sp)
    80000164:	f06a                	sd	s10,32(sp)
    80000166:	ec6e                	sd	s11,24(sp)
    80000168:	0100                	addi	s0,sp,128
    8000016a:	8b2a                	mv	s6,a0
    8000016c:	8aae                	mv	s5,a1
    8000016e:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000170:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000174:	0000f517          	auipc	a0,0xf
    80000178:	6fc50513          	addi	a0,a0,1788 # 8000f870 <cons>
    8000017c:	1ff000ef          	jal	ra,80000b7a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000180:	0000f497          	auipc	s1,0xf
    80000184:	6f048493          	addi	s1,s1,1776 # 8000f870 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000188:	89a6                	mv	s3,s1
    8000018a:	0000f917          	auipc	s2,0xf
    8000018e:	77e90913          	addi	s2,s2,1918 # 8000f908 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80000192:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000194:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80000196:	4da9                	li	s11,10
  while(n > 0){
    80000198:	07405363          	blez	s4,800001fe <consoleread+0xb2>
    while(cons.r == cons.w){
    8000019c:	0984a783          	lw	a5,152(s1)
    800001a0:	09c4a703          	lw	a4,156(s1)
    800001a4:	02f71163          	bne	a4,a5,800001c6 <consoleread+0x7a>
      if(killed(myproc())){
    800001a8:	698010ef          	jal	ra,80001840 <myproc>
    800001ac:	555010ef          	jal	ra,80001f00 <killed>
    800001b0:	e125                	bnez	a0,80000210 <consoleread+0xc4>
      sleep(&cons.r, &cons.lock);
    800001b2:	85ce                	mv	a1,s3
    800001b4:	854a                	mv	a0,s2
    800001b6:	30d010ef          	jal	ra,80001cc2 <sleep>
    while(cons.r == cons.w){
    800001ba:	0984a783          	lw	a5,152(s1)
    800001be:	09c4a703          	lw	a4,156(s1)
    800001c2:	fef703e3          	beq	a4,a5,800001a8 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001c6:	0017871b          	addiw	a4,a5,1
    800001ca:	08e4ac23          	sw	a4,152(s1)
    800001ce:	07f7f713          	andi	a4,a5,127
    800001d2:	9726                	add	a4,a4,s1
    800001d4:	01874703          	lbu	a4,24(a4)
    800001d8:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800001dc:	079c0063          	beq	s8,s9,8000023c <consoleread+0xf0>
    cbuf = c;
    800001e0:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001e4:	4685                	li	a3,1
    800001e6:	f8f40613          	addi	a2,s0,-113
    800001ea:	85d6                	mv	a1,s5
    800001ec:	855a                	mv	a0,s6
    800001ee:	637010ef          	jal	ra,80002024 <either_copyout>
    800001f2:	01a50663          	beq	a0,s10,800001fe <consoleread+0xb2>
    dst++;
    800001f6:	0a85                	addi	s5,s5,1
    --n;
    800001f8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800001fa:	f9bc1fe3          	bne	s8,s11,80000198 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001fe:	0000f517          	auipc	a0,0xf
    80000202:	67250513          	addi	a0,a0,1650 # 8000f870 <cons>
    80000206:	20d000ef          	jal	ra,80000c12 <release>

  return target - n;
    8000020a:	414b853b          	subw	a0,s7,s4
    8000020e:	a801                	j	8000021e <consoleread+0xd2>
        release(&cons.lock);
    80000210:	0000f517          	auipc	a0,0xf
    80000214:	66050513          	addi	a0,a0,1632 # 8000f870 <cons>
    80000218:	1fb000ef          	jal	ra,80000c12 <release>
        return -1;
    8000021c:	557d                	li	a0,-1
}
    8000021e:	70e6                	ld	ra,120(sp)
    80000220:	7446                	ld	s0,112(sp)
    80000222:	74a6                	ld	s1,104(sp)
    80000224:	7906                	ld	s2,96(sp)
    80000226:	69e6                	ld	s3,88(sp)
    80000228:	6a46                	ld	s4,80(sp)
    8000022a:	6aa6                	ld	s5,72(sp)
    8000022c:	6b06                	ld	s6,64(sp)
    8000022e:	7be2                	ld	s7,56(sp)
    80000230:	7c42                	ld	s8,48(sp)
    80000232:	7ca2                	ld	s9,40(sp)
    80000234:	7d02                	ld	s10,32(sp)
    80000236:	6de2                	ld	s11,24(sp)
    80000238:	6109                	addi	sp,sp,128
    8000023a:	8082                	ret
      if(n < target){
    8000023c:	000a071b          	sext.w	a4,s4
    80000240:	fb777fe3          	bgeu	a4,s7,800001fe <consoleread+0xb2>
        cons.r--;
    80000244:	0000f717          	auipc	a4,0xf
    80000248:	6cf72223          	sw	a5,1732(a4) # 8000f908 <cons+0x98>
    8000024c:	bf4d                	j	800001fe <consoleread+0xb2>

000000008000024e <consputc>:
{
    8000024e:	1141                	addi	sp,sp,-16
    80000250:	e406                	sd	ra,8(sp)
    80000252:	e022                	sd	s0,0(sp)
    80000254:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000256:	10000793          	li	a5,256
    8000025a:	00f50863          	beq	a0,a5,8000026a <consputc+0x1c>
    uartputc_sync(c);
    8000025e:	67c000ef          	jal	ra,800008da <uartputc_sync>
}
    80000262:	60a2                	ld	ra,8(sp)
    80000264:	6402                	ld	s0,0(sp)
    80000266:	0141                	addi	sp,sp,16
    80000268:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000026a:	4521                	li	a0,8
    8000026c:	66e000ef          	jal	ra,800008da <uartputc_sync>
    80000270:	02000513          	li	a0,32
    80000274:	666000ef          	jal	ra,800008da <uartputc_sync>
    80000278:	4521                	li	a0,8
    8000027a:	660000ef          	jal	ra,800008da <uartputc_sync>
    8000027e:	b7d5                	j	80000262 <consputc+0x14>

0000000080000280 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000280:	1101                	addi	sp,sp,-32
    80000282:	ec06                	sd	ra,24(sp)
    80000284:	e822                	sd	s0,16(sp)
    80000286:	e426                	sd	s1,8(sp)
    80000288:	e04a                	sd	s2,0(sp)
    8000028a:	1000                	addi	s0,sp,32
    8000028c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000028e:	0000f517          	auipc	a0,0xf
    80000292:	5e250513          	addi	a0,a0,1506 # 8000f870 <cons>
    80000296:	0e5000ef          	jal	ra,80000b7a <acquire>

  switch(c){
    8000029a:	47d5                	li	a5,21
    8000029c:	0af48063          	beq	s1,a5,8000033c <consoleintr+0xbc>
    800002a0:	0297c663          	blt	a5,s1,800002cc <consoleintr+0x4c>
    800002a4:	47a1                	li	a5,8
    800002a6:	0cf48f63          	beq	s1,a5,80000384 <consoleintr+0x104>
    800002aa:	47c1                	li	a5,16
    800002ac:	10f49063          	bne	s1,a5,800003ac <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    800002b0:	609010ef          	jal	ra,800020b8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002b4:	0000f517          	auipc	a0,0xf
    800002b8:	5bc50513          	addi	a0,a0,1468 # 8000f870 <cons>
    800002bc:	157000ef          	jal	ra,80000c12 <release>
}
    800002c0:	60e2                	ld	ra,24(sp)
    800002c2:	6442                	ld	s0,16(sp)
    800002c4:	64a2                	ld	s1,8(sp)
    800002c6:	6902                	ld	s2,0(sp)
    800002c8:	6105                	addi	sp,sp,32
    800002ca:	8082                	ret
  switch(c){
    800002cc:	07f00793          	li	a5,127
    800002d0:	0af48a63          	beq	s1,a5,80000384 <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002d4:	0000f717          	auipc	a4,0xf
    800002d8:	59c70713          	addi	a4,a4,1436 # 8000f870 <cons>
    800002dc:	0a072783          	lw	a5,160(a4)
    800002e0:	09872703          	lw	a4,152(a4)
    800002e4:	9f99                	subw	a5,a5,a4
    800002e6:	07f00713          	li	a4,127
    800002ea:	fcf765e3          	bltu	a4,a5,800002b4 <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002ee:	47b5                	li	a5,13
    800002f0:	0cf48163          	beq	s1,a5,800003b2 <consoleintr+0x132>
      consputc(c);
    800002f4:	8526                	mv	a0,s1
    800002f6:	f59ff0ef          	jal	ra,8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002fa:	0000f797          	auipc	a5,0xf
    800002fe:	57678793          	addi	a5,a5,1398 # 8000f870 <cons>
    80000302:	0a07a683          	lw	a3,160(a5)
    80000306:	0016871b          	addiw	a4,a3,1
    8000030a:	0007061b          	sext.w	a2,a4
    8000030e:	0ae7a023          	sw	a4,160(a5)
    80000312:	07f6f693          	andi	a3,a3,127
    80000316:	97b6                	add	a5,a5,a3
    80000318:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000031c:	47a9                	li	a5,10
    8000031e:	0af48f63          	beq	s1,a5,800003dc <consoleintr+0x15c>
    80000322:	4791                	li	a5,4
    80000324:	0af48c63          	beq	s1,a5,800003dc <consoleintr+0x15c>
    80000328:	0000f797          	auipc	a5,0xf
    8000032c:	5e07a783          	lw	a5,1504(a5) # 8000f908 <cons+0x98>
    80000330:	9f1d                	subw	a4,a4,a5
    80000332:	08000793          	li	a5,128
    80000336:	f6f71fe3          	bne	a4,a5,800002b4 <consoleintr+0x34>
    8000033a:	a04d                	j	800003dc <consoleintr+0x15c>
    while(cons.e != cons.w &&
    8000033c:	0000f717          	auipc	a4,0xf
    80000340:	53470713          	addi	a4,a4,1332 # 8000f870 <cons>
    80000344:	0a072783          	lw	a5,160(a4)
    80000348:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034c:	0000f497          	auipc	s1,0xf
    80000350:	52448493          	addi	s1,s1,1316 # 8000f870 <cons>
    while(cons.e != cons.w &&
    80000354:	4929                	li	s2,10
    80000356:	f4f70fe3          	beq	a4,a5,800002b4 <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000035a:	37fd                	addiw	a5,a5,-1
    8000035c:	07f7f713          	andi	a4,a5,127
    80000360:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000362:	01874703          	lbu	a4,24(a4)
    80000366:	f52707e3          	beq	a4,s2,800002b4 <consoleintr+0x34>
      cons.e--;
    8000036a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000036e:	10000513          	li	a0,256
    80000372:	eddff0ef          	jal	ra,8000024e <consputc>
    while(cons.e != cons.w &&
    80000376:	0a04a783          	lw	a5,160(s1)
    8000037a:	09c4a703          	lw	a4,156(s1)
    8000037e:	fcf71ee3          	bne	a4,a5,8000035a <consoleintr+0xda>
    80000382:	bf0d                	j	800002b4 <consoleintr+0x34>
    if(cons.e != cons.w){
    80000384:	0000f717          	auipc	a4,0xf
    80000388:	4ec70713          	addi	a4,a4,1260 # 8000f870 <cons>
    8000038c:	0a072783          	lw	a5,160(a4)
    80000390:	09c72703          	lw	a4,156(a4)
    80000394:	f2f700e3          	beq	a4,a5,800002b4 <consoleintr+0x34>
      cons.e--;
    80000398:	37fd                	addiw	a5,a5,-1
    8000039a:	0000f717          	auipc	a4,0xf
    8000039e:	56f72b23          	sw	a5,1398(a4) # 8000f910 <cons+0xa0>
      consputc(BACKSPACE);
    800003a2:	10000513          	li	a0,256
    800003a6:	ea9ff0ef          	jal	ra,8000024e <consputc>
    800003aa:	b729                	j	800002b4 <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003ac:	f00484e3          	beqz	s1,800002b4 <consoleintr+0x34>
    800003b0:	b715                	j	800002d4 <consoleintr+0x54>
      consputc(c);
    800003b2:	4529                	li	a0,10
    800003b4:	e9bff0ef          	jal	ra,8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b8:	0000f797          	auipc	a5,0xf
    800003bc:	4b878793          	addi	a5,a5,1208 # 8000f870 <cons>
    800003c0:	0a07a703          	lw	a4,160(a5)
    800003c4:	0017069b          	addiw	a3,a4,1
    800003c8:	0006861b          	sext.w	a2,a3
    800003cc:	0ad7a023          	sw	a3,160(a5)
    800003d0:	07f77713          	andi	a4,a4,127
    800003d4:	97ba                	add	a5,a5,a4
    800003d6:	4729                	li	a4,10
    800003d8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003dc:	0000f797          	auipc	a5,0xf
    800003e0:	52c7a823          	sw	a2,1328(a5) # 8000f90c <cons+0x9c>
        wakeup(&cons.r);
    800003e4:	0000f517          	auipc	a0,0xf
    800003e8:	52450513          	addi	a0,a0,1316 # 8000f908 <cons+0x98>
    800003ec:	129010ef          	jal	ra,80001d14 <wakeup>
    800003f0:	b5d1                	j	800002b4 <consoleintr+0x34>

00000000800003f2 <consoleinit>:

void
consoleinit(void)
{
    800003f2:	1141                	addi	sp,sp,-16
    800003f4:	e406                	sd	ra,8(sp)
    800003f6:	e022                	sd	s0,0(sp)
    800003f8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003fa:	00007597          	auipc	a1,0x7
    800003fe:	c1658593          	addi	a1,a1,-1002 # 80007010 <etext+0x10>
    80000402:	0000f517          	auipc	a0,0xf
    80000406:	46e50513          	addi	a0,a0,1134 # 8000f870 <cons>
    8000040a:	6f0000ef          	jal	ra,80000afa <initlock>

  uartinit();
    8000040e:	3e2000ef          	jal	ra,800007f0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000412:	00020797          	auipc	a5,0x20
    80000416:	c4e78793          	addi	a5,a5,-946 # 80020060 <devsw>
    8000041a:	00000717          	auipc	a4,0x0
    8000041e:	d3270713          	addi	a4,a4,-718 # 8000014c <consoleread>
    80000422:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000424:	00000717          	auipc	a4,0x0
    80000428:	cac70713          	addi	a4,a4,-852 # 800000d0 <consolewrite>
    8000042c:	ef98                	sd	a4,24(a5)
}
    8000042e:	60a2                	ld	ra,8(sp)
    80000430:	6402                	ld	s0,0(sp)
    80000432:	0141                	addi	sp,sp,16
    80000434:	8082                	ret

0000000080000436 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000436:	7139                	addi	sp,sp,-64
    80000438:	fc06                	sd	ra,56(sp)
    8000043a:	f822                	sd	s0,48(sp)
    8000043c:	f426                	sd	s1,40(sp)
    8000043e:	f04a                	sd	s2,32(sp)
    80000440:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000442:	c219                	beqz	a2,80000448 <printint+0x12>
    80000444:	06054f63          	bltz	a0,800004c2 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    80000448:	4881                	li	a7,0
    8000044a:	fc840693          	addi	a3,s0,-56

  i = 0;
    8000044e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000450:	00007617          	auipc	a2,0x7
    80000454:	be860613          	addi	a2,a2,-1048 # 80007038 <digits>
    80000458:	883e                	mv	a6,a5
    8000045a:	2785                	addiw	a5,a5,1
    8000045c:	02b57733          	remu	a4,a0,a1
    80000460:	9732                	add	a4,a4,a2
    80000462:	00074703          	lbu	a4,0(a4)
    80000466:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000046a:	872a                	mv	a4,a0
    8000046c:	02b55533          	divu	a0,a0,a1
    80000470:	0685                	addi	a3,a3,1
    80000472:	feb773e3          	bgeu	a4,a1,80000458 <printint+0x22>

  if(sign)
    80000476:	00088b63          	beqz	a7,8000048c <printint+0x56>
    buf[i++] = '-';
    8000047a:	fe040713          	addi	a4,s0,-32
    8000047e:	97ba                	add	a5,a5,a4
    80000480:	02d00713          	li	a4,45
    80000484:	fee78423          	sb	a4,-24(a5)
    80000488:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000048c:	02f05563          	blez	a5,800004b6 <printint+0x80>
    80000490:	fc840713          	addi	a4,s0,-56
    80000494:	00f704b3          	add	s1,a4,a5
    80000498:	fff70913          	addi	s2,a4,-1
    8000049c:	993e                	add	s2,s2,a5
    8000049e:	37fd                	addiw	a5,a5,-1
    800004a0:	1782                	slli	a5,a5,0x20
    800004a2:	9381                	srli	a5,a5,0x20
    800004a4:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a8:	fff4c503          	lbu	a0,-1(s1)
    800004ac:	da3ff0ef          	jal	ra,8000024e <consputc>
  while(--i >= 0)
    800004b0:	14fd                	addi	s1,s1,-1
    800004b2:	ff249be3          	bne	s1,s2,800004a8 <printint+0x72>
}
    800004b6:	70e2                	ld	ra,56(sp)
    800004b8:	7442                	ld	s0,48(sp)
    800004ba:	74a2                	ld	s1,40(sp)
    800004bc:	7902                	ld	s2,32(sp)
    800004be:	6121                	addi	sp,sp,64
    800004c0:	8082                	ret
    x = -xx;
    800004c2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004c6:	4885                	li	a7,1
    x = -xx;
    800004c8:	b749                	j	8000044a <printint+0x14>

00000000800004ca <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004ca:	7131                	addi	sp,sp,-192
    800004cc:	fc86                	sd	ra,120(sp)
    800004ce:	f8a2                	sd	s0,112(sp)
    800004d0:	f4a6                	sd	s1,104(sp)
    800004d2:	f0ca                	sd	s2,96(sp)
    800004d4:	ecce                	sd	s3,88(sp)
    800004d6:	e8d2                	sd	s4,80(sp)
    800004d8:	e4d6                	sd	s5,72(sp)
    800004da:	e0da                	sd	s6,64(sp)
    800004dc:	fc5e                	sd	s7,56(sp)
    800004de:	f862                	sd	s8,48(sp)
    800004e0:	f466                	sd	s9,40(sp)
    800004e2:	f06a                	sd	s10,32(sp)
    800004e4:	ec6e                	sd	s11,24(sp)
    800004e6:	0100                	addi	s0,sp,128
    800004e8:	8a2a                	mv	s4,a0
    800004ea:	e40c                	sd	a1,8(s0)
    800004ec:	e810                	sd	a2,16(s0)
    800004ee:	ec14                	sd	a3,24(s0)
    800004f0:	f018                	sd	a4,32(s0)
    800004f2:	f41c                	sd	a5,40(s0)
    800004f4:	03043823          	sd	a6,48(s0)
    800004f8:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    800004fc:	00007797          	auipc	a5,0x7
    80000500:	3487a783          	lw	a5,840(a5) # 80007844 <panicking>
    80000504:	cb9d                	beqz	a5,8000053a <printf+0x70>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000506:	00840793          	addi	a5,s0,8
    8000050a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000050e:	000a4503          	lbu	a0,0(s4)
    80000512:	24050363          	beqz	a0,80000758 <printf+0x28e>
    80000516:	4981                	li	s3,0
    if(cx != '%'){
    80000518:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000051c:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000520:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000524:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000528:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000052c:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000530:	00007b97          	auipc	s7,0x7
    80000534:	b08b8b93          	addi	s7,s7,-1272 # 80007038 <digits>
    80000538:	a01d                	j	8000055e <printf+0x94>
    acquire(&pr.lock);
    8000053a:	0000f517          	auipc	a0,0xf
    8000053e:	3de50513          	addi	a0,a0,990 # 8000f918 <pr>
    80000542:	638000ef          	jal	ra,80000b7a <acquire>
    80000546:	b7c1                	j	80000506 <printf+0x3c>
      consputc(cx);
    80000548:	d07ff0ef          	jal	ra,8000024e <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050f63          	beqz	a0,80000758 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x7e>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090563          	beqz	s2,80000758 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xb8>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690863          	beq	s2,s6,800005b2 <printf+0xe8>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890263          	beq	s2,s8,800005ca <printf+0x100>
    } else if(c0 == 'u'){
    8000058a:	0d990163          	beq	s2,s9,8000064c <printf+0x182>
    } else if(c0 == 'x'){
    8000058e:	11a90863          	beq	s2,s10,8000069e <printf+0x1d4>
    } else if(c0 == 'p'){
    80000592:	15b90163          	beq	s2,s11,800006d4 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    80000596:	06300793          	li	a5,99
    8000059a:	16f90963          	beq	s2,a5,8000070c <printf+0x242>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    8000059e:	07300793          	li	a5,115
    800005a2:	16f90f63          	beq	s2,a5,80000720 <printf+0x256>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005a6:	03591c63          	bne	s2,s5,800005de <printf+0x114>
      consputc('%');
    800005aa:	8556                	mv	a0,s5
    800005ac:	ca3ff0ef          	jal	ra,8000024e <consputc>
    800005b0:	bf79                	j	8000054e <printf+0x84>
      printint(va_arg(ap, int), 10, 1);
    800005b2:	f8843783          	ld	a5,-120(s0)
    800005b6:	00878713          	addi	a4,a5,8
    800005ba:	f8e43423          	sd	a4,-120(s0)
    800005be:	4605                	li	a2,1
    800005c0:	45a9                	li	a1,10
    800005c2:	4388                	lw	a0,0(a5)
    800005c4:	e73ff0ef          	jal	ra,80000436 <printint>
    800005c8:	b759                	j	8000054e <printf+0x84>
    } else if(c0 == 'l' && c1 == 'd'){
    800005ca:	03678163          	beq	a5,s6,800005ec <printf+0x122>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005ce:	03878d63          	beq	a5,s8,80000608 <printf+0x13e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d2:	09978a63          	beq	a5,s9,80000666 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005d6:	03878b63          	beq	a5,s8,8000060c <printf+0x142>
    } else if(c0 == 'l' && c1 == 'x'){
    800005da:	0da78f63          	beq	a5,s10,800006b8 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005de:	8556                	mv	a0,s5
    800005e0:	c6fff0ef          	jal	ra,8000024e <consputc>
      consputc(c0);
    800005e4:	854a                	mv	a0,s2
    800005e6:	c69ff0ef          	jal	ra,8000024e <consputc>
    800005ea:	b795                	j	8000054e <printf+0x84>
      printint(va_arg(ap, uint64), 10, 1);
    800005ec:	f8843783          	ld	a5,-120(s0)
    800005f0:	00878713          	addi	a4,a5,8
    800005f4:	f8e43423          	sd	a4,-120(s0)
    800005f8:	4605                	li	a2,1
    800005fa:	45a9                	li	a1,10
    800005fc:	6388                	ld	a0,0(a5)
    800005fe:	e39ff0ef          	jal	ra,80000436 <printint>
      i += 1;
    80000602:	0029849b          	addiw	s1,s3,2
    80000606:	b7a1                	j	8000054e <printf+0x84>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000608:	03668463          	beq	a3,s6,80000630 <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000060c:	07968b63          	beq	a3,s9,80000682 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000610:	fda697e3          	bne	a3,s10,800005de <printf+0x114>
      printint(va_arg(ap, uint64), 16, 0);
    80000614:	f8843783          	ld	a5,-120(s0)
    80000618:	00878713          	addi	a4,a5,8
    8000061c:	f8e43423          	sd	a4,-120(s0)
    80000620:	4601                	li	a2,0
    80000622:	45c1                	li	a1,16
    80000624:	6388                	ld	a0,0(a5)
    80000626:	e11ff0ef          	jal	ra,80000436 <printint>
      i += 2;
    8000062a:	0039849b          	addiw	s1,s3,3
    8000062e:	b705                	j	8000054e <printf+0x84>
      printint(va_arg(ap, uint64), 10, 1);
    80000630:	f8843783          	ld	a5,-120(s0)
    80000634:	00878713          	addi	a4,a5,8
    80000638:	f8e43423          	sd	a4,-120(s0)
    8000063c:	4605                	li	a2,1
    8000063e:	45a9                	li	a1,10
    80000640:	6388                	ld	a0,0(a5)
    80000642:	df5ff0ef          	jal	ra,80000436 <printint>
      i += 2;
    80000646:	0039849b          	addiw	s1,s3,3
    8000064a:	b711                	j	8000054e <printf+0x84>
      printint(va_arg(ap, uint32), 10, 0);
    8000064c:	f8843783          	ld	a5,-120(s0)
    80000650:	00878713          	addi	a4,a5,8
    80000654:	f8e43423          	sd	a4,-120(s0)
    80000658:	4601                	li	a2,0
    8000065a:	45a9                	li	a1,10
    8000065c:	0007e503          	lwu	a0,0(a5)
    80000660:	dd7ff0ef          	jal	ra,80000436 <printint>
    80000664:	b5ed                	j	8000054e <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    80000666:	f8843783          	ld	a5,-120(s0)
    8000066a:	00878713          	addi	a4,a5,8
    8000066e:	f8e43423          	sd	a4,-120(s0)
    80000672:	4601                	li	a2,0
    80000674:	45a9                	li	a1,10
    80000676:	6388                	ld	a0,0(a5)
    80000678:	dbfff0ef          	jal	ra,80000436 <printint>
      i += 1;
    8000067c:	0029849b          	addiw	s1,s3,2
    80000680:	b5f9                	j	8000054e <printf+0x84>
      printint(va_arg(ap, uint64), 10, 0);
    80000682:	f8843783          	ld	a5,-120(s0)
    80000686:	00878713          	addi	a4,a5,8
    8000068a:	f8e43423          	sd	a4,-120(s0)
    8000068e:	4601                	li	a2,0
    80000690:	45a9                	li	a1,10
    80000692:	6388                	ld	a0,0(a5)
    80000694:	da3ff0ef          	jal	ra,80000436 <printint>
      i += 2;
    80000698:	0039849b          	addiw	s1,s3,3
    8000069c:	bd4d                	j	8000054e <printf+0x84>
      printint(va_arg(ap, uint32), 16, 0);
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	addi	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	4601                	li	a2,0
    800006ac:	45c1                	li	a1,16
    800006ae:	0007e503          	lwu	a0,0(a5)
    800006b2:	d85ff0ef          	jal	ra,80000436 <printint>
    800006b6:	bd61                	j	8000054e <printf+0x84>
      printint(va_arg(ap, uint64), 16, 0);
    800006b8:	f8843783          	ld	a5,-120(s0)
    800006bc:	00878713          	addi	a4,a5,8
    800006c0:	f8e43423          	sd	a4,-120(s0)
    800006c4:	4601                	li	a2,0
    800006c6:	45c1                	li	a1,16
    800006c8:	6388                	ld	a0,0(a5)
    800006ca:	d6dff0ef          	jal	ra,80000436 <printint>
      i += 1;
    800006ce:	0029849b          	addiw	s1,s3,2
    800006d2:	bdb5                	j	8000054e <printf+0x84>
      printptr(va_arg(ap, uint64));
    800006d4:	f8843783          	ld	a5,-120(s0)
    800006d8:	00878713          	addi	a4,a5,8
    800006dc:	f8e43423          	sd	a4,-120(s0)
    800006e0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006e4:	03000513          	li	a0,48
    800006e8:	b67ff0ef          	jal	ra,8000024e <consputc>
  consputc('x');
    800006ec:	856a                	mv	a0,s10
    800006ee:	b61ff0ef          	jal	ra,8000024e <consputc>
    800006f2:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b51ff0ef          	jal	ra,8000024e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x22a>
    8000070a:	b591                	j	8000054e <printf+0x84>
      consputc(va_arg(ap, uint));
    8000070c:	f8843783          	ld	a5,-120(s0)
    80000710:	00878713          	addi	a4,a5,8
    80000714:	f8e43423          	sd	a4,-120(s0)
    80000718:	4388                	lw	a0,0(a5)
    8000071a:	b35ff0ef          	jal	ra,8000024e <consputc>
    8000071e:	bd05                	j	8000054e <printf+0x84>
      if((s = va_arg(ap, char*)) == 0)
    80000720:	f8843783          	ld	a5,-120(s0)
    80000724:	00878713          	addi	a4,a5,8
    80000728:	f8e43423          	sd	a4,-120(s0)
    8000072c:	0007b903          	ld	s2,0(a5)
    80000730:	00090d63          	beqz	s2,8000074a <printf+0x280>
      for(; *s; s++)
    80000734:	00094503          	lbu	a0,0(s2)
    80000738:	e0050be3          	beqz	a0,8000054e <printf+0x84>
        consputc(*s);
    8000073c:	b13ff0ef          	jal	ra,8000024e <consputc>
      for(; *s; s++)
    80000740:	0905                	addi	s2,s2,1
    80000742:	00094503          	lbu	a0,0(s2)
    80000746:	f97d                	bnez	a0,8000073c <printf+0x272>
    80000748:	b519                	j	8000054e <printf+0x84>
        s = "(null)";
    8000074a:	00007917          	auipc	s2,0x7
    8000074e:	8ce90913          	addi	s2,s2,-1842 # 80007018 <etext+0x18>
      for(; *s; s++)
    80000752:	02800513          	li	a0,40
    80000756:	b7dd                	j	8000073c <printf+0x272>
    }

  }
  va_end(ap);

  if(panicking == 0)
    80000758:	00007797          	auipc	a5,0x7
    8000075c:	0ec7a783          	lw	a5,236(a5) # 80007844 <panicking>
    80000760:	c38d                	beqz	a5,80000782 <printf+0x2b8>
    release(&pr.lock);

  return 0;
}
    80000762:	4501                	li	a0,0
    80000764:	70e6                	ld	ra,120(sp)
    80000766:	7446                	ld	s0,112(sp)
    80000768:	74a6                	ld	s1,104(sp)
    8000076a:	7906                	ld	s2,96(sp)
    8000076c:	69e6                	ld	s3,88(sp)
    8000076e:	6a46                	ld	s4,80(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	7d02                	ld	s10,32(sp)
    8000077c:	6de2                	ld	s11,24(sp)
    8000077e:	6129                	addi	sp,sp,192
    80000780:	8082                	ret
    release(&pr.lock);
    80000782:	0000f517          	auipc	a0,0xf
    80000786:	19650513          	addi	a0,a0,406 # 8000f918 <pr>
    8000078a:	488000ef          	jal	ra,80000c12 <release>
  return 0;
    8000078e:	bfd1                	j	80000762 <printf+0x298>

0000000080000790 <panic>:

void
panic(char *s)
{
    80000790:	1101                	addi	sp,sp,-32
    80000792:	ec06                	sd	ra,24(sp)
    80000794:	e822                	sd	s0,16(sp)
    80000796:	e426                	sd	s1,8(sp)
    80000798:	e04a                	sd	s2,0(sp)
    8000079a:	1000                	addi	s0,sp,32
    8000079c:	892a                	mv	s2,a0
  panicking = 1;
    8000079e:	4485                	li	s1,1
    800007a0:	00007797          	auipc	a5,0x7
    800007a4:	0a97a223          	sw	s1,164(a5) # 80007844 <panicking>
  printf("panic: ");
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	87850513          	addi	a0,a0,-1928 # 80007020 <etext+0x20>
    800007b0:	d1bff0ef          	jal	ra,800004ca <printf>
  printf("%s\n", s);
    800007b4:	85ca                	mv	a1,s2
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	87250513          	addi	a0,a0,-1934 # 80007028 <etext+0x28>
    800007be:	d0dff0ef          	jal	ra,800004ca <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	00007797          	auipc	a5,0x7
    800007c6:	0697af23          	sw	s1,126(a5) # 80007840 <panicked>
  for(;;)
    800007ca:	a001                	j	800007ca <panic+0x3a>

00000000800007cc <printfinit>:
    ;
}

void
printfinit(void)
{
    800007cc:	1141                	addi	sp,sp,-16
    800007ce:	e406                	sd	ra,8(sp)
    800007d0:	e022                	sd	s0,0(sp)
    800007d2:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    800007d4:	00007597          	auipc	a1,0x7
    800007d8:	85c58593          	addi	a1,a1,-1956 # 80007030 <etext+0x30>
    800007dc:	0000f517          	auipc	a0,0xf
    800007e0:	13c50513          	addi	a0,a0,316 # 8000f918 <pr>
    800007e4:	316000ef          	jal	ra,80000afa <initlock>
}
    800007e8:	60a2                	ld	ra,8(sp)
    800007ea:	6402                	ld	s0,0(sp)
    800007ec:	0141                	addi	sp,sp,16
    800007ee:	8082                	ret

00000000800007f0 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    800007f0:	1141                	addi	sp,sp,-16
    800007f2:	e406                	sd	ra,8(sp)
    800007f4:	e022                	sd	s0,0(sp)
    800007f6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007f8:	100007b7          	lui	a5,0x10000
    800007fc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000800:	f8000713          	li	a4,-128
    80000804:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000808:	470d                	li	a4,3
    8000080a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000812:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000816:	469d                	li	a3,7
    80000818:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00e780a3          	sb	a4,1(a5)

  initlock(&tx_lock, "uart");
    80000820:	00007597          	auipc	a1,0x7
    80000824:	83058593          	addi	a1,a1,-2000 # 80007050 <digits+0x18>
    80000828:	0000f517          	auipc	a0,0xf
    8000082c:	10850513          	addi	a0,a0,264 # 8000f930 <tx_lock>
    80000830:	2ca000ef          	jal	ra,80000afa <initlock>
}
    80000834:	60a2                	ld	ra,8(sp)
    80000836:	6402                	ld	s0,0(sp)
    80000838:	0141                	addi	sp,sp,16
    8000083a:	8082                	ret

000000008000083c <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    8000083c:	715d                	addi	sp,sp,-80
    8000083e:	e486                	sd	ra,72(sp)
    80000840:	e0a2                	sd	s0,64(sp)
    80000842:	fc26                	sd	s1,56(sp)
    80000844:	f84a                	sd	s2,48(sp)
    80000846:	f44e                	sd	s3,40(sp)
    80000848:	f052                	sd	s4,32(sp)
    8000084a:	ec56                	sd	s5,24(sp)
    8000084c:	e85a                	sd	s6,16(sp)
    8000084e:	e45e                	sd	s7,8(sp)
    80000850:	0880                	addi	s0,sp,80
    80000852:	84aa                	mv	s1,a0
    80000854:	8aae                	mv	s5,a1
  acquire(&tx_lock);
    80000856:	0000f517          	auipc	a0,0xf
    8000085a:	0da50513          	addi	a0,a0,218 # 8000f930 <tx_lock>
    8000085e:	31c000ef          	jal	ra,80000b7a <acquire>

  int i = 0;
  while(i < n){ 
    80000862:	05505b63          	blez	s5,800008b8 <uartwrite+0x7c>
    80000866:	8a26                	mv	s4,s1
    80000868:	0485                	addi	s1,s1,1
    8000086a:	3afd                	addiw	s5,s5,-1
    8000086c:	1a82                	slli	s5,s5,0x20
    8000086e:	020ada93          	srli	s5,s5,0x20
    80000872:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80000874:	00007497          	auipc	s1,0x7
    80000878:	fd848493          	addi	s1,s1,-40 # 8000784c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    8000087c:	0000f997          	auipc	s3,0xf
    80000880:	0b498993          	addi	s3,s3,180 # 8000f930 <tx_lock>
    80000884:	00007917          	auipc	s2,0x7
    80000888:	fc490913          	addi	s2,s2,-60 # 80007848 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    8000088c:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000890:	4b05                	li	s6,1
    80000892:	a005                	j	800008b2 <uartwrite+0x76>
      sleep(&tx_chan, &tx_lock);
    80000894:	85ce                	mv	a1,s3
    80000896:	854a                	mv	a0,s2
    80000898:	42a010ef          	jal	ra,80001cc2 <sleep>
    while(tx_busy != 0){
    8000089c:	409c                	lw	a5,0(s1)
    8000089e:	fbfd                	bnez	a5,80000894 <uartwrite+0x58>
    WriteReg(THR, buf[i]);
    800008a0:	000a4783          	lbu	a5,0(s4)
    800008a4:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800008a8:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800008ac:	0a05                	addi	s4,s4,1
    800008ae:	015a0563          	beq	s4,s5,800008b8 <uartwrite+0x7c>
    while(tx_busy != 0){
    800008b2:	409c                	lw	a5,0(s1)
    800008b4:	f3e5                	bnez	a5,80000894 <uartwrite+0x58>
    800008b6:	b7ed                	j	800008a0 <uartwrite+0x64>
  }

  release(&tx_lock);
    800008b8:	0000f517          	auipc	a0,0xf
    800008bc:	07850513          	addi	a0,a0,120 # 8000f930 <tx_lock>
    800008c0:	352000ef          	jal	ra,80000c12 <release>
}
    800008c4:	60a6                	ld	ra,72(sp)
    800008c6:	6406                	ld	s0,64(sp)
    800008c8:	74e2                	ld	s1,56(sp)
    800008ca:	7942                	ld	s2,48(sp)
    800008cc:	79a2                	ld	s3,40(sp)
    800008ce:	7a02                	ld	s4,32(sp)
    800008d0:	6ae2                	ld	s5,24(sp)
    800008d2:	6b42                	ld	s6,16(sp)
    800008d4:	6ba2                	ld	s7,8(sp)
    800008d6:	6161                	addi	sp,sp,80
    800008d8:	8082                	ret

00000000800008da <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800008da:	1101                	addi	sp,sp,-32
    800008dc:	ec06                	sd	ra,24(sp)
    800008de:	e822                	sd	s0,16(sp)
    800008e0:	e426                	sd	s1,8(sp)
    800008e2:	1000                	addi	s0,sp,32
    800008e4:	84aa                	mv	s1,a0
  if(panicking == 0)
    800008e6:	00007797          	auipc	a5,0x7
    800008ea:	f5e7a783          	lw	a5,-162(a5) # 80007844 <panicking>
    800008ee:	cb89                	beqz	a5,80000900 <uartputc_sync+0x26>
    push_off();

  if(panicked){
    800008f0:	00007797          	auipc	a5,0x7
    800008f4:	f507a783          	lw	a5,-176(a5) # 80007840 <panicked>
    for(;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800008f8:	10000737          	lui	a4,0x10000
  if(panicked){
    800008fc:	c789                	beqz	a5,80000906 <uartputc_sync+0x2c>
    for(;;)
    800008fe:	a001                	j	800008fe <uartputc_sync+0x24>
    push_off();
    80000900:	23a000ef          	jal	ra,80000b3a <push_off>
    80000904:	b7f5                	j	800008f0 <uartputc_sync+0x16>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000906:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000090a:	0ff7f793          	andi	a5,a5,255
    8000090e:	0207f793          	andi	a5,a5,32
    80000912:	dbf5                	beqz	a5,80000906 <uartputc_sync+0x2c>
    ;
  WriteReg(THR, c);
    80000914:	0ff4f793          	andi	a5,s1,255
    80000918:	10000737          	lui	a4,0x10000
    8000091c:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80000920:	00007797          	auipc	a5,0x7
    80000924:	f247a783          	lw	a5,-220(a5) # 80007844 <panicking>
    80000928:	c791                	beqz	a5,80000934 <uartputc_sync+0x5a>
    pop_off();
}
    8000092a:	60e2                	ld	ra,24(sp)
    8000092c:	6442                	ld	s0,16(sp)
    8000092e:	64a2                	ld	s1,8(sp)
    80000930:	6105                	addi	sp,sp,32
    80000932:	8082                	ret
    pop_off();
    80000934:	28a000ef          	jal	ra,80000bbe <pop_off>
}
    80000938:	bfcd                	j	8000092a <uartputc_sync+0x50>

000000008000093a <uartgetc>:

// try to read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000093a:	1141                	addi	sp,sp,-16
    8000093c:	e422                	sd	s0,8(sp)
    8000093e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80000940:	100007b7          	lui	a5,0x10000
    80000944:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000948:	8b85                	andi	a5,a5,1
    8000094a:	cb91                	beqz	a5,8000095e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000094c:	100007b7          	lui	a5,0x10000
    80000950:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000954:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000958:	6422                	ld	s0,8(sp)
    8000095a:	0141                	addi	sp,sp,16
    8000095c:	8082                	ret
    return -1;
    8000095e:	557d                	li	a0,-1
    80000960:	bfe5                	j	80000958 <uartgetc+0x1e>

0000000080000962 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000962:	1101                	addi	sp,sp,-32
    80000964:	ec06                	sd	ra,24(sp)
    80000966:	e822                	sd	s0,16(sp)
    80000968:	e426                	sd	s1,8(sp)
    8000096a:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    8000096c:	100004b7          	lui	s1,0x10000
    80000970:	0024c783          	lbu	a5,2(s1) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80000974:	0000f517          	auipc	a0,0xf
    80000978:	fbc50513          	addi	a0,a0,-68 # 8000f930 <tx_lock>
    8000097c:	1fe000ef          	jal	ra,80000b7a <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80000980:	0054c783          	lbu	a5,5(s1)
    80000984:	0ff7f793          	andi	a5,a5,255
    80000988:	0207f793          	andi	a5,a5,32
    8000098c:	ef99                	bnez	a5,800009aa <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    8000098e:	0000f517          	auipc	a0,0xf
    80000992:	fa250513          	addi	a0,a0,-94 # 8000f930 <tx_lock>
    80000996:	27c000ef          	jal	ra,80000c12 <release>

  // read and process incoming characters, if any.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000099a:	54fd                	li	s1,-1
    int c = uartgetc();
    8000099c:	f9fff0ef          	jal	ra,8000093a <uartgetc>
    if(c == -1)
    800009a0:	02950063          	beq	a0,s1,800009c0 <uartintr+0x5e>
      break;
    consoleintr(c);
    800009a4:	8ddff0ef          	jal	ra,80000280 <consoleintr>
  while(1){
    800009a8:	bfd5                	j	8000099c <uartintr+0x3a>
    tx_busy = 0;
    800009aa:	00007797          	auipc	a5,0x7
    800009ae:	ea07a123          	sw	zero,-350(a5) # 8000784c <tx_busy>
    wakeup(&tx_chan);
    800009b2:	00007517          	auipc	a0,0x7
    800009b6:	e9650513          	addi	a0,a0,-362 # 80007848 <tx_chan>
    800009ba:	35a010ef          	jal	ra,80001d14 <wakeup>
    800009be:	bfc1                	j	8000098e <uartintr+0x2c>
  }
}
    800009c0:	60e2                	ld	ra,24(sp)
    800009c2:	6442                	ld	s0,16(sp)
    800009c4:	64a2                	ld	s1,8(sp)
    800009c6:	6105                	addi	sp,sp,32
    800009c8:	8082                	ret

00000000800009ca <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	e04a                	sd	s2,0(sp)
    800009d4:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009d6:	03451793          	slli	a5,a0,0x34
    800009da:	e7a9                	bnez	a5,80000a24 <kfree+0x5a>
    800009dc:	84aa                	mv	s1,a0
    800009de:	00021797          	auipc	a5,0x21
    800009e2:	81a78793          	addi	a5,a5,-2022 # 800211f8 <end>
    800009e6:	02f56f63          	bltu	a0,a5,80000a24 <kfree+0x5a>
    800009ea:	47c5                	li	a5,17
    800009ec:	07ee                	slli	a5,a5,0x1b
    800009ee:	02f57b63          	bgeu	a0,a5,80000a24 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009f2:	6605                	lui	a2,0x1
    800009f4:	4585                	li	a1,1
    800009f6:	258000ef          	jal	ra,80000c4e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    800009fa:	0000f917          	auipc	s2,0xf
    800009fe:	f4e90913          	addi	s2,s2,-178 # 8000f948 <kmem>
    80000a02:	854a                	mv	a0,s2
    80000a04:	176000ef          	jal	ra,80000b7a <acquire>
  r->next = kmem.freelist;
    80000a08:	01893783          	ld	a5,24(s2)
    80000a0c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a0e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a12:	854a                	mv	a0,s2
    80000a14:	1fe000ef          	jal	ra,80000c12 <release>
}
    80000a18:	60e2                	ld	ra,24(sp)
    80000a1a:	6442                	ld	s0,16(sp)
    80000a1c:	64a2                	ld	s1,8(sp)
    80000a1e:	6902                	ld	s2,0(sp)
    80000a20:	6105                	addi	sp,sp,32
    80000a22:	8082                	ret
    panic("kfree");
    80000a24:	00006517          	auipc	a0,0x6
    80000a28:	63450513          	addi	a0,a0,1588 # 80007058 <digits+0x20>
    80000a2c:	d65ff0ef          	jal	ra,80000790 <panic>

0000000080000a30 <freerange>:
{
    80000a30:	7179                	addi	sp,sp,-48
    80000a32:	f406                	sd	ra,40(sp)
    80000a34:	f022                	sd	s0,32(sp)
    80000a36:	ec26                	sd	s1,24(sp)
    80000a38:	e84a                	sd	s2,16(sp)
    80000a3a:	e44e                	sd	s3,8(sp)
    80000a3c:	e052                	sd	s4,0(sp)
    80000a3e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a40:	6785                	lui	a5,0x1
    80000a42:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a46:	94aa                	add	s1,s1,a0
    80000a48:	757d                	lui	a0,0xfffff
    80000a4a:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a4c:	94be                	add	s1,s1,a5
    80000a4e:	0095ec63          	bltu	a1,s1,80000a66 <freerange+0x36>
    80000a52:	892e                	mv	s2,a1
    kfree(p);
    80000a54:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a56:	6985                	lui	s3,0x1
    kfree(p);
    80000a58:	01448533          	add	a0,s1,s4
    80000a5c:	f6fff0ef          	jal	ra,800009ca <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a60:	94ce                	add	s1,s1,s3
    80000a62:	fe997be3          	bgeu	s2,s1,80000a58 <freerange+0x28>
}
    80000a66:	70a2                	ld	ra,40(sp)
    80000a68:	7402                	ld	s0,32(sp)
    80000a6a:	64e2                	ld	s1,24(sp)
    80000a6c:	6942                	ld	s2,16(sp)
    80000a6e:	69a2                	ld	s3,8(sp)
    80000a70:	6a02                	ld	s4,0(sp)
    80000a72:	6145                	addi	sp,sp,48
    80000a74:	8082                	ret

0000000080000a76 <kinit>:
{
    80000a76:	1141                	addi	sp,sp,-16
    80000a78:	e406                	sd	ra,8(sp)
    80000a7a:	e022                	sd	s0,0(sp)
    80000a7c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a7e:	00006597          	auipc	a1,0x6
    80000a82:	5e258593          	addi	a1,a1,1506 # 80007060 <digits+0x28>
    80000a86:	0000f517          	auipc	a0,0xf
    80000a8a:	ec250513          	addi	a0,a0,-318 # 8000f948 <kmem>
    80000a8e:	06c000ef          	jal	ra,80000afa <initlock>
  freerange(end, (void*)PHYSTOP);
    80000a92:	45c5                	li	a1,17
    80000a94:	05ee                	slli	a1,a1,0x1b
    80000a96:	00020517          	auipc	a0,0x20
    80000a9a:	76250513          	addi	a0,a0,1890 # 800211f8 <end>
    80000a9e:	f93ff0ef          	jal	ra,80000a30 <freerange>
}
    80000aa2:	60a2                	ld	ra,8(sp)
    80000aa4:	6402                	ld	s0,0(sp)
    80000aa6:	0141                	addi	sp,sp,16
    80000aa8:	8082                	ret

0000000080000aaa <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000aaa:	1101                	addi	sp,sp,-32
    80000aac:	ec06                	sd	ra,24(sp)
    80000aae:	e822                	sd	s0,16(sp)
    80000ab0:	e426                	sd	s1,8(sp)
    80000ab2:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ab4:	0000f497          	auipc	s1,0xf
    80000ab8:	e9448493          	addi	s1,s1,-364 # 8000f948 <kmem>
    80000abc:	8526                	mv	a0,s1
    80000abe:	0bc000ef          	jal	ra,80000b7a <acquire>
  r = kmem.freelist;
    80000ac2:	6c84                	ld	s1,24(s1)
  if(r)
    80000ac4:	c485                	beqz	s1,80000aec <kalloc+0x42>
    kmem.freelist = r->next;
    80000ac6:	609c                	ld	a5,0(s1)
    80000ac8:	0000f517          	auipc	a0,0xf
    80000acc:	e8050513          	addi	a0,a0,-384 # 8000f948 <kmem>
    80000ad0:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000ad2:	140000ef          	jal	ra,80000c12 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000ad6:	6605                	lui	a2,0x1
    80000ad8:	4595                	li	a1,5
    80000ada:	8526                	mv	a0,s1
    80000adc:	172000ef          	jal	ra,80000c4e <memset>
  return (void*)r;
}
    80000ae0:	8526                	mv	a0,s1
    80000ae2:	60e2                	ld	ra,24(sp)
    80000ae4:	6442                	ld	s0,16(sp)
    80000ae6:	64a2                	ld	s1,8(sp)
    80000ae8:	6105                	addi	sp,sp,32
    80000aea:	8082                	ret
  release(&kmem.lock);
    80000aec:	0000f517          	auipc	a0,0xf
    80000af0:	e5c50513          	addi	a0,a0,-420 # 8000f948 <kmem>
    80000af4:	11e000ef          	jal	ra,80000c12 <release>
  if(r)
    80000af8:	b7e5                	j	80000ae0 <kalloc+0x36>

0000000080000afa <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000afa:	1141                	addi	sp,sp,-16
    80000afc:	e422                	sd	s0,8(sp)
    80000afe:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b00:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b02:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b06:	00053823          	sd	zero,16(a0)
}
    80000b0a:	6422                	ld	s0,8(sp)
    80000b0c:	0141                	addi	sp,sp,16
    80000b0e:	8082                	ret

0000000080000b10 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b10:	411c                	lw	a5,0(a0)
    80000b12:	e399                	bnez	a5,80000b18 <holding+0x8>
    80000b14:	4501                	li	a0,0
  return r;
}
    80000b16:	8082                	ret
{
    80000b18:	1101                	addi	sp,sp,-32
    80000b1a:	ec06                	sd	ra,24(sp)
    80000b1c:	e822                	sd	s0,16(sp)
    80000b1e:	e426                	sd	s1,8(sp)
    80000b20:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b22:	6904                	ld	s1,16(a0)
    80000b24:	501000ef          	jal	ra,80001824 <mycpu>
    80000b28:	40a48533          	sub	a0,s1,a0
    80000b2c:	00153513          	seqz	a0,a0
}
    80000b30:	60e2                	ld	ra,24(sp)
    80000b32:	6442                	ld	s0,16(sp)
    80000b34:	64a2                	ld	s1,8(sp)
    80000b36:	6105                	addi	sp,sp,32
    80000b38:	8082                	ret

0000000080000b3a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b3a:	1101                	addi	sp,sp,-32
    80000b3c:	ec06                	sd	ra,24(sp)
    80000b3e:	e822                	sd	s0,16(sp)
    80000b40:	e426                	sd	s1,8(sp)
    80000b42:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b44:	100024f3          	csrr	s1,sstatus
    80000b48:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b4c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b4e:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000b52:	4d3000ef          	jal	ra,80001824 <mycpu>
    80000b56:	5d3c                	lw	a5,120(a0)
    80000b58:	cb99                	beqz	a5,80000b6e <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b5a:	4cb000ef          	jal	ra,80001824 <mycpu>
    80000b5e:	5d3c                	lw	a5,120(a0)
    80000b60:	2785                	addiw	a5,a5,1
    80000b62:	dd3c                	sw	a5,120(a0)
}
    80000b64:	60e2                	ld	ra,24(sp)
    80000b66:	6442                	ld	s0,16(sp)
    80000b68:	64a2                	ld	s1,8(sp)
    80000b6a:	6105                	addi	sp,sp,32
    80000b6c:	8082                	ret
    mycpu()->intena = old;
    80000b6e:	4b7000ef          	jal	ra,80001824 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b72:	8085                	srli	s1,s1,0x1
    80000b74:	8885                	andi	s1,s1,1
    80000b76:	dd64                	sw	s1,124(a0)
    80000b78:	b7cd                	j	80000b5a <push_off+0x20>

0000000080000b7a <acquire>:
{
    80000b7a:	1101                	addi	sp,sp,-32
    80000b7c:	ec06                	sd	ra,24(sp)
    80000b7e:	e822                	sd	s0,16(sp)
    80000b80:	e426                	sd	s1,8(sp)
    80000b82:	1000                	addi	s0,sp,32
    80000b84:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000b86:	fb5ff0ef          	jal	ra,80000b3a <push_off>
  if(holding(lk))
    80000b8a:	8526                	mv	a0,s1
    80000b8c:	f85ff0ef          	jal	ra,80000b10 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000b90:	4705                	li	a4,1
  if(holding(lk))
    80000b92:	e105                	bnez	a0,80000bb2 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000b94:	87ba                	mv	a5,a4
    80000b96:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000b9a:	2781                	sext.w	a5,a5
    80000b9c:	ffe5                	bnez	a5,80000b94 <acquire+0x1a>
  __sync_synchronize();
    80000b9e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000ba2:	483000ef          	jal	ra,80001824 <mycpu>
    80000ba6:	e888                	sd	a0,16(s1)
}
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6105                	addi	sp,sp,32
    80000bb0:	8082                	ret
    panic("acquire");
    80000bb2:	00006517          	auipc	a0,0x6
    80000bb6:	4b650513          	addi	a0,a0,1206 # 80007068 <digits+0x30>
    80000bba:	bd7ff0ef          	jal	ra,80000790 <panic>

0000000080000bbe <pop_off>:

void
pop_off(void)
{
    80000bbe:	1141                	addi	sp,sp,-16
    80000bc0:	e406                	sd	ra,8(sp)
    80000bc2:	e022                	sd	s0,0(sp)
    80000bc4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000bc6:	45f000ef          	jal	ra,80001824 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bce:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000bd0:	e78d                	bnez	a5,80000bfa <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000bd2:	5d3c                	lw	a5,120(a0)
    80000bd4:	02f05963          	blez	a5,80000c06 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000bd8:	37fd                	addiw	a5,a5,-1
    80000bda:	0007871b          	sext.w	a4,a5
    80000bde:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000be0:	eb09                	bnez	a4,80000bf2 <pop_off+0x34>
    80000be2:	5d7c                	lw	a5,124(a0)
    80000be4:	c799                	beqz	a5,80000bf2 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000be6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000bea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bee:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000bf2:	60a2                	ld	ra,8(sp)
    80000bf4:	6402                	ld	s0,0(sp)
    80000bf6:	0141                	addi	sp,sp,16
    80000bf8:	8082                	ret
    panic("pop_off - interruptible");
    80000bfa:	00006517          	auipc	a0,0x6
    80000bfe:	47650513          	addi	a0,a0,1142 # 80007070 <digits+0x38>
    80000c02:	b8fff0ef          	jal	ra,80000790 <panic>
    panic("pop_off");
    80000c06:	00006517          	auipc	a0,0x6
    80000c0a:	48250513          	addi	a0,a0,1154 # 80007088 <digits+0x50>
    80000c0e:	b83ff0ef          	jal	ra,80000790 <panic>

0000000080000c12 <release>:
{
    80000c12:	1101                	addi	sp,sp,-32
    80000c14:	ec06                	sd	ra,24(sp)
    80000c16:	e822                	sd	s0,16(sp)
    80000c18:	e426                	sd	s1,8(sp)
    80000c1a:	1000                	addi	s0,sp,32
    80000c1c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c1e:	ef3ff0ef          	jal	ra,80000b10 <holding>
    80000c22:	c105                	beqz	a0,80000c42 <release+0x30>
  lk->cpu = 0;
    80000c24:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c28:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c2c:	0f50000f          	fence	iorw,ow
    80000c30:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c34:	f8bff0ef          	jal	ra,80000bbe <pop_off>
}
    80000c38:	60e2                	ld	ra,24(sp)
    80000c3a:	6442                	ld	s0,16(sp)
    80000c3c:	64a2                	ld	s1,8(sp)
    80000c3e:	6105                	addi	sp,sp,32
    80000c40:	8082                	ret
    panic("release");
    80000c42:	00006517          	auipc	a0,0x6
    80000c46:	44e50513          	addi	a0,a0,1102 # 80007090 <digits+0x58>
    80000c4a:	b47ff0ef          	jal	ra,80000790 <panic>

0000000080000c4e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c4e:	1141                	addi	sp,sp,-16
    80000c50:	e422                	sd	s0,8(sp)
    80000c52:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c54:	ce09                	beqz	a2,80000c6e <memset+0x20>
    80000c56:	87aa                	mv	a5,a0
    80000c58:	fff6071b          	addiw	a4,a2,-1
    80000c5c:	1702                	slli	a4,a4,0x20
    80000c5e:	9301                	srli	a4,a4,0x20
    80000c60:	0705                	addi	a4,a4,1
    80000c62:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000c64:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c68:	0785                	addi	a5,a5,1
    80000c6a:	fee79de3          	bne	a5,a4,80000c64 <memset+0x16>
  }
  return dst;
}
    80000c6e:	6422                	ld	s0,8(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret

0000000080000c74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c74:	1141                	addi	sp,sp,-16
    80000c76:	e422                	sd	s0,8(sp)
    80000c78:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000c7a:	ca05                	beqz	a2,80000caa <memcmp+0x36>
    80000c7c:	fff6069b          	addiw	a3,a2,-1
    80000c80:	1682                	slli	a3,a3,0x20
    80000c82:	9281                	srli	a3,a3,0x20
    80000c84:	0685                	addi	a3,a3,1
    80000c86:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000c88:	00054783          	lbu	a5,0(a0)
    80000c8c:	0005c703          	lbu	a4,0(a1)
    80000c90:	00e79863          	bne	a5,a4,80000ca0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000c94:	0505                	addi	a0,a0,1
    80000c96:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000c98:	fed518e3          	bne	a0,a3,80000c88 <memcmp+0x14>
  }

  return 0;
    80000c9c:	4501                	li	a0,0
    80000c9e:	a019                	j	80000ca4 <memcmp+0x30>
      return *s1 - *s2;
    80000ca0:	40e7853b          	subw	a0,a5,a4
}
    80000ca4:	6422                	ld	s0,8(sp)
    80000ca6:	0141                	addi	sp,sp,16
    80000ca8:	8082                	ret
  return 0;
    80000caa:	4501                	li	a0,0
    80000cac:	bfe5                	j	80000ca4 <memcmp+0x30>

0000000080000cae <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cae:	1141                	addi	sp,sp,-16
    80000cb0:	e422                	sd	s0,8(sp)
    80000cb2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000cb4:	ca0d                	beqz	a2,80000ce6 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000cb6:	00a5f963          	bgeu	a1,a0,80000cc8 <memmove+0x1a>
    80000cba:	02061693          	slli	a3,a2,0x20
    80000cbe:	9281                	srli	a3,a3,0x20
    80000cc0:	00d58733          	add	a4,a1,a3
    80000cc4:	02e56463          	bltu	a0,a4,80000cec <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000cc8:	fff6079b          	addiw	a5,a2,-1
    80000ccc:	1782                	slli	a5,a5,0x20
    80000cce:	9381                	srli	a5,a5,0x20
    80000cd0:	0785                	addi	a5,a5,1
    80000cd2:	97ae                	add	a5,a5,a1
    80000cd4:	872a                	mv	a4,a0
      *d++ = *s++;
    80000cd6:	0585                	addi	a1,a1,1
    80000cd8:	0705                	addi	a4,a4,1
    80000cda:	fff5c683          	lbu	a3,-1(a1)
    80000cde:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000ce2:	fef59ae3          	bne	a1,a5,80000cd6 <memmove+0x28>

  return dst;
}
    80000ce6:	6422                	ld	s0,8(sp)
    80000ce8:	0141                	addi	sp,sp,16
    80000cea:	8082                	ret
    d += n;
    80000cec:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000cee:	fff6079b          	addiw	a5,a2,-1
    80000cf2:	1782                	slli	a5,a5,0x20
    80000cf4:	9381                	srli	a5,a5,0x20
    80000cf6:	fff7c793          	not	a5,a5
    80000cfa:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000cfc:	177d                	addi	a4,a4,-1
    80000cfe:	16fd                	addi	a3,a3,-1
    80000d00:	00074603          	lbu	a2,0(a4)
    80000d04:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d08:	fef71ae3          	bne	a4,a5,80000cfc <memmove+0x4e>
    80000d0c:	bfe9                	j	80000ce6 <memmove+0x38>

0000000080000d0e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d0e:	1141                	addi	sp,sp,-16
    80000d10:	e406                	sd	ra,8(sp)
    80000d12:	e022                	sd	s0,0(sp)
    80000d14:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d16:	f99ff0ef          	jal	ra,80000cae <memmove>
}
    80000d1a:	60a2                	ld	ra,8(sp)
    80000d1c:	6402                	ld	s0,0(sp)
    80000d1e:	0141                	addi	sp,sp,16
    80000d20:	8082                	ret

0000000080000d22 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d22:	1141                	addi	sp,sp,-16
    80000d24:	e422                	sd	s0,8(sp)
    80000d26:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d28:	ce11                	beqz	a2,80000d44 <strncmp+0x22>
    80000d2a:	00054783          	lbu	a5,0(a0)
    80000d2e:	cf89                	beqz	a5,80000d48 <strncmp+0x26>
    80000d30:	0005c703          	lbu	a4,0(a1)
    80000d34:	00f71a63          	bne	a4,a5,80000d48 <strncmp+0x26>
    n--, p++, q++;
    80000d38:	367d                	addiw	a2,a2,-1
    80000d3a:	0505                	addi	a0,a0,1
    80000d3c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d3e:	f675                	bnez	a2,80000d2a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d40:	4501                	li	a0,0
    80000d42:	a809                	j	80000d54 <strncmp+0x32>
    80000d44:	4501                	li	a0,0
    80000d46:	a039                	j	80000d54 <strncmp+0x32>
  if(n == 0)
    80000d48:	ca09                	beqz	a2,80000d5a <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d4a:	00054503          	lbu	a0,0(a0)
    80000d4e:	0005c783          	lbu	a5,0(a1)
    80000d52:	9d1d                	subw	a0,a0,a5
}
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
    return 0;
    80000d5a:	4501                	li	a0,0
    80000d5c:	bfe5                	j	80000d54 <strncmp+0x32>

0000000080000d5e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d5e:	1141                	addi	sp,sp,-16
    80000d60:	e422                	sd	s0,8(sp)
    80000d62:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d64:	872a                	mv	a4,a0
    80000d66:	8832                	mv	a6,a2
    80000d68:	367d                	addiw	a2,a2,-1
    80000d6a:	01005963          	blez	a6,80000d7c <strncpy+0x1e>
    80000d6e:	0705                	addi	a4,a4,1
    80000d70:	0005c783          	lbu	a5,0(a1)
    80000d74:	fef70fa3          	sb	a5,-1(a4)
    80000d78:	0585                	addi	a1,a1,1
    80000d7a:	f7f5                	bnez	a5,80000d66 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000d7c:	00c05d63          	blez	a2,80000d96 <strncpy+0x38>
    80000d80:	86ba                	mv	a3,a4
    *s++ = 0;
    80000d82:	0685                	addi	a3,a3,1
    80000d84:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000d88:	fff6c793          	not	a5,a3
    80000d8c:	9fb9                	addw	a5,a5,a4
    80000d8e:	010787bb          	addw	a5,a5,a6
    80000d92:	fef048e3          	bgtz	a5,80000d82 <strncpy+0x24>
  return os;
}
    80000d96:	6422                	ld	s0,8(sp)
    80000d98:	0141                	addi	sp,sp,16
    80000d9a:	8082                	ret

0000000080000d9c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000d9c:	1141                	addi	sp,sp,-16
    80000d9e:	e422                	sd	s0,8(sp)
    80000da0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000da2:	02c05363          	blez	a2,80000dc8 <safestrcpy+0x2c>
    80000da6:	fff6069b          	addiw	a3,a2,-1
    80000daa:	1682                	slli	a3,a3,0x20
    80000dac:	9281                	srli	a3,a3,0x20
    80000dae:	96ae                	add	a3,a3,a1
    80000db0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000db2:	00d58963          	beq	a1,a3,80000dc4 <safestrcpy+0x28>
    80000db6:	0585                	addi	a1,a1,1
    80000db8:	0785                	addi	a5,a5,1
    80000dba:	fff5c703          	lbu	a4,-1(a1)
    80000dbe:	fee78fa3          	sb	a4,-1(a5)
    80000dc2:	fb65                	bnez	a4,80000db2 <safestrcpy+0x16>
    ;
  *s = 0;
    80000dc4:	00078023          	sb	zero,0(a5)
  return os;
}
    80000dc8:	6422                	ld	s0,8(sp)
    80000dca:	0141                	addi	sp,sp,16
    80000dcc:	8082                	ret

0000000080000dce <strlen>:

int
strlen(const char *s)
{
    80000dce:	1141                	addi	sp,sp,-16
    80000dd0:	e422                	sd	s0,8(sp)
    80000dd2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000dd4:	00054783          	lbu	a5,0(a0)
    80000dd8:	cf91                	beqz	a5,80000df4 <strlen+0x26>
    80000dda:	0505                	addi	a0,a0,1
    80000ddc:	87aa                	mv	a5,a0
    80000dde:	4685                	li	a3,1
    80000de0:	9e89                	subw	a3,a3,a0
    80000de2:	00f6853b          	addw	a0,a3,a5
    80000de6:	0785                	addi	a5,a5,1
    80000de8:	fff7c703          	lbu	a4,-1(a5)
    80000dec:	fb7d                	bnez	a4,80000de2 <strlen+0x14>
    ;
  return n;
}
    80000dee:	6422                	ld	s0,8(sp)
    80000df0:	0141                	addi	sp,sp,16
    80000df2:	8082                	ret
  for(n = 0; s[n]; n++)
    80000df4:	4501                	li	a0,0
    80000df6:	bfe5                	j	80000dee <strlen+0x20>

0000000080000df8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000df8:	1141                	addi	sp,sp,-16
    80000dfa:	e406                	sd	ra,8(sp)
    80000dfc:	e022                	sd	s0,0(sp)
    80000dfe:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e00:	215000ef          	jal	ra,80001814 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e04:	00007717          	auipc	a4,0x7
    80000e08:	a4c70713          	addi	a4,a4,-1460 # 80007850 <started>
  if(cpuid() == 0){
    80000e0c:	c51d                	beqz	a0,80000e3a <main+0x42>
    while(started == 0)
    80000e0e:	431c                	lw	a5,0(a4)
    80000e10:	2781                	sext.w	a5,a5
    80000e12:	dff5                	beqz	a5,80000e0e <main+0x16>
      ;
    __sync_synchronize();
    80000e14:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e18:	1fd000ef          	jal	ra,80001814 <cpuid>
    80000e1c:	85aa                	mv	a1,a0
    80000e1e:	00006517          	auipc	a0,0x6
    80000e22:	29250513          	addi	a0,a0,658 # 800070b0 <digits+0x78>
    80000e26:	ea4ff0ef          	jal	ra,800004ca <printf>
    kvminithart();    // turn on paging
    80000e2a:	080000ef          	jal	ra,80000eaa <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e2e:	7a0010ef          	jal	ra,800025ce <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e32:	7e2040ef          	jal	ra,80005614 <plicinithart>
  }

  scheduler();        
    80000e36:	482010ef          	jal	ra,800022b8 <scheduler>
    consoleinit();
    80000e3a:	db8ff0ef          	jal	ra,800003f2 <consoleinit>
    printfinit();
    80000e3e:	98fff0ef          	jal	ra,800007cc <printfinit>
    printf("\n");
    80000e42:	00006517          	auipc	a0,0x6
    80000e46:	27e50513          	addi	a0,a0,638 # 800070c0 <digits+0x88>
    80000e4a:	e80ff0ef          	jal	ra,800004ca <printf>
    printf("xv6 kernel is booting\n");
    80000e4e:	00006517          	auipc	a0,0x6
    80000e52:	24a50513          	addi	a0,a0,586 # 80007098 <digits+0x60>
    80000e56:	e74ff0ef          	jal	ra,800004ca <printf>
    printf("\n");
    80000e5a:	00006517          	auipc	a0,0x6
    80000e5e:	26650513          	addi	a0,a0,614 # 800070c0 <digits+0x88>
    80000e62:	e68ff0ef          	jal	ra,800004ca <printf>
    kinit();         // physical page allocator
    80000e66:	c11ff0ef          	jal	ra,80000a76 <kinit>
    kvminit();       // create kernel page table
    80000e6a:	2ca000ef          	jal	ra,80001134 <kvminit>
    kvminithart();   // turn on paging
    80000e6e:	03c000ef          	jal	ra,80000eaa <kvminithart>
    procinit();      // process table
    80000e72:	0d5000ef          	jal	ra,80001746 <procinit>
    trapinit();      // trap vectors
    80000e76:	734010ef          	jal	ra,800025aa <trapinit>
    trapinithart();  // install kernel trap vector
    80000e7a:	754010ef          	jal	ra,800025ce <trapinithart>
    plicinit();      // set up interrupt controller
    80000e7e:	780040ef          	jal	ra,800055fe <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e82:	792040ef          	jal	ra,80005614 <plicinithart>
    binit();         // buffer cache
    80000e86:	73d010ef          	jal	ra,80002dc2 <binit>
    iinit();         // inode table
    80000e8a:	4b0020ef          	jal	ra,8000333a <iinit>
    fileinit();      // file table
    80000e8e:	390030ef          	jal	ra,8000421e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000e92:	073040ef          	jal	ra,80005704 <virtio_disk_init>
    userinit();      // first user process
    80000e96:	4a3000ef          	jal	ra,80001b38 <userinit>
    __sync_synchronize();
    80000e9a:	0ff0000f          	fence
    started = 1;
    80000e9e:	4785                	li	a5,1
    80000ea0:	00007717          	auipc	a4,0x7
    80000ea4:	9af72823          	sw	a5,-1616(a4) # 80007850 <started>
    80000ea8:	b779                	j	80000e36 <main+0x3e>

0000000080000eaa <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000eaa:	1141                	addi	sp,sp,-16
    80000eac:	e422                	sd	s0,8(sp)
    80000eae:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000eb0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000eb4:	00007797          	auipc	a5,0x7
    80000eb8:	9a47b783          	ld	a5,-1628(a5) # 80007858 <kernel_pagetable>
    80000ebc:	83b1                	srli	a5,a5,0xc
    80000ebe:	577d                	li	a4,-1
    80000ec0:	177e                	slli	a4,a4,0x3f
    80000ec2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000ec4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ec8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000ecc:	6422                	ld	s0,8(sp)
    80000ece:	0141                	addi	sp,sp,16
    80000ed0:	8082                	ret

0000000080000ed2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000ed2:	7139                	addi	sp,sp,-64
    80000ed4:	fc06                	sd	ra,56(sp)
    80000ed6:	f822                	sd	s0,48(sp)
    80000ed8:	f426                	sd	s1,40(sp)
    80000eda:	f04a                	sd	s2,32(sp)
    80000edc:	ec4e                	sd	s3,24(sp)
    80000ede:	e852                	sd	s4,16(sp)
    80000ee0:	e456                	sd	s5,8(sp)
    80000ee2:	e05a                	sd	s6,0(sp)
    80000ee4:	0080                	addi	s0,sp,64
    80000ee6:	84aa                	mv	s1,a0
    80000ee8:	89ae                	mv	s3,a1
    80000eea:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000eec:	57fd                	li	a5,-1
    80000eee:	83e9                	srli	a5,a5,0x1a
    80000ef0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000ef2:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000ef4:	02b7fc63          	bgeu	a5,a1,80000f2c <walk+0x5a>
    panic("walk");
    80000ef8:	00006517          	auipc	a0,0x6
    80000efc:	1d050513          	addi	a0,a0,464 # 800070c8 <digits+0x90>
    80000f00:	891ff0ef          	jal	ra,80000790 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f04:	060a8263          	beqz	s5,80000f68 <walk+0x96>
    80000f08:	ba3ff0ef          	jal	ra,80000aaa <kalloc>
    80000f0c:	84aa                	mv	s1,a0
    80000f0e:	c139                	beqz	a0,80000f54 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f10:	6605                	lui	a2,0x1
    80000f12:	4581                	li	a1,0
    80000f14:	d3bff0ef          	jal	ra,80000c4e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f18:	00c4d793          	srli	a5,s1,0xc
    80000f1c:	07aa                	slli	a5,a5,0xa
    80000f1e:	0017e793          	ori	a5,a5,1
    80000f22:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f26:	3a5d                	addiw	s4,s4,-9
    80000f28:	036a0063          	beq	s4,s6,80000f48 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f2c:	0149d933          	srl	s2,s3,s4
    80000f30:	1ff97913          	andi	s2,s2,511
    80000f34:	090e                	slli	s2,s2,0x3
    80000f36:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f38:	00093483          	ld	s1,0(s2)
    80000f3c:	0014f793          	andi	a5,s1,1
    80000f40:	d3f1                	beqz	a5,80000f04 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f42:	80a9                	srli	s1,s1,0xa
    80000f44:	04b2                	slli	s1,s1,0xc
    80000f46:	b7c5                	j	80000f26 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f48:	00c9d513          	srli	a0,s3,0xc
    80000f4c:	1ff57513          	andi	a0,a0,511
    80000f50:	050e                	slli	a0,a0,0x3
    80000f52:	9526                	add	a0,a0,s1
}
    80000f54:	70e2                	ld	ra,56(sp)
    80000f56:	7442                	ld	s0,48(sp)
    80000f58:	74a2                	ld	s1,40(sp)
    80000f5a:	7902                	ld	s2,32(sp)
    80000f5c:	69e2                	ld	s3,24(sp)
    80000f5e:	6a42                	ld	s4,16(sp)
    80000f60:	6aa2                	ld	s5,8(sp)
    80000f62:	6b02                	ld	s6,0(sp)
    80000f64:	6121                	addi	sp,sp,64
    80000f66:	8082                	ret
        return 0;
    80000f68:	4501                	li	a0,0
    80000f6a:	b7ed                	j	80000f54 <walk+0x82>

0000000080000f6c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000f6c:	57fd                	li	a5,-1
    80000f6e:	83e9                	srli	a5,a5,0x1a
    80000f70:	00b7f463          	bgeu	a5,a1,80000f78 <walkaddr+0xc>
    return 0;
    80000f74:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000f76:	8082                	ret
{
    80000f78:	1141                	addi	sp,sp,-16
    80000f7a:	e406                	sd	ra,8(sp)
    80000f7c:	e022                	sd	s0,0(sp)
    80000f7e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f80:	4601                	li	a2,0
    80000f82:	f51ff0ef          	jal	ra,80000ed2 <walk>
  if(pte == 0)
    80000f86:	c105                	beqz	a0,80000fa6 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000f88:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000f8a:	0117f693          	andi	a3,a5,17
    80000f8e:	4745                	li	a4,17
    return 0;
    80000f90:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000f92:	00e68663          	beq	a3,a4,80000f9e <walkaddr+0x32>
}
    80000f96:	60a2                	ld	ra,8(sp)
    80000f98:	6402                	ld	s0,0(sp)
    80000f9a:	0141                	addi	sp,sp,16
    80000f9c:	8082                	ret
  pa = PTE2PA(*pte);
    80000f9e:	00a7d513          	srli	a0,a5,0xa
    80000fa2:	0532                	slli	a0,a0,0xc
  return pa;
    80000fa4:	bfcd                	j	80000f96 <walkaddr+0x2a>
    return 0;
    80000fa6:	4501                	li	a0,0
    80000fa8:	b7fd                	j	80000f96 <walkaddr+0x2a>

0000000080000faa <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000faa:	715d                	addi	sp,sp,-80
    80000fac:	e486                	sd	ra,72(sp)
    80000fae:	e0a2                	sd	s0,64(sp)
    80000fb0:	fc26                	sd	s1,56(sp)
    80000fb2:	f84a                	sd	s2,48(sp)
    80000fb4:	f44e                	sd	s3,40(sp)
    80000fb6:	f052                	sd	s4,32(sp)
    80000fb8:	ec56                	sd	s5,24(sp)
    80000fba:	e85a                	sd	s6,16(sp)
    80000fbc:	e45e                	sd	s7,8(sp)
    80000fbe:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000fc0:	03459793          	slli	a5,a1,0x34
    80000fc4:	e385                	bnez	a5,80000fe4 <mappages+0x3a>
    80000fc6:	8aaa                	mv	s5,a0
    80000fc8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000fca:	03461793          	slli	a5,a2,0x34
    80000fce:	e38d                	bnez	a5,80000ff0 <mappages+0x46>
    panic("mappages: size not aligned");

  if(size == 0)
    80000fd0:	c615                	beqz	a2,80000ffc <mappages+0x52>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000fd2:	79fd                	lui	s3,0xfffff
    80000fd4:	964e                	add	a2,a2,s3
    80000fd6:	00b609b3          	add	s3,a2,a1
  a = va;
    80000fda:	892e                	mv	s2,a1
    80000fdc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000fe0:	6b85                	lui	s7,0x1
    80000fe2:	a815                	j	80001016 <mappages+0x6c>
    panic("mappages: va not aligned");
    80000fe4:	00006517          	auipc	a0,0x6
    80000fe8:	0ec50513          	addi	a0,a0,236 # 800070d0 <digits+0x98>
    80000fec:	fa4ff0ef          	jal	ra,80000790 <panic>
    panic("mappages: size not aligned");
    80000ff0:	00006517          	auipc	a0,0x6
    80000ff4:	10050513          	addi	a0,a0,256 # 800070f0 <digits+0xb8>
    80000ff8:	f98ff0ef          	jal	ra,80000790 <panic>
    panic("mappages: size");
    80000ffc:	00006517          	auipc	a0,0x6
    80001000:	11450513          	addi	a0,a0,276 # 80007110 <digits+0xd8>
    80001004:	f8cff0ef          	jal	ra,80000790 <panic>
      panic("mappages: remap");
    80001008:	00006517          	auipc	a0,0x6
    8000100c:	11850513          	addi	a0,a0,280 # 80007120 <digits+0xe8>
    80001010:	f80ff0ef          	jal	ra,80000790 <panic>
    a += PGSIZE;
    80001014:	995e                	add	s2,s2,s7
  for(;;){
    80001016:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000101a:	4605                	li	a2,1
    8000101c:	85ca                	mv	a1,s2
    8000101e:	8556                	mv	a0,s5
    80001020:	eb3ff0ef          	jal	ra,80000ed2 <walk>
    80001024:	cd19                	beqz	a0,80001042 <mappages+0x98>
    if(*pte & PTE_V)
    80001026:	611c                	ld	a5,0(a0)
    80001028:	8b85                	andi	a5,a5,1
    8000102a:	fff9                	bnez	a5,80001008 <mappages+0x5e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000102c:	80b1                	srli	s1,s1,0xc
    8000102e:	04aa                	slli	s1,s1,0xa
    80001030:	0164e4b3          	or	s1,s1,s6
    80001034:	0014e493          	ori	s1,s1,1
    80001038:	e104                	sd	s1,0(a0)
    if(a == last)
    8000103a:	fd391de3          	bne	s2,s3,80001014 <mappages+0x6a>
    pa += PGSIZE;
  }
  return 0;
    8000103e:	4501                	li	a0,0
    80001040:	a011                	j	80001044 <mappages+0x9a>
      return -1;
    80001042:	557d                	li	a0,-1
}
    80001044:	60a6                	ld	ra,72(sp)
    80001046:	6406                	ld	s0,64(sp)
    80001048:	74e2                	ld	s1,56(sp)
    8000104a:	7942                	ld	s2,48(sp)
    8000104c:	79a2                	ld	s3,40(sp)
    8000104e:	7a02                	ld	s4,32(sp)
    80001050:	6ae2                	ld	s5,24(sp)
    80001052:	6b42                	ld	s6,16(sp)
    80001054:	6ba2                	ld	s7,8(sp)
    80001056:	6161                	addi	sp,sp,80
    80001058:	8082                	ret

000000008000105a <kvmmap>:
{
    8000105a:	1141                	addi	sp,sp,-16
    8000105c:	e406                	sd	ra,8(sp)
    8000105e:	e022                	sd	s0,0(sp)
    80001060:	0800                	addi	s0,sp,16
    80001062:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001064:	86b2                	mv	a3,a2
    80001066:	863e                	mv	a2,a5
    80001068:	f43ff0ef          	jal	ra,80000faa <mappages>
    8000106c:	e509                	bnez	a0,80001076 <kvmmap+0x1c>
}
    8000106e:	60a2                	ld	ra,8(sp)
    80001070:	6402                	ld	s0,0(sp)
    80001072:	0141                	addi	sp,sp,16
    80001074:	8082                	ret
    panic("kvmmap");
    80001076:	00006517          	auipc	a0,0x6
    8000107a:	0ba50513          	addi	a0,a0,186 # 80007130 <digits+0xf8>
    8000107e:	f12ff0ef          	jal	ra,80000790 <panic>

0000000080001082 <kvmmake>:
{
    80001082:	1101                	addi	sp,sp,-32
    80001084:	ec06                	sd	ra,24(sp)
    80001086:	e822                	sd	s0,16(sp)
    80001088:	e426                	sd	s1,8(sp)
    8000108a:	e04a                	sd	s2,0(sp)
    8000108c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000108e:	a1dff0ef          	jal	ra,80000aaa <kalloc>
    80001092:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001094:	6605                	lui	a2,0x1
    80001096:	4581                	li	a1,0
    80001098:	bb7ff0ef          	jal	ra,80000c4e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000109c:	4719                	li	a4,6
    8000109e:	6685                	lui	a3,0x1
    800010a0:	10000637          	lui	a2,0x10000
    800010a4:	100005b7          	lui	a1,0x10000
    800010a8:	8526                	mv	a0,s1
    800010aa:	fb1ff0ef          	jal	ra,8000105a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010ae:	4719                	li	a4,6
    800010b0:	6685                	lui	a3,0x1
    800010b2:	10001637          	lui	a2,0x10001
    800010b6:	100015b7          	lui	a1,0x10001
    800010ba:	8526                	mv	a0,s1
    800010bc:	f9fff0ef          	jal	ra,8000105a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800010c0:	4719                	li	a4,6
    800010c2:	040006b7          	lui	a3,0x4000
    800010c6:	0c000637          	lui	a2,0xc000
    800010ca:	0c0005b7          	lui	a1,0xc000
    800010ce:	8526                	mv	a0,s1
    800010d0:	f8bff0ef          	jal	ra,8000105a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800010d4:	00006917          	auipc	s2,0x6
    800010d8:	f2c90913          	addi	s2,s2,-212 # 80007000 <etext>
    800010dc:	4729                	li	a4,10
    800010de:	80006697          	auipc	a3,0x80006
    800010e2:	f2268693          	addi	a3,a3,-222 # 7000 <_entry-0x7fff9000>
    800010e6:	4605                	li	a2,1
    800010e8:	067e                	slli	a2,a2,0x1f
    800010ea:	85b2                	mv	a1,a2
    800010ec:	8526                	mv	a0,s1
    800010ee:	f6dff0ef          	jal	ra,8000105a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800010f2:	4719                	li	a4,6
    800010f4:	46c5                	li	a3,17
    800010f6:	06ee                	slli	a3,a3,0x1b
    800010f8:	412686b3          	sub	a3,a3,s2
    800010fc:	864a                	mv	a2,s2
    800010fe:	85ca                	mv	a1,s2
    80001100:	8526                	mv	a0,s1
    80001102:	f59ff0ef          	jal	ra,8000105a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001106:	4729                	li	a4,10
    80001108:	6685                	lui	a3,0x1
    8000110a:	00005617          	auipc	a2,0x5
    8000110e:	ef660613          	addi	a2,a2,-266 # 80006000 <_trampoline>
    80001112:	040005b7          	lui	a1,0x4000
    80001116:	15fd                	addi	a1,a1,-1
    80001118:	05b2                	slli	a1,a1,0xc
    8000111a:	8526                	mv	a0,s1
    8000111c:	f3fff0ef          	jal	ra,8000105a <kvmmap>
  proc_mapstacks(kpgtbl);
    80001120:	8526                	mv	a0,s1
    80001122:	59a000ef          	jal	ra,800016bc <proc_mapstacks>
}
    80001126:	8526                	mv	a0,s1
    80001128:	60e2                	ld	ra,24(sp)
    8000112a:	6442                	ld	s0,16(sp)
    8000112c:	64a2                	ld	s1,8(sp)
    8000112e:	6902                	ld	s2,0(sp)
    80001130:	6105                	addi	sp,sp,32
    80001132:	8082                	ret

0000000080001134 <kvminit>:
{
    80001134:	1141                	addi	sp,sp,-16
    80001136:	e406                	sd	ra,8(sp)
    80001138:	e022                	sd	s0,0(sp)
    8000113a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000113c:	f47ff0ef          	jal	ra,80001082 <kvmmake>
    80001140:	00006797          	auipc	a5,0x6
    80001144:	70a7bc23          	sd	a0,1816(a5) # 80007858 <kernel_pagetable>
}
    80001148:	60a2                	ld	ra,8(sp)
    8000114a:	6402                	ld	s0,0(sp)
    8000114c:	0141                	addi	sp,sp,16
    8000114e:	8082                	ret

0000000080001150 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001150:	1101                	addi	sp,sp,-32
    80001152:	ec06                	sd	ra,24(sp)
    80001154:	e822                	sd	s0,16(sp)
    80001156:	e426                	sd	s1,8(sp)
    80001158:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000115a:	951ff0ef          	jal	ra,80000aaa <kalloc>
    8000115e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001160:	c509                	beqz	a0,8000116a <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001162:	6605                	lui	a2,0x1
    80001164:	4581                	li	a1,0
    80001166:	ae9ff0ef          	jal	ra,80000c4e <memset>
  return pagetable;
}
    8000116a:	8526                	mv	a0,s1
    8000116c:	60e2                	ld	ra,24(sp)
    8000116e:	6442                	ld	s0,16(sp)
    80001170:	64a2                	ld	s1,8(sp)
    80001172:	6105                	addi	sp,sp,32
    80001174:	8082                	ret

0000000080001176 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001176:	7139                	addi	sp,sp,-64
    80001178:	fc06                	sd	ra,56(sp)
    8000117a:	f822                	sd	s0,48(sp)
    8000117c:	f426                	sd	s1,40(sp)
    8000117e:	f04a                	sd	s2,32(sp)
    80001180:	ec4e                	sd	s3,24(sp)
    80001182:	e852                	sd	s4,16(sp)
    80001184:	e456                	sd	s5,8(sp)
    80001186:	e05a                	sd	s6,0(sp)
    80001188:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000118a:	03459793          	slli	a5,a1,0x34
    8000118e:	e785                	bnez	a5,800011b6 <uvmunmap+0x40>
    80001190:	8a2a                	mv	s4,a0
    80001192:	892e                	mv	s2,a1
    80001194:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001196:	0632                	slli	a2,a2,0xc
    80001198:	00b609b3          	add	s3,a2,a1
    8000119c:	6b05                	lui	s6,0x1
    8000119e:	0335ec63          	bltu	a1,s3,800011d6 <uvmunmap+0x60>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800011a2:	70e2                	ld	ra,56(sp)
    800011a4:	7442                	ld	s0,48(sp)
    800011a6:	74a2                	ld	s1,40(sp)
    800011a8:	7902                	ld	s2,32(sp)
    800011aa:	69e2                	ld	s3,24(sp)
    800011ac:	6a42                	ld	s4,16(sp)
    800011ae:	6aa2                	ld	s5,8(sp)
    800011b0:	6b02                	ld	s6,0(sp)
    800011b2:	6121                	addi	sp,sp,64
    800011b4:	8082                	ret
    panic("uvmunmap: not aligned");
    800011b6:	00006517          	auipc	a0,0x6
    800011ba:	f8250513          	addi	a0,a0,-126 # 80007138 <digits+0x100>
    800011be:	dd2ff0ef          	jal	ra,80000790 <panic>
      uint64 pa = PTE2PA(*pte);
    800011c2:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800011c4:	00c79513          	slli	a0,a5,0xc
    800011c8:	803ff0ef          	jal	ra,800009ca <kfree>
    *pte = 0;
    800011cc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011d0:	995a                	add	s2,s2,s6
    800011d2:	fd3978e3          	bgeu	s2,s3,800011a2 <uvmunmap+0x2c>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800011d6:	4601                	li	a2,0
    800011d8:	85ca                	mv	a1,s2
    800011da:	8552                	mv	a0,s4
    800011dc:	cf7ff0ef          	jal	ra,80000ed2 <walk>
    800011e0:	84aa                	mv	s1,a0
    800011e2:	d57d                	beqz	a0,800011d0 <uvmunmap+0x5a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800011e4:	611c                	ld	a5,0(a0)
    800011e6:	0017f713          	andi	a4,a5,1
    800011ea:	d37d                	beqz	a4,800011d0 <uvmunmap+0x5a>
    if(do_free){
    800011ec:	fe0a80e3          	beqz	s5,800011cc <uvmunmap+0x56>
    800011f0:	bfc9                	j	800011c2 <uvmunmap+0x4c>

00000000800011f2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800011f2:	1101                	addi	sp,sp,-32
    800011f4:	ec06                	sd	ra,24(sp)
    800011f6:	e822                	sd	s0,16(sp)
    800011f8:	e426                	sd	s1,8(sp)
    800011fa:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800011fc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800011fe:	00b67d63          	bgeu	a2,a1,80001218 <uvmdealloc+0x26>
    80001202:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001204:	6785                	lui	a5,0x1
    80001206:	17fd                	addi	a5,a5,-1
    80001208:	00f60733          	add	a4,a2,a5
    8000120c:	767d                	lui	a2,0xfffff
    8000120e:	8f71                	and	a4,a4,a2
    80001210:	97ae                	add	a5,a5,a1
    80001212:	8ff1                	and	a5,a5,a2
    80001214:	00f76863          	bltu	a4,a5,80001224 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001218:	8526                	mv	a0,s1
    8000121a:	60e2                	ld	ra,24(sp)
    8000121c:	6442                	ld	s0,16(sp)
    8000121e:	64a2                	ld	s1,8(sp)
    80001220:	6105                	addi	sp,sp,32
    80001222:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001224:	8f99                	sub	a5,a5,a4
    80001226:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001228:	4685                	li	a3,1
    8000122a:	0007861b          	sext.w	a2,a5
    8000122e:	85ba                	mv	a1,a4
    80001230:	f47ff0ef          	jal	ra,80001176 <uvmunmap>
    80001234:	b7d5                	j	80001218 <uvmdealloc+0x26>

0000000080001236 <uvmalloc>:
  if(newsz < oldsz)
    80001236:	08b66963          	bltu	a2,a1,800012c8 <uvmalloc+0x92>
{
    8000123a:	7139                	addi	sp,sp,-64
    8000123c:	fc06                	sd	ra,56(sp)
    8000123e:	f822                	sd	s0,48(sp)
    80001240:	f426                	sd	s1,40(sp)
    80001242:	f04a                	sd	s2,32(sp)
    80001244:	ec4e                	sd	s3,24(sp)
    80001246:	e852                	sd	s4,16(sp)
    80001248:	e456                	sd	s5,8(sp)
    8000124a:	e05a                	sd	s6,0(sp)
    8000124c:	0080                	addi	s0,sp,64
    8000124e:	8aaa                	mv	s5,a0
    80001250:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001252:	6985                	lui	s3,0x1
    80001254:	19fd                	addi	s3,s3,-1
    80001256:	95ce                	add	a1,a1,s3
    80001258:	79fd                	lui	s3,0xfffff
    8000125a:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000125e:	06c9f763          	bgeu	s3,a2,800012cc <uvmalloc+0x96>
    80001262:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001264:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001268:	843ff0ef          	jal	ra,80000aaa <kalloc>
    8000126c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000126e:	c11d                	beqz	a0,80001294 <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    80001270:	6605                	lui	a2,0x1
    80001272:	4581                	li	a1,0
    80001274:	9dbff0ef          	jal	ra,80000c4e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001278:	875a                	mv	a4,s6
    8000127a:	86a6                	mv	a3,s1
    8000127c:	6605                	lui	a2,0x1
    8000127e:	85ca                	mv	a1,s2
    80001280:	8556                	mv	a0,s5
    80001282:	d29ff0ef          	jal	ra,80000faa <mappages>
    80001286:	e51d                	bnez	a0,800012b4 <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001288:	6785                	lui	a5,0x1
    8000128a:	993e                	add	s2,s2,a5
    8000128c:	fd496ee3          	bltu	s2,s4,80001268 <uvmalloc+0x32>
  return newsz;
    80001290:	8552                	mv	a0,s4
    80001292:	a039                	j	800012a0 <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    80001294:	864e                	mv	a2,s3
    80001296:	85ca                	mv	a1,s2
    80001298:	8556                	mv	a0,s5
    8000129a:	f59ff0ef          	jal	ra,800011f2 <uvmdealloc>
      return 0;
    8000129e:	4501                	li	a0,0
}
    800012a0:	70e2                	ld	ra,56(sp)
    800012a2:	7442                	ld	s0,48(sp)
    800012a4:	74a2                	ld	s1,40(sp)
    800012a6:	7902                	ld	s2,32(sp)
    800012a8:	69e2                	ld	s3,24(sp)
    800012aa:	6a42                	ld	s4,16(sp)
    800012ac:	6aa2                	ld	s5,8(sp)
    800012ae:	6b02                	ld	s6,0(sp)
    800012b0:	6121                	addi	sp,sp,64
    800012b2:	8082                	ret
      kfree(mem);
    800012b4:	8526                	mv	a0,s1
    800012b6:	f14ff0ef          	jal	ra,800009ca <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800012ba:	864e                	mv	a2,s3
    800012bc:	85ca                	mv	a1,s2
    800012be:	8556                	mv	a0,s5
    800012c0:	f33ff0ef          	jal	ra,800011f2 <uvmdealloc>
      return 0;
    800012c4:	4501                	li	a0,0
    800012c6:	bfe9                	j	800012a0 <uvmalloc+0x6a>
    return oldsz;
    800012c8:	852e                	mv	a0,a1
}
    800012ca:	8082                	ret
  return newsz;
    800012cc:	8532                	mv	a0,a2
    800012ce:	bfc9                	j	800012a0 <uvmalloc+0x6a>

00000000800012d0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800012d0:	7179                	addi	sp,sp,-48
    800012d2:	f406                	sd	ra,40(sp)
    800012d4:	f022                	sd	s0,32(sp)
    800012d6:	ec26                	sd	s1,24(sp)
    800012d8:	e84a                	sd	s2,16(sp)
    800012da:	e44e                	sd	s3,8(sp)
    800012dc:	e052                	sd	s4,0(sp)
    800012de:	1800                	addi	s0,sp,48
    800012e0:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800012e2:	84aa                	mv	s1,a0
    800012e4:	6905                	lui	s2,0x1
    800012e6:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800012e8:	4985                	li	s3,1
    800012ea:	a811                	j	800012fe <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800012ec:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800012ee:	0532                	slli	a0,a0,0xc
    800012f0:	fe1ff0ef          	jal	ra,800012d0 <freewalk>
      pagetable[i] = 0;
    800012f4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800012f8:	04a1                	addi	s1,s1,8
    800012fa:	01248f63          	beq	s1,s2,80001318 <freewalk+0x48>
    pte_t pte = pagetable[i];
    800012fe:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001300:	00f57793          	andi	a5,a0,15
    80001304:	ff3784e3          	beq	a5,s3,800012ec <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001308:	8905                	andi	a0,a0,1
    8000130a:	d57d                	beqz	a0,800012f8 <freewalk+0x28>
      panic("freewalk: leaf");
    8000130c:	00006517          	auipc	a0,0x6
    80001310:	e4450513          	addi	a0,a0,-444 # 80007150 <digits+0x118>
    80001314:	c7cff0ef          	jal	ra,80000790 <panic>
    }
  }
  kfree((void*)pagetable);
    80001318:	8552                	mv	a0,s4
    8000131a:	eb0ff0ef          	jal	ra,800009ca <kfree>
}
    8000131e:	70a2                	ld	ra,40(sp)
    80001320:	7402                	ld	s0,32(sp)
    80001322:	64e2                	ld	s1,24(sp)
    80001324:	6942                	ld	s2,16(sp)
    80001326:	69a2                	ld	s3,8(sp)
    80001328:	6a02                	ld	s4,0(sp)
    8000132a:	6145                	addi	sp,sp,48
    8000132c:	8082                	ret

000000008000132e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000132e:	1101                	addi	sp,sp,-32
    80001330:	ec06                	sd	ra,24(sp)
    80001332:	e822                	sd	s0,16(sp)
    80001334:	e426                	sd	s1,8(sp)
    80001336:	1000                	addi	s0,sp,32
    80001338:	84aa                	mv	s1,a0
  if(sz > 0)
    8000133a:	e989                	bnez	a1,8000134c <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000133c:	8526                	mv	a0,s1
    8000133e:	f93ff0ef          	jal	ra,800012d0 <freewalk>
}
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000134c:	6605                	lui	a2,0x1
    8000134e:	167d                	addi	a2,a2,-1
    80001350:	962e                	add	a2,a2,a1
    80001352:	4685                	li	a3,1
    80001354:	8231                	srli	a2,a2,0xc
    80001356:	4581                	li	a1,0
    80001358:	e1fff0ef          	jal	ra,80001176 <uvmunmap>
    8000135c:	b7c5                	j	8000133c <uvmfree+0xe>

000000008000135e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000135e:	ce49                	beqz	a2,800013f8 <uvmcopy+0x9a>
{
    80001360:	715d                	addi	sp,sp,-80
    80001362:	e486                	sd	ra,72(sp)
    80001364:	e0a2                	sd	s0,64(sp)
    80001366:	fc26                	sd	s1,56(sp)
    80001368:	f84a                	sd	s2,48(sp)
    8000136a:	f44e                	sd	s3,40(sp)
    8000136c:	f052                	sd	s4,32(sp)
    8000136e:	ec56                	sd	s5,24(sp)
    80001370:	e85a                	sd	s6,16(sp)
    80001372:	e45e                	sd	s7,8(sp)
    80001374:	0880                	addi	s0,sp,80
    80001376:	8aaa                	mv	s5,a0
    80001378:	8b2e                	mv	s6,a1
    8000137a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000137c:	4481                	li	s1,0
    8000137e:	a029                	j	80001388 <uvmcopy+0x2a>
    80001380:	6785                	lui	a5,0x1
    80001382:	94be                	add	s1,s1,a5
    80001384:	0544fe63          	bgeu	s1,s4,800013e0 <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    80001388:	4601                	li	a2,0
    8000138a:	85a6                	mv	a1,s1
    8000138c:	8556                	mv	a0,s5
    8000138e:	b45ff0ef          	jal	ra,80000ed2 <walk>
    80001392:	d57d                	beqz	a0,80001380 <uvmcopy+0x22>
      continue;   // page table entry hasn't been allocated
    if((*pte & PTE_V) == 0)
    80001394:	6118                	ld	a4,0(a0)
    80001396:	00177793          	andi	a5,a4,1
    8000139a:	d3fd                	beqz	a5,80001380 <uvmcopy+0x22>
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    8000139c:	00a75593          	srli	a1,a4,0xa
    800013a0:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800013a4:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    800013a8:	f02ff0ef          	jal	ra,80000aaa <kalloc>
    800013ac:	89aa                	mv	s3,a0
    800013ae:	c105                	beqz	a0,800013ce <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800013b0:	6605                	lui	a2,0x1
    800013b2:	85de                	mv	a1,s7
    800013b4:	8fbff0ef          	jal	ra,80000cae <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800013b8:	874a                	mv	a4,s2
    800013ba:	86ce                	mv	a3,s3
    800013bc:	6605                	lui	a2,0x1
    800013be:	85a6                	mv	a1,s1
    800013c0:	855a                	mv	a0,s6
    800013c2:	be9ff0ef          	jal	ra,80000faa <mappages>
    800013c6:	dd4d                	beqz	a0,80001380 <uvmcopy+0x22>
      kfree(mem);
    800013c8:	854e                	mv	a0,s3
    800013ca:	e00ff0ef          	jal	ra,800009ca <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800013ce:	4685                	li	a3,1
    800013d0:	00c4d613          	srli	a2,s1,0xc
    800013d4:	4581                	li	a1,0
    800013d6:	855a                	mv	a0,s6
    800013d8:	d9fff0ef          	jal	ra,80001176 <uvmunmap>
  return -1;
    800013dc:	557d                	li	a0,-1
    800013de:	a011                	j	800013e2 <uvmcopy+0x84>
  return 0;
    800013e0:	4501                	li	a0,0
}
    800013e2:	60a6                	ld	ra,72(sp)
    800013e4:	6406                	ld	s0,64(sp)
    800013e6:	74e2                	ld	s1,56(sp)
    800013e8:	7942                	ld	s2,48(sp)
    800013ea:	79a2                	ld	s3,40(sp)
    800013ec:	7a02                	ld	s4,32(sp)
    800013ee:	6ae2                	ld	s5,24(sp)
    800013f0:	6b42                	ld	s6,16(sp)
    800013f2:	6ba2                	ld	s7,8(sp)
    800013f4:	6161                	addi	sp,sp,80
    800013f6:	8082                	ret
  return 0;
    800013f8:	4501                	li	a0,0
}
    800013fa:	8082                	ret

00000000800013fc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800013fc:	1141                	addi	sp,sp,-16
    800013fe:	e406                	sd	ra,8(sp)
    80001400:	e022                	sd	s0,0(sp)
    80001402:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001404:	4601                	li	a2,0
    80001406:	acdff0ef          	jal	ra,80000ed2 <walk>
  if(pte == 0)
    8000140a:	c901                	beqz	a0,8000141a <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000140c:	611c                	ld	a5,0(a0)
    8000140e:	9bbd                	andi	a5,a5,-17
    80001410:	e11c                	sd	a5,0(a0)
}
    80001412:	60a2                	ld	ra,8(sp)
    80001414:	6402                	ld	s0,0(sp)
    80001416:	0141                	addi	sp,sp,16
    80001418:	8082                	ret
    panic("uvmclear");
    8000141a:	00006517          	auipc	a0,0x6
    8000141e:	d4650513          	addi	a0,a0,-698 # 80007160 <digits+0x128>
    80001422:	b6eff0ef          	jal	ra,80000790 <panic>

0000000080001426 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001426:	c2d5                	beqz	a3,800014ca <copyinstr+0xa4>
{
    80001428:	715d                	addi	sp,sp,-80
    8000142a:	e486                	sd	ra,72(sp)
    8000142c:	e0a2                	sd	s0,64(sp)
    8000142e:	fc26                	sd	s1,56(sp)
    80001430:	f84a                	sd	s2,48(sp)
    80001432:	f44e                	sd	s3,40(sp)
    80001434:	f052                	sd	s4,32(sp)
    80001436:	ec56                	sd	s5,24(sp)
    80001438:	e85a                	sd	s6,16(sp)
    8000143a:	e45e                	sd	s7,8(sp)
    8000143c:	0880                	addi	s0,sp,80
    8000143e:	8a2a                	mv	s4,a0
    80001440:	8b2e                	mv	s6,a1
    80001442:	8bb2                	mv	s7,a2
    80001444:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001446:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001448:	6985                	lui	s3,0x1
    8000144a:	a035                	j	80001476 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000144c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001450:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001452:	0017b793          	seqz	a5,a5
    80001456:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000145a:	60a6                	ld	ra,72(sp)
    8000145c:	6406                	ld	s0,64(sp)
    8000145e:	74e2                	ld	s1,56(sp)
    80001460:	7942                	ld	s2,48(sp)
    80001462:	79a2                	ld	s3,40(sp)
    80001464:	7a02                	ld	s4,32(sp)
    80001466:	6ae2                	ld	s5,24(sp)
    80001468:	6b42                	ld	s6,16(sp)
    8000146a:	6ba2                	ld	s7,8(sp)
    8000146c:	6161                	addi	sp,sp,80
    8000146e:	8082                	ret
    srcva = va0 + PGSIZE;
    80001470:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001474:	c4b9                	beqz	s1,800014c2 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80001476:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000147a:	85ca                	mv	a1,s2
    8000147c:	8552                	mv	a0,s4
    8000147e:	aefff0ef          	jal	ra,80000f6c <walkaddr>
    if(pa0 == 0)
    80001482:	c131                	beqz	a0,800014c6 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80001484:	41790833          	sub	a6,s2,s7
    80001488:	984e                	add	a6,a6,s3
    if(n > max)
    8000148a:	0104f363          	bgeu	s1,a6,80001490 <copyinstr+0x6a>
    8000148e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001490:	955e                	add	a0,a0,s7
    80001492:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001496:	fc080de3          	beqz	a6,80001470 <copyinstr+0x4a>
    8000149a:	985a                	add	a6,a6,s6
    8000149c:	87da                	mv	a5,s6
      if(*p == '\0'){
    8000149e:	41650633          	sub	a2,a0,s6
    800014a2:	14fd                	addi	s1,s1,-1
    800014a4:	9b26                	add	s6,s6,s1
    800014a6:	00f60733          	add	a4,a2,a5
    800014aa:	00074703          	lbu	a4,0(a4)
    800014ae:	df59                	beqz	a4,8000144c <copyinstr+0x26>
        *dst = *p;
    800014b0:	00e78023          	sb	a4,0(a5)
      --max;
    800014b4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800014b8:	0785                	addi	a5,a5,1
    while(n > 0){
    800014ba:	ff0796e3          	bne	a5,a6,800014a6 <copyinstr+0x80>
      dst++;
    800014be:	8b42                	mv	s6,a6
    800014c0:	bf45                	j	80001470 <copyinstr+0x4a>
    800014c2:	4781                	li	a5,0
    800014c4:	b779                	j	80001452 <copyinstr+0x2c>
      return -1;
    800014c6:	557d                	li	a0,-1
    800014c8:	bf49                	j	8000145a <copyinstr+0x34>
  int got_null = 0;
    800014ca:	4781                	li	a5,0
  if(got_null){
    800014cc:	0017b793          	seqz	a5,a5
    800014d0:	40f00533          	neg	a0,a5
}
    800014d4:	8082                	ret

00000000800014d6 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800014d6:	1141                	addi	sp,sp,-16
    800014d8:	e406                	sd	ra,8(sp)
    800014da:	e022                	sd	s0,0(sp)
    800014dc:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014de:	4601                	li	a2,0
    800014e0:	9f3ff0ef          	jal	ra,80000ed2 <walk>
  if (pte == 0) {
    800014e4:	c519                	beqz	a0,800014f2 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    800014e6:	6108                	ld	a0,0(a0)
    return 0;
    800014e8:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800014ea:	60a2                	ld	ra,8(sp)
    800014ec:	6402                	ld	s0,0(sp)
    800014ee:	0141                	addi	sp,sp,16
    800014f0:	8082                	ret
    return 0;
    800014f2:	4501                	li	a0,0
    800014f4:	bfdd                	j	800014ea <ismapped+0x14>

00000000800014f6 <vmfault>:
{
    800014f6:	7179                	addi	sp,sp,-48
    800014f8:	f406                	sd	ra,40(sp)
    800014fa:	f022                	sd	s0,32(sp)
    800014fc:	ec26                	sd	s1,24(sp)
    800014fe:	e84a                	sd	s2,16(sp)
    80001500:	e44e                	sd	s3,8(sp)
    80001502:	e052                	sd	s4,0(sp)
    80001504:	1800                	addi	s0,sp,48
    80001506:	89aa                	mv	s3,a0
    80001508:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    8000150a:	336000ef          	jal	ra,80001840 <myproc>
  if (va >= p->sz)
    8000150e:	653c                	ld	a5,72(a0)
    80001510:	00f4ec63          	bltu	s1,a5,80001528 <vmfault+0x32>
    return 0;
    80001514:	4981                	li	s3,0
}
    80001516:	854e                	mv	a0,s3
    80001518:	70a2                	ld	ra,40(sp)
    8000151a:	7402                	ld	s0,32(sp)
    8000151c:	64e2                	ld	s1,24(sp)
    8000151e:	6942                	ld	s2,16(sp)
    80001520:	69a2                	ld	s3,8(sp)
    80001522:	6a02                	ld	s4,0(sp)
    80001524:	6145                	addi	sp,sp,48
    80001526:	8082                	ret
    80001528:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    8000152a:	75fd                	lui	a1,0xfffff
    8000152c:	8ced                	and	s1,s1,a1
  if(ismapped(pagetable, va)) {
    8000152e:	85a6                	mv	a1,s1
    80001530:	854e                	mv	a0,s3
    80001532:	fa5ff0ef          	jal	ra,800014d6 <ismapped>
    return 0;
    80001536:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80001538:	fd79                	bnez	a0,80001516 <vmfault+0x20>
  mem = (uint64) kalloc();
    8000153a:	d70ff0ef          	jal	ra,80000aaa <kalloc>
    8000153e:	8a2a                	mv	s4,a0
  if(mem == 0)
    80001540:	d979                	beqz	a0,80001516 <vmfault+0x20>
  mem = (uint64) kalloc();
    80001542:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80001544:	6605                	lui	a2,0x1
    80001546:	4581                	li	a1,0
    80001548:	f06ff0ef          	jal	ra,80000c4e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    8000154c:	4759                	li	a4,22
    8000154e:	86d2                	mv	a3,s4
    80001550:	6605                	lui	a2,0x1
    80001552:	85a6                	mv	a1,s1
    80001554:	05093503          	ld	a0,80(s2) # 1050 <_entry-0x7fffefb0>
    80001558:	a53ff0ef          	jal	ra,80000faa <mappages>
    8000155c:	dd4d                	beqz	a0,80001516 <vmfault+0x20>
    kfree((void *)mem);
    8000155e:	8552                	mv	a0,s4
    80001560:	c6aff0ef          	jal	ra,800009ca <kfree>
    return 0;
    80001564:	4981                	li	s3,0
    80001566:	bf45                	j	80001516 <vmfault+0x20>

0000000080001568 <copyout>:
  while(len > 0){
    80001568:	cec1                	beqz	a3,80001600 <copyout+0x98>
{
    8000156a:	711d                	addi	sp,sp,-96
    8000156c:	ec86                	sd	ra,88(sp)
    8000156e:	e8a2                	sd	s0,80(sp)
    80001570:	e4a6                	sd	s1,72(sp)
    80001572:	e0ca                	sd	s2,64(sp)
    80001574:	fc4e                	sd	s3,56(sp)
    80001576:	f852                	sd	s4,48(sp)
    80001578:	f456                	sd	s5,40(sp)
    8000157a:	f05a                	sd	s6,32(sp)
    8000157c:	ec5e                	sd	s7,24(sp)
    8000157e:	e862                	sd	s8,16(sp)
    80001580:	e466                	sd	s9,8(sp)
    80001582:	e06a                	sd	s10,0(sp)
    80001584:	1080                	addi	s0,sp,96
    80001586:	8c2a                	mv	s8,a0
    80001588:	8b2e                	mv	s6,a1
    8000158a:	8bb2                	mv	s7,a2
    8000158c:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    8000158e:	74fd                	lui	s1,0xfffff
    80001590:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001592:	57fd                	li	a5,-1
    80001594:	83e9                	srli	a5,a5,0x1a
    80001596:	0697e763          	bltu	a5,s1,80001604 <copyout+0x9c>
    8000159a:	6d05                	lui	s10,0x1
    8000159c:	8cbe                	mv	s9,a5
    8000159e:	a015                	j	800015c2 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015a0:	409b0533          	sub	a0,s6,s1
    800015a4:	0009861b          	sext.w	a2,s3
    800015a8:	85de                	mv	a1,s7
    800015aa:	954a                	add	a0,a0,s2
    800015ac:	f02ff0ef          	jal	ra,80000cae <memmove>
    len -= n;
    800015b0:	413a0a33          	sub	s4,s4,s3
    src += n;
    800015b4:	9bce                	add	s7,s7,s3
  while(len > 0){
    800015b6:	040a0363          	beqz	s4,800015fc <copyout+0x94>
    if(va0 >= MAXVA)
    800015ba:	055ce763          	bltu	s9,s5,80001608 <copyout+0xa0>
    va0 = PGROUNDDOWN(dstva);
    800015be:	84d6                	mv	s1,s5
    dstva = va0 + PGSIZE;
    800015c0:	8b56                	mv	s6,s5
    pa0 = walkaddr(pagetable, va0);
    800015c2:	85a6                	mv	a1,s1
    800015c4:	8562                	mv	a0,s8
    800015c6:	9a7ff0ef          	jal	ra,80000f6c <walkaddr>
    800015ca:	892a                	mv	s2,a0
    if(pa0 == 0) {
    800015cc:	e901                	bnez	a0,800015dc <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    800015ce:	4601                	li	a2,0
    800015d0:	85a6                	mv	a1,s1
    800015d2:	8562                	mv	a0,s8
    800015d4:	f23ff0ef          	jal	ra,800014f6 <vmfault>
    800015d8:	892a                	mv	s2,a0
    800015da:	c90d                	beqz	a0,8000160c <copyout+0xa4>
    pte = walk(pagetable, va0, 0);
    800015dc:	4601                	li	a2,0
    800015de:	85a6                	mv	a1,s1
    800015e0:	8562                	mv	a0,s8
    800015e2:	8f1ff0ef          	jal	ra,80000ed2 <walk>
    if((*pte & PTE_W) == 0)
    800015e6:	611c                	ld	a5,0(a0)
    800015e8:	8b91                	andi	a5,a5,4
    800015ea:	c39d                	beqz	a5,80001610 <copyout+0xa8>
    n = PGSIZE - (dstva - va0);
    800015ec:	01a48ab3          	add	s5,s1,s10
    800015f0:	416a89b3          	sub	s3,s5,s6
    if(n > len)
    800015f4:	fb3a76e3          	bgeu	s4,s3,800015a0 <copyout+0x38>
    800015f8:	89d2                	mv	s3,s4
    800015fa:	b75d                	j	800015a0 <copyout+0x38>
  return 0;
    800015fc:	4501                	li	a0,0
    800015fe:	a811                	j	80001612 <copyout+0xaa>
    80001600:	4501                	li	a0,0
}
    80001602:	8082                	ret
      return -1;
    80001604:	557d                	li	a0,-1
    80001606:	a031                	j	80001612 <copyout+0xaa>
    80001608:	557d                	li	a0,-1
    8000160a:	a021                	j	80001612 <copyout+0xaa>
        return -1;
    8000160c:	557d                	li	a0,-1
    8000160e:	a011                	j	80001612 <copyout+0xaa>
      return -1;
    80001610:	557d                	li	a0,-1
}
    80001612:	60e6                	ld	ra,88(sp)
    80001614:	6446                	ld	s0,80(sp)
    80001616:	64a6                	ld	s1,72(sp)
    80001618:	6906                	ld	s2,64(sp)
    8000161a:	79e2                	ld	s3,56(sp)
    8000161c:	7a42                	ld	s4,48(sp)
    8000161e:	7aa2                	ld	s5,40(sp)
    80001620:	7b02                	ld	s6,32(sp)
    80001622:	6be2                	ld	s7,24(sp)
    80001624:	6c42                	ld	s8,16(sp)
    80001626:	6ca2                	ld	s9,8(sp)
    80001628:	6d02                	ld	s10,0(sp)
    8000162a:	6125                	addi	sp,sp,96
    8000162c:	8082                	ret

000000008000162e <copyin>:
  while(len > 0){
    8000162e:	c6c9                	beqz	a3,800016b8 <copyin+0x8a>
{
    80001630:	715d                	addi	sp,sp,-80
    80001632:	e486                	sd	ra,72(sp)
    80001634:	e0a2                	sd	s0,64(sp)
    80001636:	fc26                	sd	s1,56(sp)
    80001638:	f84a                	sd	s2,48(sp)
    8000163a:	f44e                	sd	s3,40(sp)
    8000163c:	f052                	sd	s4,32(sp)
    8000163e:	ec56                	sd	s5,24(sp)
    80001640:	e85a                	sd	s6,16(sp)
    80001642:	e45e                	sd	s7,8(sp)
    80001644:	e062                	sd	s8,0(sp)
    80001646:	0880                	addi	s0,sp,80
    80001648:	8baa                	mv	s7,a0
    8000164a:	8aae                	mv	s5,a1
    8000164c:	8932                	mv	s2,a2
    8000164e:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001650:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80001652:	6b05                	lui	s6,0x1
    80001654:	a035                	j	80001680 <copyin+0x52>
    80001656:	412984b3          	sub	s1,s3,s2
    8000165a:	94da                	add	s1,s1,s6
    if(n > len)
    8000165c:	009a7363          	bgeu	s4,s1,80001662 <copyin+0x34>
    80001660:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001662:	413905b3          	sub	a1,s2,s3
    80001666:	0004861b          	sext.w	a2,s1
    8000166a:	95aa                	add	a1,a1,a0
    8000166c:	8556                	mv	a0,s5
    8000166e:	e40ff0ef          	jal	ra,80000cae <memmove>
    len -= n;
    80001672:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80001676:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001678:	01698933          	add	s2,s3,s6
  while(len > 0){
    8000167c:	020a0163          	beqz	s4,8000169e <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001680:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001684:	85ce                	mv	a1,s3
    80001686:	855e                	mv	a0,s7
    80001688:	8e5ff0ef          	jal	ra,80000f6c <walkaddr>
    if(pa0 == 0) {
    8000168c:	f569                	bnez	a0,80001656 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    8000168e:	4601                	li	a2,0
    80001690:	85ce                	mv	a1,s3
    80001692:	855e                	mv	a0,s7
    80001694:	e63ff0ef          	jal	ra,800014f6 <vmfault>
    80001698:	fd5d                	bnez	a0,80001656 <copyin+0x28>
        return -1;
    8000169a:	557d                	li	a0,-1
    8000169c:	a011                	j	800016a0 <copyin+0x72>
  return 0;
    8000169e:	4501                	li	a0,0
}
    800016a0:	60a6                	ld	ra,72(sp)
    800016a2:	6406                	ld	s0,64(sp)
    800016a4:	74e2                	ld	s1,56(sp)
    800016a6:	7942                	ld	s2,48(sp)
    800016a8:	79a2                	ld	s3,40(sp)
    800016aa:	7a02                	ld	s4,32(sp)
    800016ac:	6ae2                	ld	s5,24(sp)
    800016ae:	6b42                	ld	s6,16(sp)
    800016b0:	6ba2                	ld	s7,8(sp)
    800016b2:	6c02                	ld	s8,0(sp)
    800016b4:	6161                	addi	sp,sp,80
    800016b6:	8082                	ret
  return 0;
    800016b8:	4501                	li	a0,0
}
    800016ba:	8082                	ret

00000000800016bc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800016bc:	7139                	addi	sp,sp,-64
    800016be:	fc06                	sd	ra,56(sp)
    800016c0:	f822                	sd	s0,48(sp)
    800016c2:	f426                	sd	s1,40(sp)
    800016c4:	f04a                	sd	s2,32(sp)
    800016c6:	ec4e                	sd	s3,24(sp)
    800016c8:	e852                	sd	s4,16(sp)
    800016ca:	e456                	sd	s5,8(sp)
    800016cc:	e05a                	sd	s6,0(sp)
    800016ce:	0080                	addi	s0,sp,64
    800016d0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d2:	0000e497          	auipc	s1,0xe
    800016d6:	74648493          	addi	s1,s1,1862 # 8000fe18 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800016da:	8b26                	mv	s6,s1
    800016dc:	00006a97          	auipc	s5,0x6
    800016e0:	924a8a93          	addi	s5,s5,-1756 # 80007000 <etext>
    800016e4:	04000937          	lui	s2,0x4000
    800016e8:	197d                	addi	s2,s2,-1
    800016ea:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ec:	00014a17          	auipc	s4,0x14
    800016f0:	72ca0a13          	addi	s4,s4,1836 # 80015e18 <tickslock>
    char *pa = kalloc();
    800016f4:	bb6ff0ef          	jal	ra,80000aaa <kalloc>
    800016f8:	862a                	mv	a2,a0
    if(pa == 0)
    800016fa:	c121                	beqz	a0,8000173a <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    800016fc:	416485b3          	sub	a1,s1,s6
    80001700:	859d                	srai	a1,a1,0x7
    80001702:	000ab783          	ld	a5,0(s5)
    80001706:	02f585b3          	mul	a1,a1,a5
    8000170a:	2585                	addiw	a1,a1,1
    8000170c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001710:	4719                	li	a4,6
    80001712:	6685                	lui	a3,0x1
    80001714:	40b905b3          	sub	a1,s2,a1
    80001718:	854e                	mv	a0,s3
    8000171a:	941ff0ef          	jal	ra,8000105a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171e:	18048493          	addi	s1,s1,384
    80001722:	fd4499e3          	bne	s1,s4,800016f4 <proc_mapstacks+0x38>
  }
}
    80001726:	70e2                	ld	ra,56(sp)
    80001728:	7442                	ld	s0,48(sp)
    8000172a:	74a2                	ld	s1,40(sp)
    8000172c:	7902                	ld	s2,32(sp)
    8000172e:	69e2                	ld	s3,24(sp)
    80001730:	6a42                	ld	s4,16(sp)
    80001732:	6aa2                	ld	s5,8(sp)
    80001734:	6b02                	ld	s6,0(sp)
    80001736:	6121                	addi	sp,sp,64
    80001738:	8082                	ret
      panic("kalloc");
    8000173a:	00006517          	auipc	a0,0x6
    8000173e:	a3650513          	addi	a0,a0,-1482 # 80007170 <digits+0x138>
    80001742:	84eff0ef          	jal	ra,80000790 <panic>

0000000080001746 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001746:	7139                	addi	sp,sp,-64
    80001748:	fc06                	sd	ra,56(sp)
    8000174a:	f822                	sd	s0,48(sp)
    8000174c:	f426                	sd	s1,40(sp)
    8000174e:	f04a                	sd	s2,32(sp)
    80001750:	ec4e                	sd	s3,24(sp)
    80001752:	e852                	sd	s4,16(sp)
    80001754:	e456                	sd	s5,8(sp)
    80001756:	e05a                	sd	s6,0(sp)
    80001758:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000175a:	00006597          	auipc	a1,0x6
    8000175e:	a1e58593          	addi	a1,a1,-1506 # 80007178 <digits+0x140>
    80001762:	0000e517          	auipc	a0,0xe
    80001766:	20650513          	addi	a0,a0,518 # 8000f968 <pid_lock>
    8000176a:	b90ff0ef          	jal	ra,80000afa <initlock>
  initlock(&wait_lock, "wait_lock");
    8000176e:	00006597          	auipc	a1,0x6
    80001772:	a1258593          	addi	a1,a1,-1518 # 80007180 <digits+0x148>
    80001776:	0000e517          	auipc	a0,0xe
    8000177a:	20a50513          	addi	a0,a0,522 # 8000f980 <wait_lock>
    8000177e:	b7cff0ef          	jal	ra,80000afa <initlock>

  //Εργασία ---- αρχικοποίηση round-robin state για κάθε CPU
  for(int i = 0; i < NCPU; i++) {
    80001782:	0000e797          	auipc	a5,0xe
    80001786:	21678793          	addi	a5,a5,534 # 8000f998 <rr_state>
    8000178a:	0000e717          	auipc	a4,0xe
    8000178e:	28e70713          	addi	a4,a4,654 # 8000fa18 <cpus>
    for(int j = 0; j < NQUEUES; j++) {
      rr_state[i].last_queued_proc[j] = INIT_RR_INDEX;
    80001792:	0007a023          	sw	zero,0(a5)
    80001796:	0007a223          	sw	zero,4(a5)
    8000179a:	0007a423          	sw	zero,8(a5)
    8000179e:	0007a623          	sw	zero,12(a5)
  for(int i = 0; i < NCPU; i++) {
    800017a2:	07c1                	addi	a5,a5,16
    800017a4:	fee797e3          	bne	a5,a4,80001792 <procinit+0x4c>
    }
  }

  for(p = proc; p < &proc[NPROC]; p++) {
    800017a8:	0000e497          	auipc	s1,0xe
    800017ac:	67048493          	addi	s1,s1,1648 # 8000fe18 <proc>
      initlock(&p->lock, "proc");
    800017b0:	00006b17          	auipc	s6,0x6
    800017b4:	9e0b0b13          	addi	s6,s6,-1568 # 80007190 <digits+0x158>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800017b8:	8aa6                	mv	s5,s1
    800017ba:	00006a17          	auipc	s4,0x6
    800017be:	846a0a13          	addi	s4,s4,-1978 # 80007000 <etext>
    800017c2:	04000937          	lui	s2,0x4000
    800017c6:	197d                	addi	s2,s2,-1
    800017c8:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ca:	00014997          	auipc	s3,0x14
    800017ce:	64e98993          	addi	s3,s3,1614 # 80015e18 <tickslock>
      initlock(&p->lock, "proc");
    800017d2:	85da                	mv	a1,s6
    800017d4:	8526                	mv	a0,s1
    800017d6:	b24ff0ef          	jal	ra,80000afa <initlock>
      p->state = UNUSED;
    800017da:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017de:	415487b3          	sub	a5,s1,s5
    800017e2:	879d                	srai	a5,a5,0x7
    800017e4:	000a3703          	ld	a4,0(s4)
    800017e8:	02e787b3          	mul	a5,a5,a4
    800017ec:	2785                	addiw	a5,a5,1
    800017ee:	00d7979b          	slliw	a5,a5,0xd
    800017f2:	40f907b3          	sub	a5,s2,a5
    800017f6:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f8:	18048493          	addi	s1,s1,384
    800017fc:	fd349be3          	bne	s1,s3,800017d2 <procinit+0x8c>
  }
}
    80001800:	70e2                	ld	ra,56(sp)
    80001802:	7442                	ld	s0,48(sp)
    80001804:	74a2                	ld	s1,40(sp)
    80001806:	7902                	ld	s2,32(sp)
    80001808:	69e2                	ld	s3,24(sp)
    8000180a:	6a42                	ld	s4,16(sp)
    8000180c:	6aa2                	ld	s5,8(sp)
    8000180e:	6b02                	ld	s6,0(sp)
    80001810:	6121                	addi	sp,sp,64
    80001812:	8082                	ret

0000000080001814 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001814:	1141                	addi	sp,sp,-16
    80001816:	e422                	sd	s0,8(sp)
    80001818:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000181a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000181c:	2501                	sext.w	a0,a0
    8000181e:	6422                	ld	s0,8(sp)
    80001820:	0141                	addi	sp,sp,16
    80001822:	8082                	ret

0000000080001824 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001824:	1141                	addi	sp,sp,-16
    80001826:	e422                	sd	s0,8(sp)
    80001828:	0800                	addi	s0,sp,16
    8000182a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000182c:	2781                	sext.w	a5,a5
    8000182e:	079e                	slli	a5,a5,0x7
  return c;
}
    80001830:	0000e517          	auipc	a0,0xe
    80001834:	1e850513          	addi	a0,a0,488 # 8000fa18 <cpus>
    80001838:	953e                	add	a0,a0,a5
    8000183a:	6422                	ld	s0,8(sp)
    8000183c:	0141                	addi	sp,sp,16
    8000183e:	8082                	ret

0000000080001840 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001840:	1101                	addi	sp,sp,-32
    80001842:	ec06                	sd	ra,24(sp)
    80001844:	e822                	sd	s0,16(sp)
    80001846:	e426                	sd	s1,8(sp)
    80001848:	1000                	addi	s0,sp,32
  push_off();
    8000184a:	af0ff0ef          	jal	ra,80000b3a <push_off>
    8000184e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001850:	2781                	sext.w	a5,a5
    80001852:	079e                	slli	a5,a5,0x7
    80001854:	0000e717          	auipc	a4,0xe
    80001858:	11470713          	addi	a4,a4,276 # 8000f968 <pid_lock>
    8000185c:	97ba                	add	a5,a5,a4
    8000185e:	7bc4                	ld	s1,176(a5)
  pop_off();
    80001860:	b5eff0ef          	jal	ra,80000bbe <pop_off>
  return p;
}
    80001864:	8526                	mv	a0,s1
    80001866:	60e2                	ld	ra,24(sp)
    80001868:	6442                	ld	s0,16(sp)
    8000186a:	64a2                	ld	s1,8(sp)
    8000186c:	6105                	addi	sp,sp,32
    8000186e:	8082                	ret

0000000080001870 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001870:	7179                	addi	sp,sp,-48
    80001872:	f406                	sd	ra,40(sp)
    80001874:	f022                	sd	s0,32(sp)
    80001876:	ec26                	sd	s1,24(sp)
    80001878:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000187a:	fc7ff0ef          	jal	ra,80001840 <myproc>
    8000187e:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001880:	b92ff0ef          	jal	ra,80000c12 <release>

  if (first) {
    80001884:	00006797          	auipc	a5,0x6
    80001888:	fac7a783          	lw	a5,-84(a5) # 80007830 <first.1722>
    8000188c:	cf8d                	beqz	a5,800018c6 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000188e:	4505                	li	a0,1
    80001890:	75b010ef          	jal	ra,800037ea <fsinit>

    first = 0;
    80001894:	00006797          	auipc	a5,0x6
    80001898:	f807ae23          	sw	zero,-100(a5) # 80007830 <first.1722>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000189c:	0ff0000f          	fence

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    800018a0:	00006517          	auipc	a0,0x6
    800018a4:	8f850513          	addi	a0,a0,-1800 # 80007198 <digits+0x160>
    800018a8:	fca43823          	sd	a0,-48(s0)
    800018ac:	fc043c23          	sd	zero,-40(s0)
    800018b0:	fd040593          	addi	a1,s0,-48
    800018b4:	7ed020ef          	jal	ra,800048a0 <kexec>
    800018b8:	6cbc                	ld	a5,88(s1)
    800018ba:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800018bc:	6cbc                	ld	a5,88(s1)
    800018be:	7bb8                	ld	a4,112(a5)
    800018c0:	57fd                	li	a5,-1
    800018c2:	02f70d63          	beq	a4,a5,800018fc <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800018c6:	521000ef          	jal	ra,800025e6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800018ca:	68a8                	ld	a0,80(s1)
    800018cc:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018ce:	04000737          	lui	a4,0x4000
    800018d2:	00004797          	auipc	a5,0x4
    800018d6:	7ca78793          	addi	a5,a5,1994 # 8000609c <userret>
    800018da:	00004697          	auipc	a3,0x4
    800018de:	72668693          	addi	a3,a3,1830 # 80006000 <_trampoline>
    800018e2:	8f95                	sub	a5,a5,a3
    800018e4:	177d                	addi	a4,a4,-1
    800018e6:	0732                	slli	a4,a4,0xc
    800018e8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018ea:	577d                	li	a4,-1
    800018ec:	177e                	slli	a4,a4,0x3f
    800018ee:	8d59                	or	a0,a0,a4
    800018f0:	9782                	jalr	a5
}
    800018f2:	70a2                	ld	ra,40(sp)
    800018f4:	7402                	ld	s0,32(sp)
    800018f6:	64e2                	ld	s1,24(sp)
    800018f8:	6145                	addi	sp,sp,48
    800018fa:	8082                	ret
      panic("exec");
    800018fc:	00006517          	auipc	a0,0x6
    80001900:	8a450513          	addi	a0,a0,-1884 # 800071a0 <digits+0x168>
    80001904:	e8dfe0ef          	jal	ra,80000790 <panic>

0000000080001908 <allocpid>:
{
    80001908:	1101                	addi	sp,sp,-32
    8000190a:	ec06                	sd	ra,24(sp)
    8000190c:	e822                	sd	s0,16(sp)
    8000190e:	e426                	sd	s1,8(sp)
    80001910:	e04a                	sd	s2,0(sp)
    80001912:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001914:	0000e917          	auipc	s2,0xe
    80001918:	05490913          	addi	s2,s2,84 # 8000f968 <pid_lock>
    8000191c:	854a                	mv	a0,s2
    8000191e:	a5cff0ef          	jal	ra,80000b7a <acquire>
  pid = nextpid;
    80001922:	00006797          	auipc	a5,0x6
    80001926:	f1278793          	addi	a5,a5,-238 # 80007834 <nextpid>
    8000192a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000192c:	0014871b          	addiw	a4,s1,1
    80001930:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001932:	854a                	mv	a0,s2
    80001934:	adeff0ef          	jal	ra,80000c12 <release>
}
    80001938:	8526                	mv	a0,s1
    8000193a:	60e2                	ld	ra,24(sp)
    8000193c:	6442                	ld	s0,16(sp)
    8000193e:	64a2                	ld	s1,8(sp)
    80001940:	6902                	ld	s2,0(sp)
    80001942:	6105                	addi	sp,sp,32
    80001944:	8082                	ret

0000000080001946 <proc_pagetable>:
{
    80001946:	1101                	addi	sp,sp,-32
    80001948:	ec06                	sd	ra,24(sp)
    8000194a:	e822                	sd	s0,16(sp)
    8000194c:	e426                	sd	s1,8(sp)
    8000194e:	e04a                	sd	s2,0(sp)
    80001950:	1000                	addi	s0,sp,32
    80001952:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001954:	ffcff0ef          	jal	ra,80001150 <uvmcreate>
    80001958:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000195a:	cd05                	beqz	a0,80001992 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000195c:	4729                	li	a4,10
    8000195e:	00004697          	auipc	a3,0x4
    80001962:	6a268693          	addi	a3,a3,1698 # 80006000 <_trampoline>
    80001966:	6605                	lui	a2,0x1
    80001968:	040005b7          	lui	a1,0x4000
    8000196c:	15fd                	addi	a1,a1,-1
    8000196e:	05b2                	slli	a1,a1,0xc
    80001970:	e3aff0ef          	jal	ra,80000faa <mappages>
    80001974:	02054663          	bltz	a0,800019a0 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001978:	4719                	li	a4,6
    8000197a:	05893683          	ld	a3,88(s2)
    8000197e:	6605                	lui	a2,0x1
    80001980:	020005b7          	lui	a1,0x2000
    80001984:	15fd                	addi	a1,a1,-1
    80001986:	05b6                	slli	a1,a1,0xd
    80001988:	8526                	mv	a0,s1
    8000198a:	e20ff0ef          	jal	ra,80000faa <mappages>
    8000198e:	00054f63          	bltz	a0,800019ac <proc_pagetable+0x66>
}
    80001992:	8526                	mv	a0,s1
    80001994:	60e2                	ld	ra,24(sp)
    80001996:	6442                	ld	s0,16(sp)
    80001998:	64a2                	ld	s1,8(sp)
    8000199a:	6902                	ld	s2,0(sp)
    8000199c:	6105                	addi	sp,sp,32
    8000199e:	8082                	ret
    uvmfree(pagetable, 0);
    800019a0:	4581                	li	a1,0
    800019a2:	8526                	mv	a0,s1
    800019a4:	98bff0ef          	jal	ra,8000132e <uvmfree>
    return 0;
    800019a8:	4481                	li	s1,0
    800019aa:	b7e5                	j	80001992 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019ac:	4681                	li	a3,0
    800019ae:	4605                	li	a2,1
    800019b0:	040005b7          	lui	a1,0x4000
    800019b4:	15fd                	addi	a1,a1,-1
    800019b6:	05b2                	slli	a1,a1,0xc
    800019b8:	8526                	mv	a0,s1
    800019ba:	fbcff0ef          	jal	ra,80001176 <uvmunmap>
    uvmfree(pagetable, 0);
    800019be:	4581                	li	a1,0
    800019c0:	8526                	mv	a0,s1
    800019c2:	96dff0ef          	jal	ra,8000132e <uvmfree>
    return 0;
    800019c6:	4481                	li	s1,0
    800019c8:	b7e9                	j	80001992 <proc_pagetable+0x4c>

00000000800019ca <proc_freepagetable>:
{
    800019ca:	1101                	addi	sp,sp,-32
    800019cc:	ec06                	sd	ra,24(sp)
    800019ce:	e822                	sd	s0,16(sp)
    800019d0:	e426                	sd	s1,8(sp)
    800019d2:	e04a                	sd	s2,0(sp)
    800019d4:	1000                	addi	s0,sp,32
    800019d6:	84aa                	mv	s1,a0
    800019d8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019da:	4681                	li	a3,0
    800019dc:	4605                	li	a2,1
    800019de:	040005b7          	lui	a1,0x4000
    800019e2:	15fd                	addi	a1,a1,-1
    800019e4:	05b2                	slli	a1,a1,0xc
    800019e6:	f90ff0ef          	jal	ra,80001176 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800019ea:	4681                	li	a3,0
    800019ec:	4605                	li	a2,1
    800019ee:	020005b7          	lui	a1,0x2000
    800019f2:	15fd                	addi	a1,a1,-1
    800019f4:	05b6                	slli	a1,a1,0xd
    800019f6:	8526                	mv	a0,s1
    800019f8:	f7eff0ef          	jal	ra,80001176 <uvmunmap>
  uvmfree(pagetable, sz);
    800019fc:	85ca                	mv	a1,s2
    800019fe:	8526                	mv	a0,s1
    80001a00:	92fff0ef          	jal	ra,8000132e <uvmfree>
}
    80001a04:	60e2                	ld	ra,24(sp)
    80001a06:	6442                	ld	s0,16(sp)
    80001a08:	64a2                	ld	s1,8(sp)
    80001a0a:	6902                	ld	s2,0(sp)
    80001a0c:	6105                	addi	sp,sp,32
    80001a0e:	8082                	ret

0000000080001a10 <freeproc>:
{
    80001a10:	1101                	addi	sp,sp,-32
    80001a12:	ec06                	sd	ra,24(sp)
    80001a14:	e822                	sd	s0,16(sp)
    80001a16:	e426                	sd	s1,8(sp)
    80001a18:	1000                	addi	s0,sp,32
    80001a1a:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a1c:	6d28                	ld	a0,88(a0)
    80001a1e:	c119                	beqz	a0,80001a24 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a20:	fabfe0ef          	jal	ra,800009ca <kfree>
  p->trapframe = 0;
    80001a24:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a28:	68a8                	ld	a0,80(s1)
    80001a2a:	c501                	beqz	a0,80001a32 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a2c:	64ac                	ld	a1,72(s1)
    80001a2e:	f9dff0ef          	jal	ra,800019ca <proc_freepagetable>
  p->pagetable = 0;
    80001a32:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a36:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a3a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a3e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a42:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a46:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a4a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a4e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001a52:	0004ac23          	sw	zero,24(s1)
  p->priority = 0;
    80001a56:	1604a423          	sw	zero,360(s1)
  p->timer_ticks_used = 0;
    80001a5a:	1604a623          	sw	zero,364(s1)
  p->wait_timer_ticks = 0;
    80001a5e:	1604a823          	sw	zero,368(s1)
  p->queue_level = 0;
    80001a62:	1604ac23          	sw	zero,376(s1)
  p->voluntarily_yielded = 0;
    80001a66:	1604ae23          	sw	zero,380(s1)
}
    80001a6a:	60e2                	ld	ra,24(sp)
    80001a6c:	6442                	ld	s0,16(sp)
    80001a6e:	64a2                	ld	s1,8(sp)
    80001a70:	6105                	addi	sp,sp,32
    80001a72:	8082                	ret

0000000080001a74 <allocproc>:
{
    80001a74:	1101                	addi	sp,sp,-32
    80001a76:	ec06                	sd	ra,24(sp)
    80001a78:	e822                	sd	s0,16(sp)
    80001a7a:	e426                	sd	s1,8(sp)
    80001a7c:	e04a                	sd	s2,0(sp)
    80001a7e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a80:	0000e497          	auipc	s1,0xe
    80001a84:	39848493          	addi	s1,s1,920 # 8000fe18 <proc>
    80001a88:	00014917          	auipc	s2,0x14
    80001a8c:	39090913          	addi	s2,s2,912 # 80015e18 <tickslock>
    acquire(&p->lock);
    80001a90:	8526                	mv	a0,s1
    80001a92:	8e8ff0ef          	jal	ra,80000b7a <acquire>
    if(p->state == UNUSED) {
    80001a96:	4c9c                	lw	a5,24(s1)
    80001a98:	cb91                	beqz	a5,80001aac <allocproc+0x38>
      release(&p->lock);
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	976ff0ef          	jal	ra,80000c12 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aa0:	18048493          	addi	s1,s1,384
    80001aa4:	ff2496e3          	bne	s1,s2,80001a90 <allocproc+0x1c>
  return 0;
    80001aa8:	4481                	li	s1,0
    80001aaa:	a085                	j	80001b0a <allocproc+0x96>
  p->pid = allocpid();
    80001aac:	e5dff0ef          	jal	ra,80001908 <allocpid>
    80001ab0:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001ab2:	4785                	li	a5,1
    80001ab4:	cc9c                	sw	a5,24(s1)
  p->priority = 0;
    80001ab6:	1604a423          	sw	zero,360(s1)
  p->timer_ticks_used = 0;
    80001aba:	1604a623          	sw	zero,364(s1)
  p->wait_timer_ticks = 0;
    80001abe:	1604a823          	sw	zero,368(s1)
  p->queue_level = 0;
    80001ac2:	1604ac23          	sw	zero,376(s1)
  p->parent = 0;
    80001ac6:	0204bc23          	sd	zero,56(s1)
  p->max_time_slice = TIME_SLICE_0;
    80001aca:	4791                	li	a5,4
    80001acc:	16f4aa23          	sw	a5,372(s1)
  p->voluntarily_yielded = 0; //αρχικά όχι εθελούσια παράδοση
    80001ad0:	1604ae23          	sw	zero,380(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001ad4:	fd7fe0ef          	jal	ra,80000aaa <kalloc>
    80001ad8:	892a                	mv	s2,a0
    80001ada:	eca8                	sd	a0,88(s1)
    80001adc:	cd15                	beqz	a0,80001b18 <allocproc+0xa4>
  p->pagetable = proc_pagetable(p);
    80001ade:	8526                	mv	a0,s1
    80001ae0:	e67ff0ef          	jal	ra,80001946 <proc_pagetable>
    80001ae4:	892a                	mv	s2,a0
    80001ae6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001ae8:	c121                	beqz	a0,80001b28 <allocproc+0xb4>
  memset(&p->context, 0, sizeof(p->context));
    80001aea:	07000613          	li	a2,112
    80001aee:	4581                	li	a1,0
    80001af0:	06048513          	addi	a0,s1,96
    80001af4:	95aff0ef          	jal	ra,80000c4e <memset>
  p->context.ra = (uint64)forkret;
    80001af8:	00000797          	auipc	a5,0x0
    80001afc:	d7878793          	addi	a5,a5,-648 # 80001870 <forkret>
    80001b00:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b02:	60bc                	ld	a5,64(s1)
    80001b04:	6705                	lui	a4,0x1
    80001b06:	97ba                	add	a5,a5,a4
    80001b08:	f4bc                	sd	a5,104(s1)
}
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	60e2                	ld	ra,24(sp)
    80001b0e:	6442                	ld	s0,16(sp)
    80001b10:	64a2                	ld	s1,8(sp)
    80001b12:	6902                	ld	s2,0(sp)
    80001b14:	6105                	addi	sp,sp,32
    80001b16:	8082                	ret
    freeproc(p);
    80001b18:	8526                	mv	a0,s1
    80001b1a:	ef7ff0ef          	jal	ra,80001a10 <freeproc>
    release(&p->lock);
    80001b1e:	8526                	mv	a0,s1
    80001b20:	8f2ff0ef          	jal	ra,80000c12 <release>
    return 0;
    80001b24:	84ca                	mv	s1,s2
    80001b26:	b7d5                	j	80001b0a <allocproc+0x96>
    freeproc(p);
    80001b28:	8526                	mv	a0,s1
    80001b2a:	ee7ff0ef          	jal	ra,80001a10 <freeproc>
    release(&p->lock);
    80001b2e:	8526                	mv	a0,s1
    80001b30:	8e2ff0ef          	jal	ra,80000c12 <release>
    return 0;
    80001b34:	84ca                	mv	s1,s2
    80001b36:	bfd1                	j	80001b0a <allocproc+0x96>

0000000080001b38 <userinit>:
{
    80001b38:	1101                	addi	sp,sp,-32
    80001b3a:	ec06                	sd	ra,24(sp)
    80001b3c:	e822                	sd	s0,16(sp)
    80001b3e:	e426                	sd	s1,8(sp)
    80001b40:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b42:	f33ff0ef          	jal	ra,80001a74 <allocproc>
    80001b46:	84aa                	mv	s1,a0
  initproc = p;
    80001b48:	00006797          	auipc	a5,0x6
    80001b4c:	d0a7bc23          	sd	a0,-744(a5) # 80007860 <initproc>
  p->cwd = namei("/");
    80001b50:	00005517          	auipc	a0,0x5
    80001b54:	65850513          	addi	a0,a0,1624 # 800071a8 <digits+0x170>
    80001b58:	190020ef          	jal	ra,80003ce8 <namei>
    80001b5c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b60:	478d                	li	a5,3
    80001b62:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b64:	8526                	mv	a0,s1
    80001b66:	8acff0ef          	jal	ra,80000c12 <release>
}
    80001b6a:	60e2                	ld	ra,24(sp)
    80001b6c:	6442                	ld	s0,16(sp)
    80001b6e:	64a2                	ld	s1,8(sp)
    80001b70:	6105                	addi	sp,sp,32
    80001b72:	8082                	ret

0000000080001b74 <growproc>:
{
    80001b74:	1101                	addi	sp,sp,-32
    80001b76:	ec06                	sd	ra,24(sp)
    80001b78:	e822                	sd	s0,16(sp)
    80001b7a:	e426                	sd	s1,8(sp)
    80001b7c:	e04a                	sd	s2,0(sp)
    80001b7e:	1000                	addi	s0,sp,32
    80001b80:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b82:	cbfff0ef          	jal	ra,80001840 <myproc>
    80001b86:	892a                	mv	s2,a0
  sz = p->sz;
    80001b88:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b8a:	02905963          	blez	s1,80001bbc <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001b8e:	00b48633          	add	a2,s1,a1
    80001b92:	020007b7          	lui	a5,0x2000
    80001b96:	17fd                	addi	a5,a5,-1
    80001b98:	07b6                	slli	a5,a5,0xd
    80001b9a:	02c7ea63          	bltu	a5,a2,80001bce <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b9e:	4691                	li	a3,4
    80001ba0:	6928                	ld	a0,80(a0)
    80001ba2:	e94ff0ef          	jal	ra,80001236 <uvmalloc>
    80001ba6:	85aa                	mv	a1,a0
    80001ba8:	c50d                	beqz	a0,80001bd2 <growproc+0x5e>
  p->sz = sz;
    80001baa:	04b93423          	sd	a1,72(s2)
  return 0;
    80001bae:	4501                	li	a0,0
}
    80001bb0:	60e2                	ld	ra,24(sp)
    80001bb2:	6442                	ld	s0,16(sp)
    80001bb4:	64a2                	ld	s1,8(sp)
    80001bb6:	6902                	ld	s2,0(sp)
    80001bb8:	6105                	addi	sp,sp,32
    80001bba:	8082                	ret
  } else if(n < 0){
    80001bbc:	fe04d7e3          	bgez	s1,80001baa <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001bc0:	00b48633          	add	a2,s1,a1
    80001bc4:	6928                	ld	a0,80(a0)
    80001bc6:	e2cff0ef          	jal	ra,800011f2 <uvmdealloc>
    80001bca:	85aa                	mv	a1,a0
    80001bcc:	bff9                	j	80001baa <growproc+0x36>
      return -1;
    80001bce:	557d                	li	a0,-1
    80001bd0:	b7c5                	j	80001bb0 <growproc+0x3c>
      return -1;
    80001bd2:	557d                	li	a0,-1
    80001bd4:	bff1                	j	80001bb0 <growproc+0x3c>

0000000080001bd6 <sched>:
{
    80001bd6:	7179                	addi	sp,sp,-48
    80001bd8:	f406                	sd	ra,40(sp)
    80001bda:	f022                	sd	s0,32(sp)
    80001bdc:	ec26                	sd	s1,24(sp)
    80001bde:	e84a                	sd	s2,16(sp)
    80001be0:	e44e                	sd	s3,8(sp)
    80001be2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001be4:	c5dff0ef          	jal	ra,80001840 <myproc>
    80001be8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001bea:	f27fe0ef          	jal	ra,80000b10 <holding>
    80001bee:	c92d                	beqz	a0,80001c60 <sched+0x8a>
    80001bf0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001bf2:	2781                	sext.w	a5,a5
    80001bf4:	079e                	slli	a5,a5,0x7
    80001bf6:	0000e717          	auipc	a4,0xe
    80001bfa:	d7270713          	addi	a4,a4,-654 # 8000f968 <pid_lock>
    80001bfe:	97ba                	add	a5,a5,a4
    80001c00:	1287a703          	lw	a4,296(a5) # 2000128 <_entry-0x7dfffed8>
    80001c04:	4785                	li	a5,1
    80001c06:	06f71363          	bne	a4,a5,80001c6c <sched+0x96>
  if(p->state == RUNNING)
    80001c0a:	4c98                	lw	a4,24(s1)
    80001c0c:	4791                	li	a5,4
    80001c0e:	06f70563          	beq	a4,a5,80001c78 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c12:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001c16:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001c18:	e7b5                	bnez	a5,80001c84 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c1a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001c1c:	0000e917          	auipc	s2,0xe
    80001c20:	d4c90913          	addi	s2,s2,-692 # 8000f968 <pid_lock>
    80001c24:	2781                	sext.w	a5,a5
    80001c26:	079e                	slli	a5,a5,0x7
    80001c28:	97ca                	add	a5,a5,s2
    80001c2a:	12c7a983          	lw	s3,300(a5)
    80001c2e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001c30:	2781                	sext.w	a5,a5
    80001c32:	079e                	slli	a5,a5,0x7
    80001c34:	0000e597          	auipc	a1,0xe
    80001c38:	dec58593          	addi	a1,a1,-532 # 8000fa20 <cpus+0x8>
    80001c3c:	95be                	add	a1,a1,a5
    80001c3e:	06048513          	addi	a0,s1,96
    80001c42:	0ff000ef          	jal	ra,80002540 <swtch>
    80001c46:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001c48:	2781                	sext.w	a5,a5
    80001c4a:	079e                	slli	a5,a5,0x7
    80001c4c:	97ca                	add	a5,a5,s2
    80001c4e:	1337a623          	sw	s3,300(a5)
}
    80001c52:	70a2                	ld	ra,40(sp)
    80001c54:	7402                	ld	s0,32(sp)
    80001c56:	64e2                	ld	s1,24(sp)
    80001c58:	6942                	ld	s2,16(sp)
    80001c5a:	69a2                	ld	s3,8(sp)
    80001c5c:	6145                	addi	sp,sp,48
    80001c5e:	8082                	ret
    panic("sched p->lock");
    80001c60:	00005517          	auipc	a0,0x5
    80001c64:	55050513          	addi	a0,a0,1360 # 800071b0 <digits+0x178>
    80001c68:	b29fe0ef          	jal	ra,80000790 <panic>
    panic("sched locks");
    80001c6c:	00005517          	auipc	a0,0x5
    80001c70:	55450513          	addi	a0,a0,1364 # 800071c0 <digits+0x188>
    80001c74:	b1dfe0ef          	jal	ra,80000790 <panic>
    panic("sched RUNNING");
    80001c78:	00005517          	auipc	a0,0x5
    80001c7c:	55850513          	addi	a0,a0,1368 # 800071d0 <digits+0x198>
    80001c80:	b11fe0ef          	jal	ra,80000790 <panic>
    panic("sched interruptible");
    80001c84:	00005517          	auipc	a0,0x5
    80001c88:	55c50513          	addi	a0,a0,1372 # 800071e0 <digits+0x1a8>
    80001c8c:	b05fe0ef          	jal	ra,80000790 <panic>

0000000080001c90 <yield>:
{
    80001c90:	1101                	addi	sp,sp,-32
    80001c92:	ec06                	sd	ra,24(sp)
    80001c94:	e822                	sd	s0,16(sp)
    80001c96:	e426                	sd	s1,8(sp)
    80001c98:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001c9a:	ba7ff0ef          	jal	ra,80001840 <myproc>
    80001c9e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ca0:	edbfe0ef          	jal	ra,80000b7a <acquire>
  p->state = RUNNABLE;
    80001ca4:	478d                	li	a5,3
    80001ca6:	cc9c                	sw	a5,24(s1)
  p->voluntarily_yielded = 1; //σηματοδότηση εθελούσιας παράδοσης
    80001ca8:	4785                	li	a5,1
    80001caa:	16f4ae23          	sw	a5,380(s1)
  sched();
    80001cae:	f29ff0ef          	jal	ra,80001bd6 <sched>
  release(&p->lock);
    80001cb2:	8526                	mv	a0,s1
    80001cb4:	f5ffe0ef          	jal	ra,80000c12 <release>
}
    80001cb8:	60e2                	ld	ra,24(sp)
    80001cba:	6442                	ld	s0,16(sp)
    80001cbc:	64a2                	ld	s1,8(sp)
    80001cbe:	6105                	addi	sp,sp,32
    80001cc0:	8082                	ret

0000000080001cc2 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001cc2:	7179                	addi	sp,sp,-48
    80001cc4:	f406                	sd	ra,40(sp)
    80001cc6:	f022                	sd	s0,32(sp)
    80001cc8:	ec26                	sd	s1,24(sp)
    80001cca:	e84a                	sd	s2,16(sp)
    80001ccc:	e44e                	sd	s3,8(sp)
    80001cce:	1800                	addi	s0,sp,48
    80001cd0:	89aa                	mv	s3,a0
    80001cd2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001cd4:	b6dff0ef          	jal	ra,80001840 <myproc>
    80001cd8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001cda:	ea1fe0ef          	jal	ra,80000b7a <acquire>
  release(lk);
    80001cde:	854a                	mv	a0,s2
    80001ce0:	f33fe0ef          	jal	ra,80000c12 <release>

  // Go to sleep.
  p->chan = chan;
    80001ce4:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001ce8:	4789                	li	a5,2
    80001cea:	cc9c                	sw	a5,24(s1)
  p->voluntarily_yielded = 1;  //sleep είναι εθελούσια παράδοση
    80001cec:	4785                	li	a5,1
    80001cee:	16f4ae23          	sw	a5,380(s1)

  sched();
    80001cf2:	ee5ff0ef          	jal	ra,80001bd6 <sched>

  // Tidy up.
  p->chan = 0;
    80001cf6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	f17fe0ef          	jal	ra,80000c12 <release>
  acquire(lk);
    80001d00:	854a                	mv	a0,s2
    80001d02:	e79fe0ef          	jal	ra,80000b7a <acquire>
}
    80001d06:	70a2                	ld	ra,40(sp)
    80001d08:	7402                	ld	s0,32(sp)
    80001d0a:	64e2                	ld	s1,24(sp)
    80001d0c:	6942                	ld	s2,16(sp)
    80001d0e:	69a2                	ld	s3,8(sp)
    80001d10:	6145                	addi	sp,sp,48
    80001d12:	8082                	ret

0000000080001d14 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001d14:	7139                	addi	sp,sp,-64
    80001d16:	fc06                	sd	ra,56(sp)
    80001d18:	f822                	sd	s0,48(sp)
    80001d1a:	f426                	sd	s1,40(sp)
    80001d1c:	f04a                	sd	s2,32(sp)
    80001d1e:	ec4e                	sd	s3,24(sp)
    80001d20:	e852                	sd	s4,16(sp)
    80001d22:	e456                	sd	s5,8(sp)
    80001d24:	0080                	addi	s0,sp,64
    80001d26:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001d28:	0000e497          	auipc	s1,0xe
    80001d2c:	0f048493          	addi	s1,s1,240 # 8000fe18 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001d30:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001d32:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d34:	00014917          	auipc	s2,0x14
    80001d38:	0e490913          	addi	s2,s2,228 # 80015e18 <tickslock>
    80001d3c:	a811                	j	80001d50 <wakeup+0x3c>
        p->state = RUNNABLE;
    80001d3e:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001d42:	8526                	mv	a0,s1
    80001d44:	ecffe0ef          	jal	ra,80000c12 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d48:	18048493          	addi	s1,s1,384
    80001d4c:	03248063          	beq	s1,s2,80001d6c <wakeup+0x58>
    if(p != myproc()){
    80001d50:	af1ff0ef          	jal	ra,80001840 <myproc>
    80001d54:	fea48ae3          	beq	s1,a0,80001d48 <wakeup+0x34>
      acquire(&p->lock);
    80001d58:	8526                	mv	a0,s1
    80001d5a:	e21fe0ef          	jal	ra,80000b7a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001d5e:	4c9c                	lw	a5,24(s1)
    80001d60:	ff3791e3          	bne	a5,s3,80001d42 <wakeup+0x2e>
    80001d64:	709c                	ld	a5,32(s1)
    80001d66:	fd479ee3          	bne	a5,s4,80001d42 <wakeup+0x2e>
    80001d6a:	bfd1                	j	80001d3e <wakeup+0x2a>
    }
  }
}
    80001d6c:	70e2                	ld	ra,56(sp)
    80001d6e:	7442                	ld	s0,48(sp)
    80001d70:	74a2                	ld	s1,40(sp)
    80001d72:	7902                	ld	s2,32(sp)
    80001d74:	69e2                	ld	s3,24(sp)
    80001d76:	6a42                	ld	s4,16(sp)
    80001d78:	6aa2                	ld	s5,8(sp)
    80001d7a:	6121                	addi	sp,sp,64
    80001d7c:	8082                	ret

0000000080001d7e <reparent>:
{
    80001d7e:	7179                	addi	sp,sp,-48
    80001d80:	f406                	sd	ra,40(sp)
    80001d82:	f022                	sd	s0,32(sp)
    80001d84:	ec26                	sd	s1,24(sp)
    80001d86:	e84a                	sd	s2,16(sp)
    80001d88:	e44e                	sd	s3,8(sp)
    80001d8a:	e052                	sd	s4,0(sp)
    80001d8c:	1800                	addi	s0,sp,48
    80001d8e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d90:	0000e497          	auipc	s1,0xe
    80001d94:	08848493          	addi	s1,s1,136 # 8000fe18 <proc>
      pp->parent = initproc;
    80001d98:	00006a17          	auipc	s4,0x6
    80001d9c:	ac8a0a13          	addi	s4,s4,-1336 # 80007860 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001da0:	00014997          	auipc	s3,0x14
    80001da4:	07898993          	addi	s3,s3,120 # 80015e18 <tickslock>
    80001da8:	a029                	j	80001db2 <reparent+0x34>
    80001daa:	18048493          	addi	s1,s1,384
    80001dae:	01348b63          	beq	s1,s3,80001dc4 <reparent+0x46>
    if(pp->parent == p){
    80001db2:	7c9c                	ld	a5,56(s1)
    80001db4:	ff279be3          	bne	a5,s2,80001daa <reparent+0x2c>
      pp->parent = initproc;
    80001db8:	000a3503          	ld	a0,0(s4)
    80001dbc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001dbe:	f57ff0ef          	jal	ra,80001d14 <wakeup>
    80001dc2:	b7e5                	j	80001daa <reparent+0x2c>
}
    80001dc4:	70a2                	ld	ra,40(sp)
    80001dc6:	7402                	ld	s0,32(sp)
    80001dc8:	64e2                	ld	s1,24(sp)
    80001dca:	6942                	ld	s2,16(sp)
    80001dcc:	69a2                	ld	s3,8(sp)
    80001dce:	6a02                	ld	s4,0(sp)
    80001dd0:	6145                	addi	sp,sp,48
    80001dd2:	8082                	ret

0000000080001dd4 <kexit>:
{
    80001dd4:	7179                	addi	sp,sp,-48
    80001dd6:	f406                	sd	ra,40(sp)
    80001dd8:	f022                	sd	s0,32(sp)
    80001dda:	ec26                	sd	s1,24(sp)
    80001ddc:	e84a                	sd	s2,16(sp)
    80001dde:	e44e                	sd	s3,8(sp)
    80001de0:	e052                	sd	s4,0(sp)
    80001de2:	1800                	addi	s0,sp,48
    80001de4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001de6:	a5bff0ef          	jal	ra,80001840 <myproc>
    80001dea:	89aa                	mv	s3,a0
  if(p == initproc)
    80001dec:	00006797          	auipc	a5,0x6
    80001df0:	a747b783          	ld	a5,-1420(a5) # 80007860 <initproc>
    80001df4:	0d050493          	addi	s1,a0,208
    80001df8:	15050913          	addi	s2,a0,336
    80001dfc:	00a79f63          	bne	a5,a0,80001e1a <kexit+0x46>
    panic("init exiting");
    80001e00:	00005517          	auipc	a0,0x5
    80001e04:	3f850513          	addi	a0,a0,1016 # 800071f8 <digits+0x1c0>
    80001e08:	989fe0ef          	jal	ra,80000790 <panic>
      fileclose(f);
    80001e0c:	4da020ef          	jal	ra,800042e6 <fileclose>
      p->ofile[fd] = 0;
    80001e10:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001e14:	04a1                	addi	s1,s1,8
    80001e16:	01248563          	beq	s1,s2,80001e20 <kexit+0x4c>
    if(p->ofile[fd]){
    80001e1a:	6088                	ld	a0,0(s1)
    80001e1c:	f965                	bnez	a0,80001e0c <kexit+0x38>
    80001e1e:	bfdd                	j	80001e14 <kexit+0x40>
  begin_op();
    80001e20:	0b8020ef          	jal	ra,80003ed8 <begin_op>
  iput(p->cwd);
    80001e24:	1509b503          	ld	a0,336(s3)
    80001e28:	051010ef          	jal	ra,80003678 <iput>
  end_op();
    80001e2c:	11c020ef          	jal	ra,80003f48 <end_op>
  p->cwd = 0;
    80001e30:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001e34:	0000e497          	auipc	s1,0xe
    80001e38:	b4c48493          	addi	s1,s1,-1204 # 8000f980 <wait_lock>
    80001e3c:	8526                	mv	a0,s1
    80001e3e:	d3dfe0ef          	jal	ra,80000b7a <acquire>
  reparent(p);
    80001e42:	854e                	mv	a0,s3
    80001e44:	f3bff0ef          	jal	ra,80001d7e <reparent>
  wakeup(p->parent);
    80001e48:	0389b503          	ld	a0,56(s3)
    80001e4c:	ec9ff0ef          	jal	ra,80001d14 <wakeup>
  acquire(&p->lock);
    80001e50:	854e                	mv	a0,s3
    80001e52:	d29fe0ef          	jal	ra,80000b7a <acquire>
  p->xstate = status;
    80001e56:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001e5a:	4795                	li	a5,5
    80001e5c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001e60:	8526                	mv	a0,s1
    80001e62:	db1fe0ef          	jal	ra,80000c12 <release>
  sched();
    80001e66:	d71ff0ef          	jal	ra,80001bd6 <sched>
  panic("zombie exit");
    80001e6a:	00005517          	auipc	a0,0x5
    80001e6e:	39e50513          	addi	a0,a0,926 # 80007208 <digits+0x1d0>
    80001e72:	91ffe0ef          	jal	ra,80000790 <panic>

0000000080001e76 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001e76:	7179                	addi	sp,sp,-48
    80001e78:	f406                	sd	ra,40(sp)
    80001e7a:	f022                	sd	s0,32(sp)
    80001e7c:	ec26                	sd	s1,24(sp)
    80001e7e:	e84a                	sd	s2,16(sp)
    80001e80:	e44e                	sd	s3,8(sp)
    80001e82:	1800                	addi	s0,sp,48
    80001e84:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001e86:	0000e497          	auipc	s1,0xe
    80001e8a:	f9248493          	addi	s1,s1,-110 # 8000fe18 <proc>
    80001e8e:	00014997          	auipc	s3,0x14
    80001e92:	f8a98993          	addi	s3,s3,-118 # 80015e18 <tickslock>
    acquire(&p->lock);
    80001e96:	8526                	mv	a0,s1
    80001e98:	ce3fe0ef          	jal	ra,80000b7a <acquire>
    if(p->pid == pid){
    80001e9c:	589c                	lw	a5,48(s1)
    80001e9e:	01278b63          	beq	a5,s2,80001eb4 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001ea2:	8526                	mv	a0,s1
    80001ea4:	d6ffe0ef          	jal	ra,80000c12 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ea8:	18048493          	addi	s1,s1,384
    80001eac:	ff3495e3          	bne	s1,s3,80001e96 <kkill+0x20>
  }
  return -1;
    80001eb0:	557d                	li	a0,-1
    80001eb2:	a819                	j	80001ec8 <kkill+0x52>
      p->killed = 1;
    80001eb4:	4785                	li	a5,1
    80001eb6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001eb8:	4c98                	lw	a4,24(s1)
    80001eba:	4789                	li	a5,2
    80001ebc:	00f70d63          	beq	a4,a5,80001ed6 <kkill+0x60>
      release(&p->lock);
    80001ec0:	8526                	mv	a0,s1
    80001ec2:	d51fe0ef          	jal	ra,80000c12 <release>
      return 0;
    80001ec6:	4501                	li	a0,0
}
    80001ec8:	70a2                	ld	ra,40(sp)
    80001eca:	7402                	ld	s0,32(sp)
    80001ecc:	64e2                	ld	s1,24(sp)
    80001ece:	6942                	ld	s2,16(sp)
    80001ed0:	69a2                	ld	s3,8(sp)
    80001ed2:	6145                	addi	sp,sp,48
    80001ed4:	8082                	ret
        p->state = RUNNABLE;
    80001ed6:	478d                	li	a5,3
    80001ed8:	cc9c                	sw	a5,24(s1)
    80001eda:	b7dd                	j	80001ec0 <kkill+0x4a>

0000000080001edc <setkilled>:

void
setkilled(struct proc *p)
{
    80001edc:	1101                	addi	sp,sp,-32
    80001ede:	ec06                	sd	ra,24(sp)
    80001ee0:	e822                	sd	s0,16(sp)
    80001ee2:	e426                	sd	s1,8(sp)
    80001ee4:	1000                	addi	s0,sp,32
    80001ee6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ee8:	c93fe0ef          	jal	ra,80000b7a <acquire>
  p->killed = 1;
    80001eec:	4785                	li	a5,1
    80001eee:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001ef0:	8526                	mv	a0,s1
    80001ef2:	d21fe0ef          	jal	ra,80000c12 <release>
}
    80001ef6:	60e2                	ld	ra,24(sp)
    80001ef8:	6442                	ld	s0,16(sp)
    80001efa:	64a2                	ld	s1,8(sp)
    80001efc:	6105                	addi	sp,sp,32
    80001efe:	8082                	ret

0000000080001f00 <killed>:

int
killed(struct proc *p)
{
    80001f00:	1101                	addi	sp,sp,-32
    80001f02:	ec06                	sd	ra,24(sp)
    80001f04:	e822                	sd	s0,16(sp)
    80001f06:	e426                	sd	s1,8(sp)
    80001f08:	e04a                	sd	s2,0(sp)
    80001f0a:	1000                	addi	s0,sp,32
    80001f0c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001f0e:	c6dfe0ef          	jal	ra,80000b7a <acquire>
  k = p->killed;
    80001f12:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001f16:	8526                	mv	a0,s1
    80001f18:	cfbfe0ef          	jal	ra,80000c12 <release>
  return k;
}
    80001f1c:	854a                	mv	a0,s2
    80001f1e:	60e2                	ld	ra,24(sp)
    80001f20:	6442                	ld	s0,16(sp)
    80001f22:	64a2                	ld	s1,8(sp)
    80001f24:	6902                	ld	s2,0(sp)
    80001f26:	6105                	addi	sp,sp,32
    80001f28:	8082                	ret

0000000080001f2a <kwait>:
{
    80001f2a:	715d                	addi	sp,sp,-80
    80001f2c:	e486                	sd	ra,72(sp)
    80001f2e:	e0a2                	sd	s0,64(sp)
    80001f30:	fc26                	sd	s1,56(sp)
    80001f32:	f84a                	sd	s2,48(sp)
    80001f34:	f44e                	sd	s3,40(sp)
    80001f36:	f052                	sd	s4,32(sp)
    80001f38:	ec56                	sd	s5,24(sp)
    80001f3a:	e85a                	sd	s6,16(sp)
    80001f3c:	e45e                	sd	s7,8(sp)
    80001f3e:	e062                	sd	s8,0(sp)
    80001f40:	0880                	addi	s0,sp,80
    80001f42:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001f44:	8fdff0ef          	jal	ra,80001840 <myproc>
    80001f48:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001f4a:	0000e517          	auipc	a0,0xe
    80001f4e:	a3650513          	addi	a0,a0,-1482 # 8000f980 <wait_lock>
    80001f52:	c29fe0ef          	jal	ra,80000b7a <acquire>
    havekids = 0;
    80001f56:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001f58:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f5a:	00014997          	auipc	s3,0x14
    80001f5e:	ebe98993          	addi	s3,s3,-322 # 80015e18 <tickslock>
        havekids = 1;
    80001f62:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001f64:	0000ec17          	auipc	s8,0xe
    80001f68:	a1cc0c13          	addi	s8,s8,-1508 # 8000f980 <wait_lock>
    havekids = 0;
    80001f6c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f6e:	0000e497          	auipc	s1,0xe
    80001f72:	eaa48493          	addi	s1,s1,-342 # 8000fe18 <proc>
    80001f76:	a899                	j	80001fcc <kwait+0xa2>
          pid = pp->pid;
    80001f78:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001f7c:	000b0c63          	beqz	s6,80001f94 <kwait+0x6a>
    80001f80:	4691                	li	a3,4
    80001f82:	02c48613          	addi	a2,s1,44
    80001f86:	85da                	mv	a1,s6
    80001f88:	05093503          	ld	a0,80(s2)
    80001f8c:	ddcff0ef          	jal	ra,80001568 <copyout>
    80001f90:	00054f63          	bltz	a0,80001fae <kwait+0x84>
          freeproc(pp);
    80001f94:	8526                	mv	a0,s1
    80001f96:	a7bff0ef          	jal	ra,80001a10 <freeproc>
          release(&pp->lock);
    80001f9a:	8526                	mv	a0,s1
    80001f9c:	c77fe0ef          	jal	ra,80000c12 <release>
          release(&wait_lock);
    80001fa0:	0000e517          	auipc	a0,0xe
    80001fa4:	9e050513          	addi	a0,a0,-1568 # 8000f980 <wait_lock>
    80001fa8:	c6bfe0ef          	jal	ra,80000c12 <release>
          return pid;
    80001fac:	a891                	j	80002000 <kwait+0xd6>
            release(&pp->lock);
    80001fae:	8526                	mv	a0,s1
    80001fb0:	c63fe0ef          	jal	ra,80000c12 <release>
            release(&wait_lock);
    80001fb4:	0000e517          	auipc	a0,0xe
    80001fb8:	9cc50513          	addi	a0,a0,-1588 # 8000f980 <wait_lock>
    80001fbc:	c57fe0ef          	jal	ra,80000c12 <release>
            return -1;
    80001fc0:	59fd                	li	s3,-1
    80001fc2:	a83d                	j	80002000 <kwait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fc4:	18048493          	addi	s1,s1,384
    80001fc8:	03348063          	beq	s1,s3,80001fe8 <kwait+0xbe>
      if(pp->parent == p){
    80001fcc:	7c9c                	ld	a5,56(s1)
    80001fce:	ff279be3          	bne	a5,s2,80001fc4 <kwait+0x9a>
        acquire(&pp->lock);
    80001fd2:	8526                	mv	a0,s1
    80001fd4:	ba7fe0ef          	jal	ra,80000b7a <acquire>
        if(pp->state == ZOMBIE){
    80001fd8:	4c9c                	lw	a5,24(s1)
    80001fda:	f9478fe3          	beq	a5,s4,80001f78 <kwait+0x4e>
        release(&pp->lock);
    80001fde:	8526                	mv	a0,s1
    80001fe0:	c33fe0ef          	jal	ra,80000c12 <release>
        havekids = 1;
    80001fe4:	8756                	mv	a4,s5
    80001fe6:	bff9                	j	80001fc4 <kwait+0x9a>
    if(!havekids || killed(p)){
    80001fe8:	c709                	beqz	a4,80001ff2 <kwait+0xc8>
    80001fea:	854a                	mv	a0,s2
    80001fec:	f15ff0ef          	jal	ra,80001f00 <killed>
    80001ff0:	c50d                	beqz	a0,8000201a <kwait+0xf0>
      release(&wait_lock);
    80001ff2:	0000e517          	auipc	a0,0xe
    80001ff6:	98e50513          	addi	a0,a0,-1650 # 8000f980 <wait_lock>
    80001ffa:	c19fe0ef          	jal	ra,80000c12 <release>
      return -1;
    80001ffe:	59fd                	li	s3,-1
}
    80002000:	854e                	mv	a0,s3
    80002002:	60a6                	ld	ra,72(sp)
    80002004:	6406                	ld	s0,64(sp)
    80002006:	74e2                	ld	s1,56(sp)
    80002008:	7942                	ld	s2,48(sp)
    8000200a:	79a2                	ld	s3,40(sp)
    8000200c:	7a02                	ld	s4,32(sp)
    8000200e:	6ae2                	ld	s5,24(sp)
    80002010:	6b42                	ld	s6,16(sp)
    80002012:	6ba2                	ld	s7,8(sp)
    80002014:	6c02                	ld	s8,0(sp)
    80002016:	6161                	addi	sp,sp,80
    80002018:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000201a:	85e2                	mv	a1,s8
    8000201c:	854a                	mv	a0,s2
    8000201e:	ca5ff0ef          	jal	ra,80001cc2 <sleep>
    havekids = 0;
    80002022:	b7a9                	j	80001f6c <kwait+0x42>

0000000080002024 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002024:	7179                	addi	sp,sp,-48
    80002026:	f406                	sd	ra,40(sp)
    80002028:	f022                	sd	s0,32(sp)
    8000202a:	ec26                	sd	s1,24(sp)
    8000202c:	e84a                	sd	s2,16(sp)
    8000202e:	e44e                	sd	s3,8(sp)
    80002030:	e052                	sd	s4,0(sp)
    80002032:	1800                	addi	s0,sp,48
    80002034:	84aa                	mv	s1,a0
    80002036:	892e                	mv	s2,a1
    80002038:	89b2                	mv	s3,a2
    8000203a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000203c:	805ff0ef          	jal	ra,80001840 <myproc>
  if(user_dst){
    80002040:	cc99                	beqz	s1,8000205e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002042:	86d2                	mv	a3,s4
    80002044:	864e                	mv	a2,s3
    80002046:	85ca                	mv	a1,s2
    80002048:	6928                	ld	a0,80(a0)
    8000204a:	d1eff0ef          	jal	ra,80001568 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000204e:	70a2                	ld	ra,40(sp)
    80002050:	7402                	ld	s0,32(sp)
    80002052:	64e2                	ld	s1,24(sp)
    80002054:	6942                	ld	s2,16(sp)
    80002056:	69a2                	ld	s3,8(sp)
    80002058:	6a02                	ld	s4,0(sp)
    8000205a:	6145                	addi	sp,sp,48
    8000205c:	8082                	ret
    memmove((char *)dst, src, len);
    8000205e:	000a061b          	sext.w	a2,s4
    80002062:	85ce                	mv	a1,s3
    80002064:	854a                	mv	a0,s2
    80002066:	c49fe0ef          	jal	ra,80000cae <memmove>
    return 0;
    8000206a:	8526                	mv	a0,s1
    8000206c:	b7cd                	j	8000204e <either_copyout+0x2a>

000000008000206e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000206e:	7179                	addi	sp,sp,-48
    80002070:	f406                	sd	ra,40(sp)
    80002072:	f022                	sd	s0,32(sp)
    80002074:	ec26                	sd	s1,24(sp)
    80002076:	e84a                	sd	s2,16(sp)
    80002078:	e44e                	sd	s3,8(sp)
    8000207a:	e052                	sd	s4,0(sp)
    8000207c:	1800                	addi	s0,sp,48
    8000207e:	892a                	mv	s2,a0
    80002080:	84ae                	mv	s1,a1
    80002082:	89b2                	mv	s3,a2
    80002084:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002086:	fbaff0ef          	jal	ra,80001840 <myproc>
  if(user_src){
    8000208a:	cc99                	beqz	s1,800020a8 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000208c:	86d2                	mv	a3,s4
    8000208e:	864e                	mv	a2,s3
    80002090:	85ca                	mv	a1,s2
    80002092:	6928                	ld	a0,80(a0)
    80002094:	d9aff0ef          	jal	ra,8000162e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002098:	70a2                	ld	ra,40(sp)
    8000209a:	7402                	ld	s0,32(sp)
    8000209c:	64e2                	ld	s1,24(sp)
    8000209e:	6942                	ld	s2,16(sp)
    800020a0:	69a2                	ld	s3,8(sp)
    800020a2:	6a02                	ld	s4,0(sp)
    800020a4:	6145                	addi	sp,sp,48
    800020a6:	8082                	ret
    memmove(dst, (char*)src, len);
    800020a8:	000a061b          	sext.w	a2,s4
    800020ac:	85ce                	mv	a1,s3
    800020ae:	854a                	mv	a0,s2
    800020b0:	bfffe0ef          	jal	ra,80000cae <memmove>
    return 0;
    800020b4:	8526                	mv	a0,s1
    800020b6:	b7cd                	j	80002098 <either_copyin+0x2a>

00000000800020b8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800020b8:	715d                	addi	sp,sp,-80
    800020ba:	e486                	sd	ra,72(sp)
    800020bc:	e0a2                	sd	s0,64(sp)
    800020be:	fc26                	sd	s1,56(sp)
    800020c0:	f84a                	sd	s2,48(sp)
    800020c2:	f44e                	sd	s3,40(sp)
    800020c4:	f052                	sd	s4,32(sp)
    800020c6:	ec56                	sd	s5,24(sp)
    800020c8:	e85a                	sd	s6,16(sp)
    800020ca:	e45e                	sd	s7,8(sp)
    800020cc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800020ce:	00005517          	auipc	a0,0x5
    800020d2:	ff250513          	addi	a0,a0,-14 # 800070c0 <digits+0x88>
    800020d6:	bf4fe0ef          	jal	ra,800004ca <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800020da:	0000e497          	auipc	s1,0xe
    800020de:	e9648493          	addi	s1,s1,-362 # 8000ff70 <proc+0x158>
    800020e2:	00014917          	auipc	s2,0x14
    800020e6:	e8e90913          	addi	s2,s2,-370 # 80015f70 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800020ea:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800020ec:	00005997          	auipc	s3,0x5
    800020f0:	12c98993          	addi	s3,s3,300 # 80007218 <digits+0x1e0>
    printf("%d %s %s", p->pid, state, p->name);
    800020f4:	00005a97          	auipc	s5,0x5
    800020f8:	12ca8a93          	addi	s5,s5,300 # 80007220 <digits+0x1e8>
    printf("\n");
    800020fc:	00005a17          	auipc	s4,0x5
    80002100:	fc4a0a13          	addi	s4,s4,-60 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002104:	00005b97          	auipc	s7,0x5
    80002108:	15cb8b93          	addi	s7,s7,348 # 80007260 <states.1772>
    8000210c:	a829                	j	80002126 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000210e:	ed86a583          	lw	a1,-296(a3)
    80002112:	8556                	mv	a0,s5
    80002114:	bb6fe0ef          	jal	ra,800004ca <printf>
    printf("\n");
    80002118:	8552                	mv	a0,s4
    8000211a:	bb0fe0ef          	jal	ra,800004ca <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000211e:	18048493          	addi	s1,s1,384
    80002122:	03248163          	beq	s1,s2,80002144 <procdump+0x8c>
    if(p->state == UNUSED)
    80002126:	86a6                	mv	a3,s1
    80002128:	ec04a783          	lw	a5,-320(s1)
    8000212c:	dbed                	beqz	a5,8000211e <procdump+0x66>
      state = "???";
    8000212e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002130:	fcfb6fe3          	bltu	s6,a5,8000210e <procdump+0x56>
    80002134:	1782                	slli	a5,a5,0x20
    80002136:	9381                	srli	a5,a5,0x20
    80002138:	078e                	slli	a5,a5,0x3
    8000213a:	97de                	add	a5,a5,s7
    8000213c:	6390                	ld	a2,0(a5)
    8000213e:	fa61                	bnez	a2,8000210e <procdump+0x56>
      state = "???";
    80002140:	864e                	mv	a2,s3
    80002142:	b7f1                	j	8000210e <procdump+0x56>
  }
}
    80002144:	60a6                	ld	ra,72(sp)
    80002146:	6406                	ld	s0,64(sp)
    80002148:	74e2                	ld	s1,56(sp)
    8000214a:	7942                	ld	s2,48(sp)
    8000214c:	79a2                	ld	s3,40(sp)
    8000214e:	7a02                	ld	s4,32(sp)
    80002150:	6ae2                	ld	s5,24(sp)
    80002152:	6b42                	ld	s6,16(sp)
    80002154:	6ba2                	ld	s7,8(sp)
    80002156:	6161                	addi	sp,sp,80
    80002158:	8082                	ret

000000008000215a <get_time_slice>:


//Βοηθητικές Συναρτήσεις ----> Εργασία
int get_time_slice(int level){  //συνάρτηση που επιστρέφει τον αριθμό των ticks για μία προτεραιότητα
    8000215a:	1141                	addi	sp,sp,-16
    8000215c:	e422                	sd	s0,8(sp)
    8000215e:	0800                	addi	s0,sp,16
  switch(level){
    80002160:	4709                	li	a4,2
    80002162:	02e50063          	beq	a0,a4,80002182 <get_time_slice+0x28>
    80002166:	87aa                	mv	a5,a0
  case 0: return TIME_SLICE_0;
  case 1: return TIME_SLICE_1;
  case 2: return TIME_SLICE_2;
  case 3: return TIME_SLICE_3;
    80002168:	02000513          	li	a0,32
  switch(level){
    8000216c:	00f74863          	blt	a4,a5,8000217c <get_time_slice+0x22>
  case 0: return TIME_SLICE_0;
    80002170:	4511                	li	a0,4
  switch(level){
    80002172:	c789                	beqz	a5,8000217c <get_time_slice+0x22>
    80002174:	4705                	li	a4,1
    80002176:	00e79863          	bne	a5,a4,80002186 <get_time_slice+0x2c>
    8000217a:	4521                	li	a0,8
  default: return TIME_SLICE_3;
  }
}
    8000217c:	6422                	ld	s0,8(sp)
    8000217e:	0141                	addi	sp,sp,16
    80002180:	8082                	ret
  case 2: return TIME_SLICE_2;
    80002182:	4541                	li	a0,16
    80002184:	bfe5                	j	8000217c <get_time_slice+0x22>
  default: return TIME_SLICE_3;
    80002186:	02000513          	li	a0,32
    8000218a:	bfcd                	j	8000217c <get_time_slice+0x22>

000000008000218c <kfork>:
{
    8000218c:	7179                	addi	sp,sp,-48
    8000218e:	f406                	sd	ra,40(sp)
    80002190:	f022                	sd	s0,32(sp)
    80002192:	ec26                	sd	s1,24(sp)
    80002194:	e84a                	sd	s2,16(sp)
    80002196:	e44e                	sd	s3,8(sp)
    80002198:	e052                	sd	s4,0(sp)
    8000219a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000219c:	ea4ff0ef          	jal	ra,80001840 <myproc>
    800021a0:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    800021a2:	8d3ff0ef          	jal	ra,80001a74 <allocproc>
    800021a6:	10050763          	beqz	a0,800022b4 <kfork+0x128>
    800021aa:	892a                	mv	s2,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800021ac:	0489b603          	ld	a2,72(s3)
    800021b0:	692c                	ld	a1,80(a0)
    800021b2:	0509b503          	ld	a0,80(s3)
    800021b6:	9a8ff0ef          	jal	ra,8000135e <uvmcopy>
    800021ba:	06054863          	bltz	a0,8000222a <kfork+0x9e>
  np->sz = p->sz;
    800021be:	0489b783          	ld	a5,72(s3)
    800021c2:	04f93423          	sd	a5,72(s2)
  np->priority = p->priority;
    800021c6:	1689a783          	lw	a5,360(s3)
    800021ca:	16f92423          	sw	a5,360(s2)
  np->queue_level = p->queue_level;
    800021ce:	1789a503          	lw	a0,376(s3)
    800021d2:	16a92c23          	sw	a0,376(s2)
  np->timer_ticks_used = 0;
    800021d6:	16092623          	sw	zero,364(s2)
  np->wait_timer_ticks = 0;
    800021da:	16092823          	sw	zero,368(s2)
  np->max_time_slice = get_time_slice(np->queue_level); 
    800021de:	f7dff0ef          	jal	ra,8000215a <get_time_slice>
    800021e2:	16a92a23          	sw	a0,372(s2)
  np->voluntarily_yielded = 0; 
    800021e6:	16092e23          	sw	zero,380(s2)
  *(np->trapframe) = *(p->trapframe);
    800021ea:	0589b683          	ld	a3,88(s3)
    800021ee:	87b6                	mv	a5,a3
    800021f0:	05893703          	ld	a4,88(s2)
    800021f4:	12068693          	addi	a3,a3,288
    800021f8:	0007b803          	ld	a6,0(a5)
    800021fc:	6788                	ld	a0,8(a5)
    800021fe:	6b8c                	ld	a1,16(a5)
    80002200:	6f90                	ld	a2,24(a5)
    80002202:	01073023          	sd	a6,0(a4)
    80002206:	e708                	sd	a0,8(a4)
    80002208:	eb0c                	sd	a1,16(a4)
    8000220a:	ef10                	sd	a2,24(a4)
    8000220c:	02078793          	addi	a5,a5,32
    80002210:	02070713          	addi	a4,a4,32
    80002214:	fed792e3          	bne	a5,a3,800021f8 <kfork+0x6c>
  np->trapframe->a0 = 0;
    80002218:	05893783          	ld	a5,88(s2)
    8000221c:	0607b823          	sd	zero,112(a5)
    80002220:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80002224:	15000a13          	li	s4,336
    80002228:	a00d                	j	8000224a <kfork+0xbe>
    freeproc(np);
    8000222a:	854a                	mv	a0,s2
    8000222c:	fe4ff0ef          	jal	ra,80001a10 <freeproc>
    release(&np->lock);
    80002230:	854a                	mv	a0,s2
    80002232:	9e1fe0ef          	jal	ra,80000c12 <release>
    return -1;
    80002236:	5a7d                	li	s4,-1
    80002238:	a0ad                	j	800022a2 <kfork+0x116>
      np->ofile[i] = filedup(p->ofile[i]);
    8000223a:	066020ef          	jal	ra,800042a0 <filedup>
    8000223e:	009907b3          	add	a5,s2,s1
    80002242:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80002244:	04a1                	addi	s1,s1,8
    80002246:	01448763          	beq	s1,s4,80002254 <kfork+0xc8>
    if(p->ofile[i])
    8000224a:	009987b3          	add	a5,s3,s1
    8000224e:	6388                	ld	a0,0(a5)
    80002250:	f56d                	bnez	a0,8000223a <kfork+0xae>
    80002252:	bfcd                	j	80002244 <kfork+0xb8>
  np->cwd = idup(p->cwd);
    80002254:	1509b503          	ld	a0,336(s3)
    80002258:	26c010ef          	jal	ra,800034c4 <idup>
    8000225c:	14a93823          	sd	a0,336(s2)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002260:	4641                	li	a2,16
    80002262:	15898593          	addi	a1,s3,344
    80002266:	15890513          	addi	a0,s2,344
    8000226a:	b33fe0ef          	jal	ra,80000d9c <safestrcpy>
  pid = np->pid;
    8000226e:	03092a03          	lw	s4,48(s2)
  release(&np->lock);
    80002272:	854a                	mv	a0,s2
    80002274:	99ffe0ef          	jal	ra,80000c12 <release>
  acquire(&wait_lock);
    80002278:	0000d497          	auipc	s1,0xd
    8000227c:	70848493          	addi	s1,s1,1800 # 8000f980 <wait_lock>
    80002280:	8526                	mv	a0,s1
    80002282:	8f9fe0ef          	jal	ra,80000b7a <acquire>
  np->parent = p;
    80002286:	03393c23          	sd	s3,56(s2)
  release(&wait_lock);
    8000228a:	8526                	mv	a0,s1
    8000228c:	987fe0ef          	jal	ra,80000c12 <release>
  acquire(&np->lock);
    80002290:	854a                	mv	a0,s2
    80002292:	8e9fe0ef          	jal	ra,80000b7a <acquire>
  np->state = RUNNABLE;
    80002296:	478d                	li	a5,3
    80002298:	00f92c23          	sw	a5,24(s2)
  release(&np->lock);
    8000229c:	854a                	mv	a0,s2
    8000229e:	975fe0ef          	jal	ra,80000c12 <release>
}
    800022a2:	8552                	mv	a0,s4
    800022a4:	70a2                	ld	ra,40(sp)
    800022a6:	7402                	ld	s0,32(sp)
    800022a8:	64e2                	ld	s1,24(sp)
    800022aa:	6942                	ld	s2,16(sp)
    800022ac:	69a2                	ld	s3,8(sp)
    800022ae:	6a02                	ld	s4,0(sp)
    800022b0:	6145                	addi	sp,sp,48
    800022b2:	8082                	ret
    return -1;
    800022b4:	5a7d                	li	s4,-1
    800022b6:	b7f5                	j	800022a2 <kfork+0x116>

00000000800022b8 <scheduler>:
{
    800022b8:	7135                	addi	sp,sp,-160
    800022ba:	ed06                	sd	ra,152(sp)
    800022bc:	e922                	sd	s0,144(sp)
    800022be:	e526                	sd	s1,136(sp)
    800022c0:	e14a                	sd	s2,128(sp)
    800022c2:	fcce                	sd	s3,120(sp)
    800022c4:	f8d2                	sd	s4,112(sp)
    800022c6:	f4d6                	sd	s5,104(sp)
    800022c8:	f0da                	sd	s6,96(sp)
    800022ca:	ecde                	sd	s7,88(sp)
    800022cc:	e8e2                	sd	s8,80(sp)
    800022ce:	e4e6                	sd	s9,72(sp)
    800022d0:	e0ea                	sd	s10,64(sp)
    800022d2:	fc6e                	sd	s11,56(sp)
    800022d4:	1100                	addi	s0,sp,160
    800022d6:	8792                	mv	a5,tp
  int id = r_tp();
    800022d8:	2781                	sext.w	a5,a5
    800022da:	8712                	mv	a4,tp
  int *last_queued_proc = rr_state[cpuid].last_queued_proc; //το round-robin state αυτού του CPU
    800022dc:	2701                	sext.w	a4,a4
    800022de:	0712                	slli	a4,a4,0x4
    800022e0:	0000d697          	auipc	a3,0xd
    800022e4:	6b868693          	addi	a3,a3,1720 # 8000f998 <rr_state>
    800022e8:	9736                	add	a4,a4,a3
    800022ea:	f8e43023          	sd	a4,-128(s0)
  c->proc = 0;
    800022ee:	00779693          	slli	a3,a5,0x7
    800022f2:	0000d717          	auipc	a4,0xd
    800022f6:	67670713          	addi	a4,a4,1654 # 8000f968 <pid_lock>
    800022fa:	9736                	add	a4,a4,a3
    800022fc:	0a073823          	sd	zero,176(a4)
      swtch(&c->context, &chosen->context);
    80002300:	0000d717          	auipc	a4,0xd
    80002304:	72070713          	addi	a4,a4,1824 # 8000fa20 <cpus+0x8>
    80002308:	9736                	add	a4,a4,a3
    8000230a:	f6e43823          	sd	a4,-144(s0)
      if(p->state == RUNNABLE){  //μόνο αν είναι έτοιμη να τρέξει
    8000230e:	4a8d                	li	s5,3
    for(p=proc; p<&proc[NPROC]; p++){
    80002310:	00014b17          	auipc	s6,0x14
    80002314:	b08b0b13          	addi	s6,s6,-1272 # 80015e18 <tickslock>
      int checked = 0;
    80002318:	f6043c23          	sd	zero,-136(s0)
      c->proc = chosen;
    8000231c:	0000d717          	auipc	a4,0xd
    80002320:	64c70713          	addi	a4,a4,1612 # 8000f968 <pid_lock>
    80002324:	00d707b3          	add	a5,a4,a3
    80002328:	f6f43423          	sd	a5,-152(s0)
    8000232c:	aa8d                	j	8000249e <scheduler+0x1e6>
      release(&p->lock);
    8000232e:	8526                	mv	a0,s1
    80002330:	8e3fe0ef          	jal	ra,80000c12 <release>
    for(p=proc; p<&proc[NPROC]; p++){
    80002334:	18048493          	addi	s1,s1,384
    80002338:	19648663          	beq	s1,s6,800024c4 <scheduler+0x20c>
      acquire(&p->lock);
    8000233c:	8526                	mv	a0,s1
    8000233e:	83dfe0ef          	jal	ra,80000b7a <acquire>
      if(p->state == RUNNABLE){  //μόνο αν είναι έτοιμη να τρέξει
    80002342:	4c9c                	lw	a5,24(s1)
    80002344:	ff5795e3          	bne	a5,s5,8000232e <scheduler+0x76>
        p->wait_timer_ticks++;
    80002348:	1704a783          	lw	a5,368(s1)
    8000234c:	2785                	addiw	a5,a5,1
    8000234e:	0007899b          	sext.w	s3,a5
    80002352:	16f4a823          	sw	a5,368(s1)
        int level_slice = get_time_slice(p->queue_level);
    80002356:	1784a903          	lw	s2,376(s1)
    8000235a:	854a                	mv	a0,s2
    8000235c:	dffff0ef          	jal	ra,8000215a <get_time_slice>
        if(p->wait_timer_ticks >= (level_slice * PROMO_THRESHOLD) && p->queue_level > 0){ //promotion όταν περιμένει 10 φορές το time slice
    80002360:	0025179b          	slliw	a5,a0,0x2
    80002364:	9fa9                	addw	a5,a5,a0
    80002366:	0017979b          	slliw	a5,a5,0x1
    8000236a:	fcf9c2e3          	blt	s3,a5,8000232e <scheduler+0x76>
    8000236e:	fd2050e3          	blez	s2,8000232e <scheduler+0x76>
          p->queue_level--;
    80002372:	fff9051b          	addiw	a0,s2,-1
    80002376:	16a4ac23          	sw	a0,376(s1)
          p->priority = p->queue_level;
    8000237a:	16a4a423          	sw	a0,360(s1)
          p->max_time_slice = get_time_slice(p->queue_level);
    8000237e:	2501                	sext.w	a0,a0
    80002380:	ddbff0ef          	jal	ra,8000215a <get_time_slice>
    80002384:	16a4aa23          	sw	a0,372(s1)
          p->timer_ticks_used = 0;
    80002388:	1604a623          	sw	zero,364(s1)
          p->wait_timer_ticks = 0;
    8000238c:	1604a823          	sw	zero,368(s1)
    80002390:	bf79                	j	8000232e <scheduler+0x76>
        if(p->state == RUNNABLE && p->queue_level == q){
    80002392:	1784a783          	lw	a5,376(s1)
    80002396:	05a78a63          	beq	a5,s10,800023ea <scheduler+0x132>
        release(&p->lock);
    8000239a:	8526                	mv	a0,s1
    8000239c:	877fe0ef          	jal	ra,80000c12 <release>
        checked++;
    800023a0:	2985                	addiw	s3,s3,1
      while(checked < NPROC && !found){ //round-robin εντός της ουράς q
    800023a2:	153cc063          	blt	s9,s3,800024e2 <scheduler+0x22a>
        int idx = (start_index + checked) % NPROC;
    800023a6:	013c07bb          	addw	a5,s8,s3
    800023aa:	41f7d91b          	sraiw	s2,a5,0x1f
    800023ae:	01a9571b          	srliw	a4,s2,0x1a
    800023b2:	00e7893b          	addw	s2,a5,a4
    800023b6:	03f97913          	andi	s2,s2,63
    800023ba:	40e9093b          	subw	s2,s2,a4
    800023be:	00090a1b          	sext.w	s4,s2
        p = &proc[idx];
    800023c2:	001a1493          	slli	s1,s4,0x1
    800023c6:	94d2                	add	s1,s1,s4
    800023c8:	049e                	slli	s1,s1,0x7
    800023ca:	94de                	add	s1,s1,s7
        acquire(&p->lock);
    800023cc:	8526                	mv	a0,s1
    800023ce:	facfe0ef          	jal	ra,80000b7a <acquire>
        if(p->state == RUNNABLE && p->queue_level == q){
    800023d2:	4c9c                	lw	a5,24(s1)
    800023d4:	fb578fe3          	beq	a5,s5,80002392 <scheduler+0xda>
        release(&p->lock);
    800023d8:	8526                	mv	a0,s1
    800023da:	839fe0ef          	jal	ra,80000c12 <release>
        checked++;
    800023de:	2985                	addiw	s3,s3,1
      while(checked < NPROC && !found){ //round-robin εντός της ουράς q
    800023e0:	fd3cd3e3          	bge	s9,s3,800023a6 <scheduler+0xee>
    800023e4:	f8843483          	ld	s1,-120(s0)
    800023e8:	a03d                	j	80002416 <scheduler+0x15e>
          last_queued_proc[q] = (idx + 1) % NPROC;  //επόμενος για RR
    800023ea:	2905                	addiw	s2,s2,1
    800023ec:	41f9579b          	sraiw	a5,s2,0x1f
    800023f0:	01a7d79b          	srliw	a5,a5,0x1a
    800023f4:	00f9093b          	addw	s2,s2,a5
    800023f8:	03f97913          	andi	s2,s2,63
    800023fc:	40f9093b          	subw	s2,s2,a5
    80002400:	012da023          	sw	s2,0(s11)
        release(&p->lock);
    80002404:	8526                	mv	a0,s1
    80002406:	80dfe0ef          	jal	ra,80000c12 <release>
      while(checked < NPROC && !found){ //round-robin εντός της ουράς q
    8000240a:	03e00793          	li	a5,62
    8000240e:	0337d363          	bge	a5,s3,80002434 <scheduler+0x17c>
          found = 1;
    80002412:	4785                	li	a5,1
      if(found) break;
    80002414:	e385                	bnez	a5,80002434 <scheduler+0x17c>
    for(int q=0; q<NQUEUES; q++){
    80002416:	2d05                	addiw	s10,s10,1
    80002418:	01aace63          	blt	s5,s10,80002434 <scheduler+0x17c>
      int start_index = last_queued_proc[q];
    8000241c:	002d1d93          	slli	s11,s10,0x2
    80002420:	f8043783          	ld	a5,-128(s0)
    80002424:	9dbe                	add	s11,s11,a5
    80002426:	000dac03          	lw	s8,0(s11)
    8000242a:	f8943423          	sd	s1,-120(s0)
      int checked = 0;
    8000242e:	f7843983          	ld	s3,-136(s0)
    80002432:	bf95                	j	800023a6 <scheduler+0xee>
    if(chosen){
    80002434:	c4c9                	beqz	s1,800024be <scheduler+0x206>
      acquire(&chosen->lock);
    80002436:	8926                	mv	s2,s1
    80002438:	8526                	mv	a0,s1
    8000243a:	f40fe0ef          	jal	ra,80000b7a <acquire>
      chosen->state = RUNNING;
    8000243e:	4791                	li	a5,4
    80002440:	cc9c                	sw	a5,24(s1)
      chosen->voluntarily_yielded = 0;  // reset για αυτή την εκτέλεση
    80002442:	1604ae23          	sw	zero,380(s1)
      c->proc = chosen;
    80002446:	f6843983          	ld	s3,-152(s0)
    8000244a:	0a99b823          	sd	s1,176(s3)
      swtch(&c->context, &chosen->context);
    8000244e:	06048593          	addi	a1,s1,96
    80002452:	f7043503          	ld	a0,-144(s0)
    80002456:	0ea000ef          	jal	ra,80002540 <swtch>
      c->proc = 0;
    8000245a:	0a09b823          	sd	zero,176(s3)
      if(!chosen->voluntarily_yielded && has_to_demote(chosen) && chosen->queue_level < (NQUEUES - 1)){
    8000245e:	17c4a783          	lw	a5,380(s1)
    80002462:	eb9d                	bnez	a5,80002498 <scheduler+0x1e0>
    80002464:	16c4a703          	lw	a4,364(s1)
    80002468:	1744a783          	lw	a5,372(s1)
    8000246c:	02f74663          	blt	a4,a5,80002498 <scheduler+0x1e0>
    80002470:	1784a783          	lw	a5,376(s1)
    80002474:	4709                	li	a4,2
    80002476:	02f74163          	blt	a4,a5,80002498 <scheduler+0x1e0>
        chosen->queue_level++;
    8000247a:	2785                	addiw	a5,a5,1
    8000247c:	16f4ac23          	sw	a5,376(s1)
        chosen->priority = chosen->queue_level;
    80002480:	16f4a423          	sw	a5,360(s1)
        chosen->max_time_slice = get_time_slice(chosen->queue_level);
    80002484:	0007851b          	sext.w	a0,a5
    80002488:	cd3ff0ef          	jal	ra,8000215a <get_time_slice>
    8000248c:	16a4aa23          	sw	a0,372(s1)
        chosen->timer_ticks_used = 0;
    80002490:	1604a623          	sw	zero,364(s1)
        chosen->wait_timer_ticks = 0;
    80002494:	1604a823          	sw	zero,368(s1)
      release(&chosen->lock);
    80002498:	854a                	mv	a0,s2
    8000249a:	f78fe0ef          	jal	ra,80000c12 <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000249e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800024a2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024a6:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800024ae:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024b0:	10079073          	csrw	sstatus,a5
    for(p=proc; p<&proc[NPROC]; p++){
    800024b4:	0000e497          	auipc	s1,0xe
    800024b8:	96448493          	addi	s1,s1,-1692 # 8000fe18 <proc>
    800024bc:	b541                	j	8000233c <scheduler+0x84>
      asm volatile("wfi");  //wait for interrupt αν δεν υπάρχει διαθέσιμη
    800024be:	10500073          	wfi
    800024c2:	bff1                	j	8000249e <scheduler+0x1e6>
      int start_index = last_queued_proc[q];
    800024c4:	f8043d83          	ld	s11,-128(s0)
    800024c8:	000dac03          	lw	s8,0(s11)
    for(int q=0; q<NQUEUES; q++){
    800024cc:	4d01                	li	s10,0
      int checked = 0;
    800024ce:	4981                	li	s3,0
    struct proc *chosen = 0;
    800024d0:	f8043423          	sd	zero,-120(s0)
        p = &proc[idx];
    800024d4:	0000eb97          	auipc	s7,0xe
    800024d8:	944b8b93          	addi	s7,s7,-1724 # 8000fe18 <proc>
      while(checked < NPROC && !found){ //round-robin εντός της ουράς q
    800024dc:	03f00c93          	li	s9,63
    800024e0:	b5d9                	j	800023a6 <scheduler+0xee>
    800024e2:	f8843483          	ld	s1,-120(s0)
    800024e6:	f7843783          	ld	a5,-136(s0)
    800024ea:	b72d                	j	80002414 <scheduler+0x15c>

00000000800024ec <has_to_demote>:

int has_to_demote(struct proc* p){  //συνάρτηση που κάνει έλεγχο για το αν πρέπει να γίνει demotion, αν τελείωσε το time slice
    800024ec:	1141                	addi	sp,sp,-16
    800024ee:	e422                	sd	s0,8(sp)
    800024f0:	0800                	addi	s0,sp,16
  return p->timer_ticks_used >= p->max_time_slice;
    800024f2:	16c52783          	lw	a5,364(a0)
    800024f6:	17452503          	lw	a0,372(a0)
    800024fa:	00a7a533          	slt	a0,a5,a0
    800024fe:	00154513          	xori	a0,a0,1
}
    80002502:	2501                	sext.w	a0,a0
    80002504:	6422                	ld	s0,8(sp)
    80002506:	0141                	addi	sp,sp,16
    80002508:	8082                	ret

000000008000250a <has_to_promote>:

int has_to_promote(struct proc* p){ //συνάρτηση που ελέγχει για το αν πρέπει να γίνει promotion 
    8000250a:	1101                	addi	sp,sp,-32
    8000250c:	ec06                	sd	ra,24(sp)
    8000250e:	e822                	sd	s0,16(sp)
    80002510:	e426                	sd	s1,8(sp)
    80002512:	1000                	addi	s0,sp,32
    80002514:	84aa                	mv	s1,a0
  int level_slice = get_time_slice(p->queue_level);
    80002516:	17852503          	lw	a0,376(a0)
    8000251a:	c41ff0ef          	jal	ra,8000215a <get_time_slice>
  return p->wait_timer_ticks >= (level_slice * PROMO_THRESHOLD);
    8000251e:	0025179b          	slliw	a5,a0,0x2
    80002522:	9fa9                	addw	a5,a5,a0
    80002524:	1704a503          	lw	a0,368(s1)
    80002528:	0017979b          	slliw	a5,a5,0x1
    8000252c:	00f52533          	slt	a0,a0,a5
    80002530:	00154513          	xori	a0,a0,1
    80002534:	2501                	sext.w	a0,a0
    80002536:	60e2                	ld	ra,24(sp)
    80002538:	6442                	ld	s0,16(sp)
    8000253a:	64a2                	ld	s1,8(sp)
    8000253c:	6105                	addi	sp,sp,32
    8000253e:	8082                	ret

0000000080002540 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002540:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002544:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002548:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000254a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000254c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80002550:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002554:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002558:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8000255c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002560:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002564:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002568:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8000256c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002570:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002574:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002578:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8000257c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000257e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002580:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002584:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002588:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000258c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002590:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002594:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002598:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000259c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800025a0:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800025a4:	0685bd83          	ld	s11,104(a1)
        
        ret
    800025a8:	8082                	ret

00000000800025aa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025aa:	1141                	addi	sp,sp,-16
    800025ac:	e406                	sd	ra,8(sp)
    800025ae:	e022                	sd	s0,0(sp)
    800025b0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800025b2:	00005597          	auipc	a1,0x5
    800025b6:	cde58593          	addi	a1,a1,-802 # 80007290 <states.1772+0x30>
    800025ba:	00014517          	auipc	a0,0x14
    800025be:	85e50513          	addi	a0,a0,-1954 # 80015e18 <tickslock>
    800025c2:	d38fe0ef          	jal	ra,80000afa <initlock>
}
    800025c6:	60a2                	ld	ra,8(sp)
    800025c8:	6402                	ld	s0,0(sp)
    800025ca:	0141                	addi	sp,sp,16
    800025cc:	8082                	ret

00000000800025ce <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800025ce:	1141                	addi	sp,sp,-16
    800025d0:	e422                	sd	s0,8(sp)
    800025d2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025d4:	00003797          	auipc	a5,0x3
    800025d8:	fcc78793          	addi	a5,a5,-52 # 800055a0 <kernelvec>
    800025dc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800025e0:	6422                	ld	s0,8(sp)
    800025e2:	0141                	addi	sp,sp,16
    800025e4:	8082                	ret

00000000800025e6 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800025e6:	1141                	addi	sp,sp,-16
    800025e8:	e406                	sd	ra,8(sp)
    800025ea:	e022                	sd	s0,0(sp)
    800025ec:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800025ee:	a52ff0ef          	jal	ra,80001840 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800025f6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025f8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800025fc:	04000737          	lui	a4,0x4000
    80002600:	00004797          	auipc	a5,0x4
    80002604:	a0078793          	addi	a5,a5,-1536 # 80006000 <_trampoline>
    80002608:	00004697          	auipc	a3,0x4
    8000260c:	9f868693          	addi	a3,a3,-1544 # 80006000 <_trampoline>
    80002610:	8f95                	sub	a5,a5,a3
    80002612:	177d                	addi	a4,a4,-1
    80002614:	0732                	slli	a4,a4,0xc
    80002616:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002618:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000261c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000261e:	18002773          	csrr	a4,satp
    80002622:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002624:	6d38                	ld	a4,88(a0)
    80002626:	613c                	ld	a5,64(a0)
    80002628:	6685                	lui	a3,0x1
    8000262a:	97b6                	add	a5,a5,a3
    8000262c:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000262e:	6d3c                	ld	a5,88(a0)
    80002630:	00000717          	auipc	a4,0x0
    80002634:	0f470713          	addi	a4,a4,244 # 80002724 <usertrap>
    80002638:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000263a:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000263c:	8712                	mv	a4,tp
    8000263e:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002640:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002644:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002648:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000264c:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002650:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002652:	6f9c                	ld	a5,24(a5)
    80002654:	14179073          	csrw	sepc,a5
}
    80002658:	60a2                	ld	ra,8(sp)
    8000265a:	6402                	ld	s0,0(sp)
    8000265c:	0141                	addi	sp,sp,16
    8000265e:	8082                	ret

0000000080002660 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002660:	1101                	addi	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	e426                	sd	s1,8(sp)
    80002668:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000266a:	9aaff0ef          	jal	ra,80001814 <cpuid>
    8000266e:	cd19                	beqz	a0,8000268c <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002670:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002674:	000f4737          	lui	a4,0xf4
    80002678:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000267c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000267e:	14d79073          	csrw	0x14d,a5
}
    80002682:	60e2                	ld	ra,24(sp)
    80002684:	6442                	ld	s0,16(sp)
    80002686:	64a2                	ld	s1,8(sp)
    80002688:	6105                	addi	sp,sp,32
    8000268a:	8082                	ret
    acquire(&tickslock);
    8000268c:	00013497          	auipc	s1,0x13
    80002690:	78c48493          	addi	s1,s1,1932 # 80015e18 <tickslock>
    80002694:	8526                	mv	a0,s1
    80002696:	ce4fe0ef          	jal	ra,80000b7a <acquire>
    ticks++;
    8000269a:	00005517          	auipc	a0,0x5
    8000269e:	1ce50513          	addi	a0,a0,462 # 80007868 <ticks>
    800026a2:	411c                	lw	a5,0(a0)
    800026a4:	2785                	addiw	a5,a5,1
    800026a6:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800026a8:	e6cff0ef          	jal	ra,80001d14 <wakeup>
    release(&tickslock);
    800026ac:	8526                	mv	a0,s1
    800026ae:	d64fe0ef          	jal	ra,80000c12 <release>
    800026b2:	bf7d                	j	80002670 <clockintr+0x10>

00000000800026b4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800026b4:	1101                	addi	sp,sp,-32
    800026b6:	ec06                	sd	ra,24(sp)
    800026b8:	e822                	sd	s0,16(sp)
    800026ba:	e426                	sd	s1,8(sp)
    800026bc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026be:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800026c2:	57fd                	li	a5,-1
    800026c4:	17fe                	slli	a5,a5,0x3f
    800026c6:	07a5                	addi	a5,a5,9
    800026c8:	00f70d63          	beq	a4,a5,800026e2 <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800026cc:	57fd                	li	a5,-1
    800026ce:	17fe                	slli	a5,a5,0x3f
    800026d0:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800026d2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800026d4:	04f70463          	beq	a4,a5,8000271c <devintr+0x68>
  }
}
    800026d8:	60e2                	ld	ra,24(sp)
    800026da:	6442                	ld	s0,16(sp)
    800026dc:	64a2                	ld	s1,8(sp)
    800026de:	6105                	addi	sp,sp,32
    800026e0:	8082                	ret
    int irq = plic_claim();
    800026e2:	767020ef          	jal	ra,80005648 <plic_claim>
    800026e6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800026e8:	47a9                	li	a5,10
    800026ea:	02f50363          	beq	a0,a5,80002710 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    800026ee:	4785                	li	a5,1
    800026f0:	02f50363          	beq	a0,a5,80002716 <devintr+0x62>
    return 1;
    800026f4:	4505                	li	a0,1
    } else if(irq){
    800026f6:	d0ed                	beqz	s1,800026d8 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    800026f8:	85a6                	mv	a1,s1
    800026fa:	00005517          	auipc	a0,0x5
    800026fe:	b9e50513          	addi	a0,a0,-1122 # 80007298 <states.1772+0x38>
    80002702:	dc9fd0ef          	jal	ra,800004ca <printf>
      plic_complete(irq);
    80002706:	8526                	mv	a0,s1
    80002708:	761020ef          	jal	ra,80005668 <plic_complete>
    return 1;
    8000270c:	4505                	li	a0,1
    8000270e:	b7e9                	j	800026d8 <devintr+0x24>
      uartintr();
    80002710:	a52fe0ef          	jal	ra,80000962 <uartintr>
    80002714:	bfcd                	j	80002706 <devintr+0x52>
      virtio_disk_intr();
    80002716:	418030ef          	jal	ra,80005b2e <virtio_disk_intr>
    8000271a:	b7f5                	j	80002706 <devintr+0x52>
    clockintr();
    8000271c:	f45ff0ef          	jal	ra,80002660 <clockintr>
    return 2;
    80002720:	4509                	li	a0,2
    80002722:	bf5d                	j	800026d8 <devintr+0x24>

0000000080002724 <usertrap>:
{
    80002724:	1101                	addi	sp,sp,-32
    80002726:	ec06                	sd	ra,24(sp)
    80002728:	e822                	sd	s0,16(sp)
    8000272a:	e426                	sd	s1,8(sp)
    8000272c:	e04a                	sd	s2,0(sp)
    8000272e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002730:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002734:	1007f793          	andi	a5,a5,256
    80002738:	eba5                	bnez	a5,800027a8 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000273a:	00003797          	auipc	a5,0x3
    8000273e:	e6678793          	addi	a5,a5,-410 # 800055a0 <kernelvec>
    80002742:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002746:	8faff0ef          	jal	ra,80001840 <myproc>
    8000274a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000274c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000274e:	14102773          	csrr	a4,sepc
    80002752:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002754:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002758:	47a1                	li	a5,8
    8000275a:	04f70d63          	beq	a4,a5,800027b4 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    8000275e:	f57ff0ef          	jal	ra,800026b4 <devintr>
    80002762:	892a                	mv	s2,a0
    80002764:	e945                	bnez	a0,80002814 <usertrap+0xf0>
    80002766:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    8000276a:	47bd                	li	a5,15
    8000276c:	08f70863          	beq	a4,a5,800027fc <usertrap+0xd8>
    80002770:	14202773          	csrr	a4,scause
    80002774:	47b5                	li	a5,13
    80002776:	08f70363          	beq	a4,a5,800027fc <usertrap+0xd8>
    8000277a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000277e:	5890                	lw	a2,48(s1)
    80002780:	00005517          	auipc	a0,0x5
    80002784:	b5850513          	addi	a0,a0,-1192 # 800072d8 <states.1772+0x78>
    80002788:	d43fd0ef          	jal	ra,800004ca <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000278c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002790:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002794:	00005517          	auipc	a0,0x5
    80002798:	b7450513          	addi	a0,a0,-1164 # 80007308 <states.1772+0xa8>
    8000279c:	d2ffd0ef          	jal	ra,800004ca <printf>
    setkilled(p);
    800027a0:	8526                	mv	a0,s1
    800027a2:	f3aff0ef          	jal	ra,80001edc <setkilled>
    800027a6:	a035                	j	800027d2 <usertrap+0xae>
    panic("usertrap: not from user mode");
    800027a8:	00005517          	auipc	a0,0x5
    800027ac:	b1050513          	addi	a0,a0,-1264 # 800072b8 <states.1772+0x58>
    800027b0:	fe1fd0ef          	jal	ra,80000790 <panic>
    if(killed(p))
    800027b4:	f4cff0ef          	jal	ra,80001f00 <killed>
    800027b8:	ed15                	bnez	a0,800027f4 <usertrap+0xd0>
    p->trapframe->epc += 4;
    800027ba:	6cb8                	ld	a4,88(s1)
    800027bc:	6f1c                	ld	a5,24(a4)
    800027be:	0791                	addi	a5,a5,4
    800027c0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800027c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027ca:	10079073          	csrw	sstatus,a5
    syscall();
    800027ce:	268000ef          	jal	ra,80002a36 <syscall>
  if(killed(p))
    800027d2:	8526                	mv	a0,s1
    800027d4:	f2cff0ef          	jal	ra,80001f00 <killed>
    800027d8:	e139                	bnez	a0,8000281e <usertrap+0xfa>
  prepare_return();
    800027da:	e0dff0ef          	jal	ra,800025e6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800027de:	68a8                	ld	a0,80(s1)
    800027e0:	8131                	srli	a0,a0,0xc
    800027e2:	57fd                	li	a5,-1
    800027e4:	17fe                	slli	a5,a5,0x3f
    800027e6:	8d5d                	or	a0,a0,a5
}
    800027e8:	60e2                	ld	ra,24(sp)
    800027ea:	6442                	ld	s0,16(sp)
    800027ec:	64a2                	ld	s1,8(sp)
    800027ee:	6902                	ld	s2,0(sp)
    800027f0:	6105                	addi	sp,sp,32
    800027f2:	8082                	ret
      kexit(-1);
    800027f4:	557d                	li	a0,-1
    800027f6:	ddeff0ef          	jal	ra,80001dd4 <kexit>
    800027fa:	b7c1                	j	800027ba <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027fc:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002800:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002804:	164d                	addi	a2,a2,-13
    80002806:	00163613          	seqz	a2,a2
    8000280a:	68a8                	ld	a0,80(s1)
    8000280c:	cebfe0ef          	jal	ra,800014f6 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002810:	f169                	bnez	a0,800027d2 <usertrap+0xae>
    80002812:	b7a5                	j	8000277a <usertrap+0x56>
  if(killed(p))
    80002814:	8526                	mv	a0,s1
    80002816:	eeaff0ef          	jal	ra,80001f00 <killed>
    8000281a:	c511                	beqz	a0,80002826 <usertrap+0x102>
    8000281c:	a011                	j	80002820 <usertrap+0xfc>
    8000281e:	4901                	li	s2,0
    kexit(-1);
    80002820:	557d                	li	a0,-1
    80002822:	db2ff0ef          	jal	ra,80001dd4 <kexit>
  if(which_dev == 2)
    80002826:	4789                	li	a5,2
    80002828:	faf919e3          	bne	s2,a5,800027da <usertrap+0xb6>
    yield();
    8000282c:	c64ff0ef          	jal	ra,80001c90 <yield>
    80002830:	b76d                	j	800027da <usertrap+0xb6>

0000000080002832 <kerneltrap>:
{
    80002832:	7179                	addi	sp,sp,-48
    80002834:	f406                	sd	ra,40(sp)
    80002836:	f022                	sd	s0,32(sp)
    80002838:	ec26                	sd	s1,24(sp)
    8000283a:	e84a                	sd	s2,16(sp)
    8000283c:	e44e                	sd	s3,8(sp)
    8000283e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002840:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002844:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002848:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000284c:	1004f793          	andi	a5,s1,256
    80002850:	c795                	beqz	a5,8000287c <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002852:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002856:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002858:	eb85                	bnez	a5,80002888 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    8000285a:	e5bff0ef          	jal	ra,800026b4 <devintr>
    8000285e:	c91d                	beqz	a0,80002894 <kerneltrap+0x62>
  if(which_dev == 2){
    80002860:	4789                	li	a5,2
    80002862:	04f50a63          	beq	a0,a5,800028b6 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002866:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000286a:	10049073          	csrw	sstatus,s1
}
    8000286e:	70a2                	ld	ra,40(sp)
    80002870:	7402                	ld	s0,32(sp)
    80002872:	64e2                	ld	s1,24(sp)
    80002874:	6942                	ld	s2,16(sp)
    80002876:	69a2                	ld	s3,8(sp)
    80002878:	6145                	addi	sp,sp,48
    8000287a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000287c:	00005517          	auipc	a0,0x5
    80002880:	ab450513          	addi	a0,a0,-1356 # 80007330 <states.1772+0xd0>
    80002884:	f0dfd0ef          	jal	ra,80000790 <panic>
    panic("kerneltrap: interrupts enabled");
    80002888:	00005517          	auipc	a0,0x5
    8000288c:	ad050513          	addi	a0,a0,-1328 # 80007358 <states.1772+0xf8>
    80002890:	f01fd0ef          	jal	ra,80000790 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002894:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002898:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    8000289c:	85ce                	mv	a1,s3
    8000289e:	00005517          	auipc	a0,0x5
    800028a2:	ada50513          	addi	a0,a0,-1318 # 80007378 <states.1772+0x118>
    800028a6:	c25fd0ef          	jal	ra,800004ca <printf>
    panic("kerneltrap");
    800028aa:	00005517          	auipc	a0,0x5
    800028ae:	af650513          	addi	a0,a0,-1290 # 800073a0 <states.1772+0x140>
    800028b2:	edffd0ef          	jal	ra,80000790 <panic>
    struct proc *p = mycpu()->proc;
    800028b6:	f6ffe0ef          	jal	ra,80001824 <mycpu>
    800028ba:	00053983          	ld	s3,0(a0)
    if(p && p->state == RUNNING){  //μόνο αν τρέχει
    800028be:	fa0984e3          	beqz	s3,80002866 <kerneltrap+0x34>
    800028c2:	0189a703          	lw	a4,24(s3)
    800028c6:	4791                	li	a5,4
    800028c8:	f8f71fe3          	bne	a4,a5,80002866 <kerneltrap+0x34>
      acquire(&p->lock);
    800028cc:	854e                	mv	a0,s3
    800028ce:	aacfe0ef          	jal	ra,80000b7a <acquire>
      p->timer_ticks_used++;  //αυξάνουμε το demotion counter
    800028d2:	16c9a783          	lw	a5,364(s3)
    800028d6:	2785                	addiw	a5,a5,1
    800028d8:	16f9a623          	sw	a5,364(s3)
      release(&p->lock);
    800028dc:	854e                	mv	a0,s3
    800028de:	b34fe0ef          	jal	ra,80000c12 <release>
    800028e2:	b751                	j	80002866 <kerneltrap+0x34>

00000000800028e4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800028e4:	1101                	addi	sp,sp,-32
    800028e6:	ec06                	sd	ra,24(sp)
    800028e8:	e822                	sd	s0,16(sp)
    800028ea:	e426                	sd	s1,8(sp)
    800028ec:	1000                	addi	s0,sp,32
    800028ee:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800028f0:	f51fe0ef          	jal	ra,80001840 <myproc>
  switch (n) {
    800028f4:	4795                	li	a5,5
    800028f6:	0497e163          	bltu	a5,s1,80002938 <argraw+0x54>
    800028fa:	048a                	slli	s1,s1,0x2
    800028fc:	00005717          	auipc	a4,0x5
    80002900:	adc70713          	addi	a4,a4,-1316 # 800073d8 <states.1772+0x178>
    80002904:	94ba                	add	s1,s1,a4
    80002906:	409c                	lw	a5,0(s1)
    80002908:	97ba                	add	a5,a5,a4
    8000290a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000290c:	6d3c                	ld	a5,88(a0)
    8000290e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002910:	60e2                	ld	ra,24(sp)
    80002912:	6442                	ld	s0,16(sp)
    80002914:	64a2                	ld	s1,8(sp)
    80002916:	6105                	addi	sp,sp,32
    80002918:	8082                	ret
    return p->trapframe->a1;
    8000291a:	6d3c                	ld	a5,88(a0)
    8000291c:	7fa8                	ld	a0,120(a5)
    8000291e:	bfcd                	j	80002910 <argraw+0x2c>
    return p->trapframe->a2;
    80002920:	6d3c                	ld	a5,88(a0)
    80002922:	63c8                	ld	a0,128(a5)
    80002924:	b7f5                	j	80002910 <argraw+0x2c>
    return p->trapframe->a3;
    80002926:	6d3c                	ld	a5,88(a0)
    80002928:	67c8                	ld	a0,136(a5)
    8000292a:	b7dd                	j	80002910 <argraw+0x2c>
    return p->trapframe->a4;
    8000292c:	6d3c                	ld	a5,88(a0)
    8000292e:	6bc8                	ld	a0,144(a5)
    80002930:	b7c5                	j	80002910 <argraw+0x2c>
    return p->trapframe->a5;
    80002932:	6d3c                	ld	a5,88(a0)
    80002934:	6fc8                	ld	a0,152(a5)
    80002936:	bfe9                	j	80002910 <argraw+0x2c>
  panic("argraw");
    80002938:	00005517          	auipc	a0,0x5
    8000293c:	a7850513          	addi	a0,a0,-1416 # 800073b0 <states.1772+0x150>
    80002940:	e51fd0ef          	jal	ra,80000790 <panic>

0000000080002944 <fetchaddr>:
{
    80002944:	1101                	addi	sp,sp,-32
    80002946:	ec06                	sd	ra,24(sp)
    80002948:	e822                	sd	s0,16(sp)
    8000294a:	e426                	sd	s1,8(sp)
    8000294c:	e04a                	sd	s2,0(sp)
    8000294e:	1000                	addi	s0,sp,32
    80002950:	84aa                	mv	s1,a0
    80002952:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002954:	eedfe0ef          	jal	ra,80001840 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002958:	653c                	ld	a5,72(a0)
    8000295a:	02f4f663          	bgeu	s1,a5,80002986 <fetchaddr+0x42>
    8000295e:	00848713          	addi	a4,s1,8
    80002962:	02e7e463          	bltu	a5,a4,8000298a <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002966:	46a1                	li	a3,8
    80002968:	8626                	mv	a2,s1
    8000296a:	85ca                	mv	a1,s2
    8000296c:	6928                	ld	a0,80(a0)
    8000296e:	cc1fe0ef          	jal	ra,8000162e <copyin>
    80002972:	00a03533          	snez	a0,a0
    80002976:	40a00533          	neg	a0,a0
}
    8000297a:	60e2                	ld	ra,24(sp)
    8000297c:	6442                	ld	s0,16(sp)
    8000297e:	64a2                	ld	s1,8(sp)
    80002980:	6902                	ld	s2,0(sp)
    80002982:	6105                	addi	sp,sp,32
    80002984:	8082                	ret
    return -1;
    80002986:	557d                	li	a0,-1
    80002988:	bfcd                	j	8000297a <fetchaddr+0x36>
    8000298a:	557d                	li	a0,-1
    8000298c:	b7fd                	j	8000297a <fetchaddr+0x36>

000000008000298e <fetchstr>:
{
    8000298e:	7179                	addi	sp,sp,-48
    80002990:	f406                	sd	ra,40(sp)
    80002992:	f022                	sd	s0,32(sp)
    80002994:	ec26                	sd	s1,24(sp)
    80002996:	e84a                	sd	s2,16(sp)
    80002998:	e44e                	sd	s3,8(sp)
    8000299a:	1800                	addi	s0,sp,48
    8000299c:	892a                	mv	s2,a0
    8000299e:	84ae                	mv	s1,a1
    800029a0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800029a2:	e9ffe0ef          	jal	ra,80001840 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800029a6:	86ce                	mv	a3,s3
    800029a8:	864a                	mv	a2,s2
    800029aa:	85a6                	mv	a1,s1
    800029ac:	6928                	ld	a0,80(a0)
    800029ae:	a79fe0ef          	jal	ra,80001426 <copyinstr>
    800029b2:	00054c63          	bltz	a0,800029ca <fetchstr+0x3c>
  return strlen(buf);
    800029b6:	8526                	mv	a0,s1
    800029b8:	c16fe0ef          	jal	ra,80000dce <strlen>
}
    800029bc:	70a2                	ld	ra,40(sp)
    800029be:	7402                	ld	s0,32(sp)
    800029c0:	64e2                	ld	s1,24(sp)
    800029c2:	6942                	ld	s2,16(sp)
    800029c4:	69a2                	ld	s3,8(sp)
    800029c6:	6145                	addi	sp,sp,48
    800029c8:	8082                	ret
    return -1;
    800029ca:	557d                	li	a0,-1
    800029cc:	bfc5                	j	800029bc <fetchstr+0x2e>

00000000800029ce <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800029ce:	1101                	addi	sp,sp,-32
    800029d0:	ec06                	sd	ra,24(sp)
    800029d2:	e822                	sd	s0,16(sp)
    800029d4:	e426                	sd	s1,8(sp)
    800029d6:	1000                	addi	s0,sp,32
    800029d8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029da:	f0bff0ef          	jal	ra,800028e4 <argraw>
    800029de:	c088                	sw	a0,0(s1)
}
    800029e0:	60e2                	ld	ra,24(sp)
    800029e2:	6442                	ld	s0,16(sp)
    800029e4:	64a2                	ld	s1,8(sp)
    800029e6:	6105                	addi	sp,sp,32
    800029e8:	8082                	ret

00000000800029ea <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800029ea:	1101                	addi	sp,sp,-32
    800029ec:	ec06                	sd	ra,24(sp)
    800029ee:	e822                	sd	s0,16(sp)
    800029f0:	e426                	sd	s1,8(sp)
    800029f2:	1000                	addi	s0,sp,32
    800029f4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029f6:	eefff0ef          	jal	ra,800028e4 <argraw>
    800029fa:	e088                	sd	a0,0(s1)
}
    800029fc:	60e2                	ld	ra,24(sp)
    800029fe:	6442                	ld	s0,16(sp)
    80002a00:	64a2                	ld	s1,8(sp)
    80002a02:	6105                	addi	sp,sp,32
    80002a04:	8082                	ret

0000000080002a06 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002a06:	7179                	addi	sp,sp,-48
    80002a08:	f406                	sd	ra,40(sp)
    80002a0a:	f022                	sd	s0,32(sp)
    80002a0c:	ec26                	sd	s1,24(sp)
    80002a0e:	e84a                	sd	s2,16(sp)
    80002a10:	1800                	addi	s0,sp,48
    80002a12:	84ae                	mv	s1,a1
    80002a14:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002a16:	fd840593          	addi	a1,s0,-40
    80002a1a:	fd1ff0ef          	jal	ra,800029ea <argaddr>
  return fetchstr(addr, buf, max);
    80002a1e:	864a                	mv	a2,s2
    80002a20:	85a6                	mv	a1,s1
    80002a22:	fd843503          	ld	a0,-40(s0)
    80002a26:	f69ff0ef          	jal	ra,8000298e <fetchstr>
}
    80002a2a:	70a2                	ld	ra,40(sp)
    80002a2c:	7402                	ld	s0,32(sp)
    80002a2e:	64e2                	ld	s1,24(sp)
    80002a30:	6942                	ld	s2,16(sp)
    80002a32:	6145                	addi	sp,sp,48
    80002a34:	8082                	ret

0000000080002a36 <syscall>:
[SYS_getpinfo] sys_getpinfo,  //προσθήκη στο syscall table
};

void
syscall(void)
{
    80002a36:	1101                	addi	sp,sp,-32
    80002a38:	ec06                	sd	ra,24(sp)
    80002a3a:	e822                	sd	s0,16(sp)
    80002a3c:	e426                	sd	s1,8(sp)
    80002a3e:	e04a                	sd	s2,0(sp)
    80002a40:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002a42:	dfffe0ef          	jal	ra,80001840 <myproc>
    80002a46:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002a48:	05853903          	ld	s2,88(a0)
    80002a4c:	0a893783          	ld	a5,168(s2)
    80002a50:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002a54:	37fd                	addiw	a5,a5,-1
    80002a56:	4755                	li	a4,21
    80002a58:	00f76f63          	bltu	a4,a5,80002a76 <syscall+0x40>
    80002a5c:	00369713          	slli	a4,a3,0x3
    80002a60:	00005797          	auipc	a5,0x5
    80002a64:	99078793          	addi	a5,a5,-1648 # 800073f0 <syscalls>
    80002a68:	97ba                	add	a5,a5,a4
    80002a6a:	639c                	ld	a5,0(a5)
    80002a6c:	c789                	beqz	a5,80002a76 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002a6e:	9782                	jalr	a5
    80002a70:	06a93823          	sd	a0,112(s2)
    80002a74:	a829                	j	80002a8e <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002a76:	15848613          	addi	a2,s1,344
    80002a7a:	588c                	lw	a1,48(s1)
    80002a7c:	00005517          	auipc	a0,0x5
    80002a80:	93c50513          	addi	a0,a0,-1732 # 800073b8 <states.1772+0x158>
    80002a84:	a47fd0ef          	jal	ra,800004ca <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002a88:	6cbc                	ld	a5,88(s1)
    80002a8a:	577d                	li	a4,-1
    80002a8c:	fbb8                	sd	a4,112(a5)
  }
}
    80002a8e:	60e2                	ld	ra,24(sp)
    80002a90:	6442                	ld	s0,16(sp)
    80002a92:	64a2                	ld	s1,8(sp)
    80002a94:	6902                	ld	s2,0(sp)
    80002a96:	6105                	addi	sp,sp,32
    80002a98:	8082                	ret

0000000080002a9a <sys_exit>:
#include "stddef.h"
extern struct proc proc[NPROC]; 

uint64
sys_exit(void)
{
    80002a9a:	1101                	addi	sp,sp,-32
    80002a9c:	ec06                	sd	ra,24(sp)
    80002a9e:	e822                	sd	s0,16(sp)
    80002aa0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002aa2:	fec40593          	addi	a1,s0,-20
    80002aa6:	4501                	li	a0,0
    80002aa8:	f27ff0ef          	jal	ra,800029ce <argint>
  kexit(n);
    80002aac:	fec42503          	lw	a0,-20(s0)
    80002ab0:	b24ff0ef          	jal	ra,80001dd4 <kexit>
  return 0;  // not reached
}
    80002ab4:	4501                	li	a0,0
    80002ab6:	60e2                	ld	ra,24(sp)
    80002ab8:	6442                	ld	s0,16(sp)
    80002aba:	6105                	addi	sp,sp,32
    80002abc:	8082                	ret

0000000080002abe <sys_getpid>:

uint64
sys_getpid(void)
{
    80002abe:	1141                	addi	sp,sp,-16
    80002ac0:	e406                	sd	ra,8(sp)
    80002ac2:	e022                	sd	s0,0(sp)
    80002ac4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002ac6:	d7bfe0ef          	jal	ra,80001840 <myproc>
}
    80002aca:	5908                	lw	a0,48(a0)
    80002acc:	60a2                	ld	ra,8(sp)
    80002ace:	6402                	ld	s0,0(sp)
    80002ad0:	0141                	addi	sp,sp,16
    80002ad2:	8082                	ret

0000000080002ad4 <sys_fork>:

uint64
sys_fork(void)
{
    80002ad4:	1141                	addi	sp,sp,-16
    80002ad6:	e406                	sd	ra,8(sp)
    80002ad8:	e022                	sd	s0,0(sp)
    80002ada:	0800                	addi	s0,sp,16
  return kfork();
    80002adc:	eb0ff0ef          	jal	ra,8000218c <kfork>
}
    80002ae0:	60a2                	ld	ra,8(sp)
    80002ae2:	6402                	ld	s0,0(sp)
    80002ae4:	0141                	addi	sp,sp,16
    80002ae6:	8082                	ret

0000000080002ae8 <sys_wait>:

uint64
sys_wait(void)
{
    80002ae8:	1101                	addi	sp,sp,-32
    80002aea:	ec06                	sd	ra,24(sp)
    80002aec:	e822                	sd	s0,16(sp)
    80002aee:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002af0:	fe840593          	addi	a1,s0,-24
    80002af4:	4501                	li	a0,0
    80002af6:	ef5ff0ef          	jal	ra,800029ea <argaddr>
  return kwait(p);
    80002afa:	fe843503          	ld	a0,-24(s0)
    80002afe:	c2cff0ef          	jal	ra,80001f2a <kwait>
}
    80002b02:	60e2                	ld	ra,24(sp)
    80002b04:	6442                	ld	s0,16(sp)
    80002b06:	6105                	addi	sp,sp,32
    80002b08:	8082                	ret

0000000080002b0a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002b0a:	7179                	addi	sp,sp,-48
    80002b0c:	f406                	sd	ra,40(sp)
    80002b0e:	f022                	sd	s0,32(sp)
    80002b10:	ec26                	sd	s1,24(sp)
    80002b12:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002b14:	fd840593          	addi	a1,s0,-40
    80002b18:	4501                	li	a0,0
    80002b1a:	eb5ff0ef          	jal	ra,800029ce <argint>
  argint(1, &t);
    80002b1e:	fdc40593          	addi	a1,s0,-36
    80002b22:	4505                	li	a0,1
    80002b24:	eabff0ef          	jal	ra,800029ce <argint>
  addr = myproc()->sz;
    80002b28:	d19fe0ef          	jal	ra,80001840 <myproc>
    80002b2c:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80002b2e:	fdc42703          	lw	a4,-36(s0)
    80002b32:	4785                	li	a5,1
    80002b34:	02f70763          	beq	a4,a5,80002b62 <sys_sbrk+0x58>
    80002b38:	fd842783          	lw	a5,-40(s0)
    80002b3c:	0207c363          	bltz	a5,80002b62 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80002b40:	97a6                	add	a5,a5,s1
    80002b42:	0297ee63          	bltu	a5,s1,80002b7e <sys_sbrk+0x74>
      return -1;
    if(addr + n > TRAPFRAME)
    80002b46:	02000737          	lui	a4,0x2000
    80002b4a:	177d                	addi	a4,a4,-1
    80002b4c:	0736                	slli	a4,a4,0xd
    80002b4e:	02f76a63          	bltu	a4,a5,80002b82 <sys_sbrk+0x78>
      return -1;
    myproc()->sz += n;
    80002b52:	ceffe0ef          	jal	ra,80001840 <myproc>
    80002b56:	fd842703          	lw	a4,-40(s0)
    80002b5a:	653c                	ld	a5,72(a0)
    80002b5c:	97ba                	add	a5,a5,a4
    80002b5e:	e53c                	sd	a5,72(a0)
    80002b60:	a039                	j	80002b6e <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80002b62:	fd842503          	lw	a0,-40(s0)
    80002b66:	80eff0ef          	jal	ra,80001b74 <growproc>
    80002b6a:	00054863          	bltz	a0,80002b7a <sys_sbrk+0x70>
  }
  return addr;
}
    80002b6e:	8526                	mv	a0,s1
    80002b70:	70a2                	ld	ra,40(sp)
    80002b72:	7402                	ld	s0,32(sp)
    80002b74:	64e2                	ld	s1,24(sp)
    80002b76:	6145                	addi	sp,sp,48
    80002b78:	8082                	ret
      return -1;
    80002b7a:	54fd                	li	s1,-1
    80002b7c:	bfcd                	j	80002b6e <sys_sbrk+0x64>
      return -1;
    80002b7e:	54fd                	li	s1,-1
    80002b80:	b7fd                	j	80002b6e <sys_sbrk+0x64>
      return -1;
    80002b82:	54fd                	li	s1,-1
    80002b84:	b7ed                	j	80002b6e <sys_sbrk+0x64>

0000000080002b86 <sys_pause>:

uint64
sys_pause(void)
{
    80002b86:	7139                	addi	sp,sp,-64
    80002b88:	fc06                	sd	ra,56(sp)
    80002b8a:	f822                	sd	s0,48(sp)
    80002b8c:	f426                	sd	s1,40(sp)
    80002b8e:	f04a                	sd	s2,32(sp)
    80002b90:	ec4e                	sd	s3,24(sp)
    80002b92:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002b94:	fcc40593          	addi	a1,s0,-52
    80002b98:	4501                	li	a0,0
    80002b9a:	e35ff0ef          	jal	ra,800029ce <argint>
  if(n < 0)
    80002b9e:	fcc42783          	lw	a5,-52(s0)
    80002ba2:	0607c563          	bltz	a5,80002c0c <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002ba6:	00013517          	auipc	a0,0x13
    80002baa:	27250513          	addi	a0,a0,626 # 80015e18 <tickslock>
    80002bae:	fcdfd0ef          	jal	ra,80000b7a <acquire>
  ticks0 = ticks;
    80002bb2:	00005917          	auipc	s2,0x5
    80002bb6:	cb692903          	lw	s2,-842(s2) # 80007868 <ticks>
  while(ticks - ticks0 < n){
    80002bba:	fcc42783          	lw	a5,-52(s0)
    80002bbe:	cb8d                	beqz	a5,80002bf0 <sys_pause+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002bc0:	00013997          	auipc	s3,0x13
    80002bc4:	25898993          	addi	s3,s3,600 # 80015e18 <tickslock>
    80002bc8:	00005497          	auipc	s1,0x5
    80002bcc:	ca048493          	addi	s1,s1,-864 # 80007868 <ticks>
    if(killed(myproc())){
    80002bd0:	c71fe0ef          	jal	ra,80001840 <myproc>
    80002bd4:	b2cff0ef          	jal	ra,80001f00 <killed>
    80002bd8:	ed0d                	bnez	a0,80002c12 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002bda:	85ce                	mv	a1,s3
    80002bdc:	8526                	mv	a0,s1
    80002bde:	8e4ff0ef          	jal	ra,80001cc2 <sleep>
  while(ticks - ticks0 < n){
    80002be2:	409c                	lw	a5,0(s1)
    80002be4:	412787bb          	subw	a5,a5,s2
    80002be8:	fcc42703          	lw	a4,-52(s0)
    80002bec:	fee7e2e3          	bltu	a5,a4,80002bd0 <sys_pause+0x4a>
  }
  release(&tickslock);
    80002bf0:	00013517          	auipc	a0,0x13
    80002bf4:	22850513          	addi	a0,a0,552 # 80015e18 <tickslock>
    80002bf8:	81afe0ef          	jal	ra,80000c12 <release>
  return 0;
    80002bfc:	4501                	li	a0,0
}
    80002bfe:	70e2                	ld	ra,56(sp)
    80002c00:	7442                	ld	s0,48(sp)
    80002c02:	74a2                	ld	s1,40(sp)
    80002c04:	7902                	ld	s2,32(sp)
    80002c06:	69e2                	ld	s3,24(sp)
    80002c08:	6121                	addi	sp,sp,64
    80002c0a:	8082                	ret
    n = 0;
    80002c0c:	fc042623          	sw	zero,-52(s0)
    80002c10:	bf59                	j	80002ba6 <sys_pause+0x20>
      release(&tickslock);
    80002c12:	00013517          	auipc	a0,0x13
    80002c16:	20650513          	addi	a0,a0,518 # 80015e18 <tickslock>
    80002c1a:	ff9fd0ef          	jal	ra,80000c12 <release>
      return -1;
    80002c1e:	557d                	li	a0,-1
    80002c20:	bff9                	j	80002bfe <sys_pause+0x78>

0000000080002c22 <sys_kill>:

uint64
sys_kill(void)
{
    80002c22:	1101                	addi	sp,sp,-32
    80002c24:	ec06                	sd	ra,24(sp)
    80002c26:	e822                	sd	s0,16(sp)
    80002c28:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002c2a:	fec40593          	addi	a1,s0,-20
    80002c2e:	4501                	li	a0,0
    80002c30:	d9fff0ef          	jal	ra,800029ce <argint>
  return kkill(pid);
    80002c34:	fec42503          	lw	a0,-20(s0)
    80002c38:	a3eff0ef          	jal	ra,80001e76 <kkill>
}
    80002c3c:	60e2                	ld	ra,24(sp)
    80002c3e:	6442                	ld	s0,16(sp)
    80002c40:	6105                	addi	sp,sp,32
    80002c42:	8082                	ret

0000000080002c44 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002c44:	1101                	addi	sp,sp,-32
    80002c46:	ec06                	sd	ra,24(sp)
    80002c48:	e822                	sd	s0,16(sp)
    80002c4a:	e426                	sd	s1,8(sp)
    80002c4c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002c4e:	00013517          	auipc	a0,0x13
    80002c52:	1ca50513          	addi	a0,a0,458 # 80015e18 <tickslock>
    80002c56:	f25fd0ef          	jal	ra,80000b7a <acquire>
  xticks = ticks;
    80002c5a:	00005497          	auipc	s1,0x5
    80002c5e:	c0e4a483          	lw	s1,-1010(s1) # 80007868 <ticks>
  release(&tickslock);
    80002c62:	00013517          	auipc	a0,0x13
    80002c66:	1b650513          	addi	a0,a0,438 # 80015e18 <tickslock>
    80002c6a:	fa9fd0ef          	jal	ra,80000c12 <release>
  return xticks;
}
    80002c6e:	02049513          	slli	a0,s1,0x20
    80002c72:	9101                	srli	a0,a0,0x20
    80002c74:	60e2                	ld	ra,24(sp)
    80002c76:	6442                	ld	s0,16(sp)
    80002c78:	64a2                	ld	s1,8(sp)
    80002c7a:	6105                	addi	sp,sp,32
    80002c7c:	8082                	ret

0000000080002c7e <sys_getpinfo>:

// Εργασία
uint64
sys_getpinfo(void)  
{
    80002c7e:	81010113          	addi	sp,sp,-2032
    80002c82:	7e113423          	sd	ra,2024(sp)
    80002c86:	7e813023          	sd	s0,2016(sp)
    80002c8a:	7c913c23          	sd	s1,2008(sp)
    80002c8e:	7d213823          	sd	s2,2000(sp)
    80002c92:	7d313423          	sd	s3,1992(sp)
    80002c96:	7d413023          	sd	s4,1984(sp)
    80002c9a:	7b513c23          	sd	s5,1976(sp)
    80002c9e:	7b613823          	sd	s6,1968(sp)
    80002ca2:	7b713423          	sd	s7,1960(sp)
    80002ca6:	7f010413          	addi	s0,sp,2032
    80002caa:	d9010113          	addi	sp,sp,-624
  uint64 addr;
  struct pstat ps;

  argaddr(0, &addr);
    80002cae:	fa840593          	addi	a1,s0,-88
    80002cb2:	4501                	li	a0,0
    80002cb4:	d37ff0ef          	jal	ra,800029ea <argaddr>
    
  for(int i=0; i<NPROC; i++)  //αρχικοποίηση του isused
    80002cb8:	7b7d                	lui	s6,0xfffff
    80002cba:	5f8b0b13          	addi	s6,s6,1528 # fffffffffffff5f8 <end+0xffffffff7ffde400>
    80002cbe:	fb040793          	addi	a5,s0,-80
    80002cc2:	9b3e                	add	s6,s6,a5
    80002cc4:	100b0713          	addi	a4,s6,256
  argaddr(0, &addr);
    80002cc8:	87da                	mv	a5,s6
    ps.isused[i] = 0;
    80002cca:	0007a023          	sw	zero,0(a5)
  for(int i=0; i<NPROC; i++)  //αρχικοποίηση του isused
    80002cce:	0791                	addi	a5,a5,4
    80002cd0:	fee79de3          	bne	a5,a4,80002cca <sys_getpinfo+0x4c>
    80002cd4:	0000d917          	auipc	s2,0xd
    80002cd8:	14490913          	addi	s2,s2,324 # 8000fe18 <proc>
    80002cdc:	8a840a13          	addi	s4,s0,-1880
    80002ce0:	da840493          	addi	s1,s0,-600
    80002ce4:	6785                	lui	a5,0x1
    80002ce6:	90078793          	addi	a5,a5,-1792 # 900 <_entry-0x7ffff700>
    80002cea:	9b3e                	add	s6,s6,a5
  
  for(int i = 0; i < NPROC; i++){ //αντιγραφή πληροφοριών
    struct proc *p = &proc[i];
    acquire(&p->lock);
    if(p->state != UNUSED){
      ps.isused[i] = 1;
    80002cec:	4b85                	li	s7,1
    80002cee:	a835                	j	80002d2a <sys_getpinfo+0xac>
      ps.pid[i] = p->pid;
      
      if(p->parent != NULL) //αν δε υπάρχει parent αρχικοποιείται με 0
        ps.ppid[i] = p->parent->pid;
      else  
        ps.ppid[i] = 0;
    80002cf0:	a004a023          	sw	zero,-1536(s1)
      
      safestrcpy(ps.pname[i], p->name, sizeof(p->name));
    80002cf4:	4641                	li	a2,16
    80002cf6:	15890593          	addi	a1,s2,344
    80002cfa:	8552                	mv	a0,s4
    80002cfc:	8a0fe0ef          	jal	ra,80000d9c <safestrcpy>
      ps.priority[i] = p->priority;
    80002d00:	1689a783          	lw	a5,360(s3)
    80002d04:	f0faa023          	sw	a5,-256(s5)
      ps.pstate[i] = p->state;
    80002d08:	0189a783          	lw	a5,24(s3)
    80002d0c:	00faa023          	sw	a5,0(s5)
      ps.memsize[i] = p->sz;
    80002d10:	0489b783          	ld	a5,72(s3)
    80002d14:	10faa023          	sw	a5,256(s5)
      ps.priority[i] = 0;   
      ps.pstate[i] = 0;     
      ps.memsize[i] = 0;    
    }
    
    release(&p->lock);
    80002d18:	854e                	mv	a0,s3
    80002d1a:	ef9fd0ef          	jal	ra,80000c12 <release>
  for(int i = 0; i < NPROC; i++){ //αντιγραφή πληροφοριών
    80002d1e:	18090913          	addi	s2,s2,384
    80002d22:	0a41                	addi	s4,s4,16
    80002d24:	0491                	addi	s1,s1,4
    80002d26:	05648663          	beq	s1,s6,80002d72 <sys_getpinfo+0xf4>
    acquire(&p->lock);
    80002d2a:	89ca                	mv	s3,s2
    80002d2c:	854a                	mv	a0,s2
    80002d2e:	e4dfd0ef          	jal	ra,80000b7a <acquire>
    if(p->state != UNUSED){
    80002d32:	01892783          	lw	a5,24(s2)
    80002d36:	cf99                	beqz	a5,80002d54 <sys_getpinfo+0xd6>
      ps.isused[i] = 1;
    80002d38:	8aa6                	mv	s5,s1
    80002d3a:	8174a023          	sw	s7,-2048(s1)
      ps.pid[i] = p->pid;
    80002d3e:	03092783          	lw	a5,48(s2)
    80002d42:	90f4a023          	sw	a5,-1792(s1)
      if(p->parent != NULL) //αν δε υπάρχει parent αρχικοποιείται με 0
    80002d46:	03893783          	ld	a5,56(s2)
    80002d4a:	d3dd                	beqz	a5,80002cf0 <sys_getpinfo+0x72>
        ps.ppid[i] = p->parent->pid;
    80002d4c:	5b9c                	lw	a5,48(a5)
    80002d4e:	a0f4a023          	sw	a5,-1536(s1)
    80002d52:	b74d                	j	80002cf4 <sys_getpinfo+0x76>
      ps.isused[i] = 0;
    80002d54:	8004a023          	sw	zero,-2048(s1)
      ps.pid[i] = 0;        //μηδενισμός για consistency
    80002d58:	9004a023          	sw	zero,-1792(s1)
      ps.ppid[i] = 0;       
    80002d5c:	a004a023          	sw	zero,-1536(s1)
      ps.pname[i][0] = '\0';
    80002d60:	000a0023          	sb	zero,0(s4)
      ps.priority[i] = 0;   
    80002d64:	f004a023          	sw	zero,-256(s1)
      ps.pstate[i] = 0;     
    80002d68:	0004a023          	sw	zero,0(s1)
      ps.memsize[i] = 0;    
    80002d6c:	1004a023          	sw	zero,256(s1)
    80002d70:	b765                	j	80002d18 <sys_getpinfo+0x9a>
  }

  if(copyout(myproc()->pagetable, addr, (char*)&ps, sizeof(ps)) < 0)  //αντιγραφαφή στο χώρο του user
    80002d72:	acffe0ef          	jal	ra,80001840 <myproc>
    80002d76:	6685                	lui	a3,0x1
    80002d78:	a0068693          	addi	a3,a3,-1536 # a00 <_entry-0x7ffff600>
    80002d7c:	767d                	lui	a2,0xfffff
    80002d7e:	5f860613          	addi	a2,a2,1528 # fffffffffffff5f8 <end+0xffffffff7ffde400>
    80002d82:	fb040793          	addi	a5,s0,-80
    80002d86:	963e                	add	a2,a2,a5
    80002d88:	fa843583          	ld	a1,-88(s0)
    80002d8c:	6928                	ld	a0,80(a0)
    80002d8e:	fdafe0ef          	jal	ra,80001568 <copyout>
    return -1;
  
  return 0;
    80002d92:	957d                	srai	a0,a0,0x3f
    80002d94:	27010113          	addi	sp,sp,624
    80002d98:	7e813083          	ld	ra,2024(sp)
    80002d9c:	7e013403          	ld	s0,2016(sp)
    80002da0:	7d813483          	ld	s1,2008(sp)
    80002da4:	7d013903          	ld	s2,2000(sp)
    80002da8:	7c813983          	ld	s3,1992(sp)
    80002dac:	7c013a03          	ld	s4,1984(sp)
    80002db0:	7b813a83          	ld	s5,1976(sp)
    80002db4:	7b013b03          	ld	s6,1968(sp)
    80002db8:	7a813b83          	ld	s7,1960(sp)
    80002dbc:	7f010113          	addi	sp,sp,2032
    80002dc0:	8082                	ret

0000000080002dc2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002dc2:	7179                	addi	sp,sp,-48
    80002dc4:	f406                	sd	ra,40(sp)
    80002dc6:	f022                	sd	s0,32(sp)
    80002dc8:	ec26                	sd	s1,24(sp)
    80002dca:	e84a                	sd	s2,16(sp)
    80002dcc:	e44e                	sd	s3,8(sp)
    80002dce:	e052                	sd	s4,0(sp)
    80002dd0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002dd2:	00004597          	auipc	a1,0x4
    80002dd6:	6d658593          	addi	a1,a1,1750 # 800074a8 <syscalls+0xb8>
    80002dda:	00013517          	auipc	a0,0x13
    80002dde:	05650513          	addi	a0,a0,86 # 80015e30 <bcache>
    80002de2:	d19fd0ef          	jal	ra,80000afa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002de6:	0001b797          	auipc	a5,0x1b
    80002dea:	04a78793          	addi	a5,a5,74 # 8001de30 <bcache+0x8000>
    80002dee:	0001b717          	auipc	a4,0x1b
    80002df2:	2aa70713          	addi	a4,a4,682 # 8001e098 <bcache+0x8268>
    80002df6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002dfa:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002dfe:	00013497          	auipc	s1,0x13
    80002e02:	04a48493          	addi	s1,s1,74 # 80015e48 <bcache+0x18>
    b->next = bcache.head.next;
    80002e06:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e08:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e0a:	00004a17          	auipc	s4,0x4
    80002e0e:	6a6a0a13          	addi	s4,s4,1702 # 800074b0 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002e12:	2b893783          	ld	a5,696(s2)
    80002e16:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002e18:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002e1c:	85d2                	mv	a1,s4
    80002e1e:	01048513          	addi	a0,s1,16
    80002e22:	2fe010ef          	jal	ra,80004120 <initsleeplock>
    bcache.head.next->prev = b;
    80002e26:	2b893783          	ld	a5,696(s2)
    80002e2a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002e2c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e30:	45848493          	addi	s1,s1,1112
    80002e34:	fd349fe3          	bne	s1,s3,80002e12 <binit+0x50>
  }
}
    80002e38:	70a2                	ld	ra,40(sp)
    80002e3a:	7402                	ld	s0,32(sp)
    80002e3c:	64e2                	ld	s1,24(sp)
    80002e3e:	6942                	ld	s2,16(sp)
    80002e40:	69a2                	ld	s3,8(sp)
    80002e42:	6a02                	ld	s4,0(sp)
    80002e44:	6145                	addi	sp,sp,48
    80002e46:	8082                	ret

0000000080002e48 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002e48:	7179                	addi	sp,sp,-48
    80002e4a:	f406                	sd	ra,40(sp)
    80002e4c:	f022                	sd	s0,32(sp)
    80002e4e:	ec26                	sd	s1,24(sp)
    80002e50:	e84a                	sd	s2,16(sp)
    80002e52:	e44e                	sd	s3,8(sp)
    80002e54:	1800                	addi	s0,sp,48
    80002e56:	89aa                	mv	s3,a0
    80002e58:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002e5a:	00013517          	auipc	a0,0x13
    80002e5e:	fd650513          	addi	a0,a0,-42 # 80015e30 <bcache>
    80002e62:	d19fd0ef          	jal	ra,80000b7a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e66:	0001b497          	auipc	s1,0x1b
    80002e6a:	2824b483          	ld	s1,642(s1) # 8001e0e8 <bcache+0x82b8>
    80002e6e:	0001b797          	auipc	a5,0x1b
    80002e72:	22a78793          	addi	a5,a5,554 # 8001e098 <bcache+0x8268>
    80002e76:	02f48b63          	beq	s1,a5,80002eac <bread+0x64>
    80002e7a:	873e                	mv	a4,a5
    80002e7c:	a021                	j	80002e84 <bread+0x3c>
    80002e7e:	68a4                	ld	s1,80(s1)
    80002e80:	02e48663          	beq	s1,a4,80002eac <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002e84:	449c                	lw	a5,8(s1)
    80002e86:	ff379ce3          	bne	a5,s3,80002e7e <bread+0x36>
    80002e8a:	44dc                	lw	a5,12(s1)
    80002e8c:	ff2799e3          	bne	a5,s2,80002e7e <bread+0x36>
      b->refcnt++;
    80002e90:	40bc                	lw	a5,64(s1)
    80002e92:	2785                	addiw	a5,a5,1
    80002e94:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e96:	00013517          	auipc	a0,0x13
    80002e9a:	f9a50513          	addi	a0,a0,-102 # 80015e30 <bcache>
    80002e9e:	d75fd0ef          	jal	ra,80000c12 <release>
      acquiresleep(&b->lock);
    80002ea2:	01048513          	addi	a0,s1,16
    80002ea6:	2b0010ef          	jal	ra,80004156 <acquiresleep>
      return b;
    80002eaa:	a889                	j	80002efc <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002eac:	0001b497          	auipc	s1,0x1b
    80002eb0:	2344b483          	ld	s1,564(s1) # 8001e0e0 <bcache+0x82b0>
    80002eb4:	0001b797          	auipc	a5,0x1b
    80002eb8:	1e478793          	addi	a5,a5,484 # 8001e098 <bcache+0x8268>
    80002ebc:	00f48863          	beq	s1,a5,80002ecc <bread+0x84>
    80002ec0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002ec2:	40bc                	lw	a5,64(s1)
    80002ec4:	cb91                	beqz	a5,80002ed8 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ec6:	64a4                	ld	s1,72(s1)
    80002ec8:	fee49de3          	bne	s1,a4,80002ec2 <bread+0x7a>
  panic("bget: no buffers");
    80002ecc:	00004517          	auipc	a0,0x4
    80002ed0:	5ec50513          	addi	a0,a0,1516 # 800074b8 <syscalls+0xc8>
    80002ed4:	8bdfd0ef          	jal	ra,80000790 <panic>
      b->dev = dev;
    80002ed8:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002edc:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002ee0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002ee4:	4785                	li	a5,1
    80002ee6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ee8:	00013517          	auipc	a0,0x13
    80002eec:	f4850513          	addi	a0,a0,-184 # 80015e30 <bcache>
    80002ef0:	d23fd0ef          	jal	ra,80000c12 <release>
      acquiresleep(&b->lock);
    80002ef4:	01048513          	addi	a0,s1,16
    80002ef8:	25e010ef          	jal	ra,80004156 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002efc:	409c                	lw	a5,0(s1)
    80002efe:	cb89                	beqz	a5,80002f10 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f00:	8526                	mv	a0,s1
    80002f02:	70a2                	ld	ra,40(sp)
    80002f04:	7402                	ld	s0,32(sp)
    80002f06:	64e2                	ld	s1,24(sp)
    80002f08:	6942                	ld	s2,16(sp)
    80002f0a:	69a2                	ld	s3,8(sp)
    80002f0c:	6145                	addi	sp,sp,48
    80002f0e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002f10:	4581                	li	a1,0
    80002f12:	8526                	mv	a0,s1
    80002f14:	1ad020ef          	jal	ra,800058c0 <virtio_disk_rw>
    b->valid = 1;
    80002f18:	4785                	li	a5,1
    80002f1a:	c09c                	sw	a5,0(s1)
  return b;
    80002f1c:	b7d5                	j	80002f00 <bread+0xb8>

0000000080002f1e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002f1e:	1101                	addi	sp,sp,-32
    80002f20:	ec06                	sd	ra,24(sp)
    80002f22:	e822                	sd	s0,16(sp)
    80002f24:	e426                	sd	s1,8(sp)
    80002f26:	1000                	addi	s0,sp,32
    80002f28:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f2a:	0541                	addi	a0,a0,16
    80002f2c:	2a8010ef          	jal	ra,800041d4 <holdingsleep>
    80002f30:	c911                	beqz	a0,80002f44 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f32:	4585                	li	a1,1
    80002f34:	8526                	mv	a0,s1
    80002f36:	18b020ef          	jal	ra,800058c0 <virtio_disk_rw>
}
    80002f3a:	60e2                	ld	ra,24(sp)
    80002f3c:	6442                	ld	s0,16(sp)
    80002f3e:	64a2                	ld	s1,8(sp)
    80002f40:	6105                	addi	sp,sp,32
    80002f42:	8082                	ret
    panic("bwrite");
    80002f44:	00004517          	auipc	a0,0x4
    80002f48:	58c50513          	addi	a0,a0,1420 # 800074d0 <syscalls+0xe0>
    80002f4c:	845fd0ef          	jal	ra,80000790 <panic>

0000000080002f50 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f50:	1101                	addi	sp,sp,-32
    80002f52:	ec06                	sd	ra,24(sp)
    80002f54:	e822                	sd	s0,16(sp)
    80002f56:	e426                	sd	s1,8(sp)
    80002f58:	e04a                	sd	s2,0(sp)
    80002f5a:	1000                	addi	s0,sp,32
    80002f5c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f5e:	01050913          	addi	s2,a0,16
    80002f62:	854a                	mv	a0,s2
    80002f64:	270010ef          	jal	ra,800041d4 <holdingsleep>
    80002f68:	c13d                	beqz	a0,80002fce <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002f6a:	854a                	mv	a0,s2
    80002f6c:	230010ef          	jal	ra,8000419c <releasesleep>

  acquire(&bcache.lock);
    80002f70:	00013517          	auipc	a0,0x13
    80002f74:	ec050513          	addi	a0,a0,-320 # 80015e30 <bcache>
    80002f78:	c03fd0ef          	jal	ra,80000b7a <acquire>
  b->refcnt--;
    80002f7c:	40bc                	lw	a5,64(s1)
    80002f7e:	37fd                	addiw	a5,a5,-1
    80002f80:	0007871b          	sext.w	a4,a5
    80002f84:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f86:	eb05                	bnez	a4,80002fb6 <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f88:	68bc                	ld	a5,80(s1)
    80002f8a:	64b8                	ld	a4,72(s1)
    80002f8c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002f8e:	64bc                	ld	a5,72(s1)
    80002f90:	68b8                	ld	a4,80(s1)
    80002f92:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f94:	0001b797          	auipc	a5,0x1b
    80002f98:	e9c78793          	addi	a5,a5,-356 # 8001de30 <bcache+0x8000>
    80002f9c:	2b87b703          	ld	a4,696(a5)
    80002fa0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002fa2:	0001b717          	auipc	a4,0x1b
    80002fa6:	0f670713          	addi	a4,a4,246 # 8001e098 <bcache+0x8268>
    80002faa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002fac:	2b87b703          	ld	a4,696(a5)
    80002fb0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002fb2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002fb6:	00013517          	auipc	a0,0x13
    80002fba:	e7a50513          	addi	a0,a0,-390 # 80015e30 <bcache>
    80002fbe:	c55fd0ef          	jal	ra,80000c12 <release>
}
    80002fc2:	60e2                	ld	ra,24(sp)
    80002fc4:	6442                	ld	s0,16(sp)
    80002fc6:	64a2                	ld	s1,8(sp)
    80002fc8:	6902                	ld	s2,0(sp)
    80002fca:	6105                	addi	sp,sp,32
    80002fcc:	8082                	ret
    panic("brelse");
    80002fce:	00004517          	auipc	a0,0x4
    80002fd2:	50a50513          	addi	a0,a0,1290 # 800074d8 <syscalls+0xe8>
    80002fd6:	fbafd0ef          	jal	ra,80000790 <panic>

0000000080002fda <bpin>:

void
bpin(struct buf *b) {
    80002fda:	1101                	addi	sp,sp,-32
    80002fdc:	ec06                	sd	ra,24(sp)
    80002fde:	e822                	sd	s0,16(sp)
    80002fe0:	e426                	sd	s1,8(sp)
    80002fe2:	1000                	addi	s0,sp,32
    80002fe4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fe6:	00013517          	auipc	a0,0x13
    80002fea:	e4a50513          	addi	a0,a0,-438 # 80015e30 <bcache>
    80002fee:	b8dfd0ef          	jal	ra,80000b7a <acquire>
  b->refcnt++;
    80002ff2:	40bc                	lw	a5,64(s1)
    80002ff4:	2785                	addiw	a5,a5,1
    80002ff6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ff8:	00013517          	auipc	a0,0x13
    80002ffc:	e3850513          	addi	a0,a0,-456 # 80015e30 <bcache>
    80003000:	c13fd0ef          	jal	ra,80000c12 <release>
}
    80003004:	60e2                	ld	ra,24(sp)
    80003006:	6442                	ld	s0,16(sp)
    80003008:	64a2                	ld	s1,8(sp)
    8000300a:	6105                	addi	sp,sp,32
    8000300c:	8082                	ret

000000008000300e <bunpin>:

void
bunpin(struct buf *b) {
    8000300e:	1101                	addi	sp,sp,-32
    80003010:	ec06                	sd	ra,24(sp)
    80003012:	e822                	sd	s0,16(sp)
    80003014:	e426                	sd	s1,8(sp)
    80003016:	1000                	addi	s0,sp,32
    80003018:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000301a:	00013517          	auipc	a0,0x13
    8000301e:	e1650513          	addi	a0,a0,-490 # 80015e30 <bcache>
    80003022:	b59fd0ef          	jal	ra,80000b7a <acquire>
  b->refcnt--;
    80003026:	40bc                	lw	a5,64(s1)
    80003028:	37fd                	addiw	a5,a5,-1
    8000302a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000302c:	00013517          	auipc	a0,0x13
    80003030:	e0450513          	addi	a0,a0,-508 # 80015e30 <bcache>
    80003034:	bdffd0ef          	jal	ra,80000c12 <release>
}
    80003038:	60e2                	ld	ra,24(sp)
    8000303a:	6442                	ld	s0,16(sp)
    8000303c:	64a2                	ld	s1,8(sp)
    8000303e:	6105                	addi	sp,sp,32
    80003040:	8082                	ret

0000000080003042 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003042:	1101                	addi	sp,sp,-32
    80003044:	ec06                	sd	ra,24(sp)
    80003046:	e822                	sd	s0,16(sp)
    80003048:	e426                	sd	s1,8(sp)
    8000304a:	e04a                	sd	s2,0(sp)
    8000304c:	1000                	addi	s0,sp,32
    8000304e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003050:	00d5d59b          	srliw	a1,a1,0xd
    80003054:	0001b797          	auipc	a5,0x1b
    80003058:	4b87a783          	lw	a5,1208(a5) # 8001e50c <sb+0x1c>
    8000305c:	9dbd                	addw	a1,a1,a5
    8000305e:	debff0ef          	jal	ra,80002e48 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003062:	0074f713          	andi	a4,s1,7
    80003066:	4785                	li	a5,1
    80003068:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000306c:	14ce                	slli	s1,s1,0x33
    8000306e:	90d9                	srli	s1,s1,0x36
    80003070:	00950733          	add	a4,a0,s1
    80003074:	05874703          	lbu	a4,88(a4)
    80003078:	00e7f6b3          	and	a3,a5,a4
    8000307c:	c29d                	beqz	a3,800030a2 <bfree+0x60>
    8000307e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003080:	94aa                	add	s1,s1,a0
    80003082:	fff7c793          	not	a5,a5
    80003086:	8ff9                	and	a5,a5,a4
    80003088:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000308c:	7d1000ef          	jal	ra,8000405c <log_write>
  brelse(bp);
    80003090:	854a                	mv	a0,s2
    80003092:	ebfff0ef          	jal	ra,80002f50 <brelse>
}
    80003096:	60e2                	ld	ra,24(sp)
    80003098:	6442                	ld	s0,16(sp)
    8000309a:	64a2                	ld	s1,8(sp)
    8000309c:	6902                	ld	s2,0(sp)
    8000309e:	6105                	addi	sp,sp,32
    800030a0:	8082                	ret
    panic("freeing free block");
    800030a2:	00004517          	auipc	a0,0x4
    800030a6:	43e50513          	addi	a0,a0,1086 # 800074e0 <syscalls+0xf0>
    800030aa:	ee6fd0ef          	jal	ra,80000790 <panic>

00000000800030ae <balloc>:
{
    800030ae:	711d                	addi	sp,sp,-96
    800030b0:	ec86                	sd	ra,88(sp)
    800030b2:	e8a2                	sd	s0,80(sp)
    800030b4:	e4a6                	sd	s1,72(sp)
    800030b6:	e0ca                	sd	s2,64(sp)
    800030b8:	fc4e                	sd	s3,56(sp)
    800030ba:	f852                	sd	s4,48(sp)
    800030bc:	f456                	sd	s5,40(sp)
    800030be:	f05a                	sd	s6,32(sp)
    800030c0:	ec5e                	sd	s7,24(sp)
    800030c2:	e862                	sd	s8,16(sp)
    800030c4:	e466                	sd	s9,8(sp)
    800030c6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030c8:	0001b797          	auipc	a5,0x1b
    800030cc:	42c7a783          	lw	a5,1068(a5) # 8001e4f4 <sb+0x4>
    800030d0:	0e078163          	beqz	a5,800031b2 <balloc+0x104>
    800030d4:	8baa                	mv	s7,a0
    800030d6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030d8:	0001bb17          	auipc	s6,0x1b
    800030dc:	418b0b13          	addi	s6,s6,1048 # 8001e4f0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030e0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030e2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030e4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030e6:	6c89                	lui	s9,0x2
    800030e8:	a0b5                	j	80003154 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800030ea:	974a                	add	a4,a4,s2
    800030ec:	8fd5                	or	a5,a5,a3
    800030ee:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800030f2:	854a                	mv	a0,s2
    800030f4:	769000ef          	jal	ra,8000405c <log_write>
        brelse(bp);
    800030f8:	854a                	mv	a0,s2
    800030fa:	e57ff0ef          	jal	ra,80002f50 <brelse>
  bp = bread(dev, bno);
    800030fe:	85a6                	mv	a1,s1
    80003100:	855e                	mv	a0,s7
    80003102:	d47ff0ef          	jal	ra,80002e48 <bread>
    80003106:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003108:	40000613          	li	a2,1024
    8000310c:	4581                	li	a1,0
    8000310e:	05850513          	addi	a0,a0,88
    80003112:	b3dfd0ef          	jal	ra,80000c4e <memset>
  log_write(bp);
    80003116:	854a                	mv	a0,s2
    80003118:	745000ef          	jal	ra,8000405c <log_write>
  brelse(bp);
    8000311c:	854a                	mv	a0,s2
    8000311e:	e33ff0ef          	jal	ra,80002f50 <brelse>
}
    80003122:	8526                	mv	a0,s1
    80003124:	60e6                	ld	ra,88(sp)
    80003126:	6446                	ld	s0,80(sp)
    80003128:	64a6                	ld	s1,72(sp)
    8000312a:	6906                	ld	s2,64(sp)
    8000312c:	79e2                	ld	s3,56(sp)
    8000312e:	7a42                	ld	s4,48(sp)
    80003130:	7aa2                	ld	s5,40(sp)
    80003132:	7b02                	ld	s6,32(sp)
    80003134:	6be2                	ld	s7,24(sp)
    80003136:	6c42                	ld	s8,16(sp)
    80003138:	6ca2                	ld	s9,8(sp)
    8000313a:	6125                	addi	sp,sp,96
    8000313c:	8082                	ret
    brelse(bp);
    8000313e:	854a                	mv	a0,s2
    80003140:	e11ff0ef          	jal	ra,80002f50 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003144:	015c87bb          	addw	a5,s9,s5
    80003148:	00078a9b          	sext.w	s5,a5
    8000314c:	004b2703          	lw	a4,4(s6)
    80003150:	06eaf163          	bgeu	s5,a4,800031b2 <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80003154:	41fad79b          	sraiw	a5,s5,0x1f
    80003158:	0137d79b          	srliw	a5,a5,0x13
    8000315c:	015787bb          	addw	a5,a5,s5
    80003160:	40d7d79b          	sraiw	a5,a5,0xd
    80003164:	01cb2583          	lw	a1,28(s6)
    80003168:	9dbd                	addw	a1,a1,a5
    8000316a:	855e                	mv	a0,s7
    8000316c:	cddff0ef          	jal	ra,80002e48 <bread>
    80003170:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003172:	004b2503          	lw	a0,4(s6)
    80003176:	000a849b          	sext.w	s1,s5
    8000317a:	8662                	mv	a2,s8
    8000317c:	fca4f1e3          	bgeu	s1,a0,8000313e <balloc+0x90>
      m = 1 << (bi % 8);
    80003180:	41f6579b          	sraiw	a5,a2,0x1f
    80003184:	01d7d69b          	srliw	a3,a5,0x1d
    80003188:	00c6873b          	addw	a4,a3,a2
    8000318c:	00777793          	andi	a5,a4,7
    80003190:	9f95                	subw	a5,a5,a3
    80003192:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003196:	4037571b          	sraiw	a4,a4,0x3
    8000319a:	00e906b3          	add	a3,s2,a4
    8000319e:	0586c683          	lbu	a3,88(a3)
    800031a2:	00d7f5b3          	and	a1,a5,a3
    800031a6:	d1b1                	beqz	a1,800030ea <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031a8:	2605                	addiw	a2,a2,1
    800031aa:	2485                	addiw	s1,s1,1
    800031ac:	fd4618e3          	bne	a2,s4,8000317c <balloc+0xce>
    800031b0:	b779                	j	8000313e <balloc+0x90>
  printf("balloc: out of blocks\n");
    800031b2:	00004517          	auipc	a0,0x4
    800031b6:	34650513          	addi	a0,a0,838 # 800074f8 <syscalls+0x108>
    800031ba:	b10fd0ef          	jal	ra,800004ca <printf>
  return 0;
    800031be:	4481                	li	s1,0
    800031c0:	b78d                	j	80003122 <balloc+0x74>

00000000800031c2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800031c2:	7179                	addi	sp,sp,-48
    800031c4:	f406                	sd	ra,40(sp)
    800031c6:	f022                	sd	s0,32(sp)
    800031c8:	ec26                	sd	s1,24(sp)
    800031ca:	e84a                	sd	s2,16(sp)
    800031cc:	e44e                	sd	s3,8(sp)
    800031ce:	e052                	sd	s4,0(sp)
    800031d0:	1800                	addi	s0,sp,48
    800031d2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800031d4:	47ad                	li	a5,11
    800031d6:	02b7e563          	bltu	a5,a1,80003200 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800031da:	02059493          	slli	s1,a1,0x20
    800031de:	9081                	srli	s1,s1,0x20
    800031e0:	048a                	slli	s1,s1,0x2
    800031e2:	94aa                	add	s1,s1,a0
    800031e4:	0504a903          	lw	s2,80(s1)
    800031e8:	06091663          	bnez	s2,80003254 <bmap+0x92>
      addr = balloc(ip->dev);
    800031ec:	4108                	lw	a0,0(a0)
    800031ee:	ec1ff0ef          	jal	ra,800030ae <balloc>
    800031f2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800031f6:	04090f63          	beqz	s2,80003254 <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    800031fa:	0524a823          	sw	s2,80(s1)
    800031fe:	a899                	j	80003254 <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003200:	ff45849b          	addiw	s1,a1,-12
    80003204:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003208:	0ff00793          	li	a5,255
    8000320c:	06e7eb63          	bltu	a5,a4,80003282 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003210:	08052903          	lw	s2,128(a0)
    80003214:	00091b63          	bnez	s2,8000322a <bmap+0x68>
      addr = balloc(ip->dev);
    80003218:	4108                	lw	a0,0(a0)
    8000321a:	e95ff0ef          	jal	ra,800030ae <balloc>
    8000321e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003222:	02090963          	beqz	s2,80003254 <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003226:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000322a:	85ca                	mv	a1,s2
    8000322c:	0009a503          	lw	a0,0(s3)
    80003230:	c19ff0ef          	jal	ra,80002e48 <bread>
    80003234:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003236:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000323a:	02049593          	slli	a1,s1,0x20
    8000323e:	9181                	srli	a1,a1,0x20
    80003240:	058a                	slli	a1,a1,0x2
    80003242:	00b784b3          	add	s1,a5,a1
    80003246:	0004a903          	lw	s2,0(s1)
    8000324a:	00090e63          	beqz	s2,80003266 <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000324e:	8552                	mv	a0,s4
    80003250:	d01ff0ef          	jal	ra,80002f50 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003254:	854a                	mv	a0,s2
    80003256:	70a2                	ld	ra,40(sp)
    80003258:	7402                	ld	s0,32(sp)
    8000325a:	64e2                	ld	s1,24(sp)
    8000325c:	6942                	ld	s2,16(sp)
    8000325e:	69a2                	ld	s3,8(sp)
    80003260:	6a02                	ld	s4,0(sp)
    80003262:	6145                	addi	sp,sp,48
    80003264:	8082                	ret
      addr = balloc(ip->dev);
    80003266:	0009a503          	lw	a0,0(s3)
    8000326a:	e45ff0ef          	jal	ra,800030ae <balloc>
    8000326e:	0005091b          	sext.w	s2,a0
      if(addr){
    80003272:	fc090ee3          	beqz	s2,8000324e <bmap+0x8c>
        a[bn] = addr;
    80003276:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000327a:	8552                	mv	a0,s4
    8000327c:	5e1000ef          	jal	ra,8000405c <log_write>
    80003280:	b7f9                	j	8000324e <bmap+0x8c>
  panic("bmap: out of range");
    80003282:	00004517          	auipc	a0,0x4
    80003286:	28e50513          	addi	a0,a0,654 # 80007510 <syscalls+0x120>
    8000328a:	d06fd0ef          	jal	ra,80000790 <panic>

000000008000328e <iget>:
{
    8000328e:	7179                	addi	sp,sp,-48
    80003290:	f406                	sd	ra,40(sp)
    80003292:	f022                	sd	s0,32(sp)
    80003294:	ec26                	sd	s1,24(sp)
    80003296:	e84a                	sd	s2,16(sp)
    80003298:	e44e                	sd	s3,8(sp)
    8000329a:	e052                	sd	s4,0(sp)
    8000329c:	1800                	addi	s0,sp,48
    8000329e:	89aa                	mv	s3,a0
    800032a0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800032a2:	0001b517          	auipc	a0,0x1b
    800032a6:	26e50513          	addi	a0,a0,622 # 8001e510 <itable>
    800032aa:	8d1fd0ef          	jal	ra,80000b7a <acquire>
  empty = 0;
    800032ae:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800032b0:	0001b497          	auipc	s1,0x1b
    800032b4:	27848493          	addi	s1,s1,632 # 8001e528 <itable+0x18>
    800032b8:	0001d697          	auipc	a3,0x1d
    800032bc:	d0068693          	addi	a3,a3,-768 # 8001ffb8 <log>
    800032c0:	a039                	j	800032ce <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032c2:	02090963          	beqz	s2,800032f4 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800032c6:	08848493          	addi	s1,s1,136
    800032ca:	02d48863          	beq	s1,a3,800032fa <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800032ce:	449c                	lw	a5,8(s1)
    800032d0:	fef059e3          	blez	a5,800032c2 <iget+0x34>
    800032d4:	4098                	lw	a4,0(s1)
    800032d6:	ff3716e3          	bne	a4,s3,800032c2 <iget+0x34>
    800032da:	40d8                	lw	a4,4(s1)
    800032dc:	ff4713e3          	bne	a4,s4,800032c2 <iget+0x34>
      ip->ref++;
    800032e0:	2785                	addiw	a5,a5,1
    800032e2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800032e4:	0001b517          	auipc	a0,0x1b
    800032e8:	22c50513          	addi	a0,a0,556 # 8001e510 <itable>
    800032ec:	927fd0ef          	jal	ra,80000c12 <release>
      return ip;
    800032f0:	8926                	mv	s2,s1
    800032f2:	a02d                	j	8000331c <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032f4:	fbe9                	bnez	a5,800032c6 <iget+0x38>
    800032f6:	8926                	mv	s2,s1
    800032f8:	b7f9                	j	800032c6 <iget+0x38>
  if(empty == 0)
    800032fa:	02090a63          	beqz	s2,8000332e <iget+0xa0>
  ip->dev = dev;
    800032fe:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003302:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003306:	4785                	li	a5,1
    80003308:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000330c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003310:	0001b517          	auipc	a0,0x1b
    80003314:	20050513          	addi	a0,a0,512 # 8001e510 <itable>
    80003318:	8fbfd0ef          	jal	ra,80000c12 <release>
}
    8000331c:	854a                	mv	a0,s2
    8000331e:	70a2                	ld	ra,40(sp)
    80003320:	7402                	ld	s0,32(sp)
    80003322:	64e2                	ld	s1,24(sp)
    80003324:	6942                	ld	s2,16(sp)
    80003326:	69a2                	ld	s3,8(sp)
    80003328:	6a02                	ld	s4,0(sp)
    8000332a:	6145                	addi	sp,sp,48
    8000332c:	8082                	ret
    panic("iget: no inodes");
    8000332e:	00004517          	auipc	a0,0x4
    80003332:	1fa50513          	addi	a0,a0,506 # 80007528 <syscalls+0x138>
    80003336:	c5afd0ef          	jal	ra,80000790 <panic>

000000008000333a <iinit>:
{
    8000333a:	7179                	addi	sp,sp,-48
    8000333c:	f406                	sd	ra,40(sp)
    8000333e:	f022                	sd	s0,32(sp)
    80003340:	ec26                	sd	s1,24(sp)
    80003342:	e84a                	sd	s2,16(sp)
    80003344:	e44e                	sd	s3,8(sp)
    80003346:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003348:	00004597          	auipc	a1,0x4
    8000334c:	1f058593          	addi	a1,a1,496 # 80007538 <syscalls+0x148>
    80003350:	0001b517          	auipc	a0,0x1b
    80003354:	1c050513          	addi	a0,a0,448 # 8001e510 <itable>
    80003358:	fa2fd0ef          	jal	ra,80000afa <initlock>
  for(i = 0; i < NINODE; i++) {
    8000335c:	0001b497          	auipc	s1,0x1b
    80003360:	1dc48493          	addi	s1,s1,476 # 8001e538 <itable+0x28>
    80003364:	0001d997          	auipc	s3,0x1d
    80003368:	c6498993          	addi	s3,s3,-924 # 8001ffc8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000336c:	00004917          	auipc	s2,0x4
    80003370:	1d490913          	addi	s2,s2,468 # 80007540 <syscalls+0x150>
    80003374:	85ca                	mv	a1,s2
    80003376:	8526                	mv	a0,s1
    80003378:	5a9000ef          	jal	ra,80004120 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000337c:	08848493          	addi	s1,s1,136
    80003380:	ff349ae3          	bne	s1,s3,80003374 <iinit+0x3a>
}
    80003384:	70a2                	ld	ra,40(sp)
    80003386:	7402                	ld	s0,32(sp)
    80003388:	64e2                	ld	s1,24(sp)
    8000338a:	6942                	ld	s2,16(sp)
    8000338c:	69a2                	ld	s3,8(sp)
    8000338e:	6145                	addi	sp,sp,48
    80003390:	8082                	ret

0000000080003392 <ialloc>:
{
    80003392:	715d                	addi	sp,sp,-80
    80003394:	e486                	sd	ra,72(sp)
    80003396:	e0a2                	sd	s0,64(sp)
    80003398:	fc26                	sd	s1,56(sp)
    8000339a:	f84a                	sd	s2,48(sp)
    8000339c:	f44e                	sd	s3,40(sp)
    8000339e:	f052                	sd	s4,32(sp)
    800033a0:	ec56                	sd	s5,24(sp)
    800033a2:	e85a                	sd	s6,16(sp)
    800033a4:	e45e                	sd	s7,8(sp)
    800033a6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800033a8:	0001b717          	auipc	a4,0x1b
    800033ac:	15472703          	lw	a4,340(a4) # 8001e4fc <sb+0xc>
    800033b0:	4785                	li	a5,1
    800033b2:	04e7f663          	bgeu	a5,a4,800033fe <ialloc+0x6c>
    800033b6:	8aaa                	mv	s5,a0
    800033b8:	8bae                	mv	s7,a1
    800033ba:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800033bc:	0001ba17          	auipc	s4,0x1b
    800033c0:	134a0a13          	addi	s4,s4,308 # 8001e4f0 <sb>
    800033c4:	00048b1b          	sext.w	s6,s1
    800033c8:	0044d593          	srli	a1,s1,0x4
    800033cc:	018a2783          	lw	a5,24(s4)
    800033d0:	9dbd                	addw	a1,a1,a5
    800033d2:	8556                	mv	a0,s5
    800033d4:	a75ff0ef          	jal	ra,80002e48 <bread>
    800033d8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800033da:	05850993          	addi	s3,a0,88
    800033de:	00f4f793          	andi	a5,s1,15
    800033e2:	079a                	slli	a5,a5,0x6
    800033e4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800033e6:	00099783          	lh	a5,0(s3)
    800033ea:	cf85                	beqz	a5,80003422 <ialloc+0x90>
    brelse(bp);
    800033ec:	b65ff0ef          	jal	ra,80002f50 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800033f0:	0485                	addi	s1,s1,1
    800033f2:	00ca2703          	lw	a4,12(s4)
    800033f6:	0004879b          	sext.w	a5,s1
    800033fa:	fce7e5e3          	bltu	a5,a4,800033c4 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800033fe:	00004517          	auipc	a0,0x4
    80003402:	14a50513          	addi	a0,a0,330 # 80007548 <syscalls+0x158>
    80003406:	8c4fd0ef          	jal	ra,800004ca <printf>
  return 0;
    8000340a:	4501                	li	a0,0
}
    8000340c:	60a6                	ld	ra,72(sp)
    8000340e:	6406                	ld	s0,64(sp)
    80003410:	74e2                	ld	s1,56(sp)
    80003412:	7942                	ld	s2,48(sp)
    80003414:	79a2                	ld	s3,40(sp)
    80003416:	7a02                	ld	s4,32(sp)
    80003418:	6ae2                	ld	s5,24(sp)
    8000341a:	6b42                	ld	s6,16(sp)
    8000341c:	6ba2                	ld	s7,8(sp)
    8000341e:	6161                	addi	sp,sp,80
    80003420:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003422:	04000613          	li	a2,64
    80003426:	4581                	li	a1,0
    80003428:	854e                	mv	a0,s3
    8000342a:	825fd0ef          	jal	ra,80000c4e <memset>
      dip->type = type;
    8000342e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003432:	854a                	mv	a0,s2
    80003434:	429000ef          	jal	ra,8000405c <log_write>
      brelse(bp);
    80003438:	854a                	mv	a0,s2
    8000343a:	b17ff0ef          	jal	ra,80002f50 <brelse>
      return iget(dev, inum);
    8000343e:	85da                	mv	a1,s6
    80003440:	8556                	mv	a0,s5
    80003442:	e4dff0ef          	jal	ra,8000328e <iget>
    80003446:	b7d9                	j	8000340c <ialloc+0x7a>

0000000080003448 <iupdate>:
{
    80003448:	1101                	addi	sp,sp,-32
    8000344a:	ec06                	sd	ra,24(sp)
    8000344c:	e822                	sd	s0,16(sp)
    8000344e:	e426                	sd	s1,8(sp)
    80003450:	e04a                	sd	s2,0(sp)
    80003452:	1000                	addi	s0,sp,32
    80003454:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003456:	415c                	lw	a5,4(a0)
    80003458:	0047d79b          	srliw	a5,a5,0x4
    8000345c:	0001b597          	auipc	a1,0x1b
    80003460:	0ac5a583          	lw	a1,172(a1) # 8001e508 <sb+0x18>
    80003464:	9dbd                	addw	a1,a1,a5
    80003466:	4108                	lw	a0,0(a0)
    80003468:	9e1ff0ef          	jal	ra,80002e48 <bread>
    8000346c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000346e:	05850793          	addi	a5,a0,88
    80003472:	40c8                	lw	a0,4(s1)
    80003474:	893d                	andi	a0,a0,15
    80003476:	051a                	slli	a0,a0,0x6
    80003478:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000347a:	04449703          	lh	a4,68(s1)
    8000347e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003482:	04649703          	lh	a4,70(s1)
    80003486:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000348a:	04849703          	lh	a4,72(s1)
    8000348e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003492:	04a49703          	lh	a4,74(s1)
    80003496:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000349a:	44f8                	lw	a4,76(s1)
    8000349c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000349e:	03400613          	li	a2,52
    800034a2:	05048593          	addi	a1,s1,80
    800034a6:	0531                	addi	a0,a0,12
    800034a8:	807fd0ef          	jal	ra,80000cae <memmove>
  log_write(bp);
    800034ac:	854a                	mv	a0,s2
    800034ae:	3af000ef          	jal	ra,8000405c <log_write>
  brelse(bp);
    800034b2:	854a                	mv	a0,s2
    800034b4:	a9dff0ef          	jal	ra,80002f50 <brelse>
}
    800034b8:	60e2                	ld	ra,24(sp)
    800034ba:	6442                	ld	s0,16(sp)
    800034bc:	64a2                	ld	s1,8(sp)
    800034be:	6902                	ld	s2,0(sp)
    800034c0:	6105                	addi	sp,sp,32
    800034c2:	8082                	ret

00000000800034c4 <idup>:
{
    800034c4:	1101                	addi	sp,sp,-32
    800034c6:	ec06                	sd	ra,24(sp)
    800034c8:	e822                	sd	s0,16(sp)
    800034ca:	e426                	sd	s1,8(sp)
    800034cc:	1000                	addi	s0,sp,32
    800034ce:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034d0:	0001b517          	auipc	a0,0x1b
    800034d4:	04050513          	addi	a0,a0,64 # 8001e510 <itable>
    800034d8:	ea2fd0ef          	jal	ra,80000b7a <acquire>
  ip->ref++;
    800034dc:	449c                	lw	a5,8(s1)
    800034de:	2785                	addiw	a5,a5,1
    800034e0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800034e2:	0001b517          	auipc	a0,0x1b
    800034e6:	02e50513          	addi	a0,a0,46 # 8001e510 <itable>
    800034ea:	f28fd0ef          	jal	ra,80000c12 <release>
}
    800034ee:	8526                	mv	a0,s1
    800034f0:	60e2                	ld	ra,24(sp)
    800034f2:	6442                	ld	s0,16(sp)
    800034f4:	64a2                	ld	s1,8(sp)
    800034f6:	6105                	addi	sp,sp,32
    800034f8:	8082                	ret

00000000800034fa <ilock>:
{
    800034fa:	1101                	addi	sp,sp,-32
    800034fc:	ec06                	sd	ra,24(sp)
    800034fe:	e822                	sd	s0,16(sp)
    80003500:	e426                	sd	s1,8(sp)
    80003502:	e04a                	sd	s2,0(sp)
    80003504:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003506:	c105                	beqz	a0,80003526 <ilock+0x2c>
    80003508:	84aa                	mv	s1,a0
    8000350a:	451c                	lw	a5,8(a0)
    8000350c:	00f05d63          	blez	a5,80003526 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003510:	0541                	addi	a0,a0,16
    80003512:	445000ef          	jal	ra,80004156 <acquiresleep>
  if(ip->valid == 0){
    80003516:	40bc                	lw	a5,64(s1)
    80003518:	cf89                	beqz	a5,80003532 <ilock+0x38>
}
    8000351a:	60e2                	ld	ra,24(sp)
    8000351c:	6442                	ld	s0,16(sp)
    8000351e:	64a2                	ld	s1,8(sp)
    80003520:	6902                	ld	s2,0(sp)
    80003522:	6105                	addi	sp,sp,32
    80003524:	8082                	ret
    panic("ilock");
    80003526:	00004517          	auipc	a0,0x4
    8000352a:	03a50513          	addi	a0,a0,58 # 80007560 <syscalls+0x170>
    8000352e:	a62fd0ef          	jal	ra,80000790 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003532:	40dc                	lw	a5,4(s1)
    80003534:	0047d79b          	srliw	a5,a5,0x4
    80003538:	0001b597          	auipc	a1,0x1b
    8000353c:	fd05a583          	lw	a1,-48(a1) # 8001e508 <sb+0x18>
    80003540:	9dbd                	addw	a1,a1,a5
    80003542:	4088                	lw	a0,0(s1)
    80003544:	905ff0ef          	jal	ra,80002e48 <bread>
    80003548:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000354a:	05850593          	addi	a1,a0,88
    8000354e:	40dc                	lw	a5,4(s1)
    80003550:	8bbd                	andi	a5,a5,15
    80003552:	079a                	slli	a5,a5,0x6
    80003554:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003556:	00059783          	lh	a5,0(a1)
    8000355a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000355e:	00259783          	lh	a5,2(a1)
    80003562:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003566:	00459783          	lh	a5,4(a1)
    8000356a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000356e:	00659783          	lh	a5,6(a1)
    80003572:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003576:	459c                	lw	a5,8(a1)
    80003578:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000357a:	03400613          	li	a2,52
    8000357e:	05b1                	addi	a1,a1,12
    80003580:	05048513          	addi	a0,s1,80
    80003584:	f2afd0ef          	jal	ra,80000cae <memmove>
    brelse(bp);
    80003588:	854a                	mv	a0,s2
    8000358a:	9c7ff0ef          	jal	ra,80002f50 <brelse>
    ip->valid = 1;
    8000358e:	4785                	li	a5,1
    80003590:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003592:	04449783          	lh	a5,68(s1)
    80003596:	f3d1                	bnez	a5,8000351a <ilock+0x20>
      panic("ilock: no type");
    80003598:	00004517          	auipc	a0,0x4
    8000359c:	fd050513          	addi	a0,a0,-48 # 80007568 <syscalls+0x178>
    800035a0:	9f0fd0ef          	jal	ra,80000790 <panic>

00000000800035a4 <iunlock>:
{
    800035a4:	1101                	addi	sp,sp,-32
    800035a6:	ec06                	sd	ra,24(sp)
    800035a8:	e822                	sd	s0,16(sp)
    800035aa:	e426                	sd	s1,8(sp)
    800035ac:	e04a                	sd	s2,0(sp)
    800035ae:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800035b0:	c505                	beqz	a0,800035d8 <iunlock+0x34>
    800035b2:	84aa                	mv	s1,a0
    800035b4:	01050913          	addi	s2,a0,16
    800035b8:	854a                	mv	a0,s2
    800035ba:	41b000ef          	jal	ra,800041d4 <holdingsleep>
    800035be:	cd09                	beqz	a0,800035d8 <iunlock+0x34>
    800035c0:	449c                	lw	a5,8(s1)
    800035c2:	00f05b63          	blez	a5,800035d8 <iunlock+0x34>
  releasesleep(&ip->lock);
    800035c6:	854a                	mv	a0,s2
    800035c8:	3d5000ef          	jal	ra,8000419c <releasesleep>
}
    800035cc:	60e2                	ld	ra,24(sp)
    800035ce:	6442                	ld	s0,16(sp)
    800035d0:	64a2                	ld	s1,8(sp)
    800035d2:	6902                	ld	s2,0(sp)
    800035d4:	6105                	addi	sp,sp,32
    800035d6:	8082                	ret
    panic("iunlock");
    800035d8:	00004517          	auipc	a0,0x4
    800035dc:	fa050513          	addi	a0,a0,-96 # 80007578 <syscalls+0x188>
    800035e0:	9b0fd0ef          	jal	ra,80000790 <panic>

00000000800035e4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800035e4:	7179                	addi	sp,sp,-48
    800035e6:	f406                	sd	ra,40(sp)
    800035e8:	f022                	sd	s0,32(sp)
    800035ea:	ec26                	sd	s1,24(sp)
    800035ec:	e84a                	sd	s2,16(sp)
    800035ee:	e44e                	sd	s3,8(sp)
    800035f0:	e052                	sd	s4,0(sp)
    800035f2:	1800                	addi	s0,sp,48
    800035f4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800035f6:	05050493          	addi	s1,a0,80
    800035fa:	08050913          	addi	s2,a0,128
    800035fe:	a021                	j	80003606 <itrunc+0x22>
    80003600:	0491                	addi	s1,s1,4
    80003602:	01248b63          	beq	s1,s2,80003618 <itrunc+0x34>
    if(ip->addrs[i]){
    80003606:	408c                	lw	a1,0(s1)
    80003608:	dde5                	beqz	a1,80003600 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000360a:	0009a503          	lw	a0,0(s3)
    8000360e:	a35ff0ef          	jal	ra,80003042 <bfree>
      ip->addrs[i] = 0;
    80003612:	0004a023          	sw	zero,0(s1)
    80003616:	b7ed                	j	80003600 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003618:	0809a583          	lw	a1,128(s3)
    8000361c:	ed91                	bnez	a1,80003638 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000361e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003622:	854e                	mv	a0,s3
    80003624:	e25ff0ef          	jal	ra,80003448 <iupdate>
}
    80003628:	70a2                	ld	ra,40(sp)
    8000362a:	7402                	ld	s0,32(sp)
    8000362c:	64e2                	ld	s1,24(sp)
    8000362e:	6942                	ld	s2,16(sp)
    80003630:	69a2                	ld	s3,8(sp)
    80003632:	6a02                	ld	s4,0(sp)
    80003634:	6145                	addi	sp,sp,48
    80003636:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003638:	0009a503          	lw	a0,0(s3)
    8000363c:	80dff0ef          	jal	ra,80002e48 <bread>
    80003640:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003642:	05850493          	addi	s1,a0,88
    80003646:	45850913          	addi	s2,a0,1112
    8000364a:	a801                	j	8000365a <itrunc+0x76>
        bfree(ip->dev, a[j]);
    8000364c:	0009a503          	lw	a0,0(s3)
    80003650:	9f3ff0ef          	jal	ra,80003042 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003654:	0491                	addi	s1,s1,4
    80003656:	01248563          	beq	s1,s2,80003660 <itrunc+0x7c>
      if(a[j])
    8000365a:	408c                	lw	a1,0(s1)
    8000365c:	dde5                	beqz	a1,80003654 <itrunc+0x70>
    8000365e:	b7fd                	j	8000364c <itrunc+0x68>
    brelse(bp);
    80003660:	8552                	mv	a0,s4
    80003662:	8efff0ef          	jal	ra,80002f50 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003666:	0809a583          	lw	a1,128(s3)
    8000366a:	0009a503          	lw	a0,0(s3)
    8000366e:	9d5ff0ef          	jal	ra,80003042 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003672:	0809a023          	sw	zero,128(s3)
    80003676:	b765                	j	8000361e <itrunc+0x3a>

0000000080003678 <iput>:
{
    80003678:	1101                	addi	sp,sp,-32
    8000367a:	ec06                	sd	ra,24(sp)
    8000367c:	e822                	sd	s0,16(sp)
    8000367e:	e426                	sd	s1,8(sp)
    80003680:	e04a                	sd	s2,0(sp)
    80003682:	1000                	addi	s0,sp,32
    80003684:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003686:	0001b517          	auipc	a0,0x1b
    8000368a:	e8a50513          	addi	a0,a0,-374 # 8001e510 <itable>
    8000368e:	cecfd0ef          	jal	ra,80000b7a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003692:	4498                	lw	a4,8(s1)
    80003694:	4785                	li	a5,1
    80003696:	02f70163          	beq	a4,a5,800036b8 <iput+0x40>
  ip->ref--;
    8000369a:	449c                	lw	a5,8(s1)
    8000369c:	37fd                	addiw	a5,a5,-1
    8000369e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800036a0:	0001b517          	auipc	a0,0x1b
    800036a4:	e7050513          	addi	a0,a0,-400 # 8001e510 <itable>
    800036a8:	d6afd0ef          	jal	ra,80000c12 <release>
}
    800036ac:	60e2                	ld	ra,24(sp)
    800036ae:	6442                	ld	s0,16(sp)
    800036b0:	64a2                	ld	s1,8(sp)
    800036b2:	6902                	ld	s2,0(sp)
    800036b4:	6105                	addi	sp,sp,32
    800036b6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800036b8:	40bc                	lw	a5,64(s1)
    800036ba:	d3e5                	beqz	a5,8000369a <iput+0x22>
    800036bc:	04a49783          	lh	a5,74(s1)
    800036c0:	ffe9                	bnez	a5,8000369a <iput+0x22>
    acquiresleep(&ip->lock);
    800036c2:	01048913          	addi	s2,s1,16
    800036c6:	854a                	mv	a0,s2
    800036c8:	28f000ef          	jal	ra,80004156 <acquiresleep>
    release(&itable.lock);
    800036cc:	0001b517          	auipc	a0,0x1b
    800036d0:	e4450513          	addi	a0,a0,-444 # 8001e510 <itable>
    800036d4:	d3efd0ef          	jal	ra,80000c12 <release>
    itrunc(ip);
    800036d8:	8526                	mv	a0,s1
    800036da:	f0bff0ef          	jal	ra,800035e4 <itrunc>
    ip->type = 0;
    800036de:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800036e2:	8526                	mv	a0,s1
    800036e4:	d65ff0ef          	jal	ra,80003448 <iupdate>
    ip->valid = 0;
    800036e8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800036ec:	854a                	mv	a0,s2
    800036ee:	2af000ef          	jal	ra,8000419c <releasesleep>
    acquire(&itable.lock);
    800036f2:	0001b517          	auipc	a0,0x1b
    800036f6:	e1e50513          	addi	a0,a0,-482 # 8001e510 <itable>
    800036fa:	c80fd0ef          	jal	ra,80000b7a <acquire>
    800036fe:	bf71                	j	8000369a <iput+0x22>

0000000080003700 <iunlockput>:
{
    80003700:	1101                	addi	sp,sp,-32
    80003702:	ec06                	sd	ra,24(sp)
    80003704:	e822                	sd	s0,16(sp)
    80003706:	e426                	sd	s1,8(sp)
    80003708:	1000                	addi	s0,sp,32
    8000370a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000370c:	e99ff0ef          	jal	ra,800035a4 <iunlock>
  iput(ip);
    80003710:	8526                	mv	a0,s1
    80003712:	f67ff0ef          	jal	ra,80003678 <iput>
}
    80003716:	60e2                	ld	ra,24(sp)
    80003718:	6442                	ld	s0,16(sp)
    8000371a:	64a2                	ld	s1,8(sp)
    8000371c:	6105                	addi	sp,sp,32
    8000371e:	8082                	ret

0000000080003720 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003720:	0001b717          	auipc	a4,0x1b
    80003724:	ddc72703          	lw	a4,-548(a4) # 8001e4fc <sb+0xc>
    80003728:	4785                	li	a5,1
    8000372a:	0ae7ff63          	bgeu	a5,a4,800037e8 <ireclaim+0xc8>
{
    8000372e:	7139                	addi	sp,sp,-64
    80003730:	fc06                	sd	ra,56(sp)
    80003732:	f822                	sd	s0,48(sp)
    80003734:	f426                	sd	s1,40(sp)
    80003736:	f04a                	sd	s2,32(sp)
    80003738:	ec4e                	sd	s3,24(sp)
    8000373a:	e852                	sd	s4,16(sp)
    8000373c:	e456                	sd	s5,8(sp)
    8000373e:	e05a                	sd	s6,0(sp)
    80003740:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003742:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003744:	00050a1b          	sext.w	s4,a0
    80003748:	0001ba97          	auipc	s5,0x1b
    8000374c:	da8a8a93          	addi	s5,s5,-600 # 8001e4f0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003750:	00004b17          	auipc	s6,0x4
    80003754:	e30b0b13          	addi	s6,s6,-464 # 80007580 <syscalls+0x190>
    80003758:	a099                	j	8000379e <ireclaim+0x7e>
    8000375a:	85ce                	mv	a1,s3
    8000375c:	855a                	mv	a0,s6
    8000375e:	d6dfc0ef          	jal	ra,800004ca <printf>
      ip = iget(dev, inum);
    80003762:	85ce                	mv	a1,s3
    80003764:	8552                	mv	a0,s4
    80003766:	b29ff0ef          	jal	ra,8000328e <iget>
    8000376a:	89aa                	mv	s3,a0
    brelse(bp);
    8000376c:	854a                	mv	a0,s2
    8000376e:	fe2ff0ef          	jal	ra,80002f50 <brelse>
    if (ip) {
    80003772:	00098f63          	beqz	s3,80003790 <ireclaim+0x70>
      begin_op();
    80003776:	762000ef          	jal	ra,80003ed8 <begin_op>
      ilock(ip);
    8000377a:	854e                	mv	a0,s3
    8000377c:	d7fff0ef          	jal	ra,800034fa <ilock>
      iunlock(ip);
    80003780:	854e                	mv	a0,s3
    80003782:	e23ff0ef          	jal	ra,800035a4 <iunlock>
      iput(ip);
    80003786:	854e                	mv	a0,s3
    80003788:	ef1ff0ef          	jal	ra,80003678 <iput>
      end_op();
    8000378c:	7bc000ef          	jal	ra,80003f48 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003790:	0485                	addi	s1,s1,1
    80003792:	00caa703          	lw	a4,12(s5)
    80003796:	0004879b          	sext.w	a5,s1
    8000379a:	02e7fd63          	bgeu	a5,a4,800037d4 <ireclaim+0xb4>
    8000379e:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800037a2:	0044d593          	srli	a1,s1,0x4
    800037a6:	018aa783          	lw	a5,24(s5)
    800037aa:	9dbd                	addw	a1,a1,a5
    800037ac:	8552                	mv	a0,s4
    800037ae:	e9aff0ef          	jal	ra,80002e48 <bread>
    800037b2:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800037b4:	05850793          	addi	a5,a0,88
    800037b8:	00f9f713          	andi	a4,s3,15
    800037bc:	071a                	slli	a4,a4,0x6
    800037be:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800037c0:	00079703          	lh	a4,0(a5)
    800037c4:	c701                	beqz	a4,800037cc <ireclaim+0xac>
    800037c6:	00679783          	lh	a5,6(a5)
    800037ca:	dbc1                	beqz	a5,8000375a <ireclaim+0x3a>
    brelse(bp);
    800037cc:	854a                	mv	a0,s2
    800037ce:	f82ff0ef          	jal	ra,80002f50 <brelse>
    if (ip) {
    800037d2:	bf7d                	j	80003790 <ireclaim+0x70>
}
    800037d4:	70e2                	ld	ra,56(sp)
    800037d6:	7442                	ld	s0,48(sp)
    800037d8:	74a2                	ld	s1,40(sp)
    800037da:	7902                	ld	s2,32(sp)
    800037dc:	69e2                	ld	s3,24(sp)
    800037de:	6a42                	ld	s4,16(sp)
    800037e0:	6aa2                	ld	s5,8(sp)
    800037e2:	6b02                	ld	s6,0(sp)
    800037e4:	6121                	addi	sp,sp,64
    800037e6:	8082                	ret
    800037e8:	8082                	ret

00000000800037ea <fsinit>:
fsinit(int dev) {
    800037ea:	7179                	addi	sp,sp,-48
    800037ec:	f406                	sd	ra,40(sp)
    800037ee:	f022                	sd	s0,32(sp)
    800037f0:	ec26                	sd	s1,24(sp)
    800037f2:	e84a                	sd	s2,16(sp)
    800037f4:	e44e                	sd	s3,8(sp)
    800037f6:	1800                	addi	s0,sp,48
    800037f8:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800037fa:	4585                	li	a1,1
    800037fc:	e4cff0ef          	jal	ra,80002e48 <bread>
    80003800:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003802:	0001b997          	auipc	s3,0x1b
    80003806:	cee98993          	addi	s3,s3,-786 # 8001e4f0 <sb>
    8000380a:	02000613          	li	a2,32
    8000380e:	05850593          	addi	a1,a0,88
    80003812:	854e                	mv	a0,s3
    80003814:	c9afd0ef          	jal	ra,80000cae <memmove>
  brelse(bp);
    80003818:	854a                	mv	a0,s2
    8000381a:	f36ff0ef          	jal	ra,80002f50 <brelse>
  if(sb.magic != FSMAGIC)
    8000381e:	0009a703          	lw	a4,0(s3)
    80003822:	102037b7          	lui	a5,0x10203
    80003826:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000382a:	02f71363          	bne	a4,a5,80003850 <fsinit+0x66>
  initlog(dev, &sb);
    8000382e:	0001b597          	auipc	a1,0x1b
    80003832:	cc258593          	addi	a1,a1,-830 # 8001e4f0 <sb>
    80003836:	8526                	mv	a0,s1
    80003838:	616000ef          	jal	ra,80003e4e <initlog>
  ireclaim(dev);
    8000383c:	8526                	mv	a0,s1
    8000383e:	ee3ff0ef          	jal	ra,80003720 <ireclaim>
}
    80003842:	70a2                	ld	ra,40(sp)
    80003844:	7402                	ld	s0,32(sp)
    80003846:	64e2                	ld	s1,24(sp)
    80003848:	6942                	ld	s2,16(sp)
    8000384a:	69a2                	ld	s3,8(sp)
    8000384c:	6145                	addi	sp,sp,48
    8000384e:	8082                	ret
    panic("invalid file system");
    80003850:	00004517          	auipc	a0,0x4
    80003854:	d5050513          	addi	a0,a0,-688 # 800075a0 <syscalls+0x1b0>
    80003858:	f39fc0ef          	jal	ra,80000790 <panic>

000000008000385c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000385c:	1141                	addi	sp,sp,-16
    8000385e:	e422                	sd	s0,8(sp)
    80003860:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003862:	411c                	lw	a5,0(a0)
    80003864:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003866:	415c                	lw	a5,4(a0)
    80003868:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000386a:	04451783          	lh	a5,68(a0)
    8000386e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003872:	04a51783          	lh	a5,74(a0)
    80003876:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000387a:	04c56783          	lwu	a5,76(a0)
    8000387e:	e99c                	sd	a5,16(a1)
}
    80003880:	6422                	ld	s0,8(sp)
    80003882:	0141                	addi	sp,sp,16
    80003884:	8082                	ret

0000000080003886 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003886:	457c                	lw	a5,76(a0)
    80003888:	0cd7ef63          	bltu	a5,a3,80003966 <readi+0xe0>
{
    8000388c:	7159                	addi	sp,sp,-112
    8000388e:	f486                	sd	ra,104(sp)
    80003890:	f0a2                	sd	s0,96(sp)
    80003892:	eca6                	sd	s1,88(sp)
    80003894:	e8ca                	sd	s2,80(sp)
    80003896:	e4ce                	sd	s3,72(sp)
    80003898:	e0d2                	sd	s4,64(sp)
    8000389a:	fc56                	sd	s5,56(sp)
    8000389c:	f85a                	sd	s6,48(sp)
    8000389e:	f45e                	sd	s7,40(sp)
    800038a0:	f062                	sd	s8,32(sp)
    800038a2:	ec66                	sd	s9,24(sp)
    800038a4:	e86a                	sd	s10,16(sp)
    800038a6:	e46e                	sd	s11,8(sp)
    800038a8:	1880                	addi	s0,sp,112
    800038aa:	8b2a                	mv	s6,a0
    800038ac:	8bae                	mv	s7,a1
    800038ae:	8a32                	mv	s4,a2
    800038b0:	84b6                	mv	s1,a3
    800038b2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800038b4:	9f35                	addw	a4,a4,a3
    return 0;
    800038b6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800038b8:	08d76663          	bltu	a4,a3,80003944 <readi+0xbe>
  if(off + n > ip->size)
    800038bc:	00e7f463          	bgeu	a5,a4,800038c4 <readi+0x3e>
    n = ip->size - off;
    800038c0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038c4:	080a8f63          	beqz	s5,80003962 <readi+0xdc>
    800038c8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800038ca:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038ce:	5c7d                	li	s8,-1
    800038d0:	a80d                	j	80003902 <readi+0x7c>
    800038d2:	020d1d93          	slli	s11,s10,0x20
    800038d6:	020ddd93          	srli	s11,s11,0x20
    800038da:	05890613          	addi	a2,s2,88
    800038de:	86ee                	mv	a3,s11
    800038e0:	963a                	add	a2,a2,a4
    800038e2:	85d2                	mv	a1,s4
    800038e4:	855e                	mv	a0,s7
    800038e6:	f3efe0ef          	jal	ra,80002024 <either_copyout>
    800038ea:	05850763          	beq	a0,s8,80003938 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800038ee:	854a                	mv	a0,s2
    800038f0:	e60ff0ef          	jal	ra,80002f50 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038f4:	013d09bb          	addw	s3,s10,s3
    800038f8:	009d04bb          	addw	s1,s10,s1
    800038fc:	9a6e                	add	s4,s4,s11
    800038fe:	0559f163          	bgeu	s3,s5,80003940 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80003902:	00a4d59b          	srliw	a1,s1,0xa
    80003906:	855a                	mv	a0,s6
    80003908:	8bbff0ef          	jal	ra,800031c2 <bmap>
    8000390c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003910:	c985                	beqz	a1,80003940 <readi+0xba>
    bp = bread(ip->dev, addr);
    80003912:	000b2503          	lw	a0,0(s6)
    80003916:	d32ff0ef          	jal	ra,80002e48 <bread>
    8000391a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000391c:	3ff4f713          	andi	a4,s1,1023
    80003920:	40ec87bb          	subw	a5,s9,a4
    80003924:	413a86bb          	subw	a3,s5,s3
    80003928:	8d3e                	mv	s10,a5
    8000392a:	2781                	sext.w	a5,a5
    8000392c:	0006861b          	sext.w	a2,a3
    80003930:	faf671e3          	bgeu	a2,a5,800038d2 <readi+0x4c>
    80003934:	8d36                	mv	s10,a3
    80003936:	bf71                	j	800038d2 <readi+0x4c>
      brelse(bp);
    80003938:	854a                	mv	a0,s2
    8000393a:	e16ff0ef          	jal	ra,80002f50 <brelse>
      tot = -1;
    8000393e:	59fd                	li	s3,-1
  }
  return tot;
    80003940:	0009851b          	sext.w	a0,s3
}
    80003944:	70a6                	ld	ra,104(sp)
    80003946:	7406                	ld	s0,96(sp)
    80003948:	64e6                	ld	s1,88(sp)
    8000394a:	6946                	ld	s2,80(sp)
    8000394c:	69a6                	ld	s3,72(sp)
    8000394e:	6a06                	ld	s4,64(sp)
    80003950:	7ae2                	ld	s5,56(sp)
    80003952:	7b42                	ld	s6,48(sp)
    80003954:	7ba2                	ld	s7,40(sp)
    80003956:	7c02                	ld	s8,32(sp)
    80003958:	6ce2                	ld	s9,24(sp)
    8000395a:	6d42                	ld	s10,16(sp)
    8000395c:	6da2                	ld	s11,8(sp)
    8000395e:	6165                	addi	sp,sp,112
    80003960:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003962:	89d6                	mv	s3,s5
    80003964:	bff1                	j	80003940 <readi+0xba>
    return 0;
    80003966:	4501                	li	a0,0
}
    80003968:	8082                	ret

000000008000396a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000396a:	457c                	lw	a5,76(a0)
    8000396c:	0ed7ea63          	bltu	a5,a3,80003a60 <writei+0xf6>
{
    80003970:	7159                	addi	sp,sp,-112
    80003972:	f486                	sd	ra,104(sp)
    80003974:	f0a2                	sd	s0,96(sp)
    80003976:	eca6                	sd	s1,88(sp)
    80003978:	e8ca                	sd	s2,80(sp)
    8000397a:	e4ce                	sd	s3,72(sp)
    8000397c:	e0d2                	sd	s4,64(sp)
    8000397e:	fc56                	sd	s5,56(sp)
    80003980:	f85a                	sd	s6,48(sp)
    80003982:	f45e                	sd	s7,40(sp)
    80003984:	f062                	sd	s8,32(sp)
    80003986:	ec66                	sd	s9,24(sp)
    80003988:	e86a                	sd	s10,16(sp)
    8000398a:	e46e                	sd	s11,8(sp)
    8000398c:	1880                	addi	s0,sp,112
    8000398e:	8aaa                	mv	s5,a0
    80003990:	8bae                	mv	s7,a1
    80003992:	8a32                	mv	s4,a2
    80003994:	8936                	mv	s2,a3
    80003996:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003998:	00e687bb          	addw	a5,a3,a4
    8000399c:	0cd7e463          	bltu	a5,a3,80003a64 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800039a0:	00043737          	lui	a4,0x43
    800039a4:	0cf76263          	bltu	a4,a5,80003a68 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039a8:	0a0b0a63          	beqz	s6,80003a5c <writei+0xf2>
    800039ac:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800039ae:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800039b2:	5c7d                	li	s8,-1
    800039b4:	a825                	j	800039ec <writei+0x82>
    800039b6:	020d1d93          	slli	s11,s10,0x20
    800039ba:	020ddd93          	srli	s11,s11,0x20
    800039be:	05848513          	addi	a0,s1,88
    800039c2:	86ee                	mv	a3,s11
    800039c4:	8652                	mv	a2,s4
    800039c6:	85de                	mv	a1,s7
    800039c8:	953a                	add	a0,a0,a4
    800039ca:	ea4fe0ef          	jal	ra,8000206e <either_copyin>
    800039ce:	05850a63          	beq	a0,s8,80003a22 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800039d2:	8526                	mv	a0,s1
    800039d4:	688000ef          	jal	ra,8000405c <log_write>
    brelse(bp);
    800039d8:	8526                	mv	a0,s1
    800039da:	d76ff0ef          	jal	ra,80002f50 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039de:	013d09bb          	addw	s3,s10,s3
    800039e2:	012d093b          	addw	s2,s10,s2
    800039e6:	9a6e                	add	s4,s4,s11
    800039e8:	0569f063          	bgeu	s3,s6,80003a28 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800039ec:	00a9559b          	srliw	a1,s2,0xa
    800039f0:	8556                	mv	a0,s5
    800039f2:	fd0ff0ef          	jal	ra,800031c2 <bmap>
    800039f6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800039fa:	c59d                	beqz	a1,80003a28 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800039fc:	000aa503          	lw	a0,0(s5)
    80003a00:	c48ff0ef          	jal	ra,80002e48 <bread>
    80003a04:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a06:	3ff97713          	andi	a4,s2,1023
    80003a0a:	40ec87bb          	subw	a5,s9,a4
    80003a0e:	413b06bb          	subw	a3,s6,s3
    80003a12:	8d3e                	mv	s10,a5
    80003a14:	2781                	sext.w	a5,a5
    80003a16:	0006861b          	sext.w	a2,a3
    80003a1a:	f8f67ee3          	bgeu	a2,a5,800039b6 <writei+0x4c>
    80003a1e:	8d36                	mv	s10,a3
    80003a20:	bf59                	j	800039b6 <writei+0x4c>
      brelse(bp);
    80003a22:	8526                	mv	a0,s1
    80003a24:	d2cff0ef          	jal	ra,80002f50 <brelse>
  }

  if(off > ip->size)
    80003a28:	04caa783          	lw	a5,76(s5)
    80003a2c:	0127f463          	bgeu	a5,s2,80003a34 <writei+0xca>
    ip->size = off;
    80003a30:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003a34:	8556                	mv	a0,s5
    80003a36:	a13ff0ef          	jal	ra,80003448 <iupdate>

  return tot;
    80003a3a:	0009851b          	sext.w	a0,s3
}
    80003a3e:	70a6                	ld	ra,104(sp)
    80003a40:	7406                	ld	s0,96(sp)
    80003a42:	64e6                	ld	s1,88(sp)
    80003a44:	6946                	ld	s2,80(sp)
    80003a46:	69a6                	ld	s3,72(sp)
    80003a48:	6a06                	ld	s4,64(sp)
    80003a4a:	7ae2                	ld	s5,56(sp)
    80003a4c:	7b42                	ld	s6,48(sp)
    80003a4e:	7ba2                	ld	s7,40(sp)
    80003a50:	7c02                	ld	s8,32(sp)
    80003a52:	6ce2                	ld	s9,24(sp)
    80003a54:	6d42                	ld	s10,16(sp)
    80003a56:	6da2                	ld	s11,8(sp)
    80003a58:	6165                	addi	sp,sp,112
    80003a5a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a5c:	89da                	mv	s3,s6
    80003a5e:	bfd9                	j	80003a34 <writei+0xca>
    return -1;
    80003a60:	557d                	li	a0,-1
}
    80003a62:	8082                	ret
    return -1;
    80003a64:	557d                	li	a0,-1
    80003a66:	bfe1                	j	80003a3e <writei+0xd4>
    return -1;
    80003a68:	557d                	li	a0,-1
    80003a6a:	bfd1                	j	80003a3e <writei+0xd4>

0000000080003a6c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003a6c:	1141                	addi	sp,sp,-16
    80003a6e:	e406                	sd	ra,8(sp)
    80003a70:	e022                	sd	s0,0(sp)
    80003a72:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003a74:	4639                	li	a2,14
    80003a76:	aacfd0ef          	jal	ra,80000d22 <strncmp>
}
    80003a7a:	60a2                	ld	ra,8(sp)
    80003a7c:	6402                	ld	s0,0(sp)
    80003a7e:	0141                	addi	sp,sp,16
    80003a80:	8082                	ret

0000000080003a82 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003a82:	7139                	addi	sp,sp,-64
    80003a84:	fc06                	sd	ra,56(sp)
    80003a86:	f822                	sd	s0,48(sp)
    80003a88:	f426                	sd	s1,40(sp)
    80003a8a:	f04a                	sd	s2,32(sp)
    80003a8c:	ec4e                	sd	s3,24(sp)
    80003a8e:	e852                	sd	s4,16(sp)
    80003a90:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003a92:	04451703          	lh	a4,68(a0)
    80003a96:	4785                	li	a5,1
    80003a98:	00f71a63          	bne	a4,a5,80003aac <dirlookup+0x2a>
    80003a9c:	892a                	mv	s2,a0
    80003a9e:	89ae                	mv	s3,a1
    80003aa0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003aa2:	457c                	lw	a5,76(a0)
    80003aa4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003aa6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003aa8:	e39d                	bnez	a5,80003ace <dirlookup+0x4c>
    80003aaa:	a095                	j	80003b0e <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003aac:	00004517          	auipc	a0,0x4
    80003ab0:	b0c50513          	addi	a0,a0,-1268 # 800075b8 <syscalls+0x1c8>
    80003ab4:	cddfc0ef          	jal	ra,80000790 <panic>
      panic("dirlookup read");
    80003ab8:	00004517          	auipc	a0,0x4
    80003abc:	b1850513          	addi	a0,a0,-1256 # 800075d0 <syscalls+0x1e0>
    80003ac0:	cd1fc0ef          	jal	ra,80000790 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ac4:	24c1                	addiw	s1,s1,16
    80003ac6:	04c92783          	lw	a5,76(s2)
    80003aca:	04f4f163          	bgeu	s1,a5,80003b0c <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ace:	4741                	li	a4,16
    80003ad0:	86a6                	mv	a3,s1
    80003ad2:	fc040613          	addi	a2,s0,-64
    80003ad6:	4581                	li	a1,0
    80003ad8:	854a                	mv	a0,s2
    80003ada:	dadff0ef          	jal	ra,80003886 <readi>
    80003ade:	47c1                	li	a5,16
    80003ae0:	fcf51ce3          	bne	a0,a5,80003ab8 <dirlookup+0x36>
    if(de.inum == 0)
    80003ae4:	fc045783          	lhu	a5,-64(s0)
    80003ae8:	dff1                	beqz	a5,80003ac4 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003aea:	fc240593          	addi	a1,s0,-62
    80003aee:	854e                	mv	a0,s3
    80003af0:	f7dff0ef          	jal	ra,80003a6c <namecmp>
    80003af4:	f961                	bnez	a0,80003ac4 <dirlookup+0x42>
      if(poff)
    80003af6:	000a0463          	beqz	s4,80003afe <dirlookup+0x7c>
        *poff = off;
    80003afa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003afe:	fc045583          	lhu	a1,-64(s0)
    80003b02:	00092503          	lw	a0,0(s2)
    80003b06:	f88ff0ef          	jal	ra,8000328e <iget>
    80003b0a:	a011                	j	80003b0e <dirlookup+0x8c>
  return 0;
    80003b0c:	4501                	li	a0,0
}
    80003b0e:	70e2                	ld	ra,56(sp)
    80003b10:	7442                	ld	s0,48(sp)
    80003b12:	74a2                	ld	s1,40(sp)
    80003b14:	7902                	ld	s2,32(sp)
    80003b16:	69e2                	ld	s3,24(sp)
    80003b18:	6a42                	ld	s4,16(sp)
    80003b1a:	6121                	addi	sp,sp,64
    80003b1c:	8082                	ret

0000000080003b1e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b1e:	711d                	addi	sp,sp,-96
    80003b20:	ec86                	sd	ra,88(sp)
    80003b22:	e8a2                	sd	s0,80(sp)
    80003b24:	e4a6                	sd	s1,72(sp)
    80003b26:	e0ca                	sd	s2,64(sp)
    80003b28:	fc4e                	sd	s3,56(sp)
    80003b2a:	f852                	sd	s4,48(sp)
    80003b2c:	f456                	sd	s5,40(sp)
    80003b2e:	f05a                	sd	s6,32(sp)
    80003b30:	ec5e                	sd	s7,24(sp)
    80003b32:	e862                	sd	s8,16(sp)
    80003b34:	e466                	sd	s9,8(sp)
    80003b36:	1080                	addi	s0,sp,96
    80003b38:	84aa                	mv	s1,a0
    80003b3a:	8b2e                	mv	s6,a1
    80003b3c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003b3e:	00054703          	lbu	a4,0(a0)
    80003b42:	02f00793          	li	a5,47
    80003b46:	00f70f63          	beq	a4,a5,80003b64 <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003b4a:	cf7fd0ef          	jal	ra,80001840 <myproc>
    80003b4e:	15053503          	ld	a0,336(a0)
    80003b52:	973ff0ef          	jal	ra,800034c4 <idup>
    80003b56:	89aa                	mv	s3,a0
  while(*path == '/')
    80003b58:	02f00913          	li	s2,47
  len = path - s;
    80003b5c:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003b5e:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003b60:	4c05                	li	s8,1
    80003b62:	a861                	j	80003bfa <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    80003b64:	4585                	li	a1,1
    80003b66:	4505                	li	a0,1
    80003b68:	f26ff0ef          	jal	ra,8000328e <iget>
    80003b6c:	89aa                	mv	s3,a0
    80003b6e:	b7ed                	j	80003b58 <namex+0x3a>
      iunlockput(ip);
    80003b70:	854e                	mv	a0,s3
    80003b72:	b8fff0ef          	jal	ra,80003700 <iunlockput>
      return 0;
    80003b76:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003b78:	854e                	mv	a0,s3
    80003b7a:	60e6                	ld	ra,88(sp)
    80003b7c:	6446                	ld	s0,80(sp)
    80003b7e:	64a6                	ld	s1,72(sp)
    80003b80:	6906                	ld	s2,64(sp)
    80003b82:	79e2                	ld	s3,56(sp)
    80003b84:	7a42                	ld	s4,48(sp)
    80003b86:	7aa2                	ld	s5,40(sp)
    80003b88:	7b02                	ld	s6,32(sp)
    80003b8a:	6be2                	ld	s7,24(sp)
    80003b8c:	6c42                	ld	s8,16(sp)
    80003b8e:	6ca2                	ld	s9,8(sp)
    80003b90:	6125                	addi	sp,sp,96
    80003b92:	8082                	ret
      iunlock(ip);
    80003b94:	854e                	mv	a0,s3
    80003b96:	a0fff0ef          	jal	ra,800035a4 <iunlock>
      return ip;
    80003b9a:	bff9                	j	80003b78 <namex+0x5a>
      iunlockput(ip);
    80003b9c:	854e                	mv	a0,s3
    80003b9e:	b63ff0ef          	jal	ra,80003700 <iunlockput>
      return 0;
    80003ba2:	89d2                	mv	s3,s4
    80003ba4:	bfd1                	j	80003b78 <namex+0x5a>
  len = path - s;
    80003ba6:	40b48633          	sub	a2,s1,a1
    80003baa:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003bae:	074cdc63          	bge	s9,s4,80003c26 <namex+0x108>
    memmove(name, s, DIRSIZ);
    80003bb2:	4639                	li	a2,14
    80003bb4:	8556                	mv	a0,s5
    80003bb6:	8f8fd0ef          	jal	ra,80000cae <memmove>
  while(*path == '/')
    80003bba:	0004c783          	lbu	a5,0(s1)
    80003bbe:	01279763          	bne	a5,s2,80003bcc <namex+0xae>
    path++;
    80003bc2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003bc4:	0004c783          	lbu	a5,0(s1)
    80003bc8:	ff278de3          	beq	a5,s2,80003bc2 <namex+0xa4>
    ilock(ip);
    80003bcc:	854e                	mv	a0,s3
    80003bce:	92dff0ef          	jal	ra,800034fa <ilock>
    if(ip->type != T_DIR){
    80003bd2:	04499783          	lh	a5,68(s3)
    80003bd6:	f9879de3          	bne	a5,s8,80003b70 <namex+0x52>
    if(nameiparent && *path == '\0'){
    80003bda:	000b0563          	beqz	s6,80003be4 <namex+0xc6>
    80003bde:	0004c783          	lbu	a5,0(s1)
    80003be2:	dbcd                	beqz	a5,80003b94 <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003be4:	865e                	mv	a2,s7
    80003be6:	85d6                	mv	a1,s5
    80003be8:	854e                	mv	a0,s3
    80003bea:	e99ff0ef          	jal	ra,80003a82 <dirlookup>
    80003bee:	8a2a                	mv	s4,a0
    80003bf0:	d555                	beqz	a0,80003b9c <namex+0x7e>
    iunlockput(ip);
    80003bf2:	854e                	mv	a0,s3
    80003bf4:	b0dff0ef          	jal	ra,80003700 <iunlockput>
    ip = next;
    80003bf8:	89d2                	mv	s3,s4
  while(*path == '/')
    80003bfa:	0004c783          	lbu	a5,0(s1)
    80003bfe:	05279363          	bne	a5,s2,80003c44 <namex+0x126>
    path++;
    80003c02:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c04:	0004c783          	lbu	a5,0(s1)
    80003c08:	ff278de3          	beq	a5,s2,80003c02 <namex+0xe4>
  if(*path == 0)
    80003c0c:	c78d                	beqz	a5,80003c36 <namex+0x118>
    path++;
    80003c0e:	85a6                	mv	a1,s1
  len = path - s;
    80003c10:	8a5e                	mv	s4,s7
    80003c12:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003c14:	01278963          	beq	a5,s2,80003c26 <namex+0x108>
    80003c18:	d7d9                	beqz	a5,80003ba6 <namex+0x88>
    path++;
    80003c1a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003c1c:	0004c783          	lbu	a5,0(s1)
    80003c20:	ff279ce3          	bne	a5,s2,80003c18 <namex+0xfa>
    80003c24:	b749                	j	80003ba6 <namex+0x88>
    memmove(name, s, len);
    80003c26:	2601                	sext.w	a2,a2
    80003c28:	8556                	mv	a0,s5
    80003c2a:	884fd0ef          	jal	ra,80000cae <memmove>
    name[len] = 0;
    80003c2e:	9a56                	add	s4,s4,s5
    80003c30:	000a0023          	sb	zero,0(s4)
    80003c34:	b759                	j	80003bba <namex+0x9c>
  if(nameiparent){
    80003c36:	f40b01e3          	beqz	s6,80003b78 <namex+0x5a>
    iput(ip);
    80003c3a:	854e                	mv	a0,s3
    80003c3c:	a3dff0ef          	jal	ra,80003678 <iput>
    return 0;
    80003c40:	4981                	li	s3,0
    80003c42:	bf1d                	j	80003b78 <namex+0x5a>
  if(*path == 0)
    80003c44:	dbed                	beqz	a5,80003c36 <namex+0x118>
  while(*path != '/' && *path != 0)
    80003c46:	0004c783          	lbu	a5,0(s1)
    80003c4a:	85a6                	mv	a1,s1
    80003c4c:	b7f1                	j	80003c18 <namex+0xfa>

0000000080003c4e <dirlink>:
{
    80003c4e:	7139                	addi	sp,sp,-64
    80003c50:	fc06                	sd	ra,56(sp)
    80003c52:	f822                	sd	s0,48(sp)
    80003c54:	f426                	sd	s1,40(sp)
    80003c56:	f04a                	sd	s2,32(sp)
    80003c58:	ec4e                	sd	s3,24(sp)
    80003c5a:	e852                	sd	s4,16(sp)
    80003c5c:	0080                	addi	s0,sp,64
    80003c5e:	892a                	mv	s2,a0
    80003c60:	8a2e                	mv	s4,a1
    80003c62:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003c64:	4601                	li	a2,0
    80003c66:	e1dff0ef          	jal	ra,80003a82 <dirlookup>
    80003c6a:	e52d                	bnez	a0,80003cd4 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c6c:	04c92483          	lw	s1,76(s2)
    80003c70:	c48d                	beqz	s1,80003c9a <dirlink+0x4c>
    80003c72:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c74:	4741                	li	a4,16
    80003c76:	86a6                	mv	a3,s1
    80003c78:	fc040613          	addi	a2,s0,-64
    80003c7c:	4581                	li	a1,0
    80003c7e:	854a                	mv	a0,s2
    80003c80:	c07ff0ef          	jal	ra,80003886 <readi>
    80003c84:	47c1                	li	a5,16
    80003c86:	04f51b63          	bne	a0,a5,80003cdc <dirlink+0x8e>
    if(de.inum == 0)
    80003c8a:	fc045783          	lhu	a5,-64(s0)
    80003c8e:	c791                	beqz	a5,80003c9a <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c90:	24c1                	addiw	s1,s1,16
    80003c92:	04c92783          	lw	a5,76(s2)
    80003c96:	fcf4efe3          	bltu	s1,a5,80003c74 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003c9a:	4639                	li	a2,14
    80003c9c:	85d2                	mv	a1,s4
    80003c9e:	fc240513          	addi	a0,s0,-62
    80003ca2:	8bcfd0ef          	jal	ra,80000d5e <strncpy>
  de.inum = inum;
    80003ca6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003caa:	4741                	li	a4,16
    80003cac:	86a6                	mv	a3,s1
    80003cae:	fc040613          	addi	a2,s0,-64
    80003cb2:	4581                	li	a1,0
    80003cb4:	854a                	mv	a0,s2
    80003cb6:	cb5ff0ef          	jal	ra,8000396a <writei>
    80003cba:	1541                	addi	a0,a0,-16
    80003cbc:	00a03533          	snez	a0,a0
    80003cc0:	40a00533          	neg	a0,a0
}
    80003cc4:	70e2                	ld	ra,56(sp)
    80003cc6:	7442                	ld	s0,48(sp)
    80003cc8:	74a2                	ld	s1,40(sp)
    80003cca:	7902                	ld	s2,32(sp)
    80003ccc:	69e2                	ld	s3,24(sp)
    80003cce:	6a42                	ld	s4,16(sp)
    80003cd0:	6121                	addi	sp,sp,64
    80003cd2:	8082                	ret
    iput(ip);
    80003cd4:	9a5ff0ef          	jal	ra,80003678 <iput>
    return -1;
    80003cd8:	557d                	li	a0,-1
    80003cda:	b7ed                	j	80003cc4 <dirlink+0x76>
      panic("dirlink read");
    80003cdc:	00004517          	auipc	a0,0x4
    80003ce0:	90450513          	addi	a0,a0,-1788 # 800075e0 <syscalls+0x1f0>
    80003ce4:	aadfc0ef          	jal	ra,80000790 <panic>

0000000080003ce8 <namei>:

struct inode*
namei(char *path)
{
    80003ce8:	1101                	addi	sp,sp,-32
    80003cea:	ec06                	sd	ra,24(sp)
    80003cec:	e822                	sd	s0,16(sp)
    80003cee:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003cf0:	fe040613          	addi	a2,s0,-32
    80003cf4:	4581                	li	a1,0
    80003cf6:	e29ff0ef          	jal	ra,80003b1e <namex>
}
    80003cfa:	60e2                	ld	ra,24(sp)
    80003cfc:	6442                	ld	s0,16(sp)
    80003cfe:	6105                	addi	sp,sp,32
    80003d00:	8082                	ret

0000000080003d02 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003d02:	1141                	addi	sp,sp,-16
    80003d04:	e406                	sd	ra,8(sp)
    80003d06:	e022                	sd	s0,0(sp)
    80003d08:	0800                	addi	s0,sp,16
    80003d0a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003d0c:	4585                	li	a1,1
    80003d0e:	e11ff0ef          	jal	ra,80003b1e <namex>
}
    80003d12:	60a2                	ld	ra,8(sp)
    80003d14:	6402                	ld	s0,0(sp)
    80003d16:	0141                	addi	sp,sp,16
    80003d18:	8082                	ret

0000000080003d1a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003d1a:	1101                	addi	sp,sp,-32
    80003d1c:	ec06                	sd	ra,24(sp)
    80003d1e:	e822                	sd	s0,16(sp)
    80003d20:	e426                	sd	s1,8(sp)
    80003d22:	e04a                	sd	s2,0(sp)
    80003d24:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003d26:	0001c917          	auipc	s2,0x1c
    80003d2a:	29290913          	addi	s2,s2,658 # 8001ffb8 <log>
    80003d2e:	01892583          	lw	a1,24(s2)
    80003d32:	02492503          	lw	a0,36(s2)
    80003d36:	912ff0ef          	jal	ra,80002e48 <bread>
    80003d3a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003d3c:	02892683          	lw	a3,40(s2)
    80003d40:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003d42:	02d05763          	blez	a3,80003d70 <write_head+0x56>
    80003d46:	0001c797          	auipc	a5,0x1c
    80003d4a:	29e78793          	addi	a5,a5,670 # 8001ffe4 <log+0x2c>
    80003d4e:	05c50713          	addi	a4,a0,92
    80003d52:	36fd                	addiw	a3,a3,-1
    80003d54:	1682                	slli	a3,a3,0x20
    80003d56:	9281                	srli	a3,a3,0x20
    80003d58:	068a                	slli	a3,a3,0x2
    80003d5a:	0001c617          	auipc	a2,0x1c
    80003d5e:	28e60613          	addi	a2,a2,654 # 8001ffe8 <log+0x30>
    80003d62:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003d64:	4390                	lw	a2,0(a5)
    80003d66:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003d68:	0791                	addi	a5,a5,4
    80003d6a:	0711                	addi	a4,a4,4
    80003d6c:	fed79ce3          	bne	a5,a3,80003d64 <write_head+0x4a>
  }
  bwrite(buf);
    80003d70:	8526                	mv	a0,s1
    80003d72:	9acff0ef          	jal	ra,80002f1e <bwrite>
  brelse(buf);
    80003d76:	8526                	mv	a0,s1
    80003d78:	9d8ff0ef          	jal	ra,80002f50 <brelse>
}
    80003d7c:	60e2                	ld	ra,24(sp)
    80003d7e:	6442                	ld	s0,16(sp)
    80003d80:	64a2                	ld	s1,8(sp)
    80003d82:	6902                	ld	s2,0(sp)
    80003d84:	6105                	addi	sp,sp,32
    80003d86:	8082                	ret

0000000080003d88 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d88:	0001c797          	auipc	a5,0x1c
    80003d8c:	2587a783          	lw	a5,600(a5) # 8001ffe0 <log+0x28>
    80003d90:	0af05e63          	blez	a5,80003e4c <install_trans+0xc4>
{
    80003d94:	715d                	addi	sp,sp,-80
    80003d96:	e486                	sd	ra,72(sp)
    80003d98:	e0a2                	sd	s0,64(sp)
    80003d9a:	fc26                	sd	s1,56(sp)
    80003d9c:	f84a                	sd	s2,48(sp)
    80003d9e:	f44e                	sd	s3,40(sp)
    80003da0:	f052                	sd	s4,32(sp)
    80003da2:	ec56                	sd	s5,24(sp)
    80003da4:	e85a                	sd	s6,16(sp)
    80003da6:	e45e                	sd	s7,8(sp)
    80003da8:	0880                	addi	s0,sp,80
    80003daa:	8b2a                	mv	s6,a0
    80003dac:	0001ca97          	auipc	s5,0x1c
    80003db0:	238a8a93          	addi	s5,s5,568 # 8001ffe4 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003db4:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003db6:	00004b97          	auipc	s7,0x4
    80003dba:	83ab8b93          	addi	s7,s7,-1990 # 800075f0 <syscalls+0x200>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003dbe:	0001ca17          	auipc	s4,0x1c
    80003dc2:	1faa0a13          	addi	s4,s4,506 # 8001ffb8 <log>
    80003dc6:	a03d                	j	80003df4 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003dc8:	000aa603          	lw	a2,0(s5)
    80003dcc:	85ce                	mv	a1,s3
    80003dce:	855e                	mv	a0,s7
    80003dd0:	efafc0ef          	jal	ra,800004ca <printf>
    80003dd4:	a015                	j	80003df8 <install_trans+0x70>
      bunpin(dbuf);
    80003dd6:	8526                	mv	a0,s1
    80003dd8:	a36ff0ef          	jal	ra,8000300e <bunpin>
    brelse(lbuf);
    80003ddc:	854a                	mv	a0,s2
    80003dde:	972ff0ef          	jal	ra,80002f50 <brelse>
    brelse(dbuf);
    80003de2:	8526                	mv	a0,s1
    80003de4:	96cff0ef          	jal	ra,80002f50 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003de8:	2985                	addiw	s3,s3,1
    80003dea:	0a91                	addi	s5,s5,4
    80003dec:	028a2783          	lw	a5,40(s4)
    80003df0:	04f9d363          	bge	s3,a5,80003e36 <install_trans+0xae>
    if(recovering) {
    80003df4:	fc0b1ae3          	bnez	s6,80003dc8 <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003df8:	018a2583          	lw	a1,24(s4)
    80003dfc:	013585bb          	addw	a1,a1,s3
    80003e00:	2585                	addiw	a1,a1,1
    80003e02:	024a2503          	lw	a0,36(s4)
    80003e06:	842ff0ef          	jal	ra,80002e48 <bread>
    80003e0a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003e0c:	000aa583          	lw	a1,0(s5)
    80003e10:	024a2503          	lw	a0,36(s4)
    80003e14:	834ff0ef          	jal	ra,80002e48 <bread>
    80003e18:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003e1a:	40000613          	li	a2,1024
    80003e1e:	05890593          	addi	a1,s2,88
    80003e22:	05850513          	addi	a0,a0,88
    80003e26:	e89fc0ef          	jal	ra,80000cae <memmove>
    bwrite(dbuf);  // write dst to disk
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	8f2ff0ef          	jal	ra,80002f1e <bwrite>
    if(recovering == 0)
    80003e30:	fa0b16e3          	bnez	s6,80003ddc <install_trans+0x54>
    80003e34:	b74d                	j	80003dd6 <install_trans+0x4e>
}
    80003e36:	60a6                	ld	ra,72(sp)
    80003e38:	6406                	ld	s0,64(sp)
    80003e3a:	74e2                	ld	s1,56(sp)
    80003e3c:	7942                	ld	s2,48(sp)
    80003e3e:	79a2                	ld	s3,40(sp)
    80003e40:	7a02                	ld	s4,32(sp)
    80003e42:	6ae2                	ld	s5,24(sp)
    80003e44:	6b42                	ld	s6,16(sp)
    80003e46:	6ba2                	ld	s7,8(sp)
    80003e48:	6161                	addi	sp,sp,80
    80003e4a:	8082                	ret
    80003e4c:	8082                	ret

0000000080003e4e <initlog>:
{
    80003e4e:	7179                	addi	sp,sp,-48
    80003e50:	f406                	sd	ra,40(sp)
    80003e52:	f022                	sd	s0,32(sp)
    80003e54:	ec26                	sd	s1,24(sp)
    80003e56:	e84a                	sd	s2,16(sp)
    80003e58:	e44e                	sd	s3,8(sp)
    80003e5a:	1800                	addi	s0,sp,48
    80003e5c:	892a                	mv	s2,a0
    80003e5e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003e60:	0001c497          	auipc	s1,0x1c
    80003e64:	15848493          	addi	s1,s1,344 # 8001ffb8 <log>
    80003e68:	00003597          	auipc	a1,0x3
    80003e6c:	7a858593          	addi	a1,a1,1960 # 80007610 <syscalls+0x220>
    80003e70:	8526                	mv	a0,s1
    80003e72:	c89fc0ef          	jal	ra,80000afa <initlock>
  log.start = sb->logstart;
    80003e76:	0149a583          	lw	a1,20(s3)
    80003e7a:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003e7c:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003e80:	854a                	mv	a0,s2
    80003e82:	fc7fe0ef          	jal	ra,80002e48 <bread>
  log.lh.n = lh->n;
    80003e86:	4d3c                	lw	a5,88(a0)
    80003e88:	d49c                	sw	a5,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003e8a:	02f05563          	blez	a5,80003eb4 <initlog+0x66>
    80003e8e:	05c50713          	addi	a4,a0,92
    80003e92:	0001c697          	auipc	a3,0x1c
    80003e96:	15268693          	addi	a3,a3,338 # 8001ffe4 <log+0x2c>
    80003e9a:	37fd                	addiw	a5,a5,-1
    80003e9c:	1782                	slli	a5,a5,0x20
    80003e9e:	9381                	srli	a5,a5,0x20
    80003ea0:	078a                	slli	a5,a5,0x2
    80003ea2:	06050613          	addi	a2,a0,96
    80003ea6:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003ea8:	4310                	lw	a2,0(a4)
    80003eaa:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003eac:	0711                	addi	a4,a4,4
    80003eae:	0691                	addi	a3,a3,4
    80003eb0:	fef71ce3          	bne	a4,a5,80003ea8 <initlog+0x5a>
  brelse(buf);
    80003eb4:	89cff0ef          	jal	ra,80002f50 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003eb8:	4505                	li	a0,1
    80003eba:	ecfff0ef          	jal	ra,80003d88 <install_trans>
  log.lh.n = 0;
    80003ebe:	0001c797          	auipc	a5,0x1c
    80003ec2:	1207a123          	sw	zero,290(a5) # 8001ffe0 <log+0x28>
  write_head(); // clear the log
    80003ec6:	e55ff0ef          	jal	ra,80003d1a <write_head>
}
    80003eca:	70a2                	ld	ra,40(sp)
    80003ecc:	7402                	ld	s0,32(sp)
    80003ece:	64e2                	ld	s1,24(sp)
    80003ed0:	6942                	ld	s2,16(sp)
    80003ed2:	69a2                	ld	s3,8(sp)
    80003ed4:	6145                	addi	sp,sp,48
    80003ed6:	8082                	ret

0000000080003ed8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003ed8:	1101                	addi	sp,sp,-32
    80003eda:	ec06                	sd	ra,24(sp)
    80003edc:	e822                	sd	s0,16(sp)
    80003ede:	e426                	sd	s1,8(sp)
    80003ee0:	e04a                	sd	s2,0(sp)
    80003ee2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ee4:	0001c517          	auipc	a0,0x1c
    80003ee8:	0d450513          	addi	a0,a0,212 # 8001ffb8 <log>
    80003eec:	c8ffc0ef          	jal	ra,80000b7a <acquire>
  while(1){
    if(log.committing){
    80003ef0:	0001c497          	auipc	s1,0x1c
    80003ef4:	0c848493          	addi	s1,s1,200 # 8001ffb8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003ef8:	4979                	li	s2,30
    80003efa:	a029                	j	80003f04 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003efc:	85a6                	mv	a1,s1
    80003efe:	8526                	mv	a0,s1
    80003f00:	dc3fd0ef          	jal	ra,80001cc2 <sleep>
    if(log.committing){
    80003f04:	509c                	lw	a5,32(s1)
    80003f06:	fbfd                	bnez	a5,80003efc <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003f08:	4cdc                	lw	a5,28(s1)
    80003f0a:	0017871b          	addiw	a4,a5,1
    80003f0e:	0007069b          	sext.w	a3,a4
    80003f12:	0027179b          	slliw	a5,a4,0x2
    80003f16:	9fb9                	addw	a5,a5,a4
    80003f18:	0017979b          	slliw	a5,a5,0x1
    80003f1c:	5498                	lw	a4,40(s1)
    80003f1e:	9fb9                	addw	a5,a5,a4
    80003f20:	00f95763          	bge	s2,a5,80003f2e <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003f24:	85a6                	mv	a1,s1
    80003f26:	8526                	mv	a0,s1
    80003f28:	d9bfd0ef          	jal	ra,80001cc2 <sleep>
    80003f2c:	bfe1                	j	80003f04 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003f2e:	0001c517          	auipc	a0,0x1c
    80003f32:	08a50513          	addi	a0,a0,138 # 8001ffb8 <log>
    80003f36:	cd54                	sw	a3,28(a0)
      release(&log.lock);
    80003f38:	cdbfc0ef          	jal	ra,80000c12 <release>
      break;
    }
  }
}
    80003f3c:	60e2                	ld	ra,24(sp)
    80003f3e:	6442                	ld	s0,16(sp)
    80003f40:	64a2                	ld	s1,8(sp)
    80003f42:	6902                	ld	s2,0(sp)
    80003f44:	6105                	addi	sp,sp,32
    80003f46:	8082                	ret

0000000080003f48 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003f48:	7139                	addi	sp,sp,-64
    80003f4a:	fc06                	sd	ra,56(sp)
    80003f4c:	f822                	sd	s0,48(sp)
    80003f4e:	f426                	sd	s1,40(sp)
    80003f50:	f04a                	sd	s2,32(sp)
    80003f52:	ec4e                	sd	s3,24(sp)
    80003f54:	e852                	sd	s4,16(sp)
    80003f56:	e456                	sd	s5,8(sp)
    80003f58:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003f5a:	0001c497          	auipc	s1,0x1c
    80003f5e:	05e48493          	addi	s1,s1,94 # 8001ffb8 <log>
    80003f62:	8526                	mv	a0,s1
    80003f64:	c17fc0ef          	jal	ra,80000b7a <acquire>
  log.outstanding -= 1;
    80003f68:	4cdc                	lw	a5,28(s1)
    80003f6a:	37fd                	addiw	a5,a5,-1
    80003f6c:	0007891b          	sext.w	s2,a5
    80003f70:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003f72:	509c                	lw	a5,32(s1)
    80003f74:	e7b9                	bnez	a5,80003fc2 <end_op+0x7a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003f76:	04091c63          	bnez	s2,80003fce <end_op+0x86>
    do_commit = 1;
    log.committing = 1;
    80003f7a:	0001c497          	auipc	s1,0x1c
    80003f7e:	03e48493          	addi	s1,s1,62 # 8001ffb8 <log>
    80003f82:	4785                	li	a5,1
    80003f84:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003f86:	8526                	mv	a0,s1
    80003f88:	c8bfc0ef          	jal	ra,80000c12 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003f8c:	549c                	lw	a5,40(s1)
    80003f8e:	04f04b63          	bgtz	a5,80003fe4 <end_op+0x9c>
    acquire(&log.lock);
    80003f92:	0001c497          	auipc	s1,0x1c
    80003f96:	02648493          	addi	s1,s1,38 # 8001ffb8 <log>
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	bdffc0ef          	jal	ra,80000b7a <acquire>
    log.committing = 0;
    80003fa0:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	d6ffd0ef          	jal	ra,80001d14 <wakeup>
    release(&log.lock);
    80003faa:	8526                	mv	a0,s1
    80003fac:	c67fc0ef          	jal	ra,80000c12 <release>
}
    80003fb0:	70e2                	ld	ra,56(sp)
    80003fb2:	7442                	ld	s0,48(sp)
    80003fb4:	74a2                	ld	s1,40(sp)
    80003fb6:	7902                	ld	s2,32(sp)
    80003fb8:	69e2                	ld	s3,24(sp)
    80003fba:	6a42                	ld	s4,16(sp)
    80003fbc:	6aa2                	ld	s5,8(sp)
    80003fbe:	6121                	addi	sp,sp,64
    80003fc0:	8082                	ret
    panic("log.committing");
    80003fc2:	00003517          	auipc	a0,0x3
    80003fc6:	65650513          	addi	a0,a0,1622 # 80007618 <syscalls+0x228>
    80003fca:	fc6fc0ef          	jal	ra,80000790 <panic>
    wakeup(&log);
    80003fce:	0001c497          	auipc	s1,0x1c
    80003fd2:	fea48493          	addi	s1,s1,-22 # 8001ffb8 <log>
    80003fd6:	8526                	mv	a0,s1
    80003fd8:	d3dfd0ef          	jal	ra,80001d14 <wakeup>
  release(&log.lock);
    80003fdc:	8526                	mv	a0,s1
    80003fde:	c35fc0ef          	jal	ra,80000c12 <release>
  if(do_commit){
    80003fe2:	b7f9                	j	80003fb0 <end_op+0x68>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fe4:	0001ca97          	auipc	s5,0x1c
    80003fe8:	000a8a93          	mv	s5,s5
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003fec:	0001ca17          	auipc	s4,0x1c
    80003ff0:	fcca0a13          	addi	s4,s4,-52 # 8001ffb8 <log>
    80003ff4:	018a2583          	lw	a1,24(s4)
    80003ff8:	012585bb          	addw	a1,a1,s2
    80003ffc:	2585                	addiw	a1,a1,1
    80003ffe:	024a2503          	lw	a0,36(s4)
    80004002:	e47fe0ef          	jal	ra,80002e48 <bread>
    80004006:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004008:	000aa583          	lw	a1,0(s5) # 8001ffe4 <log+0x2c>
    8000400c:	024a2503          	lw	a0,36(s4)
    80004010:	e39fe0ef          	jal	ra,80002e48 <bread>
    80004014:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004016:	40000613          	li	a2,1024
    8000401a:	05850593          	addi	a1,a0,88
    8000401e:	05848513          	addi	a0,s1,88
    80004022:	c8dfc0ef          	jal	ra,80000cae <memmove>
    bwrite(to);  // write the log
    80004026:	8526                	mv	a0,s1
    80004028:	ef7fe0ef          	jal	ra,80002f1e <bwrite>
    brelse(from);
    8000402c:	854e                	mv	a0,s3
    8000402e:	f23fe0ef          	jal	ra,80002f50 <brelse>
    brelse(to);
    80004032:	8526                	mv	a0,s1
    80004034:	f1dfe0ef          	jal	ra,80002f50 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004038:	2905                	addiw	s2,s2,1
    8000403a:	0a91                	addi	s5,s5,4
    8000403c:	028a2783          	lw	a5,40(s4)
    80004040:	faf94ae3          	blt	s2,a5,80003ff4 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004044:	cd7ff0ef          	jal	ra,80003d1a <write_head>
    install_trans(0); // Now install writes to home locations
    80004048:	4501                	li	a0,0
    8000404a:	d3fff0ef          	jal	ra,80003d88 <install_trans>
    log.lh.n = 0;
    8000404e:	0001c797          	auipc	a5,0x1c
    80004052:	f807a923          	sw	zero,-110(a5) # 8001ffe0 <log+0x28>
    write_head();    // Erase the transaction from the log
    80004056:	cc5ff0ef          	jal	ra,80003d1a <write_head>
    8000405a:	bf25                	j	80003f92 <end_op+0x4a>

000000008000405c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000405c:	1101                	addi	sp,sp,-32
    8000405e:	ec06                	sd	ra,24(sp)
    80004060:	e822                	sd	s0,16(sp)
    80004062:	e426                	sd	s1,8(sp)
    80004064:	e04a                	sd	s2,0(sp)
    80004066:	1000                	addi	s0,sp,32
    80004068:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000406a:	0001c917          	auipc	s2,0x1c
    8000406e:	f4e90913          	addi	s2,s2,-178 # 8001ffb8 <log>
    80004072:	854a                	mv	a0,s2
    80004074:	b07fc0ef          	jal	ra,80000b7a <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80004078:	02892603          	lw	a2,40(s2)
    8000407c:	47f5                	li	a5,29
    8000407e:	04c7cc63          	blt	a5,a2,800040d6 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004082:	0001c797          	auipc	a5,0x1c
    80004086:	f527a783          	lw	a5,-174(a5) # 8001ffd4 <log+0x1c>
    8000408a:	04f05c63          	blez	a5,800040e2 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000408e:	4781                	li	a5,0
    80004090:	04c05f63          	blez	a2,800040ee <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004094:	44cc                	lw	a1,12(s1)
    80004096:	0001c717          	auipc	a4,0x1c
    8000409a:	f4e70713          	addi	a4,a4,-178 # 8001ffe4 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    8000409e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800040a0:	4314                	lw	a3,0(a4)
    800040a2:	04b68663          	beq	a3,a1,800040ee <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    800040a6:	2785                	addiw	a5,a5,1
    800040a8:	0711                	addi	a4,a4,4
    800040aa:	fef61be3          	bne	a2,a5,800040a0 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800040ae:	0621                	addi	a2,a2,8
    800040b0:	060a                	slli	a2,a2,0x2
    800040b2:	0001c797          	auipc	a5,0x1c
    800040b6:	f0678793          	addi	a5,a5,-250 # 8001ffb8 <log>
    800040ba:	963e                	add	a2,a2,a5
    800040bc:	44dc                	lw	a5,12(s1)
    800040be:	c65c                	sw	a5,12(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800040c0:	8526                	mv	a0,s1
    800040c2:	f19fe0ef          	jal	ra,80002fda <bpin>
    log.lh.n++;
    800040c6:	0001c717          	auipc	a4,0x1c
    800040ca:	ef270713          	addi	a4,a4,-270 # 8001ffb8 <log>
    800040ce:	571c                	lw	a5,40(a4)
    800040d0:	2785                	addiw	a5,a5,1
    800040d2:	d71c                	sw	a5,40(a4)
    800040d4:	a815                	j	80004108 <log_write+0xac>
    panic("too big a transaction");
    800040d6:	00003517          	auipc	a0,0x3
    800040da:	55250513          	addi	a0,a0,1362 # 80007628 <syscalls+0x238>
    800040de:	eb2fc0ef          	jal	ra,80000790 <panic>
    panic("log_write outside of trans");
    800040e2:	00003517          	auipc	a0,0x3
    800040e6:	55e50513          	addi	a0,a0,1374 # 80007640 <syscalls+0x250>
    800040ea:	ea6fc0ef          	jal	ra,80000790 <panic>
  log.lh.block[i] = b->blockno;
    800040ee:	00878713          	addi	a4,a5,8
    800040f2:	00271693          	slli	a3,a4,0x2
    800040f6:	0001c717          	auipc	a4,0x1c
    800040fa:	ec270713          	addi	a4,a4,-318 # 8001ffb8 <log>
    800040fe:	9736                	add	a4,a4,a3
    80004100:	44d4                	lw	a3,12(s1)
    80004102:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004104:	faf60ee3          	beq	a2,a5,800040c0 <log_write+0x64>
  }
  release(&log.lock);
    80004108:	0001c517          	auipc	a0,0x1c
    8000410c:	eb050513          	addi	a0,a0,-336 # 8001ffb8 <log>
    80004110:	b03fc0ef          	jal	ra,80000c12 <release>
}
    80004114:	60e2                	ld	ra,24(sp)
    80004116:	6442                	ld	s0,16(sp)
    80004118:	64a2                	ld	s1,8(sp)
    8000411a:	6902                	ld	s2,0(sp)
    8000411c:	6105                	addi	sp,sp,32
    8000411e:	8082                	ret

0000000080004120 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004120:	1101                	addi	sp,sp,-32
    80004122:	ec06                	sd	ra,24(sp)
    80004124:	e822                	sd	s0,16(sp)
    80004126:	e426                	sd	s1,8(sp)
    80004128:	e04a                	sd	s2,0(sp)
    8000412a:	1000                	addi	s0,sp,32
    8000412c:	84aa                	mv	s1,a0
    8000412e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004130:	00003597          	auipc	a1,0x3
    80004134:	53058593          	addi	a1,a1,1328 # 80007660 <syscalls+0x270>
    80004138:	0521                	addi	a0,a0,8
    8000413a:	9c1fc0ef          	jal	ra,80000afa <initlock>
  lk->name = name;
    8000413e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004142:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004146:	0204a423          	sw	zero,40(s1)
}
    8000414a:	60e2                	ld	ra,24(sp)
    8000414c:	6442                	ld	s0,16(sp)
    8000414e:	64a2                	ld	s1,8(sp)
    80004150:	6902                	ld	s2,0(sp)
    80004152:	6105                	addi	sp,sp,32
    80004154:	8082                	ret

0000000080004156 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004156:	1101                	addi	sp,sp,-32
    80004158:	ec06                	sd	ra,24(sp)
    8000415a:	e822                	sd	s0,16(sp)
    8000415c:	e426                	sd	s1,8(sp)
    8000415e:	e04a                	sd	s2,0(sp)
    80004160:	1000                	addi	s0,sp,32
    80004162:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004164:	00850913          	addi	s2,a0,8
    80004168:	854a                	mv	a0,s2
    8000416a:	a11fc0ef          	jal	ra,80000b7a <acquire>
  while (lk->locked) {
    8000416e:	409c                	lw	a5,0(s1)
    80004170:	c799                	beqz	a5,8000417e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004172:	85ca                	mv	a1,s2
    80004174:	8526                	mv	a0,s1
    80004176:	b4dfd0ef          	jal	ra,80001cc2 <sleep>
  while (lk->locked) {
    8000417a:	409c                	lw	a5,0(s1)
    8000417c:	fbfd                	bnez	a5,80004172 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000417e:	4785                	li	a5,1
    80004180:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004182:	ebefd0ef          	jal	ra,80001840 <myproc>
    80004186:	591c                	lw	a5,48(a0)
    80004188:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000418a:	854a                	mv	a0,s2
    8000418c:	a87fc0ef          	jal	ra,80000c12 <release>
}
    80004190:	60e2                	ld	ra,24(sp)
    80004192:	6442                	ld	s0,16(sp)
    80004194:	64a2                	ld	s1,8(sp)
    80004196:	6902                	ld	s2,0(sp)
    80004198:	6105                	addi	sp,sp,32
    8000419a:	8082                	ret

000000008000419c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000419c:	1101                	addi	sp,sp,-32
    8000419e:	ec06                	sd	ra,24(sp)
    800041a0:	e822                	sd	s0,16(sp)
    800041a2:	e426                	sd	s1,8(sp)
    800041a4:	e04a                	sd	s2,0(sp)
    800041a6:	1000                	addi	s0,sp,32
    800041a8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800041aa:	00850913          	addi	s2,a0,8
    800041ae:	854a                	mv	a0,s2
    800041b0:	9cbfc0ef          	jal	ra,80000b7a <acquire>
  lk->locked = 0;
    800041b4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800041b8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800041bc:	8526                	mv	a0,s1
    800041be:	b57fd0ef          	jal	ra,80001d14 <wakeup>
  release(&lk->lk);
    800041c2:	854a                	mv	a0,s2
    800041c4:	a4ffc0ef          	jal	ra,80000c12 <release>
}
    800041c8:	60e2                	ld	ra,24(sp)
    800041ca:	6442                	ld	s0,16(sp)
    800041cc:	64a2                	ld	s1,8(sp)
    800041ce:	6902                	ld	s2,0(sp)
    800041d0:	6105                	addi	sp,sp,32
    800041d2:	8082                	ret

00000000800041d4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800041d4:	7179                	addi	sp,sp,-48
    800041d6:	f406                	sd	ra,40(sp)
    800041d8:	f022                	sd	s0,32(sp)
    800041da:	ec26                	sd	s1,24(sp)
    800041dc:	e84a                	sd	s2,16(sp)
    800041de:	e44e                	sd	s3,8(sp)
    800041e0:	1800                	addi	s0,sp,48
    800041e2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800041e4:	00850913          	addi	s2,a0,8
    800041e8:	854a                	mv	a0,s2
    800041ea:	991fc0ef          	jal	ra,80000b7a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800041ee:	409c                	lw	a5,0(s1)
    800041f0:	ef89                	bnez	a5,8000420a <holdingsleep+0x36>
    800041f2:	4481                	li	s1,0
  release(&lk->lk);
    800041f4:	854a                	mv	a0,s2
    800041f6:	a1dfc0ef          	jal	ra,80000c12 <release>
  return r;
}
    800041fa:	8526                	mv	a0,s1
    800041fc:	70a2                	ld	ra,40(sp)
    800041fe:	7402                	ld	s0,32(sp)
    80004200:	64e2                	ld	s1,24(sp)
    80004202:	6942                	ld	s2,16(sp)
    80004204:	69a2                	ld	s3,8(sp)
    80004206:	6145                	addi	sp,sp,48
    80004208:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000420a:	0284a983          	lw	s3,40(s1)
    8000420e:	e32fd0ef          	jal	ra,80001840 <myproc>
    80004212:	5904                	lw	s1,48(a0)
    80004214:	413484b3          	sub	s1,s1,s3
    80004218:	0014b493          	seqz	s1,s1
    8000421c:	bfe1                	j	800041f4 <holdingsleep+0x20>

000000008000421e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000421e:	1141                	addi	sp,sp,-16
    80004220:	e406                	sd	ra,8(sp)
    80004222:	e022                	sd	s0,0(sp)
    80004224:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004226:	00003597          	auipc	a1,0x3
    8000422a:	44a58593          	addi	a1,a1,1098 # 80007670 <syscalls+0x280>
    8000422e:	0001c517          	auipc	a0,0x1c
    80004232:	ed250513          	addi	a0,a0,-302 # 80020100 <ftable>
    80004236:	8c5fc0ef          	jal	ra,80000afa <initlock>
}
    8000423a:	60a2                	ld	ra,8(sp)
    8000423c:	6402                	ld	s0,0(sp)
    8000423e:	0141                	addi	sp,sp,16
    80004240:	8082                	ret

0000000080004242 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004242:	1101                	addi	sp,sp,-32
    80004244:	ec06                	sd	ra,24(sp)
    80004246:	e822                	sd	s0,16(sp)
    80004248:	e426                	sd	s1,8(sp)
    8000424a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000424c:	0001c517          	auipc	a0,0x1c
    80004250:	eb450513          	addi	a0,a0,-332 # 80020100 <ftable>
    80004254:	927fc0ef          	jal	ra,80000b7a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004258:	0001c497          	auipc	s1,0x1c
    8000425c:	ec048493          	addi	s1,s1,-320 # 80020118 <ftable+0x18>
    80004260:	0001d717          	auipc	a4,0x1d
    80004264:	e5870713          	addi	a4,a4,-424 # 800210b8 <disk>
    if(f->ref == 0){
    80004268:	40dc                	lw	a5,4(s1)
    8000426a:	cf89                	beqz	a5,80004284 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000426c:	02848493          	addi	s1,s1,40
    80004270:	fee49ce3          	bne	s1,a4,80004268 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004274:	0001c517          	auipc	a0,0x1c
    80004278:	e8c50513          	addi	a0,a0,-372 # 80020100 <ftable>
    8000427c:	997fc0ef          	jal	ra,80000c12 <release>
  return 0;
    80004280:	4481                	li	s1,0
    80004282:	a809                	j	80004294 <filealloc+0x52>
      f->ref = 1;
    80004284:	4785                	li	a5,1
    80004286:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004288:	0001c517          	auipc	a0,0x1c
    8000428c:	e7850513          	addi	a0,a0,-392 # 80020100 <ftable>
    80004290:	983fc0ef          	jal	ra,80000c12 <release>
}
    80004294:	8526                	mv	a0,s1
    80004296:	60e2                	ld	ra,24(sp)
    80004298:	6442                	ld	s0,16(sp)
    8000429a:	64a2                	ld	s1,8(sp)
    8000429c:	6105                	addi	sp,sp,32
    8000429e:	8082                	ret

00000000800042a0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800042a0:	1101                	addi	sp,sp,-32
    800042a2:	ec06                	sd	ra,24(sp)
    800042a4:	e822                	sd	s0,16(sp)
    800042a6:	e426                	sd	s1,8(sp)
    800042a8:	1000                	addi	s0,sp,32
    800042aa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800042ac:	0001c517          	auipc	a0,0x1c
    800042b0:	e5450513          	addi	a0,a0,-428 # 80020100 <ftable>
    800042b4:	8c7fc0ef          	jal	ra,80000b7a <acquire>
  if(f->ref < 1)
    800042b8:	40dc                	lw	a5,4(s1)
    800042ba:	02f05063          	blez	a5,800042da <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800042be:	2785                	addiw	a5,a5,1
    800042c0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800042c2:	0001c517          	auipc	a0,0x1c
    800042c6:	e3e50513          	addi	a0,a0,-450 # 80020100 <ftable>
    800042ca:	949fc0ef          	jal	ra,80000c12 <release>
  return f;
}
    800042ce:	8526                	mv	a0,s1
    800042d0:	60e2                	ld	ra,24(sp)
    800042d2:	6442                	ld	s0,16(sp)
    800042d4:	64a2                	ld	s1,8(sp)
    800042d6:	6105                	addi	sp,sp,32
    800042d8:	8082                	ret
    panic("filedup");
    800042da:	00003517          	auipc	a0,0x3
    800042de:	39e50513          	addi	a0,a0,926 # 80007678 <syscalls+0x288>
    800042e2:	caefc0ef          	jal	ra,80000790 <panic>

00000000800042e6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800042e6:	7139                	addi	sp,sp,-64
    800042e8:	fc06                	sd	ra,56(sp)
    800042ea:	f822                	sd	s0,48(sp)
    800042ec:	f426                	sd	s1,40(sp)
    800042ee:	f04a                	sd	s2,32(sp)
    800042f0:	ec4e                	sd	s3,24(sp)
    800042f2:	e852                	sd	s4,16(sp)
    800042f4:	e456                	sd	s5,8(sp)
    800042f6:	0080                	addi	s0,sp,64
    800042f8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800042fa:	0001c517          	auipc	a0,0x1c
    800042fe:	e0650513          	addi	a0,a0,-506 # 80020100 <ftable>
    80004302:	879fc0ef          	jal	ra,80000b7a <acquire>
  if(f->ref < 1)
    80004306:	40dc                	lw	a5,4(s1)
    80004308:	04f05963          	blez	a5,8000435a <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    8000430c:	37fd                	addiw	a5,a5,-1
    8000430e:	0007871b          	sext.w	a4,a5
    80004312:	c0dc                	sw	a5,4(s1)
    80004314:	04e04963          	bgtz	a4,80004366 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004318:	0004a903          	lw	s2,0(s1)
    8000431c:	0094ca83          	lbu	s5,9(s1)
    80004320:	0104ba03          	ld	s4,16(s1)
    80004324:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004328:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000432c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004330:	0001c517          	auipc	a0,0x1c
    80004334:	dd050513          	addi	a0,a0,-560 # 80020100 <ftable>
    80004338:	8dbfc0ef          	jal	ra,80000c12 <release>

  if(ff.type == FD_PIPE){
    8000433c:	4785                	li	a5,1
    8000433e:	04f90363          	beq	s2,a5,80004384 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004342:	3979                	addiw	s2,s2,-2
    80004344:	4785                	li	a5,1
    80004346:	0327e663          	bltu	a5,s2,80004372 <fileclose+0x8c>
    begin_op();
    8000434a:	b8fff0ef          	jal	ra,80003ed8 <begin_op>
    iput(ff.ip);
    8000434e:	854e                	mv	a0,s3
    80004350:	b28ff0ef          	jal	ra,80003678 <iput>
    end_op();
    80004354:	bf5ff0ef          	jal	ra,80003f48 <end_op>
    80004358:	a829                	j	80004372 <fileclose+0x8c>
    panic("fileclose");
    8000435a:	00003517          	auipc	a0,0x3
    8000435e:	32650513          	addi	a0,a0,806 # 80007680 <syscalls+0x290>
    80004362:	c2efc0ef          	jal	ra,80000790 <panic>
    release(&ftable.lock);
    80004366:	0001c517          	auipc	a0,0x1c
    8000436a:	d9a50513          	addi	a0,a0,-614 # 80020100 <ftable>
    8000436e:	8a5fc0ef          	jal	ra,80000c12 <release>
  }
}
    80004372:	70e2                	ld	ra,56(sp)
    80004374:	7442                	ld	s0,48(sp)
    80004376:	74a2                	ld	s1,40(sp)
    80004378:	7902                	ld	s2,32(sp)
    8000437a:	69e2                	ld	s3,24(sp)
    8000437c:	6a42                	ld	s4,16(sp)
    8000437e:	6aa2                	ld	s5,8(sp)
    80004380:	6121                	addi	sp,sp,64
    80004382:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004384:	85d6                	mv	a1,s5
    80004386:	8552                	mv	a0,s4
    80004388:	2ec000ef          	jal	ra,80004674 <pipeclose>
    8000438c:	b7dd                	j	80004372 <fileclose+0x8c>

000000008000438e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000438e:	715d                	addi	sp,sp,-80
    80004390:	e486                	sd	ra,72(sp)
    80004392:	e0a2                	sd	s0,64(sp)
    80004394:	fc26                	sd	s1,56(sp)
    80004396:	f84a                	sd	s2,48(sp)
    80004398:	f44e                	sd	s3,40(sp)
    8000439a:	0880                	addi	s0,sp,80
    8000439c:	84aa                	mv	s1,a0
    8000439e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800043a0:	ca0fd0ef          	jal	ra,80001840 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800043a4:	409c                	lw	a5,0(s1)
    800043a6:	37f9                	addiw	a5,a5,-2
    800043a8:	4705                	li	a4,1
    800043aa:	02f76f63          	bltu	a4,a5,800043e8 <filestat+0x5a>
    800043ae:	892a                	mv	s2,a0
    ilock(f->ip);
    800043b0:	6c88                	ld	a0,24(s1)
    800043b2:	948ff0ef          	jal	ra,800034fa <ilock>
    stati(f->ip, &st);
    800043b6:	fb840593          	addi	a1,s0,-72
    800043ba:	6c88                	ld	a0,24(s1)
    800043bc:	ca0ff0ef          	jal	ra,8000385c <stati>
    iunlock(f->ip);
    800043c0:	6c88                	ld	a0,24(s1)
    800043c2:	9e2ff0ef          	jal	ra,800035a4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800043c6:	46e1                	li	a3,24
    800043c8:	fb840613          	addi	a2,s0,-72
    800043cc:	85ce                	mv	a1,s3
    800043ce:	05093503          	ld	a0,80(s2)
    800043d2:	996fd0ef          	jal	ra,80001568 <copyout>
    800043d6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800043da:	60a6                	ld	ra,72(sp)
    800043dc:	6406                	ld	s0,64(sp)
    800043de:	74e2                	ld	s1,56(sp)
    800043e0:	7942                	ld	s2,48(sp)
    800043e2:	79a2                	ld	s3,40(sp)
    800043e4:	6161                	addi	sp,sp,80
    800043e6:	8082                	ret
  return -1;
    800043e8:	557d                	li	a0,-1
    800043ea:	bfc5                	j	800043da <filestat+0x4c>

00000000800043ec <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800043ec:	7179                	addi	sp,sp,-48
    800043ee:	f406                	sd	ra,40(sp)
    800043f0:	f022                	sd	s0,32(sp)
    800043f2:	ec26                	sd	s1,24(sp)
    800043f4:	e84a                	sd	s2,16(sp)
    800043f6:	e44e                	sd	s3,8(sp)
    800043f8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800043fa:	00854783          	lbu	a5,8(a0)
    800043fe:	cbc1                	beqz	a5,8000448e <fileread+0xa2>
    80004400:	84aa                	mv	s1,a0
    80004402:	89ae                	mv	s3,a1
    80004404:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004406:	411c                	lw	a5,0(a0)
    80004408:	4705                	li	a4,1
    8000440a:	04e78363          	beq	a5,a4,80004450 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000440e:	470d                	li	a4,3
    80004410:	04e78563          	beq	a5,a4,8000445a <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004414:	4709                	li	a4,2
    80004416:	06e79663          	bne	a5,a4,80004482 <fileread+0x96>
    ilock(f->ip);
    8000441a:	6d08                	ld	a0,24(a0)
    8000441c:	8deff0ef          	jal	ra,800034fa <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004420:	874a                	mv	a4,s2
    80004422:	5094                	lw	a3,32(s1)
    80004424:	864e                	mv	a2,s3
    80004426:	4585                	li	a1,1
    80004428:	6c88                	ld	a0,24(s1)
    8000442a:	c5cff0ef          	jal	ra,80003886 <readi>
    8000442e:	892a                	mv	s2,a0
    80004430:	00a05563          	blez	a0,8000443a <fileread+0x4e>
      f->off += r;
    80004434:	509c                	lw	a5,32(s1)
    80004436:	9fa9                	addw	a5,a5,a0
    80004438:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000443a:	6c88                	ld	a0,24(s1)
    8000443c:	968ff0ef          	jal	ra,800035a4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004440:	854a                	mv	a0,s2
    80004442:	70a2                	ld	ra,40(sp)
    80004444:	7402                	ld	s0,32(sp)
    80004446:	64e2                	ld	s1,24(sp)
    80004448:	6942                	ld	s2,16(sp)
    8000444a:	69a2                	ld	s3,8(sp)
    8000444c:	6145                	addi	sp,sp,48
    8000444e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004450:	6908                	ld	a0,16(a0)
    80004452:	356000ef          	jal	ra,800047a8 <piperead>
    80004456:	892a                	mv	s2,a0
    80004458:	b7e5                	j	80004440 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000445a:	02451783          	lh	a5,36(a0)
    8000445e:	03079693          	slli	a3,a5,0x30
    80004462:	92c1                	srli	a3,a3,0x30
    80004464:	4725                	li	a4,9
    80004466:	02d76663          	bltu	a4,a3,80004492 <fileread+0xa6>
    8000446a:	0792                	slli	a5,a5,0x4
    8000446c:	0001c717          	auipc	a4,0x1c
    80004470:	bf470713          	addi	a4,a4,-1036 # 80020060 <devsw>
    80004474:	97ba                	add	a5,a5,a4
    80004476:	639c                	ld	a5,0(a5)
    80004478:	cf99                	beqz	a5,80004496 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    8000447a:	4505                	li	a0,1
    8000447c:	9782                	jalr	a5
    8000447e:	892a                	mv	s2,a0
    80004480:	b7c1                	j	80004440 <fileread+0x54>
    panic("fileread");
    80004482:	00003517          	auipc	a0,0x3
    80004486:	20e50513          	addi	a0,a0,526 # 80007690 <syscalls+0x2a0>
    8000448a:	b06fc0ef          	jal	ra,80000790 <panic>
    return -1;
    8000448e:	597d                	li	s2,-1
    80004490:	bf45                	j	80004440 <fileread+0x54>
      return -1;
    80004492:	597d                	li	s2,-1
    80004494:	b775                	j	80004440 <fileread+0x54>
    80004496:	597d                	li	s2,-1
    80004498:	b765                	j	80004440 <fileread+0x54>

000000008000449a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    8000449a:	715d                	addi	sp,sp,-80
    8000449c:	e486                	sd	ra,72(sp)
    8000449e:	e0a2                	sd	s0,64(sp)
    800044a0:	fc26                	sd	s1,56(sp)
    800044a2:	f84a                	sd	s2,48(sp)
    800044a4:	f44e                	sd	s3,40(sp)
    800044a6:	f052                	sd	s4,32(sp)
    800044a8:	ec56                	sd	s5,24(sp)
    800044aa:	e85a                	sd	s6,16(sp)
    800044ac:	e45e                	sd	s7,8(sp)
    800044ae:	e062                	sd	s8,0(sp)
    800044b0:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800044b2:	00954783          	lbu	a5,9(a0)
    800044b6:	0e078863          	beqz	a5,800045a6 <filewrite+0x10c>
    800044ba:	892a                	mv	s2,a0
    800044bc:	8aae                	mv	s5,a1
    800044be:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800044c0:	411c                	lw	a5,0(a0)
    800044c2:	4705                	li	a4,1
    800044c4:	02e78263          	beq	a5,a4,800044e8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800044c8:	470d                	li	a4,3
    800044ca:	02e78463          	beq	a5,a4,800044f2 <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800044ce:	4709                	li	a4,2
    800044d0:	0ce79563          	bne	a5,a4,8000459a <filewrite+0x100>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800044d4:	0ac05163          	blez	a2,80004576 <filewrite+0xdc>
    int i = 0;
    800044d8:	4981                	li	s3,0
    800044da:	6b05                	lui	s6,0x1
    800044dc:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800044e0:	6b85                	lui	s7,0x1
    800044e2:	c00b8b9b          	addiw	s7,s7,-1024
    800044e6:	a041                	j	80004566 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800044e8:	6908                	ld	a0,16(a0)
    800044ea:	1e2000ef          	jal	ra,800046cc <pipewrite>
    800044ee:	8a2a                	mv	s4,a0
    800044f0:	a071                	j	8000457c <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800044f2:	02451783          	lh	a5,36(a0)
    800044f6:	03079693          	slli	a3,a5,0x30
    800044fa:	92c1                	srli	a3,a3,0x30
    800044fc:	4725                	li	a4,9
    800044fe:	0ad76663          	bltu	a4,a3,800045aa <filewrite+0x110>
    80004502:	0792                	slli	a5,a5,0x4
    80004504:	0001c717          	auipc	a4,0x1c
    80004508:	b5c70713          	addi	a4,a4,-1188 # 80020060 <devsw>
    8000450c:	97ba                	add	a5,a5,a4
    8000450e:	679c                	ld	a5,8(a5)
    80004510:	cfd9                	beqz	a5,800045ae <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    80004512:	4505                	li	a0,1
    80004514:	9782                	jalr	a5
    80004516:	8a2a                	mv	s4,a0
    80004518:	a095                	j	8000457c <filewrite+0xe2>
    8000451a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000451e:	9bbff0ef          	jal	ra,80003ed8 <begin_op>
      ilock(f->ip);
    80004522:	01893503          	ld	a0,24(s2)
    80004526:	fd5fe0ef          	jal	ra,800034fa <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000452a:	8762                	mv	a4,s8
    8000452c:	02092683          	lw	a3,32(s2)
    80004530:	01598633          	add	a2,s3,s5
    80004534:	4585                	li	a1,1
    80004536:	01893503          	ld	a0,24(s2)
    8000453a:	c30ff0ef          	jal	ra,8000396a <writei>
    8000453e:	84aa                	mv	s1,a0
    80004540:	00a05763          	blez	a0,8000454e <filewrite+0xb4>
        f->off += r;
    80004544:	02092783          	lw	a5,32(s2)
    80004548:	9fa9                	addw	a5,a5,a0
    8000454a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000454e:	01893503          	ld	a0,24(s2)
    80004552:	852ff0ef          	jal	ra,800035a4 <iunlock>
      end_op();
    80004556:	9f3ff0ef          	jal	ra,80003f48 <end_op>

      if(r != n1){
    8000455a:	009c1f63          	bne	s8,s1,80004578 <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    8000455e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004562:	0149db63          	bge	s3,s4,80004578 <filewrite+0xde>
      int n1 = n - i;
    80004566:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    8000456a:	84be                	mv	s1,a5
    8000456c:	2781                	sext.w	a5,a5
    8000456e:	fafb56e3          	bge	s6,a5,8000451a <filewrite+0x80>
    80004572:	84de                	mv	s1,s7
    80004574:	b75d                	j	8000451a <filewrite+0x80>
    int i = 0;
    80004576:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004578:	013a1f63          	bne	s4,s3,80004596 <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000457c:	8552                	mv	a0,s4
    8000457e:	60a6                	ld	ra,72(sp)
    80004580:	6406                	ld	s0,64(sp)
    80004582:	74e2                	ld	s1,56(sp)
    80004584:	7942                	ld	s2,48(sp)
    80004586:	79a2                	ld	s3,40(sp)
    80004588:	7a02                	ld	s4,32(sp)
    8000458a:	6ae2                	ld	s5,24(sp)
    8000458c:	6b42                	ld	s6,16(sp)
    8000458e:	6ba2                	ld	s7,8(sp)
    80004590:	6c02                	ld	s8,0(sp)
    80004592:	6161                	addi	sp,sp,80
    80004594:	8082                	ret
    ret = (i == n ? n : -1);
    80004596:	5a7d                	li	s4,-1
    80004598:	b7d5                	j	8000457c <filewrite+0xe2>
    panic("filewrite");
    8000459a:	00003517          	auipc	a0,0x3
    8000459e:	10650513          	addi	a0,a0,262 # 800076a0 <syscalls+0x2b0>
    800045a2:	9eefc0ef          	jal	ra,80000790 <panic>
    return -1;
    800045a6:	5a7d                	li	s4,-1
    800045a8:	bfd1                	j	8000457c <filewrite+0xe2>
      return -1;
    800045aa:	5a7d                	li	s4,-1
    800045ac:	bfc1                	j	8000457c <filewrite+0xe2>
    800045ae:	5a7d                	li	s4,-1
    800045b0:	b7f1                	j	8000457c <filewrite+0xe2>

00000000800045b2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800045b2:	7179                	addi	sp,sp,-48
    800045b4:	f406                	sd	ra,40(sp)
    800045b6:	f022                	sd	s0,32(sp)
    800045b8:	ec26                	sd	s1,24(sp)
    800045ba:	e84a                	sd	s2,16(sp)
    800045bc:	e44e                	sd	s3,8(sp)
    800045be:	e052                	sd	s4,0(sp)
    800045c0:	1800                	addi	s0,sp,48
    800045c2:	84aa                	mv	s1,a0
    800045c4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800045c6:	0005b023          	sd	zero,0(a1)
    800045ca:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800045ce:	c75ff0ef          	jal	ra,80004242 <filealloc>
    800045d2:	e088                	sd	a0,0(s1)
    800045d4:	cd35                	beqz	a0,80004650 <pipealloc+0x9e>
    800045d6:	c6dff0ef          	jal	ra,80004242 <filealloc>
    800045da:	00aa3023          	sd	a0,0(s4)
    800045de:	c52d                	beqz	a0,80004648 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800045e0:	ccafc0ef          	jal	ra,80000aaa <kalloc>
    800045e4:	892a                	mv	s2,a0
    800045e6:	cd31                	beqz	a0,80004642 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    800045e8:	4985                	li	s3,1
    800045ea:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800045ee:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800045f2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800045f6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800045fa:	00003597          	auipc	a1,0x3
    800045fe:	0b658593          	addi	a1,a1,182 # 800076b0 <syscalls+0x2c0>
    80004602:	cf8fc0ef          	jal	ra,80000afa <initlock>
  (*f0)->type = FD_PIPE;
    80004606:	609c                	ld	a5,0(s1)
    80004608:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000460c:	609c                	ld	a5,0(s1)
    8000460e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004612:	609c                	ld	a5,0(s1)
    80004614:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004618:	609c                	ld	a5,0(s1)
    8000461a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000461e:	000a3783          	ld	a5,0(s4)
    80004622:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004626:	000a3783          	ld	a5,0(s4)
    8000462a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000462e:	000a3783          	ld	a5,0(s4)
    80004632:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004636:	000a3783          	ld	a5,0(s4)
    8000463a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000463e:	4501                	li	a0,0
    80004640:	a005                	j	80004660 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004642:	6088                	ld	a0,0(s1)
    80004644:	e501                	bnez	a0,8000464c <pipealloc+0x9a>
    80004646:	a029                	j	80004650 <pipealloc+0x9e>
    80004648:	6088                	ld	a0,0(s1)
    8000464a:	c11d                	beqz	a0,80004670 <pipealloc+0xbe>
    fileclose(*f0);
    8000464c:	c9bff0ef          	jal	ra,800042e6 <fileclose>
  if(*f1)
    80004650:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004654:	557d                	li	a0,-1
  if(*f1)
    80004656:	c789                	beqz	a5,80004660 <pipealloc+0xae>
    fileclose(*f1);
    80004658:	853e                	mv	a0,a5
    8000465a:	c8dff0ef          	jal	ra,800042e6 <fileclose>
  return -1;
    8000465e:	557d                	li	a0,-1
}
    80004660:	70a2                	ld	ra,40(sp)
    80004662:	7402                	ld	s0,32(sp)
    80004664:	64e2                	ld	s1,24(sp)
    80004666:	6942                	ld	s2,16(sp)
    80004668:	69a2                	ld	s3,8(sp)
    8000466a:	6a02                	ld	s4,0(sp)
    8000466c:	6145                	addi	sp,sp,48
    8000466e:	8082                	ret
  return -1;
    80004670:	557d                	li	a0,-1
    80004672:	b7fd                	j	80004660 <pipealloc+0xae>

0000000080004674 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004674:	1101                	addi	sp,sp,-32
    80004676:	ec06                	sd	ra,24(sp)
    80004678:	e822                	sd	s0,16(sp)
    8000467a:	e426                	sd	s1,8(sp)
    8000467c:	e04a                	sd	s2,0(sp)
    8000467e:	1000                	addi	s0,sp,32
    80004680:	84aa                	mv	s1,a0
    80004682:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004684:	cf6fc0ef          	jal	ra,80000b7a <acquire>
  if(writable){
    80004688:	02090763          	beqz	s2,800046b6 <pipeclose+0x42>
    pi->writeopen = 0;
    8000468c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004690:	21848513          	addi	a0,s1,536
    80004694:	e80fd0ef          	jal	ra,80001d14 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004698:	2204b783          	ld	a5,544(s1)
    8000469c:	e785                	bnez	a5,800046c4 <pipeclose+0x50>
    release(&pi->lock);
    8000469e:	8526                	mv	a0,s1
    800046a0:	d72fc0ef          	jal	ra,80000c12 <release>
    kfree((char*)pi);
    800046a4:	8526                	mv	a0,s1
    800046a6:	b24fc0ef          	jal	ra,800009ca <kfree>
  } else
    release(&pi->lock);
}
    800046aa:	60e2                	ld	ra,24(sp)
    800046ac:	6442                	ld	s0,16(sp)
    800046ae:	64a2                	ld	s1,8(sp)
    800046b0:	6902                	ld	s2,0(sp)
    800046b2:	6105                	addi	sp,sp,32
    800046b4:	8082                	ret
    pi->readopen = 0;
    800046b6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800046ba:	21c48513          	addi	a0,s1,540
    800046be:	e56fd0ef          	jal	ra,80001d14 <wakeup>
    800046c2:	bfd9                	j	80004698 <pipeclose+0x24>
    release(&pi->lock);
    800046c4:	8526                	mv	a0,s1
    800046c6:	d4cfc0ef          	jal	ra,80000c12 <release>
}
    800046ca:	b7c5                	j	800046aa <pipeclose+0x36>

00000000800046cc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800046cc:	7159                	addi	sp,sp,-112
    800046ce:	f486                	sd	ra,104(sp)
    800046d0:	f0a2                	sd	s0,96(sp)
    800046d2:	eca6                	sd	s1,88(sp)
    800046d4:	e8ca                	sd	s2,80(sp)
    800046d6:	e4ce                	sd	s3,72(sp)
    800046d8:	e0d2                	sd	s4,64(sp)
    800046da:	fc56                	sd	s5,56(sp)
    800046dc:	f85a                	sd	s6,48(sp)
    800046de:	f45e                	sd	s7,40(sp)
    800046e0:	f062                	sd	s8,32(sp)
    800046e2:	ec66                	sd	s9,24(sp)
    800046e4:	1880                	addi	s0,sp,112
    800046e6:	84aa                	mv	s1,a0
    800046e8:	8aae                	mv	s5,a1
    800046ea:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800046ec:	954fd0ef          	jal	ra,80001840 <myproc>
    800046f0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800046f2:	8526                	mv	a0,s1
    800046f4:	c86fc0ef          	jal	ra,80000b7a <acquire>
  while(i < n){
    800046f8:	0b405663          	blez	s4,800047a4 <pipewrite+0xd8>
    800046fc:	8ba6                	mv	s7,s1
  int i = 0;
    800046fe:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004700:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004702:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004706:	21c48c13          	addi	s8,s1,540
    8000470a:	a899                	j	80004760 <pipewrite+0x94>
      release(&pi->lock);
    8000470c:	8526                	mv	a0,s1
    8000470e:	d04fc0ef          	jal	ra,80000c12 <release>
      return -1;
    80004712:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004714:	854a                	mv	a0,s2
    80004716:	70a6                	ld	ra,104(sp)
    80004718:	7406                	ld	s0,96(sp)
    8000471a:	64e6                	ld	s1,88(sp)
    8000471c:	6946                	ld	s2,80(sp)
    8000471e:	69a6                	ld	s3,72(sp)
    80004720:	6a06                	ld	s4,64(sp)
    80004722:	7ae2                	ld	s5,56(sp)
    80004724:	7b42                	ld	s6,48(sp)
    80004726:	7ba2                	ld	s7,40(sp)
    80004728:	7c02                	ld	s8,32(sp)
    8000472a:	6ce2                	ld	s9,24(sp)
    8000472c:	6165                	addi	sp,sp,112
    8000472e:	8082                	ret
      wakeup(&pi->nread);
    80004730:	8566                	mv	a0,s9
    80004732:	de2fd0ef          	jal	ra,80001d14 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004736:	85de                	mv	a1,s7
    80004738:	8562                	mv	a0,s8
    8000473a:	d88fd0ef          	jal	ra,80001cc2 <sleep>
    8000473e:	a839                	j	8000475c <pipewrite+0x90>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004740:	21c4a783          	lw	a5,540(s1)
    80004744:	0017871b          	addiw	a4,a5,1
    80004748:	20e4ae23          	sw	a4,540(s1)
    8000474c:	1ff7f793          	andi	a5,a5,511
    80004750:	97a6                	add	a5,a5,s1
    80004752:	f9f44703          	lbu	a4,-97(s0)
    80004756:	00e78c23          	sb	a4,24(a5)
      i++;
    8000475a:	2905                	addiw	s2,s2,1
  while(i < n){
    8000475c:	03495c63          	bge	s2,s4,80004794 <pipewrite+0xc8>
    if(pi->readopen == 0 || killed(pr)){
    80004760:	2204a783          	lw	a5,544(s1)
    80004764:	d7c5                	beqz	a5,8000470c <pipewrite+0x40>
    80004766:	854e                	mv	a0,s3
    80004768:	f98fd0ef          	jal	ra,80001f00 <killed>
    8000476c:	f145                	bnez	a0,8000470c <pipewrite+0x40>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000476e:	2184a783          	lw	a5,536(s1)
    80004772:	21c4a703          	lw	a4,540(s1)
    80004776:	2007879b          	addiw	a5,a5,512
    8000477a:	faf70be3          	beq	a4,a5,80004730 <pipewrite+0x64>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000477e:	4685                	li	a3,1
    80004780:	01590633          	add	a2,s2,s5
    80004784:	f9f40593          	addi	a1,s0,-97
    80004788:	0509b503          	ld	a0,80(s3)
    8000478c:	ea3fc0ef          	jal	ra,8000162e <copyin>
    80004790:	fb6518e3          	bne	a0,s6,80004740 <pipewrite+0x74>
  wakeup(&pi->nread);
    80004794:	21848513          	addi	a0,s1,536
    80004798:	d7cfd0ef          	jal	ra,80001d14 <wakeup>
  release(&pi->lock);
    8000479c:	8526                	mv	a0,s1
    8000479e:	c74fc0ef          	jal	ra,80000c12 <release>
  return i;
    800047a2:	bf8d                	j	80004714 <pipewrite+0x48>
  int i = 0;
    800047a4:	4901                	li	s2,0
    800047a6:	b7fd                	j	80004794 <pipewrite+0xc8>

00000000800047a8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800047a8:	715d                	addi	sp,sp,-80
    800047aa:	e486                	sd	ra,72(sp)
    800047ac:	e0a2                	sd	s0,64(sp)
    800047ae:	fc26                	sd	s1,56(sp)
    800047b0:	f84a                	sd	s2,48(sp)
    800047b2:	f44e                	sd	s3,40(sp)
    800047b4:	f052                	sd	s4,32(sp)
    800047b6:	ec56                	sd	s5,24(sp)
    800047b8:	e85a                	sd	s6,16(sp)
    800047ba:	0880                	addi	s0,sp,80
    800047bc:	84aa                	mv	s1,a0
    800047be:	892e                	mv	s2,a1
    800047c0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800047c2:	87efd0ef          	jal	ra,80001840 <myproc>
    800047c6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800047c8:	8b26                	mv	s6,s1
    800047ca:	8526                	mv	a0,s1
    800047cc:	baefc0ef          	jal	ra,80000b7a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047d0:	2184a703          	lw	a4,536(s1)
    800047d4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800047d8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047dc:	02f71363          	bne	a4,a5,80004802 <piperead+0x5a>
    800047e0:	2244a783          	lw	a5,548(s1)
    800047e4:	cf99                	beqz	a5,80004802 <piperead+0x5a>
    if(killed(pr)){
    800047e6:	8552                	mv	a0,s4
    800047e8:	f18fd0ef          	jal	ra,80001f00 <killed>
    800047ec:	e149                	bnez	a0,8000486e <piperead+0xc6>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800047ee:	85da                	mv	a1,s6
    800047f0:	854e                	mv	a0,s3
    800047f2:	cd0fd0ef          	jal	ra,80001cc2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047f6:	2184a703          	lw	a4,536(s1)
    800047fa:	21c4a783          	lw	a5,540(s1)
    800047fe:	fef701e3          	beq	a4,a5,800047e0 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004802:	07505f63          	blez	s5,80004880 <piperead+0xd8>
    80004806:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004808:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000480a:	2184a783          	lw	a5,536(s1)
    8000480e:	21c4a703          	lw	a4,540(s1)
    80004812:	02f70c63          	beq	a4,a5,8000484a <piperead+0xa2>
    ch = pi->data[pi->nread % PIPESIZE];
    80004816:	1ff7f793          	andi	a5,a5,511
    8000481a:	97a6                	add	a5,a5,s1
    8000481c:	0187c783          	lbu	a5,24(a5)
    80004820:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004824:	4685                	li	a3,1
    80004826:	fbf40613          	addi	a2,s0,-65
    8000482a:	85ca                	mv	a1,s2
    8000482c:	050a3503          	ld	a0,80(s4)
    80004830:	d39fc0ef          	jal	ra,80001568 <copyout>
    80004834:	05650263          	beq	a0,s6,80004878 <piperead+0xd0>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004838:	2184a783          	lw	a5,536(s1)
    8000483c:	2785                	addiw	a5,a5,1
    8000483e:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004842:	2985                	addiw	s3,s3,1
    80004844:	0905                	addi	s2,s2,1
    80004846:	fd3a92e3          	bne	s5,s3,8000480a <piperead+0x62>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000484a:	21c48513          	addi	a0,s1,540
    8000484e:	cc6fd0ef          	jal	ra,80001d14 <wakeup>
  release(&pi->lock);
    80004852:	8526                	mv	a0,s1
    80004854:	bbefc0ef          	jal	ra,80000c12 <release>
  return i;
}
    80004858:	854e                	mv	a0,s3
    8000485a:	60a6                	ld	ra,72(sp)
    8000485c:	6406                	ld	s0,64(sp)
    8000485e:	74e2                	ld	s1,56(sp)
    80004860:	7942                	ld	s2,48(sp)
    80004862:	79a2                	ld	s3,40(sp)
    80004864:	7a02                	ld	s4,32(sp)
    80004866:	6ae2                	ld	s5,24(sp)
    80004868:	6b42                	ld	s6,16(sp)
    8000486a:	6161                	addi	sp,sp,80
    8000486c:	8082                	ret
      release(&pi->lock);
    8000486e:	8526                	mv	a0,s1
    80004870:	ba2fc0ef          	jal	ra,80000c12 <release>
      return -1;
    80004874:	59fd                	li	s3,-1
    80004876:	b7cd                	j	80004858 <piperead+0xb0>
      if(i == 0)
    80004878:	fc0999e3          	bnez	s3,8000484a <piperead+0xa2>
        i = -1;
    8000487c:	89aa                	mv	s3,a0
    8000487e:	b7f1                	j	8000484a <piperead+0xa2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004880:	4981                	li	s3,0
    80004882:	b7e1                	j	8000484a <piperead+0xa2>

0000000080004884 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004884:	1141                	addi	sp,sp,-16
    80004886:	e422                	sd	s0,8(sp)
    80004888:	0800                	addi	s0,sp,16
    8000488a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000488c:	8905                	andi	a0,a0,1
    8000488e:	c111                	beqz	a0,80004892 <flags2perm+0xe>
      perm = PTE_X;
    80004890:	4521                	li	a0,8
    if(flags & 0x2)
    80004892:	8b89                	andi	a5,a5,2
    80004894:	c399                	beqz	a5,8000489a <flags2perm+0x16>
      perm |= PTE_W;
    80004896:	00456513          	ori	a0,a0,4
    return perm;
}
    8000489a:	6422                	ld	s0,8(sp)
    8000489c:	0141                	addi	sp,sp,16
    8000489e:	8082                	ret

00000000800048a0 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800048a0:	df010113          	addi	sp,sp,-528
    800048a4:	20113423          	sd	ra,520(sp)
    800048a8:	20813023          	sd	s0,512(sp)
    800048ac:	ffa6                	sd	s1,504(sp)
    800048ae:	fbca                	sd	s2,496(sp)
    800048b0:	f7ce                	sd	s3,488(sp)
    800048b2:	f3d2                	sd	s4,480(sp)
    800048b4:	efd6                	sd	s5,472(sp)
    800048b6:	ebda                	sd	s6,464(sp)
    800048b8:	e7de                	sd	s7,456(sp)
    800048ba:	e3e2                	sd	s8,448(sp)
    800048bc:	ff66                	sd	s9,440(sp)
    800048be:	fb6a                	sd	s10,432(sp)
    800048c0:	f76e                	sd	s11,424(sp)
    800048c2:	0c00                	addi	s0,sp,528
    800048c4:	84aa                	mv	s1,a0
    800048c6:	dea43c23          	sd	a0,-520(s0)
    800048ca:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800048ce:	f73fc0ef          	jal	ra,80001840 <myproc>
    800048d2:	892a                	mv	s2,a0

  begin_op();
    800048d4:	e04ff0ef          	jal	ra,80003ed8 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    800048d8:	8526                	mv	a0,s1
    800048da:	c0eff0ef          	jal	ra,80003ce8 <namei>
    800048de:	c12d                	beqz	a0,80004940 <kexec+0xa0>
    800048e0:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800048e2:	c19fe0ef          	jal	ra,800034fa <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800048e6:	04000713          	li	a4,64
    800048ea:	4681                	li	a3,0
    800048ec:	e5040613          	addi	a2,s0,-432
    800048f0:	4581                	li	a1,0
    800048f2:	8526                	mv	a0,s1
    800048f4:	f93fe0ef          	jal	ra,80003886 <readi>
    800048f8:	04000793          	li	a5,64
    800048fc:	00f51a63          	bne	a0,a5,80004910 <kexec+0x70>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004900:	e5042703          	lw	a4,-432(s0)
    80004904:	464c47b7          	lui	a5,0x464c4
    80004908:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000490c:	02f70e63          	beq	a4,a5,80004948 <kexec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004910:	8526                	mv	a0,s1
    80004912:	deffe0ef          	jal	ra,80003700 <iunlockput>
    end_op();
    80004916:	e32ff0ef          	jal	ra,80003f48 <end_op>
  }
  return -1;
    8000491a:	557d                	li	a0,-1
}
    8000491c:	20813083          	ld	ra,520(sp)
    80004920:	20013403          	ld	s0,512(sp)
    80004924:	74fe                	ld	s1,504(sp)
    80004926:	795e                	ld	s2,496(sp)
    80004928:	79be                	ld	s3,488(sp)
    8000492a:	7a1e                	ld	s4,480(sp)
    8000492c:	6afe                	ld	s5,472(sp)
    8000492e:	6b5e                	ld	s6,464(sp)
    80004930:	6bbe                	ld	s7,456(sp)
    80004932:	6c1e                	ld	s8,448(sp)
    80004934:	7cfa                	ld	s9,440(sp)
    80004936:	7d5a                	ld	s10,432(sp)
    80004938:	7dba                	ld	s11,424(sp)
    8000493a:	21010113          	addi	sp,sp,528
    8000493e:	8082                	ret
    end_op();
    80004940:	e08ff0ef          	jal	ra,80003f48 <end_op>
    return -1;
    80004944:	557d                	li	a0,-1
    80004946:	bfd9                	j	8000491c <kexec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004948:	854a                	mv	a0,s2
    8000494a:	ffdfc0ef          	jal	ra,80001946 <proc_pagetable>
    8000494e:	8baa                	mv	s7,a0
    80004950:	d161                	beqz	a0,80004910 <kexec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004952:	e7042983          	lw	s3,-400(s0)
    80004956:	e8845783          	lhu	a5,-376(s0)
    8000495a:	cfb9                	beqz	a5,800049b8 <kexec+0x118>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000495c:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000495e:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004960:	6c85                	lui	s9,0x1
    80004962:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004966:	def43823          	sd	a5,-528(s0)
    8000496a:	aadd                	j	80004b60 <kexec+0x2c0>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000496c:	00003517          	auipc	a0,0x3
    80004970:	d4c50513          	addi	a0,a0,-692 # 800076b8 <syscalls+0x2c8>
    80004974:	e1dfb0ef          	jal	ra,80000790 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004978:	8756                	mv	a4,s5
    8000497a:	012d86bb          	addw	a3,s11,s2
    8000497e:	4581                	li	a1,0
    80004980:	8526                	mv	a0,s1
    80004982:	f05fe0ef          	jal	ra,80003886 <readi>
    80004986:	2501                	sext.w	a0,a0
    80004988:	18aa9263          	bne	s5,a0,80004b0c <kexec+0x26c>
  for(i = 0; i < sz; i += PGSIZE){
    8000498c:	6785                	lui	a5,0x1
    8000498e:	0127893b          	addw	s2,a5,s2
    80004992:	77fd                	lui	a5,0xfffff
    80004994:	01478a3b          	addw	s4,a5,s4
    80004998:	1b897b63          	bgeu	s2,s8,80004b4e <kexec+0x2ae>
    pa = walkaddr(pagetable, va + i);
    8000499c:	02091593          	slli	a1,s2,0x20
    800049a0:	9181                	srli	a1,a1,0x20
    800049a2:	95ea                	add	a1,a1,s10
    800049a4:	855e                	mv	a0,s7
    800049a6:	dc6fc0ef          	jal	ra,80000f6c <walkaddr>
    800049aa:	862a                	mv	a2,a0
    if(pa == 0)
    800049ac:	d161                	beqz	a0,8000496c <kexec+0xcc>
      n = PGSIZE;
    800049ae:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800049b0:	fd9a74e3          	bgeu	s4,s9,80004978 <kexec+0xd8>
      n = sz - i;
    800049b4:	8ad2                	mv	s5,s4
    800049b6:	b7c9                	j	80004978 <kexec+0xd8>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800049b8:	4a01                	li	s4,0
  iunlockput(ip);
    800049ba:	8526                	mv	a0,s1
    800049bc:	d45fe0ef          	jal	ra,80003700 <iunlockput>
  end_op();
    800049c0:	d88ff0ef          	jal	ra,80003f48 <end_op>
  p = myproc();
    800049c4:	e7dfc0ef          	jal	ra,80001840 <myproc>
    800049c8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800049ca:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800049ce:	6785                	lui	a5,0x1
    800049d0:	17fd                	addi	a5,a5,-1
    800049d2:	9a3e                	add	s4,s4,a5
    800049d4:	757d                	lui	a0,0xfffff
    800049d6:	00aa77b3          	and	a5,s4,a0
    800049da:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800049de:	4691                	li	a3,4
    800049e0:	6609                	lui	a2,0x2
    800049e2:	963e                	add	a2,a2,a5
    800049e4:	85be                	mv	a1,a5
    800049e6:	855e                	mv	a0,s7
    800049e8:	84ffc0ef          	jal	ra,80001236 <uvmalloc>
    800049ec:	8b2a                	mv	s6,a0
  ip = 0;
    800049ee:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800049f0:	10050e63          	beqz	a0,80004b0c <kexec+0x26c>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800049f4:	75f9                	lui	a1,0xffffe
    800049f6:	95aa                	add	a1,a1,a0
    800049f8:	855e                	mv	a0,s7
    800049fa:	a03fc0ef          	jal	ra,800013fc <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800049fe:	7c7d                	lui	s8,0xfffff
    80004a00:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004a02:	e0043783          	ld	a5,-512(s0)
    80004a06:	6388                	ld	a0,0(a5)
    80004a08:	c125                	beqz	a0,80004a68 <kexec+0x1c8>
    80004a0a:	e9040993          	addi	s3,s0,-368
    80004a0e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004a12:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004a14:	bbafc0ef          	jal	ra,80000dce <strlen>
    80004a18:	2505                	addiw	a0,a0,1
    80004a1a:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004a1e:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004a22:	11896a63          	bltu	s2,s8,80004b36 <kexec+0x296>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004a26:	e0043d83          	ld	s11,-512(s0)
    80004a2a:	000dba03          	ld	s4,0(s11)
    80004a2e:	8552                	mv	a0,s4
    80004a30:	b9efc0ef          	jal	ra,80000dce <strlen>
    80004a34:	0015069b          	addiw	a3,a0,1
    80004a38:	8652                	mv	a2,s4
    80004a3a:	85ca                	mv	a1,s2
    80004a3c:	855e                	mv	a0,s7
    80004a3e:	b2bfc0ef          	jal	ra,80001568 <copyout>
    80004a42:	0e054e63          	bltz	a0,80004b3e <kexec+0x29e>
    ustack[argc] = sp;
    80004a46:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004a4a:	0485                	addi	s1,s1,1
    80004a4c:	008d8793          	addi	a5,s11,8
    80004a50:	e0f43023          	sd	a5,-512(s0)
    80004a54:	008db503          	ld	a0,8(s11)
    80004a58:	c911                	beqz	a0,80004a6c <kexec+0x1cc>
    if(argc >= MAXARG)
    80004a5a:	09a1                	addi	s3,s3,8
    80004a5c:	fb3c9ce3          	bne	s9,s3,80004a14 <kexec+0x174>
  sz = sz1;
    80004a60:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004a64:	4481                	li	s1,0
    80004a66:	a05d                	j	80004b0c <kexec+0x26c>
  sp = sz;
    80004a68:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004a6a:	4481                	li	s1,0
  ustack[argc] = 0;
    80004a6c:	00349793          	slli	a5,s1,0x3
    80004a70:	f9040713          	addi	a4,s0,-112
    80004a74:	97ba                	add	a5,a5,a4
    80004a76:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004a7a:	00148693          	addi	a3,s1,1
    80004a7e:	068e                	slli	a3,a3,0x3
    80004a80:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004a84:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004a88:	01897663          	bgeu	s2,s8,80004a94 <kexec+0x1f4>
  sz = sz1;
    80004a8c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004a90:	4481                	li	s1,0
    80004a92:	a8ad                	j	80004b0c <kexec+0x26c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004a94:	e9040613          	addi	a2,s0,-368
    80004a98:	85ca                	mv	a1,s2
    80004a9a:	855e                	mv	a0,s7
    80004a9c:	acdfc0ef          	jal	ra,80001568 <copyout>
    80004aa0:	0a054363          	bltz	a0,80004b46 <kexec+0x2a6>
  p->trapframe->a1 = sp;
    80004aa4:	058ab783          	ld	a5,88(s5)
    80004aa8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004aac:	df843783          	ld	a5,-520(s0)
    80004ab0:	0007c703          	lbu	a4,0(a5)
    80004ab4:	cf11                	beqz	a4,80004ad0 <kexec+0x230>
    80004ab6:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004ab8:	02f00693          	li	a3,47
    80004abc:	a039                	j	80004aca <kexec+0x22a>
      last = s+1;
    80004abe:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004ac2:	0785                	addi	a5,a5,1
    80004ac4:	fff7c703          	lbu	a4,-1(a5)
    80004ac8:	c701                	beqz	a4,80004ad0 <kexec+0x230>
    if(*s == '/')
    80004aca:	fed71ce3          	bne	a4,a3,80004ac2 <kexec+0x222>
    80004ace:	bfc5                	j	80004abe <kexec+0x21e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ad0:	4641                	li	a2,16
    80004ad2:	df843583          	ld	a1,-520(s0)
    80004ad6:	158a8513          	addi	a0,s5,344
    80004ada:	ac2fc0ef          	jal	ra,80000d9c <safestrcpy>
  oldpagetable = p->pagetable;
    80004ade:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004ae2:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004ae6:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80004aea:	058ab783          	ld	a5,88(s5)
    80004aee:	e6843703          	ld	a4,-408(s0)
    80004af2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004af4:	058ab783          	ld	a5,88(s5)
    80004af8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004afc:	85ea                	mv	a1,s10
    80004afe:	ecdfc0ef          	jal	ra,800019ca <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004b02:	0004851b          	sext.w	a0,s1
    80004b06:	bd19                	j	8000491c <kexec+0x7c>
    80004b08:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004b0c:	e0843583          	ld	a1,-504(s0)
    80004b10:	855e                	mv	a0,s7
    80004b12:	eb9fc0ef          	jal	ra,800019ca <proc_freepagetable>
  if(ip){
    80004b16:	de049de3          	bnez	s1,80004910 <kexec+0x70>
  return -1;
    80004b1a:	557d                	li	a0,-1
    80004b1c:	b501                	j	8000491c <kexec+0x7c>
    80004b1e:	e1443423          	sd	s4,-504(s0)
    80004b22:	b7ed                	j	80004b0c <kexec+0x26c>
    80004b24:	e1443423          	sd	s4,-504(s0)
    80004b28:	b7d5                	j	80004b0c <kexec+0x26c>
    80004b2a:	e1443423          	sd	s4,-504(s0)
    80004b2e:	bff9                	j	80004b0c <kexec+0x26c>
    80004b30:	e1443423          	sd	s4,-504(s0)
    80004b34:	bfe1                	j	80004b0c <kexec+0x26c>
  sz = sz1;
    80004b36:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004b3a:	4481                	li	s1,0
    80004b3c:	bfc1                	j	80004b0c <kexec+0x26c>
  sz = sz1;
    80004b3e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004b42:	4481                	li	s1,0
    80004b44:	b7e1                	j	80004b0c <kexec+0x26c>
  sz = sz1;
    80004b46:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004b4a:	4481                	li	s1,0
    80004b4c:	b7c1                	j	80004b0c <kexec+0x26c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004b4e:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b52:	2b05                	addiw	s6,s6,1
    80004b54:	0389899b          	addiw	s3,s3,56
    80004b58:	e8845783          	lhu	a5,-376(s0)
    80004b5c:	e4fb5fe3          	bge	s6,a5,800049ba <kexec+0x11a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004b60:	2981                	sext.w	s3,s3
    80004b62:	03800713          	li	a4,56
    80004b66:	86ce                	mv	a3,s3
    80004b68:	e1840613          	addi	a2,s0,-488
    80004b6c:	4581                	li	a1,0
    80004b6e:	8526                	mv	a0,s1
    80004b70:	d17fe0ef          	jal	ra,80003886 <readi>
    80004b74:	03800793          	li	a5,56
    80004b78:	f8f518e3          	bne	a0,a5,80004b08 <kexec+0x268>
    if(ph.type != ELF_PROG_LOAD)
    80004b7c:	e1842783          	lw	a5,-488(s0)
    80004b80:	4705                	li	a4,1
    80004b82:	fce798e3          	bne	a5,a4,80004b52 <kexec+0x2b2>
    if(ph.memsz < ph.filesz)
    80004b86:	e4043903          	ld	s2,-448(s0)
    80004b8a:	e3843783          	ld	a5,-456(s0)
    80004b8e:	f8f968e3          	bltu	s2,a5,80004b1e <kexec+0x27e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004b92:	e2843783          	ld	a5,-472(s0)
    80004b96:	993e                	add	s2,s2,a5
    80004b98:	f8f966e3          	bltu	s2,a5,80004b24 <kexec+0x284>
    if(ph.vaddr % PGSIZE != 0)
    80004b9c:	df043703          	ld	a4,-528(s0)
    80004ba0:	8ff9                	and	a5,a5,a4
    80004ba2:	f7c1                	bnez	a5,80004b2a <kexec+0x28a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004ba4:	e1c42503          	lw	a0,-484(s0)
    80004ba8:	cddff0ef          	jal	ra,80004884 <flags2perm>
    80004bac:	86aa                	mv	a3,a0
    80004bae:	864a                	mv	a2,s2
    80004bb0:	85d2                	mv	a1,s4
    80004bb2:	855e                	mv	a0,s7
    80004bb4:	e82fc0ef          	jal	ra,80001236 <uvmalloc>
    80004bb8:	e0a43423          	sd	a0,-504(s0)
    80004bbc:	d935                	beqz	a0,80004b30 <kexec+0x290>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004bbe:	e2843d03          	ld	s10,-472(s0)
    80004bc2:	e2042d83          	lw	s11,-480(s0)
    80004bc6:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004bca:	f80c02e3          	beqz	s8,80004b4e <kexec+0x2ae>
    80004bce:	8a62                	mv	s4,s8
    80004bd0:	4901                	li	s2,0
    80004bd2:	b3e9                	j	8000499c <kexec+0xfc>

0000000080004bd4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004bd4:	7179                	addi	sp,sp,-48
    80004bd6:	f406                	sd	ra,40(sp)
    80004bd8:	f022                	sd	s0,32(sp)
    80004bda:	ec26                	sd	s1,24(sp)
    80004bdc:	e84a                	sd	s2,16(sp)
    80004bde:	1800                	addi	s0,sp,48
    80004be0:	892e                	mv	s2,a1
    80004be2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004be4:	fdc40593          	addi	a1,s0,-36
    80004be8:	de7fd0ef          	jal	ra,800029ce <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004bec:	fdc42703          	lw	a4,-36(s0)
    80004bf0:	47bd                	li	a5,15
    80004bf2:	02e7e963          	bltu	a5,a4,80004c24 <argfd+0x50>
    80004bf6:	c4bfc0ef          	jal	ra,80001840 <myproc>
    80004bfa:	fdc42703          	lw	a4,-36(s0)
    80004bfe:	01a70793          	addi	a5,a4,26
    80004c02:	078e                	slli	a5,a5,0x3
    80004c04:	953e                	add	a0,a0,a5
    80004c06:	611c                	ld	a5,0(a0)
    80004c08:	c385                	beqz	a5,80004c28 <argfd+0x54>
    return -1;
  if(pfd)
    80004c0a:	00090463          	beqz	s2,80004c12 <argfd+0x3e>
    *pfd = fd;
    80004c0e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004c12:	4501                	li	a0,0
  if(pf)
    80004c14:	c091                	beqz	s1,80004c18 <argfd+0x44>
    *pf = f;
    80004c16:	e09c                	sd	a5,0(s1)
}
    80004c18:	70a2                	ld	ra,40(sp)
    80004c1a:	7402                	ld	s0,32(sp)
    80004c1c:	64e2                	ld	s1,24(sp)
    80004c1e:	6942                	ld	s2,16(sp)
    80004c20:	6145                	addi	sp,sp,48
    80004c22:	8082                	ret
    return -1;
    80004c24:	557d                	li	a0,-1
    80004c26:	bfcd                	j	80004c18 <argfd+0x44>
    80004c28:	557d                	li	a0,-1
    80004c2a:	b7fd                	j	80004c18 <argfd+0x44>

0000000080004c2c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004c2c:	1101                	addi	sp,sp,-32
    80004c2e:	ec06                	sd	ra,24(sp)
    80004c30:	e822                	sd	s0,16(sp)
    80004c32:	e426                	sd	s1,8(sp)
    80004c34:	1000                	addi	s0,sp,32
    80004c36:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004c38:	c09fc0ef          	jal	ra,80001840 <myproc>
    80004c3c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004c3e:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdded8>
    80004c42:	4501                	li	a0,0
    80004c44:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004c46:	6398                	ld	a4,0(a5)
    80004c48:	cb19                	beqz	a4,80004c5e <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004c4a:	2505                	addiw	a0,a0,1
    80004c4c:	07a1                	addi	a5,a5,8
    80004c4e:	fed51ce3          	bne	a0,a3,80004c46 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004c52:	557d                	li	a0,-1
}
    80004c54:	60e2                	ld	ra,24(sp)
    80004c56:	6442                	ld	s0,16(sp)
    80004c58:	64a2                	ld	s1,8(sp)
    80004c5a:	6105                	addi	sp,sp,32
    80004c5c:	8082                	ret
      p->ofile[fd] = f;
    80004c5e:	01a50793          	addi	a5,a0,26
    80004c62:	078e                	slli	a5,a5,0x3
    80004c64:	963e                	add	a2,a2,a5
    80004c66:	e204                	sd	s1,0(a2)
      return fd;
    80004c68:	b7f5                	j	80004c54 <fdalloc+0x28>

0000000080004c6a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004c6a:	715d                	addi	sp,sp,-80
    80004c6c:	e486                	sd	ra,72(sp)
    80004c6e:	e0a2                	sd	s0,64(sp)
    80004c70:	fc26                	sd	s1,56(sp)
    80004c72:	f84a                	sd	s2,48(sp)
    80004c74:	f44e                	sd	s3,40(sp)
    80004c76:	f052                	sd	s4,32(sp)
    80004c78:	ec56                	sd	s5,24(sp)
    80004c7a:	e85a                	sd	s6,16(sp)
    80004c7c:	0880                	addi	s0,sp,80
    80004c7e:	8b2e                	mv	s6,a1
    80004c80:	89b2                	mv	s3,a2
    80004c82:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004c84:	fb040593          	addi	a1,s0,-80
    80004c88:	87aff0ef          	jal	ra,80003d02 <nameiparent>
    80004c8c:	84aa                	mv	s1,a0
    80004c8e:	10050c63          	beqz	a0,80004da6 <create+0x13c>
    return 0;

  ilock(dp);
    80004c92:	869fe0ef          	jal	ra,800034fa <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004c96:	4601                	li	a2,0
    80004c98:	fb040593          	addi	a1,s0,-80
    80004c9c:	8526                	mv	a0,s1
    80004c9e:	de5fe0ef          	jal	ra,80003a82 <dirlookup>
    80004ca2:	8aaa                	mv	s5,a0
    80004ca4:	c521                	beqz	a0,80004cec <create+0x82>
    iunlockput(dp);
    80004ca6:	8526                	mv	a0,s1
    80004ca8:	a59fe0ef          	jal	ra,80003700 <iunlockput>
    ilock(ip);
    80004cac:	8556                	mv	a0,s5
    80004cae:	84dfe0ef          	jal	ra,800034fa <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004cb2:	000b059b          	sext.w	a1,s6
    80004cb6:	4789                	li	a5,2
    80004cb8:	02f59563          	bne	a1,a5,80004ce2 <create+0x78>
    80004cbc:	044ad783          	lhu	a5,68(s5)
    80004cc0:	37f9                	addiw	a5,a5,-2
    80004cc2:	17c2                	slli	a5,a5,0x30
    80004cc4:	93c1                	srli	a5,a5,0x30
    80004cc6:	4705                	li	a4,1
    80004cc8:	00f76d63          	bltu	a4,a5,80004ce2 <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004ccc:	8556                	mv	a0,s5
    80004cce:	60a6                	ld	ra,72(sp)
    80004cd0:	6406                	ld	s0,64(sp)
    80004cd2:	74e2                	ld	s1,56(sp)
    80004cd4:	7942                	ld	s2,48(sp)
    80004cd6:	79a2                	ld	s3,40(sp)
    80004cd8:	7a02                	ld	s4,32(sp)
    80004cda:	6ae2                	ld	s5,24(sp)
    80004cdc:	6b42                	ld	s6,16(sp)
    80004cde:	6161                	addi	sp,sp,80
    80004ce0:	8082                	ret
    iunlockput(ip);
    80004ce2:	8556                	mv	a0,s5
    80004ce4:	a1dfe0ef          	jal	ra,80003700 <iunlockput>
    return 0;
    80004ce8:	4a81                	li	s5,0
    80004cea:	b7cd                	j	80004ccc <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004cec:	85da                	mv	a1,s6
    80004cee:	4088                	lw	a0,0(s1)
    80004cf0:	ea2fe0ef          	jal	ra,80003392 <ialloc>
    80004cf4:	8a2a                	mv	s4,a0
    80004cf6:	c121                	beqz	a0,80004d36 <create+0xcc>
  ilock(ip);
    80004cf8:	803fe0ef          	jal	ra,800034fa <ilock>
  ip->major = major;
    80004cfc:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004d00:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004d04:	4785                	li	a5,1
    80004d06:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004d0a:	8552                	mv	a0,s4
    80004d0c:	f3cfe0ef          	jal	ra,80003448 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004d10:	000b059b          	sext.w	a1,s6
    80004d14:	4785                	li	a5,1
    80004d16:	02f58563          	beq	a1,a5,80004d40 <create+0xd6>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d1a:	004a2603          	lw	a2,4(s4)
    80004d1e:	fb040593          	addi	a1,s0,-80
    80004d22:	8526                	mv	a0,s1
    80004d24:	f2bfe0ef          	jal	ra,80003c4e <dirlink>
    80004d28:	06054363          	bltz	a0,80004d8e <create+0x124>
  iunlockput(dp);
    80004d2c:	8526                	mv	a0,s1
    80004d2e:	9d3fe0ef          	jal	ra,80003700 <iunlockput>
  return ip;
    80004d32:	8ad2                	mv	s5,s4
    80004d34:	bf61                	j	80004ccc <create+0x62>
    iunlockput(dp);
    80004d36:	8526                	mv	a0,s1
    80004d38:	9c9fe0ef          	jal	ra,80003700 <iunlockput>
    return 0;
    80004d3c:	8ad2                	mv	s5,s4
    80004d3e:	b779                	j	80004ccc <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004d40:	004a2603          	lw	a2,4(s4)
    80004d44:	00003597          	auipc	a1,0x3
    80004d48:	99458593          	addi	a1,a1,-1644 # 800076d8 <syscalls+0x2e8>
    80004d4c:	8552                	mv	a0,s4
    80004d4e:	f01fe0ef          	jal	ra,80003c4e <dirlink>
    80004d52:	02054e63          	bltz	a0,80004d8e <create+0x124>
    80004d56:	40d0                	lw	a2,4(s1)
    80004d58:	00003597          	auipc	a1,0x3
    80004d5c:	98858593          	addi	a1,a1,-1656 # 800076e0 <syscalls+0x2f0>
    80004d60:	8552                	mv	a0,s4
    80004d62:	eedfe0ef          	jal	ra,80003c4e <dirlink>
    80004d66:	02054463          	bltz	a0,80004d8e <create+0x124>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d6a:	004a2603          	lw	a2,4(s4)
    80004d6e:	fb040593          	addi	a1,s0,-80
    80004d72:	8526                	mv	a0,s1
    80004d74:	edbfe0ef          	jal	ra,80003c4e <dirlink>
    80004d78:	00054b63          	bltz	a0,80004d8e <create+0x124>
    dp->nlink++;  // for ".."
    80004d7c:	04a4d783          	lhu	a5,74(s1)
    80004d80:	2785                	addiw	a5,a5,1
    80004d82:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d86:	8526                	mv	a0,s1
    80004d88:	ec0fe0ef          	jal	ra,80003448 <iupdate>
    80004d8c:	b745                	j	80004d2c <create+0xc2>
  ip->nlink = 0;
    80004d8e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004d92:	8552                	mv	a0,s4
    80004d94:	eb4fe0ef          	jal	ra,80003448 <iupdate>
  iunlockput(ip);
    80004d98:	8552                	mv	a0,s4
    80004d9a:	967fe0ef          	jal	ra,80003700 <iunlockput>
  iunlockput(dp);
    80004d9e:	8526                	mv	a0,s1
    80004da0:	961fe0ef          	jal	ra,80003700 <iunlockput>
  return 0;
    80004da4:	b725                	j	80004ccc <create+0x62>
    return 0;
    80004da6:	8aaa                	mv	s5,a0
    80004da8:	b715                	j	80004ccc <create+0x62>

0000000080004daa <sys_dup>:
{
    80004daa:	7179                	addi	sp,sp,-48
    80004dac:	f406                	sd	ra,40(sp)
    80004dae:	f022                	sd	s0,32(sp)
    80004db0:	ec26                	sd	s1,24(sp)
    80004db2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004db4:	fd840613          	addi	a2,s0,-40
    80004db8:	4581                	li	a1,0
    80004dba:	4501                	li	a0,0
    80004dbc:	e19ff0ef          	jal	ra,80004bd4 <argfd>
    return -1;
    80004dc0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004dc2:	00054f63          	bltz	a0,80004de0 <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    80004dc6:	fd843503          	ld	a0,-40(s0)
    80004dca:	e63ff0ef          	jal	ra,80004c2c <fdalloc>
    80004dce:	84aa                	mv	s1,a0
    return -1;
    80004dd0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004dd2:	00054763          	bltz	a0,80004de0 <sys_dup+0x36>
  filedup(f);
    80004dd6:	fd843503          	ld	a0,-40(s0)
    80004dda:	cc6ff0ef          	jal	ra,800042a0 <filedup>
  return fd;
    80004dde:	87a6                	mv	a5,s1
}
    80004de0:	853e                	mv	a0,a5
    80004de2:	70a2                	ld	ra,40(sp)
    80004de4:	7402                	ld	s0,32(sp)
    80004de6:	64e2                	ld	s1,24(sp)
    80004de8:	6145                	addi	sp,sp,48
    80004dea:	8082                	ret

0000000080004dec <sys_read>:
{
    80004dec:	7179                	addi	sp,sp,-48
    80004dee:	f406                	sd	ra,40(sp)
    80004df0:	f022                	sd	s0,32(sp)
    80004df2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004df4:	fd840593          	addi	a1,s0,-40
    80004df8:	4505                	li	a0,1
    80004dfa:	bf1fd0ef          	jal	ra,800029ea <argaddr>
  argint(2, &n);
    80004dfe:	fe440593          	addi	a1,s0,-28
    80004e02:	4509                	li	a0,2
    80004e04:	bcbfd0ef          	jal	ra,800029ce <argint>
  if(argfd(0, 0, &f) < 0)
    80004e08:	fe840613          	addi	a2,s0,-24
    80004e0c:	4581                	li	a1,0
    80004e0e:	4501                	li	a0,0
    80004e10:	dc5ff0ef          	jal	ra,80004bd4 <argfd>
    80004e14:	87aa                	mv	a5,a0
    return -1;
    80004e16:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e18:	0007ca63          	bltz	a5,80004e2c <sys_read+0x40>
  return fileread(f, p, n);
    80004e1c:	fe442603          	lw	a2,-28(s0)
    80004e20:	fd843583          	ld	a1,-40(s0)
    80004e24:	fe843503          	ld	a0,-24(s0)
    80004e28:	dc4ff0ef          	jal	ra,800043ec <fileread>
}
    80004e2c:	70a2                	ld	ra,40(sp)
    80004e2e:	7402                	ld	s0,32(sp)
    80004e30:	6145                	addi	sp,sp,48
    80004e32:	8082                	ret

0000000080004e34 <sys_write>:
{
    80004e34:	7179                	addi	sp,sp,-48
    80004e36:	f406                	sd	ra,40(sp)
    80004e38:	f022                	sd	s0,32(sp)
    80004e3a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e3c:	fd840593          	addi	a1,s0,-40
    80004e40:	4505                	li	a0,1
    80004e42:	ba9fd0ef          	jal	ra,800029ea <argaddr>
  argint(2, &n);
    80004e46:	fe440593          	addi	a1,s0,-28
    80004e4a:	4509                	li	a0,2
    80004e4c:	b83fd0ef          	jal	ra,800029ce <argint>
  if(argfd(0, 0, &f) < 0)
    80004e50:	fe840613          	addi	a2,s0,-24
    80004e54:	4581                	li	a1,0
    80004e56:	4501                	li	a0,0
    80004e58:	d7dff0ef          	jal	ra,80004bd4 <argfd>
    80004e5c:	87aa                	mv	a5,a0
    return -1;
    80004e5e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e60:	0007ca63          	bltz	a5,80004e74 <sys_write+0x40>
  return filewrite(f, p, n);
    80004e64:	fe442603          	lw	a2,-28(s0)
    80004e68:	fd843583          	ld	a1,-40(s0)
    80004e6c:	fe843503          	ld	a0,-24(s0)
    80004e70:	e2aff0ef          	jal	ra,8000449a <filewrite>
}
    80004e74:	70a2                	ld	ra,40(sp)
    80004e76:	7402                	ld	s0,32(sp)
    80004e78:	6145                	addi	sp,sp,48
    80004e7a:	8082                	ret

0000000080004e7c <sys_close>:
{
    80004e7c:	1101                	addi	sp,sp,-32
    80004e7e:	ec06                	sd	ra,24(sp)
    80004e80:	e822                	sd	s0,16(sp)
    80004e82:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004e84:	fe040613          	addi	a2,s0,-32
    80004e88:	fec40593          	addi	a1,s0,-20
    80004e8c:	4501                	li	a0,0
    80004e8e:	d47ff0ef          	jal	ra,80004bd4 <argfd>
    return -1;
    80004e92:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004e94:	02054063          	bltz	a0,80004eb4 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004e98:	9a9fc0ef          	jal	ra,80001840 <myproc>
    80004e9c:	fec42783          	lw	a5,-20(s0)
    80004ea0:	07e9                	addi	a5,a5,26
    80004ea2:	078e                	slli	a5,a5,0x3
    80004ea4:	97aa                	add	a5,a5,a0
    80004ea6:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004eaa:	fe043503          	ld	a0,-32(s0)
    80004eae:	c38ff0ef          	jal	ra,800042e6 <fileclose>
  return 0;
    80004eb2:	4781                	li	a5,0
}
    80004eb4:	853e                	mv	a0,a5
    80004eb6:	60e2                	ld	ra,24(sp)
    80004eb8:	6442                	ld	s0,16(sp)
    80004eba:	6105                	addi	sp,sp,32
    80004ebc:	8082                	ret

0000000080004ebe <sys_fstat>:
{
    80004ebe:	1101                	addi	sp,sp,-32
    80004ec0:	ec06                	sd	ra,24(sp)
    80004ec2:	e822                	sd	s0,16(sp)
    80004ec4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004ec6:	fe040593          	addi	a1,s0,-32
    80004eca:	4505                	li	a0,1
    80004ecc:	b1ffd0ef          	jal	ra,800029ea <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004ed0:	fe840613          	addi	a2,s0,-24
    80004ed4:	4581                	li	a1,0
    80004ed6:	4501                	li	a0,0
    80004ed8:	cfdff0ef          	jal	ra,80004bd4 <argfd>
    80004edc:	87aa                	mv	a5,a0
    return -1;
    80004ede:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ee0:	0007c863          	bltz	a5,80004ef0 <sys_fstat+0x32>
  return filestat(f, st);
    80004ee4:	fe043583          	ld	a1,-32(s0)
    80004ee8:	fe843503          	ld	a0,-24(s0)
    80004eec:	ca2ff0ef          	jal	ra,8000438e <filestat>
}
    80004ef0:	60e2                	ld	ra,24(sp)
    80004ef2:	6442                	ld	s0,16(sp)
    80004ef4:	6105                	addi	sp,sp,32
    80004ef6:	8082                	ret

0000000080004ef8 <sys_link>:
{
    80004ef8:	7169                	addi	sp,sp,-304
    80004efa:	f606                	sd	ra,296(sp)
    80004efc:	f222                	sd	s0,288(sp)
    80004efe:	ee26                	sd	s1,280(sp)
    80004f00:	ea4a                	sd	s2,272(sp)
    80004f02:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f04:	08000613          	li	a2,128
    80004f08:	ed040593          	addi	a1,s0,-304
    80004f0c:	4501                	li	a0,0
    80004f0e:	af9fd0ef          	jal	ra,80002a06 <argstr>
    return -1;
    80004f12:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f14:	0c054663          	bltz	a0,80004fe0 <sys_link+0xe8>
    80004f18:	08000613          	li	a2,128
    80004f1c:	f5040593          	addi	a1,s0,-176
    80004f20:	4505                	li	a0,1
    80004f22:	ae5fd0ef          	jal	ra,80002a06 <argstr>
    return -1;
    80004f26:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f28:	0a054c63          	bltz	a0,80004fe0 <sys_link+0xe8>
  begin_op();
    80004f2c:	fadfe0ef          	jal	ra,80003ed8 <begin_op>
  if((ip = namei(old)) == 0){
    80004f30:	ed040513          	addi	a0,s0,-304
    80004f34:	db5fe0ef          	jal	ra,80003ce8 <namei>
    80004f38:	84aa                	mv	s1,a0
    80004f3a:	c525                	beqz	a0,80004fa2 <sys_link+0xaa>
  ilock(ip);
    80004f3c:	dbefe0ef          	jal	ra,800034fa <ilock>
  if(ip->type == T_DIR){
    80004f40:	04449703          	lh	a4,68(s1)
    80004f44:	4785                	li	a5,1
    80004f46:	06f70263          	beq	a4,a5,80004faa <sys_link+0xb2>
  ip->nlink++;
    80004f4a:	04a4d783          	lhu	a5,74(s1)
    80004f4e:	2785                	addiw	a5,a5,1
    80004f50:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f54:	8526                	mv	a0,s1
    80004f56:	cf2fe0ef          	jal	ra,80003448 <iupdate>
  iunlock(ip);
    80004f5a:	8526                	mv	a0,s1
    80004f5c:	e48fe0ef          	jal	ra,800035a4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004f60:	fd040593          	addi	a1,s0,-48
    80004f64:	f5040513          	addi	a0,s0,-176
    80004f68:	d9bfe0ef          	jal	ra,80003d02 <nameiparent>
    80004f6c:	892a                	mv	s2,a0
    80004f6e:	c921                	beqz	a0,80004fbe <sys_link+0xc6>
  ilock(dp);
    80004f70:	d8afe0ef          	jal	ra,800034fa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004f74:	00092703          	lw	a4,0(s2)
    80004f78:	409c                	lw	a5,0(s1)
    80004f7a:	02f71f63          	bne	a4,a5,80004fb8 <sys_link+0xc0>
    80004f7e:	40d0                	lw	a2,4(s1)
    80004f80:	fd040593          	addi	a1,s0,-48
    80004f84:	854a                	mv	a0,s2
    80004f86:	cc9fe0ef          	jal	ra,80003c4e <dirlink>
    80004f8a:	02054763          	bltz	a0,80004fb8 <sys_link+0xc0>
  iunlockput(dp);
    80004f8e:	854a                	mv	a0,s2
    80004f90:	f70fe0ef          	jal	ra,80003700 <iunlockput>
  iput(ip);
    80004f94:	8526                	mv	a0,s1
    80004f96:	ee2fe0ef          	jal	ra,80003678 <iput>
  end_op();
    80004f9a:	faffe0ef          	jal	ra,80003f48 <end_op>
  return 0;
    80004f9e:	4781                	li	a5,0
    80004fa0:	a081                	j	80004fe0 <sys_link+0xe8>
    end_op();
    80004fa2:	fa7fe0ef          	jal	ra,80003f48 <end_op>
    return -1;
    80004fa6:	57fd                	li	a5,-1
    80004fa8:	a825                	j	80004fe0 <sys_link+0xe8>
    iunlockput(ip);
    80004faa:	8526                	mv	a0,s1
    80004fac:	f54fe0ef          	jal	ra,80003700 <iunlockput>
    end_op();
    80004fb0:	f99fe0ef          	jal	ra,80003f48 <end_op>
    return -1;
    80004fb4:	57fd                	li	a5,-1
    80004fb6:	a02d                	j	80004fe0 <sys_link+0xe8>
    iunlockput(dp);
    80004fb8:	854a                	mv	a0,s2
    80004fba:	f46fe0ef          	jal	ra,80003700 <iunlockput>
  ilock(ip);
    80004fbe:	8526                	mv	a0,s1
    80004fc0:	d3afe0ef          	jal	ra,800034fa <ilock>
  ip->nlink--;
    80004fc4:	04a4d783          	lhu	a5,74(s1)
    80004fc8:	37fd                	addiw	a5,a5,-1
    80004fca:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004fce:	8526                	mv	a0,s1
    80004fd0:	c78fe0ef          	jal	ra,80003448 <iupdate>
  iunlockput(ip);
    80004fd4:	8526                	mv	a0,s1
    80004fd6:	f2afe0ef          	jal	ra,80003700 <iunlockput>
  end_op();
    80004fda:	f6ffe0ef          	jal	ra,80003f48 <end_op>
  return -1;
    80004fde:	57fd                	li	a5,-1
}
    80004fe0:	853e                	mv	a0,a5
    80004fe2:	70b2                	ld	ra,296(sp)
    80004fe4:	7412                	ld	s0,288(sp)
    80004fe6:	64f2                	ld	s1,280(sp)
    80004fe8:	6952                	ld	s2,272(sp)
    80004fea:	6155                	addi	sp,sp,304
    80004fec:	8082                	ret

0000000080004fee <sys_unlink>:
{
    80004fee:	7151                	addi	sp,sp,-240
    80004ff0:	f586                	sd	ra,232(sp)
    80004ff2:	f1a2                	sd	s0,224(sp)
    80004ff4:	eda6                	sd	s1,216(sp)
    80004ff6:	e9ca                	sd	s2,208(sp)
    80004ff8:	e5ce                	sd	s3,200(sp)
    80004ffa:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ffc:	08000613          	li	a2,128
    80005000:	f3040593          	addi	a1,s0,-208
    80005004:	4501                	li	a0,0
    80005006:	a01fd0ef          	jal	ra,80002a06 <argstr>
    8000500a:	12054b63          	bltz	a0,80005140 <sys_unlink+0x152>
  begin_op();
    8000500e:	ecbfe0ef          	jal	ra,80003ed8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005012:	fb040593          	addi	a1,s0,-80
    80005016:	f3040513          	addi	a0,s0,-208
    8000501a:	ce9fe0ef          	jal	ra,80003d02 <nameiparent>
    8000501e:	84aa                	mv	s1,a0
    80005020:	c54d                	beqz	a0,800050ca <sys_unlink+0xdc>
  ilock(dp);
    80005022:	cd8fe0ef          	jal	ra,800034fa <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005026:	00002597          	auipc	a1,0x2
    8000502a:	6b258593          	addi	a1,a1,1714 # 800076d8 <syscalls+0x2e8>
    8000502e:	fb040513          	addi	a0,s0,-80
    80005032:	a3bfe0ef          	jal	ra,80003a6c <namecmp>
    80005036:	10050a63          	beqz	a0,8000514a <sys_unlink+0x15c>
    8000503a:	00002597          	auipc	a1,0x2
    8000503e:	6a658593          	addi	a1,a1,1702 # 800076e0 <syscalls+0x2f0>
    80005042:	fb040513          	addi	a0,s0,-80
    80005046:	a27fe0ef          	jal	ra,80003a6c <namecmp>
    8000504a:	10050063          	beqz	a0,8000514a <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000504e:	f2c40613          	addi	a2,s0,-212
    80005052:	fb040593          	addi	a1,s0,-80
    80005056:	8526                	mv	a0,s1
    80005058:	a2bfe0ef          	jal	ra,80003a82 <dirlookup>
    8000505c:	892a                	mv	s2,a0
    8000505e:	0e050663          	beqz	a0,8000514a <sys_unlink+0x15c>
  ilock(ip);
    80005062:	c98fe0ef          	jal	ra,800034fa <ilock>
  if(ip->nlink < 1)
    80005066:	04a91783          	lh	a5,74(s2)
    8000506a:	06f05463          	blez	a5,800050d2 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000506e:	04491703          	lh	a4,68(s2)
    80005072:	4785                	li	a5,1
    80005074:	06f70563          	beq	a4,a5,800050de <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80005078:	4641                	li	a2,16
    8000507a:	4581                	li	a1,0
    8000507c:	fc040513          	addi	a0,s0,-64
    80005080:	bcffb0ef          	jal	ra,80000c4e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005084:	4741                	li	a4,16
    80005086:	f2c42683          	lw	a3,-212(s0)
    8000508a:	fc040613          	addi	a2,s0,-64
    8000508e:	4581                	li	a1,0
    80005090:	8526                	mv	a0,s1
    80005092:	8d9fe0ef          	jal	ra,8000396a <writei>
    80005096:	47c1                	li	a5,16
    80005098:	08f51563          	bne	a0,a5,80005122 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    8000509c:	04491703          	lh	a4,68(s2)
    800050a0:	4785                	li	a5,1
    800050a2:	08f70663          	beq	a4,a5,8000512e <sys_unlink+0x140>
  iunlockput(dp);
    800050a6:	8526                	mv	a0,s1
    800050a8:	e58fe0ef          	jal	ra,80003700 <iunlockput>
  ip->nlink--;
    800050ac:	04a95783          	lhu	a5,74(s2)
    800050b0:	37fd                	addiw	a5,a5,-1
    800050b2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800050b6:	854a                	mv	a0,s2
    800050b8:	b90fe0ef          	jal	ra,80003448 <iupdate>
  iunlockput(ip);
    800050bc:	854a                	mv	a0,s2
    800050be:	e42fe0ef          	jal	ra,80003700 <iunlockput>
  end_op();
    800050c2:	e87fe0ef          	jal	ra,80003f48 <end_op>
  return 0;
    800050c6:	4501                	li	a0,0
    800050c8:	a079                	j	80005156 <sys_unlink+0x168>
    end_op();
    800050ca:	e7ffe0ef          	jal	ra,80003f48 <end_op>
    return -1;
    800050ce:	557d                	li	a0,-1
    800050d0:	a059                	j	80005156 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800050d2:	00002517          	auipc	a0,0x2
    800050d6:	61650513          	addi	a0,a0,1558 # 800076e8 <syscalls+0x2f8>
    800050da:	eb6fb0ef          	jal	ra,80000790 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800050de:	04c92703          	lw	a4,76(s2)
    800050e2:	02000793          	li	a5,32
    800050e6:	f8e7f9e3          	bgeu	a5,a4,80005078 <sys_unlink+0x8a>
    800050ea:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800050ee:	4741                	li	a4,16
    800050f0:	86ce                	mv	a3,s3
    800050f2:	f1840613          	addi	a2,s0,-232
    800050f6:	4581                	li	a1,0
    800050f8:	854a                	mv	a0,s2
    800050fa:	f8cfe0ef          	jal	ra,80003886 <readi>
    800050fe:	47c1                	li	a5,16
    80005100:	00f51b63          	bne	a0,a5,80005116 <sys_unlink+0x128>
    if(de.inum != 0)
    80005104:	f1845783          	lhu	a5,-232(s0)
    80005108:	ef95                	bnez	a5,80005144 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000510a:	29c1                	addiw	s3,s3,16
    8000510c:	04c92783          	lw	a5,76(s2)
    80005110:	fcf9efe3          	bltu	s3,a5,800050ee <sys_unlink+0x100>
    80005114:	b795                	j	80005078 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005116:	00002517          	auipc	a0,0x2
    8000511a:	5ea50513          	addi	a0,a0,1514 # 80007700 <syscalls+0x310>
    8000511e:	e72fb0ef          	jal	ra,80000790 <panic>
    panic("unlink: writei");
    80005122:	00002517          	auipc	a0,0x2
    80005126:	5f650513          	addi	a0,a0,1526 # 80007718 <syscalls+0x328>
    8000512a:	e66fb0ef          	jal	ra,80000790 <panic>
    dp->nlink--;
    8000512e:	04a4d783          	lhu	a5,74(s1)
    80005132:	37fd                	addiw	a5,a5,-1
    80005134:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005138:	8526                	mv	a0,s1
    8000513a:	b0efe0ef          	jal	ra,80003448 <iupdate>
    8000513e:	b7a5                	j	800050a6 <sys_unlink+0xb8>
    return -1;
    80005140:	557d                	li	a0,-1
    80005142:	a811                	j	80005156 <sys_unlink+0x168>
    iunlockput(ip);
    80005144:	854a                	mv	a0,s2
    80005146:	dbafe0ef          	jal	ra,80003700 <iunlockput>
  iunlockput(dp);
    8000514a:	8526                	mv	a0,s1
    8000514c:	db4fe0ef          	jal	ra,80003700 <iunlockput>
  end_op();
    80005150:	df9fe0ef          	jal	ra,80003f48 <end_op>
  return -1;
    80005154:	557d                	li	a0,-1
}
    80005156:	70ae                	ld	ra,232(sp)
    80005158:	740e                	ld	s0,224(sp)
    8000515a:	64ee                	ld	s1,216(sp)
    8000515c:	694e                	ld	s2,208(sp)
    8000515e:	69ae                	ld	s3,200(sp)
    80005160:	616d                	addi	sp,sp,240
    80005162:	8082                	ret

0000000080005164 <sys_open>:

uint64
sys_open(void)
{
    80005164:	7131                	addi	sp,sp,-192
    80005166:	fd06                	sd	ra,184(sp)
    80005168:	f922                	sd	s0,176(sp)
    8000516a:	f526                	sd	s1,168(sp)
    8000516c:	f14a                	sd	s2,160(sp)
    8000516e:	ed4e                	sd	s3,152(sp)
    80005170:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005172:	f4c40593          	addi	a1,s0,-180
    80005176:	4505                	li	a0,1
    80005178:	857fd0ef          	jal	ra,800029ce <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000517c:	08000613          	li	a2,128
    80005180:	f5040593          	addi	a1,s0,-176
    80005184:	4501                	li	a0,0
    80005186:	881fd0ef          	jal	ra,80002a06 <argstr>
    8000518a:	87aa                	mv	a5,a0
    return -1;
    8000518c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000518e:	0807cd63          	bltz	a5,80005228 <sys_open+0xc4>

  begin_op();
    80005192:	d47fe0ef          	jal	ra,80003ed8 <begin_op>

  if(omode & O_CREATE){
    80005196:	f4c42783          	lw	a5,-180(s0)
    8000519a:	2007f793          	andi	a5,a5,512
    8000519e:	c3c5                	beqz	a5,8000523e <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800051a0:	4681                	li	a3,0
    800051a2:	4601                	li	a2,0
    800051a4:	4589                	li	a1,2
    800051a6:	f5040513          	addi	a0,s0,-176
    800051aa:	ac1ff0ef          	jal	ra,80004c6a <create>
    800051ae:	84aa                	mv	s1,a0
    if(ip == 0){
    800051b0:	c159                	beqz	a0,80005236 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800051b2:	04449703          	lh	a4,68(s1)
    800051b6:	478d                	li	a5,3
    800051b8:	00f71763          	bne	a4,a5,800051c6 <sys_open+0x62>
    800051bc:	0464d703          	lhu	a4,70(s1)
    800051c0:	47a5                	li	a5,9
    800051c2:	0ae7e963          	bltu	a5,a4,80005274 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800051c6:	87cff0ef          	jal	ra,80004242 <filealloc>
    800051ca:	89aa                	mv	s3,a0
    800051cc:	0c050963          	beqz	a0,8000529e <sys_open+0x13a>
    800051d0:	a5dff0ef          	jal	ra,80004c2c <fdalloc>
    800051d4:	892a                	mv	s2,a0
    800051d6:	0c054163          	bltz	a0,80005298 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800051da:	04449703          	lh	a4,68(s1)
    800051de:	478d                	li	a5,3
    800051e0:	0af70163          	beq	a4,a5,80005282 <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800051e4:	4789                	li	a5,2
    800051e6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800051ea:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800051ee:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    800051f2:	f4c42783          	lw	a5,-180(s0)
    800051f6:	0017c713          	xori	a4,a5,1
    800051fa:	8b05                	andi	a4,a4,1
    800051fc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005200:	0037f713          	andi	a4,a5,3
    80005204:	00e03733          	snez	a4,a4
    80005208:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000520c:	4007f793          	andi	a5,a5,1024
    80005210:	c791                	beqz	a5,8000521c <sys_open+0xb8>
    80005212:	04449703          	lh	a4,68(s1)
    80005216:	4789                	li	a5,2
    80005218:	06f70c63          	beq	a4,a5,80005290 <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    8000521c:	8526                	mv	a0,s1
    8000521e:	b86fe0ef          	jal	ra,800035a4 <iunlock>
  end_op();
    80005222:	d27fe0ef          	jal	ra,80003f48 <end_op>

  return fd;
    80005226:	854a                	mv	a0,s2
}
    80005228:	70ea                	ld	ra,184(sp)
    8000522a:	744a                	ld	s0,176(sp)
    8000522c:	74aa                	ld	s1,168(sp)
    8000522e:	790a                	ld	s2,160(sp)
    80005230:	69ea                	ld	s3,152(sp)
    80005232:	6129                	addi	sp,sp,192
    80005234:	8082                	ret
      end_op();
    80005236:	d13fe0ef          	jal	ra,80003f48 <end_op>
      return -1;
    8000523a:	557d                	li	a0,-1
    8000523c:	b7f5                	j	80005228 <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    8000523e:	f5040513          	addi	a0,s0,-176
    80005242:	aa7fe0ef          	jal	ra,80003ce8 <namei>
    80005246:	84aa                	mv	s1,a0
    80005248:	c115                	beqz	a0,8000526c <sys_open+0x108>
    ilock(ip);
    8000524a:	ab0fe0ef          	jal	ra,800034fa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000524e:	04449703          	lh	a4,68(s1)
    80005252:	4785                	li	a5,1
    80005254:	f4f71fe3          	bne	a4,a5,800051b2 <sys_open+0x4e>
    80005258:	f4c42783          	lw	a5,-180(s0)
    8000525c:	d7ad                	beqz	a5,800051c6 <sys_open+0x62>
      iunlockput(ip);
    8000525e:	8526                	mv	a0,s1
    80005260:	ca0fe0ef          	jal	ra,80003700 <iunlockput>
      end_op();
    80005264:	ce5fe0ef          	jal	ra,80003f48 <end_op>
      return -1;
    80005268:	557d                	li	a0,-1
    8000526a:	bf7d                	j	80005228 <sys_open+0xc4>
      end_op();
    8000526c:	cddfe0ef          	jal	ra,80003f48 <end_op>
      return -1;
    80005270:	557d                	li	a0,-1
    80005272:	bf5d                	j	80005228 <sys_open+0xc4>
    iunlockput(ip);
    80005274:	8526                	mv	a0,s1
    80005276:	c8afe0ef          	jal	ra,80003700 <iunlockput>
    end_op();
    8000527a:	ccffe0ef          	jal	ra,80003f48 <end_op>
    return -1;
    8000527e:	557d                	li	a0,-1
    80005280:	b765                	j	80005228 <sys_open+0xc4>
    f->type = FD_DEVICE;
    80005282:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005286:	04649783          	lh	a5,70(s1)
    8000528a:	02f99223          	sh	a5,36(s3)
    8000528e:	b785                	j	800051ee <sys_open+0x8a>
    itrunc(ip);
    80005290:	8526                	mv	a0,s1
    80005292:	b52fe0ef          	jal	ra,800035e4 <itrunc>
    80005296:	b759                	j	8000521c <sys_open+0xb8>
      fileclose(f);
    80005298:	854e                	mv	a0,s3
    8000529a:	84cff0ef          	jal	ra,800042e6 <fileclose>
    iunlockput(ip);
    8000529e:	8526                	mv	a0,s1
    800052a0:	c60fe0ef          	jal	ra,80003700 <iunlockput>
    end_op();
    800052a4:	ca5fe0ef          	jal	ra,80003f48 <end_op>
    return -1;
    800052a8:	557d                	li	a0,-1
    800052aa:	bfbd                	j	80005228 <sys_open+0xc4>

00000000800052ac <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800052ac:	7175                	addi	sp,sp,-144
    800052ae:	e506                	sd	ra,136(sp)
    800052b0:	e122                	sd	s0,128(sp)
    800052b2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800052b4:	c25fe0ef          	jal	ra,80003ed8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800052b8:	08000613          	li	a2,128
    800052bc:	f7040593          	addi	a1,s0,-144
    800052c0:	4501                	li	a0,0
    800052c2:	f44fd0ef          	jal	ra,80002a06 <argstr>
    800052c6:	02054363          	bltz	a0,800052ec <sys_mkdir+0x40>
    800052ca:	4681                	li	a3,0
    800052cc:	4601                	li	a2,0
    800052ce:	4585                	li	a1,1
    800052d0:	f7040513          	addi	a0,s0,-144
    800052d4:	997ff0ef          	jal	ra,80004c6a <create>
    800052d8:	c911                	beqz	a0,800052ec <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800052da:	c26fe0ef          	jal	ra,80003700 <iunlockput>
  end_op();
    800052de:	c6bfe0ef          	jal	ra,80003f48 <end_op>
  return 0;
    800052e2:	4501                	li	a0,0
}
    800052e4:	60aa                	ld	ra,136(sp)
    800052e6:	640a                	ld	s0,128(sp)
    800052e8:	6149                	addi	sp,sp,144
    800052ea:	8082                	ret
    end_op();
    800052ec:	c5dfe0ef          	jal	ra,80003f48 <end_op>
    return -1;
    800052f0:	557d                	li	a0,-1
    800052f2:	bfcd                	j	800052e4 <sys_mkdir+0x38>

00000000800052f4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800052f4:	7135                	addi	sp,sp,-160
    800052f6:	ed06                	sd	ra,152(sp)
    800052f8:	e922                	sd	s0,144(sp)
    800052fa:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800052fc:	bddfe0ef          	jal	ra,80003ed8 <begin_op>
  argint(1, &major);
    80005300:	f6c40593          	addi	a1,s0,-148
    80005304:	4505                	li	a0,1
    80005306:	ec8fd0ef          	jal	ra,800029ce <argint>
  argint(2, &minor);
    8000530a:	f6840593          	addi	a1,s0,-152
    8000530e:	4509                	li	a0,2
    80005310:	ebefd0ef          	jal	ra,800029ce <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005314:	08000613          	li	a2,128
    80005318:	f7040593          	addi	a1,s0,-144
    8000531c:	4501                	li	a0,0
    8000531e:	ee8fd0ef          	jal	ra,80002a06 <argstr>
    80005322:	02054563          	bltz	a0,8000534c <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005326:	f6841683          	lh	a3,-152(s0)
    8000532a:	f6c41603          	lh	a2,-148(s0)
    8000532e:	458d                	li	a1,3
    80005330:	f7040513          	addi	a0,s0,-144
    80005334:	937ff0ef          	jal	ra,80004c6a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005338:	c911                	beqz	a0,8000534c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000533a:	bc6fe0ef          	jal	ra,80003700 <iunlockput>
  end_op();
    8000533e:	c0bfe0ef          	jal	ra,80003f48 <end_op>
  return 0;
    80005342:	4501                	li	a0,0
}
    80005344:	60ea                	ld	ra,152(sp)
    80005346:	644a                	ld	s0,144(sp)
    80005348:	610d                	addi	sp,sp,160
    8000534a:	8082                	ret
    end_op();
    8000534c:	bfdfe0ef          	jal	ra,80003f48 <end_op>
    return -1;
    80005350:	557d                	li	a0,-1
    80005352:	bfcd                	j	80005344 <sys_mknod+0x50>

0000000080005354 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005354:	7135                	addi	sp,sp,-160
    80005356:	ed06                	sd	ra,152(sp)
    80005358:	e922                	sd	s0,144(sp)
    8000535a:	e526                	sd	s1,136(sp)
    8000535c:	e14a                	sd	s2,128(sp)
    8000535e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005360:	ce0fc0ef          	jal	ra,80001840 <myproc>
    80005364:	892a                	mv	s2,a0
  
  begin_op();
    80005366:	b73fe0ef          	jal	ra,80003ed8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000536a:	08000613          	li	a2,128
    8000536e:	f6040593          	addi	a1,s0,-160
    80005372:	4501                	li	a0,0
    80005374:	e92fd0ef          	jal	ra,80002a06 <argstr>
    80005378:	04054163          	bltz	a0,800053ba <sys_chdir+0x66>
    8000537c:	f6040513          	addi	a0,s0,-160
    80005380:	969fe0ef          	jal	ra,80003ce8 <namei>
    80005384:	84aa                	mv	s1,a0
    80005386:	c915                	beqz	a0,800053ba <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005388:	972fe0ef          	jal	ra,800034fa <ilock>
  if(ip->type != T_DIR){
    8000538c:	04449703          	lh	a4,68(s1)
    80005390:	4785                	li	a5,1
    80005392:	02f71863          	bne	a4,a5,800053c2 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005396:	8526                	mv	a0,s1
    80005398:	a0cfe0ef          	jal	ra,800035a4 <iunlock>
  iput(p->cwd);
    8000539c:	15093503          	ld	a0,336(s2)
    800053a0:	ad8fe0ef          	jal	ra,80003678 <iput>
  end_op();
    800053a4:	ba5fe0ef          	jal	ra,80003f48 <end_op>
  p->cwd = ip;
    800053a8:	14993823          	sd	s1,336(s2)
  return 0;
    800053ac:	4501                	li	a0,0
}
    800053ae:	60ea                	ld	ra,152(sp)
    800053b0:	644a                	ld	s0,144(sp)
    800053b2:	64aa                	ld	s1,136(sp)
    800053b4:	690a                	ld	s2,128(sp)
    800053b6:	610d                	addi	sp,sp,160
    800053b8:	8082                	ret
    end_op();
    800053ba:	b8ffe0ef          	jal	ra,80003f48 <end_op>
    return -1;
    800053be:	557d                	li	a0,-1
    800053c0:	b7fd                	j	800053ae <sys_chdir+0x5a>
    iunlockput(ip);
    800053c2:	8526                	mv	a0,s1
    800053c4:	b3cfe0ef          	jal	ra,80003700 <iunlockput>
    end_op();
    800053c8:	b81fe0ef          	jal	ra,80003f48 <end_op>
    return -1;
    800053cc:	557d                	li	a0,-1
    800053ce:	b7c5                	j	800053ae <sys_chdir+0x5a>

00000000800053d0 <sys_exec>:

uint64
sys_exec(void)
{
    800053d0:	7145                	addi	sp,sp,-464
    800053d2:	e786                	sd	ra,456(sp)
    800053d4:	e3a2                	sd	s0,448(sp)
    800053d6:	ff26                	sd	s1,440(sp)
    800053d8:	fb4a                	sd	s2,432(sp)
    800053da:	f74e                	sd	s3,424(sp)
    800053dc:	f352                	sd	s4,416(sp)
    800053de:	ef56                	sd	s5,408(sp)
    800053e0:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800053e2:	e3840593          	addi	a1,s0,-456
    800053e6:	4505                	li	a0,1
    800053e8:	e02fd0ef          	jal	ra,800029ea <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800053ec:	08000613          	li	a2,128
    800053f0:	f4040593          	addi	a1,s0,-192
    800053f4:	4501                	li	a0,0
    800053f6:	e10fd0ef          	jal	ra,80002a06 <argstr>
    800053fa:	87aa                	mv	a5,a0
    return -1;
    800053fc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800053fe:	0a07c463          	bltz	a5,800054a6 <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    80005402:	10000613          	li	a2,256
    80005406:	4581                	li	a1,0
    80005408:	e4040513          	addi	a0,s0,-448
    8000540c:	843fb0ef          	jal	ra,80000c4e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005410:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005414:	89a6                	mv	s3,s1
    80005416:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005418:	02000a13          	li	s4,32
    8000541c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005420:	00391513          	slli	a0,s2,0x3
    80005424:	e3040593          	addi	a1,s0,-464
    80005428:	e3843783          	ld	a5,-456(s0)
    8000542c:	953e                	add	a0,a0,a5
    8000542e:	d16fd0ef          	jal	ra,80002944 <fetchaddr>
    80005432:	02054663          	bltz	a0,8000545e <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80005436:	e3043783          	ld	a5,-464(s0)
    8000543a:	cf8d                	beqz	a5,80005474 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000543c:	e6efb0ef          	jal	ra,80000aaa <kalloc>
    80005440:	85aa                	mv	a1,a0
    80005442:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005446:	cd01                	beqz	a0,8000545e <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005448:	6605                	lui	a2,0x1
    8000544a:	e3043503          	ld	a0,-464(s0)
    8000544e:	d40fd0ef          	jal	ra,8000298e <fetchstr>
    80005452:	00054663          	bltz	a0,8000545e <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80005456:	0905                	addi	s2,s2,1
    80005458:	09a1                	addi	s3,s3,8
    8000545a:	fd4911e3          	bne	s2,s4,8000541c <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000545e:	10048913          	addi	s2,s1,256
    80005462:	6088                	ld	a0,0(s1)
    80005464:	c121                	beqz	a0,800054a4 <sys_exec+0xd4>
    kfree(argv[i]);
    80005466:	d64fb0ef          	jal	ra,800009ca <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000546a:	04a1                	addi	s1,s1,8
    8000546c:	ff249be3          	bne	s1,s2,80005462 <sys_exec+0x92>
  return -1;
    80005470:	557d                	li	a0,-1
    80005472:	a815                	j	800054a6 <sys_exec+0xd6>
      argv[i] = 0;
    80005474:	0a8e                	slli	s5,s5,0x3
    80005476:	fc040793          	addi	a5,s0,-64
    8000547a:	9abe                	add	s5,s5,a5
    8000547c:	e80ab023          	sd	zero,-384(s5)
  int ret = kexec(path, argv);
    80005480:	e4040593          	addi	a1,s0,-448
    80005484:	f4040513          	addi	a0,s0,-192
    80005488:	c18ff0ef          	jal	ra,800048a0 <kexec>
    8000548c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000548e:	10048993          	addi	s3,s1,256
    80005492:	6088                	ld	a0,0(s1)
    80005494:	c511                	beqz	a0,800054a0 <sys_exec+0xd0>
    kfree(argv[i]);
    80005496:	d34fb0ef          	jal	ra,800009ca <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000549a:	04a1                	addi	s1,s1,8
    8000549c:	ff349be3          	bne	s1,s3,80005492 <sys_exec+0xc2>
  return ret;
    800054a0:	854a                	mv	a0,s2
    800054a2:	a011                	j	800054a6 <sys_exec+0xd6>
  return -1;
    800054a4:	557d                	li	a0,-1
}
    800054a6:	60be                	ld	ra,456(sp)
    800054a8:	641e                	ld	s0,448(sp)
    800054aa:	74fa                	ld	s1,440(sp)
    800054ac:	795a                	ld	s2,432(sp)
    800054ae:	79ba                	ld	s3,424(sp)
    800054b0:	7a1a                	ld	s4,416(sp)
    800054b2:	6afa                	ld	s5,408(sp)
    800054b4:	6179                	addi	sp,sp,464
    800054b6:	8082                	ret

00000000800054b8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800054b8:	7139                	addi	sp,sp,-64
    800054ba:	fc06                	sd	ra,56(sp)
    800054bc:	f822                	sd	s0,48(sp)
    800054be:	f426                	sd	s1,40(sp)
    800054c0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800054c2:	b7efc0ef          	jal	ra,80001840 <myproc>
    800054c6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800054c8:	fd840593          	addi	a1,s0,-40
    800054cc:	4501                	li	a0,0
    800054ce:	d1cfd0ef          	jal	ra,800029ea <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800054d2:	fc840593          	addi	a1,s0,-56
    800054d6:	fd040513          	addi	a0,s0,-48
    800054da:	8d8ff0ef          	jal	ra,800045b2 <pipealloc>
    return -1;
    800054de:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800054e0:	0a054463          	bltz	a0,80005588 <sys_pipe+0xd0>
  fd0 = -1;
    800054e4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800054e8:	fd043503          	ld	a0,-48(s0)
    800054ec:	f40ff0ef          	jal	ra,80004c2c <fdalloc>
    800054f0:	fca42223          	sw	a0,-60(s0)
    800054f4:	08054163          	bltz	a0,80005576 <sys_pipe+0xbe>
    800054f8:	fc843503          	ld	a0,-56(s0)
    800054fc:	f30ff0ef          	jal	ra,80004c2c <fdalloc>
    80005500:	fca42023          	sw	a0,-64(s0)
    80005504:	06054063          	bltz	a0,80005564 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005508:	4691                	li	a3,4
    8000550a:	fc440613          	addi	a2,s0,-60
    8000550e:	fd843583          	ld	a1,-40(s0)
    80005512:	68a8                	ld	a0,80(s1)
    80005514:	854fc0ef          	jal	ra,80001568 <copyout>
    80005518:	00054e63          	bltz	a0,80005534 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000551c:	4691                	li	a3,4
    8000551e:	fc040613          	addi	a2,s0,-64
    80005522:	fd843583          	ld	a1,-40(s0)
    80005526:	0591                	addi	a1,a1,4
    80005528:	68a8                	ld	a0,80(s1)
    8000552a:	83efc0ef          	jal	ra,80001568 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000552e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005530:	04055c63          	bgez	a0,80005588 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005534:	fc442783          	lw	a5,-60(s0)
    80005538:	07e9                	addi	a5,a5,26
    8000553a:	078e                	slli	a5,a5,0x3
    8000553c:	97a6                	add	a5,a5,s1
    8000553e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005542:	fc042503          	lw	a0,-64(s0)
    80005546:	0569                	addi	a0,a0,26
    80005548:	050e                	slli	a0,a0,0x3
    8000554a:	94aa                	add	s1,s1,a0
    8000554c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005550:	fd043503          	ld	a0,-48(s0)
    80005554:	d93fe0ef          	jal	ra,800042e6 <fileclose>
    fileclose(wf);
    80005558:	fc843503          	ld	a0,-56(s0)
    8000555c:	d8bfe0ef          	jal	ra,800042e6 <fileclose>
    return -1;
    80005560:	57fd                	li	a5,-1
    80005562:	a01d                	j	80005588 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005564:	fc442783          	lw	a5,-60(s0)
    80005568:	0007c763          	bltz	a5,80005576 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000556c:	07e9                	addi	a5,a5,26
    8000556e:	078e                	slli	a5,a5,0x3
    80005570:	94be                	add	s1,s1,a5
    80005572:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005576:	fd043503          	ld	a0,-48(s0)
    8000557a:	d6dfe0ef          	jal	ra,800042e6 <fileclose>
    fileclose(wf);
    8000557e:	fc843503          	ld	a0,-56(s0)
    80005582:	d65fe0ef          	jal	ra,800042e6 <fileclose>
    return -1;
    80005586:	57fd                	li	a5,-1
}
    80005588:	853e                	mv	a0,a5
    8000558a:	70e2                	ld	ra,56(sp)
    8000558c:	7442                	ld	s0,48(sp)
    8000558e:	74a2                	ld	s1,40(sp)
    80005590:	6121                	addi	sp,sp,64
    80005592:	8082                	ret
	...

00000000800055a0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800055a0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800055a2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800055a4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    800055a6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    800055a8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800055aa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800055ac:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800055ae:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800055b0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800055b2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800055b4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800055b6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800055b8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800055ba:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800055bc:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800055be:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800055c0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800055c2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800055c4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800055c6:	a6cfd0ef          	jal	ra,80002832 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800055ca:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800055cc:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800055ce:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800055d0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800055d2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800055d4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800055d6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800055d8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800055da:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800055dc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800055de:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800055e0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800055e2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800055e4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800055e6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800055e8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800055ea:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800055ec:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800055ee:	10200073          	sret
	...

00000000800055fe <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800055fe:	1141                	addi	sp,sp,-16
    80005600:	e422                	sd	s0,8(sp)
    80005602:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005604:	0c0007b7          	lui	a5,0xc000
    80005608:	4705                	li	a4,1
    8000560a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000560c:	c3d8                	sw	a4,4(a5)
}
    8000560e:	6422                	ld	s0,8(sp)
    80005610:	0141                	addi	sp,sp,16
    80005612:	8082                	ret

0000000080005614 <plicinithart>:

void
plicinithart(void)
{
    80005614:	1141                	addi	sp,sp,-16
    80005616:	e406                	sd	ra,8(sp)
    80005618:	e022                	sd	s0,0(sp)
    8000561a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000561c:	9f8fc0ef          	jal	ra,80001814 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005620:	0085171b          	slliw	a4,a0,0x8
    80005624:	0c0027b7          	lui	a5,0xc002
    80005628:	97ba                	add	a5,a5,a4
    8000562a:	40200713          	li	a4,1026
    8000562e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005632:	00d5151b          	slliw	a0,a0,0xd
    80005636:	0c2017b7          	lui	a5,0xc201
    8000563a:	953e                	add	a0,a0,a5
    8000563c:	00052023          	sw	zero,0(a0)
}
    80005640:	60a2                	ld	ra,8(sp)
    80005642:	6402                	ld	s0,0(sp)
    80005644:	0141                	addi	sp,sp,16
    80005646:	8082                	ret

0000000080005648 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005648:	1141                	addi	sp,sp,-16
    8000564a:	e406                	sd	ra,8(sp)
    8000564c:	e022                	sd	s0,0(sp)
    8000564e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005650:	9c4fc0ef          	jal	ra,80001814 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005654:	00d5179b          	slliw	a5,a0,0xd
    80005658:	0c201537          	lui	a0,0xc201
    8000565c:	953e                	add	a0,a0,a5
  return irq;
}
    8000565e:	4148                	lw	a0,4(a0)
    80005660:	60a2                	ld	ra,8(sp)
    80005662:	6402                	ld	s0,0(sp)
    80005664:	0141                	addi	sp,sp,16
    80005666:	8082                	ret

0000000080005668 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005668:	1101                	addi	sp,sp,-32
    8000566a:	ec06                	sd	ra,24(sp)
    8000566c:	e822                	sd	s0,16(sp)
    8000566e:	e426                	sd	s1,8(sp)
    80005670:	1000                	addi	s0,sp,32
    80005672:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005674:	9a0fc0ef          	jal	ra,80001814 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005678:	00d5151b          	slliw	a0,a0,0xd
    8000567c:	0c2017b7          	lui	a5,0xc201
    80005680:	97aa                	add	a5,a5,a0
    80005682:	c3c4                	sw	s1,4(a5)
}
    80005684:	60e2                	ld	ra,24(sp)
    80005686:	6442                	ld	s0,16(sp)
    80005688:	64a2                	ld	s1,8(sp)
    8000568a:	6105                	addi	sp,sp,32
    8000568c:	8082                	ret

000000008000568e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000568e:	1141                	addi	sp,sp,-16
    80005690:	e406                	sd	ra,8(sp)
    80005692:	e022                	sd	s0,0(sp)
    80005694:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005696:	479d                	li	a5,7
    80005698:	04a7ca63          	blt	a5,a0,800056ec <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000569c:	0001c797          	auipc	a5,0x1c
    800056a0:	a1c78793          	addi	a5,a5,-1508 # 800210b8 <disk>
    800056a4:	97aa                	add	a5,a5,a0
    800056a6:	0187c783          	lbu	a5,24(a5)
    800056aa:	e7b9                	bnez	a5,800056f8 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800056ac:	00451613          	slli	a2,a0,0x4
    800056b0:	0001c797          	auipc	a5,0x1c
    800056b4:	a0878793          	addi	a5,a5,-1528 # 800210b8 <disk>
    800056b8:	6394                	ld	a3,0(a5)
    800056ba:	96b2                	add	a3,a3,a2
    800056bc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800056c0:	6398                	ld	a4,0(a5)
    800056c2:	9732                	add	a4,a4,a2
    800056c4:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800056c8:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800056cc:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800056d0:	953e                	add	a0,a0,a5
    800056d2:	4785                	li	a5,1
    800056d4:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800056d8:	0001c517          	auipc	a0,0x1c
    800056dc:	9f850513          	addi	a0,a0,-1544 # 800210d0 <disk+0x18>
    800056e0:	e34fc0ef          	jal	ra,80001d14 <wakeup>
}
    800056e4:	60a2                	ld	ra,8(sp)
    800056e6:	6402                	ld	s0,0(sp)
    800056e8:	0141                	addi	sp,sp,16
    800056ea:	8082                	ret
    panic("free_desc 1");
    800056ec:	00002517          	auipc	a0,0x2
    800056f0:	03c50513          	addi	a0,a0,60 # 80007728 <syscalls+0x338>
    800056f4:	89cfb0ef          	jal	ra,80000790 <panic>
    panic("free_desc 2");
    800056f8:	00002517          	auipc	a0,0x2
    800056fc:	04050513          	addi	a0,a0,64 # 80007738 <syscalls+0x348>
    80005700:	890fb0ef          	jal	ra,80000790 <panic>

0000000080005704 <virtio_disk_init>:
{
    80005704:	1101                	addi	sp,sp,-32
    80005706:	ec06                	sd	ra,24(sp)
    80005708:	e822                	sd	s0,16(sp)
    8000570a:	e426                	sd	s1,8(sp)
    8000570c:	e04a                	sd	s2,0(sp)
    8000570e:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005710:	00002597          	auipc	a1,0x2
    80005714:	03858593          	addi	a1,a1,56 # 80007748 <syscalls+0x358>
    80005718:	0001c517          	auipc	a0,0x1c
    8000571c:	ac850513          	addi	a0,a0,-1336 # 800211e0 <disk+0x128>
    80005720:	bdafb0ef          	jal	ra,80000afa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005724:	100017b7          	lui	a5,0x10001
    80005728:	4398                	lw	a4,0(a5)
    8000572a:	2701                	sext.w	a4,a4
    8000572c:	747277b7          	lui	a5,0x74727
    80005730:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005734:	14f71263          	bne	a4,a5,80005878 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005738:	100017b7          	lui	a5,0x10001
    8000573c:	43dc                	lw	a5,4(a5)
    8000573e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005740:	4709                	li	a4,2
    80005742:	12e79b63          	bne	a5,a4,80005878 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005746:	100017b7          	lui	a5,0x10001
    8000574a:	479c                	lw	a5,8(a5)
    8000574c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000574e:	12e79563          	bne	a5,a4,80005878 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005752:	100017b7          	lui	a5,0x10001
    80005756:	47d8                	lw	a4,12(a5)
    80005758:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000575a:	554d47b7          	lui	a5,0x554d4
    8000575e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005762:	10f71b63          	bne	a4,a5,80005878 <virtio_disk_init+0x174>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005766:	100017b7          	lui	a5,0x10001
    8000576a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000576e:	4705                	li	a4,1
    80005770:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005772:	470d                	li	a4,3
    80005774:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005776:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005778:	c7ffe737          	lui	a4,0xc7ffe
    8000577c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd567>
    80005780:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005782:	2701                	sext.w	a4,a4
    80005784:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005786:	472d                	li	a4,11
    80005788:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000578a:	0707a903          	lw	s2,112(a5)
    8000578e:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005790:	00897793          	andi	a5,s2,8
    80005794:	0e078863          	beqz	a5,80005884 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005798:	100017b7          	lui	a5,0x10001
    8000579c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800057a0:	43fc                	lw	a5,68(a5)
    800057a2:	2781                	sext.w	a5,a5
    800057a4:	0e079663          	bnez	a5,80005890 <virtio_disk_init+0x18c>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800057a8:	100017b7          	lui	a5,0x10001
    800057ac:	5bdc                	lw	a5,52(a5)
    800057ae:	2781                	sext.w	a5,a5
  if(max == 0)
    800057b0:	0e078663          	beqz	a5,8000589c <virtio_disk_init+0x198>
  if(max < NUM)
    800057b4:	471d                	li	a4,7
    800057b6:	0ef77963          	bgeu	a4,a5,800058a8 <virtio_disk_init+0x1a4>
  disk.desc = kalloc();
    800057ba:	af0fb0ef          	jal	ra,80000aaa <kalloc>
    800057be:	0001c497          	auipc	s1,0x1c
    800057c2:	8fa48493          	addi	s1,s1,-1798 # 800210b8 <disk>
    800057c6:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800057c8:	ae2fb0ef          	jal	ra,80000aaa <kalloc>
    800057cc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800057ce:	adcfb0ef          	jal	ra,80000aaa <kalloc>
    800057d2:	87aa                	mv	a5,a0
    800057d4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800057d6:	6088                	ld	a0,0(s1)
    800057d8:	cd71                	beqz	a0,800058b4 <virtio_disk_init+0x1b0>
    800057da:	0001c717          	auipc	a4,0x1c
    800057de:	8e673703          	ld	a4,-1818(a4) # 800210c0 <disk+0x8>
    800057e2:	cb69                	beqz	a4,800058b4 <virtio_disk_init+0x1b0>
    800057e4:	cbe1                	beqz	a5,800058b4 <virtio_disk_init+0x1b0>
  memset(disk.desc, 0, PGSIZE);
    800057e6:	6605                	lui	a2,0x1
    800057e8:	4581                	li	a1,0
    800057ea:	c64fb0ef          	jal	ra,80000c4e <memset>
  memset(disk.avail, 0, PGSIZE);
    800057ee:	0001c497          	auipc	s1,0x1c
    800057f2:	8ca48493          	addi	s1,s1,-1846 # 800210b8 <disk>
    800057f6:	6605                	lui	a2,0x1
    800057f8:	4581                	li	a1,0
    800057fa:	6488                	ld	a0,8(s1)
    800057fc:	c52fb0ef          	jal	ra,80000c4e <memset>
  memset(disk.used, 0, PGSIZE);
    80005800:	6605                	lui	a2,0x1
    80005802:	4581                	li	a1,0
    80005804:	6888                	ld	a0,16(s1)
    80005806:	c48fb0ef          	jal	ra,80000c4e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000580a:	100017b7          	lui	a5,0x10001
    8000580e:	4721                	li	a4,8
    80005810:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005812:	4098                	lw	a4,0(s1)
    80005814:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005818:	40d8                	lw	a4,4(s1)
    8000581a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000581e:	6498                	ld	a4,8(s1)
    80005820:	0007069b          	sext.w	a3,a4
    80005824:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005828:	9701                	srai	a4,a4,0x20
    8000582a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000582e:	6898                	ld	a4,16(s1)
    80005830:	0007069b          	sext.w	a3,a4
    80005834:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005838:	9701                	srai	a4,a4,0x20
    8000583a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000583e:	4685                	li	a3,1
    80005840:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005842:	4705                	li	a4,1
    80005844:	00d48c23          	sb	a3,24(s1)
    80005848:	00e48ca3          	sb	a4,25(s1)
    8000584c:	00e48d23          	sb	a4,26(s1)
    80005850:	00e48da3          	sb	a4,27(s1)
    80005854:	00e48e23          	sb	a4,28(s1)
    80005858:	00e48ea3          	sb	a4,29(s1)
    8000585c:	00e48f23          	sb	a4,30(s1)
    80005860:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005864:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005868:	0727a823          	sw	s2,112(a5)
}
    8000586c:	60e2                	ld	ra,24(sp)
    8000586e:	6442                	ld	s0,16(sp)
    80005870:	64a2                	ld	s1,8(sp)
    80005872:	6902                	ld	s2,0(sp)
    80005874:	6105                	addi	sp,sp,32
    80005876:	8082                	ret
    panic("could not find virtio disk");
    80005878:	00002517          	auipc	a0,0x2
    8000587c:	ee050513          	addi	a0,a0,-288 # 80007758 <syscalls+0x368>
    80005880:	f11fa0ef          	jal	ra,80000790 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005884:	00002517          	auipc	a0,0x2
    80005888:	ef450513          	addi	a0,a0,-268 # 80007778 <syscalls+0x388>
    8000588c:	f05fa0ef          	jal	ra,80000790 <panic>
    panic("virtio disk should not be ready");
    80005890:	00002517          	auipc	a0,0x2
    80005894:	f0850513          	addi	a0,a0,-248 # 80007798 <syscalls+0x3a8>
    80005898:	ef9fa0ef          	jal	ra,80000790 <panic>
    panic("virtio disk has no queue 0");
    8000589c:	00002517          	auipc	a0,0x2
    800058a0:	f1c50513          	addi	a0,a0,-228 # 800077b8 <syscalls+0x3c8>
    800058a4:	eedfa0ef          	jal	ra,80000790 <panic>
    panic("virtio disk max queue too short");
    800058a8:	00002517          	auipc	a0,0x2
    800058ac:	f3050513          	addi	a0,a0,-208 # 800077d8 <syscalls+0x3e8>
    800058b0:	ee1fa0ef          	jal	ra,80000790 <panic>
    panic("virtio disk kalloc");
    800058b4:	00002517          	auipc	a0,0x2
    800058b8:	f4450513          	addi	a0,a0,-188 # 800077f8 <syscalls+0x408>
    800058bc:	ed5fa0ef          	jal	ra,80000790 <panic>

00000000800058c0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800058c0:	7159                	addi	sp,sp,-112
    800058c2:	f486                	sd	ra,104(sp)
    800058c4:	f0a2                	sd	s0,96(sp)
    800058c6:	eca6                	sd	s1,88(sp)
    800058c8:	e8ca                	sd	s2,80(sp)
    800058ca:	e4ce                	sd	s3,72(sp)
    800058cc:	e0d2                	sd	s4,64(sp)
    800058ce:	fc56                	sd	s5,56(sp)
    800058d0:	f85a                	sd	s6,48(sp)
    800058d2:	f45e                	sd	s7,40(sp)
    800058d4:	f062                	sd	s8,32(sp)
    800058d6:	ec66                	sd	s9,24(sp)
    800058d8:	e86a                	sd	s10,16(sp)
    800058da:	1880                	addi	s0,sp,112
    800058dc:	892a                	mv	s2,a0
    800058de:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800058e0:	00c52c83          	lw	s9,12(a0)
    800058e4:	001c9c9b          	slliw	s9,s9,0x1
    800058e8:	1c82                	slli	s9,s9,0x20
    800058ea:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800058ee:	0001c517          	auipc	a0,0x1c
    800058f2:	8f250513          	addi	a0,a0,-1806 # 800211e0 <disk+0x128>
    800058f6:	a84fb0ef          	jal	ra,80000b7a <acquire>
  for(int i = 0; i < 3; i++){
    800058fa:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800058fc:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800058fe:	0001bb17          	auipc	s6,0x1b
    80005902:	7bab0b13          	addi	s6,s6,1978 # 800210b8 <disk>
  for(int i = 0; i < 3; i++){
    80005906:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005908:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000590a:	0001cc17          	auipc	s8,0x1c
    8000590e:	8d6c0c13          	addi	s8,s8,-1834 # 800211e0 <disk+0x128>
    80005912:	a0b5                	j	8000597e <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005914:	00fb06b3          	add	a3,s6,a5
    80005918:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    8000591c:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000591e:	0207c563          	bltz	a5,80005948 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005922:	2485                	addiw	s1,s1,1
    80005924:	0711                	addi	a4,a4,4
    80005926:	1d548c63          	beq	s1,s5,80005afe <virtio_disk_rw+0x23e>
    idx[i] = alloc_desc();
    8000592a:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    8000592c:	0001b697          	auipc	a3,0x1b
    80005930:	78c68693          	addi	a3,a3,1932 # 800210b8 <disk>
    80005934:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005936:	0186c583          	lbu	a1,24(a3)
    8000593a:	fde9                	bnez	a1,80005914 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    8000593c:	2785                	addiw	a5,a5,1
    8000593e:	0685                	addi	a3,a3,1
    80005940:	ff779be3          	bne	a5,s7,80005936 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005944:	57fd                	li	a5,-1
    80005946:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005948:	02905463          	blez	s1,80005970 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    8000594c:	f9042503          	lw	a0,-112(s0)
    80005950:	d3fff0ef          	jal	ra,8000568e <free_desc>
      for(int j = 0; j < i; j++)
    80005954:	4785                	li	a5,1
    80005956:	0097dd63          	bge	a5,s1,80005970 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    8000595a:	f9442503          	lw	a0,-108(s0)
    8000595e:	d31ff0ef          	jal	ra,8000568e <free_desc>
      for(int j = 0; j < i; j++)
    80005962:	4789                	li	a5,2
    80005964:	0097d663          	bge	a5,s1,80005970 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    80005968:	f9842503          	lw	a0,-104(s0)
    8000596c:	d23ff0ef          	jal	ra,8000568e <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005970:	85e2                	mv	a1,s8
    80005972:	0001b517          	auipc	a0,0x1b
    80005976:	75e50513          	addi	a0,a0,1886 # 800210d0 <disk+0x18>
    8000597a:	b48fc0ef          	jal	ra,80001cc2 <sleep>
  for(int i = 0; i < 3; i++){
    8000597e:	f9040713          	addi	a4,s0,-112
    80005982:	84ce                	mv	s1,s3
    80005984:	b75d                	j	8000592a <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005986:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    8000598a:	00479693          	slli	a3,a5,0x4
    8000598e:	0001b797          	auipc	a5,0x1b
    80005992:	72a78793          	addi	a5,a5,1834 # 800210b8 <disk>
    80005996:	97b6                	add	a5,a5,a3
    80005998:	4685                	li	a3,1
    8000599a:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000599c:	0001b597          	auipc	a1,0x1b
    800059a0:	71c58593          	addi	a1,a1,1820 # 800210b8 <disk>
    800059a4:	00a60793          	addi	a5,a2,10
    800059a8:	0792                	slli	a5,a5,0x4
    800059aa:	97ae                	add	a5,a5,a1
    800059ac:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800059b0:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800059b4:	f6070693          	addi	a3,a4,-160
    800059b8:	619c                	ld	a5,0(a1)
    800059ba:	97b6                	add	a5,a5,a3
    800059bc:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800059be:	6188                	ld	a0,0(a1)
    800059c0:	96aa                	add	a3,a3,a0
    800059c2:	47c1                	li	a5,16
    800059c4:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800059c6:	4785                	li	a5,1
    800059c8:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800059cc:	f9442783          	lw	a5,-108(s0)
    800059d0:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800059d4:	0792                	slli	a5,a5,0x4
    800059d6:	953e                	add	a0,a0,a5
    800059d8:	05890693          	addi	a3,s2,88
    800059dc:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800059de:	6188                	ld	a0,0(a1)
    800059e0:	97aa                	add	a5,a5,a0
    800059e2:	40000693          	li	a3,1024
    800059e6:	c794                	sw	a3,8(a5)
  if(write)
    800059e8:	100d0763          	beqz	s10,80005af6 <virtio_disk_rw+0x236>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800059ec:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800059f0:	00c7d683          	lhu	a3,12(a5)
    800059f4:	0016e693          	ori	a3,a3,1
    800059f8:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800059fc:	f9842583          	lw	a1,-104(s0)
    80005a00:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005a04:	0001b697          	auipc	a3,0x1b
    80005a08:	6b468693          	addi	a3,a3,1716 # 800210b8 <disk>
    80005a0c:	00260793          	addi	a5,a2,2
    80005a10:	0792                	slli	a5,a5,0x4
    80005a12:	97b6                	add	a5,a5,a3
    80005a14:	587d                	li	a6,-1
    80005a16:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005a1a:	0592                	slli	a1,a1,0x4
    80005a1c:	952e                	add	a0,a0,a1
    80005a1e:	f9070713          	addi	a4,a4,-112
    80005a22:	9736                	add	a4,a4,a3
    80005a24:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005a26:	6298                	ld	a4,0(a3)
    80005a28:	972e                	add	a4,a4,a1
    80005a2a:	4585                	li	a1,1
    80005a2c:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005a2e:	4509                	li	a0,2
    80005a30:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005a34:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005a38:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005a3c:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005a40:	6698                	ld	a4,8(a3)
    80005a42:	00275783          	lhu	a5,2(a4)
    80005a46:	8b9d                	andi	a5,a5,7
    80005a48:	0786                	slli	a5,a5,0x1
    80005a4a:	97ba                	add	a5,a5,a4
    80005a4c:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    80005a50:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005a54:	6698                	ld	a4,8(a3)
    80005a56:	00275783          	lhu	a5,2(a4)
    80005a5a:	2785                	addiw	a5,a5,1
    80005a5c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005a60:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005a64:	100017b7          	lui	a5,0x10001
    80005a68:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005a6c:	00492703          	lw	a4,4(s2)
    80005a70:	4785                	li	a5,1
    80005a72:	00f71f63          	bne	a4,a5,80005a90 <virtio_disk_rw+0x1d0>
    sleep(b, &disk.vdisk_lock);
    80005a76:	0001b997          	auipc	s3,0x1b
    80005a7a:	76a98993          	addi	s3,s3,1898 # 800211e0 <disk+0x128>
  while(b->disk == 1) {
    80005a7e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005a80:	85ce                	mv	a1,s3
    80005a82:	854a                	mv	a0,s2
    80005a84:	a3efc0ef          	jal	ra,80001cc2 <sleep>
  while(b->disk == 1) {
    80005a88:	00492783          	lw	a5,4(s2)
    80005a8c:	fe978ae3          	beq	a5,s1,80005a80 <virtio_disk_rw+0x1c0>
  }

  disk.info[idx[0]].b = 0;
    80005a90:	f9042903          	lw	s2,-112(s0)
    80005a94:	00290793          	addi	a5,s2,2
    80005a98:	00479713          	slli	a4,a5,0x4
    80005a9c:	0001b797          	auipc	a5,0x1b
    80005aa0:	61c78793          	addi	a5,a5,1564 # 800210b8 <disk>
    80005aa4:	97ba                	add	a5,a5,a4
    80005aa6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005aaa:	0001b997          	auipc	s3,0x1b
    80005aae:	60e98993          	addi	s3,s3,1550 # 800210b8 <disk>
    80005ab2:	00491713          	slli	a4,s2,0x4
    80005ab6:	0009b783          	ld	a5,0(s3)
    80005aba:	97ba                	add	a5,a5,a4
    80005abc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005ac0:	854a                	mv	a0,s2
    80005ac2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005ac6:	bc9ff0ef          	jal	ra,8000568e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005aca:	8885                	andi	s1,s1,1
    80005acc:	f0fd                	bnez	s1,80005ab2 <virtio_disk_rw+0x1f2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005ace:	0001b517          	auipc	a0,0x1b
    80005ad2:	71250513          	addi	a0,a0,1810 # 800211e0 <disk+0x128>
    80005ad6:	93cfb0ef          	jal	ra,80000c12 <release>
}
    80005ada:	70a6                	ld	ra,104(sp)
    80005adc:	7406                	ld	s0,96(sp)
    80005ade:	64e6                	ld	s1,88(sp)
    80005ae0:	6946                	ld	s2,80(sp)
    80005ae2:	69a6                	ld	s3,72(sp)
    80005ae4:	6a06                	ld	s4,64(sp)
    80005ae6:	7ae2                	ld	s5,56(sp)
    80005ae8:	7b42                	ld	s6,48(sp)
    80005aea:	7ba2                	ld	s7,40(sp)
    80005aec:	7c02                	ld	s8,32(sp)
    80005aee:	6ce2                	ld	s9,24(sp)
    80005af0:	6d42                	ld	s10,16(sp)
    80005af2:	6165                	addi	sp,sp,112
    80005af4:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005af6:	4689                	li	a3,2
    80005af8:	00d79623          	sh	a3,12(a5)
    80005afc:	bdd5                	j	800059f0 <virtio_disk_rw+0x130>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005afe:	f9042603          	lw	a2,-112(s0)
    80005b02:	00a60713          	addi	a4,a2,10
    80005b06:	0712                	slli	a4,a4,0x4
    80005b08:	0001b517          	auipc	a0,0x1b
    80005b0c:	5b850513          	addi	a0,a0,1464 # 800210c0 <disk+0x8>
    80005b10:	953a                	add	a0,a0,a4
  if(write)
    80005b12:	e60d1ae3          	bnez	s10,80005986 <virtio_disk_rw+0xc6>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005b16:	00a60793          	addi	a5,a2,10
    80005b1a:	00479693          	slli	a3,a5,0x4
    80005b1e:	0001b797          	auipc	a5,0x1b
    80005b22:	59a78793          	addi	a5,a5,1434 # 800210b8 <disk>
    80005b26:	97b6                	add	a5,a5,a3
    80005b28:	0007a423          	sw	zero,8(a5)
    80005b2c:	bd85                	j	8000599c <virtio_disk_rw+0xdc>

0000000080005b2e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b2e:	1101                	addi	sp,sp,-32
    80005b30:	ec06                	sd	ra,24(sp)
    80005b32:	e822                	sd	s0,16(sp)
    80005b34:	e426                	sd	s1,8(sp)
    80005b36:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b38:	0001b497          	auipc	s1,0x1b
    80005b3c:	58048493          	addi	s1,s1,1408 # 800210b8 <disk>
    80005b40:	0001b517          	auipc	a0,0x1b
    80005b44:	6a050513          	addi	a0,a0,1696 # 800211e0 <disk+0x128>
    80005b48:	832fb0ef          	jal	ra,80000b7a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b4c:	10001737          	lui	a4,0x10001
    80005b50:	533c                	lw	a5,96(a4)
    80005b52:	8b8d                	andi	a5,a5,3
    80005b54:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005b56:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005b5a:	689c                	ld	a5,16(s1)
    80005b5c:	0204d703          	lhu	a4,32(s1)
    80005b60:	0027d783          	lhu	a5,2(a5)
    80005b64:	04f70663          	beq	a4,a5,80005bb0 <virtio_disk_intr+0x82>
    __sync_synchronize();
    80005b68:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b6c:	6898                	ld	a4,16(s1)
    80005b6e:	0204d783          	lhu	a5,32(s1)
    80005b72:	8b9d                	andi	a5,a5,7
    80005b74:	078e                	slli	a5,a5,0x3
    80005b76:	97ba                	add	a5,a5,a4
    80005b78:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005b7a:	00278713          	addi	a4,a5,2
    80005b7e:	0712                	slli	a4,a4,0x4
    80005b80:	9726                	add	a4,a4,s1
    80005b82:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005b86:	e321                	bnez	a4,80005bc6 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b88:	0789                	addi	a5,a5,2
    80005b8a:	0792                	slli	a5,a5,0x4
    80005b8c:	97a6                	add	a5,a5,s1
    80005b8e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005b90:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b94:	980fc0ef          	jal	ra,80001d14 <wakeup>

    disk.used_idx += 1;
    80005b98:	0204d783          	lhu	a5,32(s1)
    80005b9c:	2785                	addiw	a5,a5,1
    80005b9e:	17c2                	slli	a5,a5,0x30
    80005ba0:	93c1                	srli	a5,a5,0x30
    80005ba2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005ba6:	6898                	ld	a4,16(s1)
    80005ba8:	00275703          	lhu	a4,2(a4)
    80005bac:	faf71ee3          	bne	a4,a5,80005b68 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80005bb0:	0001b517          	auipc	a0,0x1b
    80005bb4:	63050513          	addi	a0,a0,1584 # 800211e0 <disk+0x128>
    80005bb8:	85afb0ef          	jal	ra,80000c12 <release>
}
    80005bbc:	60e2                	ld	ra,24(sp)
    80005bbe:	6442                	ld	s0,16(sp)
    80005bc0:	64a2                	ld	s1,8(sp)
    80005bc2:	6105                	addi	sp,sp,32
    80005bc4:	8082                	ret
      panic("virtio_disk_intr status");
    80005bc6:	00002517          	auipc	a0,0x2
    80005bca:	c4a50513          	addi	a0,a0,-950 # 80007810 <syscalls+0x420>
    80005bce:	bc3fa0ef          	jal	ra,80000790 <panic>
	...

0000000080006000 <_trampoline>:
        # user page table.
        #

        # save user a0 in sscratch so
        # a0 can be used to get at TRAPFRAME.
        csrw sscratch, a0
    80006000:	14051073          	csrw	sscratch,a0

        # each process has a separate p->trapframe memory area,
        # but it's mapped to the same virtual address
        # (TRAPFRAME) in every process's user page table.
        li a0, TRAPFRAME
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1
    8000600a:	0536                	slli	a0,a0,0xd
        
        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    8000600c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
        sd sp, 48(a0)
    80006010:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    80006014:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80006018:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    8000601c:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80006020:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    80006024:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80006028:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    8000602a:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    8000602e:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80006030:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    80006032:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    80006034:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    80006036:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    80006046:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    80006056:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    80006066:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    80006072:	11f53c23          	sd	t6,280(a0)

	# save the user a0 in p->trapframe->a0
        csrr t0, sscratch
    80006076:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    8000607a:	06553823          	sd	t0,112(a0)

        # initialize kernel stack pointer, from p->trapframe->kernel_sp
        ld sp, 8(a0)
    8000607e:	00853103          	ld	sp,8(a0)

        # make tp hold the current hartid, from p->trapframe->kernel_hartid
        ld tp, 32(a0)
    80006082:	02053203          	ld	tp,32(a0)

        # load the address of usertrap(), from p->trapframe->kernel_trap
        ld t0, 16(a0)
    80006086:	01053283          	ld	t0,16(a0)

        # fetch the kernel page table address, from p->trapframe->kernel_satp.
        ld t1, 0(a0)
    8000608a:	00053303          	ld	t1,0(a0)

        # wait for any previous memory operations to complete, so that
        # they use the user page table.
        sfence.vma zero, zero
    8000608e:	12000073          	sfence.vma

        # install the kernel page table.
        csrw satp, t1
    80006092:	18031073          	csrw	satp,t1

        # flush now-stale user entries from the TLB.
        sfence.vma zero, zero
    80006096:	12000073          	sfence.vma

        # call usertrap()
        jalr t0
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
userret:
        # usertrap() returns here, with user satp in a0.
        # return from kernel to user.

        # switch to the user page table.
        sfence.vma zero, zero
    8000609c:	12000073          	sfence.vma
        csrw satp, a0
    800060a0:	18051073          	csrw	satp,a0
        sfence.vma zero, zero
    800060a4:	12000073          	sfence.vma

        li a0, TRAPFRAME
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1
    800060ae:	0536                	slli	a0,a0,0xd

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    800060b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
        ld sp, 48(a0)
    800060b4:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    800060b8:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    800060bc:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    800060c0:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    800060c4:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    800060c8:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    800060cc:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    800060ce:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    800060d2:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    800060d4:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    800060d6:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    800060da:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    800060de:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    80006112:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    80006116:	11853f83          	ld	t6,280(a0)

	# restore user a0
        ld a0, 112(a0)
    8000611a:	7928                	ld	a0,112(a0)
        
        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    8000611c:	10200073          	sret
	...
