
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      11:	eb 0e                	jmp    21 <main+0x21>
      13:	90                   	nop
      14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	0f 8f b7 00 00 00    	jg     d8 <main+0xd8>
  while((fd = open("console", O_RDWR)) >= 0){
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 a9 12 00 00       	push   $0x12a9
      2b:	e8 41 0d 00 00       	call   d71 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	eb 32                	jmp    6b <main+0x6b>
      39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      40:	80 3d e2 18 00 00 20 	cmpb   $0x20,0x18e2
      47:	74 51                	je     9a <main+0x9a>
      49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
int
fork1(void)
{
  int pid;

  pid = fork();
      50:	e8 d4 0c 00 00       	call   d29 <fork>
  if(pid == -1)
      55:	83 f8 ff             	cmp    $0xffffffff,%eax
      58:	0f 84 9d 00 00 00    	je     fb <main+0xfb>
    if(fork1() == 0)
      5e:	85 c0                	test   %eax,%eax
      60:	0f 84 80 00 00 00    	je     e6 <main+0xe6>
    wait();
      66:	e8 ce 0c 00 00       	call   d39 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
      6b:	83 ec 08             	sub    $0x8,%esp
      6e:	6a 64                	push   $0x64
      70:	68 e0 18 00 00       	push   $0x18e0
      75:	e8 96 00 00 00       	call   110 <getcmd>
      7a:	83 c4 10             	add    $0x10,%esp
      7d:	85 c0                	test   %eax,%eax
      7f:	78 14                	js     95 <main+0x95>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      81:	80 3d e0 18 00 00 63 	cmpb   $0x63,0x18e0
      88:	75 c6                	jne    50 <main+0x50>
      8a:	80 3d e1 18 00 00 64 	cmpb   $0x64,0x18e1
      91:	75 bd                	jne    50 <main+0x50>
      93:	eb ab                	jmp    40 <main+0x40>
  exit();
      95:	e8 97 0c 00 00       	call   d31 <exit>
      buf[strlen(buf)-1] = 0;  // chop \n
      9a:	83 ec 0c             	sub    $0xc,%esp
      9d:	68 e0 18 00 00       	push   $0x18e0
      a2:	e8 b9 0a 00 00       	call   b60 <strlen>
      if(chdir(buf+3) < 0)
      a7:	c7 04 24 e3 18 00 00 	movl   $0x18e3,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      ae:	c6 80 df 18 00 00 00 	movb   $0x0,0x18df(%eax)
      if(chdir(buf+3) < 0)
      b5:	e8 e7 0c 00 00       	call   da1 <chdir>
      ba:	83 c4 10             	add    $0x10,%esp
      bd:	85 c0                	test   %eax,%eax
      bf:	79 aa                	jns    6b <main+0x6b>
        printf(2, "cannot cd %s\n", buf+3);
      c1:	50                   	push   %eax
      c2:	68 e3 18 00 00       	push   $0x18e3
      c7:	68 b1 12 00 00       	push   $0x12b1
      cc:	6a 02                	push   $0x2
      ce:	e8 cd 0d 00 00       	call   ea0 <printf>
      d3:	83 c4 10             	add    $0x10,%esp
      d6:	eb 93                	jmp    6b <main+0x6b>
      close(fd);
      d8:	83 ec 0c             	sub    $0xc,%esp
      db:	50                   	push   %eax
      dc:	e8 78 0c 00 00       	call   d59 <close>
      break;
      e1:	83 c4 10             	add    $0x10,%esp
      e4:	eb 85                	jmp    6b <main+0x6b>
      runcmd(parsecmd(buf));
      e6:	83 ec 0c             	sub    $0xc,%esp
      e9:	68 e0 18 00 00       	push   $0x18e0
      ee:	e8 7d 09 00 00       	call   a70 <parsecmd>
      f3:	89 04 24             	mov    %eax,(%esp)
      f6:	e8 85 00 00 00       	call   180 <runcmd>
    panic("fork");
      fb:	83 ec 0c             	sub    $0xc,%esp
      fe:	68 32 12 00 00       	push   $0x1232
     103:	e8 58 00 00 00       	call   160 <panic>
     108:	66 90                	xchg   %ax,%ax
     10a:	66 90                	xchg   %ax,%ax
     10c:	66 90                	xchg   %ax,%ax
     10e:	66 90                	xchg   %ax,%ax

00000110 <getcmd>:
{
     110:	55                   	push   %ebp
     111:	89 e5                	mov    %esp,%ebp
     113:	56                   	push   %esi
     114:	53                   	push   %ebx
     115:	8b 75 0c             	mov    0xc(%ebp),%esi
     118:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     11b:	83 ec 08             	sub    $0x8,%esp
     11e:	68 08 12 00 00       	push   $0x1208
     123:	6a 02                	push   $0x2
     125:	e8 76 0d 00 00       	call   ea0 <printf>
  memset(buf, 0, nbuf);
     12a:	83 c4 0c             	add    $0xc,%esp
     12d:	56                   	push   %esi
     12e:	6a 00                	push   $0x0
     130:	53                   	push   %ebx
     131:	e8 5a 0a 00 00       	call   b90 <memset>
  gets(buf, nbuf);
     136:	58                   	pop    %eax
     137:	5a                   	pop    %edx
     138:	56                   	push   %esi
     139:	53                   	push   %ebx
     13a:	e8 b1 0a 00 00       	call   bf0 <gets>
  if(buf[0] == 0) // EOF
     13f:	83 c4 10             	add    $0x10,%esp
     142:	31 c0                	xor    %eax,%eax
     144:	80 3b 00             	cmpb   $0x0,(%ebx)
     147:	0f 94 c0             	sete   %al
}
     14a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     14d:	5b                   	pop    %ebx
  if(buf[0] == 0) // EOF
     14e:	f7 d8                	neg    %eax
}
     150:	5e                   	pop    %esi
     151:	5d                   	pop    %ebp
     152:	c3                   	ret    
     153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <panic>:
{
     160:	55                   	push   %ebp
     161:	89 e5                	mov    %esp,%ebp
     163:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     166:	ff 75 08             	pushl  0x8(%ebp)
     169:	68 a5 12 00 00       	push   $0x12a5
     16e:	6a 02                	push   $0x2
     170:	e8 2b 0d 00 00       	call   ea0 <printf>
  exit();
     175:	e8 b7 0b 00 00       	call   d31 <exit>
     17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000180 <runcmd>:
{
     180:	55                   	push   %ebp
     181:	89 e5                	mov    %esp,%ebp
     183:	53                   	push   %ebx
     184:	83 ec 14             	sub    $0x14,%esp
     187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     18a:	85 db                	test   %ebx,%ebx
     18c:	74 7a                	je     208 <runcmd+0x88>
  switch(cmd->type){
     18e:	83 3b 05             	cmpl   $0x5,(%ebx)
     191:	0f 87 00 01 00 00    	ja     297 <runcmd+0x117>
     197:	8b 03                	mov    (%ebx),%eax
     199:	ff 24 85 c0 12 00 00 	jmp    *0x12c0(,%eax,4)
    if(pipe(p) < 0)
     1a0:	83 ec 0c             	sub    $0xc,%esp
     1a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
     1a6:	50                   	push   %eax
     1a7:	e8 95 0b 00 00       	call   d41 <pipe>
     1ac:	83 c4 10             	add    $0x10,%esp
     1af:	85 c0                	test   %eax,%eax
     1b1:	0f 88 02 01 00 00    	js     2b9 <runcmd+0x139>
  pid = fork();
     1b7:	e8 6d 0b 00 00       	call   d29 <fork>
  if(pid == -1)
     1bc:	83 f8 ff             	cmp    $0xffffffff,%eax
     1bf:	0f 84 5d 01 00 00    	je     322 <runcmd+0x1a2>
    if(fork1() == 0){
     1c5:	85 c0                	test   %eax,%eax
     1c7:	0f 84 f9 00 00 00    	je     2c6 <runcmd+0x146>
  pid = fork();
     1cd:	e8 57 0b 00 00       	call   d29 <fork>
  if(pid == -1)
     1d2:	83 f8 ff             	cmp    $0xffffffff,%eax
     1d5:	0f 84 47 01 00 00    	je     322 <runcmd+0x1a2>
    if(fork1() == 0){
     1db:	85 c0                	test   %eax,%eax
     1dd:	0f 84 11 01 00 00    	je     2f4 <runcmd+0x174>
    close(p[0]);
     1e3:	83 ec 0c             	sub    $0xc,%esp
     1e6:	ff 75 f0             	pushl  -0x10(%ebp)
     1e9:	e8 6b 0b 00 00       	call   d59 <close>
    close(p[1]);
     1ee:	58                   	pop    %eax
     1ef:	ff 75 f4             	pushl  -0xc(%ebp)
     1f2:	e8 62 0b 00 00       	call   d59 <close>
    wait();
     1f7:	e8 3d 0b 00 00       	call   d39 <wait>
    wait();
     1fc:	e8 38 0b 00 00       	call   d39 <wait>
    break;
     201:	83 c4 10             	add    $0x10,%esp
     204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
     208:	e8 24 0b 00 00       	call   d31 <exit>
  pid = fork();
     20d:	e8 17 0b 00 00       	call   d29 <fork>
  if(pid == -1)
     212:	83 f8 ff             	cmp    $0xffffffff,%eax
     215:	0f 84 07 01 00 00    	je     322 <runcmd+0x1a2>
    if(fork1() == 0)
     21b:	85 c0                	test   %eax,%eax
     21d:	75 e9                	jne    208 <runcmd+0x88>
     21f:	eb 6b                	jmp    28c <runcmd+0x10c>
    if(ecmd->argv[0] == 0)
     221:	8b 43 04             	mov    0x4(%ebx),%eax
     224:	85 c0                	test   %eax,%eax
     226:	74 e0                	je     208 <runcmd+0x88>
    exec(ecmd->argv[0], ecmd->argv);
     228:	52                   	push   %edx
     229:	52                   	push   %edx
     22a:	8d 53 04             	lea    0x4(%ebx),%edx
     22d:	52                   	push   %edx
     22e:	50                   	push   %eax
     22f:	e8 35 0b 00 00       	call   d69 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     234:	83 c4 0c             	add    $0xc,%esp
     237:	ff 73 04             	pushl  0x4(%ebx)
     23a:	68 12 12 00 00       	push   $0x1212
     23f:	6a 02                	push   $0x2
     241:	e8 5a 0c 00 00       	call   ea0 <printf>
    break;
     246:	83 c4 10             	add    $0x10,%esp
     249:	eb bd                	jmp    208 <runcmd+0x88>
  pid = fork();
     24b:	e8 d9 0a 00 00       	call   d29 <fork>
  if(pid == -1)
     250:	83 f8 ff             	cmp    $0xffffffff,%eax
     253:	0f 84 c9 00 00 00    	je     322 <runcmd+0x1a2>
    if(fork1() == 0)
     259:	85 c0                	test   %eax,%eax
     25b:	74 2f                	je     28c <runcmd+0x10c>
    wait();
     25d:	e8 d7 0a 00 00       	call   d39 <wait>
    runcmd(lcmd->right);
     262:	83 ec 0c             	sub    $0xc,%esp
     265:	ff 73 08             	pushl  0x8(%ebx)
     268:	e8 13 ff ff ff       	call   180 <runcmd>
    close(rcmd->fd);
     26d:	83 ec 0c             	sub    $0xc,%esp
     270:	ff 73 14             	pushl  0x14(%ebx)
     273:	e8 e1 0a 00 00       	call   d59 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     278:	59                   	pop    %ecx
     279:	58                   	pop    %eax
     27a:	ff 73 10             	pushl  0x10(%ebx)
     27d:	ff 73 08             	pushl  0x8(%ebx)
     280:	e8 ec 0a 00 00       	call   d71 <open>
     285:	83 c4 10             	add    $0x10,%esp
     288:	85 c0                	test   %eax,%eax
     28a:	78 18                	js     2a4 <runcmd+0x124>
      runcmd(bcmd->cmd);
     28c:	83 ec 0c             	sub    $0xc,%esp
     28f:	ff 73 04             	pushl  0x4(%ebx)
     292:	e8 e9 fe ff ff       	call   180 <runcmd>
    panic("runcmd");
     297:	83 ec 0c             	sub    $0xc,%esp
     29a:	68 0b 12 00 00       	push   $0x120b
     29f:	e8 bc fe ff ff       	call   160 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     2a4:	52                   	push   %edx
     2a5:	ff 73 08             	pushl  0x8(%ebx)
     2a8:	68 22 12 00 00       	push   $0x1222
     2ad:	6a 02                	push   $0x2
     2af:	e8 ec 0b 00 00       	call   ea0 <printf>
      exit();
     2b4:	e8 78 0a 00 00       	call   d31 <exit>
      panic("pipe");
     2b9:	83 ec 0c             	sub    $0xc,%esp
     2bc:	68 37 12 00 00       	push   $0x1237
     2c1:	e8 9a fe ff ff       	call   160 <panic>
      close(1);
     2c6:	83 ec 0c             	sub    $0xc,%esp
     2c9:	6a 01                	push   $0x1
     2cb:	e8 89 0a 00 00       	call   d59 <close>
      dup(p[1]);
     2d0:	58                   	pop    %eax
     2d1:	ff 75 f4             	pushl  -0xc(%ebp)
     2d4:	e8 d0 0a 00 00       	call   da9 <dup>
      close(p[0]);
     2d9:	58                   	pop    %eax
     2da:	ff 75 f0             	pushl  -0x10(%ebp)
     2dd:	e8 77 0a 00 00       	call   d59 <close>
      close(p[1]);
     2e2:	58                   	pop    %eax
     2e3:	ff 75 f4             	pushl  -0xc(%ebp)
     2e6:	e8 6e 0a 00 00       	call   d59 <close>
      runcmd(pcmd->left);
     2eb:	58                   	pop    %eax
     2ec:	ff 73 04             	pushl  0x4(%ebx)
     2ef:	e8 8c fe ff ff       	call   180 <runcmd>
      close(0);
     2f4:	83 ec 0c             	sub    $0xc,%esp
     2f7:	6a 00                	push   $0x0
     2f9:	e8 5b 0a 00 00       	call   d59 <close>
      dup(p[0]);
     2fe:	5a                   	pop    %edx
     2ff:	ff 75 f0             	pushl  -0x10(%ebp)
     302:	e8 a2 0a 00 00       	call   da9 <dup>
      close(p[0]);
     307:	59                   	pop    %ecx
     308:	ff 75 f0             	pushl  -0x10(%ebp)
     30b:	e8 49 0a 00 00       	call   d59 <close>
      close(p[1]);
     310:	58                   	pop    %eax
     311:	ff 75 f4             	pushl  -0xc(%ebp)
     314:	e8 40 0a 00 00       	call   d59 <close>
      runcmd(pcmd->right);
     319:	58                   	pop    %eax
     31a:	ff 73 08             	pushl  0x8(%ebx)
     31d:	e8 5e fe ff ff       	call   180 <runcmd>
    panic("fork");
     322:	83 ec 0c             	sub    $0xc,%esp
     325:	68 32 12 00 00       	push   $0x1232
     32a:	e8 31 fe ff ff       	call   160 <panic>
     32f:	90                   	nop

00000330 <fork1>:
{
     330:	55                   	push   %ebp
     331:	89 e5                	mov    %esp,%ebp
     333:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     336:	e8 ee 09 00 00       	call   d29 <fork>
  if(pid == -1)
     33b:	83 f8 ff             	cmp    $0xffffffff,%eax
     33e:	74 02                	je     342 <fork1+0x12>
  return pid;
}
     340:	c9                   	leave  
     341:	c3                   	ret    
    panic("fork");
     342:	83 ec 0c             	sub    $0xc,%esp
     345:	68 32 12 00 00       	push   $0x1232
     34a:	e8 11 fe ff ff       	call   160 <panic>
     34f:	90                   	nop

00000350 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     350:	55                   	push   %ebp
     351:	89 e5                	mov    %esp,%ebp
     353:	53                   	push   %ebx
     354:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     357:	6a 54                	push   $0x54
     359:	e8 a2 0d 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     35e:	83 c4 0c             	add    $0xc,%esp
     361:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     363:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     365:	6a 00                	push   $0x0
     367:	50                   	push   %eax
     368:	e8 23 08 00 00       	call   b90 <memset>
  cmd->type = EXEC;
     36d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     373:	89 d8                	mov    %ebx,%eax
     375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     378:	c9                   	leave  
     379:	c3                   	ret    
     37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000380 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	53                   	push   %ebx
     384:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     387:	6a 18                	push   $0x18
     389:	e8 72 0d 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     38e:	83 c4 0c             	add    $0xc,%esp
     391:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     393:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     395:	6a 00                	push   $0x0
     397:	50                   	push   %eax
     398:	e8 f3 07 00 00       	call   b90 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     39d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     3a0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     3a6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ac:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     3af:	8b 45 10             	mov    0x10(%ebp),%eax
     3b2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     3b5:	8b 45 14             	mov    0x14(%ebp),%eax
     3b8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     3bb:	8b 45 18             	mov    0x18(%ebp),%eax
     3be:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3c1:	89 d8                	mov    %ebx,%eax
     3c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3c6:	c9                   	leave  
     3c7:	c3                   	ret    
     3c8:	90                   	nop
     3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003d0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     3d0:	55                   	push   %ebp
     3d1:	89 e5                	mov    %esp,%ebp
     3d3:	53                   	push   %ebx
     3d4:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3d7:	6a 0c                	push   $0xc
     3d9:	e8 22 0d 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3de:	83 c4 0c             	add    $0xc,%esp
     3e1:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     3e3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3e5:	6a 00                	push   $0x0
     3e7:	50                   	push   %eax
     3e8:	e8 a3 07 00 00       	call   b90 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     3ed:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     3f0:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     3f6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3fc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     3ff:	89 d8                	mov    %ebx,%eax
     401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     404:	c9                   	leave  
     405:	c3                   	ret    
     406:	8d 76 00             	lea    0x0(%esi),%esi
     409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	53                   	push   %ebx
     414:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     417:	6a 0c                	push   $0xc
     419:	e8 e2 0c 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     41e:	83 c4 0c             	add    $0xc,%esp
     421:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     423:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     425:	6a 00                	push   $0x0
     427:	50                   	push   %eax
     428:	e8 63 07 00 00       	call   b90 <memset>
  cmd->type = LIST;
  cmd->left = left;
     42d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     430:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     436:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     439:	8b 45 0c             	mov    0xc(%ebp),%eax
     43c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     43f:	89 d8                	mov    %ebx,%eax
     441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     444:	c9                   	leave  
     445:	c3                   	ret    
     446:	8d 76 00             	lea    0x0(%esi),%esi
     449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     450:	55                   	push   %ebp
     451:	89 e5                	mov    %esp,%ebp
     453:	53                   	push   %ebx
     454:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     457:	6a 08                	push   $0x8
     459:	e8 a2 0c 00 00       	call   1100 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     45e:	83 c4 0c             	add    $0xc,%esp
     461:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     463:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     465:	6a 00                	push   $0x0
     467:	50                   	push   %eax
     468:	e8 23 07 00 00       	call   b90 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     46d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     470:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     476:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     479:	89 d8                	mov    %ebx,%eax
     47b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     47e:	c9                   	leave  
     47f:	c3                   	ret    

00000480 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     480:	55                   	push   %ebp
     481:	89 e5                	mov    %esp,%ebp
     483:	57                   	push   %edi
     484:	56                   	push   %esi
     485:	53                   	push   %ebx
     486:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     489:	8b 45 08             	mov    0x8(%ebp),%eax
{
     48c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     48f:	8b 7d 10             	mov    0x10(%ebp),%edi
  s = *ps;
     492:	8b 30                	mov    (%eax),%esi
  while(s < es && strchr(whitespace, *s))
     494:	39 de                	cmp    %ebx,%esi
     496:	72 0f                	jb     4a7 <gettoken+0x27>
     498:	eb 25                	jmp    4bf <gettoken+0x3f>
     49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     4a0:	83 c6 01             	add    $0x1,%esi
  while(s < es && strchr(whitespace, *s))
     4a3:	39 f3                	cmp    %esi,%ebx
     4a5:	74 18                	je     4bf <gettoken+0x3f>
     4a7:	0f be 06             	movsbl (%esi),%eax
     4aa:	83 ec 08             	sub    $0x8,%esp
     4ad:	50                   	push   %eax
     4ae:	68 d0 18 00 00       	push   $0x18d0
     4b3:	e8 f8 06 00 00       	call   bb0 <strchr>
     4b8:	83 c4 10             	add    $0x10,%esp
     4bb:	85 c0                	test   %eax,%eax
     4bd:	75 e1                	jne    4a0 <gettoken+0x20>
  if(q)
     4bf:	85 ff                	test   %edi,%edi
     4c1:	74 02                	je     4c5 <gettoken+0x45>
    *q = s;
     4c3:	89 37                	mov    %esi,(%edi)
  ret = *s;
     4c5:	0f be 06             	movsbl (%esi),%eax
  switch(*s){
     4c8:	3c 29                	cmp    $0x29,%al
     4ca:	0f 8f b8 00 00 00    	jg     588 <gettoken+0x108>
     4d0:	3c 28                	cmp    $0x28,%al
     4d2:	0f 8d de 00 00 00    	jge    5b6 <gettoken+0x136>
     4d8:	31 ff                	xor    %edi,%edi
     4da:	84 c0                	test   %al,%al
     4dc:	75 42                	jne    520 <gettoken+0xa0>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     4de:	8b 55 14             	mov    0x14(%ebp),%edx
     4e1:	85 d2                	test   %edx,%edx
     4e3:	74 05                	je     4ea <gettoken+0x6a>
    *eq = s;
     4e5:	8b 45 14             	mov    0x14(%ebp),%eax
     4e8:	89 30                	mov    %esi,(%eax)

  while(s < es && strchr(whitespace, *s))
     4ea:	39 de                	cmp    %ebx,%esi
     4ec:	72 09                	jb     4f7 <gettoken+0x77>
     4ee:	eb 1f                	jmp    50f <gettoken+0x8f>
    s++;
     4f0:	83 c6 01             	add    $0x1,%esi
  while(s < es && strchr(whitespace, *s))
     4f3:	39 f3                	cmp    %esi,%ebx
     4f5:	74 18                	je     50f <gettoken+0x8f>
     4f7:	0f be 06             	movsbl (%esi),%eax
     4fa:	83 ec 08             	sub    $0x8,%esp
     4fd:	50                   	push   %eax
     4fe:	68 d0 18 00 00       	push   $0x18d0
     503:	e8 a8 06 00 00       	call   bb0 <strchr>
     508:	83 c4 10             	add    $0x10,%esp
     50b:	85 c0                	test   %eax,%eax
     50d:	75 e1                	jne    4f0 <gettoken+0x70>
  *ps = s;
     50f:	8b 45 08             	mov    0x8(%ebp),%eax
     512:	89 30                	mov    %esi,(%eax)
  return ret;
}
     514:	8d 65 f4             	lea    -0xc(%ebp),%esp
     517:	89 f8                	mov    %edi,%eax
     519:	5b                   	pop    %ebx
     51a:	5e                   	pop    %esi
     51b:	5f                   	pop    %edi
     51c:	5d                   	pop    %ebp
     51d:	c3                   	ret    
     51e:	66 90                	xchg   %ax,%ax
  switch(*s){
     520:	3c 26                	cmp    $0x26,%al
     522:	0f 84 8e 00 00 00    	je     5b6 <gettoken+0x136>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     528:	39 f3                	cmp    %esi,%ebx
     52a:	77 36                	ja     562 <gettoken+0xe2>
  if(eq)
     52c:	8b 45 14             	mov    0x14(%ebp),%eax
     52f:	bf 61 00 00 00       	mov    $0x61,%edi
     534:	85 c0                	test   %eax,%eax
     536:	75 ad                	jne    4e5 <gettoken+0x65>
     538:	eb d5                	jmp    50f <gettoken+0x8f>
     53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     540:	0f be 06             	movsbl (%esi),%eax
     543:	83 ec 08             	sub    $0x8,%esp
     546:	50                   	push   %eax
     547:	68 c8 18 00 00       	push   $0x18c8
     54c:	e8 5f 06 00 00       	call   bb0 <strchr>
     551:	83 c4 10             	add    $0x10,%esp
     554:	85 c0                	test   %eax,%eax
     556:	75 1f                	jne    577 <gettoken+0xf7>
      s++;
     558:	83 c6 01             	add    $0x1,%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     55b:	39 f3                	cmp    %esi,%ebx
     55d:	74 cd                	je     52c <gettoken+0xac>
     55f:	0f be 06             	movsbl (%esi),%eax
     562:	83 ec 08             	sub    $0x8,%esp
     565:	50                   	push   %eax
     566:	68 d0 18 00 00       	push   $0x18d0
     56b:	e8 40 06 00 00       	call   bb0 <strchr>
     570:	83 c4 10             	add    $0x10,%esp
     573:	85 c0                	test   %eax,%eax
     575:	74 c9                	je     540 <gettoken+0xc0>
    ret = 'a';
     577:	bf 61 00 00 00       	mov    $0x61,%edi
     57c:	e9 5d ff ff ff       	jmp    4de <gettoken+0x5e>
     581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     588:	3c 3e                	cmp    $0x3e,%al
     58a:	75 1c                	jne    5a8 <gettoken+0x128>
    if(*s == '>'){
     58c:	80 7e 01 3e          	cmpb   $0x3e,0x1(%esi)
    s++;
     590:	8d 46 01             	lea    0x1(%esi),%eax
    if(*s == '>'){
     593:	74 3c                	je     5d1 <gettoken+0x151>
    s++;
     595:	89 c6                	mov    %eax,%esi
     597:	bf 3e 00 00 00       	mov    $0x3e,%edi
     59c:	e9 3d ff ff ff       	jmp    4de <gettoken+0x5e>
     5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     5a8:	7f 1e                	jg     5c8 <gettoken+0x148>
     5aa:	8d 48 c5             	lea    -0x3b(%eax),%ecx
     5ad:	80 f9 01             	cmp    $0x1,%cl
     5b0:	0f 87 72 ff ff ff    	ja     528 <gettoken+0xa8>
  ret = *s;
     5b6:	0f be f8             	movsbl %al,%edi
    s++;
     5b9:	83 c6 01             	add    $0x1,%esi
    break;
     5bc:	e9 1d ff ff ff       	jmp    4de <gettoken+0x5e>
     5c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     5c8:	3c 7c                	cmp    $0x7c,%al
     5ca:	74 ea                	je     5b6 <gettoken+0x136>
     5cc:	e9 57 ff ff ff       	jmp    528 <gettoken+0xa8>
      s++;
     5d1:	83 c6 02             	add    $0x2,%esi
      ret = '+';
     5d4:	bf 2b 00 00 00       	mov    $0x2b,%edi
     5d9:	e9 00 ff ff ff       	jmp    4de <gettoken+0x5e>
     5de:	66 90                	xchg   %ax,%ax

000005e0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     5e0:	55                   	push   %ebp
     5e1:	89 e5                	mov    %esp,%ebp
     5e3:	57                   	push   %edi
     5e4:	56                   	push   %esi
     5e5:	53                   	push   %ebx
     5e6:	83 ec 0c             	sub    $0xc,%esp
     5e9:	8b 7d 08             	mov    0x8(%ebp),%edi
     5ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     5ef:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     5f1:	39 f3                	cmp    %esi,%ebx
     5f3:	72 12                	jb     607 <peek+0x27>
     5f5:	eb 28                	jmp    61f <peek+0x3f>
     5f7:	89 f6                	mov    %esi,%esi
     5f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     600:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     603:	39 de                	cmp    %ebx,%esi
     605:	74 18                	je     61f <peek+0x3f>
     607:	0f be 03             	movsbl (%ebx),%eax
     60a:	83 ec 08             	sub    $0x8,%esp
     60d:	50                   	push   %eax
     60e:	68 d0 18 00 00       	push   $0x18d0
     613:	e8 98 05 00 00       	call   bb0 <strchr>
     618:	83 c4 10             	add    $0x10,%esp
     61b:	85 c0                	test   %eax,%eax
     61d:	75 e1                	jne    600 <peek+0x20>
  *ps = s;
     61f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     621:	0f be 13             	movsbl (%ebx),%edx
     624:	31 c0                	xor    %eax,%eax
     626:	84 d2                	test   %dl,%dl
     628:	75 0e                	jne    638 <peek+0x58>
}
     62a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     62d:	5b                   	pop    %ebx
     62e:	5e                   	pop    %esi
     62f:	5f                   	pop    %edi
     630:	5d                   	pop    %ebp
     631:	c3                   	ret    
     632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return *s && strchr(toks, *s);
     638:	83 ec 08             	sub    $0x8,%esp
     63b:	52                   	push   %edx
     63c:	ff 75 10             	pushl  0x10(%ebp)
     63f:	e8 6c 05 00 00       	call   bb0 <strchr>
     644:	83 c4 10             	add    $0x10,%esp
     647:	85 c0                	test   %eax,%eax
     649:	0f 95 c0             	setne  %al
}
     64c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     64f:	5b                   	pop    %ebx
  return *s && strchr(toks, *s);
     650:	0f b6 c0             	movzbl %al,%eax
}
     653:	5e                   	pop    %esi
     654:	5f                   	pop    %edi
     655:	5d                   	pop    %ebp
     656:	c3                   	ret    
     657:	89 f6                	mov    %esi,%esi
     659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000660 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     660:	55                   	push   %ebp
     661:	89 e5                	mov    %esp,%ebp
     663:	57                   	push   %edi
     664:	56                   	push   %esi
     665:	53                   	push   %ebx
     666:	83 ec 1c             	sub    $0x1c,%esp
     669:	8b 75 0c             	mov    0xc(%ebp),%esi
     66c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     66f:	90                   	nop
     670:	83 ec 04             	sub    $0x4,%esp
     673:	68 59 12 00 00       	push   $0x1259
     678:	53                   	push   %ebx
     679:	56                   	push   %esi
     67a:	e8 61 ff ff ff       	call   5e0 <peek>
     67f:	83 c4 10             	add    $0x10,%esp
     682:	85 c0                	test   %eax,%eax
     684:	74 6a                	je     6f0 <parseredirs+0x90>
    tok = gettoken(ps, es, 0, 0);
     686:	6a 00                	push   $0x0
     688:	6a 00                	push   $0x0
     68a:	53                   	push   %ebx
     68b:	56                   	push   %esi
     68c:	e8 ef fd ff ff       	call   480 <gettoken>
     691:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     693:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     696:	50                   	push   %eax
     697:	8d 45 e0             	lea    -0x20(%ebp),%eax
     69a:	50                   	push   %eax
     69b:	53                   	push   %ebx
     69c:	56                   	push   %esi
     69d:	e8 de fd ff ff       	call   480 <gettoken>
     6a2:	83 c4 20             	add    $0x20,%esp
     6a5:	83 f8 61             	cmp    $0x61,%eax
     6a8:	75 51                	jne    6fb <parseredirs+0x9b>
      panic("missing file for redirection");
    switch(tok){
     6aa:	83 ff 3c             	cmp    $0x3c,%edi
     6ad:	74 31                	je     6e0 <parseredirs+0x80>
     6af:	83 ff 3e             	cmp    $0x3e,%edi
     6b2:	74 05                	je     6b9 <parseredirs+0x59>
     6b4:	83 ff 2b             	cmp    $0x2b,%edi
     6b7:	75 b7                	jne    670 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6b9:	83 ec 0c             	sub    $0xc,%esp
     6bc:	6a 01                	push   $0x1
     6be:	68 01 02 00 00       	push   $0x201
     6c3:	ff 75 e4             	pushl  -0x1c(%ebp)
     6c6:	ff 75 e0             	pushl  -0x20(%ebp)
     6c9:	ff 75 08             	pushl  0x8(%ebp)
     6cc:	e8 af fc ff ff       	call   380 <redircmd>
      break;
     6d1:	83 c4 20             	add    $0x20,%esp
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6d4:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     6d7:	eb 97                	jmp    670 <parseredirs+0x10>
     6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     6e0:	83 ec 0c             	sub    $0xc,%esp
     6e3:	6a 00                	push   $0x0
     6e5:	6a 00                	push   $0x0
     6e7:	eb da                	jmp    6c3 <parseredirs+0x63>
     6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  return cmd;
}
     6f0:	8b 45 08             	mov    0x8(%ebp),%eax
     6f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6f6:	5b                   	pop    %ebx
     6f7:	5e                   	pop    %esi
     6f8:	5f                   	pop    %edi
     6f9:	5d                   	pop    %ebp
     6fa:	c3                   	ret    
      panic("missing file for redirection");
     6fb:	83 ec 0c             	sub    $0xc,%esp
     6fe:	68 3c 12 00 00       	push   $0x123c
     703:	e8 58 fa ff ff       	call   160 <panic>
     708:	90                   	nop
     709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000710 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     710:	55                   	push   %ebp
     711:	89 e5                	mov    %esp,%ebp
     713:	57                   	push   %edi
     714:	56                   	push   %esi
     715:	53                   	push   %ebx
     716:	83 ec 30             	sub    $0x30,%esp
     719:	8b 75 08             	mov    0x8(%ebp),%esi
     71c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     71f:	68 5c 12 00 00       	push   $0x125c
     724:	57                   	push   %edi
     725:	56                   	push   %esi
     726:	e8 b5 fe ff ff       	call   5e0 <peek>
     72b:	83 c4 10             	add    $0x10,%esp
     72e:	85 c0                	test   %eax,%eax
     730:	0f 85 92 00 00 00    	jne    7c8 <parseexec+0xb8>
     736:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     738:	e8 13 fc ff ff       	call   350 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     73d:	83 ec 04             	sub    $0x4,%esp
     740:	57                   	push   %edi
     741:	56                   	push   %esi
     742:	50                   	push   %eax
  ret = execcmd();
     743:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = parseredirs(ret, ps, es);
     746:	e8 15 ff ff ff       	call   660 <parseredirs>
     74b:	83 c4 10             	add    $0x10,%esp
     74e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     751:	eb 18                	jmp    76b <parseexec+0x5b>
     753:	90                   	nop
     754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     758:	83 ec 04             	sub    $0x4,%esp
     75b:	57                   	push   %edi
     75c:	56                   	push   %esi
     75d:	ff 75 d4             	pushl  -0x2c(%ebp)
     760:	e8 fb fe ff ff       	call   660 <parseredirs>
     765:	83 c4 10             	add    $0x10,%esp
     768:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     76b:	83 ec 04             	sub    $0x4,%esp
     76e:	68 73 12 00 00       	push   $0x1273
     773:	57                   	push   %edi
     774:	56                   	push   %esi
     775:	e8 66 fe ff ff       	call   5e0 <peek>
     77a:	83 c4 10             	add    $0x10,%esp
     77d:	85 c0                	test   %eax,%eax
     77f:	75 67                	jne    7e8 <parseexec+0xd8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     781:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     784:	50                   	push   %eax
     785:	8d 45 e0             	lea    -0x20(%ebp),%eax
     788:	50                   	push   %eax
     789:	57                   	push   %edi
     78a:	56                   	push   %esi
     78b:	e8 f0 fc ff ff       	call   480 <gettoken>
     790:	83 c4 10             	add    $0x10,%esp
     793:	85 c0                	test   %eax,%eax
     795:	74 51                	je     7e8 <parseexec+0xd8>
    if(tok != 'a')
     797:	83 f8 61             	cmp    $0x61,%eax
     79a:	75 6b                	jne    807 <parseexec+0xf7>
    cmd->argv[argc] = q;
     79c:	8b 45 e0             	mov    -0x20(%ebp),%eax
     79f:	8b 55 d0             	mov    -0x30(%ebp),%edx
     7a2:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     7a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7a9:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     7ad:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     7b0:	83 fb 0a             	cmp    $0xa,%ebx
     7b3:	75 a3                	jne    758 <parseexec+0x48>
      panic("too many args");
     7b5:	83 ec 0c             	sub    $0xc,%esp
     7b8:	68 65 12 00 00       	push   $0x1265
     7bd:	e8 9e f9 ff ff       	call   160 <panic>
     7c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     7c8:	83 ec 08             	sub    $0x8,%esp
     7cb:	57                   	push   %edi
     7cc:	56                   	push   %esi
     7cd:	e8 5e 01 00 00       	call   930 <parseblock>
     7d2:	83 c4 10             	add    $0x10,%esp
     7d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     7d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7db:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7de:	5b                   	pop    %ebx
     7df:	5e                   	pop    %esi
     7e0:	5f                   	pop    %edi
     7e1:	5d                   	pop    %ebp
     7e2:	c3                   	ret    
     7e3:	90                   	nop
     7e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  cmd->argv[argc] = 0;
     7e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
     7eb:	8d 04 98             	lea    (%eax,%ebx,4),%eax
     7ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     7f5:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
}
     7fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
     802:	5b                   	pop    %ebx
     803:	5e                   	pop    %esi
     804:	5f                   	pop    %edi
     805:	5d                   	pop    %ebp
     806:	c3                   	ret    
      panic("syntax");
     807:	83 ec 0c             	sub    $0xc,%esp
     80a:	68 5e 12 00 00       	push   $0x125e
     80f:	e8 4c f9 ff ff       	call   160 <panic>
     814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     81a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000820 <parsepipe>:
{
     820:	55                   	push   %ebp
     821:	89 e5                	mov    %esp,%ebp
     823:	57                   	push   %edi
     824:	56                   	push   %esi
     825:	53                   	push   %ebx
     826:	83 ec 14             	sub    $0x14,%esp
     829:	8b 5d 08             	mov    0x8(%ebp),%ebx
     82c:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parseexec(ps, es);
     82f:	56                   	push   %esi
     830:	53                   	push   %ebx
     831:	e8 da fe ff ff       	call   710 <parseexec>
  if(peek(ps, es, "|")){
     836:	83 c4 0c             	add    $0xc,%esp
     839:	68 78 12 00 00       	push   $0x1278
  cmd = parseexec(ps, es);
     83e:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     840:	56                   	push   %esi
     841:	53                   	push   %ebx
     842:	e8 99 fd ff ff       	call   5e0 <peek>
     847:	83 c4 10             	add    $0x10,%esp
     84a:	85 c0                	test   %eax,%eax
     84c:	75 12                	jne    860 <parsepipe+0x40>
}
     84e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     851:	89 f8                	mov    %edi,%eax
     853:	5b                   	pop    %ebx
     854:	5e                   	pop    %esi
     855:	5f                   	pop    %edi
     856:	5d                   	pop    %ebp
     857:	c3                   	ret    
     858:	90                   	nop
     859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     860:	6a 00                	push   $0x0
     862:	6a 00                	push   $0x0
     864:	56                   	push   %esi
     865:	53                   	push   %ebx
     866:	e8 15 fc ff ff       	call   480 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     86b:	58                   	pop    %eax
     86c:	5a                   	pop    %edx
     86d:	56                   	push   %esi
     86e:	53                   	push   %ebx
     86f:	e8 ac ff ff ff       	call   820 <parsepipe>
     874:	89 7d 08             	mov    %edi,0x8(%ebp)
     877:	83 c4 10             	add    $0x10,%esp
     87a:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     87d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     880:	5b                   	pop    %ebx
     881:	5e                   	pop    %esi
     882:	5f                   	pop    %edi
     883:	5d                   	pop    %ebp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     884:	e9 47 fb ff ff       	jmp    3d0 <pipecmd>
     889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000890 <parseline>:
{
     890:	55                   	push   %ebp
     891:	89 e5                	mov    %esp,%ebp
     893:	57                   	push   %edi
     894:	56                   	push   %esi
     895:	53                   	push   %ebx
     896:	83 ec 14             	sub    $0x14,%esp
     899:	8b 5d 08             	mov    0x8(%ebp),%ebx
     89c:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parsepipe(ps, es);
     89f:	56                   	push   %esi
     8a0:	53                   	push   %ebx
     8a1:	e8 7a ff ff ff       	call   820 <parsepipe>
  while(peek(ps, es, "&")){
     8a6:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     8a9:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     8ab:	eb 1b                	jmp    8c8 <parseline+0x38>
     8ad:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     8b0:	6a 00                	push   $0x0
     8b2:	6a 00                	push   $0x0
     8b4:	56                   	push   %esi
     8b5:	53                   	push   %ebx
     8b6:	e8 c5 fb ff ff       	call   480 <gettoken>
    cmd = backcmd(cmd);
     8bb:	89 3c 24             	mov    %edi,(%esp)
     8be:	e8 8d fb ff ff       	call   450 <backcmd>
     8c3:	83 c4 10             	add    $0x10,%esp
     8c6:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     8c8:	83 ec 04             	sub    $0x4,%esp
     8cb:	68 7a 12 00 00       	push   $0x127a
     8d0:	56                   	push   %esi
     8d1:	53                   	push   %ebx
     8d2:	e8 09 fd ff ff       	call   5e0 <peek>
     8d7:	83 c4 10             	add    $0x10,%esp
     8da:	85 c0                	test   %eax,%eax
     8dc:	75 d2                	jne    8b0 <parseline+0x20>
  if(peek(ps, es, ";")){
     8de:	83 ec 04             	sub    $0x4,%esp
     8e1:	68 76 12 00 00       	push   $0x1276
     8e6:	56                   	push   %esi
     8e7:	53                   	push   %ebx
     8e8:	e8 f3 fc ff ff       	call   5e0 <peek>
     8ed:	83 c4 10             	add    $0x10,%esp
     8f0:	85 c0                	test   %eax,%eax
     8f2:	75 0c                	jne    900 <parseline+0x70>
}
     8f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8f7:	89 f8                	mov    %edi,%eax
     8f9:	5b                   	pop    %ebx
     8fa:	5e                   	pop    %esi
     8fb:	5f                   	pop    %edi
     8fc:	5d                   	pop    %ebp
     8fd:	c3                   	ret    
     8fe:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     900:	6a 00                	push   $0x0
     902:	6a 00                	push   $0x0
     904:	56                   	push   %esi
     905:	53                   	push   %ebx
     906:	e8 75 fb ff ff       	call   480 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     90b:	58                   	pop    %eax
     90c:	5a                   	pop    %edx
     90d:	56                   	push   %esi
     90e:	53                   	push   %ebx
     90f:	e8 7c ff ff ff       	call   890 <parseline>
     914:	89 7d 08             	mov    %edi,0x8(%ebp)
     917:	83 c4 10             	add    $0x10,%esp
     91a:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     91d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     920:	5b                   	pop    %ebx
     921:	5e                   	pop    %esi
     922:	5f                   	pop    %edi
     923:	5d                   	pop    %ebp
    cmd = listcmd(cmd, parseline(ps, es));
     924:	e9 e7 fa ff ff       	jmp    410 <listcmd>
     929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000930 <parseblock>:
{
     930:	55                   	push   %ebp
     931:	89 e5                	mov    %esp,%ebp
     933:	57                   	push   %edi
     934:	56                   	push   %esi
     935:	53                   	push   %ebx
     936:	83 ec 10             	sub    $0x10,%esp
     939:	8b 5d 08             	mov    0x8(%ebp),%ebx
     93c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     93f:	68 5c 12 00 00       	push   $0x125c
     944:	56                   	push   %esi
     945:	53                   	push   %ebx
     946:	e8 95 fc ff ff       	call   5e0 <peek>
     94b:	83 c4 10             	add    $0x10,%esp
     94e:	85 c0                	test   %eax,%eax
     950:	74 4a                	je     99c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     952:	6a 00                	push   $0x0
     954:	6a 00                	push   $0x0
     956:	56                   	push   %esi
     957:	53                   	push   %ebx
     958:	e8 23 fb ff ff       	call   480 <gettoken>
  cmd = parseline(ps, es);
     95d:	58                   	pop    %eax
     95e:	5a                   	pop    %edx
     95f:	56                   	push   %esi
     960:	53                   	push   %ebx
     961:	e8 2a ff ff ff       	call   890 <parseline>
  if(!peek(ps, es, ")"))
     966:	83 c4 0c             	add    $0xc,%esp
     969:	68 98 12 00 00       	push   $0x1298
  cmd = parseline(ps, es);
     96e:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     970:	56                   	push   %esi
     971:	53                   	push   %ebx
     972:	e8 69 fc ff ff       	call   5e0 <peek>
     977:	83 c4 10             	add    $0x10,%esp
     97a:	85 c0                	test   %eax,%eax
     97c:	74 2b                	je     9a9 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     97e:	6a 00                	push   $0x0
     980:	6a 00                	push   $0x0
     982:	56                   	push   %esi
     983:	53                   	push   %ebx
     984:	e8 f7 fa ff ff       	call   480 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     989:	83 c4 0c             	add    $0xc,%esp
     98c:	56                   	push   %esi
     98d:	53                   	push   %ebx
     98e:	57                   	push   %edi
     98f:	e8 cc fc ff ff       	call   660 <parseredirs>
}
     994:	8d 65 f4             	lea    -0xc(%ebp),%esp
     997:	5b                   	pop    %ebx
     998:	5e                   	pop    %esi
     999:	5f                   	pop    %edi
     99a:	5d                   	pop    %ebp
     99b:	c3                   	ret    
    panic("parseblock");
     99c:	83 ec 0c             	sub    $0xc,%esp
     99f:	68 7c 12 00 00       	push   $0x127c
     9a4:	e8 b7 f7 ff ff       	call   160 <panic>
    panic("syntax - missing )");
     9a9:	83 ec 0c             	sub    $0xc,%esp
     9ac:	68 87 12 00 00       	push   $0x1287
     9b1:	e8 aa f7 ff ff       	call   160 <panic>
     9b6:	8d 76 00             	lea    0x0(%esi),%esi
     9b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009c0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     9c0:	55                   	push   %ebp
     9c1:	89 e5                	mov    %esp,%ebp
     9c3:	53                   	push   %ebx
     9c4:	83 ec 04             	sub    $0x4,%esp
     9c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     9ca:	85 db                	test   %ebx,%ebx
     9cc:	74 20                	je     9ee <nulterminate+0x2e>
    return 0;

  switch(cmd->type){
     9ce:	83 3b 05             	cmpl   $0x5,(%ebx)
     9d1:	77 1b                	ja     9ee <nulterminate+0x2e>
     9d3:	8b 03                	mov    (%ebx),%eax
     9d5:	ff 24 85 d8 12 00 00 	jmp    *0x12d8(,%eax,4)
     9dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
     9e0:	83 ec 0c             	sub    $0xc,%esp
     9e3:	ff 73 04             	pushl  0x4(%ebx)
     9e6:	e8 d5 ff ff ff       	call   9c0 <nulterminate>
    break;
     9eb:	83 c4 10             	add    $0x10,%esp
  }
  return cmd;
}
     9ee:	89 d8                	mov    %ebx,%eax
     9f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     9f3:	c9                   	leave  
     9f4:	c3                   	ret    
     9f5:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(lcmd->left);
     9f8:	83 ec 0c             	sub    $0xc,%esp
     9fb:	ff 73 04             	pushl  0x4(%ebx)
     9fe:	e8 bd ff ff ff       	call   9c0 <nulterminate>
    nulterminate(lcmd->right);
     a03:	58                   	pop    %eax
     a04:	ff 73 08             	pushl  0x8(%ebx)
     a07:	e8 b4 ff ff ff       	call   9c0 <nulterminate>
}
     a0c:	89 d8                	mov    %ebx,%eax
    break;
     a0e:	83 c4 10             	add    $0x10,%esp
}
     a11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a14:	c9                   	leave  
     a15:	c3                   	ret    
     a16:	8d 76 00             	lea    0x0(%esi),%esi
     a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(i=0; ecmd->argv[i]; i++)
     a20:	8b 4b 04             	mov    0x4(%ebx),%ecx
     a23:	8d 43 08             	lea    0x8(%ebx),%eax
     a26:	85 c9                	test   %ecx,%ecx
     a28:	74 c4                	je     9ee <nulterminate+0x2e>
     a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     a30:	8b 50 24             	mov    0x24(%eax),%edx
     a33:	83 c0 04             	add    $0x4,%eax
     a36:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     a39:	8b 50 fc             	mov    -0x4(%eax),%edx
     a3c:	85 d2                	test   %edx,%edx
     a3e:	75 f0                	jne    a30 <nulterminate+0x70>
}
     a40:	89 d8                	mov    %ebx,%eax
     a42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a45:	c9                   	leave  
     a46:	c3                   	ret    
     a47:	89 f6                	mov    %esi,%esi
     a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    nulterminate(rcmd->cmd);
     a50:	83 ec 0c             	sub    $0xc,%esp
     a53:	ff 73 04             	pushl  0x4(%ebx)
     a56:	e8 65 ff ff ff       	call   9c0 <nulterminate>
    *rcmd->efile = 0;
     a5b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     a5e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     a61:	c6 00 00             	movb   $0x0,(%eax)
}
     a64:	89 d8                	mov    %ebx,%eax
     a66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a69:	c9                   	leave  
     a6a:	c3                   	ret    
     a6b:	90                   	nop
     a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a70 <parsecmd>:
{
     a70:	55                   	push   %ebp
     a71:	89 e5                	mov    %esp,%ebp
     a73:	56                   	push   %esi
     a74:	53                   	push   %ebx
  es = s + strlen(s);
     a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a78:	83 ec 0c             	sub    $0xc,%esp
     a7b:	53                   	push   %ebx
     a7c:	e8 df 00 00 00       	call   b60 <strlen>
  cmd = parseline(&s, es);
     a81:	59                   	pop    %ecx
     a82:	5e                   	pop    %esi
  es = s + strlen(s);
     a83:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     a85:	8d 45 08             	lea    0x8(%ebp),%eax
     a88:	53                   	push   %ebx
     a89:	50                   	push   %eax
     a8a:	e8 01 fe ff ff       	call   890 <parseline>
  peek(&s, es, "");
     a8f:	83 c4 0c             	add    $0xc,%esp
  cmd = parseline(&s, es);
     a92:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     a94:	8d 45 08             	lea    0x8(%ebp),%eax
     a97:	68 21 12 00 00       	push   $0x1221
     a9c:	53                   	push   %ebx
     a9d:	50                   	push   %eax
     a9e:	e8 3d fb ff ff       	call   5e0 <peek>
  if(s != es){
     aa3:	8b 45 08             	mov    0x8(%ebp),%eax
     aa6:	83 c4 10             	add    $0x10,%esp
     aa9:	39 d8                	cmp    %ebx,%eax
     aab:	75 12                	jne    abf <parsecmd+0x4f>
  nulterminate(cmd);
     aad:	83 ec 0c             	sub    $0xc,%esp
     ab0:	56                   	push   %esi
     ab1:	e8 0a ff ff ff       	call   9c0 <nulterminate>
}
     ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ab9:	89 f0                	mov    %esi,%eax
     abb:	5b                   	pop    %ebx
     abc:	5e                   	pop    %esi
     abd:	5d                   	pop    %ebp
     abe:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     abf:	52                   	push   %edx
     ac0:	50                   	push   %eax
     ac1:	68 9a 12 00 00       	push   $0x129a
     ac6:	6a 02                	push   $0x2
     ac8:	e8 d3 03 00 00       	call   ea0 <printf>
    panic("syntax");
     acd:	c7 04 24 5e 12 00 00 	movl   $0x125e,(%esp)
     ad4:	e8 87 f6 ff ff       	call   160 <panic>
     ad9:	66 90                	xchg   %ax,%ax
     adb:	66 90                	xchg   %ax,%ax
     add:	66 90                	xchg   %ax,%ax
     adf:	90                   	nop

00000ae0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     ae0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ae1:	31 d2                	xor    %edx,%edx
{
     ae3:	89 e5                	mov    %esp,%ebp
     ae5:	53                   	push   %ebx
     ae6:	8b 45 08             	mov    0x8(%ebp),%eax
     ae9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     af0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
     af4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     af7:	83 c2 01             	add    $0x1,%edx
     afa:	84 c9                	test   %cl,%cl
     afc:	75 f2                	jne    af0 <strcpy+0x10>
    ;
  return os;
}
     afe:	5b                   	pop    %ebx
     aff:	5d                   	pop    %ebp
     b00:	c3                   	ret    
     b01:	eb 0d                	jmp    b10 <strcmp>
     b03:	90                   	nop
     b04:	90                   	nop
     b05:	90                   	nop
     b06:	90                   	nop
     b07:	90                   	nop
     b08:	90                   	nop
     b09:	90                   	nop
     b0a:	90                   	nop
     b0b:	90                   	nop
     b0c:	90                   	nop
     b0d:	90                   	nop
     b0e:	90                   	nop
     b0f:	90                   	nop

00000b10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b10:	55                   	push   %ebp
     b11:	89 e5                	mov    %esp,%ebp
     b13:	56                   	push   %esi
     b14:	53                   	push   %ebx
     b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b18:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
     b1b:	0f b6 13             	movzbl (%ebx),%edx
     b1e:	0f b6 0e             	movzbl (%esi),%ecx
     b21:	84 d2                	test   %dl,%dl
     b23:	74 1e                	je     b43 <strcmp+0x33>
     b25:	b8 01 00 00 00       	mov    $0x1,%eax
     b2a:	38 ca                	cmp    %cl,%dl
     b2c:	74 09                	je     b37 <strcmp+0x27>
     b2e:	eb 20                	jmp    b50 <strcmp+0x40>
     b30:	83 c0 01             	add    $0x1,%eax
     b33:	38 ca                	cmp    %cl,%dl
     b35:	75 19                	jne    b50 <strcmp+0x40>
     b37:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     b3b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
     b3f:	84 d2                	test   %dl,%dl
     b41:	75 ed                	jne    b30 <strcmp+0x20>
     b43:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     b45:	5b                   	pop    %ebx
     b46:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
     b47:	29 c8                	sub    %ecx,%eax
}
     b49:	5d                   	pop    %ebp
     b4a:	c3                   	ret    
     b4b:	90                   	nop
     b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b50:	0f b6 c2             	movzbl %dl,%eax
     b53:	5b                   	pop    %ebx
     b54:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
     b55:	29 c8                	sub    %ecx,%eax
}
     b57:	5d                   	pop    %ebp
     b58:	c3                   	ret    
     b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000b60 <strlen>:

uint
strlen(const char *s)
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     b66:	80 39 00             	cmpb   $0x0,(%ecx)
     b69:	74 15                	je     b80 <strlen+0x20>
     b6b:	31 d2                	xor    %edx,%edx
     b6d:	8d 76 00             	lea    0x0(%esi),%esi
     b70:	83 c2 01             	add    $0x1,%edx
     b73:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     b77:	89 d0                	mov    %edx,%eax
     b79:	75 f5                	jne    b70 <strlen+0x10>
    ;
  return n;
}
     b7b:	5d                   	pop    %ebp
     b7c:	c3                   	ret    
     b7d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
     b80:	31 c0                	xor    %eax,%eax
}
     b82:	5d                   	pop    %ebp
     b83:	c3                   	ret    
     b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000b90 <memset>:

void*
memset(void *dst, int c, uint n)
{
     b90:	55                   	push   %ebp
     b91:	89 e5                	mov    %esp,%ebp
     b93:	57                   	push   %edi
     b94:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     b97:	8b 4d 10             	mov    0x10(%ebp),%ecx
     b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
     b9d:	89 d7                	mov    %edx,%edi
     b9f:	fc                   	cld    
     ba0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     ba2:	89 d0                	mov    %edx,%eax
     ba4:	5f                   	pop    %edi
     ba5:	5d                   	pop    %ebp
     ba6:	c3                   	ret    
     ba7:	89 f6                	mov    %esi,%esi
     ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bb0 <strchr>:

char*
strchr(const char *s, char c)
{
     bb0:	55                   	push   %ebp
     bb1:	89 e5                	mov    %esp,%ebp
     bb3:	53                   	push   %ebx
     bb4:	8b 45 08             	mov    0x8(%ebp),%eax
     bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
     bba:	0f b6 18             	movzbl (%eax),%ebx
     bbd:	84 db                	test   %bl,%bl
     bbf:	74 1d                	je     bde <strchr+0x2e>
     bc1:	89 d1                	mov    %edx,%ecx
    if(*s == c)
     bc3:	38 d3                	cmp    %dl,%bl
     bc5:	75 0d                	jne    bd4 <strchr+0x24>
     bc7:	eb 17                	jmp    be0 <strchr+0x30>
     bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bd0:	38 ca                	cmp    %cl,%dl
     bd2:	74 0c                	je     be0 <strchr+0x30>
  for(; *s; s++)
     bd4:	83 c0 01             	add    $0x1,%eax
     bd7:	0f b6 10             	movzbl (%eax),%edx
     bda:	84 d2                	test   %dl,%dl
     bdc:	75 f2                	jne    bd0 <strchr+0x20>
      return (char*)s;
  return 0;
     bde:	31 c0                	xor    %eax,%eax
}
     be0:	5b                   	pop    %ebx
     be1:	5d                   	pop    %ebp
     be2:	c3                   	ret    
     be3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bf0 <gets>:

char*
gets(char *buf, int max)
{
     bf0:	55                   	push   %ebp
     bf1:	89 e5                	mov    %esp,%ebp
     bf3:	57                   	push   %edi
     bf4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     bf5:	31 f6                	xor    %esi,%esi
{
     bf7:	53                   	push   %ebx
     bf8:	89 f3                	mov    %esi,%ebx
     bfa:	83 ec 1c             	sub    $0x1c,%esp
     bfd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     c00:	eb 2f                	jmp    c31 <gets+0x41>
     c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     c08:	83 ec 04             	sub    $0x4,%esp
     c0b:	8d 45 e7             	lea    -0x19(%ebp),%eax
     c0e:	6a 01                	push   $0x1
     c10:	50                   	push   %eax
     c11:	6a 00                	push   $0x0
     c13:	e8 31 01 00 00       	call   d49 <read>
    if(cc < 1)
     c18:	83 c4 10             	add    $0x10,%esp
     c1b:	85 c0                	test   %eax,%eax
     c1d:	7e 1c                	jle    c3b <gets+0x4b>
      break;
    buf[i++] = c;
     c1f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     c23:	83 c7 01             	add    $0x1,%edi
     c26:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     c29:	3c 0a                	cmp    $0xa,%al
     c2b:	74 23                	je     c50 <gets+0x60>
     c2d:	3c 0d                	cmp    $0xd,%al
     c2f:	74 1f                	je     c50 <gets+0x60>
  for(i=0; i+1 < max; ){
     c31:	83 c3 01             	add    $0x1,%ebx
     c34:	89 fe                	mov    %edi,%esi
     c36:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     c39:	7c cd                	jl     c08 <gets+0x18>
     c3b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     c40:	c6 03 00             	movb   $0x0,(%ebx)
}
     c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c46:	5b                   	pop    %ebx
     c47:	5e                   	pop    %esi
     c48:	5f                   	pop    %edi
     c49:	5d                   	pop    %ebp
     c4a:	c3                   	ret    
     c4b:	90                   	nop
     c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c50:	8b 75 08             	mov    0x8(%ebp),%esi
     c53:	8b 45 08             	mov    0x8(%ebp),%eax
     c56:	01 de                	add    %ebx,%esi
     c58:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     c5a:	c6 03 00             	movb   $0x0,(%ebx)
}
     c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c60:	5b                   	pop    %ebx
     c61:	5e                   	pop    %esi
     c62:	5f                   	pop    %edi
     c63:	5d                   	pop    %ebp
     c64:	c3                   	ret    
     c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c70 <stat>:

int
stat(const char *n, struct stat *st)
{
     c70:	55                   	push   %ebp
     c71:	89 e5                	mov    %esp,%ebp
     c73:	56                   	push   %esi
     c74:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c75:	83 ec 08             	sub    $0x8,%esp
     c78:	6a 00                	push   $0x0
     c7a:	ff 75 08             	pushl  0x8(%ebp)
     c7d:	e8 ef 00 00 00       	call   d71 <open>
  if(fd < 0)
     c82:	83 c4 10             	add    $0x10,%esp
     c85:	85 c0                	test   %eax,%eax
     c87:	78 27                	js     cb0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     c89:	83 ec 08             	sub    $0x8,%esp
     c8c:	ff 75 0c             	pushl  0xc(%ebp)
     c8f:	89 c3                	mov    %eax,%ebx
     c91:	50                   	push   %eax
     c92:	e8 f2 00 00 00       	call   d89 <fstat>
  close(fd);
     c97:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     c9a:	89 c6                	mov    %eax,%esi
  close(fd);
     c9c:	e8 b8 00 00 00       	call   d59 <close>
  return r;
     ca1:	83 c4 10             	add    $0x10,%esp
}
     ca4:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ca7:	89 f0                	mov    %esi,%eax
     ca9:	5b                   	pop    %ebx
     caa:	5e                   	pop    %esi
     cab:	5d                   	pop    %ebp
     cac:	c3                   	ret    
     cad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     cb0:	be ff ff ff ff       	mov    $0xffffffff,%esi
     cb5:	eb ed                	jmp    ca4 <stat+0x34>
     cb7:	89 f6                	mov    %esi,%esi
     cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000cc0 <atoi>:

int
atoi(const char *s)
{
     cc0:	55                   	push   %ebp
     cc1:	89 e5                	mov    %esp,%ebp
     cc3:	53                   	push   %ebx
     cc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cc7:	0f be 11             	movsbl (%ecx),%edx
     cca:	8d 42 d0             	lea    -0x30(%edx),%eax
     ccd:	3c 09                	cmp    $0x9,%al
  n = 0;
     ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
     cd4:	77 1f                	ja     cf5 <atoi+0x35>
     cd6:	8d 76 00             	lea    0x0(%esi),%esi
     cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
     ce0:	83 c1 01             	add    $0x1,%ecx
     ce3:	8d 04 80             	lea    (%eax,%eax,4),%eax
     ce6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     cea:	0f be 11             	movsbl (%ecx),%edx
     ced:	8d 5a d0             	lea    -0x30(%edx),%ebx
     cf0:	80 fb 09             	cmp    $0x9,%bl
     cf3:	76 eb                	jbe    ce0 <atoi+0x20>
  return n;
}
     cf5:	5b                   	pop    %ebx
     cf6:	5d                   	pop    %ebp
     cf7:	c3                   	ret    
     cf8:	90                   	nop
     cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d00 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	57                   	push   %edi
     d04:	8b 55 10             	mov    0x10(%ebp),%edx
     d07:	8b 45 08             	mov    0x8(%ebp),%eax
     d0a:	56                   	push   %esi
     d0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d0e:	85 d2                	test   %edx,%edx
     d10:	7e 13                	jle    d25 <memmove+0x25>
     d12:	01 c2                	add    %eax,%edx
  dst = vdst;
     d14:	89 c7                	mov    %eax,%edi
     d16:	8d 76 00             	lea    0x0(%esi),%esi
     d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    *dst++ = *src++;
     d20:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     d21:	39 fa                	cmp    %edi,%edx
     d23:	75 fb                	jne    d20 <memmove+0x20>
  return vdst;
}
     d25:	5e                   	pop    %esi
     d26:	5f                   	pop    %edi
     d27:	5d                   	pop    %ebp
     d28:	c3                   	ret    

00000d29 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d29:	b8 01 00 00 00       	mov    $0x1,%eax
     d2e:	cd 40                	int    $0x40
     d30:	c3                   	ret    

00000d31 <exit>:
SYSCALL(exit)
     d31:	b8 02 00 00 00       	mov    $0x2,%eax
     d36:	cd 40                	int    $0x40
     d38:	c3                   	ret    

00000d39 <wait>:
SYSCALL(wait)
     d39:	b8 03 00 00 00       	mov    $0x3,%eax
     d3e:	cd 40                	int    $0x40
     d40:	c3                   	ret    

00000d41 <pipe>:
SYSCALL(pipe)
     d41:	b8 04 00 00 00       	mov    $0x4,%eax
     d46:	cd 40                	int    $0x40
     d48:	c3                   	ret    

00000d49 <read>:
SYSCALL(read)
     d49:	b8 05 00 00 00       	mov    $0x5,%eax
     d4e:	cd 40                	int    $0x40
     d50:	c3                   	ret    

00000d51 <write>:
SYSCALL(write)
     d51:	b8 10 00 00 00       	mov    $0x10,%eax
     d56:	cd 40                	int    $0x40
     d58:	c3                   	ret    

00000d59 <close>:
SYSCALL(close)
     d59:	b8 15 00 00 00       	mov    $0x15,%eax
     d5e:	cd 40                	int    $0x40
     d60:	c3                   	ret    

00000d61 <kill>:
SYSCALL(kill)
     d61:	b8 06 00 00 00       	mov    $0x6,%eax
     d66:	cd 40                	int    $0x40
     d68:	c3                   	ret    

00000d69 <exec>:
SYSCALL(exec)
     d69:	b8 07 00 00 00       	mov    $0x7,%eax
     d6e:	cd 40                	int    $0x40
     d70:	c3                   	ret    

00000d71 <open>:
SYSCALL(open)
     d71:	b8 0f 00 00 00       	mov    $0xf,%eax
     d76:	cd 40                	int    $0x40
     d78:	c3                   	ret    

00000d79 <mknod>:
SYSCALL(mknod)
     d79:	b8 11 00 00 00       	mov    $0x11,%eax
     d7e:	cd 40                	int    $0x40
     d80:	c3                   	ret    

00000d81 <unlink>:
SYSCALL(unlink)
     d81:	b8 12 00 00 00       	mov    $0x12,%eax
     d86:	cd 40                	int    $0x40
     d88:	c3                   	ret    

00000d89 <fstat>:
SYSCALL(fstat)
     d89:	b8 08 00 00 00       	mov    $0x8,%eax
     d8e:	cd 40                	int    $0x40
     d90:	c3                   	ret    

00000d91 <link>:
SYSCALL(link)
     d91:	b8 13 00 00 00       	mov    $0x13,%eax
     d96:	cd 40                	int    $0x40
     d98:	c3                   	ret    

00000d99 <mkdir>:
SYSCALL(mkdir)
     d99:	b8 14 00 00 00       	mov    $0x14,%eax
     d9e:	cd 40                	int    $0x40
     da0:	c3                   	ret    

00000da1 <chdir>:
SYSCALL(chdir)
     da1:	b8 09 00 00 00       	mov    $0x9,%eax
     da6:	cd 40                	int    $0x40
     da8:	c3                   	ret    

00000da9 <dup>:
SYSCALL(dup)
     da9:	b8 0a 00 00 00       	mov    $0xa,%eax
     dae:	cd 40                	int    $0x40
     db0:	c3                   	ret    

00000db1 <getpid>:
SYSCALL(getpid)
     db1:	b8 0b 00 00 00       	mov    $0xb,%eax
     db6:	cd 40                	int    $0x40
     db8:	c3                   	ret    

00000db9 <sbrk>:
SYSCALL(sbrk)
     db9:	b8 0c 00 00 00       	mov    $0xc,%eax
     dbe:	cd 40                	int    $0x40
     dc0:	c3                   	ret    

00000dc1 <sleep>:
SYSCALL(sleep)
     dc1:	b8 0d 00 00 00       	mov    $0xd,%eax
     dc6:	cd 40                	int    $0x40
     dc8:	c3                   	ret    

00000dc9 <uptime>:
SYSCALL(uptime)
     dc9:	b8 0e 00 00 00       	mov    $0xe,%eax
     dce:	cd 40                	int    $0x40
     dd0:	c3                   	ret    

00000dd1 <date>:
SYSCALL(date)
     dd1:	b8 16 00 00 00       	mov    $0x16,%eax
     dd6:	cd 40                	int    $0x40
     dd8:	c3                   	ret    
     dd9:	66 90                	xchg   %ax,%ax
     ddb:	66 90                	xchg   %ax,%ax
     ddd:	66 90                	xchg   %ax,%ax
     ddf:	90                   	nop

00000de0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     de0:	55                   	push   %ebp
     de1:	89 e5                	mov    %esp,%ebp
     de3:	57                   	push   %edi
     de4:	56                   	push   %esi
     de5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     de6:	89 d3                	mov    %edx,%ebx
{
     de8:	83 ec 3c             	sub    $0x3c,%esp
     deb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
     dee:	85 d2                	test   %edx,%edx
     df0:	0f 89 92 00 00 00    	jns    e88 <printint+0xa8>
     df6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     dfa:	0f 84 88 00 00 00    	je     e88 <printint+0xa8>
    neg = 1;
     e00:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
     e07:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
     e09:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     e10:	8d 75 d7             	lea    -0x29(%ebp),%esi
     e13:	eb 08                	jmp    e1d <printint+0x3d>
     e15:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     e18:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
     e1b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
     e1d:	89 d8                	mov    %ebx,%eax
     e1f:	31 d2                	xor    %edx,%edx
     e21:	8b 7d c4             	mov    -0x3c(%ebp),%edi
     e24:	f7 f1                	div    %ecx
     e26:	83 c7 01             	add    $0x1,%edi
     e29:	0f b6 92 f8 12 00 00 	movzbl 0x12f8(%edx),%edx
     e30:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
     e33:	39 d9                	cmp    %ebx,%ecx
     e35:	76 e1                	jbe    e18 <printint+0x38>
  if(neg)
     e37:	8b 45 c0             	mov    -0x40(%ebp),%eax
     e3a:	85 c0                	test   %eax,%eax
     e3c:	74 0d                	je     e4b <printint+0x6b>
    buf[i++] = '-';
     e3e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
     e43:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
     e48:	89 7d c4             	mov    %edi,-0x3c(%ebp)

  while(--i >= 0)
     e4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     e4e:	8b 7d bc             	mov    -0x44(%ebp),%edi
     e51:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     e55:	eb 0f                	jmp    e66 <printint+0x86>
     e57:	89 f6                	mov    %esi,%esi
     e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
     e60:	0f b6 13             	movzbl (%ebx),%edx
     e63:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     e66:	83 ec 04             	sub    $0x4,%esp
     e69:	88 55 d7             	mov    %dl,-0x29(%ebp)
     e6c:	6a 01                	push   $0x1
     e6e:	56                   	push   %esi
     e6f:	57                   	push   %edi
     e70:	e8 dc fe ff ff       	call   d51 <write>
  while(--i >= 0)
     e75:	83 c4 10             	add    $0x10,%esp
     e78:	39 de                	cmp    %ebx,%esi
     e7a:	75 e4                	jne    e60 <printint+0x80>
    putc(fd, buf[i]);
}
     e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e7f:	5b                   	pop    %ebx
     e80:	5e                   	pop    %esi
     e81:	5f                   	pop    %edi
     e82:	5d                   	pop    %ebp
     e83:	c3                   	ret    
     e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     e88:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
     e8f:	e9 75 ff ff ff       	jmp    e09 <printint+0x29>
     e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000ea0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     ea0:	55                   	push   %ebp
     ea1:	89 e5                	mov    %esp,%ebp
     ea3:	57                   	push   %edi
     ea4:	56                   	push   %esi
     ea5:	53                   	push   %ebx
     ea6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     ea9:	8b 75 0c             	mov    0xc(%ebp),%esi
     eac:	0f b6 1e             	movzbl (%esi),%ebx
     eaf:	84 db                	test   %bl,%bl
     eb1:	0f 84 b9 00 00 00    	je     f70 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
     eb7:	8d 45 10             	lea    0x10(%ebp),%eax
     eba:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     ebd:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
     ec0:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
     ec2:	89 45 d0             	mov    %eax,-0x30(%ebp)
     ec5:	eb 38                	jmp    eff <printf+0x5f>
     ec7:	89 f6                	mov    %esi,%esi
     ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
     ed0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     ed3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     ed8:	83 f8 25             	cmp    $0x25,%eax
     edb:	74 17                	je     ef4 <printf+0x54>
  write(fd, &c, 1);
     edd:	83 ec 04             	sub    $0x4,%esp
     ee0:	88 5d e7             	mov    %bl,-0x19(%ebp)
     ee3:	6a 01                	push   $0x1
     ee5:	57                   	push   %edi
     ee6:	ff 75 08             	pushl  0x8(%ebp)
     ee9:	e8 63 fe ff ff       	call   d51 <write>
     eee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     ef1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     ef4:	83 c6 01             	add    $0x1,%esi
     ef7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     efb:	84 db                	test   %bl,%bl
     efd:	74 71                	je     f70 <printf+0xd0>
    c = fmt[i] & 0xff;
     eff:	0f be cb             	movsbl %bl,%ecx
     f02:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     f05:	85 d2                	test   %edx,%edx
     f07:	74 c7                	je     ed0 <printf+0x30>
      }
    } else if(state == '%'){
     f09:	83 fa 25             	cmp    $0x25,%edx
     f0c:	75 e6                	jne    ef4 <printf+0x54>
      if(c == 'd'){
     f0e:	83 f8 64             	cmp    $0x64,%eax
     f11:	0f 84 99 00 00 00    	je     fb0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     f17:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     f1d:	83 f9 70             	cmp    $0x70,%ecx
     f20:	74 5e                	je     f80 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     f22:	83 f8 73             	cmp    $0x73,%eax
     f25:	0f 84 d5 00 00 00    	je     1000 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f2b:	83 f8 63             	cmp    $0x63,%eax
     f2e:	0f 84 8c 00 00 00    	je     fc0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     f34:	83 f8 25             	cmp    $0x25,%eax
     f37:	0f 84 b3 00 00 00    	je     ff0 <printf+0x150>
  write(fd, &c, 1);
     f3d:	83 ec 04             	sub    $0x4,%esp
     f40:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     f44:	6a 01                	push   $0x1
     f46:	57                   	push   %edi
     f47:	ff 75 08             	pushl  0x8(%ebp)
     f4a:	e8 02 fe ff ff       	call   d51 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
     f4f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     f52:	83 c4 0c             	add    $0xc,%esp
     f55:	6a 01                	push   $0x1
     f57:	83 c6 01             	add    $0x1,%esi
     f5a:	57                   	push   %edi
     f5b:	ff 75 08             	pushl  0x8(%ebp)
     f5e:	e8 ee fd ff ff       	call   d51 <write>
  for(i = 0; fmt[i]; i++){
     f63:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
     f67:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     f6a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
     f6c:	84 db                	test   %bl,%bl
     f6e:	75 8f                	jne    eff <printf+0x5f>
    }
  }
}
     f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f73:	5b                   	pop    %ebx
     f74:	5e                   	pop    %esi
     f75:	5f                   	pop    %edi
     f76:	5d                   	pop    %ebp
     f77:	c3                   	ret    
     f78:	90                   	nop
     f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
     f80:	83 ec 0c             	sub    $0xc,%esp
     f83:	b9 10 00 00 00       	mov    $0x10,%ecx
     f88:	6a 00                	push   $0x0
     f8a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     f8d:	8b 45 08             	mov    0x8(%ebp),%eax
     f90:	8b 13                	mov    (%ebx),%edx
     f92:	e8 49 fe ff ff       	call   de0 <printint>
        ap++;
     f97:	89 d8                	mov    %ebx,%eax
     f99:	83 c4 10             	add    $0x10,%esp
      state = 0;
     f9c:	31 d2                	xor    %edx,%edx
        ap++;
     f9e:	83 c0 04             	add    $0x4,%eax
     fa1:	89 45 d0             	mov    %eax,-0x30(%ebp)
     fa4:	e9 4b ff ff ff       	jmp    ef4 <printf+0x54>
     fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
     fb0:	83 ec 0c             	sub    $0xc,%esp
     fb3:	b9 0a 00 00 00       	mov    $0xa,%ecx
     fb8:	6a 01                	push   $0x1
     fba:	eb ce                	jmp    f8a <printf+0xea>
     fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
     fc0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
     fc3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
     fc6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
     fc8:	6a 01                	push   $0x1
        ap++;
     fca:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
     fcd:	57                   	push   %edi
     fce:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
     fd1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     fd4:	e8 78 fd ff ff       	call   d51 <write>
        ap++;
     fd9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     fdc:	83 c4 10             	add    $0x10,%esp
      state = 0;
     fdf:	31 d2                	xor    %edx,%edx
     fe1:	e9 0e ff ff ff       	jmp    ef4 <printf+0x54>
     fe6:	8d 76 00             	lea    0x0(%esi),%esi
     fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        putc(fd, c);
     ff0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     ff3:	83 ec 04             	sub    $0x4,%esp
     ff6:	e9 5a ff ff ff       	jmp    f55 <printf+0xb5>
     ffb:	90                   	nop
     ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1000:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1003:	8b 18                	mov    (%eax),%ebx
        ap++;
    1005:	83 c0 04             	add    $0x4,%eax
    1008:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    100b:	85 db                	test   %ebx,%ebx
    100d:	74 17                	je     1026 <printf+0x186>
        while(*s != 0){
    100f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1012:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1014:	84 c0                	test   %al,%al
    1016:	0f 84 d8 fe ff ff    	je     ef4 <printf+0x54>
    101c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    101f:	89 de                	mov    %ebx,%esi
    1021:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1024:	eb 1a                	jmp    1040 <printf+0x1a0>
          s = "(null)";
    1026:	bb f0 12 00 00       	mov    $0x12f0,%ebx
        while(*s != 0){
    102b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    102e:	b8 28 00 00 00       	mov    $0x28,%eax
    1033:	89 de                	mov    %ebx,%esi
    1035:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1038:	90                   	nop
    1039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
    1040:	83 ec 04             	sub    $0x4,%esp
          s++;
    1043:	83 c6 01             	add    $0x1,%esi
    1046:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1049:	6a 01                	push   $0x1
    104b:	57                   	push   %edi
    104c:	53                   	push   %ebx
    104d:	e8 ff fc ff ff       	call   d51 <write>
        while(*s != 0){
    1052:	0f b6 06             	movzbl (%esi),%eax
    1055:	83 c4 10             	add    $0x10,%esp
    1058:	84 c0                	test   %al,%al
    105a:	75 e4                	jne    1040 <printf+0x1a0>
    105c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    105f:	31 d2                	xor    %edx,%edx
    1061:	e9 8e fe ff ff       	jmp    ef4 <printf+0x54>
    1066:	66 90                	xchg   %ax,%ax
    1068:	66 90                	xchg   %ax,%ax
    106a:	66 90                	xchg   %ax,%ax
    106c:	66 90                	xchg   %ax,%ax
    106e:	66 90                	xchg   %ax,%ax

00001070 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1070:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1071:	a1 44 19 00 00       	mov    0x1944,%eax
{
    1076:	89 e5                	mov    %esp,%ebp
    1078:	57                   	push   %edi
    1079:	56                   	push   %esi
    107a:	53                   	push   %ebx
    107b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    107e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1080:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1083:	39 c8                	cmp    %ecx,%eax
    1085:	73 19                	jae    10a0 <free+0x30>
    1087:	89 f6                	mov    %esi,%esi
    1089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    1090:	39 d1                	cmp    %edx,%ecx
    1092:	72 14                	jb     10a8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1094:	39 d0                	cmp    %edx,%eax
    1096:	73 10                	jae    10a8 <free+0x38>
{
    1098:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    109a:	8b 10                	mov    (%eax),%edx
    109c:	39 c8                	cmp    %ecx,%eax
    109e:	72 f0                	jb     1090 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10a0:	39 d0                	cmp    %edx,%eax
    10a2:	72 f4                	jb     1098 <free+0x28>
    10a4:	39 d1                	cmp    %edx,%ecx
    10a6:	73 f0                	jae    1098 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    10a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    10ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    10ae:	39 fa                	cmp    %edi,%edx
    10b0:	74 1e                	je     10d0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    10b2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    10b5:	8b 50 04             	mov    0x4(%eax),%edx
    10b8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    10bb:	39 f1                	cmp    %esi,%ecx
    10bd:	74 28                	je     10e7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    10bf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    10c1:	5b                   	pop    %ebx
  freep = p;
    10c2:	a3 44 19 00 00       	mov    %eax,0x1944
}
    10c7:	5e                   	pop    %esi
    10c8:	5f                   	pop    %edi
    10c9:	5d                   	pop    %ebp
    10ca:	c3                   	ret    
    10cb:	90                   	nop
    10cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    10d0:	03 72 04             	add    0x4(%edx),%esi
    10d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    10d6:	8b 10                	mov    (%eax),%edx
    10d8:	8b 12                	mov    (%edx),%edx
    10da:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    10dd:	8b 50 04             	mov    0x4(%eax),%edx
    10e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    10e3:	39 f1                	cmp    %esi,%ecx
    10e5:	75 d8                	jne    10bf <free+0x4f>
    p->s.size += bp->s.size;
    10e7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    10ea:	a3 44 19 00 00       	mov    %eax,0x1944
    p->s.size += bp->s.size;
    10ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    10f2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    10f5:	89 10                	mov    %edx,(%eax)
}
    10f7:	5b                   	pop    %ebx
    10f8:	5e                   	pop    %esi
    10f9:	5f                   	pop    %edi
    10fa:	5d                   	pop    %ebp
    10fb:	c3                   	ret    
    10fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001100 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	57                   	push   %edi
    1104:	56                   	push   %esi
    1105:	53                   	push   %ebx
    1106:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1109:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    110c:	8b 3d 44 19 00 00    	mov    0x1944,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1112:	8d 70 07             	lea    0x7(%eax),%esi
    1115:	c1 ee 03             	shr    $0x3,%esi
    1118:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    111b:	85 ff                	test   %edi,%edi
    111d:	0f 84 ad 00 00 00    	je     11d0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1123:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    1125:	8b 4a 04             	mov    0x4(%edx),%ecx
    1128:	39 f1                	cmp    %esi,%ecx
    112a:	73 72                	jae    119e <malloc+0x9e>
    112c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    1132:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1137:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    113a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    1141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1144:	eb 1b                	jmp    1161 <malloc+0x61>
    1146:	8d 76 00             	lea    0x0(%esi),%esi
    1149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1150:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1152:	8b 48 04             	mov    0x4(%eax),%ecx
    1155:	39 f1                	cmp    %esi,%ecx
    1157:	73 4f                	jae    11a8 <malloc+0xa8>
    1159:	8b 3d 44 19 00 00    	mov    0x1944,%edi
    115f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1161:	39 d7                	cmp    %edx,%edi
    1163:	75 eb                	jne    1150 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1165:	83 ec 0c             	sub    $0xc,%esp
    1168:	ff 75 e4             	pushl  -0x1c(%ebp)
    116b:	e8 49 fc ff ff       	call   db9 <sbrk>
  if(p == (char*)-1)
    1170:	83 c4 10             	add    $0x10,%esp
    1173:	83 f8 ff             	cmp    $0xffffffff,%eax
    1176:	74 1c                	je     1194 <malloc+0x94>
  hp->s.size = nu;
    1178:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    117b:	83 ec 0c             	sub    $0xc,%esp
    117e:	83 c0 08             	add    $0x8,%eax
    1181:	50                   	push   %eax
    1182:	e8 e9 fe ff ff       	call   1070 <free>
  return freep;
    1187:	8b 15 44 19 00 00    	mov    0x1944,%edx
      if((p = morecore(nunits)) == 0)
    118d:	83 c4 10             	add    $0x10,%esp
    1190:	85 d2                	test   %edx,%edx
    1192:	75 bc                	jne    1150 <malloc+0x50>
        return 0;
  }
}
    1194:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1197:	31 c0                	xor    %eax,%eax
}
    1199:	5b                   	pop    %ebx
    119a:	5e                   	pop    %esi
    119b:	5f                   	pop    %edi
    119c:	5d                   	pop    %ebp
    119d:	c3                   	ret    
    if(p->s.size >= nunits){
    119e:	89 d0                	mov    %edx,%eax
    11a0:	89 fa                	mov    %edi,%edx
    11a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    11a8:	39 ce                	cmp    %ecx,%esi
    11aa:	74 54                	je     1200 <malloc+0x100>
        p->s.size -= nunits;
    11ac:	29 f1                	sub    %esi,%ecx
    11ae:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    11b1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    11b4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    11b7:	89 15 44 19 00 00    	mov    %edx,0x1944
}
    11bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    11c0:	83 c0 08             	add    $0x8,%eax
}
    11c3:	5b                   	pop    %ebx
    11c4:	5e                   	pop    %esi
    11c5:	5f                   	pop    %edi
    11c6:	5d                   	pop    %ebp
    11c7:	c3                   	ret    
    11c8:	90                   	nop
    11c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    11d0:	c7 05 44 19 00 00 48 	movl   $0x1948,0x1944
    11d7:	19 00 00 
    base.s.size = 0;
    11da:	bf 48 19 00 00       	mov    $0x1948,%edi
    base.s.ptr = freep = prevp = &base;
    11df:	c7 05 48 19 00 00 48 	movl   $0x1948,0x1948
    11e6:	19 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11e9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    11eb:	c7 05 4c 19 00 00 00 	movl   $0x0,0x194c
    11f2:	00 00 00 
    if(p->s.size >= nunits){
    11f5:	e9 32 ff ff ff       	jmp    112c <malloc+0x2c>
    11fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1200:	8b 08                	mov    (%eax),%ecx
    1202:	89 0a                	mov    %ecx,(%edx)
    1204:	eb b1                	jmp    11b7 <malloc+0xb7>
