
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	2b0000ef          	jal	ra,2c0 <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	288000ef          	jal	ra,2c0 <strlen>
  3c:	2501                	sext.w	a0,a0
  3e:	47b5                	li	a5,13
  40:	00a7fa63          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  buf[sizeof(buf)-1] = '\0';
  return buf;
}
  44:	8526                	mv	a0,s1
  46:	70a2                	ld	ra,40(sp)
  48:	7402                	ld	s0,32(sp)
  4a:	64e2                	ld	s1,24(sp)
  4c:	6942                	ld	s2,16(sp)
  4e:	69a2                	ld	s3,8(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  memmove(buf, p, strlen(p));
  54:	8526                	mv	a0,s1
  56:	26a000ef          	jal	ra,2c0 <strlen>
  5a:	00001997          	auipc	s3,0x1
  5e:	fb698993          	addi	s3,s3,-74 # 1010 <buf.1114>
  62:	0005061b          	sext.w	a2,a0
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	3be000ef          	jal	ra,428 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	8526                	mv	a0,s1
  70:	250000ef          	jal	ra,2c0 <strlen>
  74:	0005091b          	sext.w	s2,a0
  78:	8526                	mv	a0,s1
  7a:	246000ef          	jal	ra,2c0 <strlen>
  7e:	1902                	slli	s2,s2,0x20
  80:	02095913          	srli	s2,s2,0x20
  84:	4639                	li	a2,14
  86:	9e09                	subw	a2,a2,a0
  88:	02000593          	li	a1,32
  8c:	01298533          	add	a0,s3,s2
  90:	25a000ef          	jal	ra,2ea <memset>
  buf[sizeof(buf)-1] = '\0';
  94:	00098723          	sb	zero,14(s3)
  return buf;
  98:	84ce                	mv	s1,s3
  9a:	b76d                	j	44 <fmtname+0x44>

000000000000009c <ls>:

void
ls(char *path)
{
  9c:	d9010113          	addi	sp,sp,-624
  a0:	26113423          	sd	ra,616(sp)
  a4:	26813023          	sd	s0,608(sp)
  a8:	24913c23          	sd	s1,600(sp)
  ac:	25213823          	sd	s2,592(sp)
  b0:	25313423          	sd	s3,584(sp)
  b4:	25413023          	sd	s4,576(sp)
  b8:	23513c23          	sd	s5,568(sp)
  bc:	1c80                	addi	s0,sp,624
  be:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  c0:	4581                	li	a1,0
  c2:	484000ef          	jal	ra,546 <open>
  c6:	06054963          	bltz	a0,138 <ls+0x9c>
  ca:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  cc:	d9840593          	addi	a1,s0,-616
  d0:	48e000ef          	jal	ra,55e <fstat>
  d4:	06054b63          	bltz	a0,14a <ls+0xae>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d8:	da041783          	lh	a5,-608(s0)
  dc:	0007869b          	sext.w	a3,a5
  e0:	4705                	li	a4,1
  e2:	08e68063          	beq	a3,a4,162 <ls+0xc6>
  e6:	37f9                	addiw	a5,a5,-2
  e8:	17c2                	slli	a5,a5,0x30
  ea:	93c1                	srli	a5,a5,0x30
  ec:	02f76263          	bltu	a4,a5,110 <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  f0:	854a                	mv	a0,s2
  f2:	f0fff0ef          	jal	ra,0 <fmtname>
  f6:	85aa                	mv	a1,a0
  f8:	da842703          	lw	a4,-600(s0)
  fc:	d9c42683          	lw	a3,-612(s0)
 100:	da041603          	lh	a2,-608(s0)
 104:	00001517          	auipc	a0,0x1
 108:	9ec50513          	addi	a0,a0,-1556 # af0 <malloc+0x10c>
 10c:	01f000ef          	jal	ra,92a <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 110:	8526                	mv	a0,s1
 112:	41c000ef          	jal	ra,52e <close>
}
 116:	26813083          	ld	ra,616(sp)
 11a:	26013403          	ld	s0,608(sp)
 11e:	25813483          	ld	s1,600(sp)
 122:	25013903          	ld	s2,592(sp)
 126:	24813983          	ld	s3,584(sp)
 12a:	24013a03          	ld	s4,576(sp)
 12e:	23813a83          	ld	s5,568(sp)
 132:	27010113          	addi	sp,sp,624
 136:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 138:	864a                	mv	a2,s2
 13a:	00001597          	auipc	a1,0x1
 13e:	98658593          	addi	a1,a1,-1658 # ac0 <malloc+0xdc>
 142:	4509                	li	a0,2
 144:	7bc000ef          	jal	ra,900 <fprintf>
    return;
 148:	b7f9                	j	116 <ls+0x7a>
    fprintf(2, "ls: cannot stat %s\n", path);
 14a:	864a                	mv	a2,s2
 14c:	00001597          	auipc	a1,0x1
 150:	98c58593          	addi	a1,a1,-1652 # ad8 <malloc+0xf4>
 154:	4509                	li	a0,2
 156:	7aa000ef          	jal	ra,900 <fprintf>
    close(fd);
 15a:	8526                	mv	a0,s1
 15c:	3d2000ef          	jal	ra,52e <close>
    return;
 160:	bf5d                	j	116 <ls+0x7a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 162:	854a                	mv	a0,s2
 164:	15c000ef          	jal	ra,2c0 <strlen>
 168:	2541                	addiw	a0,a0,16
 16a:	20000793          	li	a5,512
 16e:	00a7f963          	bgeu	a5,a0,180 <ls+0xe4>
      printf("ls: path too long\n");
 172:	00001517          	auipc	a0,0x1
 176:	98e50513          	addi	a0,a0,-1650 # b00 <malloc+0x11c>
 17a:	7b0000ef          	jal	ra,92a <printf>
      break;
 17e:	bf49                	j	110 <ls+0x74>
    strcpy(buf, path);
 180:	85ca                	mv	a1,s2
 182:	dc040513          	addi	a0,s0,-576
 186:	0f2000ef          	jal	ra,278 <strcpy>
    p = buf+strlen(buf);
 18a:	dc040513          	addi	a0,s0,-576
 18e:	132000ef          	jal	ra,2c0 <strlen>
 192:	02051913          	slli	s2,a0,0x20
 196:	02095913          	srli	s2,s2,0x20
 19a:	dc040793          	addi	a5,s0,-576
 19e:	993e                	add	s2,s2,a5
    *p++ = '/';
 1a0:	00190993          	addi	s3,s2,1
 1a4:	02f00793          	li	a5,47
 1a8:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1ac:	00001a17          	auipc	s4,0x1
 1b0:	944a0a13          	addi	s4,s4,-1724 # af0 <malloc+0x10c>
        printf("ls: cannot stat %s\n", buf);
 1b4:	00001a97          	auipc	s5,0x1
 1b8:	924a8a93          	addi	s5,s5,-1756 # ad8 <malloc+0xf4>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1bc:	a031                	j	1c8 <ls+0x12c>
        printf("ls: cannot stat %s\n", buf);
 1be:	dc040593          	addi	a1,s0,-576
 1c2:	8556                	mv	a0,s5
 1c4:	766000ef          	jal	ra,92a <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c8:	4641                	li	a2,16
 1ca:	db040593          	addi	a1,s0,-592
 1ce:	8526                	mv	a0,s1
 1d0:	34e000ef          	jal	ra,51e <read>
 1d4:	47c1                	li	a5,16
 1d6:	f2f51de3          	bne	a0,a5,110 <ls+0x74>
      if(de.inum == 0)
 1da:	db045783          	lhu	a5,-592(s0)
 1de:	d7ed                	beqz	a5,1c8 <ls+0x12c>
      memmove(p, de.name, DIRSIZ);
 1e0:	4639                	li	a2,14
 1e2:	db240593          	addi	a1,s0,-590
 1e6:	854e                	mv	a0,s3
 1e8:	240000ef          	jal	ra,428 <memmove>
      p[DIRSIZ] = 0;
 1ec:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1f0:	d9840593          	addi	a1,s0,-616
 1f4:	dc040513          	addi	a0,s0,-576
 1f8:	1ac000ef          	jal	ra,3a4 <stat>
 1fc:	fc0541e3          	bltz	a0,1be <ls+0x122>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 200:	dc040513          	addi	a0,s0,-576
 204:	dfdff0ef          	jal	ra,0 <fmtname>
 208:	85aa                	mv	a1,a0
 20a:	da842703          	lw	a4,-600(s0)
 20e:	d9c42683          	lw	a3,-612(s0)
 212:	da041603          	lh	a2,-608(s0)
 216:	8552                	mv	a0,s4
 218:	712000ef          	jal	ra,92a <printf>
 21c:	b775                	j	1c8 <ls+0x12c>

000000000000021e <main>:

int
main(int argc, char *argv[])
{
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e426                	sd	s1,8(sp)
 226:	e04a                	sd	s2,0(sp)
 228:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 22a:	4785                	li	a5,1
 22c:	02a7d563          	bge	a5,a0,256 <main+0x38>
 230:	00858493          	addi	s1,a1,8
 234:	ffe5091b          	addiw	s2,a0,-2
 238:	1902                	slli	s2,s2,0x20
 23a:	02095913          	srli	s2,s2,0x20
 23e:	090e                	slli	s2,s2,0x3
 240:	05c1                	addi	a1,a1,16
 242:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 244:	6088                	ld	a0,0(s1)
 246:	e57ff0ef          	jal	ra,9c <ls>
  for(i=1; i<argc; i++)
 24a:	04a1                	addi	s1,s1,8
 24c:	ff249ce3          	bne	s1,s2,244 <main+0x26>
  exit(0);
 250:	4501                	li	a0,0
 252:	2b4000ef          	jal	ra,506 <exit>
    ls(".");
 256:	00001517          	auipc	a0,0x1
 25a:	8c250513          	addi	a0,a0,-1854 # b18 <malloc+0x134>
 25e:	e3fff0ef          	jal	ra,9c <ls>
    exit(0);
 262:	4501                	li	a0,0
 264:	2a2000ef          	jal	ra,506 <exit>

0000000000000268 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 270:	fafff0ef          	jal	ra,21e <main>
  exit(r);
 274:	292000ef          	jal	ra,506 <exit>

0000000000000278 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27e:	87aa                	mv	a5,a0
 280:	0585                	addi	a1,a1,1
 282:	0785                	addi	a5,a5,1
 284:	fff5c703          	lbu	a4,-1(a1)
 288:	fee78fa3          	sb	a4,-1(a5)
 28c:	fb75                	bnez	a4,280 <strcpy+0x8>
    ;
  return os;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29a:	00054783          	lbu	a5,0(a0)
 29e:	cb91                	beqz	a5,2b2 <strcmp+0x1e>
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00f71763          	bne	a4,a5,2b2 <strcmp+0x1e>
    p++, q++;
 2a8:	0505                	addi	a0,a0,1
 2aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	fbe5                	bnez	a5,2a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b2:	0005c503          	lbu	a0,0(a1)
}
 2b6:	40a7853b          	subw	a0,a5,a0
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <strlen>:

uint
strlen(const char *s)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	cf91                	beqz	a5,2e6 <strlen+0x26>
 2cc:	0505                	addi	a0,a0,1
 2ce:	87aa                	mv	a5,a0
 2d0:	4685                	li	a3,1
 2d2:	9e89                	subw	a3,a3,a0
 2d4:	00f6853b          	addw	a0,a3,a5
 2d8:	0785                	addi	a5,a5,1
 2da:	fff7c703          	lbu	a4,-1(a5)
 2de:	fb7d                	bnez	a4,2d4 <strlen+0x14>
    ;
  return n;
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  for(n = 0; s[n]; n++)
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <strlen+0x20>

00000000000002ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f0:	ce09                	beqz	a2,30a <memset+0x20>
 2f2:	87aa                	mv	a5,a0
 2f4:	fff6071b          	addiw	a4,a2,-1
 2f8:	1702                	slli	a4,a4,0x20
 2fa:	9301                	srli	a4,a4,0x20
 2fc:	0705                	addi	a4,a4,1
 2fe:	972a                	add	a4,a4,a0
    cdst[i] = c;
 300:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 304:	0785                	addi	a5,a5,1
 306:	fee79de3          	bne	a5,a4,300 <memset+0x16>
  }
  return dst;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strchr>:

