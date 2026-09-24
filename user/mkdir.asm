
user/_mkdir:     file format elf64-littleriscv


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
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d563          	bge	a5,a0,3a <main+0x3a>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	340000ef          	jal	ra,36a <mkdir>
  2e:	02054063          	bltz	a0,4e <main+0x4e>
  for(i = 1; i < argc; i++){
  32:	04a1                	addi	s1,s1,8
  34:	ff249ae3          	bne	s1,s2,28 <main+0x28>
  38:	a01d                	j	5e <main+0x5e>
    fprintf(2, "Usage: mkdir files...\n");
  3a:	00001597          	auipc	a1,0x1
  3e:	88658593          	addi	a1,a1,-1914 # 8c0 <malloc+0xe0>
  42:	4509                	li	a0,2
  44:	6b8000ef          	jal	ra,6fc <fprintf>
    exit(1);
  48:	4505                	li	a0,1
  4a:	2b8000ef          	jal	ra,302 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  4e:	6090                	ld	a2,0(s1)
  50:	00001597          	auipc	a1,0x1
  54:	88858593          	addi	a1,a1,-1912 # 8d8 <malloc+0xf8>
  58:	4509                	li	a0,2
  5a:	6a2000ef          	jal	ra,6fc <fprintf>
      break;
    }
  }

  exit(0);
  5e:	4501                	li	a0,0
  60:	2a2000ef          	jal	ra,302 <exit>

0000000000000064 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  6c:	f95ff0ef          	jal	ra,0 <main>
  exit(r);
  70:	292000ef          	jal	ra,302 <exit>

0000000000000074 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  74:	1141                	addi	sp,sp,-16
  76:	e422                	sd	s0,8(sp)
  78:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	87aa                	mv	a5,a0
  7c:	0585                	addi	a1,a1,1
  7e:	0785                	addi	a5,a5,1
  80:	fff5c703          	lbu	a4,-1(a1)
  84:	fee78fa3          	sb	a4,-1(a5)
  88:	fb75                	bnez	a4,7c <strcpy+0x8>
    ;
  return os;
}
  8a:	6422                	ld	s0,8(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret

0000000000000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	1141                	addi	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	cb91                	beqz	a5,ae <strcmp+0x1e>
  9c:	0005c703          	lbu	a4,0(a1)
  a0:	00f71763          	bne	a4,a5,ae <strcmp+0x1e>
    p++, q++;
  a4:	0505                	addi	a0,a0,1
  a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	fbe5                	bnez	a5,9c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ae:	0005c503          	lbu	a0,0(a1)
}
  b2:	40a7853b          	subw	a0,a5,a0
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cf91                	beqz	a5,e2 <strlen+0x26>
  c8:	0505                	addi	a0,a0,1
  ca:	87aa                	mv	a5,a0
  cc:	4685                	li	a3,1
  ce:	9e89                	subw	a3,a3,a0
  d0:	00f6853b          	addw	a0,a3,a5
  d4:	0785                	addi	a5,a5,1
  d6:	fff7c703          	lbu	a4,-1(a5)
  da:	fb7d                	bnez	a4,d0 <strlen+0x14>
    ;
  return n;
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  for(n = 0; s[n]; n++)
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strlen+0x20>

