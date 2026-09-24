
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	04a7dc63          	bge	a5,a0,6a <main+0x6a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	1982                	slli	s3,s3,0x20
  20:	0209d993          	srli	s3,s3,0x20
  24:	098e                	slli	s3,s3,0x3
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	8a6a0a13          	addi	s4,s4,-1882 # 8d0 <malloc+0xe4>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	090000ef          	jal	ra,c8 <strlen>
  3c:	0005061b          	sext.w	a2,a0
  40:	85ca                	mv	a1,s2
  42:	4505                	li	a0,1
  44:	2ea000ef          	jal	ra,32e <write>
    if(i + 1 < argc){
  48:	04a1                	addi	s1,s1,8
  4a:	01348863          	beq	s1,s3,5a <main+0x5a>
      write(1, " ", 1);
  4e:	4605                	li	a2,1
  50:	85d2                	mv	a1,s4
  52:	4505                	li	a0,1
  54:	2da000ef          	jal	ra,32e <write>
  for(i = 1; i < argc; i++){
  58:	bfe9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  5a:	4605                	li	a2,1
  5c:	00001597          	auipc	a1,0x1
  60:	87c58593          	addi	a1,a1,-1924 # 8d8 <malloc+0xec>
  64:	4505                	li	a0,1
  66:	2c8000ef          	jal	ra,32e <write>
    }
  }
  exit(0);
  6a:	4501                	li	a0,0
  6c:	2a2000ef          	jal	ra,30e <exit>

0000000000000070 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  70:	1141                	addi	sp,sp,-16
  72:	e406                	sd	ra,8(sp)
  74:	e022                	sd	s0,0(sp)
  76:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  78:	f89ff0ef          	jal	ra,0 <main>
  exit(r);
  7c:	292000ef          	jal	ra,30e <exit>

0000000000000080 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  86:	87aa                	mv	a5,a0
  88:	0585                	addi	a1,a1,1
  8a:	0785                	addi	a5,a5,1
  8c:	fff5c703          	lbu	a4,-1(a1)
  90:	fee78fa3          	sb	a4,-1(a5)
  94:	fb75                	bnez	a4,88 <strcpy+0x8>
    ;
  return os;
}
  96:	6422                	ld	s0,8(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret

000000000000009c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	cb91                	beqz	a5,ba <strcmp+0x1e>
  a8:	0005c703          	lbu	a4,0(a1)
  ac:	00f71763          	bne	a4,a5,ba <strcmp+0x1e>
    p++, q++;
  b0:	0505                	addi	a0,a0,1
  b2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	fbe5                	bnez	a5,a8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ba:	0005c503          	lbu	a0,0(a1)
}
  be:	40a7853b          	subw	a0,a5,a0
  c2:	6422                	ld	s0,8(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strlen>:

uint
strlen(const char *s)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e422                	sd	s0,8(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf91                	beqz	a5,ee <strlen+0x26>
  d4:	0505                	addi	a0,a0,1
  d6:	87aa                	mv	a5,a0
  d8:	4685                	li	a3,1
  da:	9e89                	subw	a3,a3,a0
  dc:	00f6853b          	addw	a0,a3,a5
  e0:	0785                	addi	a5,a5,1
  e2:	fff7c703          	lbu	a4,-1(a5)
  e6:	fb7d                	bnez	a4,dc <strlen+0x14>
    ;
  return n;
}
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret
  for(n = 0; s[n]; n++)
  ee:	4501                	li	a0,0
  f0:	bfe5                	j	e8 <strlen+0x20>

00000000000000f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f8:	ce09                	beqz	a2,112 <memset+0x20>
  fa:	87aa                	mv	a5,a0
  fc:	fff6071b          	addiw	a4,a2,-1
 100:	1702                	slli	a4,a4,0x20
 102:	9301                	srli	a4,a4,0x20
 104:	0705                	addi	a4,a4,1
 106:	972a                	add	a4,a4,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x16>
  }
  return dst;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char*
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb99                	beqz	a5,138 <strchr+0x20>
    if(*s == c)
 124:	00f58763          	beq	a1,a5,132 <strchr+0x1a>
  for(; *s; s++)
 128:	0505                	addi	a0,a0,1
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbfd                	bnez	a5,124 <strchr+0xc>
      return (char*)s;
  return 0;
 130:	4501                	li	a0,0
}
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret
  return 0;
 138:	4501                	li	a0,0
 13a:	bfe5                	j	132 <strchr+0x1a>