char*
strchr(const char *s, char c)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  for(; *s; s++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cb99                	beqz	a5,330 <strchr+0x20>
    if(*s == c)
 31c:	00f58763          	beq	a1,a5,32a <strchr+0x1a>
  for(; *s; s++)
 320:	0505                	addi	a0,a0,1
 322:	00054783          	lbu	a5,0(a0)
 326:	fbfd                	bnez	a5,31c <strchr+0xc>
      return (char*)s;
  return 0;
 328:	4501                	li	a0,0
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  return 0;
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <strchr+0x1a>

0000000000000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	711d                	addi	sp,sp,-96
 336:	ec86                	sd	ra,88(sp)
 338:	e8a2                	sd	s0,80(sp)
 33a:	e4a6                	sd	s1,72(sp)
 33c:	e0ca                	sd	s2,64(sp)
 33e:	fc4e                	sd	s3,56(sp)
 340:	f852                	sd	s4,48(sp)
 342:	f456                	sd	s5,40(sp)
 344:	f05a                	sd	s6,32(sp)
 346:	ec5e                	sd	s7,24(sp)
 348:	1080                	addi	s0,sp,96
 34a:	8baa                	mv	s7,a0
 34c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34e:	892a                	mv	s2,a0
 350:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 352:	4aa9                	li	s5,10
 354:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 356:	89a6                	mv	s3,s1
 358:	2485                	addiw	s1,s1,1
 35a:	0344d663          	bge	s1,s4,386 <gets+0x52>
    cc = read(0, &c, 1);
 35e:	4605                	li	a2,1
 360:	faf40593          	addi	a1,s0,-81
 364:	4501                	li	a0,0
 366:	1b8000ef          	jal	ra,51e <read>
    if(cc < 1)
 36a:	00a05e63          	blez	a0,386 <gets+0x52>
    buf[i++] = c;
 36e:	faf44783          	lbu	a5,-81(s0)
 372:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 376:	01578763          	beq	a5,s5,384 <gets+0x50>
 37a:	0905                	addi	s2,s2,1
 37c:	fd679de3          	bne	a5,s6,356 <gets+0x22>
  for(i=0; i+1 < max; ){
 380:	89a6                	mv	s3,s1
 382:	a011                	j	386 <gets+0x52>
 384:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 386:	99de                	add	s3,s3,s7
 388:	00098023          	sb	zero,0(s3)
  return buf;
}
 38c:	855e                	mv	a0,s7
 38e:	60e6                	ld	ra,88(sp)
 390:	6446                	ld	s0,80(sp)
 392:	64a6                	ld	s1,72(sp)
 394:	6906                	ld	s2,64(sp)
 396:	79e2                	ld	s3,56(sp)
 398:	7a42                	ld	s4,48(sp)
 39a:	7aa2                	ld	s5,40(sp)
 39c:	7b02                	ld	s6,32(sp)
 39e:	6be2                	ld	s7,24(sp)
 3a0:	6125                	addi	sp,sp,96
 3a2:	8082                	ret

00000000000003a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a4:	1101                	addi	sp,sp,-32
 3a6:	ec06                	sd	ra,24(sp)
 3a8:	e822                	sd	s0,16(sp)
 3aa:	e426                	sd	s1,8(sp)
 3ac:	e04a                	sd	s2,0(sp)
 3ae:	1000                	addi	s0,sp,32
 3b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b2:	4581                	li	a1,0
 3b4:	192000ef          	jal	ra,546 <open>
  if(fd < 0)
 3b8:	02054163          	bltz	a0,3da <stat+0x36>
 3bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3be:	85ca                	mv	a1,s2
 3c0:	19e000ef          	jal	ra,55e <fstat>
 3c4:	892a                	mv	s2,a0
  close(fd);
 3c6:	8526                	mv	a0,s1
 3c8:	166000ef          	jal	ra,52e <close>
  return r;
}
 3cc:	854a                	mv	a0,s2
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	64a2                	ld	s1,8(sp)
 3d4:	6902                	ld	s2,0(sp)
 3d6:	6105                	addi	sp,sp,32
 3d8:	8082                	ret
    return -1;
 3da:	597d                	li	s2,-1
 3dc:	bfc5                	j	3cc <stat+0x28>