00000000000000e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ec:	ce09                	beqz	a2,106 <memset+0x20>
  ee:	87aa                	mv	a5,a0
  f0:	fff6071b          	addiw	a4,a2,-1
  f4:	1702                	slli	a4,a4,0x20
  f6:	9301                	srli	a4,a4,0x20
  f8:	0705                	addi	a4,a4,1
  fa:	972a                	add	a4,a4,a0
    cdst[i] = c;
  fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 100:	0785                	addi	a5,a5,1
 102:	fee79de3          	bne	a5,a4,fc <memset+0x16>
  }
  return dst;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  for(; *s; s++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cb99                	beqz	a5,12c <strchr+0x20>
    if(*s == c)
 118:	00f58763          	beq	a1,a5,126 <strchr+0x1a>
  for(; *s; s++)
 11c:	0505                	addi	a0,a0,1
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbfd                	bnez	a5,118 <strchr+0xc>
      return (char*)s;
  return 0;
 124:	4501                	li	a0,0
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strchr+0x1a>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	1080                	addi	s0,sp,96
 146:	8baa                	mv	s7,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14e:	4aa9                	li	s5,10
 150:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 152:	89a6                	mv	s3,s1
 154:	2485                	addiw	s1,s1,1
 156:	0344d663          	bge	s1,s4,182 <gets+0x52>
    cc = read(0, &c, 1);
 15a:	4605                	li	a2,1
 15c:	faf40593          	addi	a1,s0,-81
 160:	4501                	li	a0,0
 162:	1b8000ef          	jal	ra,31a <read>
    if(cc < 1)
 166:	00a05e63          	blez	a0,182 <gets+0x52>
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 172:	01578763          	beq	a5,s5,180 <gets+0x50>
 176:	0905                	addi	s2,s2,1
 178:	fd679de3          	bne	a5,s6,152 <gets+0x22>
  for(i=0; i+1 < max; ){
 17c:	89a6                	mv	s3,s1
 17e:	a011                	j	182 <gets+0x52>
 180:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 182:	99de                	add	s3,s3,s7
 184:	00098023          	sb	zero,0(s3)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6125                	addi	sp,sp,96
 19e:	8082                	ret

00000000000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	1101                	addi	sp,sp,-32
 1a2:	ec06                	sd	ra,24(sp)
 1a4:	e822                	sd	s0,16(sp)
 1a6:	e426                	sd	s1,8(sp)
 1a8:	e04a                	sd	s2,0(sp)
 1aa:	1000                	addi	s0,sp,32
 1ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	4581                	li	a1,0
 1b0:	192000ef          	jal	ra,342 <open>
  if(fd < 0)
 1b4:	02054163          	bltz	a0,1d6 <stat+0x36>
 1b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ba:	85ca                	mv	a1,s2
 1bc:	19e000ef          	jal	ra,35a <fstat>
 1c0:	892a                	mv	s2,a0
  close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	166000ef          	jal	ra,32a <close>
  return r;
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	64a2                	ld	s1,8(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
    return -1;
 1d6:	597d                	li	s2,-1
 1d8:	bfc5                	j	1c8 <stat+0x28>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e0:	00054603          	lbu	a2,0(a0)
 1e4:	fd06079b          	addiw	a5,a2,-48
 1e8:	0ff7f793          	andi	a5,a5,255
 1ec:	4725                	li	a4,9
 1ee:	02f76963          	bltu	a4,a5,220 <atoi+0x46>
 1f2:	86aa                	mv	a3,a0
  n = 0;
 1f4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1f6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1f8:	0685                	addi	a3,a3,1
 1fa:	0025179b          	slliw	a5,a0,0x2
 1fe:	9fa9                	addw	a5,a5,a0
 200:	0017979b          	slliw	a5,a5,0x1
 204:	9fb1                	addw	a5,a5,a2
 206:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20a:	0006c603          	lbu	a2,0(a3)
 20e:	fd06071b          	addiw	a4,a2,-48
 212:	0ff77713          	andi	a4,a4,255
 216:	fee5f1e3          	bgeu	a1,a4,1f8 <atoi+0x1e>
  return n;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
  n = 0;
 220:	4501                	li	a0,0
 222:	bfe5                	j	21a <atoi+0x40>

0000000000000224 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 22a:	02b57663          	bgeu	a0,a1,256 <memmove+0x32>
    while(n-- > 0)
 22e:	02c05163          	blez	a2,250 <memmove+0x2c>
 232:	fff6079b          	addiw	a5,a2,-1
 236:	1782                	slli	a5,a5,0x20
 238:	9381                	srli	a5,a5,0x20
 23a:	0785                	addi	a5,a5,1
 23c:	97aa                	add	a5,a5,a0
  dst = vdst;
 23e:	872a                	mv	a4,a0
      *dst++ = *src++;
 240:	0585                	addi	a1,a1,1
 242:	0705                	addi	a4,a4,1
 244:	fff5c683          	lbu	a3,-1(a1)
 248:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24c:	fee79ae3          	bne	a5,a4,240 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 250:	6422                	ld	s0,8(sp)
 252:	0141                	addi	sp,sp,16
 254:	8082                	ret
    dst += n;
 256:	00c50733          	add	a4,a0,a2
    src += n;
 25a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 25c:	fec05ae3          	blez	a2,250 <memmove+0x2c>
 260:	fff6079b          	addiw	a5,a2,-1
 264:	1782                	slli	a5,a5,0x20
 266:	9381                	srli	a5,a5,0x20
 268:	fff7c793          	not	a5,a5
 26c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 26e:	15fd                	addi	a1,a1,-1
 270:	177d                	addi	a4,a4,-1
 272:	0005c683          	lbu	a3,0(a1)
 276:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27a:	fee79ae3          	bne	a5,a4,26e <memmove+0x4a>
 27e:	bfc9                	j	250 <memmove+0x2c>

0000000000000280 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e422                	sd	s0,8(sp)
 284:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 286:	ca05                	beqz	a2,2b6 <memcmp+0x36>
 288:	fff6069b          	addiw	a3,a2,-1
 28c:	1682                	slli	a3,a3,0x20
 28e:	9281                	srli	a3,a3,0x20
 290:	0685                	addi	a3,a3,1
 292:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 294:	00054783          	lbu	a5,0(a0)
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00e79863          	bne	a5,a4,2ac <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a0:	0505                	addi	a0,a0,1
    p2++;
 2a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a4:	fed518e3          	bne	a0,a3,294 <memcmp+0x14>
  }
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	a019                	j	2b0 <memcmp+0x30>
      return *p1 - *p2;
 2ac:	40e7853b          	subw	a0,a5,a4
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	bfe5                	j	2b0 <memcmp+0x30>

00000000000002ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c2:	f63ff0ef          	jal	ra,224 <memmove>
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <sbrk>:

char *
sbrk(int n) {
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d6:	4585                	li	a1,1
 2d8:	0b2000ef          	jal	ra,38a <sys_sbrk>
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <sbrklazy>:

char *
sbrklazy(int n) {
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ec:	4589                	li	a1,2
 2ee:	09c000ef          	jal	ra,38a <sys_sbrk>
}
 2f2:	60a2                	ld	ra,8(sp)
 2f4:	6402                	ld	s0,0(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fa:	4885                	li	a7,1
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <exit>:
.global exit
exit:
 li a7, SYS_exit
 302:	4889                	li	a7,2
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <wait>:
.global wait
wait:
 li a7, SYS_wait
 30a:	488d                	li	a7,3
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 312:	4891                	li	a7,4
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <read>:
.global read
read:
 li a7, SYS_read
 31a:	4895                	li	a7,5
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <write>:
.global write
write:
 li a7, SYS_write
 322:	48c1                	li	a7,16
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <close>:
.global close
close:
 li a7, SYS_close
 32a:	48d5                	li	a7,21
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <kill>:
.global kill
kill:
 li a7, SYS_kill
 332:	4899                	li	a7,6
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <exec>:
.global exec
exec:
 li a7, SYS_exec
 33a:	489d                	li	a7,7
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <open>:
.global open
open:
 li a7, SYS_open
 342:	48bd                	li	a7,15
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34a:	48c5                	li	a7,17
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 352:	48c9                	li	a7,18
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35a:	48a1                	li	a7,8
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <link>:
.global link
link:
 li a7, SYS_link
 362:	48cd                	li	a7,19
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36a:	48d1                	li	a7,20
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 372:	48a5                	li	a7,9
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <dup>:
.global dup
dup:
 li a7, SYS_dup
 37a:	48a9                	li	a7,10
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 382:	48ad                	li	a7,11
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38a:	48b1                	li	a7,12
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <pause>:
.global pause
pause:
 li a7, SYS_pause
 392:	48b5                	li	a7,13
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39a:	48b9                	li	a7,14
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 3a2:	48d9                	li	a7,22
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3aa:	1101                	addi	sp,sp,-32
 3ac:	ec06                	sd	ra,24(sp)
 3ae:	e822                	sd	s0,16(sp)
 3b0:	1000                	addi	s0,sp,32
 3b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b6:	4605                	li	a2,1
 3b8:	fef40593          	addi	a1,s0,-17
 3bc:	f67ff0ef          	jal	ra,322 <write>
}
 3c0:	60e2                	ld	ra,24(sp)
 3c2:	6442                	ld	s0,16(sp)
 3c4:	6105                	addi	sp,sp,32
 3c6:	8082                	ret

00000000000003c8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3c8:	715d                	addi	sp,sp,-80
 3ca:	e486                	sd	ra,72(sp)
 3cc:	e0a2                	sd	s0,64(sp)
 3ce:	fc26                	sd	s1,56(sp)
 3d0:	f84a                	sd	s2,48(sp)
 3d2:	f44e                	sd	s3,40(sp)
 3d4:	0880                	addi	s0,sp,80
 3d6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3d8:	c299                	beqz	a3,3de <printint+0x16>
 3da:	0805c163          	bltz	a1,45c <printint+0x94>
  neg = 0;
 3de:	4881                	li	a7,0
 3e0:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3e4:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3e6:	00000517          	auipc	a0,0x0
 3ea:	51a50513          	addi	a0,a0,1306 # 900 <digits>
 3ee:	883e                	mv	a6,a5
 3f0:	2785                	addiw	a5,a5,1
 3f2:	02c5f733          	remu	a4,a1,a2
 3f6:	972a                	add	a4,a4,a0
 3f8:	00074703          	lbu	a4,0(a4)
 3fc:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 400:	872e                	mv	a4,a1
 402:	02c5d5b3          	divu	a1,a1,a2
 406:	0685                	addi	a3,a3,1
 408:	fec773e3          	bgeu	a4,a2,3ee <printint+0x26>
  if(neg)
 40c:	00088b63          	beqz	a7,422 <printint+0x5a>
    buf[i++] = '-';
 410:	fd040713          	addi	a4,s0,-48
 414:	97ba                	add	a5,a5,a4
 416:	02d00713          	li	a4,45
 41a:	fee78423          	sb	a4,-24(a5)
 41e:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 422:	02f05663          	blez	a5,44e <printint+0x86>
 426:	fb840713          	addi	a4,s0,-72
 42a:	00f704b3          	add	s1,a4,a5
 42e:	fff70993          	addi	s3,a4,-1
 432:	99be                	add	s3,s3,a5
 434:	37fd                	addiw	a5,a5,-1
 436:	1782                	slli	a5,a5,0x20
 438:	9381                	srli	a5,a5,0x20
 43a:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 43e:	fff4c583          	lbu	a1,-1(s1)
 442:	854a                	mv	a0,s2
 444:	f67ff0ef          	jal	ra,3aa <putc>
  while(--i >= 0)
 448:	14fd                	addi	s1,s1,-1
 44a:	ff349ae3          	bne	s1,s3,43e <printint+0x76>
}
 44e:	60a6                	ld	ra,72(sp)
 450:	6406                	ld	s0,64(sp)
 452:	74e2                	ld	s1,56(sp)
 454:	7942                	ld	s2,48(sp)
 456:	79a2                	ld	s3,40(sp)
 458:	6161                	addi	sp,sp,80
 45a:	8082                	ret
    x = -xx;
 45c:	40b005b3          	neg	a1,a1
    neg = 1;
 460:	4885                	li	a7,1
    x = -xx;
 462:	bfbd                	j	3e0 <printint+0x18>

0000000000000464 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 464:	7119                	addi	sp,sp,-128
 466:	fc86                	sd	ra,120(sp)
 468:	f8a2                	sd	s0,112(sp)
 46a:	f4a6                	sd	s1,104(sp)
 46c:	f0ca                	sd	s2,96(sp)
 46e:	ecce                	sd	s3,88(sp)
 470:	e8d2                	sd	s4,80(sp)
 472:	e4d6                	sd	s5,72(sp)
 474:	e0da                	sd	s6,64(sp)
 476:	fc5e                	sd	s7,56(sp)
 478:	f862                	sd	s8,48(sp)
 47a:	f466                	sd	s9,40(sp)
 47c:	f06a                	sd	s10,32(sp)
 47e:	ec6e                	sd	s11,24(sp)
 480:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 482:	0005c903          	lbu	s2,0(a1)
 486:	24090c63          	beqz	s2,6de <vprintf+0x27a>
 48a:	8b2a                	mv	s6,a0
 48c:	8a2e                	mv	s4,a1
 48e:	8bb2                	mv	s7,a2
  state = 0;
 490:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 492:	4481                	li	s1,0
 494:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 496:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 49a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 49e:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4a2:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4a6:	00000c97          	auipc	s9,0x0
 4aa:	45ac8c93          	addi	s9,s9,1114 # 900 <digits>
 4ae:	a005                	j	4ce <vprintf+0x6a>
        putc(fd, c0);
 4b0:	85ca                	mv	a1,s2
 4b2:	855a                	mv	a0,s6
 4b4:	ef7ff0ef          	jal	ra,3aa <putc>
 4b8:	a019                	j	4be <vprintf+0x5a>
    } else if(state == '%'){
 4ba:	03598263          	beq	s3,s5,4de <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4be:	2485                	addiw	s1,s1,1
 4c0:	8726                	mv	a4,s1
 4c2:	009a07b3          	add	a5,s4,s1
 4c6:	0007c903          	lbu	s2,0(a5)
 4ca:	20090a63          	beqz	s2,6de <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 4ce:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4d2:	fe0994e3          	bnez	s3,4ba <vprintf+0x56>
      if(c0 == '%'){
 4d6:	fd579de3          	bne	a5,s5,4b0 <vprintf+0x4c>
        state = '%';
 4da:	89be                	mv	s3,a5
 4dc:	b7cd                	j	4be <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4de:	c3c1                	beqz	a5,55e <vprintf+0xfa>
 4e0:	00ea06b3          	add	a3,s4,a4
 4e4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4e8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ea:	c681                	beqz	a3,4f2 <vprintf+0x8e>
 4ec:	9752                	add	a4,a4,s4
 4ee:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4f2:	03878e63          	beq	a5,s8,52e <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 4f6:	05a78863          	beq	a5,s10,546 <vprintf+0xe2>
      } else if(c0 == 'u'){
 4fa:	0db78b63          	beq	a5,s11,5d0 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4fe:	07800713          	li	a4,120
 502:	10e78d63          	beq	a5,a4,61c <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 506:	07000713          	li	a4,112
 50a:	14e78263          	beq	a5,a4,64e <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 50e:	06300713          	li	a4,99
 512:	16e78f63          	beq	a5,a4,690 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 516:	07300713          	li	a4,115
 51a:	18e78563          	beq	a5,a4,6a4 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 51e:	05579063          	bne	a5,s5,55e <vprintf+0xfa>
        putc(fd, '%');
 522:	85d6                	mv	a1,s5
 524:	855a                	mv	a0,s6
 526:	e85ff0ef          	jal	ra,3aa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 52a:	4981                	li	s3,0
 52c:	bf49                	j	4be <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 52e:	008b8913          	addi	s2,s7,8
 532:	4685                	li	a3,1
 534:	4629                	li	a2,10
 536:	000ba583          	lw	a1,0(s7)
 53a:	855a                	mv	a0,s6
 53c:	e8dff0ef          	jal	ra,3c8 <printint>
 540:	8bca                	mv	s7,s2
      state = 0;
 542:	4981                	li	s3,0
 544:	bfad                	j	4be <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 546:	03868663          	beq	a3,s8,572 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 54a:	05a68163          	beq	a3,s10,58c <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 54e:	09b68d63          	beq	a3,s11,5e8 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 552:	03a68f63          	beq	a3,s10,590 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 556:	07800793          	li	a5,120
 55a:	0cf68d63          	beq	a3,a5,634 <vprintf+0x1d0>
        putc(fd, '%');
 55e:	85d6                	mv	a1,s5
 560:	855a                	mv	a0,s6
 562:	e49ff0ef          	jal	ra,3aa <putc>
        putc(fd, c0);
 566:	85ca                	mv	a1,s2
 568:	855a                	mv	a0,s6
 56a:	e41ff0ef          	jal	ra,3aa <putc>
      state = 0;
 56e:	4981                	li	s3,0
 570:	b7b9                	j	4be <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 572:	008b8913          	addi	s2,s7,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000bb583          	ld	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e49ff0ef          	jal	ra,3c8 <printint>
        i += 1;
 584:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	8bca                	mv	s7,s2
      state = 0;
 588:	4981                	li	s3,0
        i += 1;
 58a:	bf15                	j	4be <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 58c:	03860563          	beq	a2,s8,5b6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 590:	07b60963          	beq	a2,s11,602 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 594:	07800793          	li	a5,120
 598:	fcf613e3          	bne	a2,a5,55e <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 59c:	008b8913          	addi	s2,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4641                	li	a2,16
 5a4:	000bb583          	ld	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e1fff0ef          	jal	ra,3c8 <printint>
        i += 2;
 5ae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
        i += 2;
 5b4:	b729                	j	4be <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e05ff0ef          	jal	ra,3c8 <printint>
        i += 2;
 5c8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
        i += 2;
 5ce:	bdc5                	j	4be <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000be583          	lwu	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	debff0ef          	jal	ra,3c8 <printint>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bde1                	j	4be <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000bb583          	ld	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	dd3ff0ef          	jal	ra,3c8 <printint>
        i += 1;
 5fa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
        i += 1;
 600:	bd7d                	j	4be <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	008b8913          	addi	s2,s7,8
 606:	4681                	li	a3,0
 608:	4629                	li	a2,10
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	db9ff0ef          	jal	ra,3c8 <printint>
        i += 2;
 614:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	b555                	j	4be <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 61c:	008b8913          	addi	s2,s7,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000be583          	lwu	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	d9fff0ef          	jal	ra,3c8 <printint>
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	b571                	j	4be <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	008b8913          	addi	s2,s7,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000bb583          	ld	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	d87ff0ef          	jal	ra,3c8 <printint>
        i += 1;
 646:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
        i += 1;
 64c:	bd8d                	j	4be <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 64e:	008b8793          	addi	a5,s7,8
 652:	f8f43423          	sd	a5,-120(s0)
 656:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 65a:	03000593          	li	a1,48
 65e:	855a                	mv	a0,s6
 660:	d4bff0ef          	jal	ra,3aa <putc>
  putc(fd, 'x');
 664:	07800593          	li	a1,120
 668:	855a                	mv	a0,s6
 66a:	d41ff0ef          	jal	ra,3aa <putc>
 66e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 670:	03c9d793          	srli	a5,s3,0x3c
 674:	97e6                	add	a5,a5,s9
 676:	0007c583          	lbu	a1,0(a5)
 67a:	855a                	mv	a0,s6
 67c:	d2fff0ef          	jal	ra,3aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 680:	0992                	slli	s3,s3,0x4
 682:	397d                	addiw	s2,s2,-1
 684:	fe0916e3          	bnez	s2,670 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 688:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bd05                	j	4be <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 690:	008b8913          	addi	s2,s7,8
 694:	000bc583          	lbu	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	d11ff0ef          	jal	ra,3aa <putc>
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bd31                	j	4be <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6a4:	008b8993          	addi	s3,s7,8
 6a8:	000bb903          	ld	s2,0(s7)
 6ac:	00090f63          	beqz	s2,6ca <vprintf+0x266>
        for(; *s; s++)
 6b0:	00094583          	lbu	a1,0(s2)
 6b4:	c195                	beqz	a1,6d8 <vprintf+0x274>
          putc(fd, *s);
 6b6:	855a                	mv	a0,s6
 6b8:	cf3ff0ef          	jal	ra,3aa <putc>
        for(; *s; s++)
 6bc:	0905                	addi	s2,s2,1
 6be:	00094583          	lbu	a1,0(s2)
 6c2:	f9f5                	bnez	a1,6b6 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6c4:	8bce                	mv	s7,s3
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bbdd                	j	4be <vprintf+0x5a>
          s = "(null)";
 6ca:	00000917          	auipc	s2,0x0
 6ce:	22e90913          	addi	s2,s2,558 # 8f8 <malloc+0x118>
        for(; *s; s++)
 6d2:	02800593          	li	a1,40
 6d6:	b7c5                	j	6b6 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6d8:	8bce                	mv	s7,s3
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b3cd                	j	4be <vprintf+0x5a>
    }
  }
}
 6de:	70e6                	ld	ra,120(sp)
 6e0:	7446                	ld	s0,112(sp)
 6e2:	74a6                	ld	s1,104(sp)
 6e4:	7906                	ld	s2,96(sp)
 6e6:	69e6                	ld	s3,88(sp)
 6e8:	6a46                	ld	s4,80(sp)
 6ea:	6aa6                	ld	s5,72(sp)
 6ec:	6b06                	ld	s6,64(sp)
 6ee:	7be2                	ld	s7,56(sp)
 6f0:	7c42                	ld	s8,48(sp)
 6f2:	7ca2                	ld	s9,40(sp)
 6f4:	7d02                	ld	s10,32(sp)
 6f6:	6de2                	ld	s11,24(sp)
 6f8:	6109                	addi	sp,sp,128
 6fa:	8082                	ret

