#define NPROC        64  // maximum number of processes
#define NCPU          8  // maximum number of CPUs
#define NOFILE       16  // open files per process
#define NFILE       100  // open files per system
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max exec arguments
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define LOGBLOCKS    (MAXOPBLOCKS*3)  // max data blocks in on-disk log
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
#define FSSIZE       2000  // size of file system in blocks
#define MAXPATH      128   // maximum file path name
#define USERSTACK    1     // user stack pages
// Εργασία
#define NQUEUES      4  
#define TIME_SLICE_0 4  //ticks για προτεραιότητα 0
#define TIME_SLICE_1 8  //ticks για προτεραιότητα 1
#define TIME_SLICE_2 16 //ticks για προτεραιότητα 2
#define TIME_SLICE_3 32 //ticks για προτεραιότητα 3
#define PROMO_THRESHOLD 10  //πολλαπλάσιο του time slice για promotion
#define INIT_RR_INDEX 0  //αρχική τιμή για round-robin εντός κάθε ουράς 