00000000000003de <atoi>:

int
atoi(const char *s)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e422                	sd	s0,8(sp)
 3e2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e4:	00054603          	lbu	a2,0(a0)
 3e8:	fd06079b          	addiw	a5,a2,-48
 3ec:	0ff7f793          	andi	a5,a5,255
 3f0:	4725                	li	a4,9
 3f2:	02f76963          	bltu	a4,a5,424 <atoi+0x46>
 3f6:	86aa                	mv	a3,a0
  n = 0;
 3f8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3fa:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3fc:	0685                	addi	a3,a3,1
 3fe:	0025179b          	slliw	a5,a0,0x2
 402:	9fa9                	addw	a5,a5,a0
 404:	0017979b          	slliw	a5,a5,0x1
 408:	9fb1                	addw	a5,a5,a2
 40a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40e:	0006c603          	lbu	a2,0(a3)
 412:	fd06071b          	addiw	a4,a2,-48
 416:	0ff77713          	andi	a4,a4,255
 41a:	fee5f1e3          	bgeu	a1,a4,3fc <atoi+0x1e>
  return n;
}
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret
  n = 0;
 424:	4501                	li	a0,0
 426:	bfe5                	j	41e <atoi+0x40>

0000000000000428 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 428:	1141                	addi	sp,sp,-16
 42a:	e422                	sd	s0,8(sp)
 42c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42e:	02b57663          	bgeu	a0,a1,45a <memmove+0x32>
    while(n-- > 0)
 432:	02c05163          	blez	a2,454 <memmove+0x2c>
 436:	fff6079b          	addiw	a5,a2,-1
 43a:	1782                	slli	a5,a5,0x20
 43c:	9381                	srli	a5,a5,0x20
 43e:	0785                	addi	a5,a5,1
 440:	97aa                	add	a5,a5,a0
  dst = vdst;
 442:	872a                	mv	a4,a0
      *dst++ = *src++;
 444:	0585                	addi	a1,a1,1
 446:	0705                	addi	a4,a4,1
 448:	fff5c683          	lbu	a3,-1(a1)
 44c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 450:	fee79ae3          	bne	a5,a4,444 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 454:	6422                	ld	s0,8(sp)
 456:	0141                	addi	sp,sp,16
 458:	8082                	ret
    dst += n;
 45a:	00c50733          	add	a4,a0,a2
    src += n;
 45e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 460:	fec05ae3          	blez	a2,454 <memmove+0x2c>
 464:	fff6079b          	addiw	a5,a2,-1
 468:	1782                	slli	a5,a5,0x20
 46a:	9381                	srli	a5,a5,0x20
 46c:	fff7c793          	not	a5,a5
 470:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 472:	15fd                	addi	a1,a1,-1
 474:	177d                	addi	a4,a4,-1
 476:	0005c683          	lbu	a3,0(a1)
 47a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 47e:	fee79ae3          	bne	a5,a4,472 <memmove+0x4a>
 482:	bfc9                	j	454 <memmove+0x2c>