00000000000006fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6fc:	715d                	addi	sp,sp,-80
 6fe:	ec06                	sd	ra,24(sp)
 700:	e822                	sd	s0,16(sp)
 702:	1000                	addi	s0,sp,32
 704:	e010                	sd	a2,0(s0)
 706:	e414                	sd	a3,8(s0)
 708:	e818                	sd	a4,16(s0)
 70a:	ec1c                	sd	a5,24(s0)
 70c:	03043023          	sd	a6,32(s0)
 710:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 714:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 718:	8622                	mv	a2,s0
 71a:	d4bff0ef          	jal	ra,464 <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6161                	addi	sp,sp,80
 724:	8082                	ret

0000000000000726 <printf>:

void
printf(const char *fmt, ...)
{
 726:	711d                	addi	sp,sp,-96
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e40c                	sd	a1,8(s0)
 730:	e810                	sd	a2,16(s0)
 732:	ec14                	sd	a3,24(s0)
 734:	f018                	sd	a4,32(s0)
 736:	f41c                	sd	a5,40(s0)
 738:	03043823          	sd	a6,48(s0)
 73c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 740:	00840613          	addi	a2,s0,8
 744:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 748:	85aa                	mv	a1,a0
 74a:	4505                	li	a0,1
 74c:	d19ff0ef          	jal	ra,464 <vprintf>
}
 750:	60e2                	ld	ra,24(sp)
 752:	6442                	ld	s0,16(sp)
 754:	6125                	addi	sp,sp,96
 756:	8082                	ret

