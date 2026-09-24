
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/pstat.h"
#include "user/user.h"

int main(void){
   0:	81010113          	addi	sp,sp,-2032
   4:	7e113423          	sd	ra,2024(sp)
   8:	7e813023          	sd	s0,2016(sp)
   c:	7c913c23          	sd	s1,2008(sp)
  10:	7d213823          	sd	s2,2000(sp)
  14:	7d313423          	sd	s3,1992(sp)
  18:	7d413023          	sd	s4,1984(sp)
  1c:	7b513c23          	sd	s5,1976(sp)
  20:	7b613823          	sd	s6,1968(sp)
  24:	7b713423          	sd	s7,1960(sp)
  28:	7b813023          	sd	s8,1952(sp)
  2c:	7f010413          	addi	s0,sp,2032
  30:	da010113          	addi	sp,sp,-608
    struct pstat ps;

    if(getpinfo(&ps) < 0){  //κλήση της νέας syscall getpinfo()
  34:	757d                	lui	a0,0xfffff
  36:	60050513          	addi	a0,a0,1536 # fffffffffffff600 <base+0xffffffffffffe5f0>
  3a:	fb040793          	addi	a5,s0,-80
  3e:	953e                	add	a0,a0,a5
  40:	42a000ef          	jal	ra,46a <getpinfo>
  44:	04054f63          	bltz	a0,a2 <main+0xa2>
        printf("Error: getinfo failed\n");
        exit(1);
    }

    printf("PID\tPPID\tPRIOR\tSTATE\t\tSIZE\tNAME\n");
  48:	00001517          	auipc	a0,0x1
  4c:	9d050513          	addi	a0,a0,-1584 # a18 <malloc+0x170>
  50:	79e000ef          	jal	ra,7ee <printf>

    for(int i=0; i<NPROC; i++){
  54:	77fd                	lui	a5,0xfffff
  56:	60078793          	addi	a5,a5,1536 # fffffffffffff600 <base+0xffffffffffffe5f0>
  5a:	fb040713          	addi	a4,s0,-80
  5e:	97ba                	add	a5,a5,a4
  60:	db040493          	addi	s1,s0,-592
  64:	eb040993          	addi	s3,s0,-336
  68:	00279a13          	slli	s4,a5,0x2
  6c:	414787b3          	sub	a5,a5,s4
                case 5: state_str = "ZOMBIE   "; break;
                default: state_str = "???      ";
            }

            //εκτύπωση όλων των πληροφοριών που μας δίνει το pstat
            printf("%d\t%d\t%d\t%s\t%d\t%s\n", ps.pid[i], ps.ppid[i], ps.priority[i], state_str, ps.memsize[i], ps.pname[i]);
  70:	7a79                	lui	s4,0xffffe
  72:	300a0a13          	addi	s4,s4,768 # ffffffffffffe300 <base+0xffffffffffffd2f0>
  76:	9a3e                	add	s4,s4,a5
                default: state_str = "???      ";
  78:	00001c17          	auipc	s8,0x1
  7c:	918c0c13          	addi	s8,s8,-1768 # 990 <malloc+0xe8>
  80:	00001917          	auipc	s2,0x1
  84:	9d490913          	addi	s2,s2,-1580 # a54 <malloc+0x1ac>
                case 0: state_str = "UNUSED   "; break;
  88:	00001a97          	auipc	s5,0x1
  8c:	918a8a93          	addi	s5,s5,-1768 # 9a0 <malloc+0xf8>
                case 5: state_str = "ZOMBIE   "; break;
  90:	00001b97          	auipc	s7,0x1
  94:	950b8b93          	addi	s7,s7,-1712 # 9e0 <malloc+0x138>
                case 4: state_str = "RUNNING  "; break;
  98:	00001b17          	auipc	s6,0x1
  9c:	938b0b13          	addi	s6,s6,-1736 # 9d0 <malloc+0x128>
  a0:	a091                	j	e4 <main+0xe4>
        printf("Error: getinfo failed\n");
  a2:	00001517          	auipc	a0,0x1
  a6:	95e50513          	addi	a0,a0,-1698 # a00 <malloc+0x158>
  aa:	744000ef          	jal	ra,7ee <printf>
        exit(1);
  ae:	4505                	li	a0,1
  b0:	31a000ef          	jal	ra,3ca <exit>
            switch(ps.pstate[i]){   //μετατροπή αριθμητικής κατάστασης σε string
  b4:	00001717          	auipc	a4,0x1
  b8:	93c70713          	addi	a4,a4,-1732 # 9f0 <malloc+0x148>
            printf("%d\t%d\t%d\t%s\t%d\t%s\n", ps.pid[i], ps.ppid[i], ps.priority[i], state_str, ps.memsize[i], ps.pname[i]);
  bc:	00249813          	slli	a6,s1,0x2
  c0:	9852                	add	a6,a6,s4
  c2:	1005a783          	lw	a5,256(a1)
  c6:	f005a683          	lw	a3,-256(a1)
  ca:	a005a603          	lw	a2,-1536(a1)
  ce:	9005a583          	lw	a1,-1792(a1)
  d2:	00001517          	auipc	a0,0x1
  d6:	96e50513          	addi	a0,a0,-1682 # a40 <malloc+0x198>
  da:	714000ef          	jal	ra,7ee <printf>
    for(int i=0; i<NPROC; i++){
  de:	0491                	addi	s1,s1,4
  e0:	05348363          	beq	s1,s3,126 <main+0x126>
        if(ps.isused[i]){   //φιλτράρουμε μόνο τις χρησιμοποιούμενες διεργασίες και αν βγαλω το if βγαζει και καποια unused και καποια used αλλα μετα γίνεται ο χαμός
  e4:	85a6                	mv	a1,s1
  e6:	8004a783          	lw	a5,-2048(s1)
  ea:	dbf5                	beqz	a5,de <main+0xde>
            switch(ps.pstate[i]){   //μετατροπή αριθμητικής κατάστασης σε string
  ec:	4098                	lw	a4,0(s1)
  ee:	4795                	li	a5,5
  f0:	02e7e763          	bltu	a5,a4,11e <main+0x11e>
  f4:	0004e783          	lwu	a5,0(s1)
  f8:	078a                	slli	a5,a5,0x2
  fa:	97ca                	add	a5,a5,s2
  fc:	439c                	lw	a5,0(a5)
  fe:	97ca                	add	a5,a5,s2
 100:	8782                	jr	a5
                case 2: state_str = "SLEEPING "; break;
 102:	00001717          	auipc	a4,0x1
 106:	8ae70713          	addi	a4,a4,-1874 # 9b0 <malloc+0x108>
 10a:	bf4d                	j	bc <main+0xbc>
                case 3: state_str = "RUNNABLE "; break;
 10c:	00001717          	auipc	a4,0x1
 110:	8b470713          	addi	a4,a4,-1868 # 9c0 <malloc+0x118>
 114:	b765                	j	bc <main+0xbc>
                case 4: state_str = "RUNNING  "; break;
 116:	875a                	mv	a4,s6
 118:	b755                	j	bc <main+0xbc>
                case 5: state_str = "ZOMBIE   "; break;
 11a:	875e                	mv	a4,s7
 11c:	b745                	j	bc <main+0xbc>
                default: state_str = "???      ";
 11e:	8762                	mv	a4,s8
 120:	bf71                	j	bc <main+0xbc>
                case 0: state_str = "UNUSED   "; break;
 122:	8756                	mv	a4,s5
 124:	bf61                	j	bc <main+0xbc>
        }
    }

    exit(0);
 126:	4501                	li	a0,0
 128:	2a2000ef          	jal	ra,3ca <exit>

000000000000012c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e406                	sd	ra,8(sp)
 130:	e022                	sd	s0,0(sp)
 132:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 134:	ecdff0ef          	jal	ra,0 <main>
  exit(r);
 138:	292000ef          	jal	ra,3ca <exit>

000000000000013c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 142:	87aa                	mv	a5,a0
 144:	0585                	addi	a1,a1,1
 146:	0785                	addi	a5,a5,1
 148:	fff5c703          	lbu	a4,-1(a1)
 14c:	fee78fa3          	sb	a4,-1(a5)
 150:	fb75                	bnez	a4,144 <strcpy+0x8>
    ;
  return os;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x1e>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x1e>
    p++, q++;
 16c:	0505                	addi	a0,a0,1
 16e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strlen>:

uint
strlen(const char *s)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf91                	beqz	a5,1aa <strlen+0x26>
 190:	0505                	addi	a0,a0,1
 192:	87aa                	mv	a5,a0
 194:	4685                	li	a3,1
 196:	9e89                	subw	a3,a3,a0
 198:	00f6853b          	addw	a0,a3,a5
 19c:	0785                	addi	a5,a5,1
 19e:	fff7c703          	lbu	a4,-1(a5)
 1a2:	fb7d                	bnez	a4,198 <strlen+0x14>
    ;
  return n;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  for(n = 0; s[n]; n++)
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strlen+0x20>

00000000000001ae <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b4:	ce09                	beqz	a2,1ce <memset+0x20>
 1b6:	87aa                	mv	a5,a0
 1b8:	fff6071b          	addiw	a4,a2,-1
 1bc:	1702                	slli	a4,a4,0x20
 1be:	9301                	srli	a4,a4,0x20
 1c0:	0705                	addi	a4,a4,1
 1c2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c8:	0785                	addi	a5,a5,1
 1ca:	fee79de3          	bne	a5,a4,1c4 <memset+0x16>
  }
  return dst;
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret

00000000000001d4 <strchr>:

char*
strchr(const char *s, char c)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	cb99                	beqz	a5,1f4 <strchr+0x20>
    if(*s == c)
 1e0:	00f58763          	beq	a1,a5,1ee <strchr+0x1a>
  for(; *s; s++)
 1e4:	0505                	addi	a0,a0,1
 1e6:	00054783          	lbu	a5,0(a0)
 1ea:	fbfd                	bnez	a5,1e0 <strchr+0xc>
      return (char*)s;
  return 0;
 1ec:	4501                	li	a0,0
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  return 0;
 1f4:	4501                	li	a0,0
 1f6:	bfe5                	j	1ee <strchr+0x1a>

00000000000001f8 <gets>:

char*
gets(char *buf, int max)
{
 1f8:	711d                	addi	sp,sp,-96
 1fa:	ec86                	sd	ra,88(sp)
 1fc:	e8a2                	sd	s0,80(sp)
 1fe:	e4a6                	sd	s1,72(sp)
 200:	e0ca                	sd	s2,64(sp)
 202:	fc4e                	sd	s3,56(sp)
 204:	f852                	sd	s4,48(sp)
 206:	f456                	sd	s5,40(sp)
 208:	f05a                	sd	s6,32(sp)
 20a:	ec5e                	sd	s7,24(sp)
 20c:	1080                	addi	s0,sp,96
 20e:	8baa                	mv	s7,a0
 210:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 212:	892a                	mv	s2,a0
 214:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 216:	4aa9                	li	s5,10
 218:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 21a:	89a6                	mv	s3,s1
 21c:	2485                	addiw	s1,s1,1
 21e:	0344d663          	bge	s1,s4,24a <gets+0x52>
    cc = read(0, &c, 1);
 222:	4605                	li	a2,1
 224:	faf40593          	addi	a1,s0,-81
 228:	4501                	li	a0,0
 22a:	1b8000ef          	jal	ra,3e2 <read>
    if(cc < 1)
 22e:	00a05e63          	blez	a0,24a <gets+0x52>
    buf[i++] = c;
 232:	faf44783          	lbu	a5,-81(s0)
 236:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23a:	01578763          	beq	a5,s5,248 <gets+0x50>
 23e:	0905                	addi	s2,s2,1
 240:	fd679de3          	bne	a5,s6,21a <gets+0x22>
  for(i=0; i+1 < max; ){
 244:	89a6                	mv	s3,s1
 246:	a011                	j	24a <gets+0x52>
 248:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 24a:	99de                	add	s3,s3,s7
 24c:	00098023          	sb	zero,0(s3)
  return buf;
}
 250:	855e                	mv	a0,s7
 252:	60e6                	ld	ra,88(sp)
 254:	6446                	ld	s0,80(sp)
 256:	64a6                	ld	s1,72(sp)
 258:	6906                	ld	s2,64(sp)
 25a:	79e2                	ld	s3,56(sp)
 25c:	7a42                	ld	s4,48(sp)
 25e:	7aa2                	ld	s5,40(sp)
 260:	7b02                	ld	s6,32(sp)
 262:	6be2                	ld	s7,24(sp)
 264:	6125                	addi	sp,sp,96
 266:	8082                	ret

0000000000000268 <stat>:

int
stat(const char *n, struct stat *st)
{
 268:	1101                	addi	sp,sp,-32
 26a:	ec06                	sd	ra,24(sp)
 26c:	e822                	sd	s0,16(sp)
 26e:	e426                	sd	s1,8(sp)
 270:	e04a                	sd	s2,0(sp)
 272:	1000                	addi	s0,sp,32
 274:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 276:	4581                	li	a1,0
 278:	192000ef          	jal	ra,40a <open>
  if(fd < 0)
 27c:	02054163          	bltz	a0,29e <stat+0x36>
 280:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 282:	85ca                	mv	a1,s2
 284:	19e000ef          	jal	ra,422 <fstat>
 288:	892a                	mv	s2,a0
  close(fd);
 28a:	8526                	mv	a0,s1
 28c:	166000ef          	jal	ra,3f2 <close>
  return r;
}
 290:	854a                	mv	a0,s2
 292:	60e2                	ld	ra,24(sp)
 294:	6442                	ld	s0,16(sp)
 296:	64a2                	ld	s1,8(sp)
 298:	6902                	ld	s2,0(sp)
 29a:	6105                	addi	sp,sp,32
 29c:	8082                	ret
    return -1;
 29e:	597d                	li	s2,-1
 2a0:	bfc5                	j	290 <stat+0x28>

00000000000002a2 <atoi>:

int
atoi(const char *s)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a8:	00054603          	lbu	a2,0(a0)
 2ac:	fd06079b          	addiw	a5,a2,-48
 2b0:	0ff7f793          	andi	a5,a5,255
 2b4:	4725                	li	a4,9
 2b6:	02f76963          	bltu	a4,a5,2e8 <atoi+0x46>
 2ba:	86aa                	mv	a3,a0
  n = 0;
 2bc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2be:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2c0:	0685                	addi	a3,a3,1
 2c2:	0025179b          	slliw	a5,a0,0x2
 2c6:	9fa9                	addw	a5,a5,a0
 2c8:	0017979b          	slliw	a5,a5,0x1
 2cc:	9fb1                	addw	a5,a5,a2
 2ce:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d2:	0006c603          	lbu	a2,0(a3)
 2d6:	fd06071b          	addiw	a4,a2,-48
 2da:	0ff77713          	andi	a4,a4,255
 2de:	fee5f1e3          	bgeu	a1,a4,2c0 <atoi+0x1e>
  return n;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  n = 0;
 2e8:	4501                	li	a0,0
 2ea:	bfe5                	j	2e2 <atoi+0x40>

00000000000002ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f2:	02b57663          	bgeu	a0,a1,31e <memmove+0x32>
    while(n-- > 0)
 2f6:	02c05163          	blez	a2,318 <memmove+0x2c>
 2fa:	fff6079b          	addiw	a5,a2,-1
 2fe:	1782                	slli	a5,a5,0x20
 300:	9381                	srli	a5,a5,0x20
 302:	0785                	addi	a5,a5,1
 304:	97aa                	add	a5,a5,a0
  dst = vdst;
 306:	872a                	mv	a4,a0
      *dst++ = *src++;
 308:	0585                	addi	a1,a1,1
 30a:	0705                	addi	a4,a4,1
 30c:	fff5c683          	lbu	a3,-1(a1)
 310:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 314:	fee79ae3          	bne	a5,a4,308 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
    dst += n;
 31e:	00c50733          	add	a4,a0,a2
    src += n;
 322:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 324:	fec05ae3          	blez	a2,318 <memmove+0x2c>
 328:	fff6079b          	addiw	a5,a2,-1
 32c:	1782                	slli	a5,a5,0x20
 32e:	9381                	srli	a5,a5,0x20
 330:	fff7c793          	not	a5,a5
 334:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 336:	15fd                	addi	a1,a1,-1
 338:	177d                	addi	a4,a4,-1
 33a:	0005c683          	lbu	a3,0(a1)
 33e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 342:	fee79ae3          	bne	a5,a4,336 <memmove+0x4a>
 346:	bfc9                	j	318 <memmove+0x2c>

0000000000000348 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34e:	ca05                	beqz	a2,37e <memcmp+0x36>
 350:	fff6069b          	addiw	a3,a2,-1
 354:	1682                	slli	a3,a3,0x20
 356:	9281                	srli	a3,a3,0x20
 358:	0685                	addi	a3,a3,1
 35a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 35c:	00054783          	lbu	a5,0(a0)
 360:	0005c703          	lbu	a4,0(a1)
 364:	00e79863          	bne	a5,a4,374 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 368:	0505                	addi	a0,a0,1
    p2++;
 36a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 36c:	fed518e3          	bne	a0,a3,35c <memcmp+0x14>
  }
  return 0;
 370:	4501                	li	a0,0
 372:	a019                	j	378 <memcmp+0x30>
      return *p1 - *p2;
 374:	40e7853b          	subw	a0,a5,a4
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
  return 0;
 37e:	4501                	li	a0,0
 380:	bfe5                	j	378 <memcmp+0x30>

0000000000000382 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38a:	f63ff0ef          	jal	ra,2ec <memmove>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <sbrk>:

char *
sbrk(int n) {
 396:	1141                	addi	sp,sp,-16
 398:	e406                	sd	ra,8(sp)
 39a:	e022                	sd	s0,0(sp)
 39c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 39e:	4585                	li	a1,1
 3a0:	0b2000ef          	jal	ra,452 <sys_sbrk>
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <sbrklazy>:

char *
sbrklazy(int n) {
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e406                	sd	ra,8(sp)
 3b0:	e022                	sd	s0,0(sp)
 3b2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3b4:	4589                	li	a1,2
 3b6:	09c000ef          	jal	ra,452 <sys_sbrk>
}
 3ba:	60a2                	ld	ra,8(sp)
 3bc:	6402                	ld	s0,0(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret

00000000000003c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c2:	4885                	li	a7,1
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ca:	4889                	li	a7,2
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d2:	488d                	li	a7,3
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3da:	4891                	li	a7,4
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <read>:
.global read
read:
 li a7, SYS_read
 3e2:	4895                	li	a7,5
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <write>:
.global write
write:
 li a7, SYS_write
 3ea:	48c1                	li	a7,16
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <close>:
.global close
close:
 li a7, SYS_close
 3f2:	48d5                	li	a7,21
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fa:	4899                	li	a7,6
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <exec>:
.global exec
exec:
 li a7, SYS_exec
 402:	489d                	li	a7,7
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <open>:
.global open
open:
 li a7, SYS_open
 40a:	48bd                	li	a7,15
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 412:	48c5                	li	a7,17
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41a:	48c9                	li	a7,18
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 422:	48a1                	li	a7,8
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <link>:
.global link
link:
 li a7, SYS_link
 42a:	48cd                	li	a7,19
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 432:	48d1                	li	a7,20
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43a:	48a5                	li	a7,9
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <dup>:
.global dup
dup:
 li a7, SYS_dup
 442:	48a9                	li	a7,10
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44a:	48ad                	li	a7,11
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 452:	48b1                	li	a7,12
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <pause>:
.global pause
pause:
 li a7, SYS_pause
 45a:	48b5                	li	a7,13
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 462:	48b9                	li	a7,14
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 46a:	48d9                	li	a7,22
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	f67ff0ef          	jal	ra,3ea <write>
}
 488:	60e2                	ld	ra,24(sp)
 48a:	6442                	ld	s0,16(sp)
 48c:	6105                	addi	sp,sp,32
 48e:	8082                	ret

0000000000000490 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 490:	715d                	addi	sp,sp,-80
 492:	e486                	sd	ra,72(sp)
 494:	e0a2                	sd	s0,64(sp)
 496:	fc26                	sd	s1,56(sp)
 498:	f84a                	sd	s2,48(sp)
 49a:	f44e                	sd	s3,40(sp)
 49c:	0880                	addi	s0,sp,80
 49e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4a0:	c299                	beqz	a3,4a6 <printint+0x16>
 4a2:	0805c163          	bltz	a1,524 <printint+0x94>
  neg = 0;
 4a6:	4881                	li	a7,0
 4a8:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4ac:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4ae:	00000517          	auipc	a0,0x0
 4b2:	5ca50513          	addi	a0,a0,1482 # a78 <digits>
 4b6:	883e                	mv	a6,a5
 4b8:	2785                	addiw	a5,a5,1
 4ba:	02c5f733          	remu	a4,a1,a2
 4be:	972a                	add	a4,a4,a0
 4c0:	00074703          	lbu	a4,0(a4)
 4c4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4c8:	872e                	mv	a4,a1
 4ca:	02c5d5b3          	divu	a1,a1,a2
 4ce:	0685                	addi	a3,a3,1
 4d0:	fec773e3          	bgeu	a4,a2,4b6 <printint+0x26>
  if(neg)
 4d4:	00088b63          	beqz	a7,4ea <printint+0x5a>
    buf[i++] = '-';
 4d8:	fd040713          	addi	a4,s0,-48
 4dc:	97ba                	add	a5,a5,a4
 4de:	02d00713          	li	a4,45
 4e2:	fee78423          	sb	a4,-24(a5)
 4e6:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4ea:	02f05663          	blez	a5,516 <printint+0x86>
 4ee:	fb840713          	addi	a4,s0,-72
 4f2:	00f704b3          	add	s1,a4,a5
 4f6:	fff70993          	addi	s3,a4,-1
 4fa:	99be                	add	s3,s3,a5
 4fc:	37fd                	addiw	a5,a5,-1
 4fe:	1782                	slli	a5,a5,0x20
 500:	9381                	srli	a5,a5,0x20
 502:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 506:	fff4c583          	lbu	a1,-1(s1)
 50a:	854a                	mv	a0,s2
 50c:	f67ff0ef          	jal	ra,472 <putc>
  while(--i >= 0)
 510:	14fd                	addi	s1,s1,-1
 512:	ff349ae3          	bne	s1,s3,506 <printint+0x76>
}
 516:	60a6                	ld	ra,72(sp)
 518:	6406                	ld	s0,64(sp)
 51a:	74e2                	ld	s1,56(sp)
 51c:	7942                	ld	s2,48(sp)
 51e:	79a2                	ld	s3,40(sp)
 520:	6161                	addi	sp,sp,80
 522:	8082                	ret
    x = -xx;
 524:	40b005b3          	neg	a1,a1
    neg = 1;
 528:	4885                	li	a7,1
    x = -xx;
 52a:	bfbd                	j	4a8 <printint+0x18>

000000000000052c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52c:	7119                	addi	sp,sp,-128
 52e:	fc86                	sd	ra,120(sp)
 530:	f8a2                	sd	s0,112(sp)
 532:	f4a6                	sd	s1,104(sp)
 534:	f0ca                	sd	s2,96(sp)
 536:	ecce                	sd	s3,88(sp)
 538:	e8d2                	sd	s4,80(sp)
 53a:	e4d6                	sd	s5,72(sp)
 53c:	e0da                	sd	s6,64(sp)
 53e:	fc5e                	sd	s7,56(sp)
 540:	f862                	sd	s8,48(sp)
 542:	f466                	sd	s9,40(sp)
 544:	f06a                	sd	s10,32(sp)
 546:	ec6e                	sd	s11,24(sp)
 548:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 54a:	0005c903          	lbu	s2,0(a1)
 54e:	24090c63          	beqz	s2,7a6 <vprintf+0x27a>
 552:	8b2a                	mv	s6,a0
 554:	8a2e                	mv	s4,a1
 556:	8bb2                	mv	s7,a2
  state = 0;
 558:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 55a:	4481                	li	s1,0
 55c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 55e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 562:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 566:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 56a:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 56e:	00000c97          	auipc	s9,0x0
 572:	50ac8c93          	addi	s9,s9,1290 # a78 <digits>
 576:	a005                	j	596 <vprintf+0x6a>
        putc(fd, c0);
 578:	85ca                	mv	a1,s2
 57a:	855a                	mv	a0,s6
 57c:	ef7ff0ef          	jal	ra,472 <putc>
 580:	a019                	j	586 <vprintf+0x5a>
    } else if(state == '%'){
 582:	03598263          	beq	s3,s5,5a6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 586:	2485                	addiw	s1,s1,1
 588:	8726                	mv	a4,s1
 58a:	009a07b3          	add	a5,s4,s1
 58e:	0007c903          	lbu	s2,0(a5)
 592:	20090a63          	beqz	s2,7a6 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 596:	0009079b          	sext.w	a5,s2
    if(state == 0){
 59a:	fe0994e3          	bnez	s3,582 <vprintf+0x56>
      if(c0 == '%'){
 59e:	fd579de3          	bne	a5,s5,578 <vprintf+0x4c>
        state = '%';
 5a2:	89be                	mv	s3,a5
 5a4:	b7cd                	j	586 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5a6:	c3c1                	beqz	a5,626 <vprintf+0xfa>
 5a8:	00ea06b3          	add	a3,s4,a4
 5ac:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5b0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5b2:	c681                	beqz	a3,5ba <vprintf+0x8e>
 5b4:	9752                	add	a4,a4,s4
 5b6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5ba:	03878e63          	beq	a5,s8,5f6 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 5be:	05a78863          	beq	a5,s10,60e <vprintf+0xe2>
      } else if(c0 == 'u'){
 5c2:	0db78b63          	beq	a5,s11,698 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5c6:	07800713          	li	a4,120
 5ca:	10e78d63          	beq	a5,a4,6e4 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ce:	07000713          	li	a4,112
 5d2:	14e78263          	beq	a5,a4,716 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5d6:	06300713          	li	a4,99
 5da:	16e78f63          	beq	a5,a4,758 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5de:	07300713          	li	a4,115
 5e2:	18e78563          	beq	a5,a4,76c <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5e6:	05579063          	bne	a5,s5,626 <vprintf+0xfa>
        putc(fd, '%');
 5ea:	85d6                	mv	a1,s5
 5ec:	855a                	mv	a0,s6
 5ee:	e85ff0ef          	jal	ra,472 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	bf49                	j	586 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4685                	li	a3,1
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	e8dff0ef          	jal	ra,490 <printint>
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bfad                	j	586 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 60e:	03868663          	beq	a3,s8,63a <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 612:	05a68163          	beq	a3,s10,654 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 616:	09b68d63          	beq	a3,s11,6b0 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 61a:	03a68f63          	beq	a3,s10,658 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 61e:	07800793          	li	a5,120
 622:	0cf68d63          	beq	a3,a5,6fc <vprintf+0x1d0>
        putc(fd, '%');
 626:	85d6                	mv	a1,s5
 628:	855a                	mv	a0,s6
 62a:	e49ff0ef          	jal	ra,472 <putc>
        putc(fd, c0);
 62e:	85ca                	mv	a1,s2
 630:	855a                	mv	a0,s6
 632:	e41ff0ef          	jal	ra,472 <putc>
      state = 0;
 636:	4981                	li	s3,0
 638:	b7b9                	j	586 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000bb583          	ld	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	e49ff0ef          	jal	ra,490 <printint>
        i += 1;
 64c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
        i += 1;
 652:	bf15                	j	586 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 654:	03860563          	beq	a2,s8,67e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 658:	07b60963          	beq	a2,s11,6ca <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 65c:	07800793          	li	a5,120
 660:	fcf613e3          	bne	a2,a5,626 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 664:	008b8913          	addi	s2,s7,8
 668:	4681                	li	a3,0
 66a:	4641                	li	a2,16
 66c:	000bb583          	ld	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	e1fff0ef          	jal	ra,490 <printint>
        i += 2;
 676:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
        i += 2;
 67c:	b729                	j	586 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 67e:	008b8913          	addi	s2,s7,8
 682:	4685                	li	a3,1
 684:	4629                	li	a2,10
 686:	000bb583          	ld	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	e05ff0ef          	jal	ra,490 <printint>
        i += 2;
 690:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
        i += 2;
 696:	bdc5                	j	586 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 698:	008b8913          	addi	s2,s7,8
 69c:	4681                	li	a3,0
 69e:	4629                	li	a2,10
 6a0:	000be583          	lwu	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	debff0ef          	jal	ra,490 <printint>
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bde1                	j	586 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	008b8913          	addi	s2,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4629                	li	a2,10
 6b8:	000bb583          	ld	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	dd3ff0ef          	jal	ra,490 <printint>
        i += 1;
 6c2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
        i += 1;
 6c8:	bd7d                	j	586 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4629                	li	a2,10
 6d2:	000bb583          	ld	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	db9ff0ef          	jal	ra,490 <printint>
        i += 2;
 6dc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6de:	8bca                	mv	s7,s2
      state = 0;
 6e0:	4981                	li	s3,0
        i += 2;
 6e2:	b555                	j	586 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	4681                	li	a3,0
 6ea:	4641                	li	a2,16
 6ec:	000be583          	lwu	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	d9fff0ef          	jal	ra,490 <printint>
 6f6:	8bca                	mv	s7,s2
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b571                	j	586 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fc:	008b8913          	addi	s2,s7,8
 700:	4681                	li	a3,0
 702:	4641                	li	a2,16
 704:	000bb583          	ld	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	d87ff0ef          	jal	ra,490 <printint>
        i += 1;
 70e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 710:	8bca                	mv	s7,s2
      state = 0;
 712:	4981                	li	s3,0
        i += 1;
 714:	bd8d                	j	586 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 716:	008b8793          	addi	a5,s7,8
 71a:	f8f43423          	sd	a5,-120(s0)
 71e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 722:	03000593          	li	a1,48
 726:	855a                	mv	a0,s6
 728:	d4bff0ef          	jal	ra,472 <putc>
  putc(fd, 'x');
 72c:	07800593          	li	a1,120
 730:	855a                	mv	a0,s6
 732:	d41ff0ef          	jal	ra,472 <putc>
 736:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 738:	03c9d793          	srli	a5,s3,0x3c
 73c:	97e6                	add	a5,a5,s9
 73e:	0007c583          	lbu	a1,0(a5)
 742:	855a                	mv	a0,s6
 744:	d2fff0ef          	jal	ra,472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 748:	0992                	slli	s3,s3,0x4
 74a:	397d                	addiw	s2,s2,-1
 74c:	fe0916e3          	bnez	s2,738 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 750:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 754:	4981                	li	s3,0
 756:	bd05                	j	586 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 758:	008b8913          	addi	s2,s7,8
 75c:	000bc583          	lbu	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	d11ff0ef          	jal	ra,472 <putc>
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	bd31                	j	586 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 76c:	008b8993          	addi	s3,s7,8
 770:	000bb903          	ld	s2,0(s7)
 774:	00090f63          	beqz	s2,792 <vprintf+0x266>
        for(; *s; s++)
 778:	00094583          	lbu	a1,0(s2)
 77c:	c195                	beqz	a1,7a0 <vprintf+0x274>
          putc(fd, *s);
 77e:	855a                	mv	a0,s6
 780:	cf3ff0ef          	jal	ra,472 <putc>
        for(; *s; s++)
 784:	0905                	addi	s2,s2,1
 786:	00094583          	lbu	a1,0(s2)
 78a:	f9f5                	bnez	a1,77e <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 78c:	8bce                	mv	s7,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	bbdd                	j	586 <vprintf+0x5a>
          s = "(null)";
 792:	00000917          	auipc	s2,0x0
 796:	2de90913          	addi	s2,s2,734 # a70 <malloc+0x1c8>
        for(; *s; s++)
 79a:	02800593          	li	a1,40
 79e:	b7c5                	j	77e <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 7a0:	8bce                	mv	s7,s3
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b3cd                	j	586 <vprintf+0x5a>
    }
  }
}
 7a6:	70e6                	ld	ra,120(sp)
 7a8:	7446                	ld	s0,112(sp)
 7aa:	74a6                	ld	s1,104(sp)
 7ac:	7906                	ld	s2,96(sp)
 7ae:	69e6                	ld	s3,88(sp)
 7b0:	6a46                	ld	s4,80(sp)
 7b2:	6aa6                	ld	s5,72(sp)
 7b4:	6b06                	ld	s6,64(sp)
 7b6:	7be2                	ld	s7,56(sp)
 7b8:	7c42                	ld	s8,48(sp)
 7ba:	7ca2                	ld	s9,40(sp)
 7bc:	7d02                	ld	s10,32(sp)
 7be:	6de2                	ld	s11,24(sp)
 7c0:	6109                	addi	sp,sp,128
 7c2:	8082                	ret

00000000000007c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c4:	715d                	addi	sp,sp,-80
 7c6:	ec06                	sd	ra,24(sp)
 7c8:	e822                	sd	s0,16(sp)
 7ca:	1000                	addi	s0,sp,32
 7cc:	e010                	sd	a2,0(s0)
 7ce:	e414                	sd	a3,8(s0)
 7d0:	e818                	sd	a4,16(s0)
 7d2:	ec1c                	sd	a5,24(s0)
 7d4:	03043023          	sd	a6,32(s0)
 7d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e0:	8622                	mv	a2,s0
 7e2:	d4bff0ef          	jal	ra,52c <vprintf>
}
 7e6:	60e2                	ld	ra,24(sp)
 7e8:	6442                	ld	s0,16(sp)
 7ea:	6161                	addi	sp,sp,80
 7ec:	8082                	ret