0000000000000484 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 484:	1141                	addi	sp,sp,-16
 486:	e422                	sd	s0,8(sp)
 488:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 48a:	ca05                	beqz	a2,4ba <memcmp+0x36>
 48c:	fff6069b          	addiw	a3,a2,-1
 490:	1682                	slli	a3,a3,0x20
 492:	9281                	srli	a3,a3,0x20
 494:	0685                	addi	a3,a3,1
 496:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 498:	00054783          	lbu	a5,0(a0)
 49c:	0005c703          	lbu	a4,0(a1)
 4a0:	00e79863          	bne	a5,a4,4b0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4a4:	0505                	addi	a0,a0,1
    p2++;
 4a6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a8:	fed518e3          	bne	a0,a3,498 <memcmp+0x14>
  }
  return 0;
 4ac:	4501                	li	a0,0
 4ae:	a019                	j	4b4 <memcmp+0x30>
      return *p1 - *p2;
 4b0:	40e7853b          	subw	a0,a5,a4
}
 4b4:	6422                	ld	s0,8(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret
  return 0;
 4ba:	4501                	li	a0,0
 4bc:	bfe5                	j	4b4 <memcmp+0x30>

00000000000004be <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4be:	1141                	addi	sp,sp,-16
 4c0:	e406                	sd	ra,8(sp)
 4c2:	e022                	sd	s0,0(sp)
 4c4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c6:	f63ff0ef          	jal	ra,428 <memmove>
}
 4ca:	60a2                	ld	ra,8(sp)
 4cc:	6402                	ld	s0,0(sp)
 4ce:	0141                	addi	sp,sp,16
 4d0:	8082                	ret

00000000000004d2 <sbrk>:

char *
sbrk(int n) {
 4d2:	1141                	addi	sp,sp,-16
 4d4:	e406                	sd	ra,8(sp)
 4d6:	e022                	sd	s0,0(sp)
 4d8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4da:	4585                	li	a1,1
 4dc:	0b2000ef          	jal	ra,58e <sys_sbrk>
}
 4e0:	60a2                	ld	ra,8(sp)
 4e2:	6402                	ld	s0,0(sp)
 4e4:	0141                	addi	sp,sp,16
 4e6:	8082                	ret

00000000000004e8 <sbrklazy>:

char *
sbrklazy(int n) {
 4e8:	1141                	addi	sp,sp,-16
 4ea:	e406                	sd	ra,8(sp)
 4ec:	e022                	sd	s0,0(sp)
 4ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4f0:	4589                	li	a1,2
 4f2:	09c000ef          	jal	ra,58e <sys_sbrk>
}
 4f6:	60a2                	ld	ra,8(sp)
 4f8:	6402                	ld	s0,0(sp)
 4fa:	0141                	addi	sp,sp,16
 4fc:	8082                	ret

00000000000004fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4fe:	4885                	li	a7,1
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <exit>:
.global exit
exit:
 li a7, SYS_exit
 506:	4889                	li	a7,2
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <wait>:
.global wait
wait:
 li a7, SYS_wait
 50e:	488d                	li	a7,3
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 516:	4891                	li	a7,4
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <read>:
.global read
read:
 li a7, SYS_read
 51e:	4895                	li	a7,5
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <write>:
.global write
write:
 li a7, SYS_write
 526:	48c1                	li	a7,16
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <close>:
.global close
close:
 li a7, SYS_close
 52e:	48d5                	li	a7,21
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <kill>:
.global kill
kill:
 li a7, SYS_kill
 536:	4899                	li	a7,6
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <exec>:
.global exec
exec:
 li a7, SYS_exec
 53e:	489d                	li	a7,7
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <open>:
.global open
open:
 li a7, SYS_open
 546:	48bd                	li	a7,15
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 54e:	48c5                	li	a7,17
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 556:	48c9                	li	a7,18
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 55e:	48a1                	li	a7,8
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <link>:
.global link
link:
 li a7, SYS_link
 566:	48cd                	li	a7,19
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 56e:	48d1                	li	a7,20
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 576:	48a5                	li	a7,9
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <dup>:
.global dup
dup:
 li a7, SYS_dup
 57e:	48a9                	li	a7,10
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 586:	48ad                	li	a7,11
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 58e:	48b1                	li	a7,12
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <pause>:
.global pause
pause:
 li a7, SYS_pause
 596:	48b5                	li	a7,13
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 59e:	48b9                	li	a7,14
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 5a6:	48d9                	li	a7,22
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ae:	1101                	addi	sp,sp,-32
 5b0:	ec06                	sd	ra,24(sp)
 5b2:	e822                	sd	s0,16(sp)
 5b4:	1000                	addi	s0,sp,32
 5b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ba:	4605                	li	a2,1
 5bc:	fef40593          	addi	a1,s0,-17
 5c0:	f67ff0ef          	jal	ra,526 <write>
}
 5c4:	60e2                	ld	ra,24(sp)
 5c6:	6442                	ld	s0,16(sp)
 5c8:	6105                	addi	sp,sp,32
 5ca:	8082                	ret

