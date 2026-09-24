
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	00f50c63          	beq	a0,a5,24 <main+0x24>
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	8a058593          	addi	a1,a1,-1888 # 8b0 <malloc+0xe8>
  18:	4509                	li	a0,2
  1a:	6ca000ef          	jal	ra,6e4 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2ca000ef          	jal	ra,2ea <exit>
  24:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  26:	698c                	ld	a1,16(a1)
  28:	6488                	ld	a0,8(s1)
  2a:	320000ef          	jal	ra,34a <link>
  2e:	00054563          	bltz	a0,38 <main+0x38>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  32:	4501                	li	a0,0
  34:	2b6000ef          	jal	ra,2ea <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  38:	6894                	ld	a3,16(s1)
  3a:	6490                	ld	a2,8(s1)
  3c:	00001597          	auipc	a1,0x1
  40:	88c58593          	addi	a1,a1,-1908 # 8c8 <malloc+0x100>
  44:	4509                	li	a0,2
  46:	69e000ef          	jal	ra,6e4 <fprintf>
  4a:	b7e5                	j	32 <main+0x32>

000000000000004c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e406                	sd	ra,8(sp)
  50:	e022                	sd	s0,0(sp)
  52:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  54:	fadff0ef          	jal	ra,0 <main>
  exit(r);
  58:	292000ef          	jal	ra,2ea <exit>

000000000000005c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5c:	1141                	addi	sp,sp,-16
  5e:	e422                	sd	s0,8(sp)
  60:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  62:	87aa                	mv	a5,a0
  64:	0585                	addi	a1,a1,1
  66:	0785                	addi	a5,a5,1
  68:	fff5c703          	lbu	a4,-1(a1)
  6c:	fee78fa3          	sb	a4,-1(a5)
  70:	fb75                	bnez	a4,64 <strcpy+0x8>
    ;
  return os;
}
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cb91                	beqz	a5,96 <strcmp+0x1e>
  84:	0005c703          	lbu	a4,0(a1)
  88:	00f71763          	bne	a4,a5,96 <strcmp+0x1e>
    p++, q++;
  8c:	0505                	addi	a0,a0,1
  8e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  90:	00054783          	lbu	a5,0(a0)
  94:	fbe5                	bnez	a5,84 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  96:	0005c503          	lbu	a0,0(a1)
}
  9a:	40a7853b          	subw	a0,a5,a0
  9e:	6422                	ld	s0,8(sp)
  a0:	0141                	addi	sp,sp,16
  a2:	8082                	ret

00000000000000a4 <strlen>:

uint
strlen(const char *s)
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e422                	sd	s0,8(sp)
  a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  aa:	00054783          	lbu	a5,0(a0)
  ae:	cf91                	beqz	a5,ca <strlen+0x26>
  b0:	0505                	addi	a0,a0,1
  b2:	87aa                	mv	a5,a0
  b4:	4685                	li	a3,1
  b6:	9e89                	subw	a3,a3,a0
  b8:	00f6853b          	addw	a0,a3,a5
  bc:	0785                	addi	a5,a5,1
  be:	fff7c703          	lbu	a4,-1(a5)
  c2:	fb7d                	bnez	a4,b8 <strlen+0x14>
    ;
  return n;
}
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret
  for(n = 0; s[n]; n++)
  ca:	4501                	li	a0,0
  cc:	bfe5                	j	c4 <strlen+0x20>

00000000000000ce <memset>:

void*
memset(void *dst, int c, uint n)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e422                	sd	s0,8(sp)
  d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d4:	ce09                	beqz	a2,ee <memset+0x20>
  d6:	87aa                	mv	a5,a0
  d8:	fff6071b          	addiw	a4,a2,-1
  dc:	1702                	slli	a4,a4,0x20
  de:	9301                	srli	a4,a4,0x20
  e0:	0705                	addi	a4,a4,1
  e2:	972a                	add	a4,a4,a0
    cdst[i] = c;
  e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e8:	0785                	addi	a5,a5,1
  ea:	fee79de3          	bne	a5,a4,e4 <memset+0x16>
  }
  return dst;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strchr>:

char*
strchr(const char *s, char c)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb99                	beqz	a5,114 <strchr+0x20>
    if(*s == c)
 100:	00f58763          	beq	a1,a5,10e <strchr+0x1a>
  for(; *s; s++)
 104:	0505                	addi	a0,a0,1
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbfd                	bnez	a5,100 <strchr+0xc>
      return (char*)s;
  return 0;
 10c:	4501                	li	a0,0
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  return 0;
 114:	4501                	li	a0,0
 116:	bfe5                	j	10e <strchr+0x1a>

