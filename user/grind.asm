
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	f99ff0ef          	jal	ra,0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	addi	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7159                	addi	sp,sp,-112
      76:	f486                	sd	ra,104(sp)
      78:	f0a2                	sd	s0,96(sp)
      7a:	eca6                	sd	s1,88(sp)
      7c:	e8ca                	sd	s2,80(sp)
      7e:	e4ce                	sd	s3,72(sp)
      80:	e0d2                	sd	s4,64(sp)
      82:	fc56                	sd	s5,56(sp)
      84:	f85a                	sd	s6,48(sp)
      86:	1880                	addi	s0,sp,112
      88:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8a:	4501                	li	a0,0
      8c:	30f000ef          	jal	ra,b9a <sbrk>
      90:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      92:	00001517          	auipc	a0,0x1
      96:	0fe50513          	addi	a0,a0,254 # 1190 <malloc+0xe4>
      9a:	39d000ef          	jal	ra,c36 <mkdir>
  if(chdir("grindir") != 0){
      9e:	00001517          	auipc	a0,0x1
      a2:	0f250513          	addi	a0,a0,242 # 1190 <malloc+0xe4>
      a6:	399000ef          	jal	ra,c3e <chdir>
      aa:	c911                	beqz	a0,be <go+0x4a>
    printf("grind: chdir grindir failed\n");
      ac:	00001517          	auipc	a0,0x1
      b0:	0ec50513          	addi	a0,a0,236 # 1198 <malloc+0xec>
      b4:	73f000ef          	jal	ra,ff2 <printf>
    exit(1);
      b8:	4505                	li	a0,1
      ba:	315000ef          	jal	ra,bce <exit>
  }
  chdir("/");
      be:	00001517          	auipc	a0,0x1
      c2:	0fa50513          	addi	a0,a0,250 # 11b8 <malloc+0x10c>
      c6:	379000ef          	jal	ra,c3e <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      ca:	00001997          	auipc	s3,0x1
      ce:	0fe98993          	addi	s3,s3,254 # 11c8 <malloc+0x11c>
      d2:	c489                	beqz	s1,dc <go+0x68>
      d4:	00001997          	auipc	s3,0x1
      d8:	0ec98993          	addi	s3,s3,236 # 11c0 <malloc+0x114>
    iters++;
      dc:	4485                	li	s1,1
  int fd = -1;
      de:	597d                	li	s2,-1
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
      e0:	00002a17          	auipc	s4,0x2
      e4:	f40a0a13          	addi	s4,s4,-192 # 2020 <buf.1247>
      e8:	a035                	j	114 <go+0xa0>
      close(open("grindir/../a", O_CREATE|O_RDWR));
      ea:	20200593          	li	a1,514
      ee:	00001517          	auipc	a0,0x1
      f2:	0e250513          	addi	a0,a0,226 # 11d0 <malloc+0x124>
      f6:	319000ef          	jal	ra,c0e <open>
      fa:	2fd000ef          	jal	ra,bf6 <close>
    iters++;
      fe:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     100:	1f400793          	li	a5,500
     104:	02f4f7b3          	remu	a5,s1,a5
     108:	e791                	bnez	a5,114 <go+0xa0>
      write(1, which_child?"B":"A", 1);
     10a:	4605                	li	a2,1
     10c:	85ce                	mv	a1,s3
     10e:	4505                	li	a0,1
     110:	2df000ef          	jal	ra,bee <write>
    int what = rand() % 23;
     114:	f45ff0ef          	jal	ra,58 <rand>
     118:	47dd                	li	a5,23
     11a:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     11e:	4785                	li	a5,1
     120:	fcf505e3          	beq	a0,a5,ea <go+0x76>
    } else if(what == 2){
     124:	4789                	li	a5,2
     126:	14f50563          	beq	a0,a5,270 <go+0x1fc>
    } else if(what == 3){
     12a:	478d                	li	a5,3
     12c:	14f50d63          	beq	a0,a5,286 <go+0x212>
    } else if(what == 4){
     130:	4791                	li	a5,4
     132:	16f50163          	beq	a0,a5,294 <go+0x220>
    } else if(what == 5){
     136:	4795                	li	a5,5
     138:	18f50b63          	beq	a0,a5,2ce <go+0x25a>
    } else if(what == 6){
     13c:	4799                	li	a5,6
     13e:	1af50563          	beq	a0,a5,2e8 <go+0x274>
    } else if(what == 7){
     142:	479d                	li	a5,7
     144:	1af50f63          	beq	a0,a5,302 <go+0x28e>
    } else if(what == 8){
     148:	47a1                	li	a5,8
     14a:	1cf50363          	beq	a0,a5,310 <go+0x29c>
    } else if(what == 9){
     14e:	47a5                	li	a5,9
     150:	1cf50763          	beq	a0,a5,31e <go+0x2aa>
      mkdir("grindir/../a");
      close(open("a/../a/./a", O_CREATE|O_RDWR));
      unlink("a/a");
    } else if(what == 10){
     154:	47a9                	li	a5,10
     156:	1ef50b63          	beq	a0,a5,34c <go+0x2d8>
      mkdir("/../b");
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
      unlink("b/b");
    } else if(what == 11){
     15a:	47ad                	li	a5,11
     15c:	20f50f63          	beq	a0,a5,37a <go+0x306>
      unlink("b");
      link("../grindir/./../a", "../b");
    } else if(what == 12){
     160:	47b1                	li	a5,12
     162:	22f50d63          	beq	a0,a5,39c <go+0x328>
      unlink("../grindir/../a");
      link(".././b", "/grindir/../a");
    } else if(what == 13){
     166:	47b5                	li	a5,13
     168:	24f50b63          	beq	a0,a5,3be <go+0x34a>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 14){
     16c:	47b9                	li	a5,14
     16e:	26f50c63          	beq	a0,a5,3e6 <go+0x372>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
     172:	47bd                	li	a5,15
     174:	2af50263          	beq	a0,a5,418 <go+0x3a4>
      sbrk(6011);
    } else if(what == 16){
     178:	47c1                	li	a5,16
     17a:	2af50563          	beq	a0,a5,424 <go+0x3b0>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     17e:	47c5                	li	a5,17
     180:	2af50f63          	beq	a0,a5,43e <go+0x3ca>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
      wait(0);
    } else if(what == 18){
     184:	47c9                	li	a5,18
     186:	30f50f63          	beq	a0,a5,4a4 <go+0x430>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     18a:	47cd                	li	a5,19
     18c:	34f50563          	beq	a0,a5,4d6 <go+0x462>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     190:	47d1                	li	a5,20
     192:	3ef50663          	beq	a0,a5,57e <go+0x50a>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     196:	47d5                	li	a5,21
     198:	44f50e63          	beq	a0,a5,5f4 <go+0x580>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     19c:	47d9                	li	a5,22
     19e:	f6f510e3          	bne	a0,a5,fe <go+0x8a>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1a2:	f9840513          	addi	a0,s0,-104
     1a6:	239000ef          	jal	ra,bde <pipe>
     1aa:	50054963          	bltz	a0,6bc <go+0x648>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1ae:	fa040513          	addi	a0,s0,-96
     1b2:	22d000ef          	jal	ra,bde <pipe>
     1b6:	50054d63          	bltz	a0,6d0 <go+0x65c>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ba:	20d000ef          	jal	ra,bc6 <fork>
      if(pid1 == 0){
     1be:	52050363          	beqz	a0,6e4 <go+0x670>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1c2:	5a054563          	bltz	a0,76c <go+0x6f8>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1c6:	201000ef          	jal	ra,bc6 <fork>
      if(pid2 == 0){
     1ca:	5a050b63          	beqz	a0,780 <go+0x70c>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     1ce:	64054963          	bltz	a0,820 <go+0x7ac>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     1d2:	f9842503          	lw	a0,-104(s0)
     1d6:	221000ef          	jal	ra,bf6 <close>
      close(aa[1]);
     1da:	f9c42503          	lw	a0,-100(s0)
     1de:	219000ef          	jal	ra,bf6 <close>
      close(bb[1]);
     1e2:	fa442503          	lw	a0,-92(s0)
     1e6:	211000ef          	jal	ra,bf6 <close>
      char buf[4] = { 0, 0, 0, 0 };
     1ea:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     1ee:	4605                	li	a2,1
     1f0:	f9040593          	addi	a1,s0,-112
     1f4:	fa042503          	lw	a0,-96(s0)
     1f8:	1ef000ef          	jal	ra,be6 <read>
      read(bb[0], buf+1, 1);
     1fc:	4605                	li	a2,1
     1fe:	f9140593          	addi	a1,s0,-111
     202:	fa042503          	lw	a0,-96(s0)
     206:	1e1000ef          	jal	ra,be6 <read>
      read(bb[0], buf+2, 1);
     20a:	4605                	li	a2,1
     20c:	f9240593          	addi	a1,s0,-110
     210:	fa042503          	lw	a0,-96(s0)
     214:	1d3000ef          	jal	ra,be6 <read>
      close(bb[0]);
     218:	fa042503          	lw	a0,-96(s0)
     21c:	1db000ef          	jal	ra,bf6 <close>
      int st1, st2;
      wait(&st1);
     220:	f9440513          	addi	a0,s0,-108
     224:	1b3000ef          	jal	ra,bd6 <wait>
      wait(&st2);
     228:	fa840513          	addi	a0,s0,-88
     22c:	1ab000ef          	jal	ra,bd6 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     230:	f9442783          	lw	a5,-108(s0)
     234:	fa842703          	lw	a4,-88(s0)
     238:	8fd9                	or	a5,a5,a4
     23a:	2781                	sext.w	a5,a5
     23c:	eb99                	bnez	a5,252 <go+0x1de>
     23e:	00001597          	auipc	a1,0x1
     242:	20a58593          	addi	a1,a1,522 # 1448 <malloc+0x39c>
     246:	f9040513          	addi	a0,s0,-112
     24a:	712000ef          	jal	ra,95c <strcmp>
     24e:	ea0508e3          	beqz	a0,fe <go+0x8a>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     252:	f9040693          	addi	a3,s0,-112
     256:	fa842603          	lw	a2,-88(s0)
     25a:	f9442583          	lw	a1,-108(s0)
     25e:	00001517          	auipc	a0,0x1
     262:	1f250513          	addi	a0,a0,498 # 1450 <malloc+0x3a4>
     266:	58d000ef          	jal	ra,ff2 <printf>
        exit(1);
     26a:	4505                	li	a0,1
     26c:	163000ef          	jal	ra,bce <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     270:	20200593          	li	a1,514
     274:	00001517          	auipc	a0,0x1
     278:	f6c50513          	addi	a0,a0,-148 # 11e0 <malloc+0x134>
     27c:	193000ef          	jal	ra,c0e <open>
     280:	177000ef          	jal	ra,bf6 <close>
     284:	bdad                	j	fe <go+0x8a>
      unlink("grindir/../a");
     286:	00001517          	auipc	a0,0x1
     28a:	f4a50513          	addi	a0,a0,-182 # 11d0 <malloc+0x124>
     28e:	191000ef          	jal	ra,c1e <unlink>
     292:	b5b5                	j	fe <go+0x8a>
      if(chdir("grindir") != 0){
     294:	00001517          	auipc	a0,0x1
     298:	efc50513          	addi	a0,a0,-260 # 1190 <malloc+0xe4>
     29c:	1a3000ef          	jal	ra,c3e <chdir>
     2a0:	ed11                	bnez	a0,2bc <go+0x248>
      unlink("../b");
     2a2:	00001517          	auipc	a0,0x1
     2a6:	f5650513          	addi	a0,a0,-170 # 11f8 <malloc+0x14c>
     2aa:	175000ef          	jal	ra,c1e <unlink>
      chdir("/");
     2ae:	00001517          	auipc	a0,0x1
     2b2:	f0a50513          	addi	a0,a0,-246 # 11b8 <malloc+0x10c>
     2b6:	189000ef          	jal	ra,c3e <chdir>
     2ba:	b591                	j	fe <go+0x8a>
        printf("grind: chdir grindir failed\n");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	edc50513          	addi	a0,a0,-292 # 1198 <malloc+0xec>
     2c4:	52f000ef          	jal	ra,ff2 <printf>
        exit(1);
     2c8:	4505                	li	a0,1
     2ca:	105000ef          	jal	ra,bce <exit>
      close(fd);
     2ce:	854a                	mv	a0,s2
     2d0:	127000ef          	jal	ra,bf6 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     2d4:	20200593          	li	a1,514
     2d8:	00001517          	auipc	a0,0x1
     2dc:	f2850513          	addi	a0,a0,-216 # 1200 <malloc+0x154>
     2e0:	12f000ef          	jal	ra,c0e <open>
     2e4:	892a                	mv	s2,a0
     2e6:	bd21                	j	fe <go+0x8a>
      close(fd);
     2e8:	854a                	mv	a0,s2
     2ea:	10d000ef          	jal	ra,bf6 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     2ee:	20200593          	li	a1,514
     2f2:	00001517          	auipc	a0,0x1
     2f6:	f1e50513          	addi	a0,a0,-226 # 1210 <malloc+0x164>
     2fa:	115000ef          	jal	ra,c0e <open>
     2fe:	892a                	mv	s2,a0
     300:	bbfd                	j	fe <go+0x8a>
      write(fd, buf, sizeof(buf));
     302:	3e700613          	li	a2,999
     306:	85d2                	mv	a1,s4
     308:	854a                	mv	a0,s2
     30a:	0e5000ef          	jal	ra,bee <write>
     30e:	bbc5                	j	fe <go+0x8a>
      read(fd, buf, sizeof(buf));
     310:	3e700613          	li	a2,999
     314:	85d2                	mv	a1,s4
     316:	854a                	mv	a0,s2
     318:	0cf000ef          	jal	ra,be6 <read>
     31c:	b3cd                	j	fe <go+0x8a>
      mkdir("grindir/../a");
     31e:	00001517          	auipc	a0,0x1
     322:	eb250513          	addi	a0,a0,-334 # 11d0 <malloc+0x124>
     326:	111000ef          	jal	ra,c36 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     32a:	20200593          	li	a1,514
     32e:	00001517          	auipc	a0,0x1
     332:	efa50513          	addi	a0,a0,-262 # 1228 <malloc+0x17c>
     336:	0d9000ef          	jal	ra,c0e <open>
     33a:	0bd000ef          	jal	ra,bf6 <close>
      unlink("a/a");
     33e:	00001517          	auipc	a0,0x1
     342:	efa50513          	addi	a0,a0,-262 # 1238 <malloc+0x18c>
     346:	0d9000ef          	jal	ra,c1e <unlink>
     34a:	bb55                	j	fe <go+0x8a>
      mkdir("/../b");
     34c:	00001517          	auipc	a0,0x1
     350:	ef450513          	addi	a0,a0,-268 # 1240 <malloc+0x194>
     354:	0e3000ef          	jal	ra,c36 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     358:	20200593          	li	a1,514
     35c:	00001517          	auipc	a0,0x1
     360:	eec50513          	addi	a0,a0,-276 # 1248 <malloc+0x19c>
     364:	0ab000ef          	jal	ra,c0e <open>
     368:	08f000ef          	jal	ra,bf6 <close>
      unlink("b/b");
     36c:	00001517          	auipc	a0,0x1
     370:	eec50513          	addi	a0,a0,-276 # 1258 <malloc+0x1ac>
     374:	0ab000ef          	jal	ra,c1e <unlink>
     378:	b359                	j	fe <go+0x8a>
      unlink("b");
     37a:	00001517          	auipc	a0,0x1
     37e:	ea650513          	addi	a0,a0,-346 # 1220 <malloc+0x174>
     382:	09d000ef          	jal	ra,c1e <unlink>
      link("../grindir/./../a", "../b");
     386:	00001597          	auipc	a1,0x1
     38a:	e7258593          	addi	a1,a1,-398 # 11f8 <malloc+0x14c>
     38e:	00001517          	auipc	a0,0x1
     392:	ed250513          	addi	a0,a0,-302 # 1260 <malloc+0x1b4>
     396:	099000ef          	jal	ra,c2e <link>
     39a:	b395                	j	fe <go+0x8a>
      unlink("../grindir/../a");
     39c:	00001517          	auipc	a0,0x1
     3a0:	edc50513          	addi	a0,a0,-292 # 1278 <malloc+0x1cc>
     3a4:	07b000ef          	jal	ra,c1e <unlink>
      link(".././b", "/grindir/../a");
     3a8:	00001597          	auipc	a1,0x1
     3ac:	e5858593          	addi	a1,a1,-424 # 1200 <malloc+0x154>
     3b0:	00001517          	auipc	a0,0x1
     3b4:	ed850513          	addi	a0,a0,-296 # 1288 <malloc+0x1dc>
     3b8:	077000ef          	jal	ra,c2e <link>
     3bc:	b389                	j	fe <go+0x8a>
      int pid = fork();
     3be:	009000ef          	jal	ra,bc6 <fork>
      if(pid == 0){
     3c2:	c519                	beqz	a0,3d0 <go+0x35c>
      } else if(pid < 0){
     3c4:	00054863          	bltz	a0,3d4 <go+0x360>
      wait(0);
     3c8:	4501                	li	a0,0
     3ca:	00d000ef          	jal	ra,bd6 <wait>
     3ce:	bb05                	j	fe <go+0x8a>
        exit(0);
     3d0:	7fe000ef          	jal	ra,bce <exit>
        printf("grind: fork failed\n");
     3d4:	00001517          	auipc	a0,0x1
     3d8:	ebc50513          	addi	a0,a0,-324 # 1290 <malloc+0x1e4>
     3dc:	417000ef          	jal	ra,ff2 <printf>
        exit(1);
     3e0:	4505                	li	a0,1
     3e2:	7ec000ef          	jal	ra,bce <exit>
      int pid = fork();
     3e6:	7e0000ef          	jal	ra,bc6 <fork>
      if(pid == 0){
     3ea:	c519                	beqz	a0,3f8 <go+0x384>
      } else if(pid < 0){
     3ec:	00054d63          	bltz	a0,406 <go+0x392>
      wait(0);
     3f0:	4501                	li	a0,0
     3f2:	7e4000ef          	jal	ra,bd6 <wait>
     3f6:	b321                	j	fe <go+0x8a>
        fork();
     3f8:	7ce000ef          	jal	ra,bc6 <fork>
        fork();
     3fc:	7ca000ef          	jal	ra,bc6 <fork>
        exit(0);
     400:	4501                	li	a0,0
     402:	7cc000ef          	jal	ra,bce <exit>
        printf("grind: fork failed\n");
     406:	00001517          	auipc	a0,0x1
     40a:	e8a50513          	addi	a0,a0,-374 # 1290 <malloc+0x1e4>
     40e:	3e5000ef          	jal	ra,ff2 <printf>
        exit(1);
     412:	4505                	li	a0,1
     414:	7ba000ef          	jal	ra,bce <exit>
      sbrk(6011);
     418:	6505                	lui	a0,0x1
     41a:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x2fb>
     41e:	77c000ef          	jal	ra,b9a <sbrk>
     422:	b9f1                	j	fe <go+0x8a>
      if(sbrk(0) > break0)
     424:	4501                	li	a0,0
     426:	774000ef          	jal	ra,b9a <sbrk>
     42a:	ccaafae3          	bgeu	s5,a0,fe <go+0x8a>
        sbrk(-(sbrk(0) - break0));
     42e:	4501                	li	a0,0
     430:	76a000ef          	jal	ra,b9a <sbrk>
     434:	40aa853b          	subw	a0,s5,a0
     438:	762000ef          	jal	ra,b9a <sbrk>
     43c:	b1c9                	j	fe <go+0x8a>
      int pid = fork();
     43e:	788000ef          	jal	ra,bc6 <fork>
     442:	8b2a                	mv	s6,a0
      if(pid == 0){
     444:	c10d                	beqz	a0,466 <go+0x3f2>
      } else if(pid < 0){
     446:	02054d63          	bltz	a0,480 <go+0x40c>
      if(chdir("../grindir/..") != 0){
     44a:	00001517          	auipc	a0,0x1
     44e:	e5e50513          	addi	a0,a0,-418 # 12a8 <malloc+0x1fc>
     452:	7ec000ef          	jal	ra,c3e <chdir>
     456:	ed15                	bnez	a0,492 <go+0x41e>
      kill(pid);
     458:	855a                	mv	a0,s6
     45a:	7a4000ef          	jal	ra,bfe <kill>
      wait(0);
     45e:	4501                	li	a0,0
     460:	776000ef          	jal	ra,bd6 <wait>
     464:	b969                	j	fe <go+0x8a>
        close(open("a", O_CREATE|O_RDWR));
     466:	20200593          	li	a1,514
     46a:	00001517          	auipc	a0,0x1
     46e:	e0650513          	addi	a0,a0,-506 # 1270 <malloc+0x1c4>
     472:	79c000ef          	jal	ra,c0e <open>
     476:	780000ef          	jal	ra,bf6 <close>
        exit(0);
     47a:	4501                	li	a0,0
     47c:	752000ef          	jal	ra,bce <exit>
        printf("grind: fork failed\n");
     480:	00001517          	auipc	a0,0x1
     484:	e1050513          	addi	a0,a0,-496 # 1290 <malloc+0x1e4>
     488:	36b000ef          	jal	ra,ff2 <printf>
        exit(1);
     48c:	4505                	li	a0,1
     48e:	740000ef          	jal	ra,bce <exit>
        printf("grind: chdir failed\n");
     492:	00001517          	auipc	a0,0x1
     496:	e2650513          	addi	a0,a0,-474 # 12b8 <malloc+0x20c>
     49a:	359000ef          	jal	ra,ff2 <printf>
        exit(1);
     49e:	4505                	li	a0,1
     4a0:	72e000ef          	jal	ra,bce <exit>
      int pid = fork();
     4a4:	722000ef          	jal	ra,bc6 <fork>
      if(pid == 0){
     4a8:	c519                	beqz	a0,4b6 <go+0x442>
      } else if(pid < 0){
     4aa:	00054d63          	bltz	a0,4c4 <go+0x450>
      wait(0);
     4ae:	4501                	li	a0,0
     4b0:	726000ef          	jal	ra,bd6 <wait>
     4b4:	b1a9                	j	fe <go+0x8a>
        kill(getpid());
     4b6:	798000ef          	jal	ra,c4e <getpid>
     4ba:	744000ef          	jal	ra,bfe <kill>
        exit(0);
     4be:	4501                	li	a0,0
     4c0:	70e000ef          	jal	ra,bce <exit>
        printf("grind: fork failed\n");
     4c4:	00001517          	auipc	a0,0x1
     4c8:	dcc50513          	addi	a0,a0,-564 # 1290 <malloc+0x1e4>
     4cc:	327000ef          	jal	ra,ff2 <printf>
        exit(1);
     4d0:	4505                	li	a0,1
     4d2:	6fc000ef          	jal	ra,bce <exit>
      if(pipe(fds) < 0){
     4d6:	fa840513          	addi	a0,s0,-88
     4da:	704000ef          	jal	ra,bde <pipe>
     4de:	02054363          	bltz	a0,504 <go+0x490>
      int pid = fork();
     4e2:	6e4000ef          	jal	ra,bc6 <fork>
      if(pid == 0){
     4e6:	c905                	beqz	a0,516 <go+0x4a2>
      } else if(pid < 0){
     4e8:	08054263          	bltz	a0,56c <go+0x4f8>
      close(fds[0]);
     4ec:	fa842503          	lw	a0,-88(s0)
     4f0:	706000ef          	jal	ra,bf6 <close>
      close(fds[1]);
     4f4:	fac42503          	lw	a0,-84(s0)
     4f8:	6fe000ef          	jal	ra,bf6 <close>
      wait(0);
     4fc:	4501                	li	a0,0
     4fe:	6d8000ef          	jal	ra,bd6 <wait>
     502:	bef5                	j	fe <go+0x8a>
        printf("grind: pipe failed\n");
     504:	00001517          	auipc	a0,0x1
     508:	dcc50513          	addi	a0,a0,-564 # 12d0 <malloc+0x224>
     50c:	2e7000ef          	jal	ra,ff2 <printf>
        exit(1);
     510:	4505                	li	a0,1
     512:	6bc000ef          	jal	ra,bce <exit>
        fork();
     516:	6b0000ef          	jal	ra,bc6 <fork>
        fork();
     51a:	6ac000ef          	jal	ra,bc6 <fork>
        if(write(fds[1], "x", 1) != 1)
     51e:	4605                	li	a2,1
     520:	00001597          	auipc	a1,0x1
     524:	dc858593          	addi	a1,a1,-568 # 12e8 <malloc+0x23c>
     528:	fac42503          	lw	a0,-84(s0)
     52c:	6c2000ef          	jal	ra,bee <write>
     530:	4785                	li	a5,1
     532:	00f51f63          	bne	a0,a5,550 <go+0x4dc>
        if(read(fds[0], &c, 1) != 1)
     536:	4605                	li	a2,1
     538:	fa040593          	addi	a1,s0,-96
     53c:	fa842503          	lw	a0,-88(s0)
     540:	6a6000ef          	jal	ra,be6 <read>
     544:	4785                	li	a5,1
     546:	00f51c63          	bne	a0,a5,55e <go+0x4ea>
        exit(0);
     54a:	4501                	li	a0,0
     54c:	682000ef          	jal	ra,bce <exit>
          printf("grind: pipe write failed\n");
     550:	00001517          	auipc	a0,0x1
     554:	da050513          	addi	a0,a0,-608 # 12f0 <malloc+0x244>
     558:	29b000ef          	jal	ra,ff2 <printf>
     55c:	bfe9                	j	536 <go+0x4c2>
          printf("grind: pipe read failed\n");
     55e:	00001517          	auipc	a0,0x1
     562:	db250513          	addi	a0,a0,-590 # 1310 <malloc+0x264>
     566:	28d000ef          	jal	ra,ff2 <printf>
     56a:	b7c5                	j	54a <go+0x4d6>
        printf("grind: fork failed\n");
     56c:	00001517          	auipc	a0,0x1
     570:	d2450513          	addi	a0,a0,-732 # 1290 <malloc+0x1e4>
     574:	27f000ef          	jal	ra,ff2 <printf>
        exit(1);
     578:	4505                	li	a0,1
     57a:	654000ef          	jal	ra,bce <exit>
      int pid = fork();
     57e:	648000ef          	jal	ra,bc6 <fork>
      if(pid == 0){
     582:	c519                	beqz	a0,590 <go+0x51c>
      } else if(pid < 0){
     584:	04054f63          	bltz	a0,5e2 <go+0x56e>
      wait(0);
     588:	4501                	li	a0,0
     58a:	64c000ef          	jal	ra,bd6 <wait>
     58e:	be85                	j	fe <go+0x8a>
        unlink("a");
     590:	00001517          	auipc	a0,0x1
     594:	ce050513          	addi	a0,a0,-800 # 1270 <malloc+0x1c4>
     598:	686000ef          	jal	ra,c1e <unlink>
        mkdir("a");
     59c:	00001517          	auipc	a0,0x1
     5a0:	cd450513          	addi	a0,a0,-812 # 1270 <malloc+0x1c4>
     5a4:	692000ef          	jal	ra,c36 <mkdir>
        chdir("a");
     5a8:	00001517          	auipc	a0,0x1
     5ac:	cc850513          	addi	a0,a0,-824 # 1270 <malloc+0x1c4>
     5b0:	68e000ef          	jal	ra,c3e <chdir>
        unlink("../a");
     5b4:	00001517          	auipc	a0,0x1
     5b8:	c2450513          	addi	a0,a0,-988 # 11d8 <malloc+0x12c>
     5bc:	662000ef          	jal	ra,c1e <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     5c0:	20200593          	li	a1,514
     5c4:	00001517          	auipc	a0,0x1
     5c8:	d2450513          	addi	a0,a0,-732 # 12e8 <malloc+0x23c>
     5cc:	642000ef          	jal	ra,c0e <open>
        unlink("x");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	d1850513          	addi	a0,a0,-744 # 12e8 <malloc+0x23c>
     5d8:	646000ef          	jal	ra,c1e <unlink>
        exit(0);
     5dc:	4501                	li	a0,0
     5de:	5f0000ef          	jal	ra,bce <exit>
        printf("grind: fork failed\n");
     5e2:	00001517          	auipc	a0,0x1
     5e6:	cae50513          	addi	a0,a0,-850 # 1290 <malloc+0x1e4>
     5ea:	209000ef          	jal	ra,ff2 <printf>
        exit(1);
     5ee:	4505                	li	a0,1
     5f0:	5de000ef          	jal	ra,bce <exit>
      unlink("c");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	d3c50513          	addi	a0,a0,-708 # 1330 <malloc+0x284>
     5fc:	622000ef          	jal	ra,c1e <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     600:	20200593          	li	a1,514
     604:	00001517          	auipc	a0,0x1
     608:	d2c50513          	addi	a0,a0,-724 # 1330 <malloc+0x284>
     60c:	602000ef          	jal	ra,c0e <open>
     610:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     612:	04054763          	bltz	a0,660 <go+0x5ec>
      if(write(fd1, "x", 1) != 1){
     616:	4605                	li	a2,1
     618:	00001597          	auipc	a1,0x1
     61c:	cd058593          	addi	a1,a1,-816 # 12e8 <malloc+0x23c>
     620:	5ce000ef          	jal	ra,bee <write>
     624:	4785                	li	a5,1
     626:	04f51663          	bne	a0,a5,672 <go+0x5fe>
      if(fstat(fd1, &st) != 0){
     62a:	fa840593          	addi	a1,s0,-88
     62e:	855a                	mv	a0,s6
     630:	5f6000ef          	jal	ra,c26 <fstat>
     634:	e921                	bnez	a0,684 <go+0x610>
      if(st.size != 1){
     636:	fb843583          	ld	a1,-72(s0)
     63a:	4785                	li	a5,1
     63c:	04f59d63          	bne	a1,a5,696 <go+0x622>
      if(st.ino > 200){
     640:	fac42583          	lw	a1,-84(s0)
     644:	0c800793          	li	a5,200
     648:	06b7e163          	bltu	a5,a1,6aa <go+0x636>
      close(fd1);
     64c:	855a                	mv	a0,s6
     64e:	5a8000ef          	jal	ra,bf6 <close>
      unlink("c");
     652:	00001517          	auipc	a0,0x1
     656:	cde50513          	addi	a0,a0,-802 # 1330 <malloc+0x284>
     65a:	5c4000ef          	jal	ra,c1e <unlink>
     65e:	b445                	j	fe <go+0x8a>
        printf("grind: create c failed\n");
     660:	00001517          	auipc	a0,0x1
     664:	cd850513          	addi	a0,a0,-808 # 1338 <malloc+0x28c>
     668:	18b000ef          	jal	ra,ff2 <printf>
        exit(1);
     66c:	4505                	li	a0,1
     66e:	560000ef          	jal	ra,bce <exit>
        printf("grind: write c failed\n");
     672:	00001517          	auipc	a0,0x1
     676:	cde50513          	addi	a0,a0,-802 # 1350 <malloc+0x2a4>
     67a:	179000ef          	jal	ra,ff2 <printf>
        exit(1);
     67e:	4505                	li	a0,1
     680:	54e000ef          	jal	ra,bce <exit>
        printf("grind: fstat failed\n");
     684:	00001517          	auipc	a0,0x1
     688:	ce450513          	addi	a0,a0,-796 # 1368 <malloc+0x2bc>
     68c:	167000ef          	jal	ra,ff2 <printf>
        exit(1);
     690:	4505                	li	a0,1
     692:	53c000ef          	jal	ra,bce <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     696:	2581                	sext.w	a1,a1
     698:	00001517          	auipc	a0,0x1
     69c:	ce850513          	addi	a0,a0,-792 # 1380 <malloc+0x2d4>
     6a0:	153000ef          	jal	ra,ff2 <printf>
        exit(1);
     6a4:	4505                	li	a0,1
     6a6:	528000ef          	jal	ra,bce <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     6aa:	00001517          	auipc	a0,0x1
     6ae:	cfe50513          	addi	a0,a0,-770 # 13a8 <malloc+0x2fc>
     6b2:	141000ef          	jal	ra,ff2 <printf>
        exit(1);
     6b6:	4505                	li	a0,1
     6b8:	516000ef          	jal	ra,bce <exit>
        fprintf(2, "grind: pipe failed\n");
     6bc:	00001597          	auipc	a1,0x1
     6c0:	c1458593          	addi	a1,a1,-1004 # 12d0 <malloc+0x224>
     6c4:	4509                	li	a0,2
     6c6:	103000ef          	jal	ra,fc8 <fprintf>
        exit(1);
     6ca:	4505                	li	a0,1
     6cc:	502000ef          	jal	ra,bce <exit>
        fprintf(2, "grind: pipe failed\n");
     6d0:	00001597          	auipc	a1,0x1
     6d4:	c0058593          	addi	a1,a1,-1024 # 12d0 <malloc+0x224>
     6d8:	4509                	li	a0,2
     6da:	0ef000ef          	jal	ra,fc8 <fprintf>
        exit(1);
     6de:	4505                	li	a0,1
     6e0:	4ee000ef          	jal	ra,bce <exit>
        close(bb[0]);
     6e4:	fa042503          	lw	a0,-96(s0)
     6e8:	50e000ef          	jal	ra,bf6 <close>
        close(bb[1]);
     6ec:	fa442503          	lw	a0,-92(s0)
     6f0:	506000ef          	jal	ra,bf6 <close>
        close(aa[0]);
     6f4:	f9842503          	lw	a0,-104(s0)
     6f8:	4fe000ef          	jal	ra,bf6 <close>
        close(1);
     6fc:	4505                	li	a0,1
     6fe:	4f8000ef          	jal	ra,bf6 <close>
        if(dup(aa[1]) != 1){
     702:	f9c42503          	lw	a0,-100(s0)
     706:	540000ef          	jal	ra,c46 <dup>
     70a:	4785                	li	a5,1
     70c:	00f50c63          	beq	a0,a5,724 <go+0x6b0>
          fprintf(2, "grind: dup failed\n");
     710:	00001597          	auipc	a1,0x1
     714:	cc058593          	addi	a1,a1,-832 # 13d0 <malloc+0x324>
     718:	4509                	li	a0,2
     71a:	0af000ef          	jal	ra,fc8 <fprintf>
          exit(1);
     71e:	4505                	li	a0,1
     720:	4ae000ef          	jal	ra,bce <exit>
        close(aa[1]);
     724:	f9c42503          	lw	a0,-100(s0)
     728:	4ce000ef          	jal	ra,bf6 <close>
        char *args[3] = { "echo", "hi", 0 };
     72c:	00001797          	auipc	a5,0x1
     730:	cbc78793          	addi	a5,a5,-836 # 13e8 <malloc+0x33c>
     734:	faf43423          	sd	a5,-88(s0)
     738:	00001797          	auipc	a5,0x1
     73c:	cb878793          	addi	a5,a5,-840 # 13f0 <malloc+0x344>
     740:	faf43823          	sd	a5,-80(s0)
     744:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     748:	fa840593          	addi	a1,s0,-88
     74c:	00001517          	auipc	a0,0x1
     750:	cac50513          	addi	a0,a0,-852 # 13f8 <malloc+0x34c>
     754:	4b2000ef          	jal	ra,c06 <exec>
        fprintf(2, "grind: echo: not found\n");
     758:	00001597          	auipc	a1,0x1
     75c:	cb058593          	addi	a1,a1,-848 # 1408 <malloc+0x35c>
     760:	4509                	li	a0,2
     762:	067000ef          	jal	ra,fc8 <fprintf>
        exit(2);
     766:	4509                	li	a0,2
     768:	466000ef          	jal	ra,bce <exit>
        fprintf(2, "grind: fork failed\n");
     76c:	00001597          	auipc	a1,0x1
     770:	b2458593          	addi	a1,a1,-1244 # 1290 <malloc+0x1e4>
     774:	4509                	li	a0,2
     776:	053000ef          	jal	ra,fc8 <fprintf>
        exit(3);
     77a:	450d                	li	a0,3
     77c:	452000ef          	jal	ra,bce <exit>
        close(aa[1]);
     780:	f9c42503          	lw	a0,-100(s0)
     784:	472000ef          	jal	ra,bf6 <close>
        close(bb[0]);
     788:	fa042503          	lw	a0,-96(s0)
     78c:	46a000ef          	jal	ra,bf6 <close>
        close(0);
     790:	4501                	li	a0,0
     792:	464000ef          	jal	ra,bf6 <close>
        if(dup(aa[0]) != 0){
     796:	f9842503          	lw	a0,-104(s0)
     79a:	4ac000ef          	jal	ra,c46 <dup>
     79e:	c919                	beqz	a0,7b4 <go+0x740>
          fprintf(2, "grind: dup failed\n");
     7a0:	00001597          	auipc	a1,0x1
     7a4:	c3058593          	addi	a1,a1,-976 # 13d0 <malloc+0x324>
     7a8:	4509                	li	a0,2
     7aa:	01f000ef          	jal	ra,fc8 <fprintf>
          exit(4);
     7ae:	4511                	li	a0,4
     7b0:	41e000ef          	jal	ra,bce <exit>
        close(aa[0]);
     7b4:	f9842503          	lw	a0,-104(s0)
     7b8:	43e000ef          	jal	ra,bf6 <close>
        close(1);
     7bc:	4505                	li	a0,1
     7be:	438000ef          	jal	ra,bf6 <close>
        if(dup(bb[1]) != 1){
     7c2:	fa442503          	lw	a0,-92(s0)
     7c6:	480000ef          	jal	ra,c46 <dup>
     7ca:	4785                	li	a5,1
     7cc:	00f50c63          	beq	a0,a5,7e4 <go+0x770>
          fprintf(2, "grind: dup failed\n");
     7d0:	00001597          	auipc	a1,0x1
     7d4:	c0058593          	addi	a1,a1,-1024 # 13d0 <malloc+0x324>
     7d8:	4509                	li	a0,2
     7da:	7ee000ef          	jal	ra,fc8 <fprintf>
          exit(5);
     7de:	4515                	li	a0,5
     7e0:	3ee000ef          	jal	ra,bce <exit>
        close(bb[1]);
     7e4:	fa442503          	lw	a0,-92(s0)
     7e8:	40e000ef          	jal	ra,bf6 <close>
        char *args[2] = { "cat", 0 };
     7ec:	00001797          	auipc	a5,0x1
     7f0:	c3478793          	addi	a5,a5,-972 # 1420 <malloc+0x374>
     7f4:	faf43423          	sd	a5,-88(s0)
     7f8:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     7fc:	fa840593          	addi	a1,s0,-88
     800:	00001517          	auipc	a0,0x1
     804:	c2850513          	addi	a0,a0,-984 # 1428 <malloc+0x37c>
     808:	3fe000ef          	jal	ra,c06 <exec>
        fprintf(2, "grind: cat: not found\n");
     80c:	00001597          	auipc	a1,0x1
     810:	c2458593          	addi	a1,a1,-988 # 1430 <malloc+0x384>
     814:	4509                	li	a0,2
     816:	7b2000ef          	jal	ra,fc8 <fprintf>
        exit(6);
     81a:	4519                	li	a0,6
     81c:	3b2000ef          	jal	ra,bce <exit>
        fprintf(2, "grind: fork failed\n");
     820:	00001597          	auipc	a1,0x1
     824:	a7058593          	addi	a1,a1,-1424 # 1290 <malloc+0x1e4>
     828:	4509                	li	a0,2
     82a:	79e000ef          	jal	ra,fc8 <fprintf>
        exit(7);
     82e:	451d                	li	a0,7
     830:	39e000ef          	jal	ra,bce <exit>

0000000000000834 <iter>:
  }
}

void
iter()
{
     834:	7179                	addi	sp,sp,-48
     836:	f406                	sd	ra,40(sp)
     838:	f022                	sd	s0,32(sp)
     83a:	ec26                	sd	s1,24(sp)
     83c:	e84a                	sd	s2,16(sp)
     83e:	1800                	addi	s0,sp,48
  unlink("a");
     840:	00001517          	auipc	a0,0x1
     844:	a3050513          	addi	a0,a0,-1488 # 1270 <malloc+0x1c4>
     848:	3d6000ef          	jal	ra,c1e <unlink>
  unlink("b");
     84c:	00001517          	auipc	a0,0x1
     850:	9d450513          	addi	a0,a0,-1580 # 1220 <malloc+0x174>
     854:	3ca000ef          	jal	ra,c1e <unlink>
  
  int pid1 = fork();
     858:	36e000ef          	jal	ra,bc6 <fork>
  if(pid1 < 0){
     85c:	00054f63          	bltz	a0,87a <iter+0x46>
     860:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     862:	e50d                	bnez	a0,88c <iter+0x58>
    rand_next ^= 31;
     864:	00001717          	auipc	a4,0x1
     868:	79c70713          	addi	a4,a4,1948 # 2000 <rand_next>
     86c:	631c                	ld	a5,0(a4)
     86e:	01f7c793          	xori	a5,a5,31
     872:	e31c                	sd	a5,0(a4)
    go(0);
     874:	4501                	li	a0,0
     876:	ffeff0ef          	jal	ra,74 <go>
    printf("grind: fork failed\n");
     87a:	00001517          	auipc	a0,0x1
     87e:	a1650513          	addi	a0,a0,-1514 # 1290 <malloc+0x1e4>
     882:	770000ef          	jal	ra,ff2 <printf>
    exit(1);
     886:	4505                	li	a0,1
     888:	346000ef          	jal	ra,bce <exit>
    exit(0);
  }

  int pid2 = fork();
     88c:	33a000ef          	jal	ra,bc6 <fork>
     890:	892a                	mv	s2,a0
  if(pid2 < 0){
     892:	02054063          	bltz	a0,8b2 <iter+0x7e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     896:	e51d                	bnez	a0,8c4 <iter+0x90>
    rand_next ^= 7177;
     898:	00001697          	auipc	a3,0x1
     89c:	76868693          	addi	a3,a3,1896 # 2000 <rand_next>
     8a0:	629c                	ld	a5,0(a3)
     8a2:	6709                	lui	a4,0x2
     8a4:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x789>
     8a8:	8fb9                	xor	a5,a5,a4
     8aa:	e29c                	sd	a5,0(a3)
    go(1);
     8ac:	4505                	li	a0,1
     8ae:	fc6ff0ef          	jal	ra,74 <go>
    printf("grind: fork failed\n");
     8b2:	00001517          	auipc	a0,0x1
     8b6:	9de50513          	addi	a0,a0,-1570 # 1290 <malloc+0x1e4>
     8ba:	738000ef          	jal	ra,ff2 <printf>
    exit(1);
     8be:	4505                	li	a0,1
     8c0:	30e000ef          	jal	ra,bce <exit>
    exit(0);
  }

  int st1 = -1;
     8c4:	57fd                	li	a5,-1
     8c6:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     8ca:	fdc40513          	addi	a0,s0,-36
     8ce:	308000ef          	jal	ra,bd6 <wait>
  if(st1 != 0){
     8d2:	fdc42783          	lw	a5,-36(s0)
     8d6:	eb99                	bnez	a5,8ec <iter+0xb8>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     8d8:	57fd                	li	a5,-1
     8da:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     8de:	fd840513          	addi	a0,s0,-40
     8e2:	2f4000ef          	jal	ra,bd6 <wait>

  exit(0);
     8e6:	4501                	li	a0,0
     8e8:	2e6000ef          	jal	ra,bce <exit>
    kill(pid1);
     8ec:	8526                	mv	a0,s1
     8ee:	310000ef          	jal	ra,bfe <kill>
    kill(pid2);
     8f2:	854a                	mv	a0,s2
     8f4:	30a000ef          	jal	ra,bfe <kill>
     8f8:	b7c5                	j	8d8 <iter+0xa4>

00000000000008fa <main>:
}

int
main()
{
     8fa:	1101                	addi	sp,sp,-32
     8fc:	ec06                	sd	ra,24(sp)
     8fe:	e822                	sd	s0,16(sp)
     900:	e426                	sd	s1,8(sp)
     902:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    pause(20);
    rand_next += 1;
     904:	00001497          	auipc	s1,0x1
     908:	6fc48493          	addi	s1,s1,1788 # 2000 <rand_next>
     90c:	a809                	j	91e <main+0x24>
      iter();
     90e:	f27ff0ef          	jal	ra,834 <iter>
    pause(20);
     912:	4551                	li	a0,20
     914:	34a000ef          	jal	ra,c5e <pause>
    rand_next += 1;
     918:	609c                	ld	a5,0(s1)
     91a:	0785                	addi	a5,a5,1
     91c:	e09c                	sd	a5,0(s1)
    int pid = fork();
     91e:	2a8000ef          	jal	ra,bc6 <fork>
    if(pid == 0){
     922:	d575                	beqz	a0,90e <main+0x14>
    if(pid > 0){
     924:	fea057e3          	blez	a0,912 <main+0x18>
      wait(0);
     928:	4501                	li	a0,0
     92a:	2ac000ef          	jal	ra,bd6 <wait>
     92e:	b7d5                	j	912 <main+0x18>

0000000000000930 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     930:	1141                	addi	sp,sp,-16
     932:	e406                	sd	ra,8(sp)
     934:	e022                	sd	s0,0(sp)
     936:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     938:	fc3ff0ef          	jal	ra,8fa <main>
  exit(r);
     93c:	292000ef          	jal	ra,bce <exit>

0000000000000940 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     940:	1141                	addi	sp,sp,-16
     942:	e422                	sd	s0,8(sp)
     944:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     946:	87aa                	mv	a5,a0
     948:	0585                	addi	a1,a1,1
     94a:	0785                	addi	a5,a5,1
     94c:	fff5c703          	lbu	a4,-1(a1)
     950:	fee78fa3          	sb	a4,-1(a5)
     954:	fb75                	bnez	a4,948 <strcpy+0x8>
    ;
  return os;
}
     956:	6422                	ld	s0,8(sp)
     958:	0141                	addi	sp,sp,16
     95a:	8082                	ret

000000000000095c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     95c:	1141                	addi	sp,sp,-16
     95e:	e422                	sd	s0,8(sp)
     960:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     962:	00054783          	lbu	a5,0(a0)
     966:	cb91                	beqz	a5,97a <strcmp+0x1e>
     968:	0005c703          	lbu	a4,0(a1)
     96c:	00f71763          	bne	a4,a5,97a <strcmp+0x1e>
    p++, q++;
     970:	0505                	addi	a0,a0,1
     972:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     974:	00054783          	lbu	a5,0(a0)
     978:	fbe5                	bnez	a5,968 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     97a:	0005c503          	lbu	a0,0(a1)
}
     97e:	40a7853b          	subw	a0,a5,a0
     982:	6422                	ld	s0,8(sp)
     984:	0141                	addi	sp,sp,16
     986:	8082                	ret

0000000000000988 <strlen>:

uint
strlen(const char *s)
{
     988:	1141                	addi	sp,sp,-16
     98a:	e422                	sd	s0,8(sp)
     98c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     98e:	00054783          	lbu	a5,0(a0)
     992:	cf91                	beqz	a5,9ae <strlen+0x26>
     994:	0505                	addi	a0,a0,1
     996:	87aa                	mv	a5,a0
     998:	4685                	li	a3,1
     99a:	9e89                	subw	a3,a3,a0
     99c:	00f6853b          	addw	a0,a3,a5
     9a0:	0785                	addi	a5,a5,1
     9a2:	fff7c703          	lbu	a4,-1(a5)
     9a6:	fb7d                	bnez	a4,99c <strlen+0x14>
    ;
  return n;
}
     9a8:	6422                	ld	s0,8(sp)
     9aa:	0141                	addi	sp,sp,16
     9ac:	8082                	ret
  for(n = 0; s[n]; n++)
     9ae:	4501                	li	a0,0
     9b0:	bfe5                	j	9a8 <strlen+0x20>

00000000000009b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     9b2:	1141                	addi	sp,sp,-16
     9b4:	e422                	sd	s0,8(sp)
     9b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     9b8:	ce09                	beqz	a2,9d2 <memset+0x20>
     9ba:	87aa                	mv	a5,a0
     9bc:	fff6071b          	addiw	a4,a2,-1
     9c0:	1702                	slli	a4,a4,0x20
     9c2:	9301                	srli	a4,a4,0x20
     9c4:	0705                	addi	a4,a4,1
     9c6:	972a                	add	a4,a4,a0
    cdst[i] = c;
     9c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     9cc:	0785                	addi	a5,a5,1
     9ce:	fee79de3          	bne	a5,a4,9c8 <memset+0x16>
  }
  return dst;
}
     9d2:	6422                	ld	s0,8(sp)
     9d4:	0141                	addi	sp,sp,16
     9d6:	8082                	ret

00000000000009d8 <strchr>:

char*
strchr(const char *s, char c)
{
     9d8:	1141                	addi	sp,sp,-16
     9da:	e422                	sd	s0,8(sp)
     9dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9de:	00054783          	lbu	a5,0(a0)
     9e2:	cb99                	beqz	a5,9f8 <strchr+0x20>
    if(*s == c)
     9e4:	00f58763          	beq	a1,a5,9f2 <strchr+0x1a>
  for(; *s; s++)
     9e8:	0505                	addi	a0,a0,1
     9ea:	00054783          	lbu	a5,0(a0)
     9ee:	fbfd                	bnez	a5,9e4 <strchr+0xc>
      return (char*)s;
  return 0;
     9f0:	4501                	li	a0,0
}
     9f2:	6422                	ld	s0,8(sp)
     9f4:	0141                	addi	sp,sp,16
     9f6:	8082                	ret
  return 0;
     9f8:	4501                	li	a0,0
     9fa:	bfe5                	j	9f2 <strchr+0x1a>

00000000000009fc <gets>:

char*
gets(char *buf, int max)
{
     9fc:	711d                	addi	sp,sp,-96
     9fe:	ec86                	sd	ra,88(sp)
     a00:	e8a2                	sd	s0,80(sp)
     a02:	e4a6                	sd	s1,72(sp)
     a04:	e0ca                	sd	s2,64(sp)
     a06:	fc4e                	sd	s3,56(sp)
     a08:	f852                	sd	s4,48(sp)
     a0a:	f456                	sd	s5,40(sp)
     a0c:	f05a                	sd	s6,32(sp)
     a0e:	ec5e                	sd	s7,24(sp)
     a10:	1080                	addi	s0,sp,96
     a12:	8baa                	mv	s7,a0
     a14:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a16:	892a                	mv	s2,a0
     a18:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a1a:	4aa9                	li	s5,10
     a1c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a1e:	89a6                	mv	s3,s1
     a20:	2485                	addiw	s1,s1,1
     a22:	0344d663          	bge	s1,s4,a4e <gets+0x52>
    cc = read(0, &c, 1);
     a26:	4605                	li	a2,1
     a28:	faf40593          	addi	a1,s0,-81
     a2c:	4501                	li	a0,0
     a2e:	1b8000ef          	jal	ra,be6 <read>
    if(cc < 1)
     a32:	00a05e63          	blez	a0,a4e <gets+0x52>
    buf[i++] = c;
     a36:	faf44783          	lbu	a5,-81(s0)
     a3a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a3e:	01578763          	beq	a5,s5,a4c <gets+0x50>
     a42:	0905                	addi	s2,s2,1
     a44:	fd679de3          	bne	a5,s6,a1e <gets+0x22>
  for(i=0; i+1 < max; ){
     a48:	89a6                	mv	s3,s1
     a4a:	a011                	j	a4e <gets+0x52>
     a4c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a4e:	99de                	add	s3,s3,s7
     a50:	00098023          	sb	zero,0(s3)
  return buf;
}
     a54:	855e                	mv	a0,s7
     a56:	60e6                	ld	ra,88(sp)
     a58:	6446                	ld	s0,80(sp)
     a5a:	64a6                	ld	s1,72(sp)
     a5c:	6906                	ld	s2,64(sp)
     a5e:	79e2                	ld	s3,56(sp)
     a60:	7a42                	ld	s4,48(sp)
     a62:	7aa2                	ld	s5,40(sp)
     a64:	7b02                	ld	s6,32(sp)
     a66:	6be2                	ld	s7,24(sp)
     a68:	6125                	addi	sp,sp,96
     a6a:	8082                	ret

0000000000000a6c <stat>:

int
stat(const char *n, struct stat *st)
{
     a6c:	1101                	addi	sp,sp,-32
     a6e:	ec06                	sd	ra,24(sp)
     a70:	e822                	sd	s0,16(sp)
     a72:	e426                	sd	s1,8(sp)
     a74:	e04a                	sd	s2,0(sp)
     a76:	1000                	addi	s0,sp,32
     a78:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a7a:	4581                	li	a1,0
     a7c:	192000ef          	jal	ra,c0e <open>
  if(fd < 0)
     a80:	02054163          	bltz	a0,aa2 <stat+0x36>
     a84:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a86:	85ca                	mv	a1,s2
     a88:	19e000ef          	jal	ra,c26 <fstat>
     a8c:	892a                	mv	s2,a0
  close(fd);
     a8e:	8526                	mv	a0,s1
     a90:	166000ef          	jal	ra,bf6 <close>
  return r;
}
     a94:	854a                	mv	a0,s2
     a96:	60e2                	ld	ra,24(sp)
     a98:	6442                	ld	s0,16(sp)
     a9a:	64a2                	ld	s1,8(sp)
     a9c:	6902                	ld	s2,0(sp)
     a9e:	6105                	addi	sp,sp,32
     aa0:	8082                	ret
    return -1;
     aa2:	597d                	li	s2,-1
     aa4:	bfc5                	j	a94 <stat+0x28>

0000000000000aa6 <atoi>:

int
atoi(const char *s)
{
     aa6:	1141                	addi	sp,sp,-16
     aa8:	e422                	sd	s0,8(sp)
     aaa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     aac:	00054603          	lbu	a2,0(a0)
     ab0:	fd06079b          	addiw	a5,a2,-48
     ab4:	0ff7f793          	andi	a5,a5,255
     ab8:	4725                	li	a4,9
     aba:	02f76963          	bltu	a4,a5,aec <atoi+0x46>
     abe:	86aa                	mv	a3,a0
  n = 0;
     ac0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     ac2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     ac4:	0685                	addi	a3,a3,1
     ac6:	0025179b          	slliw	a5,a0,0x2
     aca:	9fa9                	addw	a5,a5,a0
     acc:	0017979b          	slliw	a5,a5,0x1
     ad0:	9fb1                	addw	a5,a5,a2
     ad2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ad6:	0006c603          	lbu	a2,0(a3)
     ada:	fd06071b          	addiw	a4,a2,-48
     ade:	0ff77713          	andi	a4,a4,255
     ae2:	fee5f1e3          	bgeu	a1,a4,ac4 <atoi+0x1e>
  return n;
}
     ae6:	6422                	ld	s0,8(sp)
     ae8:	0141                	addi	sp,sp,16
     aea:	8082                	ret
  n = 0;
     aec:	4501                	li	a0,0
     aee:	bfe5                	j	ae6 <atoi+0x40>

0000000000000af0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     af0:	1141                	addi	sp,sp,-16
     af2:	e422                	sd	s0,8(sp)
     af4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     af6:	02b57663          	bgeu	a0,a1,b22 <memmove+0x32>
    while(n-- > 0)
     afa:	02c05163          	blez	a2,b1c <memmove+0x2c>
     afe:	fff6079b          	addiw	a5,a2,-1
     b02:	1782                	slli	a5,a5,0x20
     b04:	9381                	srli	a5,a5,0x20
     b06:	0785                	addi	a5,a5,1
     b08:	97aa                	add	a5,a5,a0
  dst = vdst;
     b0a:	872a                	mv	a4,a0
      *dst++ = *src++;
     b0c:	0585                	addi	a1,a1,1
     b0e:	0705                	addi	a4,a4,1
     b10:	fff5c683          	lbu	a3,-1(a1)
     b14:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b18:	fee79ae3          	bne	a5,a4,b0c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b1c:	6422                	ld	s0,8(sp)
     b1e:	0141                	addi	sp,sp,16
     b20:	8082                	ret
    dst += n;
     b22:	00c50733          	add	a4,a0,a2
    src += n;
     b26:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b28:	fec05ae3          	blez	a2,b1c <memmove+0x2c>
     b2c:	fff6079b          	addiw	a5,a2,-1
     b30:	1782                	slli	a5,a5,0x20
     b32:	9381                	srli	a5,a5,0x20
     b34:	fff7c793          	not	a5,a5
     b38:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b3a:	15fd                	addi	a1,a1,-1
     b3c:	177d                	addi	a4,a4,-1
     b3e:	0005c683          	lbu	a3,0(a1)
     b42:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b46:	fee79ae3          	bne	a5,a4,b3a <memmove+0x4a>
     b4a:	bfc9                	j	b1c <memmove+0x2c>

0000000000000b4c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b4c:	1141                	addi	sp,sp,-16
     b4e:	e422                	sd	s0,8(sp)
     b50:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b52:	ca05                	beqz	a2,b82 <memcmp+0x36>
     b54:	fff6069b          	addiw	a3,a2,-1
     b58:	1682                	slli	a3,a3,0x20
     b5a:	9281                	srli	a3,a3,0x20
     b5c:	0685                	addi	a3,a3,1
     b5e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b60:	00054783          	lbu	a5,0(a0)
     b64:	0005c703          	lbu	a4,0(a1)
     b68:	00e79863          	bne	a5,a4,b78 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b6c:	0505                	addi	a0,a0,1
    p2++;
     b6e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b70:	fed518e3          	bne	a0,a3,b60 <memcmp+0x14>
  }
  return 0;
     b74:	4501                	li	a0,0
     b76:	a019                	j	b7c <memcmp+0x30>
      return *p1 - *p2;
     b78:	40e7853b          	subw	a0,a5,a4
}
     b7c:	6422                	ld	s0,8(sp)
     b7e:	0141                	addi	sp,sp,16
     b80:	8082                	ret
  return 0;
     b82:	4501                	li	a0,0
     b84:	bfe5                	j	b7c <memcmp+0x30>

0000000000000b86 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b86:	1141                	addi	sp,sp,-16
     b88:	e406                	sd	ra,8(sp)
     b8a:	e022                	sd	s0,0(sp)
     b8c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b8e:	f63ff0ef          	jal	ra,af0 <memmove>
}
     b92:	60a2                	ld	ra,8(sp)
     b94:	6402                	ld	s0,0(sp)
     b96:	0141                	addi	sp,sp,16
     b98:	8082                	ret

0000000000000b9a <sbrk>:

char *
sbrk(int n) {
     b9a:	1141                	addi	sp,sp,-16
     b9c:	e406                	sd	ra,8(sp)
     b9e:	e022                	sd	s0,0(sp)
     ba0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     ba2:	4585                	li	a1,1
     ba4:	0b2000ef          	jal	ra,c56 <sys_sbrk>
}
     ba8:	60a2                	ld	ra,8(sp)
     baa:	6402                	ld	s0,0(sp)
     bac:	0141                	addi	sp,sp,16
     bae:	8082                	ret

0000000000000bb0 <sbrklazy>:

char *
sbrklazy(int n) {
     bb0:	1141                	addi	sp,sp,-16
     bb2:	e406                	sd	ra,8(sp)
     bb4:	e022                	sd	s0,0(sp)
     bb6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     bb8:	4589                	li	a1,2
     bba:	09c000ef          	jal	ra,c56 <sys_sbrk>
}
     bbe:	60a2                	ld	ra,8(sp)
     bc0:	6402                	ld	s0,0(sp)
     bc2:	0141                	addi	sp,sp,16
     bc4:	8082                	ret

0000000000000bc6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     bc6:	4885                	li	a7,1
 ecall
     bc8:	00000073          	ecall
 ret
     bcc:	8082                	ret

0000000000000bce <exit>:
.global exit
exit:
 li a7, SYS_exit
     bce:	4889                	li	a7,2
 ecall
     bd0:	00000073          	ecall
 ret
     bd4:	8082                	ret

0000000000000bd6 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bd6:	488d                	li	a7,3
 ecall
     bd8:	00000073          	ecall
 ret
     bdc:	8082                	ret

0000000000000bde <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bde:	4891                	li	a7,4
 ecall
     be0:	00000073          	ecall
 ret
     be4:	8082                	ret

0000000000000be6 <read>:
.global read
read:
 li a7, SYS_read
     be6:	4895                	li	a7,5
 ecall
     be8:	00000073          	ecall
 ret
     bec:	8082                	ret

0000000000000bee <write>:
.global write
write:
 li a7, SYS_write
     bee:	48c1                	li	a7,16
 ecall
     bf0:	00000073          	ecall
 ret
     bf4:	8082                	ret

0000000000000bf6 <close>:
.global close
close:
 li a7, SYS_close
     bf6:	48d5                	li	a7,21
 ecall
     bf8:	00000073          	ecall
 ret
     bfc:	8082                	ret

0000000000000bfe <kill>:
.global kill
kill:
 li a7, SYS_kill
     bfe:	4899                	li	a7,6
 ecall
     c00:	00000073          	ecall
 ret
     c04:	8082                	ret

0000000000000c06 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c06:	489d                	li	a7,7
 ecall
     c08:	00000073          	ecall
 ret
     c0c:	8082                	ret

0000000000000c0e <open>:
.global open
open:
 li a7, SYS_open
     c0e:	48bd                	li	a7,15
 ecall
     c10:	00000073          	ecall
 ret
     c14:	8082                	ret

0000000000000c16 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c16:	48c5                	li	a7,17
 ecall
     c18:	00000073          	ecall
 ret
     c1c:	8082                	ret

0000000000000c1e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c1e:	48c9                	li	a7,18
 ecall
     c20:	00000073          	ecall
 ret
     c24:	8082                	ret

0000000000000c26 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c26:	48a1                	li	a7,8
 ecall
     c28:	00000073          	ecall
 ret
     c2c:	8082                	ret

0000000000000c2e <link>:
.global link
link:
 li a7, SYS_link
     c2e:	48cd                	li	a7,19
 ecall
     c30:	00000073          	ecall
 ret
     c34:	8082                	ret

0000000000000c36 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c36:	48d1                	li	a7,20
 ecall
     c38:	00000073          	ecall
 ret
     c3c:	8082                	ret

0000000000000c3e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c3e:	48a5                	li	a7,9
 ecall
     c40:	00000073          	ecall
 ret
     c44:	8082                	ret

0000000000000c46 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c46:	48a9                	li	a7,10
 ecall
     c48:	00000073          	ecall
 ret
     c4c:	8082                	ret

0000000000000c4e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c4e:	48ad                	li	a7,11
 ecall
     c50:	00000073          	ecall
 ret
     c54:	8082                	ret

0000000000000c56 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     c56:	48b1                	li	a7,12
 ecall
     c58:	00000073          	ecall
 ret
     c5c:	8082                	ret

0000000000000c5e <pause>:
.global pause
pause:
 li a7, SYS_pause
     c5e:	48b5                	li	a7,13
 ecall
     c60:	00000073          	ecall
 ret
     c64:	8082                	ret

0000000000000c66 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c66:	48b9                	li	a7,14
 ecall
     c68:	00000073          	ecall
 ret
     c6c:	8082                	ret

0000000000000c6e <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
     c6e:	48d9                	li	a7,22
 ecall
     c70:	00000073          	ecall
 ret
     c74:	8082                	ret

0000000000000c76 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c76:	1101                	addi	sp,sp,-32
     c78:	ec06                	sd	ra,24(sp)
     c7a:	e822                	sd	s0,16(sp)
     c7c:	1000                	addi	s0,sp,32
     c7e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c82:	4605                	li	a2,1
     c84:	fef40593          	addi	a1,s0,-17
     c88:	f67ff0ef          	jal	ra,bee <write>
}
     c8c:	60e2                	ld	ra,24(sp)
     c8e:	6442                	ld	s0,16(sp)
     c90:	6105                	addi	sp,sp,32
     c92:	8082                	ret

0000000000000c94 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     c94:	715d                	addi	sp,sp,-80
     c96:	e486                	sd	ra,72(sp)
     c98:	e0a2                	sd	s0,64(sp)
     c9a:	fc26                	sd	s1,56(sp)
     c9c:	f84a                	sd	s2,48(sp)
     c9e:	f44e                	sd	s3,40(sp)
     ca0:	0880                	addi	s0,sp,80
     ca2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     ca4:	c299                	beqz	a3,caa <printint+0x16>
     ca6:	0805c163          	bltz	a1,d28 <printint+0x94>
  neg = 0;
     caa:	4881                	li	a7,0
     cac:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     cb0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     cb2:	00000517          	auipc	a0,0x0
     cb6:	7ce50513          	addi	a0,a0,1998 # 1480 <digits>
     cba:	883e                	mv	a6,a5
     cbc:	2785                	addiw	a5,a5,1
     cbe:	02c5f733          	remu	a4,a1,a2
     cc2:	972a                	add	a4,a4,a0
     cc4:	00074703          	lbu	a4,0(a4)
     cc8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     ccc:	872e                	mv	a4,a1
     cce:	02c5d5b3          	divu	a1,a1,a2
     cd2:	0685                	addi	a3,a3,1
     cd4:	fec773e3          	bgeu	a4,a2,cba <printint+0x26>
  if(neg)
     cd8:	00088b63          	beqz	a7,cee <printint+0x5a>
    buf[i++] = '-';
     cdc:	fd040713          	addi	a4,s0,-48
     ce0:	97ba                	add	a5,a5,a4
     ce2:	02d00713          	li	a4,45
     ce6:	fee78423          	sb	a4,-24(a5)
     cea:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
     cee:	02f05663          	blez	a5,d1a <printint+0x86>
     cf2:	fb840713          	addi	a4,s0,-72
     cf6:	00f704b3          	add	s1,a4,a5
     cfa:	fff70993          	addi	s3,a4,-1
     cfe:	99be                	add	s3,s3,a5
     d00:	37fd                	addiw	a5,a5,-1
     d02:	1782                	slli	a5,a5,0x20
     d04:	9381                	srli	a5,a5,0x20
     d06:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
     d0a:	fff4c583          	lbu	a1,-1(s1)
     d0e:	854a                	mv	a0,s2
     d10:	f67ff0ef          	jal	ra,c76 <putc>
  while(--i >= 0)
     d14:	14fd                	addi	s1,s1,-1
     d16:	ff349ae3          	bne	s1,s3,d0a <printint+0x76>
}
     d1a:	60a6                	ld	ra,72(sp)
     d1c:	6406                	ld	s0,64(sp)
     d1e:	74e2                	ld	s1,56(sp)
     d20:	7942                	ld	s2,48(sp)
     d22:	79a2                	ld	s3,40(sp)
     d24:	6161                	addi	sp,sp,80
     d26:	8082                	ret
    x = -xx;
     d28:	40b005b3          	neg	a1,a1
    neg = 1;
     d2c:	4885                	li	a7,1
    x = -xx;
     d2e:	bfbd                	j	cac <printint+0x18>

0000000000000d30 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d30:	7119                	addi	sp,sp,-128
     d32:	fc86                	sd	ra,120(sp)
     d34:	f8a2                	sd	s0,112(sp)
     d36:	f4a6                	sd	s1,104(sp)
     d38:	f0ca                	sd	s2,96(sp)
     d3a:	ecce                	sd	s3,88(sp)
     d3c:	e8d2                	sd	s4,80(sp)
     d3e:	e4d6                	sd	s5,72(sp)
     d40:	e0da                	sd	s6,64(sp)
     d42:	fc5e                	sd	s7,56(sp)
     d44:	f862                	sd	s8,48(sp)
     d46:	f466                	sd	s9,40(sp)
     d48:	f06a                	sd	s10,32(sp)
     d4a:	ec6e                	sd	s11,24(sp)
     d4c:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d4e:	0005c903          	lbu	s2,0(a1)
     d52:	24090c63          	beqz	s2,faa <vprintf+0x27a>
     d56:	8b2a                	mv	s6,a0
     d58:	8a2e                	mv	s4,a1
     d5a:	8bb2                	mv	s7,a2
  state = 0;
     d5c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d5e:	4481                	li	s1,0
     d60:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d62:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d66:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d6a:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d6e:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d72:	00000c97          	auipc	s9,0x0
     d76:	70ec8c93          	addi	s9,s9,1806 # 1480 <digits>
     d7a:	a005                	j	d9a <vprintf+0x6a>
        putc(fd, c0);
     d7c:	85ca                	mv	a1,s2
     d7e:	855a                	mv	a0,s6
     d80:	ef7ff0ef          	jal	ra,c76 <putc>
     d84:	a019                	j	d8a <vprintf+0x5a>
    } else if(state == '%'){
     d86:	03598263          	beq	s3,s5,daa <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     d8a:	2485                	addiw	s1,s1,1
     d8c:	8726                	mv	a4,s1
     d8e:	009a07b3          	add	a5,s4,s1
     d92:	0007c903          	lbu	s2,0(a5)
     d96:	20090a63          	beqz	s2,faa <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
     d9a:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d9e:	fe0994e3          	bnez	s3,d86 <vprintf+0x56>
      if(c0 == '%'){
     da2:	fd579de3          	bne	a5,s5,d7c <vprintf+0x4c>
        state = '%';
     da6:	89be                	mv	s3,a5
     da8:	b7cd                	j	d8a <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
     daa:	c3c1                	beqz	a5,e2a <vprintf+0xfa>
     dac:	00ea06b3          	add	a3,s4,a4
     db0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     db4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     db6:	c681                	beqz	a3,dbe <vprintf+0x8e>
     db8:	9752                	add	a4,a4,s4
     dba:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     dbe:	03878e63          	beq	a5,s8,dfa <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
     dc2:	05a78863          	beq	a5,s10,e12 <vprintf+0xe2>
      } else if(c0 == 'u'){
     dc6:	0db78b63          	beq	a5,s11,e9c <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     dca:	07800713          	li	a4,120
     dce:	10e78d63          	beq	a5,a4,ee8 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     dd2:	07000713          	li	a4,112
     dd6:	14e78263          	beq	a5,a4,f1a <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     dda:	06300713          	li	a4,99
     dde:	16e78f63          	beq	a5,a4,f5c <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     de2:	07300713          	li	a4,115
     de6:	18e78563          	beq	a5,a4,f70 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     dea:	05579063          	bne	a5,s5,e2a <vprintf+0xfa>
        putc(fd, '%');
     dee:	85d6                	mv	a1,s5
     df0:	855a                	mv	a0,s6
     df2:	e85ff0ef          	jal	ra,c76 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     df6:	4981                	li	s3,0
     df8:	bf49                	j	d8a <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
     dfa:	008b8913          	addi	s2,s7,8
     dfe:	4685                	li	a3,1
     e00:	4629                	li	a2,10
     e02:	000ba583          	lw	a1,0(s7)
     e06:	855a                	mv	a0,s6
     e08:	e8dff0ef          	jal	ra,c94 <printint>
     e0c:	8bca                	mv	s7,s2
      state = 0;
     e0e:	4981                	li	s3,0
     e10:	bfad                	j	d8a <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
     e12:	03868663          	beq	a3,s8,e3e <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e16:	05a68163          	beq	a3,s10,e58 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
     e1a:	09b68d63          	beq	a3,s11,eb4 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e1e:	03a68f63          	beq	a3,s10,e5c <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
     e22:	07800793          	li	a5,120
     e26:	0cf68d63          	beq	a3,a5,f00 <vprintf+0x1d0>
        putc(fd, '%');
     e2a:	85d6                	mv	a1,s5
     e2c:	855a                	mv	a0,s6
     e2e:	e49ff0ef          	jal	ra,c76 <putc>
        putc(fd, c0);
     e32:	85ca                	mv	a1,s2
     e34:	855a                	mv	a0,s6
     e36:	e41ff0ef          	jal	ra,c76 <putc>
      state = 0;
     e3a:	4981                	li	s3,0
     e3c:	b7b9                	j	d8a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e3e:	008b8913          	addi	s2,s7,8
     e42:	4685                	li	a3,1
     e44:	4629                	li	a2,10
     e46:	000bb583          	ld	a1,0(s7)
     e4a:	855a                	mv	a0,s6
     e4c:	e49ff0ef          	jal	ra,c94 <printint>
        i += 1;
     e50:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e52:	8bca                	mv	s7,s2
      state = 0;
     e54:	4981                	li	s3,0
        i += 1;
     e56:	bf15                	j	d8a <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e58:	03860563          	beq	a2,s8,e82 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e5c:	07b60963          	beq	a2,s11,ece <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e60:	07800793          	li	a5,120
     e64:	fcf613e3          	bne	a2,a5,e2a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e68:	008b8913          	addi	s2,s7,8
     e6c:	4681                	li	a3,0
     e6e:	4641                	li	a2,16
     e70:	000bb583          	ld	a1,0(s7)
     e74:	855a                	mv	a0,s6
     e76:	e1fff0ef          	jal	ra,c94 <printint>
        i += 2;
     e7a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e7c:	8bca                	mv	s7,s2
      state = 0;
     e7e:	4981                	li	s3,0
        i += 2;
     e80:	b729                	j	d8a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e82:	008b8913          	addi	s2,s7,8
     e86:	4685                	li	a3,1
     e88:	4629                	li	a2,10
     e8a:	000bb583          	ld	a1,0(s7)
     e8e:	855a                	mv	a0,s6
     e90:	e05ff0ef          	jal	ra,c94 <printint>
        i += 2;
     e94:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e96:	8bca                	mv	s7,s2
      state = 0;
     e98:	4981                	li	s3,0
        i += 2;
     e9a:	bdc5                	j	d8a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     e9c:	008b8913          	addi	s2,s7,8
     ea0:	4681                	li	a3,0
     ea2:	4629                	li	a2,10
     ea4:	000be583          	lwu	a1,0(s7)
     ea8:	855a                	mv	a0,s6
     eaa:	debff0ef          	jal	ra,c94 <printint>
     eae:	8bca                	mv	s7,s2
      state = 0;
     eb0:	4981                	li	s3,0
     eb2:	bde1                	j	d8a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eb4:	008b8913          	addi	s2,s7,8
     eb8:	4681                	li	a3,0
     eba:	4629                	li	a2,10
     ebc:	000bb583          	ld	a1,0(s7)
     ec0:	855a                	mv	a0,s6
     ec2:	dd3ff0ef          	jal	ra,c94 <printint>
        i += 1;
     ec6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ec8:	8bca                	mv	s7,s2
      state = 0;
     eca:	4981                	li	s3,0
        i += 1;
     ecc:	bd7d                	j	d8a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ece:	008b8913          	addi	s2,s7,8
     ed2:	4681                	li	a3,0
     ed4:	4629                	li	a2,10
     ed6:	000bb583          	ld	a1,0(s7)
     eda:	855a                	mv	a0,s6
     edc:	db9ff0ef          	jal	ra,c94 <printint>
        i += 2;
     ee0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     ee2:	8bca                	mv	s7,s2
      state = 0;
     ee4:	4981                	li	s3,0
        i += 2;
     ee6:	b555                	j	d8a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     ee8:	008b8913          	addi	s2,s7,8
     eec:	4681                	li	a3,0
     eee:	4641                	li	a2,16
     ef0:	000be583          	lwu	a1,0(s7)
     ef4:	855a                	mv	a0,s6
     ef6:	d9fff0ef          	jal	ra,c94 <printint>
     efa:	8bca                	mv	s7,s2
      state = 0;
     efc:	4981                	li	s3,0
     efe:	b571                	j	d8a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f00:	008b8913          	addi	s2,s7,8
     f04:	4681                	li	a3,0
     f06:	4641                	li	a2,16
     f08:	000bb583          	ld	a1,0(s7)
     f0c:	855a                	mv	a0,s6
     f0e:	d87ff0ef          	jal	ra,c94 <printint>
        i += 1;
     f12:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f14:	8bca                	mv	s7,s2
      state = 0;
     f16:	4981                	li	s3,0
        i += 1;
     f18:	bd8d                	j	d8a <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
     f1a:	008b8793          	addi	a5,s7,8
     f1e:	f8f43423          	sd	a5,-120(s0)
     f22:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f26:	03000593          	li	a1,48
     f2a:	855a                	mv	a0,s6
     f2c:	d4bff0ef          	jal	ra,c76 <putc>
  putc(fd, 'x');
     f30:	07800593          	li	a1,120
     f34:	855a                	mv	a0,s6
     f36:	d41ff0ef          	jal	ra,c76 <putc>
     f3a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f3c:	03c9d793          	srli	a5,s3,0x3c
     f40:	97e6                	add	a5,a5,s9
     f42:	0007c583          	lbu	a1,0(a5)
     f46:	855a                	mv	a0,s6
     f48:	d2fff0ef          	jal	ra,c76 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f4c:	0992                	slli	s3,s3,0x4
     f4e:	397d                	addiw	s2,s2,-1
     f50:	fe0916e3          	bnez	s2,f3c <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
     f54:	f8843b83          	ld	s7,-120(s0)
      state = 0;
     f58:	4981                	li	s3,0
     f5a:	bd05                	j	d8a <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
     f5c:	008b8913          	addi	s2,s7,8
     f60:	000bc583          	lbu	a1,0(s7)
     f64:	855a                	mv	a0,s6
     f66:	d11ff0ef          	jal	ra,c76 <putc>
     f6a:	8bca                	mv	s7,s2
      state = 0;
     f6c:	4981                	li	s3,0
     f6e:	bd31                	j	d8a <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
     f70:	008b8993          	addi	s3,s7,8
     f74:	000bb903          	ld	s2,0(s7)
     f78:	00090f63          	beqz	s2,f96 <vprintf+0x266>
        for(; *s; s++)
     f7c:	00094583          	lbu	a1,0(s2)
     f80:	c195                	beqz	a1,fa4 <vprintf+0x274>
          putc(fd, *s);
     f82:	855a                	mv	a0,s6
     f84:	cf3ff0ef          	jal	ra,c76 <putc>
        for(; *s; s++)
     f88:	0905                	addi	s2,s2,1
     f8a:	00094583          	lbu	a1,0(s2)
     f8e:	f9f5                	bnez	a1,f82 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
     f90:	8bce                	mv	s7,s3
      state = 0;
     f92:	4981                	li	s3,0
     f94:	bbdd                	j	d8a <vprintf+0x5a>
          s = "(null)";
     f96:	00000917          	auipc	s2,0x0
     f9a:	4e290913          	addi	s2,s2,1250 # 1478 <malloc+0x3cc>
        for(; *s; s++)
     f9e:	02800593          	li	a1,40
     fa2:	b7c5                	j	f82 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
     fa4:	8bce                	mv	s7,s3
      state = 0;
     fa6:	4981                	li	s3,0
     fa8:	b3cd                	j	d8a <vprintf+0x5a>
    }
  }
}
     faa:	70e6                	ld	ra,120(sp)
     fac:	7446                	ld	s0,112(sp)
     fae:	74a6                	ld	s1,104(sp)
     fb0:	7906                	ld	s2,96(sp)
     fb2:	69e6                	ld	s3,88(sp)
     fb4:	6a46                	ld	s4,80(sp)
     fb6:	6aa6                	ld	s5,72(sp)
     fb8:	6b06                	ld	s6,64(sp)
     fba:	7be2                	ld	s7,56(sp)
     fbc:	7c42                	ld	s8,48(sp)
     fbe:	7ca2                	ld	s9,40(sp)
     fc0:	7d02                	ld	s10,32(sp)
     fc2:	6de2                	ld	s11,24(sp)
     fc4:	6109                	addi	sp,sp,128
     fc6:	8082                	ret

0000000000000fc8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fc8:	715d                	addi	sp,sp,-80
     fca:	ec06                	sd	ra,24(sp)
     fcc:	e822                	sd	s0,16(sp)
     fce:	1000                	addi	s0,sp,32
     fd0:	e010                	sd	a2,0(s0)
     fd2:	e414                	sd	a3,8(s0)
     fd4:	e818                	sd	a4,16(s0)
     fd6:	ec1c                	sd	a5,24(s0)
     fd8:	03043023          	sd	a6,32(s0)
     fdc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fe0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fe4:	8622                	mv	a2,s0
     fe6:	d4bff0ef          	jal	ra,d30 <vprintf>
}
     fea:	60e2                	ld	ra,24(sp)
     fec:	6442                	ld	s0,16(sp)
     fee:	6161                	addi	sp,sp,80
     ff0:	8082                	ret

0000000000000ff2 <printf>:

void
printf(const char *fmt, ...)
{
     ff2:	711d                	addi	sp,sp,-96
     ff4:	ec06                	sd	ra,24(sp)
     ff6:	e822                	sd	s0,16(sp)
     ff8:	1000                	addi	s0,sp,32
     ffa:	e40c                	sd	a1,8(s0)
     ffc:	e810                	sd	a2,16(s0)
     ffe:	ec14                	sd	a3,24(s0)
    1000:	f018                	sd	a4,32(s0)
    1002:	f41c                	sd	a5,40(s0)
    1004:	03043823          	sd	a6,48(s0)
    1008:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    100c:	00840613          	addi	a2,s0,8
    1010:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1014:	85aa                	mv	a1,a0
    1016:	4505                	li	a0,1
    1018:	d19ff0ef          	jal	ra,d30 <vprintf>
}
    101c:	60e2                	ld	ra,24(sp)
    101e:	6442                	ld	s0,16(sp)
    1020:	6125                	addi	sp,sp,96
    1022:	8082                	ret

0000000000001024 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1024:	1141                	addi	sp,sp,-16
    1026:	e422                	sd	s0,8(sp)
    1028:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    102a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    102e:	00001797          	auipc	a5,0x1
    1032:	fe27b783          	ld	a5,-30(a5) # 2010 <freep>
    1036:	a805                	j	1066 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1038:	4618                	lw	a4,8(a2)
    103a:	9db9                	addw	a1,a1,a4
    103c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1040:	6398                	ld	a4,0(a5)
    1042:	6318                	ld	a4,0(a4)
    1044:	fee53823          	sd	a4,-16(a0)
    1048:	a091                	j	108c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    104a:	ff852703          	lw	a4,-8(a0)
    104e:	9e39                	addw	a2,a2,a4
    1050:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1052:	ff053703          	ld	a4,-16(a0)
    1056:	e398                	sd	a4,0(a5)
    1058:	a099                	j	109e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    105a:	6398                	ld	a4,0(a5)
    105c:	00e7e463          	bltu	a5,a4,1064 <free+0x40>
    1060:	00e6ea63          	bltu	a3,a4,1074 <free+0x50>
{
    1064:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1066:	fed7fae3          	bgeu	a5,a3,105a <free+0x36>
    106a:	6398                	ld	a4,0(a5)
    106c:	00e6e463          	bltu	a3,a4,1074 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1070:	fee7eae3          	bltu	a5,a4,1064 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1074:	ff852583          	lw	a1,-8(a0)
    1078:	6390                	ld	a2,0(a5)
    107a:	02059713          	slli	a4,a1,0x20
    107e:	9301                	srli	a4,a4,0x20
    1080:	0712                	slli	a4,a4,0x4
    1082:	9736                	add	a4,a4,a3
    1084:	fae60ae3          	beq	a2,a4,1038 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1088:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    108c:	4790                	lw	a2,8(a5)
    108e:	02061713          	slli	a4,a2,0x20
    1092:	9301                	srli	a4,a4,0x20
    1094:	0712                	slli	a4,a4,0x4
    1096:	973e                	add	a4,a4,a5
    1098:	fae689e3          	beq	a3,a4,104a <free+0x26>
  } else
    p->s.ptr = bp;
    109c:	e394                	sd	a3,0(a5)
  freep = p;
    109e:	00001717          	auipc	a4,0x1
    10a2:	f6f73923          	sd	a5,-142(a4) # 2010 <freep>
}
    10a6:	6422                	ld	s0,8(sp)
    10a8:	0141                	addi	sp,sp,16
    10aa:	8082                	ret

00000000000010ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10ac:	7139                	addi	sp,sp,-64
    10ae:	fc06                	sd	ra,56(sp)
    10b0:	f822                	sd	s0,48(sp)
    10b2:	f426                	sd	s1,40(sp)
    10b4:	f04a                	sd	s2,32(sp)
    10b6:	ec4e                	sd	s3,24(sp)
    10b8:	e852                	sd	s4,16(sp)
    10ba:	e456                	sd	s5,8(sp)
    10bc:	e05a                	sd	s6,0(sp)
    10be:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10c0:	02051493          	slli	s1,a0,0x20
    10c4:	9081                	srli	s1,s1,0x20
    10c6:	04bd                	addi	s1,s1,15
    10c8:	8091                	srli	s1,s1,0x4
    10ca:	0014899b          	addiw	s3,s1,1
    10ce:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    10d0:	00001517          	auipc	a0,0x1
    10d4:	f4053503          	ld	a0,-192(a0) # 2010 <freep>
    10d8:	c515                	beqz	a0,1104 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10dc:	4798                	lw	a4,8(a5)
    10de:	02977f63          	bgeu	a4,s1,111c <malloc+0x70>
    10e2:	8a4e                	mv	s4,s3
    10e4:	0009871b          	sext.w	a4,s3
    10e8:	6685                	lui	a3,0x1
    10ea:	00d77363          	bgeu	a4,a3,10f0 <malloc+0x44>
    10ee:	6a05                	lui	s4,0x1
    10f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10f8:	00001917          	auipc	s2,0x1
    10fc:	f1890913          	addi	s2,s2,-232 # 2010 <freep>
  if(p == SBRK_ERROR)
    1100:	5afd                	li	s5,-1
    1102:	a0bd                	j	1170 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    1104:	00001797          	auipc	a5,0x1
    1108:	30478793          	addi	a5,a5,772 # 2408 <base>
    110c:	00001717          	auipc	a4,0x1
    1110:	f0f73223          	sd	a5,-252(a4) # 2010 <freep>
    1114:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1116:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    111a:	b7e1                	j	10e2 <malloc+0x36>
      if(p->s.size == nunits)
    111c:	02e48b63          	beq	s1,a4,1152 <malloc+0xa6>
        p->s.size -= nunits;
    1120:	4137073b          	subw	a4,a4,s3
    1124:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1126:	1702                	slli	a4,a4,0x20
    1128:	9301                	srli	a4,a4,0x20
    112a:	0712                	slli	a4,a4,0x4
    112c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    112e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1132:	00001717          	auipc	a4,0x1
    1136:	eca73f23          	sd	a0,-290(a4) # 2010 <freep>
      return (void*)(p + 1);
    113a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    113e:	70e2                	ld	ra,56(sp)
    1140:	7442                	ld	s0,48(sp)
    1142:	74a2                	ld	s1,40(sp)
    1144:	7902                	ld	s2,32(sp)
    1146:	69e2                	ld	s3,24(sp)
    1148:	6a42                	ld	s4,16(sp)
    114a:	6aa2                	ld	s5,8(sp)
    114c:	6b02                	ld	s6,0(sp)
    114e:	6121                	addi	sp,sp,64
    1150:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1152:	6398                	ld	a4,0(a5)
    1154:	e118                	sd	a4,0(a0)
    1156:	bff1                	j	1132 <malloc+0x86>
  hp->s.size = nu;
    1158:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    115c:	0541                	addi	a0,a0,16
    115e:	ec7ff0ef          	jal	ra,1024 <free>
  return freep;
    1162:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1166:	dd61                	beqz	a0,113e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1168:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    116a:	4798                	lw	a4,8(a5)
    116c:	fa9778e3          	bgeu	a4,s1,111c <malloc+0x70>
    if(p == freep)
    1170:	00093703          	ld	a4,0(s2)
    1174:	853e                	mv	a0,a5
    1176:	fef719e3          	bne	a4,a5,1168 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    117a:	8552                	mv	a0,s4
    117c:	a1fff0ef          	jal	ra,b9a <sbrk>
  if(p == SBRK_ERROR)
    1180:	fd551ce3          	bne	a0,s5,1158 <malloc+0xac>
        return 0;
    1184:	4501                	li	a0,0
    1186:	bf65                	j	113e <malloc+0x92>