00000000000005cc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5cc:	715d                	addi	sp,sp,-80
 5ce:	e486                	sd	ra,72(sp)
 5d0:	e0a2                	sd	s0,64(sp)
 5d2:	fc26                	sd	s1,56(sp)
 5d4:	f84a                	sd	s2,48(sp)
 5d6:	f44e                	sd	s3,40(sp)
 5d8:	0880                	addi	s0,sp,80
 5da:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5dc:	c299                	beqz	a3,5e2 <printint+0x16>
 5de:	0805c163          	bltz	a1,660 <printint+0x94>
  neg = 0;
 5e2:	4881                	li	a7,0
 5e4:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5e8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5ea:	00000517          	auipc	a0,0x0
 5ee:	53e50513          	addi	a0,a0,1342 # b28 <digits>
 5f2:	883e                	mv	a6,a5
 5f4:	2785                	addiw	a5,a5,1
 5f6:	02c5f733          	remu	a4,a1,a2
 5fa:	972a                	add	a4,a4,a0
 5fc:	00074703          	lbu	a4,0(a4)
 600:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 604:	872e                	mv	a4,a1
 606:	02c5d5b3          	divu	a1,a1,a2
 60a:	0685                	addi	a3,a3,1
 60c:	fec773e3          	bgeu	a4,a2,5f2 <printint+0x26>
  if(neg)
 610:	00088b63          	beqz	a7,626 <printint+0x5a>
    buf[i++] = '-';
 614:	fd040713          	addi	a4,s0,-48
 618:	97ba                	add	a5,a5,a4
 61a:	02d00713          	li	a4,45
 61e:	fee78423          	sb	a4,-24(a5)
 622:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 626:	02f05663          	blez	a5,652 <printint+0x86>
 62a:	fb840713          	addi	a4,s0,-72
 62e:	00f704b3          	add	s1,a4,a5
 632:	fff70993          	addi	s3,a4,-1
 636:	99be                	add	s3,s3,a5
 638:	37fd                	addiw	a5,a5,-1
 63a:	1782                	slli	a5,a5,0x20
 63c:	9381                	srli	a5,a5,0x20
 63e:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 642:	fff4c583          	lbu	a1,-1(s1)
 646:	854a                	mv	a0,s2
 648:	f67ff0ef          	jal	ra,5ae <putc>
  while(--i >= 0)
 64c:	14fd                	addi	s1,s1,-1
 64e:	ff349ae3          	bne	s1,s3,642 <printint+0x76>
}
 652:	60a6                	ld	ra,72(sp)
 654:	6406                	ld	s0,64(sp)
 656:	74e2                	ld	s1,56(sp)
 658:	7942                	ld	s2,48(sp)
 65a:	79a2                	ld	s3,40(sp)
 65c:	6161                	addi	sp,sp,80
 65e:	8082                	ret
    x = -xx;
 660:	40b005b3          	neg	a1,a1
    neg = 1;
 664:	4885                	li	a7,1
    x = -xx;
 666:	bfbd                	j	5e4 <printint+0x18>

