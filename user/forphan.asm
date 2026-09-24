
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";
  
  if ((fd = open(ff, O_CREATE|O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	91050513          	addi	a0,a0,-1776 # 920 <malloc+0xe0>
  18:	38a000ef          	jal	ra,3a2 <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if(fstat(fd, &st) < 0){
  20:	fc840593          	addi	a1,s0,-56
  24:	396000ef          	jal	ra,3ba <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	8f450513          	addi	a0,a0,-1804 # 920 <malloc+0xe0>
  34:	37e000ef          	jal	ra,3b2 <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	8e250513          	addi	a0,a0,-1822 # 920 <malloc+0xe0>
  46:	35c000ef          	jal	ra,3a2 <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	92650513          	addi	a0,a0,-1754 # 978 <malloc+0x138>
  5a:	72c000ef          	jal	ra,786 <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	302000ef          	jal	ra,362 <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	8c250513          	addi	a0,a0,-1854 # 928 <malloc+0xe8>
  6e:	718000ef          	jal	ra,786 <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	2ee000ef          	jal	ra,362 <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	8c868693          	addi	a3,a3,-1848 # 940 <malloc+0x100>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	8c658593          	addi	a1,a1,-1850 # 948 <malloc+0x108>
  8a:	4509                	li	a0,2
  8c:	6d0000ef          	jal	ra,75c <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2d0000ef          	jal	ra,362 <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	8c850513          	addi	a0,a0,-1848 # 960 <malloc+0x120>
  a0:	6e6000ef          	jal	ra,786 <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2bc000ef          	jal	ra,362 <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	8e250513          	addi	a0,a0,-1822 # 990 <malloc+0x150>
  b6:	6d0000ef          	jal	ra,786 <printf>
  // sit around until killed
  for(;;) pause(1000);
  ba:	3e800513          	li	a0,1000
  be:	334000ef          	jal	ra,3f2 <pause>
  c2:	bfe5                	j	ba <main+0xba>

00000000000000c4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  cc:	f35ff0ef          	jal	ra,0 <main>
  exit(r);
  d0:	292000ef          	jal	ra,362 <exit>

00000000000000d4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  da:	87aa                	mv	a5,a0
  dc:	0585                	addi	a1,a1,1
  de:	0785                	addi	a5,a5,1
  e0:	fff5c703          	lbu	a4,-1(a1)
  e4:	fee78fa3          	sb	a4,-1(a5)
  e8:	fb75                	bnez	a4,dc <strcpy+0x8>
    ;
  return os;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb91                	beqz	a5,10e <strcmp+0x1e>
  fc:	0005c703          	lbu	a4,0(a1)
 100:	00f71763          	bne	a4,a5,10e <strcmp+0x1e>
    p++, q++;
 104:	0505                	addi	a0,a0,1
 106:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbe5                	bnez	a5,fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 10e:	0005c503          	lbu	a0,0(a1)
}
 112:	40a7853b          	subw	a0,a5,a0
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strlen>:

uint
strlen(const char *s)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cf91                	beqz	a5,142 <strlen+0x26>
 128:	0505                	addi	a0,a0,1
 12a:	87aa                	mv	a5,a0
 12c:	4685                	li	a3,1
 12e:	9e89                	subw	a3,a3,a0
 130:	00f6853b          	addw	a0,a3,a5
 134:	0785                	addi	a5,a5,1
 136:	fff7c703          	lbu	a4,-1(a5)
 13a:	fb7d                	bnez	a4,130 <strlen+0x14>
    ;
  return n;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret
  for(n = 0; s[n]; n++)
 142:	4501                	li	a0,0
 144:	bfe5                	j	13c <strlen+0x20>

0000000000000146 <memset>:

void*
memset(void *dst, int c, uint n)
{
 146:	1141                	addi	sp,sp,-16
 148:	e422                	sd	s0,8(sp)
 14a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 14c:	ce09                	beqz	a2,166 <memset+0x20>
 14e:	87aa                	mv	a5,a0
 150:	fff6071b          	addiw	a4,a2,-1
 154:	1702                	slli	a4,a4,0x20
 156:	9301                	srli	a4,a4,0x20
 158:	0705                	addi	a4,a4,1
 15a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 15c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 160:	0785                	addi	a5,a5,1
 162:	fee79de3          	bne	a5,a4,15c <memset+0x16>
  }
  return dst;
}
 166:	6422                	ld	s0,8(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret

000000000000016c <strchr>:

char*
strchr(const char *s, char c)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
  for(; *s; s++)
 172:	00054783          	lbu	a5,0(a0)
 176:	cb99                	beqz	a5,18c <strchr+0x20>
    if(*s == c)
 178:	00f58763          	beq	a1,a5,186 <strchr+0x1a>
  for(; *s; s++)
 17c:	0505                	addi	a0,a0,1
 17e:	00054783          	lbu	a5,0(a0)
 182:	fbfd                	bnez	a5,178 <strchr+0xc>
      return (char*)s;
  return 0;
 184:	4501                	li	a0,0
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  return 0;
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strchr+0x1a>

0000000000000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	711d                	addi	sp,sp,-96
 192:	ec86                	sd	ra,88(sp)
 194:	e8a2                	sd	s0,80(sp)
 196:	e4a6                	sd	s1,72(sp)
 198:	e0ca                	sd	s2,64(sp)
 19a:	fc4e                	sd	s3,56(sp)
 19c:	f852                	sd	s4,48(sp)
 19e:	f456                	sd	s5,40(sp)
 1a0:	f05a                	sd	s6,32(sp)
 1a2:	ec5e                	sd	s7,24(sp)
 1a4:	1080                	addi	s0,sp,96
 1a6:	8baa                	mv	s7,a0
 1a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1aa:	892a                	mv	s2,a0
 1ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ae:	4aa9                	li	s5,10
 1b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1b2:	89a6                	mv	s3,s1
 1b4:	2485                	addiw	s1,s1,1
 1b6:	0344d663          	bge	s1,s4,1e2 <gets+0x52>
    cc = read(0, &c, 1);
 1ba:	4605                	li	a2,1
 1bc:	faf40593          	addi	a1,s0,-81
 1c0:	4501                	li	a0,0
 1c2:	1b8000ef          	jal	ra,37a <read>
    if(cc < 1)
 1c6:	00a05e63          	blez	a0,1e2 <gets+0x52>
    buf[i++] = c;
 1ca:	faf44783          	lbu	a5,-81(s0)
 1ce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d2:	01578763          	beq	a5,s5,1e0 <gets+0x50>
 1d6:	0905                	addi	s2,s2,1
 1d8:	fd679de3          	bne	a5,s6,1b2 <gets+0x22>
  for(i=0; i+1 < max; ){
 1dc:	89a6                	mv	s3,s1
 1de:	a011                	j	1e2 <gets+0x52>
 1e0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1e2:	99de                	add	s3,s3,s7
 1e4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e8:	855e                	mv	a0,s7
 1ea:	60e6                	ld	ra,88(sp)
 1ec:	6446                	ld	s0,80(sp)
 1ee:	64a6                	ld	s1,72(sp)
 1f0:	6906                	ld	s2,64(sp)
 1f2:	79e2                	ld	s3,56(sp)
 1f4:	7a42                	ld	s4,48(sp)
 1f6:	7aa2                	ld	s5,40(sp)
 1f8:	7b02                	ld	s6,32(sp)
 1fa:	6be2                	ld	s7,24(sp)
 1fc:	6125                	addi	sp,sp,96
 1fe:	8082                	ret

0000000000000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	1101                	addi	sp,sp,-32
 202:	ec06                	sd	ra,24(sp)
 204:	e822                	sd	s0,16(sp)
 206:	e426                	sd	s1,8(sp)
 208:	e04a                	sd	s2,0(sp)
 20a:	1000                	addi	s0,sp,32
 20c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	4581                	li	a1,0
 210:	192000ef          	jal	ra,3a2 <open>
  if(fd < 0)
 214:	02054163          	bltz	a0,236 <stat+0x36>
 218:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21a:	85ca                	mv	a1,s2
 21c:	19e000ef          	jal	ra,3ba <fstat>
 220:	892a                	mv	s2,a0
  close(fd);
 222:	8526                	mv	a0,s1
 224:	166000ef          	jal	ra,38a <close>
  return r;
}
 228:	854a                	mv	a0,s2
 22a:	60e2                	ld	ra,24(sp)
 22c:	6442                	ld	s0,16(sp)
 22e:	64a2                	ld	s1,8(sp)
 230:	6902                	ld	s2,0(sp)
 232:	6105                	addi	sp,sp,32
 234:	8082                	ret
    return -1;
 236:	597d                	li	s2,-1
 238:	bfc5                	j	228 <stat+0x28>

000000000000023a <atoi>:

int
atoi(const char *s)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 240:	00054603          	lbu	a2,0(a0)
 244:	fd06079b          	addiw	a5,a2,-48
 248:	0ff7f793          	andi	a5,a5,255
 24c:	4725                	li	a4,9
 24e:	02f76963          	bltu	a4,a5,280 <atoi+0x46>
 252:	86aa                	mv	a3,a0
  n = 0;
 254:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 256:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 258:	0685                	addi	a3,a3,1
 25a:	0025179b          	slliw	a5,a0,0x2
 25e:	9fa9                	addw	a5,a5,a0
 260:	0017979b          	slliw	a5,a5,0x1
 264:	9fb1                	addw	a5,a5,a2
 266:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 26a:	0006c603          	lbu	a2,0(a3)
 26e:	fd06071b          	addiw	a4,a2,-48
 272:	0ff77713          	andi	a4,a4,255
 276:	fee5f1e3          	bgeu	a1,a4,258 <atoi+0x1e>
  return n;
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
  n = 0;
 280:	4501                	li	a0,0
 282:	bfe5                	j	27a <atoi+0x40>

0000000000000284 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 28a:	02b57663          	bgeu	a0,a1,2b6 <memmove+0x32>
    while(n-- > 0)
 28e:	02c05163          	blez	a2,2b0 <memmove+0x2c>
 292:	fff6079b          	addiw	a5,a2,-1
 296:	1782                	slli	a5,a5,0x20
 298:	9381                	srli	a5,a5,0x20
 29a:	0785                	addi	a5,a5,1
 29c:	97aa                	add	a5,a5,a0
  dst = vdst;
 29e:	872a                	mv	a4,a0
      *dst++ = *src++;
 2a0:	0585                	addi	a1,a1,1
 2a2:	0705                	addi	a4,a4,1
 2a4:	fff5c683          	lbu	a3,-1(a1)
 2a8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ac:	fee79ae3          	bne	a5,a4,2a0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
    dst += n;
 2b6:	00c50733          	add	a4,a0,a2
    src += n;
 2ba:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2bc:	fec05ae3          	blez	a2,2b0 <memmove+0x2c>
 2c0:	fff6079b          	addiw	a5,a2,-1
 2c4:	1782                	slli	a5,a5,0x20
 2c6:	9381                	srli	a5,a5,0x20
 2c8:	fff7c793          	not	a5,a5
 2cc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ce:	15fd                	addi	a1,a1,-1
 2d0:	177d                	addi	a4,a4,-1
 2d2:	0005c683          	lbu	a3,0(a1)
 2d6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2da:	fee79ae3          	bne	a5,a4,2ce <memmove+0x4a>
 2de:	bfc9                	j	2b0 <memmove+0x2c>

00000000000002e0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e6:	ca05                	beqz	a2,316 <memcmp+0x36>
 2e8:	fff6069b          	addiw	a3,a2,-1
 2ec:	1682                	slli	a3,a3,0x20
 2ee:	9281                	srli	a3,a3,0x20
 2f0:	0685                	addi	a3,a3,1
 2f2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	0005c703          	lbu	a4,0(a1)
 2fc:	00e79863          	bne	a5,a4,30c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 300:	0505                	addi	a0,a0,1
    p2++;
 302:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 304:	fed518e3          	bne	a0,a3,2f4 <memcmp+0x14>
  }
  return 0;
 308:	4501                	li	a0,0
 30a:	a019                	j	310 <memcmp+0x30>
      return *p1 - *p2;
 30c:	40e7853b          	subw	a0,a5,a4
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  return 0;
 316:	4501                	li	a0,0
 318:	bfe5                	j	310 <memcmp+0x30>

000000000000031a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e406                	sd	ra,8(sp)
 31e:	e022                	sd	s0,0(sp)
 320:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 322:	f63ff0ef          	jal	ra,284 <memmove>
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <sbrk>:

char *
sbrk(int n) {
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 336:	4585                	li	a1,1
 338:	0b2000ef          	jal	ra,3ea <sys_sbrk>
}
 33c:	60a2                	ld	ra,8(sp)
 33e:	6402                	ld	s0,0(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret

0000000000000344 <sbrklazy>:

char *
sbrklazy(int n) {
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 34c:	4589                	li	a1,2
 34e:	09c000ef          	jal	ra,3ea <sys_sbrk>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 35a:	4885                	li	a7,1
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exit>:
.global exit
exit:
 li a7, SYS_exit
 362:	4889                	li	a7,2
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <wait>:
.global wait
wait:
 li a7, SYS_wait
 36a:	488d                	li	a7,3
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 372:	4891                	li	a7,4
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <read>:
.global read
read:
 li a7, SYS_read
 37a:	4895                	li	a7,5
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <write>:
.global write
write:
 li a7, SYS_write
 382:	48c1                	li	a7,16
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <close>:
.global close
close:
 li a7, SYS_close
 38a:	48d5                	li	a7,21
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <kill>:
.global kill
kill:
 li a7, SYS_kill
 392:	4899                	li	a7,6
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <exec>:
.global exec
exec:
 li a7, SYS_exec
 39a:	489d                	li	a7,7
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <open>:
.global open
open:
 li a7, SYS_open
 3a2:	48bd                	li	a7,15
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3aa:	48c5                	li	a7,17
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b2:	48c9                	li	a7,18
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ba:	48a1                	li	a7,8
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <link>:
.global link
link:
 li a7, SYS_link
 3c2:	48cd                	li	a7,19
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ca:	48d1                	li	a7,20
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d2:	48a5                	li	a7,9
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <dup>:
.global dup
dup:
 li a7, SYS_dup
 3da:	48a9                	li	a7,10
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e2:	48ad                	li	a7,11
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3ea:	48b1                	li	a7,12
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3f2:	48b5                	li	a7,13
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3fa:	48b9                	li	a7,14
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 402:	48d9                	li	a7,22
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40a:	1101                	addi	sp,sp,-32
 40c:	ec06                	sd	ra,24(sp)
 40e:	e822                	sd	s0,16(sp)
 410:	1000                	addi	s0,sp,32
 412:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 416:	4605                	li	a2,1
 418:	fef40593          	addi	a1,s0,-17
 41c:	f67ff0ef          	jal	ra,382 <write>
}
 420:	60e2                	ld	ra,24(sp)
 422:	6442                	ld	s0,16(sp)
 424:	6105                	addi	sp,sp,32
 426:	8082                	ret

0000000000000428 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 428:	715d                	addi	sp,sp,-80
 42a:	e486                	sd	ra,72(sp)
 42c:	e0a2                	sd	s0,64(sp)
 42e:	fc26                	sd	s1,56(sp)
 430:	f84a                	sd	s2,48(sp)
 432:	f44e                	sd	s3,40(sp)
 434:	0880                	addi	s0,sp,80
 436:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 438:	c299                	beqz	a3,43e <printint+0x16>
 43a:	0805c163          	bltz	a1,4bc <printint+0x94>
  neg = 0;
 43e:	4881                	li	a7,0
 440:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 444:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 446:	00000517          	auipc	a0,0x0
 44a:	57250513          	addi	a0,a0,1394 # 9b8 <digits>
 44e:	883e                	mv	a6,a5
 450:	2785                	addiw	a5,a5,1
 452:	02c5f733          	remu	a4,a1,a2
 456:	972a                	add	a4,a4,a0
 458:	00074703          	lbu	a4,0(a4)
 45c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 460:	872e                	mv	a4,a1
 462:	02c5d5b3          	divu	a1,a1,a2
 466:	0685                	addi	a3,a3,1
 468:	fec773e3          	bgeu	a4,a2,44e <printint+0x26>
  if(neg)
 46c:	00088b63          	beqz	a7,482 <printint+0x5a>
    buf[i++] = '-';
 470:	fd040713          	addi	a4,s0,-48
 474:	97ba                	add	a5,a5,a4
 476:	02d00713          	li	a4,45
 47a:	fee78423          	sb	a4,-24(a5)
 47e:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 482:	02f05663          	blez	a5,4ae <printint+0x86>
 486:	fb840713          	addi	a4,s0,-72
 48a:	00f704b3          	add	s1,a4,a5
 48e:	fff70993          	addi	s3,a4,-1
 492:	99be                	add	s3,s3,a5
 494:	37fd                	addiw	a5,a5,-1
 496:	1782                	slli	a5,a5,0x20
 498:	9381                	srli	a5,a5,0x20
 49a:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 49e:	fff4c583          	lbu	a1,-1(s1)
 4a2:	854a                	mv	a0,s2
 4a4:	f67ff0ef          	jal	ra,40a <putc>
  while(--i >= 0)
 4a8:	14fd                	addi	s1,s1,-1
 4aa:	ff349ae3          	bne	s1,s3,49e <printint+0x76>
}
 4ae:	60a6                	ld	ra,72(sp)
 4b0:	6406                	ld	s0,64(sp)
 4b2:	74e2                	ld	s1,56(sp)
 4b4:	7942                	ld	s2,48(sp)
 4b6:	79a2                	ld	s3,40(sp)
 4b8:	6161                	addi	sp,sp,80
 4ba:	8082                	ret
    x = -xx;
 4bc:	40b005b3          	neg	a1,a1
    neg = 1;
 4c0:	4885                	li	a7,1
    x = -xx;
 4c2:	bfbd                	j	440 <printint+0x18>

00000000000004c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c4:	7119                	addi	sp,sp,-128
 4c6:	fc86                	sd	ra,120(sp)
 4c8:	f8a2                	sd	s0,112(sp)
 4ca:	f4a6                	sd	s1,104(sp)
 4cc:	f0ca                	sd	s2,96(sp)
 4ce:	ecce                	sd	s3,88(sp)
 4d0:	e8d2                	sd	s4,80(sp)
 4d2:	e4d6                	sd	s5,72(sp)
 4d4:	e0da                	sd	s6,64(sp)
 4d6:	fc5e                	sd	s7,56(sp)
 4d8:	f862                	sd	s8,48(sp)
 4da:	f466                	sd	s9,40(sp)
 4dc:	f06a                	sd	s10,32(sp)
 4de:	ec6e                	sd	s11,24(sp)
 4e0:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e2:	0005c903          	lbu	s2,0(a1)
 4e6:	24090c63          	beqz	s2,73e <vprintf+0x27a>
 4ea:	8b2a                	mv	s6,a0
 4ec:	8a2e                	mv	s4,a1
 4ee:	8bb2                	mv	s7,a2
  state = 0;
 4f0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4f2:	4481                	li	s1,0
 4f4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4f6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4fa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4fe:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 502:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 506:	00000c97          	auipc	s9,0x0
 50a:	4b2c8c93          	addi	s9,s9,1202 # 9b8 <digits>
 50e:	a005                	j	52e <vprintf+0x6a>
        putc(fd, c0);
 510:	85ca                	mv	a1,s2
 512:	855a                	mv	a0,s6
 514:	ef7ff0ef          	jal	ra,40a <putc>
 518:	a019                	j	51e <vprintf+0x5a>
    } else if(state == '%'){
 51a:	03598263          	beq	s3,s5,53e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 51e:	2485                	addiw	s1,s1,1
 520:	8726                	mv	a4,s1
 522:	009a07b3          	add	a5,s4,s1
 526:	0007c903          	lbu	s2,0(a5)
 52a:	20090a63          	beqz	s2,73e <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 52e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 532:	fe0994e3          	bnez	s3,51a <vprintf+0x56>
      if(c0 == '%'){
 536:	fd579de3          	bne	a5,s5,510 <vprintf+0x4c>
        state = '%';
 53a:	89be                	mv	s3,a5
 53c:	b7cd                	j	51e <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 53e:	c3c1                	beqz	a5,5be <vprintf+0xfa>
 540:	00ea06b3          	add	a3,s4,a4
 544:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 548:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 54a:	c681                	beqz	a3,552 <vprintf+0x8e>
 54c:	9752                	add	a4,a4,s4
 54e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 552:	03878e63          	beq	a5,s8,58e <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 556:	05a78863          	beq	a5,s10,5a6 <vprintf+0xe2>
      } else if(c0 == 'u'){
 55a:	0db78b63          	beq	a5,s11,630 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 55e:	07800713          	li	a4,120
 562:	10e78d63          	beq	a5,a4,67c <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 566:	07000713          	li	a4,112
 56a:	14e78263          	beq	a5,a4,6ae <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 56e:	06300713          	li	a4,99
 572:	16e78f63          	beq	a5,a4,6f0 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 576:	07300713          	li	a4,115
 57a:	18e78563          	beq	a5,a4,704 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 57e:	05579063          	bne	a5,s5,5be <vprintf+0xfa>
        putc(fd, '%');
 582:	85d6                	mv	a1,s5
 584:	855a                	mv	a0,s6
 586:	e85ff0ef          	jal	ra,40a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 58a:	4981                	li	s3,0
 58c:	bf49                	j	51e <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 58e:	008b8913          	addi	s2,s7,8
 592:	4685                	li	a3,1
 594:	4629                	li	a2,10
 596:	000ba583          	lw	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e8dff0ef          	jal	ra,428 <printint>
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bfad                	j	51e <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5a6:	03868663          	beq	a3,s8,5d2 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5aa:	05a68163          	beq	a3,s10,5ec <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 5ae:	09b68d63          	beq	a3,s11,648 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5b2:	03a68f63          	beq	a3,s10,5f0 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 5b6:	07800793          	li	a5,120
 5ba:	0cf68d63          	beq	a3,a5,694 <vprintf+0x1d0>
        putc(fd, '%');
 5be:	85d6                	mv	a1,s5
 5c0:	855a                	mv	a0,s6
 5c2:	e49ff0ef          	jal	ra,40a <putc>
        putc(fd, c0);
 5c6:	85ca                	mv	a1,s2
 5c8:	855a                	mv	a0,s6
 5ca:	e41ff0ef          	jal	ra,40a <putc>
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b7b9                	j	51e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000bb583          	ld	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	e49ff0ef          	jal	ra,428 <printint>
        i += 1;
 5e4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
        i += 1;
 5ea:	bf15                	j	51e <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ec:	03860563          	beq	a2,s8,616 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5f0:	07b60963          	beq	a2,s11,662 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5f4:	07800793          	li	a5,120
 5f8:	fcf613e3          	bne	a2,a5,5be <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	008b8913          	addi	s2,s7,8
 600:	4681                	li	a3,0
 602:	4641                	li	a2,16
 604:	000bb583          	ld	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	e1fff0ef          	jal	ra,428 <printint>
        i += 2;
 60e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 610:	8bca                	mv	s7,s2
      state = 0;
 612:	4981                	li	s3,0
        i += 2;
 614:	b729                	j	51e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	008b8913          	addi	s2,s7,8
 61a:	4685                	li	a3,1
 61c:	4629                	li	a2,10
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e05ff0ef          	jal	ra,428 <printint>
        i += 2;
 628:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
        i += 2;
 62e:	bdc5                	j	51e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 630:	008b8913          	addi	s2,s7,8
 634:	4681                	li	a3,0
 636:	4629                	li	a2,10
 638:	000be583          	lwu	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	debff0ef          	jal	ra,428 <printint>
 642:	8bca                	mv	s7,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	bde1                	j	51e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	008b8913          	addi	s2,s7,8
 64c:	4681                	li	a3,0
 64e:	4629                	li	a2,10
 650:	000bb583          	ld	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	dd3ff0ef          	jal	ra,428 <printint>
        i += 1;
 65a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 65c:	8bca                	mv	s7,s2
      state = 0;
 65e:	4981                	li	s3,0
        i += 1;
 660:	bd7d                	j	51e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	008b8913          	addi	s2,s7,8
 666:	4681                	li	a3,0
 668:	4629                	li	a2,10
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	db9ff0ef          	jal	ra,428 <printint>
        i += 2;
 674:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
        i += 2;
 67a:	b555                	j	51e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 67c:	008b8913          	addi	s2,s7,8
 680:	4681                	li	a3,0
 682:	4641                	li	a2,16
 684:	000be583          	lwu	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	d9fff0ef          	jal	ra,428 <printint>
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	b571                	j	51e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	008b8913          	addi	s2,s7,8
 698:	4681                	li	a3,0
 69a:	4641                	li	a2,16
 69c:	000bb583          	ld	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	d87ff0ef          	jal	ra,428 <printint>
        i += 1;
 6a6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
        i += 1;
 6ac:	bd8d                	j	51e <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6ae:	008b8793          	addi	a5,s7,8
 6b2:	f8f43423          	sd	a5,-120(s0)
 6b6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ba:	03000593          	li	a1,48
 6be:	855a                	mv	a0,s6
 6c0:	d4bff0ef          	jal	ra,40a <putc>
  putc(fd, 'x');
 6c4:	07800593          	li	a1,120
 6c8:	855a                	mv	a0,s6
 6ca:	d41ff0ef          	jal	ra,40a <putc>
 6ce:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d0:	03c9d793          	srli	a5,s3,0x3c
 6d4:	97e6                	add	a5,a5,s9
 6d6:	0007c583          	lbu	a1,0(a5)
 6da:	855a                	mv	a0,s6
 6dc:	d2fff0ef          	jal	ra,40a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e0:	0992                	slli	s3,s3,0x4
 6e2:	397d                	addiw	s2,s2,-1
 6e4:	fe0916e3          	bnez	s2,6d0 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 6e8:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bd05                	j	51e <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 6f0:	008b8913          	addi	s2,s7,8
 6f4:	000bc583          	lbu	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	d11ff0ef          	jal	ra,40a <putc>
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	bd31                	j	51e <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 704:	008b8993          	addi	s3,s7,8
 708:	000bb903          	ld	s2,0(s7)
 70c:	00090f63          	beqz	s2,72a <vprintf+0x266>
        for(; *s; s++)
 710:	00094583          	lbu	a1,0(s2)
 714:	c195                	beqz	a1,738 <vprintf+0x274>
          putc(fd, *s);
 716:	855a                	mv	a0,s6
 718:	cf3ff0ef          	jal	ra,40a <putc>
        for(; *s; s++)
 71c:	0905                	addi	s2,s2,1
 71e:	00094583          	lbu	a1,0(s2)
 722:	f9f5                	bnez	a1,716 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 724:	8bce                	mv	s7,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	bbdd                	j	51e <vprintf+0x5a>
          s = "(null)";
 72a:	00000917          	auipc	s2,0x0
 72e:	28690913          	addi	s2,s2,646 # 9b0 <malloc+0x170>
        for(; *s; s++)
 732:	02800593          	li	a1,40
 736:	b7c5                	j	716 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 738:	8bce                	mv	s7,s3
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b3cd                	j	51e <vprintf+0x5a>
    }
  }
}
 73e:	70e6                	ld	ra,120(sp)
 740:	7446                	ld	s0,112(sp)
 742:	74a6                	ld	s1,104(sp)
 744:	7906                	ld	s2,96(sp)
 746:	69e6                	ld	s3,88(sp)
 748:	6a46                	ld	s4,80(sp)
 74a:	6aa6                	ld	s5,72(sp)
 74c:	6b06                	ld	s6,64(sp)
 74e:	7be2                	ld	s7,56(sp)
 750:	7c42                	ld	s8,48(sp)
 752:	7ca2                	ld	s9,40(sp)
 754:	7d02                	ld	s10,32(sp)
 756:	6de2                	ld	s11,24(sp)
 758:	6109                	addi	sp,sp,128
 75a:	8082                	ret