0000000000000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	711d                	addi	sp,sp,-96
 11a:	ec86                	sd	ra,88(sp)
 11c:	e8a2                	sd	s0,80(sp)
 11e:	e4a6                	sd	s1,72(sp)
 120:	e0ca                	sd	s2,64(sp)
 122:	fc4e                	sd	s3,56(sp)
 124:	f852                	sd	s4,48(sp)
 126:	f456                	sd	s5,40(sp)
 128:	f05a                	sd	s6,32(sp)
 12a:	ec5e                	sd	s7,24(sp)
 12c:	1080                	addi	s0,sp,96
 12e:	8baa                	mv	s7,a0
 130:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	892a                	mv	s2,a0
 134:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 136:	4aa9                	li	s5,10
 138:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13a:	89a6                	mv	s3,s1
 13c:	2485                	addiw	s1,s1,1
 13e:	0344d663          	bge	s1,s4,16a <gets+0x52>
    cc = read(0, &c, 1);
 142:	4605                	li	a2,1
 144:	faf40593          	addi	a1,s0,-81
 148:	4501                	li	a0,0
 14a:	1b8000ef          	jal	ra,302 <read>
    if(cc < 1)
 14e:	00a05e63          	blez	a0,16a <gets+0x52>
    buf[i++] = c;
 152:	faf44783          	lbu	a5,-81(s0)
 156:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15a:	01578763          	beq	a5,s5,168 <gets+0x50>
 15e:	0905                	addi	s2,s2,1
 160:	fd679de3          	bne	a5,s6,13a <gets+0x22>
  for(i=0; i+1 < max; ){
 164:	89a6                	mv	s3,s1
 166:	a011                	j	16a <gets+0x52>
 168:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16a:	99de                	add	s3,s3,s7
 16c:	00098023          	sb	zero,0(s3)
  return buf;
}
 170:	855e                	mv	a0,s7
 172:	60e6                	ld	ra,88(sp)
 174:	6446                	ld	s0,80(sp)
 176:	64a6                	ld	s1,72(sp)
 178:	6906                	ld	s2,64(sp)
 17a:	79e2                	ld	s3,56(sp)
 17c:	7a42                	ld	s4,48(sp)
 17e:	7aa2                	ld	s5,40(sp)
 180:	7b02                	ld	s6,32(sp)
 182:	6be2                	ld	s7,24(sp)
 184:	6125                	addi	sp,sp,96
 186:	8082                	ret

0000000000000188 <stat>:

int
stat(const char *n, struct stat *st)
{
 188:	1101                	addi	sp,sp,-32
 18a:	ec06                	sd	ra,24(sp)
 18c:	e822                	sd	s0,16(sp)
 18e:	e426                	sd	s1,8(sp)
 190:	e04a                	sd	s2,0(sp)
 192:	1000                	addi	s0,sp,32
 194:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 196:	4581                	li	a1,0
 198:	192000ef          	jal	ra,32a <open>
  if(fd < 0)
 19c:	02054163          	bltz	a0,1be <stat+0x36>
 1a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a2:	85ca                	mv	a1,s2
 1a4:	19e000ef          	jal	ra,342 <fstat>
 1a8:	892a                	mv	s2,a0
  close(fd);
 1aa:	8526                	mv	a0,s1
 1ac:	166000ef          	jal	ra,312 <close>
  return r;
}
 1b0:	854a                	mv	a0,s2
 1b2:	60e2                	ld	ra,24(sp)
 1b4:	6442                	ld	s0,16(sp)
 1b6:	64a2                	ld	s1,8(sp)
 1b8:	6902                	ld	s2,0(sp)
 1ba:	6105                	addi	sp,sp,32
 1bc:	8082                	ret
    return -1;
 1be:	597d                	li	s2,-1
 1c0:	bfc5                	j	1b0 <stat+0x28>

00000000000001c2 <atoi>:

int
atoi(const char *s)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c8:	00054603          	lbu	a2,0(a0)
 1cc:	fd06079b          	addiw	a5,a2,-48
 1d0:	0ff7f793          	andi	a5,a5,255
 1d4:	4725                	li	a4,9
 1d6:	02f76963          	bltu	a4,a5,208 <atoi+0x46>
 1da:	86aa                	mv	a3,a0
  n = 0;
 1dc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1de:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1e0:	0685                	addi	a3,a3,1
 1e2:	0025179b          	slliw	a5,a0,0x2
 1e6:	9fa9                	addw	a5,a5,a0
 1e8:	0017979b          	slliw	a5,a5,0x1
 1ec:	9fb1                	addw	a5,a5,a2
 1ee:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f2:	0006c603          	lbu	a2,0(a3)
 1f6:	fd06071b          	addiw	a4,a2,-48
 1fa:	0ff77713          	andi	a4,a4,255
 1fe:	fee5f1e3          	bgeu	a1,a4,1e0 <atoi+0x1e>
  return n;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
  n = 0;
 208:	4501                	li	a0,0
 20a:	bfe5                	j	202 <atoi+0x40>