0000000000000668 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 668:	7119                	addi	sp,sp,-128
 66a:	fc86                	sd	ra,120(sp)
 66c:	f8a2                	sd	s0,112(sp)
 66e:	f4a6                	sd	s1,104(sp)
 670:	f0ca                	sd	s2,96(sp)
 672:	ecce                	sd	s3,88(sp)
 674:	e8d2                	sd	s4,80(sp)
 676:	e4d6                	sd	s5,72(sp)
 678:	e0da                	sd	s6,64(sp)
 67a:	fc5e                	sd	s7,56(sp)
 67c:	f862                	sd	s8,48(sp)
 67e:	f466                	sd	s9,40(sp)
 680:	f06a                	sd	s10,32(sp)
 682:	ec6e                	sd	s11,24(sp)
 684:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 686:	0005c903          	lbu	s2,0(a1)
 68a:	24090c63          	beqz	s2,8e2 <vprintf+0x27a>
 68e:	8b2a                	mv	s6,a0
 690:	8a2e                	mv	s4,a1
 692:	8bb2                	mv	s7,a2
  state = 0;
 694:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 696:	4481                	li	s1,0
 698:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 69a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 69e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6a2:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6a6:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6aa:	00000c97          	auipc	s9,0x0
 6ae:	47ec8c93          	addi	s9,s9,1150 # b28 <digits>
 6b2:	a005                	j	6d2 <vprintf+0x6a>
        putc(fd, c0);
 6b4:	85ca                	mv	a1,s2
 6b6:	855a                	mv	a0,s6
 6b8:	ef7ff0ef          	jal	ra,5ae <putc>
 6bc:	a019                	j	6c2 <vprintf+0x5a>
    } else if(state == '%'){
 6be:	03598263          	beq	s3,s5,6e2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6c2:	2485                	addiw	s1,s1,1
 6c4:	8726                	mv	a4,s1
 6c6:	009a07b3          	add	a5,s4,s1
 6ca:	0007c903          	lbu	s2,0(a5)
 6ce:	20090a63          	beqz	s2,8e2 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 6d2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6d6:	fe0994e3          	bnez	s3,6be <vprintf+0x56>
      if(c0 == '%'){
 6da:	fd579de3          	bne	a5,s5,6b4 <vprintf+0x4c>
        state = '%';
 6de:	89be                	mv	s3,a5
 6e0:	b7cd                	j	6c2 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e2:	c3c1                	beqz	a5,762 <vprintf+0xfa>
 6e4:	00ea06b3          	add	a3,s4,a4
 6e8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6ec:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6ee:	c681                	beqz	a3,6f6 <vprintf+0x8e>
 6f0:	9752                	add	a4,a4,s4
 6f2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6f6:	03878e63          	beq	a5,s8,732 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 6fa:	05a78863          	beq	a5,s10,74a <vprintf+0xe2>
      } else if(c0 == 'u'){
 6fe:	0db78b63          	beq	a5,s11,7d4 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 702:	07800713          	li	a4,120
 706:	10e78d63          	beq	a5,a4,820 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 70a:	07000713          	li	a4,112
 70e:	14e78263          	beq	a5,a4,852 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 712:	06300713          	li	a4,99
 716:	16e78f63          	beq	a5,a4,894 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 71a:	07300713          	li	a4,115
 71e:	18e78563          	beq	a5,a4,8a8 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 722:	05579063          	bne	a5,s5,762 <vprintf+0xfa>
        putc(fd, '%');
 726:	85d6                	mv	a1,s5
 728:	855a                	mv	a0,s6
 72a:	e85ff0ef          	jal	ra,5ae <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 72e:	4981                	li	s3,0
 730:	bf49                	j	6c2 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 732:	008b8913          	addi	s2,s7,8
 736:	4685                	li	a3,1
 738:	4629                	li	a2,10
 73a:	000ba583          	lw	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	e8dff0ef          	jal	ra,5cc <printint>
 744:	8bca                	mv	s7,s2
      state = 0;
 746:	4981                	li	s3,0
 748:	bfad                	j	6c2 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 74a:	03868663          	beq	a3,s8,776 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 74e:	05a68163          	beq	a3,s10,790 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 752:	09b68d63          	beq	a3,s11,7ec <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 756:	03a68f63          	beq	a3,s10,794 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 75a:	07800793          	li	a5,120
 75e:	0cf68d63          	beq	a3,a5,838 <vprintf+0x1d0>
        putc(fd, '%');
 762:	85d6                	mv	a1,s5
 764:	855a                	mv	a0,s6
 766:	e49ff0ef          	jal	ra,5ae <putc>
        putc(fd, c0);
 76a:	85ca                	mv	a1,s2
 76c:	855a                	mv	a0,s6
 76e:	e41ff0ef          	jal	ra,5ae <putc>
      state = 0;
 772:	4981                	li	s3,0
 774:	b7b9                	j	6c2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 776:	008b8913          	addi	s2,s7,8
 77a:	4685                	li	a3,1
 77c:	4629                	li	a2,10
 77e:	000bb583          	ld	a1,0(s7)
 782:	855a                	mv	a0,s6
 784:	e49ff0ef          	jal	ra,5cc <printint>
        i += 1;
 788:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 78a:	8bca                	mv	s7,s2
      state = 0;
 78c:	4981                	li	s3,0
        i += 1;
 78e:	bf15                	j	6c2 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 790:	03860563          	beq	a2,s8,7ba <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 794:	07b60963          	beq	a2,s11,806 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 798:	07800793          	li	a5,120
 79c:	fcf613e3          	bne	a2,a5,762 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a0:	008b8913          	addi	s2,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4641                	li	a2,16
 7a8:	000bb583          	ld	a1,0(s7)
 7ac:	855a                	mv	a0,s6
 7ae:	e1fff0ef          	jal	ra,5cc <printint>
        i += 2;
 7b2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b4:	8bca                	mv	s7,s2
      state = 0;
 7b6:	4981                	li	s3,0
        i += 2;
 7b8:	b729                	j	6c2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ba:	008b8913          	addi	s2,s7,8
 7be:	4685                	li	a3,1
 7c0:	4629                	li	a2,10
 7c2:	000bb583          	ld	a1,0(s7)
 7c6:	855a                	mv	a0,s6
 7c8:	e05ff0ef          	jal	ra,5cc <printint>
        i += 2;
 7cc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ce:	8bca                	mv	s7,s2
      state = 0;
 7d0:	4981                	li	s3,0
        i += 2;
 7d2:	bdc5                	j	6c2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7d4:	008b8913          	addi	s2,s7,8
 7d8:	4681                	li	a3,0
 7da:	4629                	li	a2,10
 7dc:	000be583          	lwu	a1,0(s7)
 7e0:	855a                	mv	a0,s6
 7e2:	debff0ef          	jal	ra,5cc <printint>
 7e6:	8bca                	mv	s7,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bde1                	j	6c2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ec:	008b8913          	addi	s2,s7,8
 7f0:	4681                	li	a3,0
 7f2:	4629                	li	a2,10
 7f4:	000bb583          	ld	a1,0(s7)
 7f8:	855a                	mv	a0,s6
 7fa:	dd3ff0ef          	jal	ra,5cc <printint>
        i += 1;
 7fe:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 800:	8bca                	mv	s7,s2
      state = 0;
 802:	4981                	li	s3,0
        i += 1;
 804:	bd7d                	j	6c2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 806:	008b8913          	addi	s2,s7,8
 80a:	4681                	li	a3,0
 80c:	4629                	li	a2,10
 80e:	000bb583          	ld	a1,0(s7)
 812:	855a                	mv	a0,s6
 814:	db9ff0ef          	jal	ra,5cc <printint>
        i += 2;
 818:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 81a:	8bca                	mv	s7,s2
      state = 0;
 81c:	4981                	li	s3,0
        i += 2;
 81e:	b555                	j	6c2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 820:	008b8913          	addi	s2,s7,8
 824:	4681                	li	a3,0
 826:	4641                	li	a2,16
 828:	000be583          	lwu	a1,0(s7)
 82c:	855a                	mv	a0,s6
 82e:	d9fff0ef          	jal	ra,5cc <printint>
 832:	8bca                	mv	s7,s2
      state = 0;
 834:	4981                	li	s3,0
 836:	b571                	j	6c2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 838:	008b8913          	addi	s2,s7,8
 83c:	4681                	li	a3,0
 83e:	4641                	li	a2,16
 840:	000bb583          	ld	a1,0(s7)
 844:	855a                	mv	a0,s6
 846:	d87ff0ef          	jal	ra,5cc <printint>
        i += 1;
 84a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 84c:	8bca                	mv	s7,s2
      state = 0;
 84e:	4981                	li	s3,0
        i += 1;
 850:	bd8d                	j	6c2 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 852:	008b8793          	addi	a5,s7,8
 856:	f8f43423          	sd	a5,-120(s0)
 85a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 85e:	03000593          	li	a1,48
 862:	855a                	mv	a0,s6
 864:	d4bff0ef          	jal	ra,5ae <putc>
  putc(fd, 'x');
 868:	07800593          	li	a1,120
 86c:	855a                	mv	a0,s6
 86e:	d41ff0ef          	jal	ra,5ae <putc>
 872:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 874:	03c9d793          	srli	a5,s3,0x3c
 878:	97e6                	add	a5,a5,s9
 87a:	0007c583          	lbu	a1,0(a5)
 87e:	855a                	mv	a0,s6
 880:	d2fff0ef          	jal	ra,5ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 884:	0992                	slli	s3,s3,0x4
 886:	397d                	addiw	s2,s2,-1
 888:	fe0916e3          	bnez	s2,874 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 88c:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 890:	4981                	li	s3,0
 892:	bd05                	j	6c2 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 894:	008b8913          	addi	s2,s7,8
 898:	000bc583          	lbu	a1,0(s7)
 89c:	855a                	mv	a0,s6
 89e:	d11ff0ef          	jal	ra,5ae <putc>
 8a2:	8bca                	mv	s7,s2
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	bd31                	j	6c2 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 8a8:	008b8993          	addi	s3,s7,8
 8ac:	000bb903          	ld	s2,0(s7)
 8b0:	00090f63          	beqz	s2,8ce <vprintf+0x266>
        for(; *s; s++)
 8b4:	00094583          	lbu	a1,0(s2)
 8b8:	c195                	beqz	a1,8dc <vprintf+0x274>
          putc(fd, *s);
 8ba:	855a                	mv	a0,s6
 8bc:	cf3ff0ef          	jal	ra,5ae <putc>
        for(; *s; s++)
 8c0:	0905                	addi	s2,s2,1
 8c2:	00094583          	lbu	a1,0(s2)
 8c6:	f9f5                	bnez	a1,8ba <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 8c8:	8bce                	mv	s7,s3
      state = 0;
 8ca:	4981                	li	s3,0
 8cc:	bbdd                	j	6c2 <vprintf+0x5a>
          s = "(null)";
 8ce:	00000917          	auipc	s2,0x0
 8d2:	25290913          	addi	s2,s2,594 # b20 <malloc+0x13c>
        for(; *s; s++)
 8d6:	02800593          	li	a1,40
 8da:	b7c5                	j	8ba <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 8dc:	8bce                	mv	s7,s3
      state = 0;
 8de:	4981                	li	s3,0
 8e0:	b3cd                	j	6c2 <vprintf+0x5a>
    }
  }
}
 8e2:	70e6                	ld	ra,120(sp)
 8e4:	7446                	ld	s0,112(sp)
 8e6:	74a6                	ld	s1,104(sp)
 8e8:	7906                	ld	s2,96(sp)
 8ea:	69e6                	ld	s3,88(sp)
 8ec:	6a46                	ld	s4,80(sp)
 8ee:	6aa6                	ld	s5,72(sp)
 8f0:	6b06                	ld	s6,64(sp)
 8f2:	7be2                	ld	s7,56(sp)
 8f4:	7c42                	ld	s8,48(sp)
 8f6:	7ca2                	ld	s9,40(sp)
 8f8:	7d02                	ld	s10,32(sp)
 8fa:	6de2                	ld	s11,24(sp)
 8fc:	6109                	addi	sp,sp,128
 8fe:	8082                	ret