000000000000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	711d                	addi	sp,sp,-96
 13e:	ec86                	sd	ra,88(sp)
 140:	e8a2                	sd	s0,80(sp)
 142:	e4a6                	sd	s1,72(sp)
 144:	e0ca                	sd	s2,64(sp)
 146:	fc4e                	sd	s3,56(sp)
 148:	f852                	sd	s4,48(sp)
 14a:	f456                	sd	s5,40(sp)
 14c:	f05a                	sd	s6,32(sp)
 14e:	ec5e                	sd	s7,24(sp)
 150:	1080                	addi	s0,sp,96
 152:	8baa                	mv	s7,a0
 154:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 156:	892a                	mv	s2,a0
 158:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15a:	4aa9                	li	s5,10
 15c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15e:	89a6                	mv	s3,s1
 160:	2485                	addiw	s1,s1,1
 162:	0344d663          	bge	s1,s4,18e <gets+0x52>
    cc = read(0, &c, 1);
 166:	4605                	li	a2,1
 168:	faf40593          	addi	a1,s0,-81
 16c:	4501                	li	a0,0
 16e:	1b8000ef          	jal	ra,326 <read>
    if(cc < 1)
 172:	00a05e63          	blez	a0,18e <gets+0x52>
    buf[i++] = c;
 176:	faf44783          	lbu	a5,-81(s0)
 17a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17e:	01578763          	beq	a5,s5,18c <gets+0x50>
 182:	0905                	addi	s2,s2,1
 184:	fd679de3          	bne	a5,s6,15e <gets+0x22>
  for(i=0; i+1 < max; ){
 188:	89a6                	mv	s3,s1
 18a:	a011                	j	18e <gets+0x52>
 18c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18e:	99de                	add	s3,s3,s7
 190:	00098023          	sb	zero,0(s3)
  return buf;
}
 194:	855e                	mv	a0,s7
 196:	60e6                	ld	ra,88(sp)
 198:	6446                	ld	s0,80(sp)
 19a:	64a6                	ld	s1,72(sp)
 19c:	6906                	ld	s2,64(sp)
 19e:	79e2                	ld	s3,56(sp)
 1a0:	7a42                	ld	s4,48(sp)
 1a2:	7aa2                	ld	s5,40(sp)
 1a4:	7b02                	ld	s6,32(sp)
 1a6:	6be2                	ld	s7,24(sp)
 1a8:	6125                	addi	sp,sp,96
 1aa:	8082                	ret

00000000000001ac <stat>:

int
stat(const char *n, struct stat *st)
{
 1ac:	1101                	addi	sp,sp,-32
 1ae:	ec06                	sd	ra,24(sp)
 1b0:	e822                	sd	s0,16(sp)
 1b2:	e426                	sd	s1,8(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	192000ef          	jal	ra,34e <open>
  if(fd < 0)
 1c0:	02054163          	bltz	a0,1e2 <stat+0x36>
 1c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c6:	85ca                	mv	a1,s2
 1c8:	19e000ef          	jal	ra,366 <fstat>
 1cc:	892a                	mv	s2,a0
  close(fd);
 1ce:	8526                	mv	a0,s1
 1d0:	166000ef          	jal	ra,336 <close>
  return r;
}
 1d4:	854a                	mv	a0,s2
 1d6:	60e2                	ld	ra,24(sp)
 1d8:	6442                	ld	s0,16(sp)
 1da:	64a2                	ld	s1,8(sp)
 1dc:	6902                	ld	s2,0(sp)
 1de:	6105                	addi	sp,sp,32
 1e0:	8082                	ret
    return -1;
 1e2:	597d                	li	s2,-1
 1e4:	bfc5                	j	1d4 <stat+0x28>

00000000000001e6 <atoi>:

int
atoi(const char *s)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ec:	00054603          	lbu	a2,0(a0)
 1f0:	fd06079b          	addiw	a5,a2,-48
 1f4:	0ff7f793          	andi	a5,a5,255
 1f8:	4725                	li	a4,9
 1fa:	02f76963          	bltu	a4,a5,22c <atoi+0x46>
 1fe:	86aa                	mv	a3,a0
  n = 0;
 200:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 202:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 204:	0685                	addi	a3,a3,1
 206:	0025179b          	slliw	a5,a0,0x2
 20a:	9fa9                	addw	a5,a5,a0
 20c:	0017979b          	slliw	a5,a5,0x1
 210:	9fb1                	addw	a5,a5,a2
 212:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 216:	0006c603          	lbu	a2,0(a3)
 21a:	fd06071b          	addiw	a4,a2,-48
 21e:	0ff77713          	andi	a4,a4,255
 222:	fee5f1e3          	bgeu	a1,a4,204 <atoi+0x1e>
  return n;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  n = 0;
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <atoi+0x40>

0000000000000230 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 236:	02b57663          	bgeu	a0,a1,262 <memmove+0x32>
    while(n-- > 0)
 23a:	02c05163          	blez	a2,25c <memmove+0x2c>
 23e:	fff6079b          	addiw	a5,a2,-1
 242:	1782                	slli	a5,a5,0x20
 244:	9381                	srli	a5,a5,0x20
 246:	0785                	addi	a5,a5,1
 248:	97aa                	add	a5,a5,a0
  dst = vdst;
 24a:	872a                	mv	a4,a0
      *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 258:	fee79ae3          	bne	a5,a4,24c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 268:	fec05ae3          	blez	a2,25c <memmove+0x2c>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x4a>
 28a:	bfc9                	j	25c <memmove+0x2c>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ac:	0505                	addi	a0,a0,1
    p2++;
 2ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
  }
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ce:	f63ff0ef          	jal	ra,230 <memmove>
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <sbrk>:

char *
sbrk(int n) {
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e2:	4585                	li	a1,1
 2e4:	0b2000ef          	jal	ra,396 <sys_sbrk>
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <sbrklazy>:

char *
sbrklazy(int n) {
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f8:	4589                	li	a1,2
 2fa:	09c000ef          	jal	ra,396 <sys_sbrk>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 306:	4885                	li	a7,1
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exit>:
.global exit
exit:
 li a7, SYS_exit
 30e:	4889                	li	a7,2
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <wait>:
.global wait
wait:
 li a7, SYS_wait
 316:	488d                	li	a7,3
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31e:	4891                	li	a7,4
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <read>:
.global read
read:
 li a7, SYS_read
 326:	4895                	li	a7,5
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <write>:
.global write
write:
 li a7, SYS_write
 32e:	48c1                	li	a7,16
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <close>:
.global close
close:
 li a7, SYS_close
 336:	48d5                	li	a7,21
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <kill>:
.global kill
kill:
 li a7, SYS_kill
 33e:	4899                	li	a7,6
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <exec>:
.global exec
exec:
 li a7, SYS_exec
 346:	489d                	li	a7,7
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <open>:
.global open
open:
 li a7, SYS_open
 34e:	48bd                	li	a7,15
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 356:	48c5                	li	a7,17
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35e:	48c9                	li	a7,18
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 366:	48a1                	li	a7,8
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <link>:
.global link
link:
 li a7, SYS_link
 36e:	48cd                	li	a7,19
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 376:	48d1                	li	a7,20
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37e:	48a5                	li	a7,9
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <dup>:
.global dup
dup:
 li a7, SYS_dup
 386:	48a9                	li	a7,10
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38e:	48ad                	li	a7,11
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 396:	48b1                	li	a7,12
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pause>:
.global pause
pause:
 li a7, SYS_pause
 39e:	48b5                	li	a7,13
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a6:	48b9                	li	a7,14
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 3ae:	48d9                	li	a7,22
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b6:	1101                	addi	sp,sp,-32
 3b8:	ec06                	sd	ra,24(sp)
 3ba:	e822                	sd	s0,16(sp)
 3bc:	1000                	addi	s0,sp,32
 3be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c2:	4605                	li	a2,1
 3c4:	fef40593          	addi	a1,s0,-17
 3c8:	f67ff0ef          	jal	ra,32e <write>
}
 3cc:	60e2                	ld	ra,24(sp)
 3ce:	6442                	ld	s0,16(sp)
 3d0:	6105                	addi	sp,sp,32
 3d2:	8082                	ret

00000000000003d4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d4:	715d                	addi	sp,sp,-80
 3d6:	e486                	sd	ra,72(sp)
 3d8:	e0a2                	sd	s0,64(sp)
 3da:	fc26                	sd	s1,56(sp)
 3dc:	f84a                	sd	s2,48(sp)
 3de:	f44e                	sd	s3,40(sp)
 3e0:	0880                	addi	s0,sp,80
 3e2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3e4:	c299                	beqz	a3,3ea <printint+0x16>
 3e6:	0805c163          	bltz	a1,468 <printint+0x94>
  neg = 0;
 3ea:	4881                	li	a7,0
 3ec:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3f0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3f2:	00000517          	auipc	a0,0x0
 3f6:	4f650513          	addi	a0,a0,1270 # 8e8 <digits>
 3fa:	883e                	mv	a6,a5
 3fc:	2785                	addiw	a5,a5,1
 3fe:	02c5f733          	remu	a4,a1,a2
 402:	972a                	add	a4,a4,a0
 404:	00074703          	lbu	a4,0(a4)
 408:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 40c:	872e                	mv	a4,a1
 40e:	02c5d5b3          	divu	a1,a1,a2
 412:	0685                	addi	a3,a3,1
 414:	fec773e3          	bgeu	a4,a2,3fa <printint+0x26>
  if(neg)
 418:	00088b63          	beqz	a7,42e <printint+0x5a>
    buf[i++] = '-';
 41c:	fd040713          	addi	a4,s0,-48
 420:	97ba                	add	a5,a5,a4
 422:	02d00713          	li	a4,45
 426:	fee78423          	sb	a4,-24(a5)
 42a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 42e:	02f05663          	blez	a5,45a <printint+0x86>
 432:	fb840713          	addi	a4,s0,-72
 436:	00f704b3          	add	s1,a4,a5
 43a:	fff70993          	addi	s3,a4,-1
 43e:	99be                	add	s3,s3,a5
 440:	37fd                	addiw	a5,a5,-1
 442:	1782                	slli	a5,a5,0x20
 444:	9381                	srli	a5,a5,0x20
 446:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 44a:	fff4c583          	lbu	a1,-1(s1)
 44e:	854a                	mv	a0,s2
 450:	f67ff0ef          	jal	ra,3b6 <putc>
  while(--i >= 0)
 454:	14fd                	addi	s1,s1,-1
 456:	ff349ae3          	bne	s1,s3,44a <printint+0x76>
}
 45a:	60a6                	ld	ra,72(sp)
 45c:	6406                	ld	s0,64(sp)
 45e:	74e2                	ld	s1,56(sp)
 460:	7942                	ld	s2,48(sp)
 462:	79a2                	ld	s3,40(sp)
 464:	6161                	addi	sp,sp,80
 466:	8082                	ret
    x = -xx;
 468:	40b005b3          	neg	a1,a1
    neg = 1;
 46c:	4885                	li	a7,1
    x = -xx;
 46e:	bfbd                	j	3ec <printint+0x18>

