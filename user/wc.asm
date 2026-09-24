
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	988a0a13          	addi	s4,s4,-1656 # 9c0 <malloc+0xe2>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1c4000ef          	jal	ra,20a <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01248d63          	beq	s1,s2,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2b85                	addiw	s7,s7,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0997e3          	bnez	s3,4e <wc+0x4e>
        w++;
  64:	2c05                	addiw	s8,s8,1
        inword = 1;
  66:	4985                	li	s3,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	00001597          	auipc	a1,0x1
  76:	f9e58593          	addi	a1,a1,-98 # 1010 <buf>
  7a:	f8843503          	ld	a0,-120(s0)
  7e:	39a000ef          	jal	ra,418 <read>
  82:	00a05f63          	blez	a0,a0 <wc+0xa0>
    for(i=0; i<n; i++){
  86:	00001497          	auipc	s1,0x1
  8a:	f8a48493          	addi	s1,s1,-118 # 1010 <buf>
  8e:	00050d1b          	sext.w	s10,a0
  92:	fff5091b          	addiw	s2,a0,-1
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	996e                	add	s2,s2,s11
  9e:	bf5d                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  a0:	02054c63          	bltz	a0,d8 <wc+0xd8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  a4:	f8043703          	ld	a4,-128(s0)
  a8:	86e6                	mv	a3,s9
  aa:	8662                	mv	a2,s8
  ac:	85de                	mv	a1,s7
  ae:	00001517          	auipc	a0,0x1
  b2:	92a50513          	addi	a0,a0,-1750 # 9d8 <malloc+0xfa>
  b6:	76e000ef          	jal	ra,824 <printf>
}
  ba:	70e6                	ld	ra,120(sp)
  bc:	7446                	ld	s0,112(sp)
  be:	74a6                	ld	s1,104(sp)
  c0:	7906                	ld	s2,96(sp)
  c2:	69e6                	ld	s3,88(sp)
  c4:	6a46                	ld	s4,80(sp)
  c6:	6aa6                	ld	s5,72(sp)
  c8:	6b06                	ld	s6,64(sp)
  ca:	7be2                	ld	s7,56(sp)
  cc:	7c42                	ld	s8,48(sp)
  ce:	7ca2                	ld	s9,40(sp)
  d0:	7d02                	ld	s10,32(sp)
  d2:	6de2                	ld	s11,24(sp)
  d4:	6109                	addi	sp,sp,128
  d6:	8082                	ret
    printf("wc: read error\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	8f050513          	addi	a0,a0,-1808 # 9c8 <malloc+0xea>
  e0:	744000ef          	jal	ra,824 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	31a000ef          	jal	ra,400 <exit>

00000000000000ea <main>:

int
main(int argc, char *argv[])
{
  ea:	7179                	addi	sp,sp,-48
  ec:	f406                	sd	ra,40(sp)
  ee:	f022                	sd	s0,32(sp)
  f0:	ec26                	sd	s1,24(sp)
  f2:	e84a                	sd	s2,16(sp)
  f4:	e44e                	sd	s3,8(sp)
  f6:	e052                	sd	s4,0(sp)
  f8:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  fa:	4785                	li	a5,1
  fc:	02a7df63          	bge	a5,a0,13a <main+0x50>
 100:	00858493          	addi	s1,a1,8
 104:	ffe5099b          	addiw	s3,a0,-2
 108:	1982                	slli	s3,s3,0x20
 10a:	0209d993          	srli	s3,s3,0x20
 10e:	098e                	slli	s3,s3,0x3
 110:	05c1                	addi	a1,a1,16
 112:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 114:	4581                	li	a1,0
 116:	6088                	ld	a0,0(s1)
 118:	328000ef          	jal	ra,440 <open>
 11c:	892a                	mv	s2,a0
 11e:	02054863          	bltz	a0,14e <main+0x64>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 122:	608c                	ld	a1,0(s1)
 124:	eddff0ef          	jal	ra,0 <wc>
    close(fd);
 128:	854a                	mv	a0,s2
 12a:	2fe000ef          	jal	ra,428 <close>
  for(i = 1; i < argc; i++){
 12e:	04a1                	addi	s1,s1,8
 130:	ff3492e3          	bne	s1,s3,114 <main+0x2a>
  }
  exit(0);
 134:	4501                	li	a0,0
 136:	2ca000ef          	jal	ra,400 <exit>
    wc(0, "");
 13a:	00001597          	auipc	a1,0x1
 13e:	8ae58593          	addi	a1,a1,-1874 # 9e8 <malloc+0x10a>
 142:	4501                	li	a0,0
 144:	ebdff0ef          	jal	ra,0 <wc>
    exit(0);
 148:	4501                	li	a0,0
 14a:	2b6000ef          	jal	ra,400 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 14e:	608c                	ld	a1,0(s1)
 150:	00001517          	auipc	a0,0x1
 154:	8a050513          	addi	a0,a0,-1888 # 9f0 <malloc+0x112>
 158:	6cc000ef          	jal	ra,824 <printf>
      exit(1);
 15c:	4505                	li	a0,1
 15e:	2a2000ef          	jal	ra,400 <exit>

0000000000000162 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 16a:	f81ff0ef          	jal	ra,ea <main>
  exit(r);
 16e:	292000ef          	jal	ra,400 <exit>

0000000000000172 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 178:	87aa                	mv	a5,a0
 17a:	0585                	addi	a1,a1,1
 17c:	0785                	addi	a5,a5,1
 17e:	fff5c703          	lbu	a4,-1(a1)
 182:	fee78fa3          	sb	a4,-1(a5)
 186:	fb75                	bnez	a4,17a <strcpy+0x8>
    ;
  return os;
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb91                	beqz	a5,1ac <strcmp+0x1e>
 19a:	0005c703          	lbu	a4,0(a1)
 19e:	00f71763          	bne	a4,a5,1ac <strcmp+0x1e>
    p++, q++;
 1a2:	0505                	addi	a0,a0,1
 1a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	fbe5                	bnez	a5,19a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ac:	0005c503          	lbu	a0,0(a1)
}
 1b0:	40a7853b          	subw	a0,a5,a0
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strlen>:

uint
strlen(const char *s)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cf91                	beqz	a5,1e0 <strlen+0x26>
 1c6:	0505                	addi	a0,a0,1
 1c8:	87aa                	mv	a5,a0
 1ca:	4685                	li	a3,1
 1cc:	9e89                	subw	a3,a3,a0
 1ce:	00f6853b          	addw	a0,a3,a5
 1d2:	0785                	addi	a5,a5,1
 1d4:	fff7c703          	lbu	a4,-1(a5)
 1d8:	fb7d                	bnez	a4,1ce <strlen+0x14>
    ;
  return n;
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  for(n = 0; s[n]; n++)
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <strlen+0x20>

00000000000001e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ea:	ce09                	beqz	a2,204 <memset+0x20>
 1ec:	87aa                	mv	a5,a0
 1ee:	fff6071b          	addiw	a4,a2,-1
 1f2:	1702                	slli	a4,a4,0x20
 1f4:	9301                	srli	a4,a4,0x20
 1f6:	0705                	addi	a4,a4,1
 1f8:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1fe:	0785                	addi	a5,a5,1
 200:	fee79de3          	bne	a5,a4,1fa <memset+0x16>
  }
  return dst;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret

000000000000020a <strchr>:

char*
strchr(const char *s, char c)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 210:	00054783          	lbu	a5,0(a0)
 214:	cb99                	beqz	a5,22a <strchr+0x20>
    if(*s == c)
 216:	00f58763          	beq	a1,a5,224 <strchr+0x1a>
  for(; *s; s++)
 21a:	0505                	addi	a0,a0,1
 21c:	00054783          	lbu	a5,0(a0)
 220:	fbfd                	bnez	a5,216 <strchr+0xc>
      return (char*)s;
  return 0;
 222:	4501                	li	a0,0
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  return 0;
 22a:	4501                	li	a0,0
 22c:	bfe5                	j	224 <strchr+0x1a>

000000000000022e <gets>:

char*
gets(char *buf, int max)
{
 22e:	711d                	addi	sp,sp,-96
 230:	ec86                	sd	ra,88(sp)
 232:	e8a2                	sd	s0,80(sp)
 234:	e4a6                	sd	s1,72(sp)
 236:	e0ca                	sd	s2,64(sp)
 238:	fc4e                	sd	s3,56(sp)
 23a:	f852                	sd	s4,48(sp)
 23c:	f456                	sd	s5,40(sp)
 23e:	f05a                	sd	s6,32(sp)
 240:	ec5e                	sd	s7,24(sp)
 242:	1080                	addi	s0,sp,96
 244:	8baa                	mv	s7,a0
 246:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 248:	892a                	mv	s2,a0
 24a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 24c:	4aa9                	li	s5,10
 24e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 250:	89a6                	mv	s3,s1
 252:	2485                	addiw	s1,s1,1
 254:	0344d663          	bge	s1,s4,280 <gets+0x52>
    cc = read(0, &c, 1);
 258:	4605                	li	a2,1
 25a:	faf40593          	addi	a1,s0,-81
 25e:	4501                	li	a0,0
 260:	1b8000ef          	jal	ra,418 <read>
    if(cc < 1)
 264:	00a05e63          	blez	a0,280 <gets+0x52>
    buf[i++] = c;
 268:	faf44783          	lbu	a5,-81(s0)
 26c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 270:	01578763          	beq	a5,s5,27e <gets+0x50>
 274:	0905                	addi	s2,s2,1
 276:	fd679de3          	bne	a5,s6,250 <gets+0x22>
  for(i=0; i+1 < max; ){
 27a:	89a6                	mv	s3,s1
 27c:	a011                	j	280 <gets+0x52>
 27e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 280:	99de                	add	s3,s3,s7
 282:	00098023          	sb	zero,0(s3)
  return buf;
}
 286:	855e                	mv	a0,s7
 288:	60e6                	ld	ra,88(sp)
 28a:	6446                	ld	s0,80(sp)
 28c:	64a6                	ld	s1,72(sp)
 28e:	6906                	ld	s2,64(sp)
 290:	79e2                	ld	s3,56(sp)
 292:	7a42                	ld	s4,48(sp)
 294:	7aa2                	ld	s5,40(sp)
 296:	7b02                	ld	s6,32(sp)
 298:	6be2                	ld	s7,24(sp)
 29a:	6125                	addi	sp,sp,96
 29c:	8082                	ret

000000000000029e <stat>:

int
stat(const char *n, struct stat *st)
{
 29e:	1101                	addi	sp,sp,-32
 2a0:	ec06                	sd	ra,24(sp)
 2a2:	e822                	sd	s0,16(sp)
 2a4:	e426                	sd	s1,8(sp)
 2a6:	e04a                	sd	s2,0(sp)
 2a8:	1000                	addi	s0,sp,32
 2aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ac:	4581                	li	a1,0
 2ae:	192000ef          	jal	ra,440 <open>
  if(fd < 0)
 2b2:	02054163          	bltz	a0,2d4 <stat+0x36>
 2b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b8:	85ca                	mv	a1,s2
 2ba:	19e000ef          	jal	ra,458 <fstat>
 2be:	892a                	mv	s2,a0
  close(fd);
 2c0:	8526                	mv	a0,s1
 2c2:	166000ef          	jal	ra,428 <close>
  return r;
}
 2c6:	854a                	mv	a0,s2
 2c8:	60e2                	ld	ra,24(sp)
 2ca:	6442                	ld	s0,16(sp)
 2cc:	64a2                	ld	s1,8(sp)
 2ce:	6902                	ld	s2,0(sp)
 2d0:	6105                	addi	sp,sp,32
 2d2:	8082                	ret
    return -1;
 2d4:	597d                	li	s2,-1
 2d6:	bfc5                	j	2c6 <stat+0x28>

00000000000002d8 <atoi>:

int
atoi(const char *s)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2de:	00054603          	lbu	a2,0(a0)
 2e2:	fd06079b          	addiw	a5,a2,-48
 2e6:	0ff7f793          	andi	a5,a5,255
 2ea:	4725                	li	a4,9
 2ec:	02f76963          	bltu	a4,a5,31e <atoi+0x46>
 2f0:	86aa                	mv	a3,a0
  n = 0;
 2f2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f6:	0685                	addi	a3,a3,1
 2f8:	0025179b          	slliw	a5,a0,0x2
 2fc:	9fa9                	addw	a5,a5,a0
 2fe:	0017979b          	slliw	a5,a5,0x1
 302:	9fb1                	addw	a5,a5,a2
 304:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 308:	0006c603          	lbu	a2,0(a3)
 30c:	fd06071b          	addiw	a4,a2,-48
 310:	0ff77713          	andi	a4,a4,255
 314:	fee5f1e3          	bgeu	a1,a4,2f6 <atoi+0x1e>
  return n;
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
  n = 0;
 31e:	4501                	li	a0,0
 320:	bfe5                	j	318 <atoi+0x40>

0000000000000322 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 328:	02b57663          	bgeu	a0,a1,354 <memmove+0x32>
    while(n-- > 0)
 32c:	02c05163          	blez	a2,34e <memmove+0x2c>
 330:	fff6079b          	addiw	a5,a2,-1
 334:	1782                	slli	a5,a5,0x20
 336:	9381                	srli	a5,a5,0x20
 338:	0785                	addi	a5,a5,1
 33a:	97aa                	add	a5,a5,a0
  dst = vdst;
 33c:	872a                	mv	a4,a0
      *dst++ = *src++;
 33e:	0585                	addi	a1,a1,1
 340:	0705                	addi	a4,a4,1
 342:	fff5c683          	lbu	a3,-1(a1)
 346:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 34a:	fee79ae3          	bne	a5,a4,33e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret
    dst += n;
 354:	00c50733          	add	a4,a0,a2
    src += n;
 358:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 35a:	fec05ae3          	blez	a2,34e <memmove+0x2c>
 35e:	fff6079b          	addiw	a5,a2,-1
 362:	1782                	slli	a5,a5,0x20
 364:	9381                	srli	a5,a5,0x20
 366:	fff7c793          	not	a5,a5
 36a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36c:	15fd                	addi	a1,a1,-1
 36e:	177d                	addi	a4,a4,-1
 370:	0005c683          	lbu	a3,0(a1)
 374:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 378:	fee79ae3          	bne	a5,a4,36c <memmove+0x4a>
 37c:	bfc9                	j	34e <memmove+0x2c>

000000000000037e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 384:	ca05                	beqz	a2,3b4 <memcmp+0x36>
 386:	fff6069b          	addiw	a3,a2,-1
 38a:	1682                	slli	a3,a3,0x20
 38c:	9281                	srli	a3,a3,0x20
 38e:	0685                	addi	a3,a3,1
 390:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 392:	00054783          	lbu	a5,0(a0)
 396:	0005c703          	lbu	a4,0(a1)
 39a:	00e79863          	bne	a5,a4,3aa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 39e:	0505                	addi	a0,a0,1
    p2++;
 3a0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a2:	fed518e3          	bne	a0,a3,392 <memcmp+0x14>
  }
  return 0;
 3a6:	4501                	li	a0,0
 3a8:	a019                	j	3ae <memcmp+0x30>
      return *p1 - *p2;
 3aa:	40e7853b          	subw	a0,a5,a4
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
  return 0;
 3b4:	4501                	li	a0,0
 3b6:	bfe5                	j	3ae <memcmp+0x30>

