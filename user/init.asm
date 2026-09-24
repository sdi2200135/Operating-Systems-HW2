
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	91250513          	addi	a0,a0,-1774 # 920 <malloc+0xe8>
  16:	384000ef          	jal	ra,39a <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	3b2000ef          	jal	ra,3d2 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	3ac000ef          	jal	ra,3d2 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	8fe90913          	addi	s2,s2,-1794 # 928 <malloc+0xf0>
  32:	854a                	mv	a0,s2
  34:	74a000ef          	jal	ra,77e <printf>
    pid = fork();
  38:	31a000ef          	jal	ra,352 <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	31c000ef          	jal	ra,362 <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	92650513          	addi	a0,a0,-1754 # 978 <malloc+0x140>
  5a:	724000ef          	jal	ra,77e <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2fa000ef          	jal	ra,35a <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	8b850513          	addi	a0,a0,-1864 # 920 <malloc+0xe8>
  70:	332000ef          	jal	ra,3a2 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	8aa50513          	addi	a0,a0,-1878 # 920 <malloc+0xe8>
  7e:	31c000ef          	jal	ra,39a <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	8bc50513          	addi	a0,a0,-1860 # 940 <malloc+0x108>
  8c:	6f2000ef          	jal	ra,77e <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2c8000ef          	jal	ra,35a <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	8ba50513          	addi	a0,a0,-1862 # 958 <malloc+0x120>
  a6:	2ec000ef          	jal	ra,392 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	8b650513          	addi	a0,a0,-1866 # 960 <malloc+0x128>
  b2:	6cc000ef          	jal	ra,77e <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2a2000ef          	jal	ra,35a <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c4:	f3dff0ef          	jal	ra,0 <main>
  exit(r);
  c8:	292000ef          	jal	ra,35a <exit>

00000000000000cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d2:	87aa                	mv	a5,a0
  d4:	0585                	addi	a1,a1,1
  d6:	0785                	addi	a5,a5,1
  d8:	fff5c703          	lbu	a4,-1(a1)
  dc:	fee78fa3          	sb	a4,-1(a5)
  e0:	fb75                	bnez	a4,d4 <strcpy+0x8>
    ;
  return os;
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cb91                	beqz	a5,106 <strcmp+0x1e>
  f4:	0005c703          	lbu	a4,0(a1)
  f8:	00f71763          	bne	a4,a5,106 <strcmp+0x1e>
    p++, q++;
  fc:	0505                	addi	a0,a0,1
  fe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 100:	00054783          	lbu	a5,0(a0)
 104:	fbe5                	bnez	a5,f4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 106:	0005c503          	lbu	a0,0(a1)
}
 10a:	40a7853b          	subw	a0,a5,a0
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strlen>:

uint
strlen(const char *s)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cf91                	beqz	a5,13a <strlen+0x26>
 120:	0505                	addi	a0,a0,1
 122:	87aa                	mv	a5,a0
 124:	4685                	li	a3,1
 126:	9e89                	subw	a3,a3,a0
 128:	00f6853b          	addw	a0,a3,a5
 12c:	0785                	addi	a5,a5,1
 12e:	fff7c703          	lbu	a4,-1(a5)
 132:	fb7d                	bnez	a4,128 <strlen+0x14>
    ;
  return n;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret
  for(n = 0; s[n]; n++)
 13a:	4501                	li	a0,0
 13c:	bfe5                	j	134 <strlen+0x20>

000000000000013e <memset>:

void*
memset(void *dst, int c, uint n)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 144:	ce09                	beqz	a2,15e <memset+0x20>
 146:	87aa                	mv	a5,a0
 148:	fff6071b          	addiw	a4,a2,-1
 14c:	1702                	slli	a4,a4,0x20
 14e:	9301                	srli	a4,a4,0x20
 150:	0705                	addi	a4,a4,1
 152:	972a                	add	a4,a4,a0
    cdst[i] = c;
 154:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 158:	0785                	addi	a5,a5,1
 15a:	fee79de3          	bne	a5,a4,154 <memset+0x16>
  }
  return dst;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strchr>:

char*
strchr(const char *s, char c)
{
 164:	1141                	addi	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	addi	s0,sp,16
  for(; *s; s++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cb99                	beqz	a5,184 <strchr+0x20>
    if(*s == c)
 170:	00f58763          	beq	a1,a5,17e <strchr+0x1a>
  for(; *s; s++)
 174:	0505                	addi	a0,a0,1
 176:	00054783          	lbu	a5,0(a0)
 17a:	fbfd                	bnez	a5,170 <strchr+0xc>
      return (char*)s;
  return 0;
 17c:	4501                	li	a0,0
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret
  return 0;
 184:	4501                	li	a0,0
 186:	bfe5                	j	17e <strchr+0x1a>

0000000000000188 <gets>:

char*
gets(char *buf, int max)
{
 188:	711d                	addi	sp,sp,-96
 18a:	ec86                	sd	ra,88(sp)
 18c:	e8a2                	sd	s0,80(sp)
 18e:	e4a6                	sd	s1,72(sp)
 190:	e0ca                	sd	s2,64(sp)
 192:	fc4e                	sd	s3,56(sp)
 194:	f852                	sd	s4,48(sp)
 196:	f456                	sd	s5,40(sp)
 198:	f05a                	sd	s6,32(sp)
 19a:	ec5e                	sd	s7,24(sp)
 19c:	1080                	addi	s0,sp,96
 19e:	8baa                	mv	s7,a0
 1a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a2:	892a                	mv	s2,a0
 1a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a6:	4aa9                	li	s5,10
 1a8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1aa:	89a6                	mv	s3,s1
 1ac:	2485                	addiw	s1,s1,1
 1ae:	0344d663          	bge	s1,s4,1da <gets+0x52>
    cc = read(0, &c, 1);
 1b2:	4605                	li	a2,1
 1b4:	faf40593          	addi	a1,s0,-81
 1b8:	4501                	li	a0,0
 1ba:	1b8000ef          	jal	ra,372 <read>
    if(cc < 1)
 1be:	00a05e63          	blez	a0,1da <gets+0x52>
    buf[i++] = c;
 1c2:	faf44783          	lbu	a5,-81(s0)
 1c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ca:	01578763          	beq	a5,s5,1d8 <gets+0x50>
 1ce:	0905                	addi	s2,s2,1
 1d0:	fd679de3          	bne	a5,s6,1aa <gets+0x22>
  for(i=0; i+1 < max; ){
 1d4:	89a6                	mv	s3,s1
 1d6:	a011                	j	1da <gets+0x52>
 1d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1da:	99de                	add	s3,s3,s7
 1dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e0:	855e                	mv	a0,s7
 1e2:	60e6                	ld	ra,88(sp)
 1e4:	6446                	ld	s0,80(sp)
 1e6:	64a6                	ld	s1,72(sp)
 1e8:	6906                	ld	s2,64(sp)
 1ea:	79e2                	ld	s3,56(sp)
 1ec:	7a42                	ld	s4,48(sp)
 1ee:	7aa2                	ld	s5,40(sp)
 1f0:	7b02                	ld	s6,32(sp)
 1f2:	6be2                	ld	s7,24(sp)
 1f4:	6125                	addi	sp,sp,96
 1f6:	8082                	ret

00000000000001f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f8:	1101                	addi	sp,sp,-32
 1fa:	ec06                	sd	ra,24(sp)
 1fc:	e822                	sd	s0,16(sp)
 1fe:	e426                	sd	s1,8(sp)
 200:	e04a                	sd	s2,0(sp)
 202:	1000                	addi	s0,sp,32
 204:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	4581                	li	a1,0
 208:	192000ef          	jal	ra,39a <open>
  if(fd < 0)
 20c:	02054163          	bltz	a0,22e <stat+0x36>
 210:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 212:	85ca                	mv	a1,s2
 214:	19e000ef          	jal	ra,3b2 <fstat>
 218:	892a                	mv	s2,a0
  close(fd);
 21a:	8526                	mv	a0,s1
 21c:	166000ef          	jal	ra,382 <close>
  return r;
}
 220:	854a                	mv	a0,s2
 222:	60e2                	ld	ra,24(sp)
 224:	6442                	ld	s0,16(sp)
 226:	64a2                	ld	s1,8(sp)
 228:	6902                	ld	s2,0(sp)
 22a:	6105                	addi	sp,sp,32
 22c:	8082                	ret
    return -1;
 22e:	597d                	li	s2,-1
 230:	bfc5                	j	220 <stat+0x28>

0000000000000232 <atoi>:

int
atoi(const char *s)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 238:	00054603          	lbu	a2,0(a0)
 23c:	fd06079b          	addiw	a5,a2,-48
 240:	0ff7f793          	andi	a5,a5,255
 244:	4725                	li	a4,9
 246:	02f76963          	bltu	a4,a5,278 <atoi+0x46>
 24a:	86aa                	mv	a3,a0
  n = 0;
 24c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 24e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 250:	0685                	addi	a3,a3,1
 252:	0025179b          	slliw	a5,a0,0x2
 256:	9fa9                	addw	a5,a5,a0
 258:	0017979b          	slliw	a5,a5,0x1
 25c:	9fb1                	addw	a5,a5,a2
 25e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 262:	0006c603          	lbu	a2,0(a3)
 266:	fd06071b          	addiw	a4,a2,-48
 26a:	0ff77713          	andi	a4,a4,255
 26e:	fee5f1e3          	bgeu	a1,a4,250 <atoi+0x1e>
  return n;
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
  n = 0;
 278:	4501                	li	a0,0
 27a:	bfe5                	j	272 <atoi+0x40>

000000000000027c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 282:	02b57663          	bgeu	a0,a1,2ae <memmove+0x32>
    while(n-- > 0)
 286:	02c05163          	blez	a2,2a8 <memmove+0x2c>
 28a:	fff6079b          	addiw	a5,a2,-1
 28e:	1782                	slli	a5,a5,0x20
 290:	9381                	srli	a5,a5,0x20
 292:	0785                	addi	a5,a5,1
 294:	97aa                	add	a5,a5,a0
  dst = vdst;
 296:	872a                	mv	a4,a0
      *dst++ = *src++;
 298:	0585                	addi	a1,a1,1
 29a:	0705                	addi	a4,a4,1
 29c:	fff5c683          	lbu	a3,-1(a1)
 2a0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a4:	fee79ae3          	bne	a5,a4,298 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
    dst += n;
 2ae:	00c50733          	add	a4,a0,a2
    src += n;
 2b2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b4:	fec05ae3          	blez	a2,2a8 <memmove+0x2c>
 2b8:	fff6079b          	addiw	a5,a2,-1
 2bc:	1782                	slli	a5,a5,0x20
 2be:	9381                	srli	a5,a5,0x20
 2c0:	fff7c793          	not	a5,a5
 2c4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c6:	15fd                	addi	a1,a1,-1
 2c8:	177d                	addi	a4,a4,-1
 2ca:	0005c683          	lbu	a3,0(a1)
 2ce:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d2:	fee79ae3          	bne	a5,a4,2c6 <memmove+0x4a>
 2d6:	bfc9                	j	2a8 <memmove+0x2c>

00000000000002d8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2de:	ca05                	beqz	a2,30e <memcmp+0x36>
 2e0:	fff6069b          	addiw	a3,a2,-1
 2e4:	1682                	slli	a3,a3,0x20
 2e6:	9281                	srli	a3,a3,0x20
 2e8:	0685                	addi	a3,a3,1
 2ea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00e79863          	bne	a5,a4,304 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f8:	0505                	addi	a0,a0,1
    p2++;
 2fa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2fc:	fed518e3          	bne	a0,a3,2ec <memcmp+0x14>
  }
  return 0;
 300:	4501                	li	a0,0
 302:	a019                	j	308 <memcmp+0x30>
      return *p1 - *p2;
 304:	40e7853b          	subw	a0,a5,a4
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
  return 0;
 30e:	4501                	li	a0,0
 310:	bfe5                	j	308 <memcmp+0x30>

0000000000000312 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 312:	1141                	addi	sp,sp,-16
 314:	e406                	sd	ra,8(sp)
 316:	e022                	sd	s0,0(sp)
 318:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 31a:	f63ff0ef          	jal	ra,27c <memmove>
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <sbrk>:

char *
sbrk(int n) {
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 32e:	4585                	li	a1,1
 330:	0b2000ef          	jal	ra,3e2 <sys_sbrk>
}
 334:	60a2                	ld	ra,8(sp)
 336:	6402                	ld	s0,0(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret

000000000000033c <sbrklazy>:

char *
sbrklazy(int n) {
 33c:	1141                	addi	sp,sp,-16
 33e:	e406                	sd	ra,8(sp)
 340:	e022                	sd	s0,0(sp)
 342:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 344:	4589                	li	a1,2
 346:	09c000ef          	jal	ra,3e2 <sys_sbrk>
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 352:	4885                	li	a7,1
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exit>:
.global exit
exit:
 li a7, SYS_exit
 35a:	4889                	li	a7,2
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <wait>:
.global wait
wait:
 li a7, SYS_wait
 362:	488d                	li	a7,3
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 36a:	4891                	li	a7,4
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <read>:
.global read
read:
 li a7, SYS_read
 372:	4895                	li	a7,5
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <write>:
.global write
write:
 li a7, SYS_write
 37a:	48c1                	li	a7,16
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <close>:
.global close
close:
 li a7, SYS_close
 382:	48d5                	li	a7,21
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <kill>:
.global kill
kill:
 li a7, SYS_kill
 38a:	4899                	li	a7,6
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exec>:
.global exec
exec:
 li a7, SYS_exec
 392:	489d                	li	a7,7
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <open>:
.global open
open:
 li a7, SYS_open
 39a:	48bd                	li	a7,15
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a2:	48c5                	li	a7,17
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3aa:	48c9                	li	a7,18
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b2:	48a1                	li	a7,8
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <link>:
.global link
link:
 li a7, SYS_link
 3ba:	48cd                	li	a7,19
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c2:	48d1                	li	a7,20
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ca:	48a5                	li	a7,9
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d2:	48a9                	li	a7,10
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3da:	48ad                	li	a7,11
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3e2:	48b1                	li	a7,12
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ea:	48b5                	li	a7,13
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f2:	48b9                	li	a7,14
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 3fa:	48d9                	li	a7,22
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 402:	1101                	addi	sp,sp,-32
 404:	ec06                	sd	ra,24(sp)
 406:	e822                	sd	s0,16(sp)
 408:	1000                	addi	s0,sp,32
 40a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40e:	4605                	li	a2,1
 410:	fef40593          	addi	a1,s0,-17
 414:	f67ff0ef          	jal	ra,37a <write>
}
 418:	60e2                	ld	ra,24(sp)
 41a:	6442                	ld	s0,16(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret

0000000000000420 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 420:	715d                	addi	sp,sp,-80
 422:	e486                	sd	ra,72(sp)
 424:	e0a2                	sd	s0,64(sp)
 426:	fc26                	sd	s1,56(sp)
 428:	f84a                	sd	s2,48(sp)
 42a:	f44e                	sd	s3,40(sp)
 42c:	0880                	addi	s0,sp,80
 42e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 430:	c299                	beqz	a3,436 <printint+0x16>
 432:	0805c163          	bltz	a1,4b4 <printint+0x94>
  neg = 0;
 436:	4881                	li	a7,0
 438:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 43c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 43e:	00000517          	auipc	a0,0x0
 442:	56250513          	addi	a0,a0,1378 # 9a0 <digits>
 446:	883e                	mv	a6,a5
 448:	2785                	addiw	a5,a5,1
 44a:	02c5f733          	remu	a4,a1,a2
 44e:	972a                	add	a4,a4,a0
 450:	00074703          	lbu	a4,0(a4)
 454:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 458:	872e                	mv	a4,a1
 45a:	02c5d5b3          	divu	a1,a1,a2
 45e:	0685                	addi	a3,a3,1
 460:	fec773e3          	bgeu	a4,a2,446 <printint+0x26>
  if(neg)
 464:	00088b63          	beqz	a7,47a <printint+0x5a>
    buf[i++] = '-';
 468:	fd040713          	addi	a4,s0,-48
 46c:	97ba                	add	a5,a5,a4
 46e:	02d00713          	li	a4,45
 472:	fee78423          	sb	a4,-24(a5)
 476:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 47a:	02f05663          	blez	a5,4a6 <printint+0x86>
 47e:	fb840713          	addi	a4,s0,-72
 482:	00f704b3          	add	s1,a4,a5
 486:	fff70993          	addi	s3,a4,-1
 48a:	99be                	add	s3,s3,a5
 48c:	37fd                	addiw	a5,a5,-1
 48e:	1782                	slli	a5,a5,0x20
 490:	9381                	srli	a5,a5,0x20
 492:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 496:	fff4c583          	lbu	a1,-1(s1)
 49a:	854a                	mv	a0,s2
 49c:	f67ff0ef          	jal	ra,402 <putc>
  while(--i >= 0)
 4a0:	14fd                	addi	s1,s1,-1
 4a2:	ff349ae3          	bne	s1,s3,496 <printint+0x76>
}
 4a6:	60a6                	ld	ra,72(sp)
 4a8:	6406                	ld	s0,64(sp)
 4aa:	74e2                	ld	s1,56(sp)
 4ac:	7942                	ld	s2,48(sp)
 4ae:	79a2                	ld	s3,40(sp)
 4b0:	6161                	addi	sp,sp,80
 4b2:	8082                	ret
    x = -xx;
 4b4:	40b005b3          	neg	a1,a1
    neg = 1;
 4b8:	4885                	li	a7,1
    x = -xx;
 4ba:	bfbd                	j	438 <printint+0x18>

00000000000004bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4bc:	7119                	addi	sp,sp,-128
 4be:	fc86                	sd	ra,120(sp)
 4c0:	f8a2                	sd	s0,112(sp)
 4c2:	f4a6                	sd	s1,104(sp)
 4c4:	f0ca                	sd	s2,96(sp)
 4c6:	ecce                	sd	s3,88(sp)
 4c8:	e8d2                	sd	s4,80(sp)
 4ca:	e4d6                	sd	s5,72(sp)
 4cc:	e0da                	sd	s6,64(sp)
 4ce:	fc5e                	sd	s7,56(sp)
 4d0:	f862                	sd	s8,48(sp)
 4d2:	f466                	sd	s9,40(sp)
 4d4:	f06a                	sd	s10,32(sp)
 4d6:	ec6e                	sd	s11,24(sp)
 4d8:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4da:	0005c903          	lbu	s2,0(a1)
 4de:	24090c63          	beqz	s2,736 <vprintf+0x27a>
 4e2:	8b2a                	mv	s6,a0
 4e4:	8a2e                	mv	s4,a1
 4e6:	8bb2                	mv	s7,a2
  state = 0;
 4e8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ea:	4481                	li	s1,0
 4ec:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ee:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4f6:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4fa:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fe:	00000c97          	auipc	s9,0x0
 502:	4a2c8c93          	addi	s9,s9,1186 # 9a0 <digits>
 506:	a005                	j	526 <vprintf+0x6a>
        putc(fd, c0);
 508:	85ca                	mv	a1,s2
 50a:	855a                	mv	a0,s6
 50c:	ef7ff0ef          	jal	ra,402 <putc>
 510:	a019                	j	516 <vprintf+0x5a>
    } else if(state == '%'){
 512:	03598263          	beq	s3,s5,536 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 516:	2485                	addiw	s1,s1,1
 518:	8726                	mv	a4,s1
 51a:	009a07b3          	add	a5,s4,s1
 51e:	0007c903          	lbu	s2,0(a5)
 522:	20090a63          	beqz	s2,736 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 526:	0009079b          	sext.w	a5,s2
    if(state == 0){
 52a:	fe0994e3          	bnez	s3,512 <vprintf+0x56>
      if(c0 == '%'){
 52e:	fd579de3          	bne	a5,s5,508 <vprintf+0x4c>
        state = '%';
 532:	89be                	mv	s3,a5
 534:	b7cd                	j	516 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 536:	c3c1                	beqz	a5,5b6 <vprintf+0xfa>
 538:	00ea06b3          	add	a3,s4,a4
 53c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 540:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 542:	c681                	beqz	a3,54a <vprintf+0x8e>
 544:	9752                	add	a4,a4,s4
 546:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 54a:	03878e63          	beq	a5,s8,586 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 54e:	05a78863          	beq	a5,s10,59e <vprintf+0xe2>
      } else if(c0 == 'u'){
 552:	0db78b63          	beq	a5,s11,628 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 556:	07800713          	li	a4,120
 55a:	10e78d63          	beq	a5,a4,674 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 55e:	07000713          	li	a4,112
 562:	14e78263          	beq	a5,a4,6a6 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 566:	06300713          	li	a4,99
 56a:	16e78f63          	beq	a5,a4,6e8 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 56e:	07300713          	li	a4,115
 572:	18e78563          	beq	a5,a4,6fc <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 576:	05579063          	bne	a5,s5,5b6 <vprintf+0xfa>
        putc(fd, '%');
 57a:	85d6                	mv	a1,s5
 57c:	855a                	mv	a0,s6
 57e:	e85ff0ef          	jal	ra,402 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 582:	4981                	li	s3,0
 584:	bf49                	j	516 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 586:	008b8913          	addi	s2,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e8dff0ef          	jal	ra,420 <printint>
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bfad                	j	516 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 59e:	03868663          	beq	a3,s8,5ca <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a2:	05a68163          	beq	a3,s10,5e4 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 5a6:	09b68d63          	beq	a3,s11,640 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5aa:	03a68f63          	beq	a3,s10,5e8 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 5ae:	07800793          	li	a5,120
 5b2:	0cf68d63          	beq	a3,a5,68c <vprintf+0x1d0>
        putc(fd, '%');
 5b6:	85d6                	mv	a1,s5
 5b8:	855a                	mv	a0,s6
 5ba:	e49ff0ef          	jal	ra,402 <putc>
        putc(fd, c0);
 5be:	85ca                	mv	a1,s2
 5c0:	855a                	mv	a0,s6
 5c2:	e41ff0ef          	jal	ra,402 <putc>
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b7b9                	j	516 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	008b8913          	addi	s2,s7,8
 5ce:	4685                	li	a3,1
 5d0:	4629                	li	a2,10
 5d2:	000bb583          	ld	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	e49ff0ef          	jal	ra,420 <printint>
        i += 1;
 5dc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
        i += 1;
 5e2:	bf15                	j	516 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e4:	03860563          	beq	a2,s8,60e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e8:	07b60963          	beq	a2,s11,65a <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ec:	07800793          	li	a5,120
 5f0:	fcf613e3          	bne	a2,a5,5b6 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	e1fff0ef          	jal	ra,420 <printint>
        i += 2;
 606:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	b729                	j	516 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	008b8913          	addi	s2,s7,8
 612:	4685                	li	a3,1
 614:	4629                	li	a2,10
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e05ff0ef          	jal	ra,420 <printint>
        i += 2;
 620:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
        i += 2;
 626:	bdc5                	j	516 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000be583          	lwu	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	debff0ef          	jal	ra,420 <printint>
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bde1                	j	516 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b8913          	addi	s2,s7,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000bb583          	ld	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	dd3ff0ef          	jal	ra,420 <printint>
        i += 1;
 652:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
        i += 1;
 658:	bd7d                	j	516 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b8913          	addi	s2,s7,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	db9ff0ef          	jal	ra,420 <printint>
        i += 2;
 66c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	b555                	j	516 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4641                	li	a2,16
 67c:	000be583          	lwu	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	d9fff0ef          	jal	ra,420 <printint>
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	b571                	j	516 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	008b8913          	addi	s2,s7,8
 690:	4681                	li	a3,0
 692:	4641                	li	a2,16
 694:	000bb583          	ld	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	d87ff0ef          	jal	ra,420 <printint>
        i += 1;
 69e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 1;
 6a4:	bd8d                	j	516 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6a6:	008b8793          	addi	a5,s7,8
 6aa:	f8f43423          	sd	a5,-120(s0)
 6ae:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b2:	03000593          	li	a1,48
 6b6:	855a                	mv	a0,s6
 6b8:	d4bff0ef          	jal	ra,402 <putc>
  putc(fd, 'x');
 6bc:	07800593          	li	a1,120
 6c0:	855a                	mv	a0,s6
 6c2:	d41ff0ef          	jal	ra,402 <putc>
 6c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c8:	03c9d793          	srli	a5,s3,0x3c
 6cc:	97e6                	add	a5,a5,s9
 6ce:	0007c583          	lbu	a1,0(a5)
 6d2:	855a                	mv	a0,s6
 6d4:	d2fff0ef          	jal	ra,402 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d8:	0992                	slli	s3,s3,0x4
 6da:	397d                	addiw	s2,s2,-1
 6dc:	fe0916e3          	bnez	s2,6c8 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 6e0:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bd05                	j	516 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	000bc583          	lbu	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	d11ff0ef          	jal	ra,402 <putc>
 6f6:	8bca                	mv	s7,s2
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	bd31                	j	516 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6fc:	008b8993          	addi	s3,s7,8
 700:	000bb903          	ld	s2,0(s7)
 704:	00090f63          	beqz	s2,722 <vprintf+0x266>
        for(; *s; s++)
 708:	00094583          	lbu	a1,0(s2)
 70c:	c195                	beqz	a1,730 <vprintf+0x274>
          putc(fd, *s);
 70e:	855a                	mv	a0,s6
 710:	cf3ff0ef          	jal	ra,402 <putc>
        for(; *s; s++)
 714:	0905                	addi	s2,s2,1
 716:	00094583          	lbu	a1,0(s2)
 71a:	f9f5                	bnez	a1,70e <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 71c:	8bce                	mv	s7,s3
      state = 0;
 71e:	4981                	li	s3,0
 720:	bbdd                	j	516 <vprintf+0x5a>
          s = "(null)";
 722:	00000917          	auipc	s2,0x0
 726:	27690913          	addi	s2,s2,630 # 998 <malloc+0x160>
        for(; *s; s++)
 72a:	02800593          	li	a1,40
 72e:	b7c5                	j	70e <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 730:	8bce                	mv	s7,s3
      state = 0;
 732:	4981                	li	s3,0
 734:	b3cd                	j	516 <vprintf+0x5a>
    }
  }
}
 736:	70e6                	ld	ra,120(sp)
 738:	7446                	ld	s0,112(sp)
 73a:	74a6                	ld	s1,104(sp)
 73c:	7906                	ld	s2,96(sp)
 73e:	69e6                	ld	s3,88(sp)
 740:	6a46                	ld	s4,80(sp)
 742:	6aa6                	ld	s5,72(sp)
 744:	6b06                	ld	s6,64(sp)
 746:	7be2                	ld	s7,56(sp)
 748:	7c42                	ld	s8,48(sp)
 74a:	7ca2                	ld	s9,40(sp)
 74c:	7d02                	ld	s10,32(sp)
 74e:	6de2                	ld	s11,24(sp)
 750:	6109                	addi	sp,sp,128
 752:	8082                	ret

0000000000000754 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 754:	715d                	addi	sp,sp,-80
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e010                	sd	a2,0(s0)
 75e:	e414                	sd	a3,8(s0)
 760:	e818                	sd	a4,16(s0)
 762:	ec1c                	sd	a5,24(s0)
 764:	03043023          	sd	a6,32(s0)
 768:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 770:	8622                	mv	a2,s0
 772:	d4bff0ef          	jal	ra,4bc <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void
printf(const char *fmt, ...)
{
 77e:	711d                	addi	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	d19ff0ef          	jal	ra,4bc <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6125                	addi	sp,sp,96
 7ae:	8082                	ret

00000000000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	1141                	addi	sp,sp,-16
 7b2:	e422                	sd	s0,8(sp)
 7b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ba:	00001797          	auipc	a5,0x1
 7be:	8567b783          	ld	a5,-1962(a5) # 1010 <freep>
 7c2:	a805                	j	7f2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c4:	4618                	lw	a4,8(a2)
 7c6:	9db9                	addw	a1,a1,a4
 7c8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	6398                	ld	a4,0(a5)
 7ce:	6318                	ld	a4,0(a4)
 7d0:	fee53823          	sd	a4,-16(a0)
 7d4:	a091                	j	818 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d6:	ff852703          	lw	a4,-8(a0)
 7da:	9e39                	addw	a2,a2,a4
 7dc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7de:	ff053703          	ld	a4,-16(a0)
 7e2:	e398                	sd	a4,0(a5)
 7e4:	a099                	j	82a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e6:	6398                	ld	a4,0(a5)
 7e8:	00e7e463          	bltu	a5,a4,7f0 <free+0x40>
 7ec:	00e6ea63          	bltu	a3,a4,800 <free+0x50>
{
 7f0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f2:	fed7fae3          	bgeu	a5,a3,7e6 <free+0x36>
 7f6:	6398                	ld	a4,0(a5)
 7f8:	00e6e463          	bltu	a3,a4,800 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fc:	fee7eae3          	bltu	a5,a4,7f0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 800:	ff852583          	lw	a1,-8(a0)
 804:	6390                	ld	a2,0(a5)
 806:	02059713          	slli	a4,a1,0x20
 80a:	9301                	srli	a4,a4,0x20
 80c:	0712                	slli	a4,a4,0x4
 80e:	9736                	add	a4,a4,a3
 810:	fae60ae3          	beq	a2,a4,7c4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 814:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 818:	4790                	lw	a2,8(a5)
 81a:	02061713          	slli	a4,a2,0x20
 81e:	9301                	srli	a4,a4,0x20
 820:	0712                	slli	a4,a4,0x4
 822:	973e                	add	a4,a4,a5
 824:	fae689e3          	beq	a3,a4,7d6 <free+0x26>
  } else
    p->s.ptr = bp;
 828:	e394                	sd	a3,0(a5)
  freep = p;
 82a:	00000717          	auipc	a4,0x0
 82e:	7ef73323          	sd	a5,2022(a4) # 1010 <freep>
}
 832:	6422                	ld	s0,8(sp)
 834:	0141                	addi	sp,sp,16
 836:	8082                	ret

0000000000000838 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 838:	7139                	addi	sp,sp,-64
 83a:	fc06                	sd	ra,56(sp)
 83c:	f822                	sd	s0,48(sp)
 83e:	f426                	sd	s1,40(sp)
 840:	f04a                	sd	s2,32(sp)
 842:	ec4e                	sd	s3,24(sp)
 844:	e852                	sd	s4,16(sp)
 846:	e456                	sd	s5,8(sp)
 848:	e05a                	sd	s6,0(sp)
 84a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84c:	02051493          	slli	s1,a0,0x20
 850:	9081                	srli	s1,s1,0x20
 852:	04bd                	addi	s1,s1,15
 854:	8091                	srli	s1,s1,0x4
 856:	0014899b          	addiw	s3,s1,1
 85a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 85c:	00000517          	auipc	a0,0x0
 860:	7b453503          	ld	a0,1972(a0) # 1010 <freep>
 864:	c515                	beqz	a0,890 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 866:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 868:	4798                	lw	a4,8(a5)
 86a:	02977f63          	bgeu	a4,s1,8a8 <malloc+0x70>
 86e:	8a4e                	mv	s4,s3
 870:	0009871b          	sext.w	a4,s3
 874:	6685                	lui	a3,0x1
 876:	00d77363          	bgeu	a4,a3,87c <malloc+0x44>
 87a:	6a05                	lui	s4,0x1
 87c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 880:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 884:	00000917          	auipc	s2,0x0
 888:	78c90913          	addi	s2,s2,1932 # 1010 <freep>
  if(p == SBRK_ERROR)
 88c:	5afd                	li	s5,-1
 88e:	a0bd                	j	8fc <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 890:	00000797          	auipc	a5,0x0
 894:	79078793          	addi	a5,a5,1936 # 1020 <base>
 898:	00000717          	auipc	a4,0x0
 89c:	76f73c23          	sd	a5,1912(a4) # 1010 <freep>
 8a0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a6:	b7e1                	j	86e <malloc+0x36>
      if(p->s.size == nunits)
 8a8:	02e48b63          	beq	s1,a4,8de <malloc+0xa6>
        p->s.size -= nunits;
 8ac:	4137073b          	subw	a4,a4,s3
 8b0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b2:	1702                	slli	a4,a4,0x20
 8b4:	9301                	srli	a4,a4,0x20
 8b6:	0712                	slli	a4,a4,0x4
 8b8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8be:	00000717          	auipc	a4,0x0
 8c2:	74a73923          	sd	a0,1874(a4) # 1010 <freep>
      return (void*)(p + 1);
 8c6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ca:	70e2                	ld	ra,56(sp)
 8cc:	7442                	ld	s0,48(sp)
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	7902                	ld	s2,32(sp)
 8d2:	69e2                	ld	s3,24(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
 8da:	6121                	addi	sp,sp,64
 8dc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8de:	6398                	ld	a4,0(a5)
 8e0:	e118                	sd	a4,0(a0)
 8e2:	bff1                	j	8be <malloc+0x86>
  hp->s.size = nu;
 8e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e8:	0541                	addi	a0,a0,16
 8ea:	ec7ff0ef          	jal	ra,7b0 <free>
  return freep;
 8ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f2:	dd61                	beqz	a0,8ca <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f6:	4798                	lw	a4,8(a5)
 8f8:	fa9778e3          	bgeu	a4,s1,8a8 <malloc+0x70>
    if(p == freep)
 8fc:	00093703          	ld	a4,0(s2)
 900:	853e                	mv	a0,a5
 902:	fef719e3          	bne	a4,a5,8f4 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 906:	8552                	mv	a0,s4
 908:	a1fff0ef          	jal	ra,326 <sbrk>
  if(p == SBRK_ERROR)
 90c:	fd551ce3          	bne	a0,s5,8e4 <malloc+0xac>
        return 0;
 910:	4501                	li	a0,0
 912:	bf65                	j	8ca <malloc+0x92>