00000000000007ee <printf>:

void
printf(const char *fmt, ...)
{
 7ee:	711d                	addi	sp,sp,-96
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e40c                	sd	a1,8(s0)
 7f8:	e810                	sd	a2,16(s0)
 7fa:	ec14                	sd	a3,24(s0)
 7fc:	f018                	sd	a4,32(s0)
 7fe:	f41c                	sd	a5,40(s0)
 800:	03043823          	sd	a6,48(s0)
 804:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	00840613          	addi	a2,s0,8
 80c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 810:	85aa                	mv	a1,a0
 812:	4505                	li	a0,1
 814:	d19ff0ef          	jal	ra,52c <vprintf>
}
 818:	60e2                	ld	ra,24(sp)
 81a:	6442                	ld	s0,16(sp)
 81c:	6125                	addi	sp,sp,96
 81e:	8082                	ret

0000000000000820 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 820:	1141                	addi	sp,sp,-16
 822:	e422                	sd	s0,8(sp)
 824:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 826:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	00000797          	auipc	a5,0x0
 82e:	7d67b783          	ld	a5,2006(a5) # 1000 <freep>
 832:	a805                	j	862 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 834:	4618                	lw	a4,8(a2)
 836:	9db9                	addw	a1,a1,a4
 838:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83c:	6398                	ld	a4,0(a5)
 83e:	6318                	ld	a4,0(a4)
 840:	fee53823          	sd	a4,-16(a0)
 844:	a091                	j	888 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 846:	ff852703          	lw	a4,-8(a0)
 84a:	9e39                	addw	a2,a2,a4
 84c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 84e:	ff053703          	ld	a4,-16(a0)
 852:	e398                	sd	a4,0(a5)
 854:	a099                	j	89a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	6398                	ld	a4,0(a5)
 858:	00e7e463          	bltu	a5,a4,860 <free+0x40>
 85c:	00e6ea63          	bltu	a3,a4,870 <free+0x50>
{
 860:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	fed7fae3          	bgeu	a5,a3,856 <free+0x36>
 866:	6398                	ld	a4,0(a5)
 868:	00e6e463          	bltu	a3,a4,870 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	fee7eae3          	bltu	a5,a4,860 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 870:	ff852583          	lw	a1,-8(a0)
 874:	6390                	ld	a2,0(a5)
 876:	02059713          	slli	a4,a1,0x20
 87a:	9301                	srli	a4,a4,0x20
 87c:	0712                	slli	a4,a4,0x4
 87e:	9736                	add	a4,a4,a3
 880:	fae60ae3          	beq	a2,a4,834 <free+0x14>
    bp->s.ptr = p->s.ptr;
 884:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 888:	4790                	lw	a2,8(a5)
 88a:	02061713          	slli	a4,a2,0x20
 88e:	9301                	srli	a4,a4,0x20
 890:	0712                	slli	a4,a4,0x4
 892:	973e                	add	a4,a4,a5
 894:	fae689e3          	beq	a3,a4,846 <free+0x26>
  } else
    p->s.ptr = bp;
 898:	e394                	sd	a3,0(a5)
  freep = p;
 89a:	00000717          	auipc	a4,0x0
 89e:	76f73323          	sd	a5,1894(a4) # 1000 <freep>
}
 8a2:	6422                	ld	s0,8(sp)
 8a4:	0141                	addi	sp,sp,16
 8a6:	8082                	ret

