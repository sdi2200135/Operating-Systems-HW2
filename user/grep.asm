
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	ra,4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	ra,0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	ra,4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	ra,4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	ra,4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	711d                	addi	sp,sp,-96
 108:	ec86                	sd	ra,88(sp)
 10a:	e8a2                	sd	s0,80(sp)
 10c:	e4a6                	sd	s1,72(sp)
 10e:	e0ca                	sd	s2,64(sp)
 110:	fc4e                	sd	s3,56(sp)
 112:	f852                	sd	s4,48(sp)
 114:	f456                	sd	s5,40(sp)
 116:	f05a                	sd	s6,32(sp)
 118:	ec5e                	sd	s7,24(sp)
 11a:	e862                	sd	s8,16(sp)
 11c:	e466                	sd	s9,8(sp)
 11e:	e06a                	sd	s10,0(sp)
 120:	1080                	addi	s0,sp,96
 122:	89aa                	mv	s3,a0
 124:	8bae                	mv	s7,a1
  m = 0;
 126:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 128:	3ff00c13          	li	s8,1023
 12c:	00001b17          	auipc	s6,0x1
 130:	ee4b0b13          	addi	s6,s6,-284 # 1010 <buf>
    p = buf;
 134:	8d5a                	mv	s10,s6
        *q = '\n';
 136:	4aa9                	li	s5,10
    p = buf;
 138:	8cda                	mv	s9,s6
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13a:	a82d                	j	174 <grep+0x6e>
        *q = '\n';
 13c:	01548023          	sb	s5,0(s1)
        write(1, p, q+1 - p);
 140:	00148613          	addi	a2,s1,1
 144:	4126063b          	subw	a2,a2,s2
 148:	85ca                	mv	a1,s2
 14a:	4505                	li	a0,1
 14c:	3d0000ef          	jal	ra,51c <write>
      p = q+1;
 150:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 154:	45a9                	li	a1,10
 156:	854a                	mv	a0,s2
 158:	1ae000ef          	jal	ra,306 <strchr>
 15c:	84aa                	mv	s1,a0
 15e:	c909                	beqz	a0,170 <grep+0x6a>
      *q = 0;
 160:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 164:	85ca                	mv	a1,s2
 166:	854e                	mv	a0,s3
 168:	f59ff0ef          	jal	ra,c0 <match>
 16c:	d175                	beqz	a0,150 <grep+0x4a>
 16e:	b7f9                	j	13c <grep+0x36>
    if(m > 0){
 170:	03404363          	bgtz	s4,196 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 174:	414c063b          	subw	a2,s8,s4
 178:	014b05b3          	add	a1,s6,s4
 17c:	855e                	mv	a0,s7
 17e:	396000ef          	jal	ra,514 <read>
 182:	02a05463          	blez	a0,1aa <grep+0xa4>
    m += n;
 186:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 18a:	014b07b3          	add	a5,s6,s4
 18e:	00078023          	sb	zero,0(a5)
    p = buf;
 192:	8966                	mv	s2,s9
    while((q = strchr(p, '\n')) != 0){
 194:	b7c1                	j	154 <grep+0x4e>
      m -= p - buf;
 196:	416907b3          	sub	a5,s2,s6
 19a:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 19e:	8652                	mv	a2,s4
 1a0:	85ca                	mv	a1,s2
 1a2:	856a                	mv	a0,s10
 1a4:	27a000ef          	jal	ra,41e <memmove>
 1a8:	b7f1                	j	174 <grep+0x6e>
}
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6c42                	ld	s8,16(sp)
 1be:	6ca2                	ld	s9,8(sp)
 1c0:	6d02                	ld	s10,0(sp)
 1c2:	6125                	addi	sp,sp,96
 1c4:	8082                	ret

00000000000001c6 <main>:
{
 1c6:	7139                	addi	sp,sp,-64
 1c8:	fc06                	sd	ra,56(sp)
 1ca:	f822                	sd	s0,48(sp)
 1cc:	f426                	sd	s1,40(sp)
 1ce:	f04a                	sd	s2,32(sp)
 1d0:	ec4e                	sd	s3,24(sp)
 1d2:	e852                	sd	s4,16(sp)
 1d4:	e456                	sd	s5,8(sp)
 1d6:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1d8:	4785                	li	a5,1
 1da:	04a7d663          	bge	a5,a0,226 <main+0x60>
  pattern = argv[1];
 1de:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1e2:	4789                	li	a5,2
 1e4:	04a7db63          	bge	a5,a0,23a <main+0x74>
 1e8:	01058913          	addi	s2,a1,16
 1ec:	ffd5099b          	addiw	s3,a0,-3
 1f0:	1982                	slli	s3,s3,0x20
 1f2:	0209d993          	srli	s3,s3,0x20
 1f6:	098e                	slli	s3,s3,0x3
 1f8:	05e1                	addi	a1,a1,24
 1fa:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1fc:	4581                	li	a1,0
 1fe:	00093503          	ld	a0,0(s2)
 202:	33a000ef          	jal	ra,53c <open>
 206:	84aa                	mv	s1,a0
 208:	04054063          	bltz	a0,248 <main+0x82>
    grep(pattern, fd);
 20c:	85aa                	mv	a1,a0
 20e:	8552                	mv	a0,s4
 210:	ef7ff0ef          	jal	ra,106 <grep>
    close(fd);
 214:	8526                	mv	a0,s1
 216:	30e000ef          	jal	ra,524 <close>
  for(i = 2; i < argc; i++){
 21a:	0921                	addi	s2,s2,8
 21c:	ff3910e3          	bne	s2,s3,1fc <main+0x36>
  exit(0);
 220:	4501                	li	a0,0
 222:	2da000ef          	jal	ra,4fc <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 226:	00001597          	auipc	a1,0x1
 22a:	89a58593          	addi	a1,a1,-1894 # ac0 <malloc+0xe6>
 22e:	4509                	li	a0,2
 230:	6c6000ef          	jal	ra,8f6 <fprintf>
    exit(1);
 234:	4505                	li	a0,1
 236:	2c6000ef          	jal	ra,4fc <exit>
    grep(pattern, 0);
 23a:	4581                	li	a1,0
 23c:	8552                	mv	a0,s4
 23e:	ec9ff0ef          	jal	ra,106 <grep>
    exit(0);
 242:	4501                	li	a0,0
 244:	2b8000ef          	jal	ra,4fc <exit>
      printf("grep: cannot open %s\n", argv[i]);
 248:	00093583          	ld	a1,0(s2)
 24c:	00001517          	auipc	a0,0x1
 250:	89450513          	addi	a0,a0,-1900 # ae0 <malloc+0x106>
 254:	6cc000ef          	jal	ra,920 <printf>
      exit(1);
 258:	4505                	li	a0,1
 25a:	2a2000ef          	jal	ra,4fc <exit>

000000000000025e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 266:	f61ff0ef          	jal	ra,1c6 <main>
  exit(r);
 26a:	292000ef          	jal	ra,4fc <exit>

000000000000026e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 274:	87aa                	mv	a5,a0
 276:	0585                	addi	a1,a1,1
 278:	0785                	addi	a5,a5,1
 27a:	fff5c703          	lbu	a4,-1(a1)
 27e:	fee78fa3          	sb	a4,-1(a5)
 282:	fb75                	bnez	a4,276 <strcpy+0x8>
    ;
  return os;
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 290:	00054783          	lbu	a5,0(a0)
 294:	cb91                	beqz	a5,2a8 <strcmp+0x1e>
 296:	0005c703          	lbu	a4,0(a1)
 29a:	00f71763          	bne	a4,a5,2a8 <strcmp+0x1e>
    p++, q++;
 29e:	0505                	addi	a0,a0,1
 2a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	fbe5                	bnez	a5,296 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a8:	0005c503          	lbu	a0,0(a1)
}
 2ac:	40a7853b          	subw	a0,a5,a0
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <strlen>:

uint
strlen(const char *s)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	cf91                	beqz	a5,2dc <strlen+0x26>
 2c2:	0505                	addi	a0,a0,1
 2c4:	87aa                	mv	a5,a0
 2c6:	4685                	li	a3,1
 2c8:	9e89                	subw	a3,a3,a0
 2ca:	00f6853b          	addw	a0,a3,a5
 2ce:	0785                	addi	a5,a5,1
 2d0:	fff7c703          	lbu	a4,-1(a5)
 2d4:	fb7d                	bnez	a4,2ca <strlen+0x14>
    ;
  return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  for(n = 0; s[n]; n++)
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <strlen+0x20>

00000000000002e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e6:	ce09                	beqz	a2,300 <memset+0x20>
 2e8:	87aa                	mv	a5,a0
 2ea:	fff6071b          	addiw	a4,a2,-1
 2ee:	1702                	slli	a4,a4,0x20
 2f0:	9301                	srli	a4,a4,0x20
 2f2:	0705                	addi	a4,a4,1
 2f4:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fa:	0785                	addi	a5,a5,1
 2fc:	fee79de3          	bne	a5,a4,2f6 <memset+0x16>
  }
  return dst;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <strchr>:

char*
strchr(const char *s, char c)
{
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 30c:	00054783          	lbu	a5,0(a0)
 310:	cb99                	beqz	a5,326 <strchr+0x20>
    if(*s == c)
 312:	00f58763          	beq	a1,a5,320 <strchr+0x1a>
  for(; *s; s++)
 316:	0505                	addi	a0,a0,1
 318:	00054783          	lbu	a5,0(a0)
 31c:	fbfd                	bnez	a5,312 <strchr+0xc>
      return (char*)s;
  return 0;
 31e:	4501                	li	a0,0
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <strchr+0x1a>

000000000000032a <gets>:

char*
gets(char *buf, int max)
{
 32a:	711d                	addi	sp,sp,-96
 32c:	ec86                	sd	ra,88(sp)
 32e:	e8a2                	sd	s0,80(sp)
 330:	e4a6                	sd	s1,72(sp)
 332:	e0ca                	sd	s2,64(sp)
 334:	fc4e                	sd	s3,56(sp)
 336:	f852                	sd	s4,48(sp)
 338:	f456                	sd	s5,40(sp)
 33a:	f05a                	sd	s6,32(sp)
 33c:	ec5e                	sd	s7,24(sp)
 33e:	1080                	addi	s0,sp,96
 340:	8baa                	mv	s7,a0
 342:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 344:	892a                	mv	s2,a0
 346:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 348:	4aa9                	li	s5,10
 34a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 34c:	89a6                	mv	s3,s1
 34e:	2485                	addiw	s1,s1,1
 350:	0344d663          	bge	s1,s4,37c <gets+0x52>
    cc = read(0, &c, 1);
 354:	4605                	li	a2,1
 356:	faf40593          	addi	a1,s0,-81
 35a:	4501                	li	a0,0
 35c:	1b8000ef          	jal	ra,514 <read>
    if(cc < 1)
 360:	00a05e63          	blez	a0,37c <gets+0x52>
    buf[i++] = c;
 364:	faf44783          	lbu	a5,-81(s0)
 368:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 36c:	01578763          	beq	a5,s5,37a <gets+0x50>
 370:	0905                	addi	s2,s2,1
 372:	fd679de3          	bne	a5,s6,34c <gets+0x22>
  for(i=0; i+1 < max; ){
 376:	89a6                	mv	s3,s1
 378:	a011                	j	37c <gets+0x52>
 37a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 37c:	99de                	add	s3,s3,s7
 37e:	00098023          	sb	zero,0(s3)
  return buf;
}
 382:	855e                	mv	a0,s7
 384:	60e6                	ld	ra,88(sp)
 386:	6446                	ld	s0,80(sp)
 388:	64a6                	ld	s1,72(sp)
 38a:	6906                	ld	s2,64(sp)
 38c:	79e2                	ld	s3,56(sp)
 38e:	7a42                	ld	s4,48(sp)
 390:	7aa2                	ld	s5,40(sp)
 392:	7b02                	ld	s6,32(sp)
 394:	6be2                	ld	s7,24(sp)
 396:	6125                	addi	sp,sp,96
 398:	8082                	ret

000000000000039a <stat>:

int
stat(const char *n, struct stat *st)
{
 39a:	1101                	addi	sp,sp,-32
 39c:	ec06                	sd	ra,24(sp)
 39e:	e822                	sd	s0,16(sp)
 3a0:	e426                	sd	s1,8(sp)
 3a2:	e04a                	sd	s2,0(sp)
 3a4:	1000                	addi	s0,sp,32
 3a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a8:	4581                	li	a1,0
 3aa:	192000ef          	jal	ra,53c <open>
  if(fd < 0)
 3ae:	02054163          	bltz	a0,3d0 <stat+0x36>
 3b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b4:	85ca                	mv	a1,s2
 3b6:	19e000ef          	jal	ra,554 <fstat>
 3ba:	892a                	mv	s2,a0
  close(fd);
 3bc:	8526                	mv	a0,s1
 3be:	166000ef          	jal	ra,524 <close>
  return r;
}
 3c2:	854a                	mv	a0,s2
 3c4:	60e2                	ld	ra,24(sp)
 3c6:	6442                	ld	s0,16(sp)
 3c8:	64a2                	ld	s1,8(sp)
 3ca:	6902                	ld	s2,0(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret
    return -1;
 3d0:	597d                	li	s2,-1
 3d2:	bfc5                	j	3c2 <stat+0x28>

00000000000003d4 <atoi>:

int
atoi(const char *s)
{
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e422                	sd	s0,8(sp)
 3d8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3da:	00054603          	lbu	a2,0(a0)
 3de:	fd06079b          	addiw	a5,a2,-48
 3e2:	0ff7f793          	andi	a5,a5,255
 3e6:	4725                	li	a4,9
 3e8:	02f76963          	bltu	a4,a5,41a <atoi+0x46>
 3ec:	86aa                	mv	a3,a0
  n = 0;
 3ee:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3f0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3f2:	0685                	addi	a3,a3,1
 3f4:	0025179b          	slliw	a5,a0,0x2
 3f8:	9fa9                	addw	a5,a5,a0
 3fa:	0017979b          	slliw	a5,a5,0x1
 3fe:	9fb1                	addw	a5,a5,a2
 400:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 404:	0006c603          	lbu	a2,0(a3)
 408:	fd06071b          	addiw	a4,a2,-48
 40c:	0ff77713          	andi	a4,a4,255
 410:	fee5f1e3          	bgeu	a1,a4,3f2 <atoi+0x1e>
  return n;
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret
  n = 0;
 41a:	4501                	li	a0,0
 41c:	bfe5                	j	414 <atoi+0x40>

000000000000041e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 424:	02b57663          	bgeu	a0,a1,450 <memmove+0x32>
    while(n-- > 0)
 428:	02c05163          	blez	a2,44a <memmove+0x2c>
 42c:	fff6079b          	addiw	a5,a2,-1
 430:	1782                	slli	a5,a5,0x20
 432:	9381                	srli	a5,a5,0x20
 434:	0785                	addi	a5,a5,1
 436:	97aa                	add	a5,a5,a0
  dst = vdst;
 438:	872a                	mv	a4,a0
      *dst++ = *src++;
 43a:	0585                	addi	a1,a1,1
 43c:	0705                	addi	a4,a4,1
 43e:	fff5c683          	lbu	a3,-1(a1)
 442:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 446:	fee79ae3          	bne	a5,a4,43a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44a:	6422                	ld	s0,8(sp)
 44c:	0141                	addi	sp,sp,16
 44e:	8082                	ret
    dst += n;
 450:	00c50733          	add	a4,a0,a2
    src += n;
 454:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 456:	fec05ae3          	blez	a2,44a <memmove+0x2c>
 45a:	fff6079b          	addiw	a5,a2,-1
 45e:	1782                	slli	a5,a5,0x20
 460:	9381                	srli	a5,a5,0x20
 462:	fff7c793          	not	a5,a5
 466:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 468:	15fd                	addi	a1,a1,-1
 46a:	177d                	addi	a4,a4,-1
 46c:	0005c683          	lbu	a3,0(a1)
 470:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 474:	fee79ae3          	bne	a5,a4,468 <memmove+0x4a>
 478:	bfc9                	j	44a <memmove+0x2c>

000000000000047a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47a:	1141                	addi	sp,sp,-16
 47c:	e422                	sd	s0,8(sp)
 47e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 480:	ca05                	beqz	a2,4b0 <memcmp+0x36>
 482:	fff6069b          	addiw	a3,a2,-1
 486:	1682                	slli	a3,a3,0x20
 488:	9281                	srli	a3,a3,0x20
 48a:	0685                	addi	a3,a3,1
 48c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 48e:	00054783          	lbu	a5,0(a0)
 492:	0005c703          	lbu	a4,0(a1)
 496:	00e79863          	bne	a5,a4,4a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49a:	0505                	addi	a0,a0,1
    p2++;
 49c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 49e:	fed518e3          	bne	a0,a3,48e <memcmp+0x14>
  }
  return 0;
 4a2:	4501                	li	a0,0
 4a4:	a019                	j	4aa <memcmp+0x30>
      return *p1 - *p2;
 4a6:	40e7853b          	subw	a0,a5,a4
}
 4aa:	6422                	ld	s0,8(sp)
 4ac:	0141                	addi	sp,sp,16
 4ae:	8082                	ret
  return 0;
 4b0:	4501                	li	a0,0
 4b2:	bfe5                	j	4aa <memcmp+0x30>

00000000000004b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b4:	1141                	addi	sp,sp,-16
 4b6:	e406                	sd	ra,8(sp)
 4b8:	e022                	sd	s0,0(sp)
 4ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4bc:	f63ff0ef          	jal	ra,41e <memmove>
}
 4c0:	60a2                	ld	ra,8(sp)
 4c2:	6402                	ld	s0,0(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret

00000000000004c8 <sbrk>:

char *
sbrk(int n) {
 4c8:	1141                	addi	sp,sp,-16
 4ca:	e406                	sd	ra,8(sp)
 4cc:	e022                	sd	s0,0(sp)
 4ce:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4d0:	4585                	li	a1,1
 4d2:	0b2000ef          	jal	ra,584 <sys_sbrk>
}
 4d6:	60a2                	ld	ra,8(sp)
 4d8:	6402                	ld	s0,0(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret

00000000000004de <sbrklazy>:

char *
sbrklazy(int n) {
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4e6:	4589                	li	a1,2
 4e8:	09c000ef          	jal	ra,584 <sys_sbrk>
}
 4ec:	60a2                	ld	ra,8(sp)
 4ee:	6402                	ld	s0,0(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret

00000000000004f4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f4:	4885                	li	a7,1
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4fc:	4889                	li	a7,2
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <wait>:
.global wait
wait:
 li a7, SYS_wait
 504:	488d                	li	a7,3
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 50c:	4891                	li	a7,4
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <read>:
.global read
read:
 li a7, SYS_read
 514:	4895                	li	a7,5
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <write>:
.global write
write:
 li a7, SYS_write
 51c:	48c1                	li	a7,16
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <close>:
.global close
close:
 li a7, SYS_close
 524:	48d5                	li	a7,21
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <kill>:
.global kill
kill:
 li a7, SYS_kill
 52c:	4899                	li	a7,6
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <exec>:
.global exec
exec:
 li a7, SYS_exec
 534:	489d                	li	a7,7
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <open>:
.global open
open:
 li a7, SYS_open
 53c:	48bd                	li	a7,15
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 544:	48c5                	li	a7,17
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 54c:	48c9                	li	a7,18
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 554:	48a1                	li	a7,8
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <link>:
.global link
link:
 li a7, SYS_link
 55c:	48cd                	li	a7,19
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 564:	48d1                	li	a7,20
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 56c:	48a5                	li	a7,9
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <dup>:
.global dup
dup:
 li a7, SYS_dup
 574:	48a9                	li	a7,10
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 57c:	48ad                	li	a7,11
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 584:	48b1                	li	a7,12
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <pause>:
.global pause
pause:
 li a7, SYS_pause
 58c:	48b5                	li	a7,13
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 594:	48b9                	li	a7,14
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 59c:	48d9                	li	a7,22
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a4:	1101                	addi	sp,sp,-32
 5a6:	ec06                	sd	ra,24(sp)
 5a8:	e822                	sd	s0,16(sp)
 5aa:	1000                	addi	s0,sp,32
 5ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b0:	4605                	li	a2,1
 5b2:	fef40593          	addi	a1,s0,-17
 5b6:	f67ff0ef          	jal	ra,51c <write>
}
 5ba:	60e2                	ld	ra,24(sp)
 5bc:	6442                	ld	s0,16(sp)
 5be:	6105                	addi	sp,sp,32
 5c0:	8082                	ret

00000000000005c2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5c2:	715d                	addi	sp,sp,-80
 5c4:	e486                	sd	ra,72(sp)
 5c6:	e0a2                	sd	s0,64(sp)
 5c8:	fc26                	sd	s1,56(sp)
 5ca:	f84a                	sd	s2,48(sp)
 5cc:	f44e                	sd	s3,40(sp)
 5ce:	0880                	addi	s0,sp,80
 5d0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5d2:	c299                	beqz	a3,5d8 <printint+0x16>
 5d4:	0805c163          	bltz	a1,656 <printint+0x94>
  neg = 0;
 5d8:	4881                	li	a7,0
 5da:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5de:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5e0:	00000517          	auipc	a0,0x0
 5e4:	52050513          	addi	a0,a0,1312 # b00 <digits>
 5e8:	883e                	mv	a6,a5
 5ea:	2785                	addiw	a5,a5,1
 5ec:	02c5f733          	remu	a4,a1,a2
 5f0:	972a                	add	a4,a4,a0
 5f2:	00074703          	lbu	a4,0(a4)
 5f6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5fa:	872e                	mv	a4,a1
 5fc:	02c5d5b3          	divu	a1,a1,a2
 600:	0685                	addi	a3,a3,1
 602:	fec773e3          	bgeu	a4,a2,5e8 <printint+0x26>
  if(neg)
 606:	00088b63          	beqz	a7,61c <printint+0x5a>
    buf[i++] = '-';
 60a:	fd040713          	addi	a4,s0,-48
 60e:	97ba                	add	a5,a5,a4
 610:	02d00713          	li	a4,45
 614:	fee78423          	sb	a4,-24(a5)
 618:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 61c:	02f05663          	blez	a5,648 <printint+0x86>
 620:	fb840713          	addi	a4,s0,-72
 624:	00f704b3          	add	s1,a4,a5
 628:	fff70993          	addi	s3,a4,-1
 62c:	99be                	add	s3,s3,a5
 62e:	37fd                	addiw	a5,a5,-1
 630:	1782                	slli	a5,a5,0x20
 632:	9381                	srli	a5,a5,0x20
 634:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 638:	fff4c583          	lbu	a1,-1(s1)
 63c:	854a                	mv	a0,s2
 63e:	f67ff0ef          	jal	ra,5a4 <putc>
  while(--i >= 0)
 642:	14fd                	addi	s1,s1,-1
 644:	ff349ae3          	bne	s1,s3,638 <printint+0x76>
}
 648:	60a6                	ld	ra,72(sp)
 64a:	6406                	ld	s0,64(sp)
 64c:	74e2                	ld	s1,56(sp)
 64e:	7942                	ld	s2,48(sp)
 650:	79a2                	ld	s3,40(sp)
 652:	6161                	addi	sp,sp,80
 654:	8082                	ret
    x = -xx;
 656:	40b005b3          	neg	a1,a1
    neg = 1;
 65a:	4885                	li	a7,1
    x = -xx;
 65c:	bfbd                	j	5da <printint+0x18>

000000000000065e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 65e:	7119                	addi	sp,sp,-128
 660:	fc86                	sd	ra,120(sp)
 662:	f8a2                	sd	s0,112(sp)
 664:	f4a6                	sd	s1,104(sp)
 666:	f0ca                	sd	s2,96(sp)
 668:	ecce                	sd	s3,88(sp)
 66a:	e8d2                	sd	s4,80(sp)
 66c:	e4d6                	sd	s5,72(sp)
 66e:	e0da                	sd	s6,64(sp)
 670:	fc5e                	sd	s7,56(sp)
 672:	f862                	sd	s8,48(sp)
 674:	f466                	sd	s9,40(sp)
 676:	f06a                	sd	s10,32(sp)
 678:	ec6e                	sd	s11,24(sp)
 67a:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 67c:	0005c903          	lbu	s2,0(a1)
 680:	24090c63          	beqz	s2,8d8 <vprintf+0x27a>
 684:	8b2a                	mv	s6,a0
 686:	8a2e                	mv	s4,a1
 688:	8bb2                	mv	s7,a2
  state = 0;
 68a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 68c:	4481                	li	s1,0
 68e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 690:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 694:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 698:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 69c:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a0:	00000c97          	auipc	s9,0x0
 6a4:	460c8c93          	addi	s9,s9,1120 # b00 <digits>
 6a8:	a005                	j	6c8 <vprintf+0x6a>
        putc(fd, c0);
 6aa:	85ca                	mv	a1,s2
 6ac:	855a                	mv	a0,s6
 6ae:	ef7ff0ef          	jal	ra,5a4 <putc>
 6b2:	a019                	j	6b8 <vprintf+0x5a>
    } else if(state == '%'){
 6b4:	03598263          	beq	s3,s5,6d8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6b8:	2485                	addiw	s1,s1,1
 6ba:	8726                	mv	a4,s1
 6bc:	009a07b3          	add	a5,s4,s1
 6c0:	0007c903          	lbu	s2,0(a5)
 6c4:	20090a63          	beqz	s2,8d8 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 6c8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6cc:	fe0994e3          	bnez	s3,6b4 <vprintf+0x56>
      if(c0 == '%'){
 6d0:	fd579de3          	bne	a5,s5,6aa <vprintf+0x4c>
        state = '%';
 6d4:	89be                	mv	s3,a5
 6d6:	b7cd                	j	6b8 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6d8:	c3c1                	beqz	a5,758 <vprintf+0xfa>
 6da:	00ea06b3          	add	a3,s4,a4
 6de:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6e2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6e4:	c681                	beqz	a3,6ec <vprintf+0x8e>
 6e6:	9752                	add	a4,a4,s4
 6e8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ec:	03878e63          	beq	a5,s8,728 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 6f0:	05a78863          	beq	a5,s10,740 <vprintf+0xe2>
      } else if(c0 == 'u'){
 6f4:	0db78b63          	beq	a5,s11,7ca <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6f8:	07800713          	li	a4,120
 6fc:	10e78d63          	beq	a5,a4,816 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 700:	07000713          	li	a4,112
 704:	14e78263          	beq	a5,a4,848 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 708:	06300713          	li	a4,99
 70c:	16e78f63          	beq	a5,a4,88a <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 710:	07300713          	li	a4,115
 714:	18e78563          	beq	a5,a4,89e <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 718:	05579063          	bne	a5,s5,758 <vprintf+0xfa>
        putc(fd, '%');
 71c:	85d6                	mv	a1,s5
 71e:	855a                	mv	a0,s6
 720:	e85ff0ef          	jal	ra,5a4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 724:	4981                	li	s3,0
 726:	bf49                	j	6b8 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 728:	008b8913          	addi	s2,s7,8
 72c:	4685                	li	a3,1
 72e:	4629                	li	a2,10
 730:	000ba583          	lw	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	e8dff0ef          	jal	ra,5c2 <printint>
 73a:	8bca                	mv	s7,s2
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bfad                	j	6b8 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 740:	03868663          	beq	a3,s8,76c <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 744:	05a68163          	beq	a3,s10,786 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 748:	09b68d63          	beq	a3,s11,7e2 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 74c:	03a68f63          	beq	a3,s10,78a <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 750:	07800793          	li	a5,120
 754:	0cf68d63          	beq	a3,a5,82e <vprintf+0x1d0>
        putc(fd, '%');
 758:	85d6                	mv	a1,s5
 75a:	855a                	mv	a0,s6
 75c:	e49ff0ef          	jal	ra,5a4 <putc>
        putc(fd, c0);
 760:	85ca                	mv	a1,s2
 762:	855a                	mv	a0,s6
 764:	e41ff0ef          	jal	ra,5a4 <putc>
      state = 0;
 768:	4981                	li	s3,0
 76a:	b7b9                	j	6b8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 76c:	008b8913          	addi	s2,s7,8
 770:	4685                	li	a3,1
 772:	4629                	li	a2,10
 774:	000bb583          	ld	a1,0(s7)
 778:	855a                	mv	a0,s6
 77a:	e49ff0ef          	jal	ra,5c2 <printint>
        i += 1;
 77e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
        i += 1;
 784:	bf15                	j	6b8 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 786:	03860563          	beq	a2,s8,7b0 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 78a:	07b60963          	beq	a2,s11,7fc <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 78e:	07800793          	li	a5,120
 792:	fcf613e3          	bne	a2,a5,758 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 796:	008b8913          	addi	s2,s7,8
 79a:	4681                	li	a3,0
 79c:	4641                	li	a2,16
 79e:	000bb583          	ld	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	e1fff0ef          	jal	ra,5c2 <printint>
        i += 2;
 7a8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7aa:	8bca                	mv	s7,s2
      state = 0;
 7ac:	4981                	li	s3,0
        i += 2;
 7ae:	b729                	j	6b8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b0:	008b8913          	addi	s2,s7,8
 7b4:	4685                	li	a3,1
 7b6:	4629                	li	a2,10
 7b8:	000bb583          	ld	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	e05ff0ef          	jal	ra,5c2 <printint>
        i += 2;
 7c2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c4:	8bca                	mv	s7,s2
      state = 0;
 7c6:	4981                	li	s3,0
        i += 2;
 7c8:	bdc5                	j	6b8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7ca:	008b8913          	addi	s2,s7,8
 7ce:	4681                	li	a3,0
 7d0:	4629                	li	a2,10
 7d2:	000be583          	lwu	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	debff0ef          	jal	ra,5c2 <printint>
 7dc:	8bca                	mv	s7,s2
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	bde1                	j	6b8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e2:	008b8913          	addi	s2,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4629                	li	a2,10
 7ea:	000bb583          	ld	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	dd3ff0ef          	jal	ra,5c2 <printint>
        i += 1;
 7f4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f6:	8bca                	mv	s7,s2
      state = 0;
 7f8:	4981                	li	s3,0
        i += 1;
 7fa:	bd7d                	j	6b8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fc:	008b8913          	addi	s2,s7,8
 800:	4681                	li	a3,0
 802:	4629                	li	a2,10
 804:	000bb583          	ld	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	db9ff0ef          	jal	ra,5c2 <printint>
        i += 2;
 80e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 810:	8bca                	mv	s7,s2
      state = 0;
 812:	4981                	li	s3,0
        i += 2;
 814:	b555                	j	6b8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 816:	008b8913          	addi	s2,s7,8
 81a:	4681                	li	a3,0
 81c:	4641                	li	a2,16
 81e:	000be583          	lwu	a1,0(s7)
 822:	855a                	mv	a0,s6
 824:	d9fff0ef          	jal	ra,5c2 <printint>
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
 82c:	b571                	j	6b8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 82e:	008b8913          	addi	s2,s7,8
 832:	4681                	li	a3,0
 834:	4641                	li	a2,16
 836:	000bb583          	ld	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	d87ff0ef          	jal	ra,5c2 <printint>
        i += 1;
 840:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 842:	8bca                	mv	s7,s2
      state = 0;
 844:	4981                	li	s3,0
        i += 1;
 846:	bd8d                	j	6b8 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 848:	008b8793          	addi	a5,s7,8
 84c:	f8f43423          	sd	a5,-120(s0)
 850:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 854:	03000593          	li	a1,48
 858:	855a                	mv	a0,s6
 85a:	d4bff0ef          	jal	ra,5a4 <putc>
  putc(fd, 'x');
 85e:	07800593          	li	a1,120
 862:	855a                	mv	a0,s6
 864:	d41ff0ef          	jal	ra,5a4 <putc>
 868:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 86a:	03c9d793          	srli	a5,s3,0x3c
 86e:	97e6                	add	a5,a5,s9
 870:	0007c583          	lbu	a1,0(a5)
 874:	855a                	mv	a0,s6
 876:	d2fff0ef          	jal	ra,5a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 87a:	0992                	slli	s3,s3,0x4
 87c:	397d                	addiw	s2,s2,-1
 87e:	fe0916e3          	bnez	s2,86a <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 882:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 886:	4981                	li	s3,0
 888:	bd05                	j	6b8 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 88a:	008b8913          	addi	s2,s7,8
 88e:	000bc583          	lbu	a1,0(s7)
 892:	855a                	mv	a0,s6
 894:	d11ff0ef          	jal	ra,5a4 <putc>
 898:	8bca                	mv	s7,s2
      state = 0;
 89a:	4981                	li	s3,0
 89c:	bd31                	j	6b8 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 89e:	008b8993          	addi	s3,s7,8
 8a2:	000bb903          	ld	s2,0(s7)
 8a6:	00090f63          	beqz	s2,8c4 <vprintf+0x266>
        for(; *s; s++)
 8aa:	00094583          	lbu	a1,0(s2)
 8ae:	c195                	beqz	a1,8d2 <vprintf+0x274>
          putc(fd, *s);
 8b0:	855a                	mv	a0,s6
 8b2:	cf3ff0ef          	jal	ra,5a4 <putc>
        for(; *s; s++)
 8b6:	0905                	addi	s2,s2,1
 8b8:	00094583          	lbu	a1,0(s2)
 8bc:	f9f5                	bnez	a1,8b0 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 8be:	8bce                	mv	s7,s3
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	bbdd                	j	6b8 <vprintf+0x5a>
          s = "(null)";
 8c4:	00000917          	auipc	s2,0x0
 8c8:	23490913          	addi	s2,s2,564 # af8 <malloc+0x11e>
        for(; *s; s++)
 8cc:	02800593          	li	a1,40
 8d0:	b7c5                	j	8b0 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 8d2:	8bce                	mv	s7,s3
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	b3cd                	j	6b8 <vprintf+0x5a>
    }
  }
}
 8d8:	70e6                	ld	ra,120(sp)
 8da:	7446                	ld	s0,112(sp)
 8dc:	74a6                	ld	s1,104(sp)
 8de:	7906                	ld	s2,96(sp)
 8e0:	69e6                	ld	s3,88(sp)
 8e2:	6a46                	ld	s4,80(sp)
 8e4:	6aa6                	ld	s5,72(sp)
 8e6:	6b06                	ld	s6,64(sp)
 8e8:	7be2                	ld	s7,56(sp)
 8ea:	7c42                	ld	s8,48(sp)
 8ec:	7ca2                	ld	s9,40(sp)
 8ee:	7d02                	ld	s10,32(sp)
 8f0:	6de2                	ld	s11,24(sp)
 8f2:	6109                	addi	sp,sp,128
 8f4:	8082                	ret

00000000000008f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f6:	715d                	addi	sp,sp,-80
 8f8:	ec06                	sd	ra,24(sp)
 8fa:	e822                	sd	s0,16(sp)
 8fc:	1000                	addi	s0,sp,32
 8fe:	e010                	sd	a2,0(s0)
 900:	e414                	sd	a3,8(s0)
 902:	e818                	sd	a4,16(s0)
 904:	ec1c                	sd	a5,24(s0)
 906:	03043023          	sd	a6,32(s0)
 90a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 912:	8622                	mv	a2,s0
 914:	d4bff0ef          	jal	ra,65e <vprintf>
}
 918:	60e2                	ld	ra,24(sp)
 91a:	6442                	ld	s0,16(sp)
 91c:	6161                	addi	sp,sp,80
 91e:	8082                	ret