000000000000020c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 212:	02b57663          	bgeu	a0,a1,23e <memmove+0x32>
    while(n-- > 0)
 216:	02c05163          	blez	a2,238 <memmove+0x2c>
 21a:	fff6079b          	addiw	a5,a2,-1
 21e:	1782                	slli	a5,a5,0x20
 220:	9381                	srli	a5,a5,0x20
 222:	0785                	addi	a5,a5,1
 224:	97aa                	add	a5,a5,a0
  dst = vdst;
 226:	872a                	mv	a4,a0
      *dst++ = *src++;
 228:	0585                	addi	a1,a1,1
 22a:	0705                	addi	a4,a4,1
 22c:	fff5c683          	lbu	a3,-1(a1)
 230:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 234:	fee79ae3          	bne	a5,a4,228 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
    dst += n;
 23e:	00c50733          	add	a4,a0,a2
    src += n;
 242:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 244:	fec05ae3          	blez	a2,238 <memmove+0x2c>
 248:	fff6079b          	addiw	a5,a2,-1
 24c:	1782                	slli	a5,a5,0x20
 24e:	9381                	srli	a5,a5,0x20
 250:	fff7c793          	not	a5,a5
 254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 256:	15fd                	addi	a1,a1,-1
 258:	177d                	addi	a4,a4,-1
 25a:	0005c683          	lbu	a3,0(a1)
 25e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 262:	fee79ae3          	bne	a5,a4,256 <memmove+0x4a>
 266:	bfc9                	j	238 <memmove+0x2c>

0000000000000268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26e:	ca05                	beqz	a2,29e <memcmp+0x36>
 270:	fff6069b          	addiw	a3,a2,-1
 274:	1682                	slli	a3,a3,0x20
 276:	9281                	srli	a3,a3,0x20
 278:	0685                	addi	a3,a3,1
 27a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27c:	00054783          	lbu	a5,0(a0)
 280:	0005c703          	lbu	a4,0(a1)
 284:	00e79863          	bne	a5,a4,294 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 288:	0505                	addi	a0,a0,1
    p2++;
 28a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28c:	fed518e3          	bne	a0,a3,27c <memcmp+0x14>
  }
  return 0;
 290:	4501                	li	a0,0
 292:	a019                	j	298 <memcmp+0x30>
      return *p1 - *p2;
 294:	40e7853b          	subw	a0,a5,a4
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <memcmp+0x30>

00000000000002a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2aa:	f63ff0ef          	jal	ra,20c <memmove>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <sbrk>:

char *
sbrk(int n) {
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2be:	4585                	li	a1,1
 2c0:	0b2000ef          	jal	ra,372 <sys_sbrk>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <sbrklazy>:

char *
sbrklazy(int n) {
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2d4:	4589                	li	a1,2
 2d6:	09c000ef          	jal	ra,372 <sys_sbrk>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e2:	4885                	li	a7,1
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ea:	4889                	li	a7,2
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f2:	488d                	li	a7,3
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fa:	4891                	li	a7,4
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <read>:
.global read
read:
 li a7, SYS_read
 302:	4895                	li	a7,5
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <write>:
.global write
write:
 li a7, SYS_write
 30a:	48c1                	li	a7,16
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <close>:
.global close
close:
 li a7, SYS_close
 312:	48d5                	li	a7,21
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <kill>:
.global kill
kill:
 li a7, SYS_kill
 31a:	4899                	li	a7,6
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exec>:
.global exec
exec:
 li a7, SYS_exec
 322:	489d                	li	a7,7
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <open>:
.global open
open:
 li a7, SYS_open
 32a:	48bd                	li	a7,15
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 332:	48c5                	li	a7,17
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33a:	48c9                	li	a7,18
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 342:	48a1                	li	a7,8
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <link>:
.global link
link:
 li a7, SYS_link
 34a:	48cd                	li	a7,19
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 352:	48d1                	li	a7,20
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35a:	48a5                	li	a7,9
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <dup>:
.global dup
dup:
 li a7, SYS_dup
 362:	48a9                	li	a7,10
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36a:	48ad                	li	a7,11
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 372:	48b1                	li	a7,12
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <pause>:
.global pause
pause:
 li a7, SYS_pause
 37a:	48b5                	li	a7,13
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 382:	48b9                	li	a7,14
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 38a:	48d9                	li	a7,22
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 392:	1101                	addi	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	1000                	addi	s0,sp,32
 39a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39e:	4605                	li	a2,1
 3a0:	fef40593          	addi	a1,s0,-17
 3a4:	f67ff0ef          	jal	ra,30a <write>
}
 3a8:	60e2                	ld	ra,24(sp)
 3aa:	6442                	ld	s0,16(sp)
 3ac:	6105                	addi	sp,sp,32
 3ae:	8082                	ret

00000000000003b0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3b0:	715d                	addi	sp,sp,-80
 3b2:	e486                	sd	ra,72(sp)
 3b4:	e0a2                	sd	s0,64(sp)
 3b6:	fc26                	sd	s1,56(sp)
 3b8:	f84a                	sd	s2,48(sp)
 3ba:	f44e                	sd	s3,40(sp)
 3bc:	0880                	addi	s0,sp,80
 3be:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3c0:	c299                	beqz	a3,3c6 <printint+0x16>
 3c2:	0805c163          	bltz	a1,444 <printint+0x94>
  neg = 0;
 3c6:	4881                	li	a7,0
 3c8:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3cc:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3ce:	00000517          	auipc	a0,0x0
 3d2:	51a50513          	addi	a0,a0,1306 # 8e8 <digits>
 3d6:	883e                	mv	a6,a5
 3d8:	2785                	addiw	a5,a5,1
 3da:	02c5f733          	remu	a4,a1,a2
 3de:	972a                	add	a4,a4,a0
 3e0:	00074703          	lbu	a4,0(a4)
 3e4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3e8:	872e                	mv	a4,a1
 3ea:	02c5d5b3          	divu	a1,a1,a2
 3ee:	0685                	addi	a3,a3,1
 3f0:	fec773e3          	bgeu	a4,a2,3d6 <printint+0x26>
  if(neg)
 3f4:	00088b63          	beqz	a7,40a <printint+0x5a>
    buf[i++] = '-';
 3f8:	fd040713          	addi	a4,s0,-48
 3fc:	97ba                	add	a5,a5,a4
 3fe:	02d00713          	li	a4,45
 402:	fee78423          	sb	a4,-24(a5)
 406:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 40a:	02f05663          	blez	a5,436 <printint+0x86>
 40e:	fb840713          	addi	a4,s0,-72
 412:	00f704b3          	add	s1,a4,a5
 416:	fff70993          	addi	s3,a4,-1
 41a:	99be                	add	s3,s3,a5
 41c:	37fd                	addiw	a5,a5,-1
 41e:	1782                	slli	a5,a5,0x20
 420:	9381                	srli	a5,a5,0x20
 422:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 426:	fff4c583          	lbu	a1,-1(s1)
 42a:	854a                	mv	a0,s2
 42c:	f67ff0ef          	jal	ra,392 <putc>
  while(--i >= 0)
 430:	14fd                	addi	s1,s1,-1
 432:	ff349ae3          	bne	s1,s3,426 <printint+0x76>
}
 436:	60a6                	ld	ra,72(sp)
 438:	6406                	ld	s0,64(sp)
 43a:	74e2                	ld	s1,56(sp)
 43c:	7942                	ld	s2,48(sp)
 43e:	79a2                	ld	s3,40(sp)
 440:	6161                	addi	sp,sp,80
 442:	8082                	ret
    x = -xx;
 444:	40b005b3          	neg	a1,a1
    neg = 1;
 448:	4885                	li	a7,1
    x = -xx;
 44a:	bfbd                	j	3c8 <printint+0x18>