00000000000008a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a8:	7139                	addi	sp,sp,-64
 8aa:	fc06                	sd	ra,56(sp)
 8ac:	f822                	sd	s0,48(sp)
 8ae:	f426                	sd	s1,40(sp)
 8b0:	f04a                	sd	s2,32(sp)
 8b2:	ec4e                	sd	s3,24(sp)
 8b4:	e852                	sd	s4,16(sp)
 8b6:	e456                	sd	s5,8(sp)
 8b8:	e05a                	sd	s6,0(sp)
 8ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8bc:	02051493          	slli	s1,a0,0x20
 8c0:	9081                	srli	s1,s1,0x20
 8c2:	04bd                	addi	s1,s1,15
 8c4:	8091                	srli	s1,s1,0x4
 8c6:	0014899b          	addiw	s3,s1,1
 8ca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8cc:	00000517          	auipc	a0,0x0
 8d0:	73453503          	ld	a0,1844(a0) # 1000 <freep>
 8d4:	c515                	beqz	a0,900 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d8:	4798                	lw	a4,8(a5)
 8da:	02977f63          	bgeu	a4,s1,918 <malloc+0x70>
 8de:	8a4e                	mv	s4,s3
 8e0:	0009871b          	sext.w	a4,s3
 8e4:	6685                	lui	a3,0x1
 8e6:	00d77363          	bgeu	a4,a3,8ec <malloc+0x44>
 8ea:	6a05                	lui	s4,0x1
 8ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f4:	00000917          	auipc	s2,0x0
 8f8:	70c90913          	addi	s2,s2,1804 # 1000 <freep>
  if(p == SBRK_ERROR)
 8fc:	5afd                	li	s5,-1
 8fe:	a0bd                	j	96c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 900:	00000797          	auipc	a5,0x0
 904:	71078793          	addi	a5,a5,1808 # 1010 <base>
 908:	00000717          	auipc	a4,0x0
 90c:	6ef73c23          	sd	a5,1784(a4) # 1000 <freep>
 910:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 912:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 916:	b7e1                	j	8de <malloc+0x36>
      if(p->s.size == nunits)
 918:	02e48b63          	beq	s1,a4,94e <malloc+0xa6>
        p->s.size -= nunits;
 91c:	4137073b          	subw	a4,a4,s3
 920:	c798                	sw	a4,8(a5)
        p += p->s.size;
 922:	1702                	slli	a4,a4,0x20
 924:	9301                	srli	a4,a4,0x20
 926:	0712                	slli	a4,a4,0x4
 928:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92e:	00000717          	auipc	a4,0x0
 932:	6ca73923          	sd	a0,1746(a4) # 1000 <freep>
      return (void*)(p + 1);
 936:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 93a:	70e2                	ld	ra,56(sp)
 93c:	7442                	ld	s0,48(sp)
 93e:	74a2                	ld	s1,40(sp)
 940:	7902                	ld	s2,32(sp)
 942:	69e2                	ld	s3,24(sp)
 944:	6a42                	ld	s4,16(sp)
 946:	6aa2                	ld	s5,8(sp)
 948:	6b02                	ld	s6,0(sp)
 94a:	6121                	addi	sp,sp,64
 94c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 94e:	6398                	ld	a4,0(a5)
 950:	e118                	sd	a4,0(a0)
 952:	bff1                	j	92e <malloc+0x86>
  hp->s.size = nu;
 954:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 958:	0541                	addi	a0,a0,16
 95a:	ec7ff0ef          	jal	ra,820 <free>
  return freep;
 95e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 962:	dd61                	beqz	a0,93a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 964:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 966:	4798                	lw	a4,8(a5)
 968:	fa9778e3          	bgeu	a4,s1,918 <malloc+0x70>
    if(p == freep)
 96c:	00093703          	ld	a4,0(s2)
 970:	853e                	mv	a0,a5
 972:	fef719e3          	bne	a4,a5,964 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 976:	8552                	mv	a0,s4
 978:	a1fff0ef          	jal	ra,396 <sbrk>
  if(p == SBRK_ERROR)
 97c:	fd551ce3          	bne	a0,s5,954 <malloc+0xac>
        return 0;
 980:	4501                	li	a0,0
 982:	bf65                	j	93a <malloc+0x92>