0000000000000900 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 900:	715d                	addi	sp,sp,-80
 902:	ec06                	sd	ra,24(sp)
 904:	e822                	sd	s0,16(sp)
 906:	1000                	addi	s0,sp,32
 908:	e010                	sd	a2,0(s0)
 90a:	e414                	sd	a3,8(s0)
 90c:	e818                	sd	a4,16(s0)
 90e:	ec1c                	sd	a5,24(s0)
 910:	03043023          	sd	a6,32(s0)
 914:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 918:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 91c:	8622                	mv	a2,s0
 91e:	d4bff0ef          	jal	ra,668 <vprintf>
}
 922:	60e2                	ld	ra,24(sp)
 924:	6442                	ld	s0,16(sp)
 926:	6161                	addi	sp,sp,80
 928:	8082                	ret

000000000000092a <printf>:

void
printf(const char *fmt, ...)
{
 92a:	711d                	addi	sp,sp,-96
 92c:	ec06                	sd	ra,24(sp)
 92e:	e822                	sd	s0,16(sp)
 930:	1000                	addi	s0,sp,32
 932:	e40c                	sd	a1,8(s0)
 934:	e810                	sd	a2,16(s0)
 936:	ec14                	sd	a3,24(s0)
 938:	f018                	sd	a4,32(s0)
 93a:	f41c                	sd	a5,40(s0)
 93c:	03043823          	sd	a6,48(s0)
 940:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 944:	00840613          	addi	a2,s0,8
 948:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 94c:	85aa                	mv	a1,a0
 94e:	4505                	li	a0,1
 950:	d19ff0ef          	jal	ra,668 <vprintf>
}
 954:	60e2                	ld	ra,24(sp)
 956:	6442                	ld	s0,16(sp)
 958:	6125                	addi	sp,sp,96
 95a:	8082                	ret