0000000000000920 <printf>:

void
printf(const char *fmt, ...)
{
 920:	711d                	addi	sp,sp,-96
 922:	ec06                	sd	ra,24(sp)
 924:	e822                	sd	s0,16(sp)
 926:	1000                	addi	s0,sp,32
 928:	e40c                	sd	a1,8(s0)
 92a:	e810                	sd	a2,16(s0)
 92c:	ec14                	sd	a3,24(s0)
 92e:	f018                	sd	a4,32(s0)
 930:	f41c                	sd	a5,40(s0)
 932:	03043823          	sd	a6,48(s0)
 936:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93a:	00840613          	addi	a2,s0,8
 93e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 942:	85aa                	mv	a1,a0
 944:	4505                	li	a0,1
 946:	d19ff0ef          	jal	ra,65e <vprintf>
}
 94a:	60e2                	ld	ra,24(sp)
 94c:	6442                	ld	s0,16(sp)
 94e:	6125                	addi	sp,sp,96
 950:	8082                	ret

0000000000000952 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 952:	1141                	addi	sp,sp,-16
 954:	e422                	sd	s0,8(sp)
 956:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 958:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95c:	00000797          	auipc	a5,0x0
 960:	6a47b783          	ld	a5,1700(a5) # 1000 <freep>
 964:	a805                	j	994 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 966:	4618                	lw	a4,8(a2)
 968:	9db9                	addw	a1,a1,a4
 96a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 96e:	6398                	ld	a4,0(a5)
 970:	6318                	ld	a4,0(a4)
 972:	fee53823          	sd	a4,-16(a0)
 976:	a091                	j	9ba <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 978:	ff852703          	lw	a4,-8(a0)
 97c:	9e39                	addw	a2,a2,a4
 97e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 980:	ff053703          	ld	a4,-16(a0)
 984:	e398                	sd	a4,0(a5)
 986:	a099                	j	9cc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 988:	6398                	ld	a4,0(a5)
 98a:	00e7e463          	bltu	a5,a4,992 <free+0x40>
 98e:	00e6ea63          	bltu	a3,a4,9a2 <free+0x50>
{
 992:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 994:	fed7fae3          	bgeu	a5,a3,988 <free+0x36>
 998:	6398                	ld	a4,0(a5)
 99a:	00e6e463          	bltu	a3,a4,9a2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99e:	fee7eae3          	bltu	a5,a4,992 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9a2:	ff852583          	lw	a1,-8(a0)
 9a6:	6390                	ld	a2,0(a5)
 9a8:	02059713          	slli	a4,a1,0x20
 9ac:	9301                	srli	a4,a4,0x20
 9ae:	0712                	slli	a4,a4,0x4
 9b0:	9736                	add	a4,a4,a3
 9b2:	fae60ae3          	beq	a2,a4,966 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ba:	4790                	lw	a2,8(a5)
 9bc:	02061713          	slli	a4,a2,0x20
 9c0:	9301                	srli	a4,a4,0x20
 9c2:	0712                	slli	a4,a4,0x4
 9c4:	973e                	add	a4,a4,a5
 9c6:	fae689e3          	beq	a3,a4,978 <free+0x26>
  } else
    p->s.ptr = bp;
 9ca:	e394                	sd	a3,0(a5)
  freep = p;
 9cc:	00000717          	auipc	a4,0x0
 9d0:	62f73a23          	sd	a5,1588(a4) # 1000 <freep>
}
 9d4:	6422                	ld	s0,8(sp)
 9d6:	0141                	addi	sp,sp,16
 9d8:	8082                	ret