0000000000000470 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 470:	7119                	addi	sp,sp,-128
 472:	fc86                	sd	ra,120(sp)
 474:	f8a2                	sd	s0,112(sp)
 476:	f4a6                	sd	s1,104(sp)
 478:	f0ca                	sd	s2,96(sp)
 47a:	ecce                	sd	s3,88(sp)
 47c:	e8d2                	sd	s4,80(sp)
 47e:	e4d6                	sd	s5,72(sp)
 480:	e0da                	sd	s6,64(sp)
 482:	fc5e                	sd	s7,56(sp)
 484:	f862                	sd	s8,48(sp)
 486:	f466                	sd	s9,40(sp)
 488:	f06a                	sd	s10,32(sp)
 48a:	ec6e                	sd	s11,24(sp)
 48c:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48e:	0005c903          	lbu	s2,0(a1)
 492:	24090c63          	beqz	s2,6ea <vprintf+0x27a>
 496:	8b2a                	mv	s6,a0
 498:	8a2e                	mv	s4,a1
 49a:	8bb2                	mv	s7,a2
  state = 0;
 49c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 49e:	4481                	li	s1,0
 4a0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4a6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4aa:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ae:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4b2:	00000c97          	auipc	s9,0x0
 4b6:	436c8c93          	addi	s9,s9,1078 # 8e8 <digits>
 4ba:	a005                	j	4da <vprintf+0x6a>
        putc(fd, c0);
 4bc:	85ca                	mv	a1,s2
 4be:	855a                	mv	a0,s6
 4c0:	ef7ff0ef          	jal	ra,3b6 <putc>
 4c4:	a019                	j	4ca <vprintf+0x5a>
    } else if(state == '%'){
 4c6:	03598263          	beq	s3,s5,4ea <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ca:	2485                	addiw	s1,s1,1
 4cc:	8726                	mv	a4,s1
 4ce:	009a07b3          	add	a5,s4,s1
 4d2:	0007c903          	lbu	s2,0(a5)
 4d6:	20090a63          	beqz	s2,6ea <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 4da:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4de:	fe0994e3          	bnez	s3,4c6 <vprintf+0x56>
      if(c0 == '%'){
 4e2:	fd579de3          	bne	a5,s5,4bc <vprintf+0x4c>
        state = '%';
 4e6:	89be                	mv	s3,a5
 4e8:	b7cd                	j	4ca <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ea:	c3c1                	beqz	a5,56a <vprintf+0xfa>
 4ec:	00ea06b3          	add	a3,s4,a4
 4f0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4f4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4f6:	c681                	beqz	a3,4fe <vprintf+0x8e>
 4f8:	9752                	add	a4,a4,s4
 4fa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4fe:	03878e63          	beq	a5,s8,53a <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 502:	05a78863          	beq	a5,s10,552 <vprintf+0xe2>
      } else if(c0 == 'u'){
 506:	0db78b63          	beq	a5,s11,5dc <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 50a:	07800713          	li	a4,120
 50e:	10e78d63          	beq	a5,a4,628 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 512:	07000713          	li	a4,112
 516:	14e78263          	beq	a5,a4,65a <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 51a:	06300713          	li	a4,99
 51e:	16e78f63          	beq	a5,a4,69c <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 522:	07300713          	li	a4,115
 526:	18e78563          	beq	a5,a4,6b0 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 52a:	05579063          	bne	a5,s5,56a <vprintf+0xfa>
        putc(fd, '%');
 52e:	85d6                	mv	a1,s5
 530:	855a                	mv	a0,s6
 532:	e85ff0ef          	jal	ra,3b6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 536:	4981                	li	s3,0
 538:	bf49                	j	4ca <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 53a:	008b8913          	addi	s2,s7,8
 53e:	4685                	li	a3,1
 540:	4629                	li	a2,10
 542:	000ba583          	lw	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	e8dff0ef          	jal	ra,3d4 <printint>
 54c:	8bca                	mv	s7,s2
      state = 0;
 54e:	4981                	li	s3,0
 550:	bfad                	j	4ca <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 552:	03868663          	beq	a3,s8,57e <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 556:	05a68163          	beq	a3,s10,598 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 55a:	09b68d63          	beq	a3,s11,5f4 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 55e:	03a68f63          	beq	a3,s10,59c <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 562:	07800793          	li	a5,120
 566:	0cf68d63          	beq	a3,a5,640 <vprintf+0x1d0>
        putc(fd, '%');
 56a:	85d6                	mv	a1,s5
 56c:	855a                	mv	a0,s6
 56e:	e49ff0ef          	jal	ra,3b6 <putc>
        putc(fd, c0);
 572:	85ca                	mv	a1,s2
 574:	855a                	mv	a0,s6
 576:	e41ff0ef          	jal	ra,3b6 <putc>
      state = 0;
 57a:	4981                	li	s3,0
 57c:	b7b9                	j	4ca <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57e:	008b8913          	addi	s2,s7,8
 582:	4685                	li	a3,1
 584:	4629                	li	a2,10
 586:	000bb583          	ld	a1,0(s7)
 58a:	855a                	mv	a0,s6
 58c:	e49ff0ef          	jal	ra,3d4 <printint>
        i += 1;
 590:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
        i += 1;
 596:	bf15                	j	4ca <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 598:	03860563          	beq	a2,s8,5c2 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 59c:	07b60963          	beq	a2,s11,60e <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5a0:	07800793          	li	a5,120
 5a4:	fcf613e3          	bne	a2,a5,56a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4641                	li	a2,16
 5b0:	000bb583          	ld	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e1fff0ef          	jal	ra,3d4 <printint>
        i += 2;
 5ba:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5bc:	8bca                	mv	s7,s2
      state = 0;
 5be:	4981                	li	s3,0
        i += 2;
 5c0:	b729                	j	4ca <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4685                	li	a3,1
 5c8:	4629                	li	a2,10
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e05ff0ef          	jal	ra,3d4 <printint>
        i += 2;
 5d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
        i += 2;
 5da:	bdc5                	j	4ca <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000be583          	lwu	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	debff0ef          	jal	ra,3d4 <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bde1                	j	4ca <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4629                	li	a2,10
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	dd3ff0ef          	jal	ra,3d4 <printint>
        i += 1;
 606:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
        i += 1;
 60c:	bd7d                	j	4ca <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	008b8913          	addi	s2,s7,8
 612:	4681                	li	a3,0
 614:	4629                	li	a2,10
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	db9ff0ef          	jal	ra,3d4 <printint>
        i += 2;
 620:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
        i += 2;
 626:	b555                	j	4ca <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000be583          	lwu	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	d9fff0ef          	jal	ra,3d4 <printint>
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b571                	j	4ca <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 640:	008b8913          	addi	s2,s7,8
 644:	4681                	li	a3,0
 646:	4641                	li	a2,16
 648:	000bb583          	ld	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	d87ff0ef          	jal	ra,3d4 <printint>
        i += 1;
 652:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
        i += 1;
 658:	bd8d                	j	4ca <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 65a:	008b8793          	addi	a5,s7,8
 65e:	f8f43423          	sd	a5,-120(s0)
 662:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 666:	03000593          	li	a1,48
 66a:	855a                	mv	a0,s6
 66c:	d4bff0ef          	jal	ra,3b6 <putc>
  putc(fd, 'x');
 670:	07800593          	li	a1,120
 674:	855a                	mv	a0,s6
 676:	d41ff0ef          	jal	ra,3b6 <putc>
 67a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67c:	03c9d793          	srli	a5,s3,0x3c
 680:	97e6                	add	a5,a5,s9
 682:	0007c583          	lbu	a1,0(a5)
 686:	855a                	mv	a0,s6
 688:	d2fff0ef          	jal	ra,3b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68c:	0992                	slli	s3,s3,0x4
 68e:	397d                	addiw	s2,s2,-1
 690:	fe0916e3          	bnez	s2,67c <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 694:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 698:	4981                	li	s3,0
 69a:	bd05                	j	4ca <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 69c:	008b8913          	addi	s2,s7,8
 6a0:	000bc583          	lbu	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	d11ff0ef          	jal	ra,3b6 <putc>
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bd31                	j	4ca <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6b0:	008b8993          	addi	s3,s7,8
 6b4:	000bb903          	ld	s2,0(s7)
 6b8:	00090f63          	beqz	s2,6d6 <vprintf+0x266>
        for(; *s; s++)
 6bc:	00094583          	lbu	a1,0(s2)
 6c0:	c195                	beqz	a1,6e4 <vprintf+0x274>
          putc(fd, *s);
 6c2:	855a                	mv	a0,s6
 6c4:	cf3ff0ef          	jal	ra,3b6 <putc>
        for(; *s; s++)
 6c8:	0905                	addi	s2,s2,1
 6ca:	00094583          	lbu	a1,0(s2)
 6ce:	f9f5                	bnez	a1,6c2 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bbdd                	j	4ca <vprintf+0x5a>
          s = "(null)";
 6d6:	00000917          	auipc	s2,0x0
 6da:	20a90913          	addi	s2,s2,522 # 8e0 <malloc+0xf4>
        for(; *s; s++)
 6de:	02800593          	li	a1,40
 6e2:	b7c5                	j	6c2 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6e4:	8bce                	mv	s7,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b3cd                	j	4ca <vprintf+0x5a>
    }
  }
}
 6ea:	70e6                	ld	ra,120(sp)
 6ec:	7446                	ld	s0,112(sp)
 6ee:	74a6                	ld	s1,104(sp)
 6f0:	7906                	ld	s2,96(sp)
 6f2:	69e6                	ld	s3,88(sp)
 6f4:	6a46                	ld	s4,80(sp)
 6f6:	6aa6                	ld	s5,72(sp)
 6f8:	6b06                	ld	s6,64(sp)
 6fa:	7be2                	ld	s7,56(sp)
 6fc:	7c42                	ld	s8,48(sp)
 6fe:	7ca2                	ld	s9,40(sp)
 700:	7d02                	ld	s10,32(sp)
 702:	6de2                	ld	s11,24(sp)
 704:	6109                	addi	sp,sp,128
 706:	8082                	ret