000000000000075c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75c:	715d                	addi	sp,sp,-80
 75e:	ec06                	sd	ra,24(sp)
 760:	e822                	sd	s0,16(sp)
 762:	1000                	addi	s0,sp,32
 764:	e010                	sd	a2,0(s0)
 766:	e414                	sd	a3,8(s0)
 768:	e818                	sd	a4,16(s0)
 76a:	ec1c                	sd	a5,24(s0)
 76c:	03043023          	sd	a6,32(s0)
 770:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 774:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 778:	8622                	mv	a2,s0
 77a:	d4bff0ef          	jal	ra,4c4 <vprintf>
}
 77e:	60e2                	ld	ra,24(sp)
 780:	6442                	ld	s0,16(sp)
 782:	6161                	addi	sp,sp,80
 784:	8082                	ret

0000000000000786 <printf>:

void
printf(const char *fmt, ...)
{
 786:	711d                	addi	sp,sp,-96
 788:	ec06                	sd	ra,24(sp)
 78a:	e822                	sd	s0,16(sp)
 78c:	1000                	addi	s0,sp,32
 78e:	e40c                	sd	a1,8(s0)
 790:	e810                	sd	a2,16(s0)
 792:	ec14                	sd	a3,24(s0)
 794:	f018                	sd	a4,32(s0)
 796:	f41c                	sd	a5,40(s0)
 798:	03043823          	sd	a6,48(s0)
 79c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a0:	00840613          	addi	a2,s0,8
 7a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a8:	85aa                	mv	a1,a0
 7aa:	4505                	li	a0,1
 7ac:	d19ff0ef          	jal	ra,4c4 <vprintf>
}
 7b0:	60e2                	ld	ra,24(sp)
 7b2:	6442                	ld	s0,16(sp)
 7b4:	6125                	addi	sp,sp,96
 7b6:	8082                	ret