000000000000044c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44c:	7119                	addi	sp,sp,-128
 44e:	fc86                	sd	ra,120(sp)
 450:	f8a2                	sd	s0,112(sp)
 452:	f4a6                	sd	s1,104(sp)
 454:	f0ca                	sd	s2,96(sp)
 456:	ecce                	sd	s3,88(sp)
 458:	e8d2                	sd	s4,80(sp)
 45a:	e4d6                	sd	s5,72(sp)
 45c:	e0da                	sd	s6,64(sp)
 45e:	fc5e                	sd	s7,56(sp)
 460:	f862                	sd	s8,48(sp)
 462:	f466                	sd	s9,40(sp)
 464:	f06a                	sd	s10,32(sp)
 466:	ec6e                	sd	s11,24(sp)
 468:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 46a:	0005c903          	lbu	s2,0(a1)
 46e:	24090c63          	beqz	s2,6c6 <vprintf+0x27a>
 472:	8b2a                	mv	s6,a0
 474:	8a2e                	mv	s4,a1
 476:	8bb2                	mv	s7,a2
  state = 0;
 478:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 47a:	4481                	li	s1,0
 47c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 47e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 482:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 486:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 48a:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 48e:	00000c97          	auipc	s9,0x0
 492:	45ac8c93          	addi	s9,s9,1114 # 8e8 <digits>
 496:	a005                	j	4b6 <vprintf+0x6a>
        putc(fd, c0);
 498:	85ca                	mv	a1,s2
 49a:	855a                	mv	a0,s6
 49c:	ef7ff0ef          	jal	ra,392 <putc>
 4a0:	a019                	j	4a6 <vprintf+0x5a>
    } else if(state == '%'){
 4a2:	03598263          	beq	s3,s5,4c6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4a6:	2485                	addiw	s1,s1,1
 4a8:	8726                	mv	a4,s1
 4aa:	009a07b3          	add	a5,s4,s1
 4ae:	0007c903          	lbu	s2,0(a5)
 4b2:	20090a63          	beqz	s2,6c6 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 4b6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4ba:	fe0994e3          	bnez	s3,4a2 <vprintf+0x56>
      if(c0 == '%'){
 4be:	fd579de3          	bne	a5,s5,498 <vprintf+0x4c>
        state = '%';
 4c2:	89be                	mv	s3,a5
 4c4:	b7cd                	j	4a6 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4c6:	c3c1                	beqz	a5,546 <vprintf+0xfa>
 4c8:	00ea06b3          	add	a3,s4,a4
 4cc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4d0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4d2:	c681                	beqz	a3,4da <vprintf+0x8e>
 4d4:	9752                	add	a4,a4,s4
 4d6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4da:	03878e63          	beq	a5,s8,516 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 4de:	05a78863          	beq	a5,s10,52e <vprintf+0xe2>
      } else if(c0 == 'u'){
 4e2:	0db78b63          	beq	a5,s11,5b8 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4e6:	07800713          	li	a4,120
 4ea:	10e78d63          	beq	a5,a4,604 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ee:	07000713          	li	a4,112
 4f2:	14e78263          	beq	a5,a4,636 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4f6:	06300713          	li	a4,99
 4fa:	16e78f63          	beq	a5,a4,678 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4fe:	07300713          	li	a4,115
 502:	18e78563          	beq	a5,a4,68c <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 506:	05579063          	bne	a5,s5,546 <vprintf+0xfa>
        putc(fd, '%');
 50a:	85d6                	mv	a1,s5
 50c:	855a                	mv	a0,s6
 50e:	e85ff0ef          	jal	ra,392 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 512:	4981                	li	s3,0
 514:	bf49                	j	4a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 516:	008b8913          	addi	s2,s7,8
 51a:	4685                	li	a3,1
 51c:	4629                	li	a2,10
 51e:	000ba583          	lw	a1,0(s7)
 522:	855a                	mv	a0,s6
 524:	e8dff0ef          	jal	ra,3b0 <printint>
 528:	8bca                	mv	s7,s2
      state = 0;
 52a:	4981                	li	s3,0
 52c:	bfad                	j	4a6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 52e:	03868663          	beq	a3,s8,55a <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 532:	05a68163          	beq	a3,s10,574 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 536:	09b68d63          	beq	a3,s11,5d0 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 53a:	03a68f63          	beq	a3,s10,578 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 53e:	07800793          	li	a5,120
 542:	0cf68d63          	beq	a3,a5,61c <vprintf+0x1d0>
        putc(fd, '%');
 546:	85d6                	mv	a1,s5
 548:	855a                	mv	a0,s6
 54a:	e49ff0ef          	jal	ra,392 <putc>
        putc(fd, c0);
 54e:	85ca                	mv	a1,s2
 550:	855a                	mv	a0,s6
 552:	e41ff0ef          	jal	ra,392 <putc>
      state = 0;
 556:	4981                	li	s3,0
 558:	b7b9                	j	4a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	008b8913          	addi	s2,s7,8
 55e:	4685                	li	a3,1
 560:	4629                	li	a2,10
 562:	000bb583          	ld	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	e49ff0ef          	jal	ra,3b0 <printint>
        i += 1;
 56c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	8bca                	mv	s7,s2
      state = 0;
 570:	4981                	li	s3,0
        i += 1;
 572:	bf15                	j	4a6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 574:	03860563          	beq	a2,s8,59e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 578:	07b60963          	beq	a2,s11,5ea <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 57c:	07800793          	li	a5,120
 580:	fcf613e3          	bne	a2,a5,546 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 584:	008b8913          	addi	s2,s7,8
 588:	4681                	li	a3,0
 58a:	4641                	li	a2,16
 58c:	000bb583          	ld	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	e1fff0ef          	jal	ra,3b0 <printint>
        i += 2;
 596:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
        i += 2;
 59c:	b729                	j	4a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	008b8913          	addi	s2,s7,8
 5a2:	4685                	li	a3,1
 5a4:	4629                	li	a2,10
 5a6:	000bb583          	ld	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	e05ff0ef          	jal	ra,3b0 <printint>
        i += 2;
 5b0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
        i += 2;
 5b6:	bdc5                	j	4a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4629                	li	a2,10
 5c0:	000be583          	lwu	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	debff0ef          	jal	ra,3b0 <printint>
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	bde1                	j	4a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000bb583          	ld	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	dd3ff0ef          	jal	ra,3b0 <printint>
        i += 1;
 5e2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
        i += 1;
 5e8:	bd7d                	j	4a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	008b8913          	addi	s2,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4629                	li	a2,10
 5f2:	000bb583          	ld	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	db9ff0ef          	jal	ra,3b0 <printint>
        i += 2;
 5fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
        i += 2;
 602:	b555                	j	4a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 604:	008b8913          	addi	s2,s7,8
 608:	4681                	li	a3,0
 60a:	4641                	li	a2,16
 60c:	000be583          	lwu	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	d9fff0ef          	jal	ra,3b0 <printint>
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
 61a:	b571                	j	4a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	008b8913          	addi	s2,s7,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000bb583          	ld	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	d87ff0ef          	jal	ra,3b0 <printint>
        i += 1;
 62e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
        i += 1;
 634:	bd8d                	j	4a6 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 636:	008b8793          	addi	a5,s7,8
 63a:	f8f43423          	sd	a5,-120(s0)
 63e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 642:	03000593          	li	a1,48
 646:	855a                	mv	a0,s6
 648:	d4bff0ef          	jal	ra,392 <putc>
  putc(fd, 'x');
 64c:	07800593          	li	a1,120
 650:	855a                	mv	a0,s6
 652:	d41ff0ef          	jal	ra,392 <putc>
 656:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 658:	03c9d793          	srli	a5,s3,0x3c
 65c:	97e6                	add	a5,a5,s9
 65e:	0007c583          	lbu	a1,0(a5)
 662:	855a                	mv	a0,s6
 664:	d2fff0ef          	jal	ra,392 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 668:	0992                	slli	s3,s3,0x4
 66a:	397d                	addiw	s2,s2,-1
 66c:	fe0916e3          	bnez	s2,658 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 670:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 674:	4981                	li	s3,0
 676:	bd05                	j	4a6 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 678:	008b8913          	addi	s2,s7,8
 67c:	000bc583          	lbu	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	d11ff0ef          	jal	ra,392 <putc>
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	bd31                	j	4a6 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 68c:	008b8993          	addi	s3,s7,8
 690:	000bb903          	ld	s2,0(s7)
 694:	00090f63          	beqz	s2,6b2 <vprintf+0x266>
        for(; *s; s++)
 698:	00094583          	lbu	a1,0(s2)
 69c:	c195                	beqz	a1,6c0 <vprintf+0x274>
          putc(fd, *s);
 69e:	855a                	mv	a0,s6
 6a0:	cf3ff0ef          	jal	ra,392 <putc>
        for(; *s; s++)
 6a4:	0905                	addi	s2,s2,1
 6a6:	00094583          	lbu	a1,0(s2)
 6aa:	f9f5                	bnez	a1,69e <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6ac:	8bce                	mv	s7,s3
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bbdd                	j	4a6 <vprintf+0x5a>
          s = "(null)";
 6b2:	00000917          	auipc	s2,0x0
 6b6:	22e90913          	addi	s2,s2,558 # 8e0 <malloc+0x118>
        for(; *s; s++)
 6ba:	02800593          	li	a1,40
 6be:	b7c5                	j	69e <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6c0:	8bce                	mv	s7,s3
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b3cd                	j	4a6 <vprintf+0x5a>
    }
  }
}
 6c6:	70e6                	ld	ra,120(sp)
 6c8:	7446                	ld	s0,112(sp)
 6ca:	74a6                	ld	s1,104(sp)
 6cc:	7906                	ld	s2,96(sp)
 6ce:	69e6                	ld	s3,88(sp)
 6d0:	6a46                	ld	s4,80(sp)
 6d2:	6aa6                	ld	s5,72(sp)
 6d4:	6b06                	ld	s6,64(sp)
 6d6:	7be2                	ld	s7,56(sp)
 6d8:	7c42                	ld	s8,48(sp)
 6da:	7ca2                	ld	s9,40(sp)
 6dc:	7d02                	ld	s10,32(sp)
 6de:	6de2                	ld	s11,24(sp)
 6e0:	6109                	addi	sp,sp,128
 6e2:	8082                	ret