00000000000003b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e406                	sd	ra,8(sp)
 3bc:	e022                	sd	s0,0(sp)
 3be:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c0:	f63ff0ef          	jal	ra,322 <memmove>
}
 3c4:	60a2                	ld	ra,8(sp)
 3c6:	6402                	ld	s0,0(sp)
 3c8:	0141                	addi	sp,sp,16
 3ca:	8082                	ret

00000000000003cc <sbrk>:

char *
sbrk(int n) {
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e406                	sd	ra,8(sp)
 3d0:	e022                	sd	s0,0(sp)
 3d2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3d4:	4585                	li	a1,1
 3d6:	0b2000ef          	jal	ra,488 <sys_sbrk>
}
 3da:	60a2                	ld	ra,8(sp)
 3dc:	6402                	ld	s0,0(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <sbrklazy>:

char *
sbrklazy(int n) {
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e406                	sd	ra,8(sp)
 3e6:	e022                	sd	s0,0(sp)
 3e8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3ea:	4589                	li	a1,2
 3ec:	09c000ef          	jal	ra,488 <sys_sbrk>
}
 3f0:	60a2                	ld	ra,8(sp)
 3f2:	6402                	ld	s0,0(sp)
 3f4:	0141                	addi	sp,sp,16
 3f6:	8082                	ret

00000000000003f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f8:	4885                	li	a7,1
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <exit>:
.global exit
exit:
 li a7, SYS_exit
 400:	4889                	li	a7,2
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <wait>:
.global wait
wait:
 li a7, SYS_wait
 408:	488d                	li	a7,3
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 410:	4891                	li	a7,4
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <read>:
.global read
read:
 li a7, SYS_read
 418:	4895                	li	a7,5
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <write>:
.global write
write:
 li a7, SYS_write
 420:	48c1                	li	a7,16
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <close>:
.global close
close:
 li a7, SYS_close
 428:	48d5                	li	a7,21
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <kill>:
.global kill
kill:
 li a7, SYS_kill
 430:	4899                	li	a7,6
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <exec>:
.global exec
exec:
 li a7, SYS_exec
 438:	489d                	li	a7,7
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <open>:
.global open
open:
 li a7, SYS_open
 440:	48bd                	li	a7,15
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 448:	48c5                	li	a7,17
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 450:	48c9                	li	a7,18
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 458:	48a1                	li	a7,8
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <link>:
.global link
link:
 li a7, SYS_link
 460:	48cd                	li	a7,19
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 468:	48d1                	li	a7,20
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 470:	48a5                	li	a7,9
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <dup>:
.global dup
dup:
 li a7, SYS_dup
 478:	48a9                	li	a7,10
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 480:	48ad                	li	a7,11
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 488:	48b1                	li	a7,12
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <pause>:
.global pause
pause:
 li a7, SYS_pause
 490:	48b5                	li	a7,13
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 498:	48b9                	li	a7,14
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 4a0:	48d9                	li	a7,22
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a8:	1101                	addi	sp,sp,-32
 4aa:	ec06                	sd	ra,24(sp)
 4ac:	e822                	sd	s0,16(sp)
 4ae:	1000                	addi	s0,sp,32
 4b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b4:	4605                	li	a2,1
 4b6:	fef40593          	addi	a1,s0,-17
 4ba:	f67ff0ef          	jal	ra,420 <write>
}
 4be:	60e2                	ld	ra,24(sp)
 4c0:	6442                	ld	s0,16(sp)
 4c2:	6105                	addi	sp,sp,32
 4c4:	8082                	ret

