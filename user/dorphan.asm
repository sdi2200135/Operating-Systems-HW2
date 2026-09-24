
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	8e450513          	addi	a0,a0,-1820 # 8f0 <malloc+0xea>
  14:	37c000ef          	jal	ra,390 <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	8dc50513          	addi	a0,a0,-1828 # 8f8 <malloc+0xf2>
  24:	728000ef          	jal	ra,74c <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	2fe000ef          	jal	ra,328 <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	8c250513          	addi	a0,a0,-1854 # 8f0 <malloc+0xea>
  36:	362000ef          	jal	ra,398 <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	8d250513          	addi	a0,a0,-1838 # 910 <malloc+0x10a>
  46:	706000ef          	jal	ra,74c <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2dc000ef          	jal	ra,328 <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	8d850513          	addi	a0,a0,-1832 # 928 <malloc+0x122>
  58:	320000ef          	jal	ra,378 <unlink>
  5c:	00054d63          	bltz	a0,76 <main+0x76>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	8e850513          	addi	a0,a0,-1816 # 948 <malloc+0x142>
  68:	6e4000ef          	jal	ra,74c <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800513          	li	a0,1000
  70:	348000ef          	jal	ra,3b8 <pause>
  74:	bfe5                	j	6c <main+0x6c>
    printf("%s: unlink failed\n", s);
  76:	85a6                	mv	a1,s1
  78:	00001517          	auipc	a0,0x1
  7c:	8b850513          	addi	a0,a0,-1864 # 930 <malloc+0x12a>
  80:	6cc000ef          	jal	ra,74c <printf>
    exit(1);
  84:	4505                	li	a0,1
  86:	2a2000ef          	jal	ra,328 <exit>

000000000000008a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  92:	f6fff0ef          	jal	ra,0 <main>
  exit(r);
  96:	292000ef          	jal	ra,328 <exit>

000000000000009a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a0:	87aa                	mv	a5,a0
  a2:	0585                	addi	a1,a1,1
  a4:	0785                	addi	a5,a5,1
  a6:	fff5c703          	lbu	a4,-1(a1)
  aa:	fee78fa3          	sb	a4,-1(a5)
  ae:	fb75                	bnez	a4,a2 <strcpy+0x8>
    ;
  return os;
}
  b0:	6422                	ld	s0,8(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cb91                	beqz	a5,d4 <strcmp+0x1e>
  c2:	0005c703          	lbu	a4,0(a1)
  c6:	00f71763          	bne	a4,a5,d4 <strcmp+0x1e>
    p++, q++;
  ca:	0505                	addi	a0,a0,1
  cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	fbe5                	bnez	a5,c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d4:	0005c503          	lbu	a0,0(a1)
}
  d8:	40a7853b          	subw	a0,a5,a0
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strlen>:

uint
strlen(const char *s)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	cf91                	beqz	a5,108 <strlen+0x26>
  ee:	0505                	addi	a0,a0,1
  f0:	87aa                	mv	a5,a0
  f2:	4685                	li	a3,1
  f4:	9e89                	subw	a3,a3,a0
  f6:	00f6853b          	addw	a0,a3,a5
  fa:	0785                	addi	a5,a5,1
  fc:	fff7c703          	lbu	a4,-1(a5)
 100:	fb7d                	bnez	a4,f6 <strlen+0x14>
    ;
  return n;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  for(n = 0; s[n]; n++)
 108:	4501                	li	a0,0
 10a:	bfe5                	j	102 <strlen+0x20>

000000000000010c <memset>:

void*
memset(void *dst, int c, uint n)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 112:	ce09                	beqz	a2,12c <memset+0x20>
 114:	87aa                	mv	a5,a0
 116:	fff6071b          	addiw	a4,a2,-1
 11a:	1702                	slli	a4,a4,0x20
 11c:	9301                	srli	a4,a4,0x20
 11e:	0705                	addi	a4,a4,1
 120:	972a                	add	a4,a4,a0
    cdst[i] = c;
 122:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 126:	0785                	addi	a5,a5,1
 128:	fee79de3          	bne	a5,a4,122 <memset+0x16>
  }
  return dst;
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strchr>:

char*
strchr(const char *s, char c)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  for(; *s; s++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cb99                	beqz	a5,152 <strchr+0x20>
    if(*s == c)
 13e:	00f58763          	beq	a1,a5,14c <strchr+0x1a>
  for(; *s; s++)
 142:	0505                	addi	a0,a0,1
 144:	00054783          	lbu	a5,0(a0)
 148:	fbfd                	bnez	a5,13e <strchr+0xc>
      return (char*)s;
  return 0;
 14a:	4501                	li	a0,0
}
 14c:	6422                	ld	s0,8(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret
  return 0;
 152:	4501                	li	a0,0
 154:	bfe5                	j	14c <strchr+0x1a>

0000000000000156 <gets>:

char*
gets(char *buf, int max)
{
 156:	711d                	addi	sp,sp,-96
 158:	ec86                	sd	ra,88(sp)
 15a:	e8a2                	sd	s0,80(sp)
 15c:	e4a6                	sd	s1,72(sp)
 15e:	e0ca                	sd	s2,64(sp)
 160:	fc4e                	sd	s3,56(sp)
 162:	f852                	sd	s4,48(sp)
 164:	f456                	sd	s5,40(sp)
 166:	f05a                	sd	s6,32(sp)
 168:	ec5e                	sd	s7,24(sp)
 16a:	1080                	addi	s0,sp,96
 16c:	8baa                	mv	s7,a0
 16e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 170:	892a                	mv	s2,a0
 172:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 174:	4aa9                	li	s5,10
 176:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 178:	89a6                	mv	s3,s1
 17a:	2485                	addiw	s1,s1,1
 17c:	0344d663          	bge	s1,s4,1a8 <gets+0x52>
    cc = read(0, &c, 1);
 180:	4605                	li	a2,1
 182:	faf40593          	addi	a1,s0,-81
 186:	4501                	li	a0,0
 188:	1b8000ef          	jal	ra,340 <read>
    if(cc < 1)
 18c:	00a05e63          	blez	a0,1a8 <gets+0x52>
    buf[i++] = c;
 190:	faf44783          	lbu	a5,-81(s0)
 194:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 198:	01578763          	beq	a5,s5,1a6 <gets+0x50>
 19c:	0905                	addi	s2,s2,1
 19e:	fd679de3          	bne	a5,s6,178 <gets+0x22>
  for(i=0; i+1 < max; ){
 1a2:	89a6                	mv	s3,s1
 1a4:	a011                	j	1a8 <gets+0x52>
 1a6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a8:	99de                	add	s3,s3,s7
 1aa:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ae:	855e                	mv	a0,s7
 1b0:	60e6                	ld	ra,88(sp)
 1b2:	6446                	ld	s0,80(sp)
 1b4:	64a6                	ld	s1,72(sp)
 1b6:	6906                	ld	s2,64(sp)
 1b8:	79e2                	ld	s3,56(sp)
 1ba:	7a42                	ld	s4,48(sp)
 1bc:	7aa2                	ld	s5,40(sp)
 1be:	7b02                	ld	s6,32(sp)
 1c0:	6be2                	ld	s7,24(sp)
 1c2:	6125                	addi	sp,sp,96
 1c4:	8082                	ret

00000000000001c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c6:	1101                	addi	sp,sp,-32
 1c8:	ec06                	sd	ra,24(sp)
 1ca:	e822                	sd	s0,16(sp)
 1cc:	e426                	sd	s1,8(sp)
 1ce:	e04a                	sd	s2,0(sp)
 1d0:	1000                	addi	s0,sp,32
 1d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d4:	4581                	li	a1,0
 1d6:	192000ef          	jal	ra,368 <open>
  if(fd < 0)
 1da:	02054163          	bltz	a0,1fc <stat+0x36>
 1de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e0:	85ca                	mv	a1,s2
 1e2:	19e000ef          	jal	ra,380 <fstat>
 1e6:	892a                	mv	s2,a0
  close(fd);
 1e8:	8526                	mv	a0,s1
 1ea:	166000ef          	jal	ra,350 <close>
  return r;
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	64a2                	ld	s1,8(sp)
 1f6:	6902                	ld	s2,0(sp)
 1f8:	6105                	addi	sp,sp,32
 1fa:	8082                	ret
    return -1;
 1fc:	597d                	li	s2,-1
 1fe:	bfc5                	j	1ee <stat+0x28>

0000000000000200 <atoi>:

int
atoi(const char *s)
{
 200:	1141                	addi	sp,sp,-16
 202:	e422                	sd	s0,8(sp)
 204:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 206:	00054603          	lbu	a2,0(a0)
 20a:	fd06079b          	addiw	a5,a2,-48
 20e:	0ff7f793          	andi	a5,a5,255
 212:	4725                	li	a4,9
 214:	02f76963          	bltu	a4,a5,246 <atoi+0x46>
 218:	86aa                	mv	a3,a0
  n = 0;
 21a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 21c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 21e:	0685                	addi	a3,a3,1
 220:	0025179b          	slliw	a5,a0,0x2
 224:	9fa9                	addw	a5,a5,a0
 226:	0017979b          	slliw	a5,a5,0x1
 22a:	9fb1                	addw	a5,a5,a2
 22c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 230:	0006c603          	lbu	a2,0(a3)
 234:	fd06071b          	addiw	a4,a2,-48
 238:	0ff77713          	andi	a4,a4,255
 23c:	fee5f1e3          	bgeu	a1,a4,21e <atoi+0x1e>
  return n;
}
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
  n = 0;
 246:	4501                	li	a0,0
 248:	bfe5                	j	240 <atoi+0x40>

000000000000024a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 250:	02b57663          	bgeu	a0,a1,27c <memmove+0x32>
    while(n-- > 0)
 254:	02c05163          	blez	a2,276 <memmove+0x2c>
 258:	fff6079b          	addiw	a5,a2,-1
 25c:	1782                	slli	a5,a5,0x20
 25e:	9381                	srli	a5,a5,0x20
 260:	0785                	addi	a5,a5,1
 262:	97aa                	add	a5,a5,a0
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fee79ae3          	bne	a5,a4,266 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
    dst += n;
 27c:	00c50733          	add	a4,a0,a2
    src += n;
 280:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 282:	fec05ae3          	blez	a2,276 <memmove+0x2c>
 286:	fff6079b          	addiw	a5,a2,-1
 28a:	1782                	slli	a5,a5,0x20
 28c:	9381                	srli	a5,a5,0x20
 28e:	fff7c793          	not	a5,a5
 292:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 294:	15fd                	addi	a1,a1,-1
 296:	177d                	addi	a4,a4,-1
 298:	0005c683          	lbu	a3,0(a1)
 29c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a0:	fee79ae3          	bne	a5,a4,294 <memmove+0x4a>
 2a4:	bfc9                	j	276 <memmove+0x2c>

00000000000002a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ac:	ca05                	beqz	a2,2dc <memcmp+0x36>
 2ae:	fff6069b          	addiw	a3,a2,-1
 2b2:	1682                	slli	a3,a3,0x20
 2b4:	9281                	srli	a3,a3,0x20
 2b6:	0685                	addi	a3,a3,1
 2b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00e79863          	bne	a5,a4,2d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c6:	0505                	addi	a0,a0,1
    p2++;
 2c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ca:	fed518e3          	bne	a0,a3,2ba <memcmp+0x14>
  }
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	a019                	j	2d6 <memcmp+0x30>
      return *p1 - *p2;
 2d2:	40e7853b          	subw	a0,a5,a4
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  return 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <memcmp+0x30>

00000000000002e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e8:	f63ff0ef          	jal	ra,24a <memmove>
}
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <sbrk>:

char *
sbrk(int n) {
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2fc:	4585                	li	a1,1
 2fe:	0b2000ef          	jal	ra,3b0 <sys_sbrk>
}
 302:	60a2                	ld	ra,8(sp)
 304:	6402                	ld	s0,0(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <sbrklazy>:

char *
sbrklazy(int n) {
 30a:	1141                	addi	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 312:	4589                	li	a1,2
 314:	09c000ef          	jal	ra,3b0 <sys_sbrk>
}
 318:	60a2                	ld	ra,8(sp)
 31a:	6402                	ld	s0,0(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 320:	4885                	li	a7,1
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <exit>:
.global exit
exit:
 li a7, SYS_exit
 328:	4889                	li	a7,2
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <wait>:
.global wait
wait:
 li a7, SYS_wait
 330:	488d                	li	a7,3
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 338:	4891                	li	a7,4
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <read>:
.global read
read:
 li a7, SYS_read
 340:	4895                	li	a7,5
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <write>:
.global write
write:
 li a7, SYS_write
 348:	48c1                	li	a7,16
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <close>:
.global close
close:
 li a7, SYS_close
 350:	48d5                	li	a7,21
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <kill>:
.global kill
kill:
 li a7, SYS_kill
 358:	4899                	li	a7,6
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <exec>:
.global exec
exec:
 li a7, SYS_exec
 360:	489d                	li	a7,7
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <open>:
.global open
open:
 li a7, SYS_open
 368:	48bd                	li	a7,15
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 370:	48c5                	li	a7,17
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 378:	48c9                	li	a7,18
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 380:	48a1                	li	a7,8
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <link>:
.global link
link:
 li a7, SYS_link
 388:	48cd                	li	a7,19
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 390:	48d1                	li	a7,20
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 398:	48a5                	li	a7,9
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a0:	48a9                	li	a7,10
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a8:	48ad                	li	a7,11
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3b0:	48b1                	li	a7,12
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3b8:	48b5                	li	a7,13
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c0:	48b9                	li	a7,14
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 3c8:	48d9                	li	a7,22
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d0:	1101                	addi	sp,sp,-32
 3d2:	ec06                	sd	ra,24(sp)
 3d4:	e822                	sd	s0,16(sp)
 3d6:	1000                	addi	s0,sp,32
 3d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3dc:	4605                	li	a2,1
 3de:	fef40593          	addi	a1,s0,-17
 3e2:	f67ff0ef          	jal	ra,348 <write>
}
 3e6:	60e2                	ld	ra,24(sp)
 3e8:	6442                	ld	s0,16(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret

00000000000003ee <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ee:	715d                	addi	sp,sp,-80
 3f0:	e486                	sd	ra,72(sp)
 3f2:	e0a2                	sd	s0,64(sp)
 3f4:	fc26                	sd	s1,56(sp)
 3f6:	f84a                	sd	s2,48(sp)
 3f8:	f44e                	sd	s3,40(sp)
 3fa:	0880                	addi	s0,sp,80
 3fc:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3fe:	c299                	beqz	a3,404 <printint+0x16>
 400:	0805c163          	bltz	a1,482 <printint+0x94>
  neg = 0;
 404:	4881                	li	a7,0
 406:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 40a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 40c:	00000517          	auipc	a0,0x0
 410:	56450513          	addi	a0,a0,1380 # 970 <digits>
 414:	883e                	mv	a6,a5
 416:	2785                	addiw	a5,a5,1
 418:	02c5f733          	remu	a4,a1,a2
 41c:	972a                	add	a4,a4,a0
 41e:	00074703          	lbu	a4,0(a4)
 422:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 426:	872e                	mv	a4,a1
 428:	02c5d5b3          	divu	a1,a1,a2
 42c:	0685                	addi	a3,a3,1
 42e:	fec773e3          	bgeu	a4,a2,414 <printint+0x26>
  if(neg)
 432:	00088b63          	beqz	a7,448 <printint+0x5a>
    buf[i++] = '-';
 436:	fd040713          	addi	a4,s0,-48
 43a:	97ba                	add	a5,a5,a4
 43c:	02d00713          	li	a4,45
 440:	fee78423          	sb	a4,-24(a5)
 444:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 448:	02f05663          	blez	a5,474 <printint+0x86>
 44c:	fb840713          	addi	a4,s0,-72
 450:	00f704b3          	add	s1,a4,a5
 454:	fff70993          	addi	s3,a4,-1
 458:	99be                	add	s3,s3,a5
 45a:	37fd                	addiw	a5,a5,-1
 45c:	1782                	slli	a5,a5,0x20
 45e:	9381                	srli	a5,a5,0x20
 460:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 464:	fff4c583          	lbu	a1,-1(s1)
 468:	854a                	mv	a0,s2
 46a:	f67ff0ef          	jal	ra,3d0 <putc>
  while(--i >= 0)
 46e:	14fd                	addi	s1,s1,-1
 470:	ff349ae3          	bne	s1,s3,464 <printint+0x76>
}
 474:	60a6                	ld	ra,72(sp)
 476:	6406                	ld	s0,64(sp)
 478:	74e2                	ld	s1,56(sp)
 47a:	7942                	ld	s2,48(sp)
 47c:	79a2                	ld	s3,40(sp)
 47e:	6161                	addi	sp,sp,80
 480:	8082                	ret
    x = -xx;
 482:	40b005b3          	neg	a1,a1
    neg = 1;
 486:	4885                	li	a7,1
    x = -xx;
 488:	bfbd                	j	406 <printint+0x18>

000000000000048a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48a:	7119                	addi	sp,sp,-128
 48c:	fc86                	sd	ra,120(sp)
 48e:	f8a2                	sd	s0,112(sp)
 490:	f4a6                	sd	s1,104(sp)
 492:	f0ca                	sd	s2,96(sp)
 494:	ecce                	sd	s3,88(sp)
 496:	e8d2                	sd	s4,80(sp)
 498:	e4d6                	sd	s5,72(sp)
 49a:	e0da                	sd	s6,64(sp)
 49c:	fc5e                	sd	s7,56(sp)
 49e:	f862                	sd	s8,48(sp)
 4a0:	f466                	sd	s9,40(sp)
 4a2:	f06a                	sd	s10,32(sp)
 4a4:	ec6e                	sd	s11,24(sp)
 4a6:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a8:	0005c903          	lbu	s2,0(a1)
 4ac:	24090c63          	beqz	s2,704 <vprintf+0x27a>
 4b0:	8b2a                	mv	s6,a0
 4b2:	8a2e                	mv	s4,a1
 4b4:	8bb2                	mv	s7,a2
  state = 0;
 4b6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4b8:	4481                	li	s1,0
 4ba:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4bc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c4:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c8:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4cc:	00000c97          	auipc	s9,0x0
 4d0:	4a4c8c93          	addi	s9,s9,1188 # 970 <digits>
 4d4:	a005                	j	4f4 <vprintf+0x6a>
        putc(fd, c0);
 4d6:	85ca                	mv	a1,s2
 4d8:	855a                	mv	a0,s6
 4da:	ef7ff0ef          	jal	ra,3d0 <putc>
 4de:	a019                	j	4e4 <vprintf+0x5a>
    } else if(state == '%'){
 4e0:	03598263          	beq	s3,s5,504 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4e4:	2485                	addiw	s1,s1,1
 4e6:	8726                	mv	a4,s1
 4e8:	009a07b3          	add	a5,s4,s1
 4ec:	0007c903          	lbu	s2,0(a5)
 4f0:	20090a63          	beqz	s2,704 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 4f4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f8:	fe0994e3          	bnez	s3,4e0 <vprintf+0x56>
      if(c0 == '%'){
 4fc:	fd579de3          	bne	a5,s5,4d6 <vprintf+0x4c>
        state = '%';
 500:	89be                	mv	s3,a5
 502:	b7cd                	j	4e4 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 504:	c3c1                	beqz	a5,584 <vprintf+0xfa>
 506:	00ea06b3          	add	a3,s4,a4
 50a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 50e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 510:	c681                	beqz	a3,518 <vprintf+0x8e>
 512:	9752                	add	a4,a4,s4
 514:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 518:	03878e63          	beq	a5,s8,554 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 51c:	05a78863          	beq	a5,s10,56c <vprintf+0xe2>
      } else if(c0 == 'u'){
 520:	0db78b63          	beq	a5,s11,5f6 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 524:	07800713          	li	a4,120
 528:	10e78d63          	beq	a5,a4,642 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 52c:	07000713          	li	a4,112
 530:	14e78263          	beq	a5,a4,674 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 534:	06300713          	li	a4,99
 538:	16e78f63          	beq	a5,a4,6b6 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 53c:	07300713          	li	a4,115
 540:	18e78563          	beq	a5,a4,6ca <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 544:	05579063          	bne	a5,s5,584 <vprintf+0xfa>
        putc(fd, '%');
 548:	85d6                	mv	a1,s5
 54a:	855a                	mv	a0,s6
 54c:	e85ff0ef          	jal	ra,3d0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 550:	4981                	li	s3,0
 552:	bf49                	j	4e4 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 554:	008b8913          	addi	s2,s7,8
 558:	4685                	li	a3,1
 55a:	4629                	li	a2,10
 55c:	000ba583          	lw	a1,0(s7)
 560:	855a                	mv	a0,s6
 562:	e8dff0ef          	jal	ra,3ee <printint>
 566:	8bca                	mv	s7,s2
      state = 0;
 568:	4981                	li	s3,0
 56a:	bfad                	j	4e4 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 56c:	03868663          	beq	a3,s8,598 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 570:	05a68163          	beq	a3,s10,5b2 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 574:	09b68d63          	beq	a3,s11,60e <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 578:	03a68f63          	beq	a3,s10,5b6 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 57c:	07800793          	li	a5,120
 580:	0cf68d63          	beq	a3,a5,65a <vprintf+0x1d0>
        putc(fd, '%');
 584:	85d6                	mv	a1,s5
 586:	855a                	mv	a0,s6
 588:	e49ff0ef          	jal	ra,3d0 <putc>
        putc(fd, c0);
 58c:	85ca                	mv	a1,s2
 58e:	855a                	mv	a0,s6
 590:	e41ff0ef          	jal	ra,3d0 <putc>
      state = 0;
 594:	4981                	li	s3,0
 596:	b7b9                	j	4e4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 598:	008b8913          	addi	s2,s7,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000bb583          	ld	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	e49ff0ef          	jal	ra,3ee <printint>
        i += 1;
 5aa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ac:	8bca                	mv	s7,s2
      state = 0;
 5ae:	4981                	li	s3,0
        i += 1;
 5b0:	bf15                	j	4e4 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b2:	03860563          	beq	a2,s8,5dc <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5b6:	07b60963          	beq	a2,s11,628 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ba:	07800793          	li	a5,120
 5be:	fcf613e3          	bne	a2,a5,584 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4641                	li	a2,16
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e1fff0ef          	jal	ra,3ee <printint>
        i += 2;
 5d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
        i += 2;
 5da:	b729                	j	4e4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4685                	li	a3,1
 5e2:	4629                	li	a2,10
 5e4:	000bb583          	ld	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e05ff0ef          	jal	ra,3ee <printint>
        i += 2;
 5ee:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 2;
 5f4:	bdc5                	j	4e4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000be583          	lwu	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	debff0ef          	jal	ra,3ee <printint>
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bde1                	j	4e4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	008b8913          	addi	s2,s7,8
 612:	4681                	li	a3,0
 614:	4629                	li	a2,10
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	dd3ff0ef          	jal	ra,3ee <printint>
        i += 1;
 620:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
        i += 1;
 626:	bd7d                	j	4e4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	db9ff0ef          	jal	ra,3ee <printint>
        i += 2;
 63a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 2;
 640:	b555                	j	4e4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 642:	008b8913          	addi	s2,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000be583          	lwu	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	d9fff0ef          	jal	ra,3ee <printint>
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
 658:	b571                	j	4e4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	008b8913          	addi	s2,s7,8
 65e:	4681                	li	a3,0
 660:	4641                	li	a2,16
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	d87ff0ef          	jal	ra,3ee <printint>
        i += 1;
 66c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 1;
 672:	bd8d                	j	4e4 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 674:	008b8793          	addi	a5,s7,8
 678:	f8f43423          	sd	a5,-120(s0)
 67c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 680:	03000593          	li	a1,48
 684:	855a                	mv	a0,s6
 686:	d4bff0ef          	jal	ra,3d0 <putc>
  putc(fd, 'x');
 68a:	07800593          	li	a1,120
 68e:	855a                	mv	a0,s6
 690:	d41ff0ef          	jal	ra,3d0 <putc>
 694:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 696:	03c9d793          	srli	a5,s3,0x3c
 69a:	97e6                	add	a5,a5,s9
 69c:	0007c583          	lbu	a1,0(a5)
 6a0:	855a                	mv	a0,s6
 6a2:	d2fff0ef          	jal	ra,3d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a6:	0992                	slli	s3,s3,0x4
 6a8:	397d                	addiw	s2,s2,-1
 6aa:	fe0916e3          	bnez	s2,696 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 6ae:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bd05                	j	4e4 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	000bc583          	lbu	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	d11ff0ef          	jal	ra,3d0 <putc>
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bd31                	j	4e4 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	008b8993          	addi	s3,s7,8
 6ce:	000bb903          	ld	s2,0(s7)
 6d2:	00090f63          	beqz	s2,6f0 <vprintf+0x266>
        for(; *s; s++)
 6d6:	00094583          	lbu	a1,0(s2)
 6da:	c195                	beqz	a1,6fe <vprintf+0x274>
          putc(fd, *s);
 6dc:	855a                	mv	a0,s6
 6de:	cf3ff0ef          	jal	ra,3d0 <putc>
        for(; *s; s++)
 6e2:	0905                	addi	s2,s2,1
 6e4:	00094583          	lbu	a1,0(s2)
 6e8:	f9f5                	bnez	a1,6dc <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6ea:	8bce                	mv	s7,s3
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bbdd                	j	4e4 <vprintf+0x5a>
          s = "(null)";
 6f0:	00000917          	auipc	s2,0x0
 6f4:	27890913          	addi	s2,s2,632 # 968 <malloc+0x162>
        for(; *s; s++)
 6f8:	02800593          	li	a1,40
 6fc:	b7c5                	j	6dc <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6fe:	8bce                	mv	s7,s3
      state = 0;
 700:	4981                	li	s3,0
 702:	b3cd                	j	4e4 <vprintf+0x5a>
    }
  }
}
 704:	70e6                	ld	ra,120(sp)
 706:	7446                	ld	s0,112(sp)
 708:	74a6                	ld	s1,104(sp)
 70a:	7906                	ld	s2,96(sp)
 70c:	69e6                	ld	s3,88(sp)
 70e:	6a46                	ld	s4,80(sp)
 710:	6aa6                	ld	s5,72(sp)
 712:	6b06                	ld	s6,64(sp)
 714:	7be2                	ld	s7,56(sp)
 716:	7c42                	ld	s8,48(sp)
 718:	7ca2                	ld	s9,40(sp)
 71a:	7d02                	ld	s10,32(sp)
 71c:	6de2                	ld	s11,24(sp)
 71e:	6109                	addi	sp,sp,128
 720:	8082                	ret