0000000000000758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	1141                	addi	sp,sp,-16
 75a:	e422                	sd	s0,8(sp)
 75c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	00001797          	auipc	a5,0x1
 766:	89e7b783          	ld	a5,-1890(a5) # 1000 <freep>
 76a:	a805                	j	79a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 76c:	4618                	lw	a4,8(a2)
 76e:	9db9                	addw	a1,a1,a4
 770:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 774:	6398                	ld	a4,0(a5)
 776:	6318                	ld	a4,0(a4)
 778:	fee53823          	sd	a4,-16(a0)
 77c:	a091                	j	7c0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 77e:	ff852703          	lw	a4,-8(a0)
 782:	9e39                	addw	a2,a2,a4
 784:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 786:	ff053703          	ld	a4,-16(a0)
 78a:	e398                	sd	a4,0(a5)
 78c:	a099                	j	7d2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78e:	6398                	ld	a4,0(a5)
 790:	00e7e463          	bltu	a5,a4,798 <free+0x40>
 794:	00e6ea63          	bltu	a3,a4,7a8 <free+0x50>
{
 798:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79a:	fed7fae3          	bgeu	a5,a3,78e <free+0x36>
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e6e463          	bltu	a3,a4,7a8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	fee7eae3          	bltu	a5,a4,798 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7a8:	ff852583          	lw	a1,-8(a0)
 7ac:	6390                	ld	a2,0(a5)
 7ae:	02059713          	slli	a4,a1,0x20
 7b2:	9301                	srli	a4,a4,0x20
 7b4:	0712                	slli	a4,a4,0x4
 7b6:	9736                	add	a4,a4,a3
 7b8:	fae60ae3          	beq	a2,a4,76c <free+0x14>
    bp->s.ptr = p->s.ptr;
 7bc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c0:	4790                	lw	a2,8(a5)
 7c2:	02061713          	slli	a4,a2,0x20
 7c6:	9301                	srli	a4,a4,0x20
 7c8:	0712                	slli	a4,a4,0x4
 7ca:	973e                	add	a4,a4,a5
 7cc:	fae689e3          	beq	a3,a4,77e <free+0x26>
  } else
    p->s.ptr = bp;
 7d0:	e394                	sd	a3,0(a5)
  freep = p;
 7d2:	00001717          	auipc	a4,0x1
 7d6:	82f73723          	sd	a5,-2002(a4) # 1000 <freep>
}
 7da:	6422                	ld	s0,8(sp)
 7dc:	0141                	addi	sp,sp,16
 7de:	8082                	ret