0000000000000708 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 708:	715d                	addi	sp,sp,-80
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e010                	sd	a2,0(s0)
 712:	e414                	sd	a3,8(s0)
 714:	e818                	sd	a4,16(s0)
 716:	ec1c                	sd	a5,24(s0)
 718:	03043023          	sd	a6,32(s0)
 71c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 724:	8622                	mv	a2,s0
 726:	d4bff0ef          	jal	ra,470 <vprintf>
}
 72a:	60e2                	ld	ra,24(sp)
 72c:	6442                	ld	s0,16(sp)
 72e:	6161                	addi	sp,sp,80
 730:	8082                	ret

0000000000000732 <printf>:

void
printf(const char *fmt, ...)
{
 732:	711d                	addi	sp,sp,-96
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e40c                	sd	a1,8(s0)
 73c:	e810                	sd	a2,16(s0)
 73e:	ec14                	sd	a3,24(s0)
 740:	f018                	sd	a4,32(s0)
 742:	f41c                	sd	a5,40(s0)
 744:	03043823          	sd	a6,48(s0)
 748:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	00840613          	addi	a2,s0,8
 750:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 754:	85aa                	mv	a1,a0
 756:	4505                	li	a0,1
 758:	d19ff0ef          	jal	ra,470 <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6125                	addi	sp,sp,96
 762:	8082                	ret

0000000000000764 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 764:	1141                	addi	sp,sp,-16
 766:	e422                	sd	s0,8(sp)
 768:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76e:	00001797          	auipc	a5,0x1
 772:	8927b783          	ld	a5,-1902(a5) # 1000 <freep>
 776:	a805                	j	7a6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 778:	4618                	lw	a4,8(a2)
 77a:	9db9                	addw	a1,a1,a4
 77c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 780:	6398                	ld	a4,0(a5)
 782:	6318                	ld	a4,0(a4)
 784:	fee53823          	sd	a4,-16(a0)
 788:	a091                	j	7cc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78a:	ff852703          	lw	a4,-8(a0)
 78e:	9e39                	addw	a2,a2,a4
 790:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 792:	ff053703          	ld	a4,-16(a0)
 796:	e398                	sd	a4,0(a5)
 798:	a099                	j	7de <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	6398                	ld	a4,0(a5)
 79c:	00e7e463          	bltu	a5,a4,7a4 <free+0x40>
 7a0:	00e6ea63          	bltu	a3,a4,7b4 <free+0x50>
{
 7a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	fed7fae3          	bgeu	a5,a3,79a <free+0x36>
 7aa:	6398                	ld	a4,0(a5)
 7ac:	00e6e463          	bltu	a3,a4,7b4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	fee7eae3          	bltu	a5,a4,7a4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7b4:	ff852583          	lw	a1,-8(a0)
 7b8:	6390                	ld	a2,0(a5)
 7ba:	02059713          	slli	a4,a1,0x20
 7be:	9301                	srli	a4,a4,0x20
 7c0:	0712                	slli	a4,a4,0x4
 7c2:	9736                	add	a4,a4,a3
 7c4:	fae60ae3          	beq	a2,a4,778 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7cc:	4790                	lw	a2,8(a5)
 7ce:	02061713          	slli	a4,a2,0x20
 7d2:	9301                	srli	a4,a4,0x20
 7d4:	0712                	slli	a4,a4,0x4
 7d6:	973e                	add	a4,a4,a5
 7d8:	fae689e3          	beq	a3,a4,78a <free+0x26>
  } else
    p->s.ptr = bp;
 7dc:	e394                	sd	a3,0(a5)
  freep = p;
 7de:	00001717          	auipc	a4,0x1
 7e2:	82f73123          	sd	a5,-2014(a4) # 1000 <freep>
}
 7e6:	6422                	ld	s0,8(sp)
 7e8:	0141                	addi	sp,sp,16
 7ea:	8082                	ret