00000000000006e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e4:	715d                	addi	sp,sp,-80
 6e6:	ec06                	sd	ra,24(sp)
 6e8:	e822                	sd	s0,16(sp)
 6ea:	1000                	addi	s0,sp,32
 6ec:	e010                	sd	a2,0(s0)
 6ee:	e414                	sd	a3,8(s0)
 6f0:	e818                	sd	a4,16(s0)
 6f2:	ec1c                	sd	a5,24(s0)
 6f4:	03043023          	sd	a6,32(s0)
 6f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 700:	8622                	mv	a2,s0
 702:	d4bff0ef          	jal	ra,44c <vprintf>
}
 706:	60e2                	ld	ra,24(sp)
 708:	6442                	ld	s0,16(sp)
 70a:	6161                	addi	sp,sp,80
 70c:	8082                	ret

000000000000070e <printf>:

void
printf(const char *fmt, ...)
{
 70e:	711d                	addi	sp,sp,-96
 710:	ec06                	sd	ra,24(sp)
 712:	e822                	sd	s0,16(sp)
 714:	1000                	addi	s0,sp,32
 716:	e40c                	sd	a1,8(s0)
 718:	e810                	sd	a2,16(s0)
 71a:	ec14                	sd	a3,24(s0)
 71c:	f018                	sd	a4,32(s0)
 71e:	f41c                	sd	a5,40(s0)
 720:	03043823          	sd	a6,48(s0)
 724:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 728:	00840613          	addi	a2,s0,8
 72c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 730:	85aa                	mv	a1,a0
 732:	4505                	li	a0,1
 734:	d19ff0ef          	jal	ra,44c <vprintf>
}
 738:	60e2                	ld	ra,24(sp)
 73a:	6442                	ld	s0,16(sp)
 73c:	6125                	addi	sp,sp,96
 73e:	8082                	ret