00000000000007b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b8:	1141                	addi	sp,sp,-16
 7ba:	e422                	sd	s0,8(sp)
 7bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c2:	00001797          	auipc	a5,0x1
 7c6:	83e7b783          	ld	a5,-1986(a5) # 1000 <freep>
 7ca:	a805                	j	7fa <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7cc:	4618                	lw	a4,8(a2)
 7ce:	9db9                	addw	a1,a1,a4
 7d0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	6398                	ld	a4,0(a5)
 7d6:	6318                	ld	a4,0(a4)
 7d8:	fee53823          	sd	a4,-16(a0)
 7dc:	a091                	j	820 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7de:	ff852703          	lw	a4,-8(a0)
 7e2:	9e39                	addw	a2,a2,a4
 7e4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7e6:	ff053703          	ld	a4,-16(a0)
 7ea:	e398                	sd	a4,0(a5)
 7ec:	a099                	j	832 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ee:	6398                	ld	a4,0(a5)
 7f0:	00e7e463          	bltu	a5,a4,7f8 <free+0x40>
 7f4:	00e6ea63          	bltu	a3,a4,808 <free+0x50>
{
 7f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	fed7fae3          	bgeu	a5,a3,7ee <free+0x36>
 7fe:	6398                	ld	a4,0(a5)
 800:	00e6e463          	bltu	a3,a4,808 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	fee7eae3          	bltu	a5,a4,7f8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 808:	ff852583          	lw	a1,-8(a0)
 80c:	6390                	ld	a2,0(a5)
 80e:	02059713          	slli	a4,a1,0x20
 812:	9301                	srli	a4,a4,0x20
 814:	0712                	slli	a4,a4,0x4
 816:	9736                	add	a4,a4,a3
 818:	fae60ae3          	beq	a2,a4,7cc <free+0x14>
    bp->s.ptr = p->s.ptr;
 81c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 820:	4790                	lw	a2,8(a5)
 822:	02061713          	slli	a4,a2,0x20
 826:	9301                	srli	a4,a4,0x20
 828:	0712                	slli	a4,a4,0x4
 82a:	973e                	add	a4,a4,a5
 82c:	fae689e3          	beq	a3,a4,7de <free+0x26>
  } else
    p->s.ptr = bp;
 830:	e394                	sd	a3,0(a5)
  freep = p;
 832:	00000717          	auipc	a4,0x0
 836:	7cf73723          	sd	a5,1998(a4) # 1000 <freep>
}
 83a:	6422                	ld	s0,8(sp)
 83c:	0141                	addi	sp,sp,16
 83e:	8082                	ret