00000000000007ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ec:	7139                	addi	sp,sp,-64
 7ee:	fc06                	sd	ra,56(sp)
 7f0:	f822                	sd	s0,48(sp)
 7f2:	f426                	sd	s1,40(sp)
 7f4:	f04a                	sd	s2,32(sp)
 7f6:	ec4e                	sd	s3,24(sp)
 7f8:	e852                	sd	s4,16(sp)
 7fa:	e456                	sd	s5,8(sp)
 7fc:	e05a                	sd	s6,0(sp)
 7fe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 800:	02051493          	slli	s1,a0,0x20
 804:	9081                	srli	s1,s1,0x20
 806:	04bd                	addi	s1,s1,15
 808:	8091                	srli	s1,s1,0x4
 80a:	0014899b          	addiw	s3,s1,1
 80e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 810:	00000517          	auipc	a0,0x0
 814:	7f053503          	ld	a0,2032(a0) # 1000 <freep>
 818:	c515                	beqz	a0,844 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81c:	4798                	lw	a4,8(a5)
 81e:	02977f63          	bgeu	a4,s1,85c <malloc+0x70>
 822:	8a4e                	mv	s4,s3
 824:	0009871b          	sext.w	a4,s3
 828:	6685                	lui	a3,0x1
 82a:	00d77363          	bgeu	a4,a3,830 <malloc+0x44>
 82e:	6a05                	lui	s4,0x1
 830:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 834:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 838:	00000917          	auipc	s2,0x0
 83c:	7c890913          	addi	s2,s2,1992 # 1000 <freep>
  if(p == SBRK_ERROR)
 840:	5afd                	li	s5,-1
 842:	a0bd                	j	8b0 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 844:	00000797          	auipc	a5,0x0
 848:	7cc78793          	addi	a5,a5,1996 # 1010 <base>
 84c:	00000717          	auipc	a4,0x0
 850:	7af73a23          	sd	a5,1972(a4) # 1000 <freep>
 854:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 856:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85a:	b7e1                	j	822 <malloc+0x36>
      if(p->s.size == nunits)
 85c:	02e48b63          	beq	s1,a4,892 <malloc+0xa6>
        p->s.size -= nunits;
 860:	4137073b          	subw	a4,a4,s3
 864:	c798                	sw	a4,8(a5)
        p += p->s.size;
 866:	1702                	slli	a4,a4,0x20
 868:	9301                	srli	a4,a4,0x20
 86a:	0712                	slli	a4,a4,0x4
 86c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 872:	00000717          	auipc	a4,0x0
 876:	78a73723          	sd	a0,1934(a4) # 1000 <freep>
      return (void*)(p + 1);
 87a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 87e:	70e2                	ld	ra,56(sp)
 880:	7442                	ld	s0,48(sp)
 882:	74a2                	ld	s1,40(sp)
 884:	7902                	ld	s2,32(sp)
 886:	69e2                	ld	s3,24(sp)
 888:	6a42                	ld	s4,16(sp)
 88a:	6aa2                	ld	s5,8(sp)
 88c:	6b02                	ld	s6,0(sp)
 88e:	6121                	addi	sp,sp,64
 890:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 892:	6398                	ld	a4,0(a5)
 894:	e118                	sd	a4,0(a0)
 896:	bff1                	j	872 <malloc+0x86>
  hp->s.size = nu;
 898:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89c:	0541                	addi	a0,a0,16
 89e:	ec7ff0ef          	jal	ra,764 <free>
  return freep;
 8a2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a6:	dd61                	beqz	a0,87e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8aa:	4798                	lw	a4,8(a5)
 8ac:	fa9778e3          	bgeu	a4,s1,85c <malloc+0x70>
    if(p == freep)
 8b0:	00093703          	ld	a4,0(s2)
 8b4:	853e                	mv	a0,a5
 8b6:	fef719e3          	bne	a4,a5,8a8 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8ba:	8552                	mv	a0,s4
 8bc:	a1fff0ef          	jal	ra,2da <sbrk>
  if(p == SBRK_ERROR)
 8c0:	fd551ce3          	bne	a0,s5,898 <malloc+0xac>
        return 0;
 8c4:	4501                	li	a0,0
 8c6:	bf65                	j	87e <malloc+0x92>