00000000000004c6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4c6:	715d                	addi	sp,sp,-80
 4c8:	e486                	sd	ra,72(sp)
 4ca:	e0a2                	sd	s0,64(sp)
 4cc:	fc26                	sd	s1,56(sp)
 4ce:	f84a                	sd	s2,48(sp)
 4d0:	f44e                	sd	s3,40(sp)
 4d2:	0880                	addi	s0,sp,80
 4d4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4d6:	c299                	beqz	a3,4dc <printint+0x16>
 4d8:	0805c163          	bltz	a1,55a <printint+0x94>
  neg = 0;
 4dc:	4881                	li	a7,0
 4de:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4e2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4e4:	00000517          	auipc	a0,0x0
 4e8:	52c50513          	addi	a0,a0,1324 # a10 <digits>
 4ec:	883e                	mv	a6,a5
 4ee:	2785                	addiw	a5,a5,1
 4f0:	02c5f733          	remu	a4,a1,a2
 4f4:	972a                	add	a4,a4,a0
 4f6:	00074703          	lbu	a4,0(a4)
 4fa:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4fe:	872e                	mv	a4,a1
 500:	02c5d5b3          	divu	a1,a1,a2
 504:	0685                	addi	a3,a3,1
 506:	fec773e3          	bgeu	a4,a2,4ec <printint+0x26>
  if(neg)
 50a:	00088b63          	beqz	a7,520 <printint+0x5a>
    buf[i++] = '-';
 50e:	fd040713          	addi	a4,s0,-48
 512:	97ba                	add	a5,a5,a4
 514:	02d00713          	li	a4,45
 518:	fee78423          	sb	a4,-24(a5)
 51c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 520:	02f05663          	blez	a5,54c <printint+0x86>
 524:	fb840713          	addi	a4,s0,-72
 528:	00f704b3          	add	s1,a4,a5
 52c:	fff70993          	addi	s3,a4,-1
 530:	99be                	add	s3,s3,a5
 532:	37fd                	addiw	a5,a5,-1
 534:	1782                	slli	a5,a5,0x20
 536:	9381                	srli	a5,a5,0x20
 538:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 53c:	fff4c583          	lbu	a1,-1(s1)
 540:	854a                	mv	a0,s2
 542:	f67ff0ef          	jal	ra,4a8 <putc>
  while(--i >= 0)
 546:	14fd                	addi	s1,s1,-1
 548:	ff349ae3          	bne	s1,s3,53c <printint+0x76>
}
 54c:	60a6                	ld	ra,72(sp)
 54e:	6406                	ld	s0,64(sp)
 550:	74e2                	ld	s1,56(sp)
 552:	7942                	ld	s2,48(sp)
 554:	79a2                	ld	s3,40(sp)
 556:	6161                	addi	sp,sp,80
 558:	8082                	ret
    x = -xx;
 55a:	40b005b3          	neg	a1,a1
    neg = 1;
 55e:	4885                	li	a7,1
    x = -xx;
 560:	bfbd                	j	4de <printint+0x18>