00000000000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	7139                	addi	sp,sp,-64
 7e2:	fc06                	sd	ra,56(sp)
 7e4:	f822                	sd	s0,48(sp)
 7e6:	f426                	sd	s1,40(sp)
 7e8:	f04a                	sd	s2,32(sp)
 7ea:	ec4e                	sd	s3,24(sp)
 7ec:	e852                	sd	s4,16(sp)
 7ee:	e456                	sd	s5,8(sp)
 7f0:	e05a                	sd	s6,0(sp)
 7f2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f4:	02051493          	slli	s1,a0,0x20
 7f8:	9081                	srli	s1,s1,0x20
 7fa:	04bd                	addi	s1,s1,15
 7fc:	8091                	srli	s1,s1,0x4
 7fe:	0014899b          	addiw	s3,s1,1
 802:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 804:	00000517          	auipc	a0,0x0
 808:	7fc53503          	ld	a0,2044(a0) # 1000 <freep>
 80c:	c515                	beqz	a0,838 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 810:	4798                	lw	a4,8(a5)
 812:	02977f63          	bgeu	a4,s1,850 <malloc+0x70>
 816:	8a4e                	mv	s4,s3
 818:	0009871b          	sext.w	a4,s3
 81c:	6685                	lui	a3,0x1
 81e:	00d77363          	bgeu	a4,a3,824 <malloc+0x44>
 822:	6a05                	lui	s4,0x1
 824:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 828:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82c:	00000917          	auipc	s2,0x0
 830:	7d490913          	addi	s2,s2,2004 # 1000 <freep>
  if(p == SBRK_ERROR)
 834:	5afd                	li	s5,-1
 836:	a0bd                	j	8a4 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 838:	00000797          	auipc	a5,0x0
 83c:	7d878793          	addi	a5,a5,2008 # 1010 <base>
 840:	00000717          	auipc	a4,0x0
 844:	7cf73023          	sd	a5,1984(a4) # 1000 <freep>
 848:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 84a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84e:	b7e1                	j	816 <malloc+0x36>
      if(p->s.size == nunits)
 850:	02e48b63          	beq	s1,a4,886 <malloc+0xa6>
        p->s.size -= nunits;
 854:	4137073b          	subw	a4,a4,s3
 858:	c798                	sw	a4,8(a5)
        p += p->s.size;
 85a:	1702                	slli	a4,a4,0x20
 85c:	9301                	srli	a4,a4,0x20
 85e:	0712                	slli	a4,a4,0x4
 860:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 862:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 866:	00000717          	auipc	a4,0x0
 86a:	78a73d23          	sd	a0,1946(a4) # 1000 <freep>
      return (void*)(p + 1);
 86e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 872:	70e2                	ld	ra,56(sp)
 874:	7442                	ld	s0,48(sp)
 876:	74a2                	ld	s1,40(sp)
 878:	7902                	ld	s2,32(sp)
 87a:	69e2                	ld	s3,24(sp)
 87c:	6a42                	ld	s4,16(sp)
 87e:	6aa2                	ld	s5,8(sp)
 880:	6b02                	ld	s6,0(sp)
 882:	6121                	addi	sp,sp,64
 884:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 886:	6398                	ld	a4,0(a5)
 888:	e118                	sd	a4,0(a0)
 88a:	bff1                	j	866 <malloc+0x86>
  hp->s.size = nu;
 88c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 890:	0541                	addi	a0,a0,16
 892:	ec7ff0ef          	jal	ra,758 <free>
  return freep;
 896:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 89a:	dd61                	beqz	a0,872 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89e:	4798                	lw	a4,8(a5)
 8a0:	fa9778e3          	bgeu	a4,s1,850 <malloc+0x70>
    if(p == freep)
 8a4:	00093703          	ld	a4,0(s2)
 8a8:	853e                	mv	a0,a5
 8aa:	fef719e3          	bne	a4,a5,89c <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8ae:	8552                	mv	a0,s4
 8b0:	a1fff0ef          	jal	ra,2ce <sbrk>
  if(p == SBRK_ERROR)
 8b4:	fd551ce3          	bne	a0,s5,88c <malloc+0xac>
        return 0;
 8b8:	4501                	li	a0,0
 8ba:	bf65                	j	872 <malloc+0x92>