0000000000000722 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 722:	715d                	addi	sp,sp,-80
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	1000                	addi	s0,sp,32
 72a:	e010                	sd	a2,0(s0)
 72c:	e414                	sd	a3,8(s0)
 72e:	e818                	sd	a4,16(s0)
 730:	ec1c                	sd	a5,24(s0)
 732:	03043023          	sd	a6,32(s0)
 736:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73e:	8622                	mv	a2,s0
 740:	d4bff0ef          	jal	ra,48a <vprintf>
}
 744:	60e2                	ld	ra,24(sp)
 746:	6442                	ld	s0,16(sp)
 748:	6161                	addi	sp,sp,80
 74a:	8082                	ret

000000000000074c <printf>:

void
printf(const char *fmt, ...)
{
 74c:	711d                	addi	sp,sp,-96
 74e:	ec06                	sd	ra,24(sp)
 750:	e822                	sd	s0,16(sp)
 752:	1000                	addi	s0,sp,32
 754:	e40c                	sd	a1,8(s0)
 756:	e810                	sd	a2,16(s0)
 758:	ec14                	sd	a3,24(s0)
 75a:	f018                	sd	a4,32(s0)
 75c:	f41c                	sd	a5,40(s0)
 75e:	03043823          	sd	a6,48(s0)
 762:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 766:	00840613          	addi	a2,s0,8
 76a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76e:	85aa                	mv	a1,a0
 770:	4505                	li	a0,1
 772:	d19ff0ef          	jal	ra,48a <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6125                	addi	sp,sp,96
 77c:	8082                	ret

000000000000077e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77e:	1141                	addi	sp,sp,-16
 780:	e422                	sd	s0,8(sp)
 782:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 784:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 788:	00001797          	auipc	a5,0x1
 78c:	8787b783          	ld	a5,-1928(a5) # 1000 <freep>
 790:	a805                	j	7c0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 792:	4618                	lw	a4,8(a2)
 794:	9db9                	addw	a1,a1,a4
 796:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79a:	6398                	ld	a4,0(a5)
 79c:	6318                	ld	a4,0(a4)
 79e:	fee53823          	sd	a4,-16(a0)
 7a2:	a091                	j	7e6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a4:	ff852703          	lw	a4,-8(a0)
 7a8:	9e39                	addw	a2,a2,a4
 7aa:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7ac:	ff053703          	ld	a4,-16(a0)
 7b0:	e398                	sd	a4,0(a5)
 7b2:	a099                	j	7f8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	6398                	ld	a4,0(a5)
 7b6:	00e7e463          	bltu	a5,a4,7be <free+0x40>
 7ba:	00e6ea63          	bltu	a3,a4,7ce <free+0x50>
{
 7be:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c0:	fed7fae3          	bgeu	a5,a3,7b4 <free+0x36>
 7c4:	6398                	ld	a4,0(a5)
 7c6:	00e6e463          	bltu	a3,a4,7ce <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ca:	fee7eae3          	bltu	a5,a4,7be <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7ce:	ff852583          	lw	a1,-8(a0)
 7d2:	6390                	ld	a2,0(a5)
 7d4:	02059713          	slli	a4,a1,0x20
 7d8:	9301                	srli	a4,a4,0x20
 7da:	0712                	slli	a4,a4,0x4
 7dc:	9736                	add	a4,a4,a3
 7de:	fae60ae3          	beq	a2,a4,792 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7e2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7e6:	4790                	lw	a2,8(a5)
 7e8:	02061713          	slli	a4,a2,0x20
 7ec:	9301                	srli	a4,a4,0x20
 7ee:	0712                	slli	a4,a4,0x4
 7f0:	973e                	add	a4,a4,a5
 7f2:	fae689e3          	beq	a3,a4,7a4 <free+0x26>
  } else
    p->s.ptr = bp;
 7f6:	e394                	sd	a3,0(a5)
  freep = p;
 7f8:	00001717          	auipc	a4,0x1
 7fc:	80f73423          	sd	a5,-2040(a4) # 1000 <freep>
}
 800:	6422                	ld	s0,8(sp)
 802:	0141                	addi	sp,sp,16
 804:	8082                	ret