0000000000000562 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 562:	7119                	addi	sp,sp,-128
 564:	fc86                	sd	ra,120(sp)
 566:	f8a2                	sd	s0,112(sp)
 568:	f4a6                	sd	s1,104(sp)
 56a:	f0ca                	sd	s2,96(sp)
 56c:	ecce                	sd	s3,88(sp)
 56e:	e8d2                	sd	s4,80(sp)
 570:	e4d6                	sd	s5,72(sp)
 572:	e0da                	sd	s6,64(sp)
 574:	fc5e                	sd	s7,56(sp)
 576:	f862                	sd	s8,48(sp)
 578:	f466                	sd	s9,40(sp)
 57a:	f06a                	sd	s10,32(sp)
 57c:	ec6e                	sd	s11,24(sp)
 57e:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 580:	0005c903          	lbu	s2,0(a1)
 584:	24090c63          	beqz	s2,7dc <vprintf+0x27a>
 588:	8b2a                	mv	s6,a0
 58a:	8a2e                	mv	s4,a1
 58c:	8bb2                	mv	s7,a2
  state = 0;
 58e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 590:	4481                	li	s1,0
 592:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 594:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 598:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 59c:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a0:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a4:	00000c97          	auipc	s9,0x0
 5a8:	46cc8c93          	addi	s9,s9,1132 # a10 <digits>
 5ac:	a005                	j	5cc <vprintf+0x6a>
        putc(fd, c0);
 5ae:	85ca                	mv	a1,s2
 5b0:	855a                	mv	a0,s6
 5b2:	ef7ff0ef          	jal	ra,4a8 <putc>
 5b6:	a019                	j	5bc <vprintf+0x5a>
    } else if(state == '%'){
 5b8:	03598263          	beq	s3,s5,5dc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5bc:	2485                	addiw	s1,s1,1
 5be:	8726                	mv	a4,s1
 5c0:	009a07b3          	add	a5,s4,s1
 5c4:	0007c903          	lbu	s2,0(a5)
 5c8:	20090a63          	beqz	s2,7dc <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 5cc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d0:	fe0994e3          	bnez	s3,5b8 <vprintf+0x56>
      if(c0 == '%'){
 5d4:	fd579de3          	bne	a5,s5,5ae <vprintf+0x4c>
        state = '%';
 5d8:	89be                	mv	s3,a5
 5da:	b7cd                	j	5bc <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5dc:	c3c1                	beqz	a5,65c <vprintf+0xfa>
 5de:	00ea06b3          	add	a3,s4,a4
 5e2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5e6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5e8:	c681                	beqz	a3,5f0 <vprintf+0x8e>
 5ea:	9752                	add	a4,a4,s4
 5ec:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5f0:	03878e63          	beq	a5,s8,62c <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 5f4:	05a78863          	beq	a5,s10,644 <vprintf+0xe2>
      } else if(c0 == 'u'){
 5f8:	0db78b63          	beq	a5,s11,6ce <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5fc:	07800713          	li	a4,120
 600:	10e78d63          	beq	a5,a4,71a <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 604:	07000713          	li	a4,112
 608:	14e78263          	beq	a5,a4,74c <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 60c:	06300713          	li	a4,99
 610:	16e78f63          	beq	a5,a4,78e <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 614:	07300713          	li	a4,115
 618:	18e78563          	beq	a5,a4,7a2 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 61c:	05579063          	bne	a5,s5,65c <vprintf+0xfa>
        putc(fd, '%');
 620:	85d6                	mv	a1,s5
 622:	855a                	mv	a0,s6
 624:	e85ff0ef          	jal	ra,4a8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 628:	4981                	li	s3,0
 62a:	bf49                	j	5bc <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 62c:	008b8913          	addi	s2,s7,8
 630:	4685                	li	a3,1
 632:	4629                	li	a2,10
 634:	000ba583          	lw	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	e8dff0ef          	jal	ra,4c6 <printint>
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	bfad                	j	5bc <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 644:	03868663          	beq	a3,s8,670 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 648:	05a68163          	beq	a3,s10,68a <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 64c:	09b68d63          	beq	a3,s11,6e6 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 650:	03a68f63          	beq	a3,s10,68e <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 654:	07800793          	li	a5,120
 658:	0cf68d63          	beq	a3,a5,732 <vprintf+0x1d0>
        putc(fd, '%');
 65c:	85d6                	mv	a1,s5
 65e:	855a                	mv	a0,s6
 660:	e49ff0ef          	jal	ra,4a8 <putc>
        putc(fd, c0);
 664:	85ca                	mv	a1,s2
 666:	855a                	mv	a0,s6
 668:	e41ff0ef          	jal	ra,4a8 <putc>
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b7b9                	j	5bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 670:	008b8913          	addi	s2,s7,8
 674:	4685                	li	a3,1
 676:	4629                	li	a2,10
 678:	000bb583          	ld	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	e49ff0ef          	jal	ra,4c6 <printint>
        i += 1;
 682:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
        i += 1;
 688:	bf15                	j	5bc <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 68a:	03860563          	beq	a2,s8,6b4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 68e:	07b60963          	beq	a2,s11,700 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 692:	07800793          	li	a5,120
 696:	fcf613e3          	bne	a2,a5,65c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69a:	008b8913          	addi	s2,s7,8
 69e:	4681                	li	a3,0
 6a0:	4641                	li	a2,16
 6a2:	000bb583          	ld	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	e1fff0ef          	jal	ra,4c6 <printint>
        i += 2;
 6ac:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
        i += 2;
 6b2:	b729                	j	5bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4685                	li	a3,1
 6ba:	4629                	li	a2,10
 6bc:	000bb583          	ld	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	e05ff0ef          	jal	ra,4c6 <printint>
        i += 2;
 6c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 2;
 6cc:	bdc5                	j	5bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4629                	li	a2,10
 6d6:	000be583          	lwu	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	debff0ef          	jal	ra,4c6 <printint>
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bde1                	j	5bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e6:	008b8913          	addi	s2,s7,8
 6ea:	4681                	li	a3,0
 6ec:	4629                	li	a2,10
 6ee:	000bb583          	ld	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	dd3ff0ef          	jal	ra,4c6 <printint>
        i += 1;
 6f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
        i += 1;
 6fe:	bd7d                	j	5bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 700:	008b8913          	addi	s2,s7,8
 704:	4681                	li	a3,0
 706:	4629                	li	a2,10
 708:	000bb583          	ld	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	db9ff0ef          	jal	ra,4c6 <printint>
        i += 2;
 712:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
        i += 2;
 718:	b555                	j	5bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 71a:	008b8913          	addi	s2,s7,8
 71e:	4681                	li	a3,0
 720:	4641                	li	a2,16
 722:	000be583          	lwu	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	d9fff0ef          	jal	ra,4c6 <printint>
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	b571                	j	5bc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 732:	008b8913          	addi	s2,s7,8
 736:	4681                	li	a3,0
 738:	4641                	li	a2,16
 73a:	000bb583          	ld	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	d87ff0ef          	jal	ra,4c6 <printint>
        i += 1;
 744:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 746:	8bca                	mv	s7,s2
      state = 0;
 748:	4981                	li	s3,0
        i += 1;
 74a:	bd8d                	j	5bc <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 74c:	008b8793          	addi	a5,s7,8
 750:	f8f43423          	sd	a5,-120(s0)
 754:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 758:	03000593          	li	a1,48
 75c:	855a                	mv	a0,s6
 75e:	d4bff0ef          	jal	ra,4a8 <putc>
  putc(fd, 'x');
 762:	07800593          	li	a1,120
 766:	855a                	mv	a0,s6
 768:	d41ff0ef          	jal	ra,4a8 <putc>
 76c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76e:	03c9d793          	srli	a5,s3,0x3c
 772:	97e6                	add	a5,a5,s9
 774:	0007c583          	lbu	a1,0(a5)
 778:	855a                	mv	a0,s6
 77a:	d2fff0ef          	jal	ra,4a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77e:	0992                	slli	s3,s3,0x4
 780:	397d                	addiw	s2,s2,-1
 782:	fe0916e3          	bnez	s2,76e <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 786:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bd05                	j	5bc <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 78e:	008b8913          	addi	s2,s7,8
 792:	000bc583          	lbu	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	d11ff0ef          	jal	ra,4a8 <putc>
 79c:	8bca                	mv	s7,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bd31                	j	5bc <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 7a2:	008b8993          	addi	s3,s7,8
 7a6:	000bb903          	ld	s2,0(s7)
 7aa:	00090f63          	beqz	s2,7c8 <vprintf+0x266>
        for(; *s; s++)
 7ae:	00094583          	lbu	a1,0(s2)
 7b2:	c195                	beqz	a1,7d6 <vprintf+0x274>
          putc(fd, *s);
 7b4:	855a                	mv	a0,s6
 7b6:	cf3ff0ef          	jal	ra,4a8 <putc>
        for(; *s; s++)
 7ba:	0905                	addi	s2,s2,1
 7bc:	00094583          	lbu	a1,0(s2)
 7c0:	f9f5                	bnez	a1,7b4 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 7c2:	8bce                	mv	s7,s3
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	bbdd                	j	5bc <vprintf+0x5a>
          s = "(null)";
 7c8:	00000917          	auipc	s2,0x0
 7cc:	24090913          	addi	s2,s2,576 # a08 <malloc+0x12a>
        for(; *s; s++)
 7d0:	02800593          	li	a1,40
 7d4:	b7c5                	j	7b4 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 7d6:	8bce                	mv	s7,s3
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b3cd                	j	5bc <vprintf+0x5a>
    }
  }
}
 7dc:	70e6                	ld	ra,120(sp)
 7de:	7446                	ld	s0,112(sp)
 7e0:	74a6                	ld	s1,104(sp)
 7e2:	7906                	ld	s2,96(sp)
 7e4:	69e6                	ld	s3,88(sp)
 7e6:	6a46                	ld	s4,80(sp)
 7e8:	6aa6                	ld	s5,72(sp)
 7ea:	6b06                	ld	s6,64(sp)
 7ec:	7be2                	ld	s7,56(sp)
 7ee:	7c42                	ld	s8,48(sp)
 7f0:	7ca2                	ld	s9,40(sp)
 7f2:	7d02                	ld	s10,32(sp)
 7f4:	6de2                	ld	s11,24(sp)
 7f6:	6109                	addi	sp,sp,128
 7f8:	8082                	ret