0000000000000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 840:	7139                	addi	sp,sp,-64
 842:	fc06                	sd	ra,56(sp)
 844:	f822                	sd	s0,48(sp)
 846:	f426                	sd	s1,40(sp)
 848:	f04a                	sd	s2,32(sp)
 84a:	ec4e                	sd	s3,24(sp)
 84c:	e852                	sd	s4,16(sp)
 84e:	e456                	sd	s5,8(sp)
 850:	e05a                	sd	s6,0(sp)
 852:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 854:	02051493          	slli	s1,a0,0x20
 858:	9081                	srli	s1,s1,0x20
 85a:	04bd                	addi	s1,s1,15
 85c:	8091                	srli	s1,s1,0x4
 85e:	0014899b          	addiw	s3,s1,1
 862:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 864:	00000517          	auipc	a0,0x0
 868:	79c53503          	ld	a0,1948(a0) # 1000 <freep>
 86c:	c515                	beqz	a0,898 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 870:	4798                	lw	a4,8(a5)
 872:	02977f63          	bgeu	a4,s1,8b0 <malloc+0x70>
 876:	8a4e                	mv	s4,s3
 878:	0009871b          	sext.w	a4,s3
 87c:	6685                	lui	a3,0x1
 87e:	00d77363          	bgeu	a4,a3,884 <malloc+0x44>
 882:	6a05                	lui	s4,0x1
 884:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 888:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88c:	00000917          	auipc	s2,0x0
 890:	77490913          	addi	s2,s2,1908 # 1000 <freep>
  if(p == SBRK_ERROR)
 894:	5afd                	li	s5,-1
 896:	a0bd                	j	904 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 898:	00001797          	auipc	a5,0x1
 89c:	97078793          	addi	a5,a5,-1680 # 1208 <base>
 8a0:	00000717          	auipc	a4,0x0
 8a4:	76f73023          	sd	a5,1888(a4) # 1000 <freep>
 8a8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8aa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ae:	b7e1                	j	876 <malloc+0x36>
      if(p->s.size == nunits)
 8b0:	02e48b63          	beq	s1,a4,8e6 <malloc+0xa6>
        p->s.size -= nunits;
 8b4:	4137073b          	subw	a4,a4,s3
 8b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ba:	1702                	slli	a4,a4,0x20
 8bc:	9301                	srli	a4,a4,0x20
 8be:	0712                	slli	a4,a4,0x4
 8c0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c6:	00000717          	auipc	a4,0x0
 8ca:	72a73d23          	sd	a0,1850(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ce:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8d2:	70e2                	ld	ra,56(sp)
 8d4:	7442                	ld	s0,48(sp)
 8d6:	74a2                	ld	s1,40(sp)
 8d8:	7902                	ld	s2,32(sp)
 8da:	69e2                	ld	s3,24(sp)
 8dc:	6a42                	ld	s4,16(sp)
 8de:	6aa2                	ld	s5,8(sp)
 8e0:	6b02                	ld	s6,0(sp)
 8e2:	6121                	addi	sp,sp,64
 8e4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8e6:	6398                	ld	a4,0(a5)
 8e8:	e118                	sd	a4,0(a0)
 8ea:	bff1                	j	8c6 <malloc+0x86>
  hp->s.size = nu;
 8ec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f0:	0541                	addi	a0,a0,16
 8f2:	ec7ff0ef          	jal	ra,7b8 <free>
  return freep;
 8f6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8fa:	dd61                	beqz	a0,8d2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fe:	4798                	lw	a4,8(a5)
 900:	fa9778e3          	bgeu	a4,s1,8b0 <malloc+0x70>
    if(p == freep)
 904:	00093703          	ld	a4,0(s2)
 908:	853e                	mv	a0,a5
 90a:	fef719e3          	bne	a4,a5,8fc <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 90e:	8552                	mv	a0,s4
 910:	a1fff0ef          	jal	ra,32e <sbrk>
  if(p == SBRK_ERROR)
 914:	fd551ce3          	bne	a0,s5,8ec <malloc+0xac>
        return 0;
 918:	4501                	li	a0,0
 91a:	bf65                	j	8d2 <malloc+0x92>