0000000000000740 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 740:	1141                	addi	sp,sp,-16
 742:	e422                	sd	s0,8(sp)
 744:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 746:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74a:	00001797          	auipc	a5,0x1
 74e:	8b67b783          	ld	a5,-1866(a5) # 1000 <freep>
 752:	a805                	j	782 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 754:	4618                	lw	a4,8(a2)
 756:	9db9                	addw	a1,a1,a4
 758:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 75c:	6398                	ld	a4,0(a5)
 75e:	6318                	ld	a4,0(a4)
 760:	fee53823          	sd	a4,-16(a0)
 764:	a091                	j	7a8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 766:	ff852703          	lw	a4,-8(a0)
 76a:	9e39                	addw	a2,a2,a4
 76c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 76e:	ff053703          	ld	a4,-16(a0)
 772:	e398                	sd	a4,0(a5)
 774:	a099                	j	7ba <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	6398                	ld	a4,0(a5)
 778:	00e7e463          	bltu	a5,a4,780 <free+0x40>
 77c:	00e6ea63          	bltu	a3,a4,790 <free+0x50>
{
 780:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	fed7fae3          	bgeu	a5,a3,776 <free+0x36>
 786:	6398                	ld	a4,0(a5)
 788:	00e6e463          	bltu	a3,a4,790 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	fee7eae3          	bltu	a5,a4,780 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 790:	ff852583          	lw	a1,-8(a0)
 794:	6390                	ld	a2,0(a5)
 796:	02059713          	slli	a4,a1,0x20
 79a:	9301                	srli	a4,a4,0x20
 79c:	0712                	slli	a4,a4,0x4
 79e:	9736                	add	a4,a4,a3
 7a0:	fae60ae3          	beq	a2,a4,754 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7a4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a8:	4790                	lw	a2,8(a5)
 7aa:	02061713          	slli	a4,a2,0x20
 7ae:	9301                	srli	a4,a4,0x20
 7b0:	0712                	slli	a4,a4,0x4
 7b2:	973e                	add	a4,a4,a5
 7b4:	fae689e3          	beq	a3,a4,766 <free+0x26>
  } else
    p->s.ptr = bp;
 7b8:	e394                	sd	a3,0(a5)
  freep = p;
 7ba:	00001717          	auipc	a4,0x1
 7be:	84f73323          	sd	a5,-1978(a4) # 1000 <freep>
}
 7c2:	6422                	ld	s0,8(sp)
 7c4:	0141                	addi	sp,sp,16
 7c6:	8082                	ret

