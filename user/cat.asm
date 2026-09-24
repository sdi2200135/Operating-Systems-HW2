
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	37c000ef          	jal	ra,39c <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	374000ef          	jal	ra,3a4 <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	90858593          	addi	a1,a1,-1784 # 940 <malloc+0xde>
  40:	4509                	li	a0,2
  42:	73c000ef          	jal	ra,77e <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	33c000ef          	jal	ra,384 <exit>
    }
  }
  if(n < 0){
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	addi	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	8fa58593          	addi	a1,a1,-1798 # 958 <malloc+0xf6>
  66:	4509                	li	a0,2
  68:	716000ef          	jal	ra,77e <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	316000ef          	jal	ra,384 <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	addi	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	ec26                	sd	s1,24(sp)
  7a:	e84a                	sd	s2,16(sp)
  7c:	e44e                	sd	s3,8(sp)
  7e:	e052                	sd	s4,0(sp)
  80:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  82:	4785                	li	a5,1
  84:	02a7df63          	bge	a5,a0,c2 <main+0x50>
  88:	00858913          	addi	s2,a1,8
  8c:	ffe5099b          	addiw	s3,a0,-2
  90:	1982                	slli	s3,s3,0x20
  92:	0209d993          	srli	s3,s3,0x20
  96:	098e                	slli	s3,s3,0x3
  98:	05c1                	addi	a1,a1,16
  9a:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  9c:	4581                	li	a1,0
  9e:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a2:	322000ef          	jal	ra,3c4 <open>
  a6:	84aa                	mv	s1,a0
  a8:	02054363          	bltz	a0,ce <main+0x5c>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  ac:	f55ff0ef          	jal	ra,0 <cat>
    close(fd);
  b0:	8526                	mv	a0,s1
  b2:	2fa000ef          	jal	ra,3ac <close>
  for(i = 1; i < argc; i++){
  b6:	0921                	addi	s2,s2,8
  b8:	ff3912e3          	bne	s2,s3,9c <main+0x2a>
  }
  exit(0);
  bc:	4501                	li	a0,0
  be:	2c6000ef          	jal	ra,384 <exit>
    cat(0);
  c2:	4501                	li	a0,0
  c4:	f3dff0ef          	jal	ra,0 <cat>
    exit(0);
  c8:	4501                	li	a0,0
  ca:	2ba000ef          	jal	ra,384 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  ce:	00093603          	ld	a2,0(s2)
  d2:	00001597          	auipc	a1,0x1
  d6:	89e58593          	addi	a1,a1,-1890 # 970 <malloc+0x10e>
  da:	4509                	li	a0,2
  dc:	6a2000ef          	jal	ra,77e <fprintf>
      exit(1);
  e0:	4505                	li	a0,1
  e2:	2a2000ef          	jal	ra,384 <exit>

00000000000000e6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ee:	f85ff0ef          	jal	ra,72 <main>
  exit(r);
  f2:	292000ef          	jal	ra,384 <exit>

00000000000000f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fc:	87aa                	mv	a5,a0
  fe:	0585                	addi	a1,a1,1
 100:	0785                	addi	a5,a5,1
 102:	fff5c703          	lbu	a4,-1(a1)
 106:	fee78fa3          	sb	a4,-1(a5)
 10a:	fb75                	bnez	a4,fe <strcpy+0x8>
    ;
  return os;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb91                	beqz	a5,130 <strcmp+0x1e>
 11e:	0005c703          	lbu	a4,0(a1)
 122:	00f71763          	bne	a4,a5,130 <strcmp+0x1e>
    p++, q++;
 126:	0505                	addi	a0,a0,1
 128:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbe5                	bnez	a5,11e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 130:	0005c503          	lbu	a0,0(a1)
}
 134:	40a7853b          	subw	a0,a5,a0
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strlen>:

uint
strlen(const char *s)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 144:	00054783          	lbu	a5,0(a0)
 148:	cf91                	beqz	a5,164 <strlen+0x26>
 14a:	0505                	addi	a0,a0,1
 14c:	87aa                	mv	a5,a0
 14e:	4685                	li	a3,1
 150:	9e89                	subw	a3,a3,a0
 152:	00f6853b          	addw	a0,a3,a5
 156:	0785                	addi	a5,a5,1
 158:	fff7c703          	lbu	a4,-1(a5)
 15c:	fb7d                	bnez	a4,152 <strlen+0x14>
    ;
  return n;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret
  for(n = 0; s[n]; n++)
 164:	4501                	li	a0,0
 166:	bfe5                	j	15e <strlen+0x20>

0000000000000168 <memset>:

void*
memset(void *dst, int c, uint n)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16e:	ce09                	beqz	a2,188 <memset+0x20>
 170:	87aa                	mv	a5,a0
 172:	fff6071b          	addiw	a4,a2,-1
 176:	1702                	slli	a4,a4,0x20
 178:	9301                	srli	a4,a4,0x20
 17a:	0705                	addi	a4,a4,1
 17c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 17e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 182:	0785                	addi	a5,a5,1
 184:	fee79de3          	bne	a5,a4,17e <memset+0x16>
  }
  return dst;
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strchr>:

char*
strchr(const char *s, char c)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  for(; *s; s++)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb99                	beqz	a5,1ae <strchr+0x20>
    if(*s == c)
 19a:	00f58763          	beq	a1,a5,1a8 <strchr+0x1a>
  for(; *s; s++)
 19e:	0505                	addi	a0,a0,1
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	fbfd                	bnez	a5,19a <strchr+0xc>
      return (char*)s;
  return 0;
 1a6:	4501                	li	a0,0
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret
  return 0;
 1ae:	4501                	li	a0,0
 1b0:	bfe5                	j	1a8 <strchr+0x1a>

00000000000001b2 <gets>:

char*
gets(char *buf, int max)
{
 1b2:	711d                	addi	sp,sp,-96
 1b4:	ec86                	sd	ra,88(sp)
 1b6:	e8a2                	sd	s0,80(sp)
 1b8:	e4a6                	sd	s1,72(sp)
 1ba:	e0ca                	sd	s2,64(sp)
 1bc:	fc4e                	sd	s3,56(sp)
 1be:	f852                	sd	s4,48(sp)
 1c0:	f456                	sd	s5,40(sp)
 1c2:	f05a                	sd	s6,32(sp)
 1c4:	ec5e                	sd	s7,24(sp)
 1c6:	1080                	addi	s0,sp,96
 1c8:	8baa                	mv	s7,a0
 1ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	892a                	mv	s2,a0
 1ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d0:	4aa9                	li	s5,10
 1d2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d4:	89a6                	mv	s3,s1
 1d6:	2485                	addiw	s1,s1,1
 1d8:	0344d663          	bge	s1,s4,204 <gets+0x52>
    cc = read(0, &c, 1);
 1dc:	4605                	li	a2,1
 1de:	faf40593          	addi	a1,s0,-81
 1e2:	4501                	li	a0,0
 1e4:	1b8000ef          	jal	ra,39c <read>
    if(cc < 1)
 1e8:	00a05e63          	blez	a0,204 <gets+0x52>
    buf[i++] = c;
 1ec:	faf44783          	lbu	a5,-81(s0)
 1f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f4:	01578763          	beq	a5,s5,202 <gets+0x50>
 1f8:	0905                	addi	s2,s2,1
 1fa:	fd679de3          	bne	a5,s6,1d4 <gets+0x22>
  for(i=0; i+1 < max; ){
 1fe:	89a6                	mv	s3,s1
 200:	a011                	j	204 <gets+0x52>
 202:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 204:	99de                	add	s3,s3,s7
 206:	00098023          	sb	zero,0(s3)
  return buf;
}
 20a:	855e                	mv	a0,s7
 20c:	60e6                	ld	ra,88(sp)
 20e:	6446                	ld	s0,80(sp)
 210:	64a6                	ld	s1,72(sp)
 212:	6906                	ld	s2,64(sp)
 214:	79e2                	ld	s3,56(sp)
 216:	7a42                	ld	s4,48(sp)
 218:	7aa2                	ld	s5,40(sp)
 21a:	7b02                	ld	s6,32(sp)
 21c:	6be2                	ld	s7,24(sp)
 21e:	6125                	addi	sp,sp,96
 220:	8082                	ret

0000000000000222 <stat>:

int
stat(const char *n, struct stat *st)
{
 222:	1101                	addi	sp,sp,-32
 224:	ec06                	sd	ra,24(sp)
 226:	e822                	sd	s0,16(sp)
 228:	e426                	sd	s1,8(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	1000                	addi	s0,sp,32
 22e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 230:	4581                	li	a1,0
 232:	192000ef          	jal	ra,3c4 <open>
  if(fd < 0)
 236:	02054163          	bltz	a0,258 <stat+0x36>
 23a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23c:	85ca                	mv	a1,s2
 23e:	19e000ef          	jal	ra,3dc <fstat>
 242:	892a                	mv	s2,a0
  close(fd);
 244:	8526                	mv	a0,s1
 246:	166000ef          	jal	ra,3ac <close>
  return r;
}
 24a:	854a                	mv	a0,s2
 24c:	60e2                	ld	ra,24(sp)
 24e:	6442                	ld	s0,16(sp)
 250:	64a2                	ld	s1,8(sp)
 252:	6902                	ld	s2,0(sp)
 254:	6105                	addi	sp,sp,32
 256:	8082                	ret
    return -1;
 258:	597d                	li	s2,-1
 25a:	bfc5                	j	24a <stat+0x28>

000000000000025c <atoi>:

int
atoi(const char *s)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 262:	00054603          	lbu	a2,0(a0)
 266:	fd06079b          	addiw	a5,a2,-48
 26a:	0ff7f793          	andi	a5,a5,255
 26e:	4725                	li	a4,9
 270:	02f76963          	bltu	a4,a5,2a2 <atoi+0x46>
 274:	86aa                	mv	a3,a0
  n = 0;
 276:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 278:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 27a:	0685                	addi	a3,a3,1
 27c:	0025179b          	slliw	a5,a0,0x2
 280:	9fa9                	addw	a5,a5,a0
 282:	0017979b          	slliw	a5,a5,0x1
 286:	9fb1                	addw	a5,a5,a2
 288:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28c:	0006c603          	lbu	a2,0(a3)
 290:	fd06071b          	addiw	a4,a2,-48
 294:	0ff77713          	andi	a4,a4,255
 298:	fee5f1e3          	bgeu	a1,a4,27a <atoi+0x1e>
  return n;
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
  n = 0;
 2a2:	4501                	li	a0,0
 2a4:	bfe5                	j	29c <atoi+0x40>

00000000000002a6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ac:	02b57663          	bgeu	a0,a1,2d8 <memmove+0x32>
    while(n-- > 0)
 2b0:	02c05163          	blez	a2,2d2 <memmove+0x2c>
 2b4:	fff6079b          	addiw	a5,a2,-1
 2b8:	1782                	slli	a5,a5,0x20
 2ba:	9381                	srli	a5,a5,0x20
 2bc:	0785                	addi	a5,a5,1
 2be:	97aa                	add	a5,a5,a0
  dst = vdst;
 2c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c2:	0585                	addi	a1,a1,1
 2c4:	0705                	addi	a4,a4,1
 2c6:	fff5c683          	lbu	a3,-1(a1)
 2ca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ce:	fee79ae3          	bne	a5,a4,2c2 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
    dst += n;
 2d8:	00c50733          	add	a4,a0,a2
    src += n;
 2dc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2de:	fec05ae3          	blez	a2,2d2 <memmove+0x2c>
 2e2:	fff6079b          	addiw	a5,a2,-1
 2e6:	1782                	slli	a5,a5,0x20
 2e8:	9381                	srli	a5,a5,0x20
 2ea:	fff7c793          	not	a5,a5
 2ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f0:	15fd                	addi	a1,a1,-1
 2f2:	177d                	addi	a4,a4,-1
 2f4:	0005c683          	lbu	a3,0(a1)
 2f8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2fc:	fee79ae3          	bne	a5,a4,2f0 <memmove+0x4a>
 300:	bfc9                	j	2d2 <memmove+0x2c>

0000000000000302 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 308:	ca05                	beqz	a2,338 <memcmp+0x36>
 30a:	fff6069b          	addiw	a3,a2,-1
 30e:	1682                	slli	a3,a3,0x20
 310:	9281                	srli	a3,a3,0x20
 312:	0685                	addi	a3,a3,1
 314:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 316:	00054783          	lbu	a5,0(a0)
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00e79863          	bne	a5,a4,32e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 322:	0505                	addi	a0,a0,1
    p2++;
 324:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 326:	fed518e3          	bne	a0,a3,316 <memcmp+0x14>
  }
  return 0;
 32a:	4501                	li	a0,0
 32c:	a019                	j	332 <memcmp+0x30>
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
  return 0;
 338:	4501                	li	a0,0
 33a:	bfe5                	j	332 <memcmp+0x30>

000000000000033c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e406                	sd	ra,8(sp)
 340:	e022                	sd	s0,0(sp)
 342:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 344:	f63ff0ef          	jal	ra,2a6 <memmove>
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret

0000000000000350 <sbrk>:

char *
sbrk(int n) {
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 358:	4585                	li	a1,1
 35a:	0b2000ef          	jal	ra,40c <sys_sbrk>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <sbrklazy>:

char *
sbrklazy(int n) {
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 36e:	4589                	li	a1,2
 370:	09c000ef          	jal	ra,40c <sys_sbrk>
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 37c:	4885                	li	a7,1
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <exit>:
.global exit
exit:
 li a7, SYS_exit
 384:	4889                	li	a7,2
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <wait>:
.global wait
wait:
 li a7, SYS_wait
 38c:	488d                	li	a7,3
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 394:	4891                	li	a7,4
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <read>:
.global read
read:
 li a7, SYS_read
 39c:	4895                	li	a7,5
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <write>:
.global write
write:
 li a7, SYS_write
 3a4:	48c1                	li	a7,16
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <close>:
.global close
close:
 li a7, SYS_close
 3ac:	48d5                	li	a7,21
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b4:	4899                	li	a7,6
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3bc:	489d                	li	a7,7
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <open>:
.global open
open:
 li a7, SYS_open
 3c4:	48bd                	li	a7,15
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3cc:	48c5                	li	a7,17
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d4:	48c9                	li	a7,18
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3dc:	48a1                	li	a7,8
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <link>:
.global link
link:
 li a7, SYS_link
 3e4:	48cd                	li	a7,19
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ec:	48d1                	li	a7,20
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f4:	48a5                	li	a7,9
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3fc:	48a9                	li	a7,10
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 404:	48ad                	li	a7,11
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 40c:	48b1                	li	a7,12
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <pause>:
.global pause
pause:
 li a7, SYS_pause
 414:	48b5                	li	a7,13
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 41c:	48b9                	li	a7,14
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 424:	48d9                	li	a7,22
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42c:	1101                	addi	sp,sp,-32
 42e:	ec06                	sd	ra,24(sp)
 430:	e822                	sd	s0,16(sp)
 432:	1000                	addi	s0,sp,32
 434:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 438:	4605                	li	a2,1
 43a:	fef40593          	addi	a1,s0,-17
 43e:	f67ff0ef          	jal	ra,3a4 <write>
}
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	6105                	addi	sp,sp,32
 448:	8082                	ret

000000000000044a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 44a:	715d                	addi	sp,sp,-80
 44c:	e486                	sd	ra,72(sp)
 44e:	e0a2                	sd	s0,64(sp)
 450:	fc26                	sd	s1,56(sp)
 452:	f84a                	sd	s2,48(sp)
 454:	f44e                	sd	s3,40(sp)
 456:	0880                	addi	s0,sp,80
 458:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 45a:	c299                	beqz	a3,460 <printint+0x16>
 45c:	0805c163          	bltz	a1,4de <printint+0x94>
  neg = 0;
 460:	4881                	li	a7,0
 462:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 466:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 468:	00000517          	auipc	a0,0x0
 46c:	52850513          	addi	a0,a0,1320 # 990 <digits>
 470:	883e                	mv	a6,a5
 472:	2785                	addiw	a5,a5,1
 474:	02c5f733          	remu	a4,a1,a2
 478:	972a                	add	a4,a4,a0
 47a:	00074703          	lbu	a4,0(a4)
 47e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 482:	872e                	mv	a4,a1
 484:	02c5d5b3          	divu	a1,a1,a2
 488:	0685                	addi	a3,a3,1
 48a:	fec773e3          	bgeu	a4,a2,470 <printint+0x26>
  if(neg)
 48e:	00088b63          	beqz	a7,4a4 <printint+0x5a>
    buf[i++] = '-';
 492:	fd040713          	addi	a4,s0,-48
 496:	97ba                	add	a5,a5,a4
 498:	02d00713          	li	a4,45
 49c:	fee78423          	sb	a4,-24(a5)
 4a0:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4a4:	02f05663          	blez	a5,4d0 <printint+0x86>
 4a8:	fb840713          	addi	a4,s0,-72
 4ac:	00f704b3          	add	s1,a4,a5
 4b0:	fff70993          	addi	s3,a4,-1
 4b4:	99be                	add	s3,s3,a5
 4b6:	37fd                	addiw	a5,a5,-1
 4b8:	1782                	slli	a5,a5,0x20
 4ba:	9381                	srli	a5,a5,0x20
 4bc:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4c0:	fff4c583          	lbu	a1,-1(s1)
 4c4:	854a                	mv	a0,s2
 4c6:	f67ff0ef          	jal	ra,42c <putc>
  while(--i >= 0)
 4ca:	14fd                	addi	s1,s1,-1
 4cc:	ff349ae3          	bne	s1,s3,4c0 <printint+0x76>
}
 4d0:	60a6                	ld	ra,72(sp)
 4d2:	6406                	ld	s0,64(sp)
 4d4:	74e2                	ld	s1,56(sp)
 4d6:	7942                	ld	s2,48(sp)
 4d8:	79a2                	ld	s3,40(sp)
 4da:	6161                	addi	sp,sp,80
 4dc:	8082                	ret
    x = -xx;
 4de:	40b005b3          	neg	a1,a1
    neg = 1;
 4e2:	4885                	li	a7,1
    x = -xx;
 4e4:	bfbd                	j	462 <printint+0x18>

00000000000004e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e6:	7119                	addi	sp,sp,-128
 4e8:	fc86                	sd	ra,120(sp)
 4ea:	f8a2                	sd	s0,112(sp)
 4ec:	f4a6                	sd	s1,104(sp)
 4ee:	f0ca                	sd	s2,96(sp)
 4f0:	ecce                	sd	s3,88(sp)
 4f2:	e8d2                	sd	s4,80(sp)
 4f4:	e4d6                	sd	s5,72(sp)
 4f6:	e0da                	sd	s6,64(sp)
 4f8:	fc5e                	sd	s7,56(sp)
 4fa:	f862                	sd	s8,48(sp)
 4fc:	f466                	sd	s9,40(sp)
 4fe:	f06a                	sd	s10,32(sp)
 500:	ec6e                	sd	s11,24(sp)
 502:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 504:	0005c903          	lbu	s2,0(a1)
 508:	24090c63          	beqz	s2,760 <vprintf+0x27a>
 50c:	8b2a                	mv	s6,a0
 50e:	8a2e                	mv	s4,a1
 510:	8bb2                	mv	s7,a2
  state = 0;
 512:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 514:	4481                	li	s1,0
 516:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 518:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 51c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 520:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 524:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 528:	00000c97          	auipc	s9,0x0
 52c:	468c8c93          	addi	s9,s9,1128 # 990 <digits>
 530:	a005                	j	550 <vprintf+0x6a>
        putc(fd, c0);
 532:	85ca                	mv	a1,s2
 534:	855a                	mv	a0,s6
 536:	ef7ff0ef          	jal	ra,42c <putc>
 53a:	a019                	j	540 <vprintf+0x5a>
    } else if(state == '%'){
 53c:	03598263          	beq	s3,s5,560 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 540:	2485                	addiw	s1,s1,1
 542:	8726                	mv	a4,s1
 544:	009a07b3          	add	a5,s4,s1
 548:	0007c903          	lbu	s2,0(a5)
 54c:	20090a63          	beqz	s2,760 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 550:	0009079b          	sext.w	a5,s2
    if(state == 0){
 554:	fe0994e3          	bnez	s3,53c <vprintf+0x56>
      if(c0 == '%'){
 558:	fd579de3          	bne	a5,s5,532 <vprintf+0x4c>
        state = '%';
 55c:	89be                	mv	s3,a5
 55e:	b7cd                	j	540 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 560:	c3c1                	beqz	a5,5e0 <vprintf+0xfa>
 562:	00ea06b3          	add	a3,s4,a4
 566:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 56a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 56c:	c681                	beqz	a3,574 <vprintf+0x8e>
 56e:	9752                	add	a4,a4,s4
 570:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 574:	03878e63          	beq	a5,s8,5b0 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 578:	05a78863          	beq	a5,s10,5c8 <vprintf+0xe2>
      } else if(c0 == 'u'){
 57c:	0db78b63          	beq	a5,s11,652 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 580:	07800713          	li	a4,120
 584:	10e78d63          	beq	a5,a4,69e <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 588:	07000713          	li	a4,112
 58c:	14e78263          	beq	a5,a4,6d0 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 590:	06300713          	li	a4,99
 594:	16e78f63          	beq	a5,a4,712 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 598:	07300713          	li	a4,115
 59c:	18e78563          	beq	a5,a4,726 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5a0:	05579063          	bne	a5,s5,5e0 <vprintf+0xfa>
        putc(fd, '%');
 5a4:	85d6                	mv	a1,s5
 5a6:	855a                	mv	a0,s6
 5a8:	e85ff0ef          	jal	ra,42c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	bf49                	j	540 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	4685                	li	a3,1
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	e8dff0ef          	jal	ra,44a <printint>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bfad                	j	540 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5c8:	03868663          	beq	a3,s8,5f4 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5cc:	05a68163          	beq	a3,s10,60e <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 5d0:	09b68d63          	beq	a3,s11,66a <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d4:	03a68f63          	beq	a3,s10,612 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 5d8:	07800793          	li	a5,120
 5dc:	0cf68d63          	beq	a3,a5,6b6 <vprintf+0x1d0>
        putc(fd, '%');
 5e0:	85d6                	mv	a1,s5
 5e2:	855a                	mv	a0,s6
 5e4:	e49ff0ef          	jal	ra,42c <putc>
        putc(fd, c0);
 5e8:	85ca                	mv	a1,s2
 5ea:	855a                	mv	a0,s6
 5ec:	e41ff0ef          	jal	ra,42c <putc>
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b7b9                	j	540 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	4685                	li	a3,1
 5fa:	4629                	li	a2,10
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	e49ff0ef          	jal	ra,44a <printint>
        i += 1;
 606:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
        i += 1;
 60c:	bf15                	j	540 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 60e:	03860563          	beq	a2,s8,638 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 612:	07b60963          	beq	a2,s11,684 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 616:	07800793          	li	a5,120
 61a:	fcf613e3          	bne	a2,a5,5e0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61e:	008b8913          	addi	s2,s7,8
 622:	4681                	li	a3,0
 624:	4641                	li	a2,16
 626:	000bb583          	ld	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	e1fff0ef          	jal	ra,44a <printint>
        i += 2;
 630:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
        i += 2;
 636:	b729                	j	540 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 638:	008b8913          	addi	s2,s7,8
 63c:	4685                	li	a3,1
 63e:	4629                	li	a2,10
 640:	000bb583          	ld	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	e05ff0ef          	jal	ra,44a <printint>
        i += 2;
 64a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
        i += 2;
 650:	bdc5                	j	540 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 652:	008b8913          	addi	s2,s7,8
 656:	4681                	li	a3,0
 658:	4629                	li	a2,10
 65a:	000be583          	lwu	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	debff0ef          	jal	ra,44a <printint>
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
 668:	bde1                	j	540 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4681                	li	a3,0
 670:	4629                	li	a2,10
 672:	000bb583          	ld	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	dd3ff0ef          	jal	ra,44a <printint>
        i += 1;
 67c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 67e:	8bca                	mv	s7,s2
      state = 0;
 680:	4981                	li	s3,0
        i += 1;
 682:	bd7d                	j	540 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 684:	008b8913          	addi	s2,s7,8
 688:	4681                	li	a3,0
 68a:	4629                	li	a2,10
 68c:	000bb583          	ld	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	db9ff0ef          	jal	ra,44a <printint>
        i += 2;
 696:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 698:	8bca                	mv	s7,s2
      state = 0;
 69a:	4981                	li	s3,0
        i += 2;
 69c:	b555                	j	540 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 69e:	008b8913          	addi	s2,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4641                	li	a2,16
 6a6:	000be583          	lwu	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	d9fff0ef          	jal	ra,44a <printint>
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b571                	j	540 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4641                	li	a2,16
 6be:	000bb583          	ld	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	d87ff0ef          	jal	ra,44a <printint>
        i += 1;
 6c8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ca:	8bca                	mv	s7,s2
      state = 0;
 6cc:	4981                	li	s3,0
        i += 1;
 6ce:	bd8d                	j	540 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6d0:	008b8793          	addi	a5,s7,8
 6d4:	f8f43423          	sd	a5,-120(s0)
 6d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6dc:	03000593          	li	a1,48
 6e0:	855a                	mv	a0,s6
 6e2:	d4bff0ef          	jal	ra,42c <putc>
  putc(fd, 'x');
 6e6:	07800593          	li	a1,120
 6ea:	855a                	mv	a0,s6
 6ec:	d41ff0ef          	jal	ra,42c <putc>
 6f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f2:	03c9d793          	srli	a5,s3,0x3c
 6f6:	97e6                	add	a5,a5,s9
 6f8:	0007c583          	lbu	a1,0(a5)
 6fc:	855a                	mv	a0,s6
 6fe:	d2fff0ef          	jal	ra,42c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 702:	0992                	slli	s3,s3,0x4
 704:	397d                	addiw	s2,s2,-1
 706:	fe0916e3          	bnez	s2,6f2 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 70a:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 70e:	4981                	li	s3,0
 710:	bd05                	j	540 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 712:	008b8913          	addi	s2,s7,8
 716:	000bc583          	lbu	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	d11ff0ef          	jal	ra,42c <putc>
 720:	8bca                	mv	s7,s2
      state = 0;
 722:	4981                	li	s3,0
 724:	bd31                	j	540 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 726:	008b8993          	addi	s3,s7,8
 72a:	000bb903          	ld	s2,0(s7)
 72e:	00090f63          	beqz	s2,74c <vprintf+0x266>
        for(; *s; s++)
 732:	00094583          	lbu	a1,0(s2)
 736:	c195                	beqz	a1,75a <vprintf+0x274>
          putc(fd, *s);
 738:	855a                	mv	a0,s6
 73a:	cf3ff0ef          	jal	ra,42c <putc>
        for(; *s; s++)
 73e:	0905                	addi	s2,s2,1
 740:	00094583          	lbu	a1,0(s2)
 744:	f9f5                	bnez	a1,738 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 746:	8bce                	mv	s7,s3
      state = 0;
 748:	4981                	li	s3,0
 74a:	bbdd                	j	540 <vprintf+0x5a>
          s = "(null)";
 74c:	00000917          	auipc	s2,0x0
 750:	23c90913          	addi	s2,s2,572 # 988 <malloc+0x126>
        for(; *s; s++)
 754:	02800593          	li	a1,40
 758:	b7c5                	j	738 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 75a:	8bce                	mv	s7,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b3cd                	j	540 <vprintf+0x5a>
    }
  }
}
 760:	70e6                	ld	ra,120(sp)
 762:	7446                	ld	s0,112(sp)
 764:	74a6                	ld	s1,104(sp)
 766:	7906                	ld	s2,96(sp)
 768:	69e6                	ld	s3,88(sp)
 76a:	6a46                	ld	s4,80(sp)
 76c:	6aa6                	ld	s5,72(sp)
 76e:	6b06                	ld	s6,64(sp)
 770:	7be2                	ld	s7,56(sp)
 772:	7c42                	ld	s8,48(sp)
 774:	7ca2                	ld	s9,40(sp)
 776:	7d02                	ld	s10,32(sp)
 778:	6de2                	ld	s11,24(sp)
 77a:	6109                	addi	sp,sp,128
 77c:	8082                	ret