00000000000009da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9da:	7139                	addi	sp,sp,-64
 9dc:	fc06                	sd	ra,56(sp)
 9de:	f822                	sd	s0,48(sp)
 9e0:	f426                	sd	s1,40(sp)
 9e2:	f04a                	sd	s2,32(sp)
 9e4:	ec4e                	sd	s3,24(sp)
 9e6:	e852                	sd	s4,16(sp)
 9e8:	e456                	sd	s5,8(sp)
 9ea:	e05a                	sd	s6,0(sp)
 9ec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ee:	02051493          	slli	s1,a0,0x20
 9f2:	9081                	srli	s1,s1,0x20
 9f4:	04bd                	addi	s1,s1,15
 9f6:	8091                	srli	s1,s1,0x4
 9f8:	0014899b          	addiw	s3,s1,1
 9fc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9fe:	00000517          	auipc	a0,0x0
 a02:	60253503          	ld	a0,1538(a0) # 1000 <freep>
 a06:	c515                	beqz	a0,a32 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a08:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0a:	4798                	lw	a4,8(a5)
 a0c:	02977f63          	bgeu	a4,s1,a4a <malloc+0x70>
 a10:	8a4e                	mv	s4,s3
 a12:	0009871b          	sext.w	a4,s3
 a16:	6685                	lui	a3,0x1
 a18:	00d77363          	bgeu	a4,a3,a1e <malloc+0x44>
 a1c:	6a05                	lui	s4,0x1
 a1e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a22:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a26:	00000917          	auipc	s2,0x0
 a2a:	5da90913          	addi	s2,s2,1498 # 1000 <freep>
  if(p == SBRK_ERROR)
 a2e:	5afd                	li	s5,-1
 a30:	a0bd                	j	a9e <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 a32:	00001797          	auipc	a5,0x1
 a36:	9de78793          	addi	a5,a5,-1570 # 1410 <base>
 a3a:	00000717          	auipc	a4,0x0
 a3e:	5cf73323          	sd	a5,1478(a4) # 1000 <freep>
 a42:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a44:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a48:	b7e1                	j	a10 <malloc+0x36>
      if(p->s.size == nunits)
 a4a:	02e48b63          	beq	s1,a4,a80 <malloc+0xa6>
        p->s.size -= nunits;
 a4e:	4137073b          	subw	a4,a4,s3
 a52:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a54:	1702                	slli	a4,a4,0x20
 a56:	9301                	srli	a4,a4,0x20
 a58:	0712                	slli	a4,a4,0x4
 a5a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a5c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a60:	00000717          	auipc	a4,0x0
 a64:	5aa73023          	sd	a0,1440(a4) # 1000 <freep>
      return (void*)(p + 1);
 a68:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a6c:	70e2                	ld	ra,56(sp)
 a6e:	7442                	ld	s0,48(sp)
 a70:	74a2                	ld	s1,40(sp)
 a72:	7902                	ld	s2,32(sp)
 a74:	69e2                	ld	s3,24(sp)
 a76:	6a42                	ld	s4,16(sp)
 a78:	6aa2                	ld	s5,8(sp)
 a7a:	6b02                	ld	s6,0(sp)
 a7c:	6121                	addi	sp,sp,64
 a7e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a80:	6398                	ld	a4,0(a5)
 a82:	e118                	sd	a4,0(a0)
 a84:	bff1                	j	a60 <malloc+0x86>
  hp->s.size = nu;
 a86:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a8a:	0541                	addi	a0,a0,16
 a8c:	ec7ff0ef          	jal	ra,952 <free>
  return freep;
 a90:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a94:	dd61                	beqz	a0,a6c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a98:	4798                	lw	a4,8(a5)
 a9a:	fa9778e3          	bgeu	a4,s1,a4a <malloc+0x70>
    if(p == freep)
 a9e:	00093703          	ld	a4,0(s2)
 aa2:	853e                	mv	a0,a5
 aa4:	fef719e3          	bne	a4,a5,a96 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 aa8:	8552                	mv	a0,s4
 aaa:	a1fff0ef          	jal	ra,4c8 <sbrk>
  if(p == SBRK_ERROR)
 aae:	fd551ce3          	bne	a0,s5,a86 <malloc+0xac>
        return 0;
 ab2:	4501                	li	a0,0
 ab4:	bf65                	j	a6c <malloc+0x92>