0000000000000806 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 806:	7139                	addi	sp,sp,-64
 808:	fc06                	sd	ra,56(sp)
 80a:	f822                	sd	s0,48(sp)
 80c:	f426                	sd	s1,40(sp)
 80e:	f04a                	sd	s2,32(sp)
 810:	ec4e                	sd	s3,24(sp)
 812:	e852                	sd	s4,16(sp)
 814:	e456                	sd	s5,8(sp)
 816:	e05a                	sd	s6,0(sp)
 818:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81a:	02051493          	slli	s1,a0,0x20
 81e:	9081                	srli	s1,s1,0x20
 820:	04bd                	addi	s1,s1,15
 822:	8091                	srli	s1,s1,0x4
 824:	0014899b          	addiw	s3,s1,1
 828:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 82a:	00000517          	auipc	a0,0x0
 82e:	7d653503          	ld	a0,2006(a0) # 1000 <freep>
 832:	c515                	beqz	a0,85e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 834:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 836:	4798                	lw	a4,8(a5)
 838:	02977f63          	bgeu	a4,s1,876 <malloc+0x70>
 83c:	8a4e                	mv	s4,s3
 83e:	0009871b          	sext.w	a4,s3
 842:	6685                	lui	a3,0x1
 844:	00d77363          	bgeu	a4,a3,84a <malloc+0x44>
 848:	6a05                	lui	s4,0x1
 84a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 84e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 852:	00000917          	auipc	s2,0x0
 856:	7ae90913          	addi	s2,s2,1966 # 1000 <freep>
  if(p == SBRK_ERROR)
 85a:	5afd                	li	s5,-1
 85c:	a0bd                	j	8ca <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 85e:	00001797          	auipc	a5,0x1
 862:	9aa78793          	addi	a5,a5,-1622 # 1208 <base>
 866:	00000717          	auipc	a4,0x0
 86a:	78f73d23          	sd	a5,1946(a4) # 1000 <freep>
 86e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 870:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 874:	b7e1                	j	83c <malloc+0x36>
      if(p->s.size == nunits)
 876:	02e48b63          	beq	s1,a4,8ac <malloc+0xa6>
        p->s.size -= nunits;
 87a:	4137073b          	subw	a4,a4,s3
 87e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 880:	1702                	slli	a4,a4,0x20
 882:	9301                	srli	a4,a4,0x20
 884:	0712                	slli	a4,a4,0x4
 886:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 888:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88c:	00000717          	auipc	a4,0x0
 890:	76a73a23          	sd	a0,1908(a4) # 1000 <freep>
      return (void*)(p + 1);
 894:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 898:	70e2                	ld	ra,56(sp)
 89a:	7442                	ld	s0,48(sp)
 89c:	74a2                	ld	s1,40(sp)
 89e:	7902                	ld	s2,32(sp)
 8a0:	69e2                	ld	s3,24(sp)
 8a2:	6a42                	ld	s4,16(sp)
 8a4:	6aa2                	ld	s5,8(sp)
 8a6:	6b02                	ld	s6,0(sp)
 8a8:	6121                	addi	sp,sp,64
 8aa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	bff1                	j	88c <malloc+0x86>
  hp->s.size = nu;
 8b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b6:	0541                	addi	a0,a0,16
 8b8:	ec7ff0ef          	jal	ra,77e <free>
  return freep;
 8bc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c0:	dd61                	beqz	a0,898 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c4:	4798                	lw	a4,8(a5)
 8c6:	fa9778e3          	bgeu	a4,s1,876 <malloc+0x70>
    if(p == freep)
 8ca:	00093703          	ld	a4,0(s2)
 8ce:	853e                	mv	a0,a5
 8d0:	fef719e3          	bne	a4,a5,8c2 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8d4:	8552                	mv	a0,s4
 8d6:	a1fff0ef          	jal	ra,2f4 <sbrk>
  if(p == SBRK_ERROR)
 8da:	fd551ce3          	bne	a0,s5,8b2 <malloc+0xac>
        return 0;
 8de:	4501                	li	a0,0
 8e0:	bf65                	j	898 <malloc+0x92>