000000000000077e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77e:	715d                	addi	sp,sp,-80
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e010                	sd	a2,0(s0)
 788:	e414                	sd	a3,8(s0)
 78a:	e818                	sd	a4,16(s0)
 78c:	ec1c                	sd	a5,24(s0)
 78e:	03043023          	sd	a6,32(s0)
 792:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79a:	8622                	mv	a2,s0
 79c:	d4bff0ef          	jal	ra,4e6 <vprintf>
}
 7a0:	60e2                	ld	ra,24(sp)
 7a2:	6442                	ld	s0,16(sp)
 7a4:	6161                	addi	sp,sp,80
 7a6:	8082                	ret

00000000000007a8 <printf>:

void
printf(const char *fmt, ...)
{
 7a8:	711d                	addi	sp,sp,-96
 7aa:	ec06                	sd	ra,24(sp)
 7ac:	e822                	sd	s0,16(sp)
 7ae:	1000                	addi	s0,sp,32
 7b0:	e40c                	sd	a1,8(s0)
 7b2:	e810                	sd	a2,16(s0)
 7b4:	ec14                	sd	a3,24(s0)
 7b6:	f018                	sd	a4,32(s0)
 7b8:	f41c                	sd	a5,40(s0)
 7ba:	03043823          	sd	a6,48(s0)
 7be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c2:	00840613          	addi	a2,s0,8
 7c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ca:	85aa                	mv	a1,a0
 7cc:	4505                	li	a0,1
 7ce:	d19ff0ef          	jal	ra,4e6 <vprintf>
}
 7d2:	60e2                	ld	ra,24(sp)
 7d4:	6442                	ld	s0,16(sp)
 7d6:	6125                	addi	sp,sp,96
 7d8:	8082                	ret