00000000000007c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c8:	7139                	addi	sp,sp,-64
 7ca:	fc06                	sd	ra,56(sp)
 7cc:	f822                	sd	s0,48(sp)
 7ce:	f426                	sd	s1,40(sp)
 7d0:	f04a                	sd	s2,32(sp)
 7d2:	ec4e                	sd	s3,24(sp)
 7d4:	e852                	sd	s4,16(sp)
 7d6:	e456                	sd	s5,8(sp)
 7d8:	e05a                	sd	s6,0(sp)
 7da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7dc:	02051493          	slli	s1,a0,0x20
 7e0:	9081                	srli	s1,s1,0x20
 7e2:	04bd                	addi	s1,s1,15
 7e4:	8091                	srli	s1,s1,0x4
 7e6:	0014899b          	addiw	s3,s1,1
 7ea:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ec:	00001517          	auipc	a0,0x1
 7f0:	81453503          	ld	a0,-2028(a0) # 1000 <freep>
 7f4:	c515                	beqz	a0,820 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f8:	4798                	lw	a4,8(a5)
 7fa:	02977f63          	bgeu	a4,s1,838 <malloc+0x70>
 7fe:	8a4e                	mv	s4,s3
 800:	0009871b          	sext.w	a4,s3
 804:	6685                	lui	a3,0x1
 806:	00d77363          	bgeu	a4,a3,80c <malloc+0x44>
 80a:	6a05                	lui	s4,0x1
 80c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 810:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 814:	00000917          	auipc	s2,0x0
 818:	7ec90913          	addi	s2,s2,2028 # 1000 <freep>
  if(p == SBRK_ERROR)
 81c:	5afd                	li	s5,-1
 81e:	a0bd                	j	88c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 820:	00000797          	auipc	a5,0x0
 824:	7f078793          	addi	a5,a5,2032 # 1010 <base>
 828:	00000717          	auipc	a4,0x0
 82c:	7cf73c23          	sd	a5,2008(a4) # 1000 <freep>
 830:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 832:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 836:	b7e1                	j	7fe <malloc+0x36>
      if(p->s.size == nunits)
 838:	02e48b63          	beq	s1,a4,86e <malloc+0xa6>
        p->s.size -= nunits;
 83c:	4137073b          	subw	a4,a4,s3
 840:	c798                	sw	a4,8(a5)
        p += p->s.size;
 842:	1702                	slli	a4,a4,0x20
 844:	9301                	srli	a4,a4,0x20
 846:	0712                	slli	a4,a4,0x4
 848:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 84e:	00000717          	auipc	a4,0x0
 852:	7aa73923          	sd	a0,1970(a4) # 1000 <freep>
      return (void*)(p + 1);
 856:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 85a:	70e2                	ld	ra,56(sp)
 85c:	7442                	ld	s0,48(sp)
 85e:	74a2                	ld	s1,40(sp)
 860:	7902                	ld	s2,32(sp)
 862:	69e2                	ld	s3,24(sp)
 864:	6a42                	ld	s4,16(sp)
 866:	6aa2                	ld	s5,8(sp)
 868:	6b02                	ld	s6,0(sp)
 86a:	6121                	addi	sp,sp,64
 86c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	e118                	sd	a4,0(a0)
 872:	bff1                	j	84e <malloc+0x86>
  hp->s.size = nu;
 874:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 878:	0541                	addi	a0,a0,16
 87a:	ec7ff0ef          	jal	ra,740 <free>
  return freep;
 87e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 882:	dd61                	beqz	a0,85a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 886:	4798                	lw	a4,8(a5)
 888:	fa9778e3          	bgeu	a4,s1,838 <malloc+0x70>
    if(p == freep)
 88c:	00093703          	ld	a4,0(s2)
 890:	853e                	mv	a0,a5
 892:	fef719e3          	bne	a4,a5,884 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 896:	8552                	mv	a0,s4
 898:	a1fff0ef          	jal	ra,2b6 <sbrk>
  if(p == SBRK_ERROR)
 89c:	fd551ce3          	bne	a0,s5,874 <malloc+0xac>
        return 0;
 8a0:	4501                	li	a0,0
 8a2:	bf65                	j	85a <malloc+0x92>