00000000000007fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fa:	715d                	addi	sp,sp,-80
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	e010                	sd	a2,0(s0)
 804:	e414                	sd	a3,8(s0)
 806:	e818                	sd	a4,16(s0)
 808:	ec1c                	sd	a5,24(s0)
 80a:	03043023          	sd	a6,32(s0)
 80e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 812:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 816:	8622                	mv	a2,s0
 818:	d4bff0ef          	jal	ra,562 <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6161                	addi	sp,sp,80
 822:	8082                	ret

0000000000000824 <printf>:

void
printf(const char *fmt, ...)
{
 824:	711d                	addi	sp,sp,-96
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e40c                	sd	a1,8(s0)
 82e:	e810                	sd	a2,16(s0)
 830:	ec14                	sd	a3,24(s0)
 832:	f018                	sd	a4,32(s0)
 834:	f41c                	sd	a5,40(s0)
 836:	03043823          	sd	a6,48(s0)
 83a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83e:	00840613          	addi	a2,s0,8
 842:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 846:	85aa                	mv	a1,a0
 848:	4505                	li	a0,1
 84a:	d19ff0ef          	jal	ra,562 <vprintf>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6125                	addi	sp,sp,96
 854:	8082                	ret

0000000000000856 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 856:	1141                	addi	sp,sp,-16
 858:	e422                	sd	s0,8(sp)
 85a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 85c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 860:	00000797          	auipc	a5,0x0
 864:	7a07b783          	ld	a5,1952(a5) # 1000 <freep>
 868:	a805                	j	898 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 86a:	4618                	lw	a4,8(a2)
 86c:	9db9                	addw	a1,a1,a4
 86e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 872:	6398                	ld	a4,0(a5)
 874:	6318                	ld	a4,0(a4)
 876:	fee53823          	sd	a4,-16(a0)
 87a:	a091                	j	8be <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 87c:	ff852703          	lw	a4,-8(a0)
 880:	9e39                	addw	a2,a2,a4
 882:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 884:	ff053703          	ld	a4,-16(a0)
 888:	e398                	sd	a4,0(a5)
 88a:	a099                	j	8d0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88c:	6398                	ld	a4,0(a5)
 88e:	00e7e463          	bltu	a5,a4,896 <free+0x40>
 892:	00e6ea63          	bltu	a3,a4,8a6 <free+0x50>
{
 896:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 898:	fed7fae3          	bgeu	a5,a3,88c <free+0x36>
 89c:	6398                	ld	a4,0(a5)
 89e:	00e6e463          	bltu	a3,a4,8a6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a2:	fee7eae3          	bltu	a5,a4,896 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8a6:	ff852583          	lw	a1,-8(a0)
 8aa:	6390                	ld	a2,0(a5)
 8ac:	02059713          	slli	a4,a1,0x20
 8b0:	9301                	srli	a4,a4,0x20
 8b2:	0712                	slli	a4,a4,0x4
 8b4:	9736                	add	a4,a4,a3
 8b6:	fae60ae3          	beq	a2,a4,86a <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ba:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8be:	4790                	lw	a2,8(a5)
 8c0:	02061713          	slli	a4,a2,0x20
 8c4:	9301                	srli	a4,a4,0x20
 8c6:	0712                	slli	a4,a4,0x4
 8c8:	973e                	add	a4,a4,a5
 8ca:	fae689e3          	beq	a3,a4,87c <free+0x26>
  } else
    p->s.ptr = bp;
 8ce:	e394                	sd	a3,0(a5)
  freep = p;
 8d0:	00000717          	auipc	a4,0x0
 8d4:	72f73823          	sd	a5,1840(a4) # 1000 <freep>
}
 8d8:	6422                	ld	s0,8(sp)
 8da:	0141                	addi	sp,sp,16
 8dc:	8082                	ret