00000000000007da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7da:	1141                	addi	sp,sp,-16
 7dc:	e422                	sd	s0,8(sp)
 7de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	00001797          	auipc	a5,0x1
 7e8:	81c7b783          	ld	a5,-2020(a5) # 1000 <freep>
 7ec:	a805                	j	81c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ee:	4618                	lw	a4,8(a2)
 7f0:	9db9                	addw	a1,a1,a4
 7f2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	6398                	ld	a4,0(a5)
 7f8:	6318                	ld	a4,0(a4)
 7fa:	fee53823          	sd	a4,-16(a0)
 7fe:	a091                	j	842 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 800:	ff852703          	lw	a4,-8(a0)
 804:	9e39                	addw	a2,a2,a4
 806:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 808:	ff053703          	ld	a4,-16(a0)
 80c:	e398                	sd	a4,0(a5)
 80e:	a099                	j	854 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	6398                	ld	a4,0(a5)
 812:	00e7e463          	bltu	a5,a4,81a <free+0x40>
 816:	00e6ea63          	bltu	a3,a4,82a <free+0x50>
{
 81a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81c:	fed7fae3          	bgeu	a5,a3,810 <free+0x36>
 820:	6398                	ld	a4,0(a5)
 822:	00e6e463          	bltu	a3,a4,82a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 826:	fee7eae3          	bltu	a5,a4,81a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 82a:	ff852583          	lw	a1,-8(a0)
 82e:	6390                	ld	a2,0(a5)
 830:	02059713          	slli	a4,a1,0x20
 834:	9301                	srli	a4,a4,0x20
 836:	0712                	slli	a4,a4,0x4
 838:	9736                	add	a4,a4,a3
 83a:	fae60ae3          	beq	a2,a4,7ee <free+0x14>
    bp->s.ptr = p->s.ptr;
 83e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 842:	4790                	lw	a2,8(a5)
 844:	02061713          	slli	a4,a2,0x20
 848:	9301                	srli	a4,a4,0x20
 84a:	0712                	slli	a4,a4,0x4
 84c:	973e                	add	a4,a4,a5
 84e:	fae689e3          	beq	a3,a4,800 <free+0x26>
  } else
    p->s.ptr = bp;
 852:	e394                	sd	a3,0(a5)
  freep = p;
 854:	00000717          	auipc	a4,0x0
 858:	7af73623          	sd	a5,1964(a4) # 1000 <freep>
}
 85c:	6422                	ld	s0,8(sp)
 85e:	0141                	addi	sp,sp,16
 860:	8082                	ret