000000000000095c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 95c:	1141                	addi	sp,sp,-16
 95e:	e422                	sd	s0,8(sp)
 960:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 962:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 966:	00000797          	auipc	a5,0x0
 96a:	69a7b783          	ld	a5,1690(a5) # 1000 <freep>
 96e:	a805                	j	99e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 970:	4618                	lw	a4,8(a2)
 972:	9db9                	addw	a1,a1,a4
 974:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 978:	6398                	ld	a4,0(a5)
 97a:	6318                	ld	a4,0(a4)
 97c:	fee53823          	sd	a4,-16(a0)
 980:	a091                	j	9c4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 982:	ff852703          	lw	a4,-8(a0)
 986:	9e39                	addw	a2,a2,a4
 988:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 98a:	ff053703          	ld	a4,-16(a0)
 98e:	e398                	sd	a4,0(a5)
 990:	a099                	j	9d6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	6398                	ld	a4,0(a5)
 994:	00e7e463          	bltu	a5,a4,99c <free+0x40>
 998:	00e6ea63          	bltu	a3,a4,9ac <free+0x50>
{
 99c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99e:	fed7fae3          	bgeu	a5,a3,992 <free+0x36>
 9a2:	6398                	ld	a4,0(a5)
 9a4:	00e6e463          	bltu	a3,a4,9ac <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a8:	fee7eae3          	bltu	a5,a4,99c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9ac:	ff852583          	lw	a1,-8(a0)
 9b0:	6390                	ld	a2,0(a5)
 9b2:	02059713          	slli	a4,a1,0x20
 9b6:	9301                	srli	a4,a4,0x20
 9b8:	0712                	slli	a4,a4,0x4
 9ba:	9736                	add	a4,a4,a3
 9bc:	fae60ae3          	beq	a2,a4,970 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c4:	4790                	lw	a2,8(a5)
 9c6:	02061713          	slli	a4,a2,0x20
 9ca:	9301                	srli	a4,a4,0x20
 9cc:	0712                	slli	a4,a4,0x4
 9ce:	973e                	add	a4,a4,a5
 9d0:	fae689e3          	beq	a3,a4,982 <free+0x26>
  } else
    p->s.ptr = bp;
 9d4:	e394                	sd	a3,0(a5)
  freep = p;
 9d6:	00000717          	auipc	a4,0x0
 9da:	62f73523          	sd	a5,1578(a4) # 1000 <freep>
}
 9de:	6422                	ld	s0,8(sp)
 9e0:	0141                	addi	sp,sp,16
 9e2:	8082                	ret

00000000000009e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e4:	7139                	addi	sp,sp,-64
 9e6:	fc06                	sd	ra,56(sp)
 9e8:	f822                	sd	s0,48(sp)
 9ea:	f426                	sd	s1,40(sp)
 9ec:	f04a                	sd	s2,32(sp)
 9ee:	ec4e                	sd	s3,24(sp)
 9f0:	e852                	sd	s4,16(sp)
 9f2:	e456                	sd	s5,8(sp)
 9f4:	e05a                	sd	s6,0(sp)
 9f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f8:	02051493          	slli	s1,a0,0x20
 9fc:	9081                	srli	s1,s1,0x20
 9fe:	04bd                	addi	s1,s1,15
 a00:	8091                	srli	s1,s1,0x4
 a02:	0014899b          	addiw	s3,s1,1
 a06:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a08:	00000517          	auipc	a0,0x0
 a0c:	5f853503          	ld	a0,1528(a0) # 1000 <freep>
 a10:	c515                	beqz	a0,a3c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a14:	4798                	lw	a4,8(a5)
 a16:	02977f63          	bgeu	a4,s1,a54 <malloc+0x70>
 a1a:	8a4e                	mv	s4,s3
 a1c:	0009871b          	sext.w	a4,s3
 a20:	6685                	lui	a3,0x1
 a22:	00d77363          	bgeu	a4,a3,a28 <malloc+0x44>
 a26:	6a05                	lui	s4,0x1
 a28:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a2c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a30:	00000917          	auipc	s2,0x0
 a34:	5d090913          	addi	s2,s2,1488 # 1000 <freep>
  if(p == SBRK_ERROR)
 a38:	5afd                	li	s5,-1
 a3a:	a0bd                	j	aa8 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 a3c:	00000797          	auipc	a5,0x0
 a40:	5e478793          	addi	a5,a5,1508 # 1020 <base>
 a44:	00000717          	auipc	a4,0x0
 a48:	5af73e23          	sd	a5,1468(a4) # 1000 <freep>
 a4c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a4e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a52:	b7e1                	j	a1a <malloc+0x36>
      if(p->s.size == nunits)
 a54:	02e48b63          	beq	s1,a4,a8a <malloc+0xa6>
        p->s.size -= nunits;
 a58:	4137073b          	subw	a4,a4,s3
 a5c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a5e:	1702                	slli	a4,a4,0x20
 a60:	9301                	srli	a4,a4,0x20
 a62:	0712                	slli	a4,a4,0x4
 a64:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a66:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a6a:	00000717          	auipc	a4,0x0
 a6e:	58a73b23          	sd	a0,1430(a4) # 1000 <freep>
      return (void*)(p + 1);
 a72:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a76:	70e2                	ld	ra,56(sp)
 a78:	7442                	ld	s0,48(sp)
 a7a:	74a2                	ld	s1,40(sp)
 a7c:	7902                	ld	s2,32(sp)
 a7e:	69e2                	ld	s3,24(sp)
 a80:	6a42                	ld	s4,16(sp)
 a82:	6aa2                	ld	s5,8(sp)
 a84:	6b02                	ld	s6,0(sp)
 a86:	6121                	addi	sp,sp,64
 a88:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a8a:	6398                	ld	a4,0(a5)
 a8c:	e118                	sd	a4,0(a0)
 a8e:	bff1                	j	a6a <malloc+0x86>
  hp->s.size = nu;
 a90:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a94:	0541                	addi	a0,a0,16
 a96:	ec7ff0ef          	jal	ra,95c <free>
  return freep;
 a9a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a9e:	dd61                	beqz	a0,a76 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa2:	4798                	lw	a4,8(a5)
 aa4:	fa9778e3          	bgeu	a4,s1,a54 <malloc+0x70>
    if(p == freep)
 aa8:	00093703          	ld	a4,0(s2)
 aac:	853e                	mv	a0,a5
 aae:	fef719e3          	bne	a4,a5,aa0 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 ab2:	8552                	mv	a0,s4
 ab4:	a1fff0ef          	jal	ra,4d2 <sbrk>
  if(p == SBRK_ERROR)
 ab8:	fd551ce3          	bne	a0,s5,a90 <malloc+0xac>
        return 0;
 abc:	4501                	li	a0,0
 abe:	bf65                	j	a76 <malloc+0x92>