00000000000008de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8de:	7139                	addi	sp,sp,-64
 8e0:	fc06                	sd	ra,56(sp)
 8e2:	f822                	sd	s0,48(sp)
 8e4:	f426                	sd	s1,40(sp)
 8e6:	f04a                	sd	s2,32(sp)
 8e8:	ec4e                	sd	s3,24(sp)
 8ea:	e852                	sd	s4,16(sp)
 8ec:	e456                	sd	s5,8(sp)
 8ee:	e05a                	sd	s6,0(sp)
 8f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f2:	02051493          	slli	s1,a0,0x20
 8f6:	9081                	srli	s1,s1,0x20
 8f8:	04bd                	addi	s1,s1,15
 8fa:	8091                	srli	s1,s1,0x4
 8fc:	0014899b          	addiw	s3,s1,1
 900:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 902:	00000517          	auipc	a0,0x0
 906:	6fe53503          	ld	a0,1790(a0) # 1000 <freep>
 90a:	c515                	beqz	a0,936 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90e:	4798                	lw	a4,8(a5)
 910:	02977f63          	bgeu	a4,s1,94e <malloc+0x70>
 914:	8a4e                	mv	s4,s3
 916:	0009871b          	sext.w	a4,s3
 91a:	6685                	lui	a3,0x1
 91c:	00d77363          	bgeu	a4,a3,922 <malloc+0x44>
 920:	6a05                	lui	s4,0x1
 922:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 926:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 92a:	00000917          	auipc	s2,0x0
 92e:	6d690913          	addi	s2,s2,1750 # 1000 <freep>
  if(p == SBRK_ERROR)
 932:	5afd                	li	s5,-1
 934:	a0bd                	j	9a2 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 936:	00001797          	auipc	a5,0x1
 93a:	8da78793          	addi	a5,a5,-1830 # 1210 <base>
 93e:	00000717          	auipc	a4,0x0
 942:	6cf73123          	sd	a5,1730(a4) # 1000 <freep>
 946:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 948:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 94c:	b7e1                	j	914 <malloc+0x36>
      if(p->s.size == nunits)
 94e:	02e48b63          	beq	s1,a4,984 <malloc+0xa6>
        p->s.size -= nunits;
 952:	4137073b          	subw	a4,a4,s3
 956:	c798                	sw	a4,8(a5)
        p += p->s.size;
 958:	1702                	slli	a4,a4,0x20
 95a:	9301                	srli	a4,a4,0x20
 95c:	0712                	slli	a4,a4,0x4
 95e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 960:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 964:	00000717          	auipc	a4,0x0
 968:	68a73e23          	sd	a0,1692(a4) # 1000 <freep>
      return (void*)(p + 1);
 96c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 970:	70e2                	ld	ra,56(sp)
 972:	7442                	ld	s0,48(sp)
 974:	74a2                	ld	s1,40(sp)
 976:	7902                	ld	s2,32(sp)
 978:	69e2                	ld	s3,24(sp)
 97a:	6a42                	ld	s4,16(sp)
 97c:	6aa2                	ld	s5,8(sp)
 97e:	6b02                	ld	s6,0(sp)
 980:	6121                	addi	sp,sp,64
 982:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 984:	6398                	ld	a4,0(a5)
 986:	e118                	sd	a4,0(a0)
 988:	bff1                	j	964 <malloc+0x86>
  hp->s.size = nu;
 98a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 98e:	0541                	addi	a0,a0,16
 990:	ec7ff0ef          	jal	ra,856 <free>
  return freep;
 994:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 998:	dd61                	beqz	a0,970 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99c:	4798                	lw	a4,8(a5)
 99e:	fa9778e3          	bgeu	a4,s1,94e <malloc+0x70>
    if(p == freep)
 9a2:	00093703          	ld	a4,0(s2)
 9a6:	853e                	mv	a0,a5
 9a8:	fef719e3          	bne	a4,a5,99a <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 9ac:	8552                	mv	a0,s4
 9ae:	a1fff0ef          	jal	ra,3cc <sbrk>
  if(p == SBRK_ERROR)
 9b2:	fd551ce3          	bne	a0,s5,98a <malloc+0xac>
        return 0;
 9b6:	4501                	li	a0,0
 9b8:	bf65                	j	970 <malloc+0x92>