0000000000000862 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 862:	7139                	addi	sp,sp,-64
 864:	fc06                	sd	ra,56(sp)
 866:	f822                	sd	s0,48(sp)
 868:	f426                	sd	s1,40(sp)
 86a:	f04a                	sd	s2,32(sp)
 86c:	ec4e                	sd	s3,24(sp)
 86e:	e852                	sd	s4,16(sp)
 870:	e456                	sd	s5,8(sp)
 872:	e05a                	sd	s6,0(sp)
 874:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 876:	02051493          	slli	s1,a0,0x20
 87a:	9081                	srli	s1,s1,0x20
 87c:	04bd                	addi	s1,s1,15
 87e:	8091                	srli	s1,s1,0x4
 880:	0014899b          	addiw	s3,s1,1
 884:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 886:	00000517          	auipc	a0,0x0
 88a:	77a53503          	ld	a0,1914(a0) # 1000 <freep>
 88e:	c515                	beqz	a0,8ba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 892:	4798                	lw	a4,8(a5)
 894:	02977f63          	bgeu	a4,s1,8d2 <malloc+0x70>
 898:	8a4e                	mv	s4,s3
 89a:	0009871b          	sext.w	a4,s3
 89e:	6685                	lui	a3,0x1
 8a0:	00d77363          	bgeu	a4,a3,8a6 <malloc+0x44>
 8a4:	6a05                	lui	s4,0x1
 8a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ae:	00000917          	auipc	s2,0x0
 8b2:	75290913          	addi	s2,s2,1874 # 1000 <freep>
  if(p == SBRK_ERROR)
 8b6:	5afd                	li	s5,-1
 8b8:	a0bd                	j	926 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 8ba:	00001797          	auipc	a5,0x1
 8be:	95678793          	addi	a5,a5,-1706 # 1210 <base>
 8c2:	00000717          	auipc	a4,0x0
 8c6:	72f73f23          	sd	a5,1854(a4) # 1000 <freep>
 8ca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8cc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d0:	b7e1                	j	898 <malloc+0x36>
      if(p->s.size == nunits)
 8d2:	02e48b63          	beq	s1,a4,908 <malloc+0xa6>
        p->s.size -= nunits;
 8d6:	4137073b          	subw	a4,a4,s3
 8da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8dc:	1702                	slli	a4,a4,0x20
 8de:	9301                	srli	a4,a4,0x20
 8e0:	0712                	slli	a4,a4,0x4
 8e2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e8:	00000717          	auipc	a4,0x0
 8ec:	70a73c23          	sd	a0,1816(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8f4:	70e2                	ld	ra,56(sp)
 8f6:	7442                	ld	s0,48(sp)
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	7902                	ld	s2,32(sp)
 8fc:	69e2                	ld	s3,24(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6b02                	ld	s6,0(sp)
 904:	6121                	addi	sp,sp,64
 906:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 908:	6398                	ld	a4,0(a5)
 90a:	e118                	sd	a4,0(a0)
 90c:	bff1                	j	8e8 <malloc+0x86>
  hp->s.size = nu;
 90e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 912:	0541                	addi	a0,a0,16
 914:	ec7ff0ef          	jal	ra,7da <free>
  return freep;
 918:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 91c:	dd61                	beqz	a0,8f4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 920:	4798                	lw	a4,8(a5)
 922:	fa9778e3          	bgeu	a4,s1,8d2 <malloc+0x70>
    if(p == freep)
 926:	00093703          	ld	a4,0(s2)
 92a:	853e                	mv	a0,a5
 92c:	fef719e3          	bne	a4,a5,91e <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 930:	8552                	mv	a0,s4
 932:	a1fff0ef          	jal	ra,350 <sbrk>
  if(p == SBRK_ERROR)
 936:	fd551ce3          	bne	a0,s5,90e <malloc+0xac>
        return 0;
 93a:	4501                	li	a0,0
 93c:	bf65                	j	8f4 <malloc+0x92>
