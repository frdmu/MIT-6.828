
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 10 11 00       	mov    $0x111000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 10 11 f0       	mov    $0xf0111000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 56 00 00 00       	call   f0100094 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <test_backtrace>:
#include <kern/console.h>

// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 0c             	sub    $0xc,%esp
f0100047:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("entering test_backtrace %d\n", x);
f010004a:	53                   	push   %ebx
f010004b:	68 e0 1a 10 f0       	push   $0xf0101ae0
f0100050:	e8 b8 09 00 00       	call   f0100a0d <cprintf>
	if (x > 0)
f0100055:	83 c4 10             	add    $0x10,%esp
f0100058:	85 db                	test   %ebx,%ebx
f010005a:	7e 25                	jle    f0100081 <test_backtrace+0x41>
		test_backtrace(x-1);
f010005c:	83 ec 0c             	sub    $0xc,%esp
f010005f:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100062:	50                   	push   %eax
f0100063:	e8 d8 ff ff ff       	call   f0100040 <test_backtrace>
f0100068:	83 c4 10             	add    $0x10,%esp
	else
		mon_backtrace(0, 0, 0);
	cprintf("leaving test_backtrace %d\n", x);
f010006b:	83 ec 08             	sub    $0x8,%esp
f010006e:	53                   	push   %ebx
f010006f:	68 fc 1a 10 f0       	push   $0xf0101afc
f0100074:	e8 94 09 00 00       	call   f0100a0d <cprintf>
}
f0100079:	83 c4 10             	add    $0x10,%esp
f010007c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010007f:	c9                   	leave  
f0100080:	c3                   	ret    
		mon_backtrace(0, 0, 0);
f0100081:	83 ec 04             	sub    $0x4,%esp
f0100084:	6a 00                	push   $0x0
f0100086:	6a 00                	push   $0x0
f0100088:	6a 00                	push   $0x0
f010008a:	e8 95 07 00 00       	call   f0100824 <mon_backtrace>
f010008f:	83 c4 10             	add    $0x10,%esp
f0100092:	eb d7                	jmp    f010006b <test_backtrace+0x2b>

f0100094 <i386_init>:

void
i386_init(void)
{
f0100094:	55                   	push   %ebp
f0100095:	89 e5                	mov    %esp,%ebp
f0100097:	83 ec 1c             	sub    $0x1c,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f010009a:	b8 60 39 11 f0       	mov    $0xf0113960,%eax
f010009f:	2d 20 33 11 f0       	sub    $0xf0113320,%eax
f01000a4:	50                   	push   %eax
f01000a5:	6a 00                	push   $0x0
f01000a7:	68 20 33 11 f0       	push   $0xf0113320
f01000ac:	e8 d6 15 00 00       	call   f0101687 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f01000b1:	e8 3c 05 00 00       	call   f01005f2 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f01000b6:	83 c4 08             	add    $0x8,%esp
f01000b9:	68 ac 1a 00 00       	push   $0x1aac
f01000be:	68 17 1b 10 f0       	push   $0xf0101b17
f01000c3:	e8 45 09 00 00       	call   f0100a0d <cprintf>
	{
		int x = 1, y = 3, z = 4;
	// Lab1_exercise8_3:
		cprintf("x %d, y %d, z %d\n", x, y, z);
f01000c8:	6a 04                	push   $0x4
f01000ca:	6a 03                	push   $0x3
f01000cc:	6a 01                	push   $0x1
f01000ce:	68 32 1b 10 f0       	push   $0xf0101b32
f01000d3:	e8 35 09 00 00       	call   f0100a0d <cprintf>

	// Lab1_exercise8_5:
		cprintf("x=%d, y=%d\n", 3);
f01000d8:	83 c4 18             	add    $0x18,%esp
f01000db:	6a 03                	push   $0x3
f01000dd:	68 44 1b 10 f0       	push   $0xf0101b44
f01000e2:	e8 26 09 00 00       	call   f0100a0d <cprintf>

	// Lab1_challenge:
		cprintf("Printing colored strings: ");
f01000e7:	c7 04 24 50 1b 10 f0 	movl   $0xf0101b50,(%esp)
f01000ee:	e8 1a 09 00 00       	call   f0100a0d <cprintf>
		cprintf("\x1b[31;40mRed ");
f01000f3:	c7 04 24 6b 1b 10 f0 	movl   $0xf0101b6b,(%esp)
f01000fa:	e8 0e 09 00 00       	call   f0100a0d <cprintf>
		cprintf("\x1b[32;40mGreen ");
f01000ff:	c7 04 24 78 1b 10 f0 	movl   $0xf0101b78,(%esp)
f0100106:	e8 02 09 00 00       	call   f0100a0d <cprintf>
		cprintf("\x1b[33;40mYellow ");
f010010b:	c7 04 24 87 1b 10 f0 	movl   $0xf0101b87,(%esp)
f0100112:	e8 f6 08 00 00       	call   f0100a0d <cprintf>
		cprintf("\n");
f0100117:	c7 04 24 21 1c 10 f0 	movl   $0xf0101c21,(%esp)
f010011e:	e8 ea 08 00 00       	call   f0100a0d <cprintf>
		cprintf("With background color: ");
f0100123:	c7 04 24 97 1b 10 f0 	movl   $0xf0101b97,(%esp)
f010012a:	e8 de 08 00 00       	call   f0100a0d <cprintf>
		cprintf("\x1b[31;32mRed ");
f010012f:	c7 04 24 af 1b 10 f0 	movl   $0xf0101baf,(%esp)
f0100136:	e8 d2 08 00 00       	call   f0100a0d <cprintf>
		cprintf("\x1b[32;33mGreen ");
f010013b:	c7 04 24 bc 1b 10 f0 	movl   $0xf0101bbc,(%esp)
f0100142:	e8 c6 08 00 00       	call   f0100a0d <cprintf>
		cprintf("\x1b[33;34mYellow ");
f0100147:	c7 04 24 cb 1b 10 f0 	movl   $0xf0101bcb,(%esp)
f010014e:	e8 ba 08 00 00       	call   f0100a0d <cprintf>
		cprintf("\n");	
f0100153:	c7 04 24 21 1c 10 f0 	movl   $0xf0101c21,(%esp)
f010015a:	e8 ae 08 00 00       	call   f0100a0d <cprintf>
	}
	
	{
		unsigned int i = 0x000a646c;
f010015f:	c7 45 f4 6c 64 0a 00 	movl   $0xa646c,-0xc(%ebp)
		cprintf("H%x Wor%s", 57616, &i);
f0100166:	83 c4 0c             	add    $0xc,%esp
f0100169:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010016c:	50                   	push   %eax
f010016d:	68 10 e1 00 00       	push   $0xe110
f0100172:	68 db 1b 10 f0       	push   $0xf0101bdb
f0100177:	e8 91 08 00 00       	call   f0100a0d <cprintf>
	}	
	
	// Test the stack backtrace function (lab 1 only)	
	test_backtrace(5);
f010017c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f0100183:	e8 b8 fe ff ff       	call   f0100040 <test_backtrace>
f0100188:	83 c4 10             	add    $0x10,%esp

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010018b:	83 ec 0c             	sub    $0xc,%esp
f010018e:	6a 00                	push   $0x0
f0100190:	e8 07 07 00 00       	call   f010089c <monitor>
f0100195:	83 c4 10             	add    $0x10,%esp
f0100198:	eb f1                	jmp    f010018b <i386_init+0xf7>

f010019a <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f010019a:	55                   	push   %ebp
f010019b:	89 e5                	mov    %esp,%ebp
f010019d:	56                   	push   %esi
f010019e:	53                   	push   %ebx
f010019f:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f01001a2:	83 3d 64 39 11 f0 00 	cmpl   $0x0,0xf0113964
f01001a9:	74 0f                	je     f01001ba <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01001ab:	83 ec 0c             	sub    $0xc,%esp
f01001ae:	6a 00                	push   $0x0
f01001b0:	e8 e7 06 00 00       	call   f010089c <monitor>
f01001b5:	83 c4 10             	add    $0x10,%esp
f01001b8:	eb f1                	jmp    f01001ab <_panic+0x11>
	panicstr = fmt;
f01001ba:	89 35 64 39 11 f0    	mov    %esi,0xf0113964
	asm volatile("cli; cld");
f01001c0:	fa                   	cli    
f01001c1:	fc                   	cld    
	va_start(ap, fmt);
f01001c2:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic at %s:%d: ", file, line);
f01001c5:	83 ec 04             	sub    $0x4,%esp
f01001c8:	ff 75 0c             	pushl  0xc(%ebp)
f01001cb:	ff 75 08             	pushl  0x8(%ebp)
f01001ce:	68 e5 1b 10 f0       	push   $0xf0101be5
f01001d3:	e8 35 08 00 00       	call   f0100a0d <cprintf>
	vcprintf(fmt, ap);
f01001d8:	83 c4 08             	add    $0x8,%esp
f01001db:	53                   	push   %ebx
f01001dc:	56                   	push   %esi
f01001dd:	e8 05 08 00 00       	call   f01009e7 <vcprintf>
	cprintf("\n");
f01001e2:	c7 04 24 21 1c 10 f0 	movl   $0xf0101c21,(%esp)
f01001e9:	e8 1f 08 00 00       	call   f0100a0d <cprintf>
f01001ee:	83 c4 10             	add    $0x10,%esp
f01001f1:	eb b8                	jmp    f01001ab <_panic+0x11>

f01001f3 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01001f3:	55                   	push   %ebp
f01001f4:	89 e5                	mov    %esp,%ebp
f01001f6:	53                   	push   %ebx
f01001f7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01001fa:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01001fd:	ff 75 0c             	pushl  0xc(%ebp)
f0100200:	ff 75 08             	pushl  0x8(%ebp)
f0100203:	68 fd 1b 10 f0       	push   $0xf0101bfd
f0100208:	e8 00 08 00 00       	call   f0100a0d <cprintf>
	vcprintf(fmt, ap);
f010020d:	83 c4 08             	add    $0x8,%esp
f0100210:	53                   	push   %ebx
f0100211:	ff 75 10             	pushl  0x10(%ebp)
f0100214:	e8 ce 07 00 00       	call   f01009e7 <vcprintf>
	cprintf("\n");
f0100219:	c7 04 24 21 1c 10 f0 	movl   $0xf0101c21,(%esp)
f0100220:	e8 e8 07 00 00       	call   f0100a0d <cprintf>
	va_end(ap);
}
f0100225:	83 c4 10             	add    $0x10,%esp
f0100228:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010022b:	c9                   	leave  
f010022c:	c3                   	ret    

f010022d <serial_proc_data>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010022d:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100232:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100233:	a8 01                	test   $0x1,%al
f0100235:	74 0a                	je     f0100241 <serial_proc_data+0x14>
f0100237:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010023c:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f010023d:	0f b6 c0             	movzbl %al,%eax
f0100240:	c3                   	ret    
		return -1;
f0100241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100246:	c3                   	ret    

f0100247 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100247:	55                   	push   %ebp
f0100248:	89 e5                	mov    %esp,%ebp
f010024a:	53                   	push   %ebx
f010024b:	83 ec 04             	sub    $0x4,%esp
f010024e:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100250:	ff d3                	call   *%ebx
f0100252:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100255:	74 29                	je     f0100280 <cons_intr+0x39>
		if (c == 0)
f0100257:	85 c0                	test   %eax,%eax
f0100259:	74 f5                	je     f0100250 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f010025b:	8b 0d 44 35 11 f0    	mov    0xf0113544,%ecx
f0100261:	8d 51 01             	lea    0x1(%ecx),%edx
f0100264:	88 81 40 33 11 f0    	mov    %al,-0xfeeccc0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f010026a:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f0100270:	b8 00 00 00 00       	mov    $0x0,%eax
f0100275:	0f 44 d0             	cmove  %eax,%edx
f0100278:	89 15 44 35 11 f0    	mov    %edx,0xf0113544
f010027e:	eb d0                	jmp    f0100250 <cons_intr+0x9>
	}
}
f0100280:	83 c4 04             	add    $0x4,%esp
f0100283:	5b                   	pop    %ebx
f0100284:	5d                   	pop    %ebp
f0100285:	c3                   	ret    

f0100286 <kbd_proc_data>:
{
f0100286:	55                   	push   %ebp
f0100287:	89 e5                	mov    %esp,%ebp
f0100289:	53                   	push   %ebx
f010028a:	83 ec 04             	sub    $0x4,%esp
f010028d:	ba 64 00 00 00       	mov    $0x64,%edx
f0100292:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f0100293:	a8 01                	test   $0x1,%al
f0100295:	0f 84 f2 00 00 00    	je     f010038d <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f010029b:	a8 20                	test   $0x20,%al
f010029d:	0f 85 f1 00 00 00    	jne    f0100394 <kbd_proc_data+0x10e>
f01002a3:	ba 60 00 00 00       	mov    $0x60,%edx
f01002a8:	ec                   	in     (%dx),%al
f01002a9:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002ab:	3c e0                	cmp    $0xe0,%al
f01002ad:	74 61                	je     f0100310 <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f01002af:	84 c0                	test   %al,%al
f01002b1:	78 70                	js     f0100323 <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f01002b3:	8b 0d 20 33 11 f0    	mov    0xf0113320,%ecx
f01002b9:	f6 c1 40             	test   $0x40,%cl
f01002bc:	74 0e                	je     f01002cc <kbd_proc_data+0x46>
		data |= 0x80;
f01002be:	83 c8 80             	or     $0xffffff80,%eax
f01002c1:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01002c3:	83 e1 bf             	and    $0xffffffbf,%ecx
f01002c6:	89 0d 20 33 11 f0    	mov    %ecx,0xf0113320
	shift |= shiftcode[data];
f01002cc:	0f b6 d2             	movzbl %dl,%edx
f01002cf:	0f b6 82 60 1d 10 f0 	movzbl -0xfefe2a0(%edx),%eax
f01002d6:	0b 05 20 33 11 f0    	or     0xf0113320,%eax
	shift ^= togglecode[data];
f01002dc:	0f b6 8a 60 1c 10 f0 	movzbl -0xfefe3a0(%edx),%ecx
f01002e3:	31 c8                	xor    %ecx,%eax
f01002e5:	a3 20 33 11 f0       	mov    %eax,0xf0113320
	c = charcode[shift & (CTL | SHIFT)][data];
f01002ea:	89 c1                	mov    %eax,%ecx
f01002ec:	83 e1 03             	and    $0x3,%ecx
f01002ef:	8b 0c 8d 40 1c 10 f0 	mov    -0xfefe3c0(,%ecx,4),%ecx
f01002f6:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f01002fa:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f01002fd:	a8 08                	test   $0x8,%al
f01002ff:	74 61                	je     f0100362 <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f0100301:	89 da                	mov    %ebx,%edx
f0100303:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100306:	83 f9 19             	cmp    $0x19,%ecx
f0100309:	77 4b                	ja     f0100356 <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f010030b:	83 eb 20             	sub    $0x20,%ebx
f010030e:	eb 0c                	jmp    f010031c <kbd_proc_data+0x96>
		shift |= E0ESC;
f0100310:	83 0d 20 33 11 f0 40 	orl    $0x40,0xf0113320
		return 0;
f0100317:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010031c:	89 d8                	mov    %ebx,%eax
f010031e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100321:	c9                   	leave  
f0100322:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100323:	8b 0d 20 33 11 f0    	mov    0xf0113320,%ecx
f0100329:	89 cb                	mov    %ecx,%ebx
f010032b:	83 e3 40             	and    $0x40,%ebx
f010032e:	83 e0 7f             	and    $0x7f,%eax
f0100331:	85 db                	test   %ebx,%ebx
f0100333:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100336:	0f b6 d2             	movzbl %dl,%edx
f0100339:	0f b6 82 60 1d 10 f0 	movzbl -0xfefe2a0(%edx),%eax
f0100340:	83 c8 40             	or     $0x40,%eax
f0100343:	0f b6 c0             	movzbl %al,%eax
f0100346:	f7 d0                	not    %eax
f0100348:	21 c8                	and    %ecx,%eax
f010034a:	a3 20 33 11 f0       	mov    %eax,0xf0113320
		return 0;
f010034f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100354:	eb c6                	jmp    f010031c <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f0100356:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100359:	8d 4b 20             	lea    0x20(%ebx),%ecx
f010035c:	83 fa 1a             	cmp    $0x1a,%edx
f010035f:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100362:	f7 d0                	not    %eax
f0100364:	a8 06                	test   $0x6,%al
f0100366:	75 b4                	jne    f010031c <kbd_proc_data+0x96>
f0100368:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010036e:	75 ac                	jne    f010031c <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f0100370:	83 ec 0c             	sub    $0xc,%esp
f0100373:	68 17 1c 10 f0       	push   $0xf0101c17
f0100378:	e8 90 06 00 00       	call   f0100a0d <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010037d:	b8 03 00 00 00       	mov    $0x3,%eax
f0100382:	ba 92 00 00 00       	mov    $0x92,%edx
f0100387:	ee                   	out    %al,(%dx)
f0100388:	83 c4 10             	add    $0x10,%esp
f010038b:	eb 8f                	jmp    f010031c <kbd_proc_data+0x96>
		return -1;
f010038d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100392:	eb 88                	jmp    f010031c <kbd_proc_data+0x96>
		return -1;
f0100394:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100399:	eb 81                	jmp    f010031c <kbd_proc_data+0x96>

f010039b <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f010039b:	55                   	push   %ebp
f010039c:	89 e5                	mov    %esp,%ebp
f010039e:	57                   	push   %edi
f010039f:	56                   	push   %esi
f01003a0:	53                   	push   %ebx
f01003a1:	83 ec 0c             	sub    $0xc,%esp
f01003a4:	89 c3                	mov    %eax,%ebx
	for (i = 0;
f01003a6:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003ab:	bf fd 03 00 00       	mov    $0x3fd,%edi
f01003b0:	b9 84 00 00 00       	mov    $0x84,%ecx
f01003b5:	89 fa                	mov    %edi,%edx
f01003b7:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01003b8:	a8 20                	test   $0x20,%al
f01003ba:	75 13                	jne    f01003cf <cons_putc+0x34>
f01003bc:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01003c2:	7f 0b                	jg     f01003cf <cons_putc+0x34>
f01003c4:	89 ca                	mov    %ecx,%edx
f01003c6:	ec                   	in     (%dx),%al
f01003c7:	ec                   	in     (%dx),%al
f01003c8:	ec                   	in     (%dx),%al
f01003c9:	ec                   	in     (%dx),%al
	     i++)
f01003ca:	83 c6 01             	add    $0x1,%esi
f01003cd:	eb e6                	jmp    f01003b5 <cons_putc+0x1a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003cf:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01003d4:	89 d8                	mov    %ebx,%eax
f01003d6:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003d7:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003dc:	bf 79 03 00 00       	mov    $0x379,%edi
f01003e1:	b9 84 00 00 00       	mov    $0x84,%ecx
f01003e6:	89 fa                	mov    %edi,%edx
f01003e8:	ec                   	in     (%dx),%al
f01003e9:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01003ef:	7f 0f                	jg     f0100400 <cons_putc+0x65>
f01003f1:	84 c0                	test   %al,%al
f01003f3:	78 0b                	js     f0100400 <cons_putc+0x65>
f01003f5:	89 ca                	mov    %ecx,%edx
f01003f7:	ec                   	in     (%dx),%al
f01003f8:	ec                   	in     (%dx),%al
f01003f9:	ec                   	in     (%dx),%al
f01003fa:	ec                   	in     (%dx),%al
f01003fb:	83 c6 01             	add    $0x1,%esi
f01003fe:	eb e6                	jmp    f01003e6 <cons_putc+0x4b>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100400:	ba 78 03 00 00       	mov    $0x378,%edx
f0100405:	89 d8                	mov    %ebx,%eax
f0100407:	ee                   	out    %al,(%dx)
f0100408:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010040d:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100412:	ee                   	out    %al,(%dx)
f0100413:	b8 08 00 00 00       	mov    $0x8,%eax
f0100418:	ee                   	out    %al,(%dx)
	c |= color_flag;
f0100419:	0f b7 05 00 33 11 f0 	movzwl 0xf0113300,%eax
f0100420:	09 d8                	or     %ebx,%eax
	switch (c & 0xff) {
f0100422:	0f b6 d0             	movzbl %al,%edx
f0100425:	83 fa 09             	cmp    $0x9,%edx
f0100428:	0f 84 b1 00 00 00    	je     f01004df <cons_putc+0x144>
f010042e:	7e 73                	jle    f01004a3 <cons_putc+0x108>
f0100430:	83 fa 0a             	cmp    $0xa,%edx
f0100433:	0f 84 99 00 00 00    	je     f01004d2 <cons_putc+0x137>
f0100439:	83 fa 0d             	cmp    $0xd,%edx
f010043c:	0f 85 d4 00 00 00    	jne    f0100516 <cons_putc+0x17b>
		crt_pos -= (crt_pos % CRT_COLS);
f0100442:	0f b7 05 48 35 11 f0 	movzwl 0xf0113548,%eax
f0100449:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010044f:	c1 e8 16             	shr    $0x16,%eax
f0100452:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100455:	c1 e0 04             	shl    $0x4,%eax
f0100458:	66 a3 48 35 11 f0    	mov    %ax,0xf0113548
	if (crt_pos >= CRT_SIZE) {
f010045e:	66 81 3d 48 35 11 f0 	cmpw   $0x7cf,0xf0113548
f0100465:	cf 07 
f0100467:	0f 87 cc 00 00 00    	ja     f0100539 <cons_putc+0x19e>
	outb(addr_6845, 14);
f010046d:	8b 0d 50 35 11 f0    	mov    0xf0113550,%ecx
f0100473:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100478:	89 ca                	mov    %ecx,%edx
f010047a:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010047b:	0f b7 1d 48 35 11 f0 	movzwl 0xf0113548,%ebx
f0100482:	8d 71 01             	lea    0x1(%ecx),%esi
f0100485:	89 d8                	mov    %ebx,%eax
f0100487:	66 c1 e8 08          	shr    $0x8,%ax
f010048b:	89 f2                	mov    %esi,%edx
f010048d:	ee                   	out    %al,(%dx)
f010048e:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100493:	89 ca                	mov    %ecx,%edx
f0100495:	ee                   	out    %al,(%dx)
f0100496:	89 d8                	mov    %ebx,%eax
f0100498:	89 f2                	mov    %esi,%edx
f010049a:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010049b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010049e:	5b                   	pop    %ebx
f010049f:	5e                   	pop    %esi
f01004a0:	5f                   	pop    %edi
f01004a1:	5d                   	pop    %ebp
f01004a2:	c3                   	ret    
	switch (c & 0xff) {
f01004a3:	83 fa 08             	cmp    $0x8,%edx
f01004a6:	75 6e                	jne    f0100516 <cons_putc+0x17b>
		if (crt_pos > 0) {
f01004a8:	0f b7 15 48 35 11 f0 	movzwl 0xf0113548,%edx
f01004af:	66 85 d2             	test   %dx,%dx
f01004b2:	74 b9                	je     f010046d <cons_putc+0xd2>
			crt_pos--;
f01004b4:	83 ea 01             	sub    $0x1,%edx
f01004b7:	66 89 15 48 35 11 f0 	mov    %dx,0xf0113548
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01004be:	0f b7 d2             	movzwl %dx,%edx
f01004c1:	b0 00                	mov    $0x0,%al
f01004c3:	83 c8 20             	or     $0x20,%eax
f01004c6:	8b 0d 4c 35 11 f0    	mov    0xf011354c,%ecx
f01004cc:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
f01004d0:	eb 8c                	jmp    f010045e <cons_putc+0xc3>
		crt_pos += CRT_COLS;
f01004d2:	66 83 05 48 35 11 f0 	addw   $0x50,0xf0113548
f01004d9:	50 
f01004da:	e9 63 ff ff ff       	jmp    f0100442 <cons_putc+0xa7>
		cons_putc(' ');
f01004df:	b8 20 00 00 00       	mov    $0x20,%eax
f01004e4:	e8 b2 fe ff ff       	call   f010039b <cons_putc>
		cons_putc(' ');
f01004e9:	b8 20 00 00 00       	mov    $0x20,%eax
f01004ee:	e8 a8 fe ff ff       	call   f010039b <cons_putc>
		cons_putc(' ');
f01004f3:	b8 20 00 00 00       	mov    $0x20,%eax
f01004f8:	e8 9e fe ff ff       	call   f010039b <cons_putc>
		cons_putc(' ');
f01004fd:	b8 20 00 00 00       	mov    $0x20,%eax
f0100502:	e8 94 fe ff ff       	call   f010039b <cons_putc>
		cons_putc(' ');
f0100507:	b8 20 00 00 00       	mov    $0x20,%eax
f010050c:	e8 8a fe ff ff       	call   f010039b <cons_putc>
f0100511:	e9 48 ff ff ff       	jmp    f010045e <cons_putc+0xc3>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100516:	0f b7 15 48 35 11 f0 	movzwl 0xf0113548,%edx
f010051d:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100520:	66 89 0d 48 35 11 f0 	mov    %cx,0xf0113548
f0100527:	0f b7 d2             	movzwl %dx,%edx
f010052a:	8b 0d 4c 35 11 f0    	mov    0xf011354c,%ecx
f0100530:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
f0100534:	e9 25 ff ff ff       	jmp    f010045e <cons_putc+0xc3>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100539:	a1 4c 35 11 f0       	mov    0xf011354c,%eax
f010053e:	83 ec 04             	sub    $0x4,%esp
f0100541:	68 00 0f 00 00       	push   $0xf00
f0100546:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f010054c:	52                   	push   %edx
f010054d:	50                   	push   %eax
f010054e:	e8 7c 11 00 00       	call   f01016cf <memmove>
			crt_buf[i] = 0x0700 | ' ';
f0100553:	8b 15 4c 35 11 f0    	mov    0xf011354c,%edx
f0100559:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f010055f:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0100565:	83 c4 10             	add    $0x10,%esp
f0100568:	66 c7 00 20 07       	movw   $0x720,(%eax)
f010056d:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100570:	39 d0                	cmp    %edx,%eax
f0100572:	75 f4                	jne    f0100568 <cons_putc+0x1cd>
		crt_pos -= CRT_COLS;
f0100574:	66 83 2d 48 35 11 f0 	subw   $0x50,0xf0113548
f010057b:	50 
f010057c:	e9 ec fe ff ff       	jmp    f010046d <cons_putc+0xd2>

f0100581 <serial_intr>:
	if (serial_exists)
f0100581:	80 3d 54 35 11 f0 00 	cmpb   $0x0,0xf0113554
f0100588:	75 01                	jne    f010058b <serial_intr+0xa>
f010058a:	c3                   	ret    
{
f010058b:	55                   	push   %ebp
f010058c:	89 e5                	mov    %esp,%ebp
f010058e:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100591:	b8 2d 02 10 f0       	mov    $0xf010022d,%eax
f0100596:	e8 ac fc ff ff       	call   f0100247 <cons_intr>
}
f010059b:	c9                   	leave  
f010059c:	c3                   	ret    

f010059d <kbd_intr>:
{
f010059d:	55                   	push   %ebp
f010059e:	89 e5                	mov    %esp,%ebp
f01005a0:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01005a3:	b8 86 02 10 f0       	mov    $0xf0100286,%eax
f01005a8:	e8 9a fc ff ff       	call   f0100247 <cons_intr>
}
f01005ad:	c9                   	leave  
f01005ae:	c3                   	ret    

f01005af <cons_getc>:
{
f01005af:	55                   	push   %ebp
f01005b0:	89 e5                	mov    %esp,%ebp
f01005b2:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01005b5:	e8 c7 ff ff ff       	call   f0100581 <serial_intr>
	kbd_intr();
f01005ba:	e8 de ff ff ff       	call   f010059d <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01005bf:	8b 15 40 35 11 f0    	mov    0xf0113540,%edx
	return 0;
f01005c5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f01005ca:	3b 15 44 35 11 f0    	cmp    0xf0113544,%edx
f01005d0:	74 1e                	je     f01005f0 <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f01005d2:	8d 4a 01             	lea    0x1(%edx),%ecx
f01005d5:	0f b6 82 40 33 11 f0 	movzbl -0xfeeccc0(%edx),%eax
			cons.rpos = 0;
f01005dc:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f01005e2:	ba 00 00 00 00       	mov    $0x0,%edx
f01005e7:	0f 44 ca             	cmove  %edx,%ecx
f01005ea:	89 0d 40 35 11 f0    	mov    %ecx,0xf0113540
}
f01005f0:	c9                   	leave  
f01005f1:	c3                   	ret    

f01005f2 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01005f2:	55                   	push   %ebp
f01005f3:	89 e5                	mov    %esp,%ebp
f01005f5:	57                   	push   %edi
f01005f6:	56                   	push   %esi
f01005f7:	53                   	push   %ebx
f01005f8:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f01005fb:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f0100602:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100609:	5a a5 
	if (*cp != 0xA55A) {
f010060b:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100612:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100616:	0f 84 b7 00 00 00    	je     f01006d3 <cons_init+0xe1>
		addr_6845 = MONO_BASE;
f010061c:	c7 05 50 35 11 f0 b4 	movl   $0x3b4,0xf0113550
f0100623:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100626:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f010062b:	8b 3d 50 35 11 f0    	mov    0xf0113550,%edi
f0100631:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100636:	89 fa                	mov    %edi,%edx
f0100638:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100639:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010063c:	89 ca                	mov    %ecx,%edx
f010063e:	ec                   	in     (%dx),%al
f010063f:	0f b6 c0             	movzbl %al,%eax
f0100642:	c1 e0 08             	shl    $0x8,%eax
f0100645:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100647:	b8 0f 00 00 00       	mov    $0xf,%eax
f010064c:	89 fa                	mov    %edi,%edx
f010064e:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010064f:	89 ca                	mov    %ecx,%edx
f0100651:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f0100652:	89 35 4c 35 11 f0    	mov    %esi,0xf011354c
	pos |= inb(addr_6845 + 1);
f0100658:	0f b6 c0             	movzbl %al,%eax
f010065b:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f010065d:	66 a3 48 35 11 f0    	mov    %ax,0xf0113548
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100663:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100668:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f010066d:	89 d8                	mov    %ebx,%eax
f010066f:	89 ca                	mov    %ecx,%edx
f0100671:	ee                   	out    %al,(%dx)
f0100672:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100677:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010067c:	89 fa                	mov    %edi,%edx
f010067e:	ee                   	out    %al,(%dx)
f010067f:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100684:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100689:	ee                   	out    %al,(%dx)
f010068a:	be f9 03 00 00       	mov    $0x3f9,%esi
f010068f:	89 d8                	mov    %ebx,%eax
f0100691:	89 f2                	mov    %esi,%edx
f0100693:	ee                   	out    %al,(%dx)
f0100694:	b8 03 00 00 00       	mov    $0x3,%eax
f0100699:	89 fa                	mov    %edi,%edx
f010069b:	ee                   	out    %al,(%dx)
f010069c:	ba fc 03 00 00       	mov    $0x3fc,%edx
f01006a1:	89 d8                	mov    %ebx,%eax
f01006a3:	ee                   	out    %al,(%dx)
f01006a4:	b8 01 00 00 00       	mov    $0x1,%eax
f01006a9:	89 f2                	mov    %esi,%edx
f01006ab:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006ac:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01006b1:	ec                   	in     (%dx),%al
f01006b2:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01006b4:	3c ff                	cmp    $0xff,%al
f01006b6:	0f 95 05 54 35 11 f0 	setne  0xf0113554
f01006bd:	89 ca                	mov    %ecx,%edx
f01006bf:	ec                   	in     (%dx),%al
f01006c0:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006c5:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01006c6:	80 fb ff             	cmp    $0xff,%bl
f01006c9:	74 23                	je     f01006ee <cons_init+0xfc>
		cprintf("Serial port does not exist!\n");
}
f01006cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01006ce:	5b                   	pop    %ebx
f01006cf:	5e                   	pop    %esi
f01006d0:	5f                   	pop    %edi
f01006d1:	5d                   	pop    %ebp
f01006d2:	c3                   	ret    
		*cp = was;
f01006d3:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01006da:	c7 05 50 35 11 f0 d4 	movl   $0x3d4,0xf0113550
f01006e1:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01006e4:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f01006e9:	e9 3d ff ff ff       	jmp    f010062b <cons_init+0x39>
		cprintf("Serial port does not exist!\n");
f01006ee:	83 ec 0c             	sub    $0xc,%esp
f01006f1:	68 23 1c 10 f0       	push   $0xf0101c23
f01006f6:	e8 12 03 00 00       	call   f0100a0d <cprintf>
f01006fb:	83 c4 10             	add    $0x10,%esp
}
f01006fe:	eb cb                	jmp    f01006cb <cons_init+0xd9>

f0100700 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100700:	55                   	push   %ebp
f0100701:	89 e5                	mov    %esp,%ebp
f0100703:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100706:	8b 45 08             	mov    0x8(%ebp),%eax
f0100709:	e8 8d fc ff ff       	call   f010039b <cons_putc>
}
f010070e:	c9                   	leave  
f010070f:	c3                   	ret    

f0100710 <getchar>:

int
getchar(void)
{
f0100710:	55                   	push   %ebp
f0100711:	89 e5                	mov    %esp,%ebp
f0100713:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100716:	e8 94 fe ff ff       	call   f01005af <cons_getc>
f010071b:	85 c0                	test   %eax,%eax
f010071d:	74 f7                	je     f0100716 <getchar+0x6>
		/* do nothing */;
	return c;
}
f010071f:	c9                   	leave  
f0100720:	c3                   	ret    

f0100721 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f0100721:	b8 01 00 00 00       	mov    $0x1,%eax
f0100726:	c3                   	ret    

f0100727 <set_color_info>:

void
set_color_info(uint16_t new_color)
{
f0100727:	55                   	push   %ebp
f0100728:	89 e5                	mov    %esp,%ebp
	color_flag = new_color;
f010072a:	8b 45 08             	mov    0x8(%ebp),%eax
f010072d:	66 a3 00 33 11 f0    	mov    %ax,0xf0113300
}
f0100733:	5d                   	pop    %ebp
f0100734:	c3                   	ret    

f0100735 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100735:	55                   	push   %ebp
f0100736:	89 e5                	mov    %esp,%ebp
f0100738:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010073b:	68 60 1e 10 f0       	push   $0xf0101e60
f0100740:	68 7e 1e 10 f0       	push   $0xf0101e7e
f0100745:	68 83 1e 10 f0       	push   $0xf0101e83
f010074a:	e8 be 02 00 00       	call   f0100a0d <cprintf>
f010074f:	83 c4 0c             	add    $0xc,%esp
f0100752:	68 18 1f 10 f0       	push   $0xf0101f18
f0100757:	68 8c 1e 10 f0       	push   $0xf0101e8c
f010075c:	68 83 1e 10 f0       	push   $0xf0101e83
f0100761:	e8 a7 02 00 00       	call   f0100a0d <cprintf>
f0100766:	83 c4 0c             	add    $0xc,%esp
f0100769:	68 40 1f 10 f0       	push   $0xf0101f40
f010076e:	68 95 1e 10 f0       	push   $0xf0101e95
f0100773:	68 83 1e 10 f0       	push   $0xf0101e83
f0100778:	e8 90 02 00 00       	call   f0100a0d <cprintf>
	return 0;
}
f010077d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100782:	c9                   	leave  
f0100783:	c3                   	ret    

f0100784 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100784:	55                   	push   %ebp
f0100785:	89 e5                	mov    %esp,%ebp
f0100787:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010078a:	68 9f 1e 10 f0       	push   $0xf0101e9f
f010078f:	e8 79 02 00 00       	call   f0100a0d <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100794:	83 c4 08             	add    $0x8,%esp
f0100797:	68 0c 00 10 00       	push   $0x10000c
f010079c:	68 60 1f 10 f0       	push   $0xf0101f60
f01007a1:	e8 67 02 00 00       	call   f0100a0d <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01007a6:	83 c4 0c             	add    $0xc,%esp
f01007a9:	68 0c 00 10 00       	push   $0x10000c
f01007ae:	68 0c 00 10 f0       	push   $0xf010000c
f01007b3:	68 88 1f 10 f0       	push   $0xf0101f88
f01007b8:	e8 50 02 00 00       	call   f0100a0d <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01007bd:	83 c4 0c             	add    $0xc,%esp
f01007c0:	68 cf 1a 10 00       	push   $0x101acf
f01007c5:	68 cf 1a 10 f0       	push   $0xf0101acf
f01007ca:	68 ac 1f 10 f0       	push   $0xf0101fac
f01007cf:	e8 39 02 00 00       	call   f0100a0d <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01007d4:	83 c4 0c             	add    $0xc,%esp
f01007d7:	68 20 33 11 00       	push   $0x113320
f01007dc:	68 20 33 11 f0       	push   $0xf0113320
f01007e1:	68 d0 1f 10 f0       	push   $0xf0101fd0
f01007e6:	e8 22 02 00 00       	call   f0100a0d <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01007eb:	83 c4 0c             	add    $0xc,%esp
f01007ee:	68 60 39 11 00       	push   $0x113960
f01007f3:	68 60 39 11 f0       	push   $0xf0113960
f01007f8:	68 f4 1f 10 f0       	push   $0xf0101ff4
f01007fd:	e8 0b 02 00 00       	call   f0100a0d <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100802:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100805:	b8 60 39 11 f0       	mov    $0xf0113960,%eax
f010080a:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f010080f:	c1 f8 0a             	sar    $0xa,%eax
f0100812:	50                   	push   %eax
f0100813:	68 18 20 10 f0       	push   $0xf0102018
f0100818:	e8 f0 01 00 00       	call   f0100a0d <cprintf>
	return 0;
}
f010081d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100822:	c9                   	leave  
f0100823:	c3                   	ret    

f0100824 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100824:	55                   	push   %ebp
f0100825:	89 e5                	mov    %esp,%ebp
f0100827:	57                   	push   %edi
f0100828:	56                   	push   %esi
f0100829:	53                   	push   %ebx
f010082a:	83 ec 38             	sub    $0x38,%esp
	// Your code here.
	cprintf("Stack backtrace:\n");
f010082d:	68 b8 1e 10 f0       	push   $0xf0101eb8
f0100832:	e8 d6 01 00 00       	call   f0100a0d <cprintf>

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100837:	89 eb                	mov    %ebp,%ebx
	
	uint32_t ebp = read_ebp();
	uint32_t *p, eip;	
	while (ebp != 0) {
f0100839:	83 c4 10             	add    $0x10,%esp
		p = (uint32_t *)ebp;	
		eip = p[1];
		cprintf("ebp %x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, p[2], p[3], p[4], p[5], p[6]);
		
		struct Eipdebuginfo info;
		int ret = debuginfo_eip(eip, &info);
f010083c:	8d 7d d0             	lea    -0x30(%ebp),%edi
	while (ebp != 0) {
f010083f:	85 db                	test   %ebx,%ebx
f0100841:	74 4c                	je     f010088f <mon_backtrace+0x6b>
		eip = p[1];
f0100843:	8b 73 04             	mov    0x4(%ebx),%esi
		cprintf("ebp %x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, p[2], p[3], p[4], p[5], p[6]);
f0100846:	ff 73 18             	pushl  0x18(%ebx)
f0100849:	ff 73 14             	pushl  0x14(%ebx)
f010084c:	ff 73 10             	pushl  0x10(%ebx)
f010084f:	ff 73 0c             	pushl  0xc(%ebx)
f0100852:	ff 73 08             	pushl  0x8(%ebx)
f0100855:	56                   	push   %esi
f0100856:	53                   	push   %ebx
f0100857:	68 44 20 10 f0       	push   $0xf0102044
f010085c:	e8 ac 01 00 00       	call   f0100a0d <cprintf>
		int ret = debuginfo_eip(eip, &info);
f0100861:	83 c4 18             	add    $0x18,%esp
f0100864:	57                   	push   %edi
f0100865:	56                   	push   %esi
f0100866:	e8 a6 02 00 00       	call   f0100b11 <debuginfo_eip>
		cprintf("%s:%d: %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, eip - info.eip_fn_addr);
f010086b:	83 c4 08             	add    $0x8,%esp
f010086e:	2b 75 e0             	sub    -0x20(%ebp),%esi
f0100871:	56                   	push   %esi
f0100872:	ff 75 d8             	pushl  -0x28(%ebp)
f0100875:	ff 75 dc             	pushl  -0x24(%ebp)
f0100878:	ff 75 d4             	pushl  -0x2c(%ebp)
f010087b:	ff 75 d0             	pushl  -0x30(%ebp)
f010087e:	68 ca 1e 10 f0       	push   $0xf0101eca
f0100883:	e8 85 01 00 00       	call   f0100a0d <cprintf>
		ebp = p[0];
f0100888:	8b 1b                	mov    (%ebx),%ebx
f010088a:	83 c4 20             	add    $0x20,%esp
f010088d:	eb b0                	jmp    f010083f <mon_backtrace+0x1b>
	}
		
	return 0;
	
}
f010088f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100894:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100897:	5b                   	pop    %ebx
f0100898:	5e                   	pop    %esi
f0100899:	5f                   	pop    %edi
f010089a:	5d                   	pop    %ebp
f010089b:	c3                   	ret    

f010089c <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f010089c:	55                   	push   %ebp
f010089d:	89 e5                	mov    %esp,%ebp
f010089f:	57                   	push   %edi
f01008a0:	56                   	push   %esi
f01008a1:	53                   	push   %ebx
f01008a2:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01008a5:	68 78 20 10 f0       	push   $0xf0102078
f01008aa:	e8 5e 01 00 00       	call   f0100a0d <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01008af:	c7 04 24 9c 20 10 f0 	movl   $0xf010209c,(%esp)
f01008b6:	e8 52 01 00 00       	call   f0100a0d <cprintf>
f01008bb:	83 c4 10             	add    $0x10,%esp
f01008be:	e9 c6 00 00 00       	jmp    f0100989 <monitor+0xed>
		while (*buf && strchr(WHITESPACE, *buf))
f01008c3:	83 ec 08             	sub    $0x8,%esp
f01008c6:	0f be c0             	movsbl %al,%eax
f01008c9:	50                   	push   %eax
f01008ca:	68 de 1e 10 f0       	push   $0xf0101ede
f01008cf:	e8 76 0d 00 00       	call   f010164a <strchr>
f01008d4:	83 c4 10             	add    $0x10,%esp
f01008d7:	85 c0                	test   %eax,%eax
f01008d9:	74 63                	je     f010093e <monitor+0xa2>
			*buf++ = 0;
f01008db:	c6 03 00             	movb   $0x0,(%ebx)
f01008de:	89 f7                	mov    %esi,%edi
f01008e0:	8d 5b 01             	lea    0x1(%ebx),%ebx
f01008e3:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01008e5:	0f b6 03             	movzbl (%ebx),%eax
f01008e8:	84 c0                	test   %al,%al
f01008ea:	75 d7                	jne    f01008c3 <monitor+0x27>
	argv[argc] = 0;
f01008ec:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01008f3:	00 
	if (argc == 0)
f01008f4:	85 f6                	test   %esi,%esi
f01008f6:	0f 84 8d 00 00 00    	je     f0100989 <monitor+0xed>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01008fc:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100901:	83 ec 08             	sub    $0x8,%esp
f0100904:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100907:	ff 34 85 e0 20 10 f0 	pushl  -0xfefdf20(,%eax,4)
f010090e:	ff 75 a8             	pushl  -0x58(%ebp)
f0100911:	e8 d6 0c 00 00       	call   f01015ec <strcmp>
f0100916:	83 c4 10             	add    $0x10,%esp
f0100919:	85 c0                	test   %eax,%eax
f010091b:	0f 84 8f 00 00 00    	je     f01009b0 <monitor+0x114>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100921:	83 c3 01             	add    $0x1,%ebx
f0100924:	83 fb 03             	cmp    $0x3,%ebx
f0100927:	75 d8                	jne    f0100901 <monitor+0x65>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100929:	83 ec 08             	sub    $0x8,%esp
f010092c:	ff 75 a8             	pushl  -0x58(%ebp)
f010092f:	68 00 1f 10 f0       	push   $0xf0101f00
f0100934:	e8 d4 00 00 00       	call   f0100a0d <cprintf>
f0100939:	83 c4 10             	add    $0x10,%esp
f010093c:	eb 4b                	jmp    f0100989 <monitor+0xed>
		if (*buf == 0)
f010093e:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100941:	74 a9                	je     f01008ec <monitor+0x50>
		if (argc == MAXARGS-1) {
f0100943:	83 fe 0f             	cmp    $0xf,%esi
f0100946:	74 2f                	je     f0100977 <monitor+0xdb>
		argv[argc++] = buf;
f0100948:	8d 7e 01             	lea    0x1(%esi),%edi
f010094b:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f010094f:	0f b6 03             	movzbl (%ebx),%eax
f0100952:	84 c0                	test   %al,%al
f0100954:	74 8d                	je     f01008e3 <monitor+0x47>
f0100956:	83 ec 08             	sub    $0x8,%esp
f0100959:	0f be c0             	movsbl %al,%eax
f010095c:	50                   	push   %eax
f010095d:	68 de 1e 10 f0       	push   $0xf0101ede
f0100962:	e8 e3 0c 00 00       	call   f010164a <strchr>
f0100967:	83 c4 10             	add    $0x10,%esp
f010096a:	85 c0                	test   %eax,%eax
f010096c:	0f 85 71 ff ff ff    	jne    f01008e3 <monitor+0x47>
			buf++;
f0100972:	83 c3 01             	add    $0x1,%ebx
f0100975:	eb d8                	jmp    f010094f <monitor+0xb3>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100977:	83 ec 08             	sub    $0x8,%esp
f010097a:	6a 10                	push   $0x10
f010097c:	68 e3 1e 10 f0       	push   $0xf0101ee3
f0100981:	e8 87 00 00 00       	call   f0100a0d <cprintf>
f0100986:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100989:	83 ec 0c             	sub    $0xc,%esp
f010098c:	68 da 1e 10 f0       	push   $0xf0101eda
f0100991:	e8 90 0a 00 00       	call   f0101426 <readline>
f0100996:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100998:	83 c4 10             	add    $0x10,%esp
f010099b:	85 c0                	test   %eax,%eax
f010099d:	74 ea                	je     f0100989 <monitor+0xed>
	argv[argc] = 0;
f010099f:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f01009a6:	be 00 00 00 00       	mov    $0x0,%esi
f01009ab:	e9 35 ff ff ff       	jmp    f01008e5 <monitor+0x49>
			return commands[i].func(argc, argv, tf);
f01009b0:	83 ec 04             	sub    $0x4,%esp
f01009b3:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01009b6:	ff 75 08             	pushl  0x8(%ebp)
f01009b9:	8d 55 a8             	lea    -0x58(%ebp),%edx
f01009bc:	52                   	push   %edx
f01009bd:	56                   	push   %esi
f01009be:	ff 14 85 e8 20 10 f0 	call   *-0xfefdf18(,%eax,4)
			if (runcmd(buf, tf) < 0)
f01009c5:	83 c4 10             	add    $0x10,%esp
f01009c8:	85 c0                	test   %eax,%eax
f01009ca:	79 bd                	jns    f0100989 <monitor+0xed>
				break;
	}
}
f01009cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01009cf:	5b                   	pop    %ebx
f01009d0:	5e                   	pop    %esi
f01009d1:	5f                   	pop    %edi
f01009d2:	5d                   	pop    %ebp
f01009d3:	c3                   	ret    

f01009d4 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01009d4:	55                   	push   %ebp
f01009d5:	89 e5                	mov    %esp,%ebp
f01009d7:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f01009da:	ff 75 08             	pushl  0x8(%ebp)
f01009dd:	e8 1e fd ff ff       	call   f0100700 <cputchar>
	*cnt++;
}
f01009e2:	83 c4 10             	add    $0x10,%esp
f01009e5:	c9                   	leave  
f01009e6:	c3                   	ret    

f01009e7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01009e7:	55                   	push   %ebp
f01009e8:	89 e5                	mov    %esp,%ebp
f01009ea:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f01009ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01009f4:	ff 75 0c             	pushl  0xc(%ebp)
f01009f7:	ff 75 08             	pushl  0x8(%ebp)
f01009fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01009fd:	50                   	push   %eax
f01009fe:	68 d4 09 10 f0       	push   $0xf01009d4
f0100a03:	e8 6f 04 00 00       	call   f0100e77 <vprintfmt>
	return cnt;
}
f0100a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100a0b:	c9                   	leave  
f0100a0c:	c3                   	ret    

f0100a0d <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0100a0d:	55                   	push   %ebp
f0100a0e:	89 e5                	mov    %esp,%ebp
f0100a10:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0100a13:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0100a16:	50                   	push   %eax
f0100a17:	ff 75 08             	pushl  0x8(%ebp)
f0100a1a:	e8 c8 ff ff ff       	call   f01009e7 <vcprintf>
	va_end(ap);

	return cnt;
}
f0100a1f:	c9                   	leave  
f0100a20:	c3                   	ret    

f0100a21 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0100a21:	55                   	push   %ebp
f0100a22:	89 e5                	mov    %esp,%ebp
f0100a24:	57                   	push   %edi
f0100a25:	56                   	push   %esi
f0100a26:	53                   	push   %ebx
f0100a27:	83 ec 14             	sub    $0x14,%esp
f0100a2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100a2d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100a30:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100a33:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100a36:	8b 1a                	mov    (%edx),%ebx
f0100a38:	8b 01                	mov    (%ecx),%eax
f0100a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100a3d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0100a44:	eb 23                	jmp    f0100a69 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0100a46:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0100a49:	eb 1e                	jmp    f0100a69 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100a4b:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100a4e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0100a51:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100a55:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100a58:	73 41                	jae    f0100a9b <stab_binsearch+0x7a>
			*region_left = m;
f0100a5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100a5d:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0100a5f:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0100a62:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0100a69:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0100a6c:	7f 5a                	jg     f0100ac8 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0100a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100a71:	01 d8                	add    %ebx,%eax
f0100a73:	89 c7                	mov    %eax,%edi
f0100a75:	c1 ef 1f             	shr    $0x1f,%edi
f0100a78:	01 c7                	add    %eax,%edi
f0100a7a:	d1 ff                	sar    %edi
f0100a7c:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100a7f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0100a82:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0100a86:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0100a88:	39 c3                	cmp    %eax,%ebx
f0100a8a:	7f ba                	jg     f0100a46 <stab_binsearch+0x25>
f0100a8c:	0f b6 0a             	movzbl (%edx),%ecx
f0100a8f:	83 ea 0c             	sub    $0xc,%edx
f0100a92:	39 f1                	cmp    %esi,%ecx
f0100a94:	74 b5                	je     f0100a4b <stab_binsearch+0x2a>
			m--;
f0100a96:	83 e8 01             	sub    $0x1,%eax
f0100a99:	eb ed                	jmp    f0100a88 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f0100a9b:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100a9e:	76 14                	jbe    f0100ab4 <stab_binsearch+0x93>
			*region_right = m - 1;
f0100aa0:	83 e8 01             	sub    $0x1,%eax
f0100aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100aa6:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0100aa9:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0100aab:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100ab2:	eb b5                	jmp    f0100a69 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0100ab4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100ab7:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0100ab9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100abd:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0100abf:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100ac6:	eb a1                	jmp    f0100a69 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0100ac8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0100acc:	75 15                	jne    f0100ae3 <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0100ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100ad1:	8b 00                	mov    (%eax),%eax
f0100ad3:	83 e8 01             	sub    $0x1,%eax
f0100ad6:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0100ad9:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0100adb:	83 c4 14             	add    $0x14,%esp
f0100ade:	5b                   	pop    %ebx
f0100adf:	5e                   	pop    %esi
f0100ae0:	5f                   	pop    %edi
f0100ae1:	5d                   	pop    %ebp
f0100ae2:	c3                   	ret    
		for (l = *region_right;
f0100ae3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100ae6:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100ae8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100aeb:	8b 0f                	mov    (%edi),%ecx
f0100aed:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100af0:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0100af3:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0100af7:	eb 03                	jmp    f0100afc <stab_binsearch+0xdb>
		     l--)
f0100af9:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0100afc:	39 c1                	cmp    %eax,%ecx
f0100afe:	7d 0a                	jge    f0100b0a <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0100b00:	0f b6 1a             	movzbl (%edx),%ebx
f0100b03:	83 ea 0c             	sub    $0xc,%edx
f0100b06:	39 f3                	cmp    %esi,%ebx
f0100b08:	75 ef                	jne    f0100af9 <stab_binsearch+0xd8>
		*region_left = l;
f0100b0a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100b0d:	89 06                	mov    %eax,(%esi)
}
f0100b0f:	eb ca                	jmp    f0100adb <stab_binsearch+0xba>

f0100b11 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100b11:	55                   	push   %ebp
f0100b12:	89 e5                	mov    %esp,%ebp
f0100b14:	57                   	push   %edi
f0100b15:	56                   	push   %esi
f0100b16:	53                   	push   %ebx
f0100b17:	83 ec 3c             	sub    $0x3c,%esp
f0100b1a:	8b 75 08             	mov    0x8(%ebp),%esi
f0100b1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100b20:	c7 03 04 21 10 f0    	movl   $0xf0102104,(%ebx)
	info->eip_line = 0;
f0100b26:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0100b2d:	c7 43 08 04 21 10 f0 	movl   $0xf0102104,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0100b34:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0100b3b:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0100b3e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100b45:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0100b4b:	0f 86 1c 01 00 00    	jbe    f0100c6d <debuginfo_eip+0x15c>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100b51:	b8 56 85 10 f0       	mov    $0xf0108556,%eax
f0100b56:	3d f1 6a 10 f0       	cmp    $0xf0106af1,%eax
f0100b5b:	0f 86 aa 01 00 00    	jbe    f0100d0b <debuginfo_eip+0x1fa>
f0100b61:	80 3d 55 85 10 f0 00 	cmpb   $0x0,0xf0108555
f0100b68:	0f 85 a4 01 00 00    	jne    f0100d12 <debuginfo_eip+0x201>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100b6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100b75:	b8 f0 6a 10 f0       	mov    $0xf0106af0,%eax
f0100b7a:	2d 5c 23 10 f0       	sub    $0xf010235c,%eax
f0100b7f:	c1 f8 02             	sar    $0x2,%eax
f0100b82:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100b88:	83 e8 01             	sub    $0x1,%eax
f0100b8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100b8e:	83 ec 08             	sub    $0x8,%esp
f0100b91:	56                   	push   %esi
f0100b92:	6a 64                	push   $0x64
f0100b94:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100b97:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100b9a:	b8 5c 23 10 f0       	mov    $0xf010235c,%eax
f0100b9f:	e8 7d fe ff ff       	call   f0100a21 <stab_binsearch>
	if (lfile == 0)
f0100ba4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100ba7:	83 c4 10             	add    $0x10,%esp
f0100baa:	85 c0                	test   %eax,%eax
f0100bac:	0f 84 67 01 00 00    	je     f0100d19 <debuginfo_eip+0x208>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100bb2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0100bb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100bb8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100bbb:	83 ec 08             	sub    $0x8,%esp
f0100bbe:	56                   	push   %esi
f0100bbf:	6a 24                	push   $0x24
f0100bc1:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100bc4:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100bc7:	b8 5c 23 10 f0       	mov    $0xf010235c,%eax
f0100bcc:	e8 50 fe ff ff       	call   f0100a21 <stab_binsearch>

	if (lfun <= rfun) {
f0100bd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100bd4:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0100bd7:	83 c4 10             	add    $0x10,%esp
f0100bda:	39 d0                	cmp    %edx,%eax
f0100bdc:	0f 8f 9f 00 00 00    	jg     f0100c81 <debuginfo_eip+0x170>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100be2:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0100be5:	c1 e1 02             	shl    $0x2,%ecx
f0100be8:	8d b9 5c 23 10 f0    	lea    -0xfefdca4(%ecx),%edi
f0100bee:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0100bf1:	8b b9 5c 23 10 f0    	mov    -0xfefdca4(%ecx),%edi
f0100bf7:	b9 56 85 10 f0       	mov    $0xf0108556,%ecx
f0100bfc:	81 e9 f1 6a 10 f0    	sub    $0xf0106af1,%ecx
f0100c02:	39 cf                	cmp    %ecx,%edi
f0100c04:	73 09                	jae    f0100c0f <debuginfo_eip+0xfe>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100c06:	81 c7 f1 6a 10 f0    	add    $0xf0106af1,%edi
f0100c0c:	89 7b 08             	mov    %edi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100c0f:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100c12:	8b 4f 08             	mov    0x8(%edi),%ecx
f0100c15:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0100c18:	29 ce                	sub    %ecx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0100c1a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0100c1d:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100c20:	83 ec 08             	sub    $0x8,%esp
f0100c23:	6a 3a                	push   $0x3a
f0100c25:	ff 73 08             	pushl  0x8(%ebx)
f0100c28:	e8 3e 0a 00 00       	call   f010166b <strfind>
f0100c2d:	2b 43 08             	sub    0x8(%ebx),%eax
f0100c30:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0100c33:	83 c4 08             	add    $0x8,%esp
f0100c36:	56                   	push   %esi
f0100c37:	6a 44                	push   $0x44
f0100c39:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0100c3c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0100c3f:	b8 5c 23 10 f0       	mov    $0xf010235c,%eax
f0100c44:	e8 d8 fd ff ff       	call   f0100a21 <stab_binsearch>
	if (lline <= rline) {
f0100c49:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100c4c:	83 c4 10             	add    $0x10,%esp
f0100c4f:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0100c52:	0f 8f c8 00 00 00    	jg     f0100d20 <debuginfo_eip+0x20f>
		info->eip_line = stabs[lline].n_desc;
f0100c58:	89 d0                	mov    %edx,%eax
f0100c5a:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0100c5d:	0f b7 14 95 62 23 10 	movzwl -0xfefdc9e(,%edx,4),%edx
f0100c64:	f0 
f0100c65:	89 53 04             	mov    %edx,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100c68:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100c6b:	eb 28                	jmp    f0100c95 <debuginfo_eip+0x184>
  	        panic("User address");
f0100c6d:	83 ec 04             	sub    $0x4,%esp
f0100c70:	68 0e 21 10 f0       	push   $0xf010210e
f0100c75:	6a 7f                	push   $0x7f
f0100c77:	68 1b 21 10 f0       	push   $0xf010211b
f0100c7c:	e8 19 f5 ff ff       	call   f010019a <_panic>
		info->eip_fn_addr = addr;
f0100c81:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0100c84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100c87:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0100c8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100c8d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100c90:	eb 8e                	jmp    f0100c20 <debuginfo_eip+0x10f>
f0100c92:	83 e8 01             	sub    $0x1,%eax
	while (lline >= lfile
f0100c95:	39 c6                	cmp    %eax,%esi
f0100c97:	7f 3f                	jg     f0100cd8 <debuginfo_eip+0x1c7>
f0100c99:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
	       && stabs[lline].n_type != N_SOL
f0100c9c:	0f b6 14 8d 60 23 10 	movzbl -0xfefdca0(,%ecx,4),%edx
f0100ca3:	f0 
f0100ca4:	80 fa 84             	cmp    $0x84,%dl
f0100ca7:	74 0f                	je     f0100cb8 <debuginfo_eip+0x1a7>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100ca9:	80 fa 64             	cmp    $0x64,%dl
f0100cac:	75 e4                	jne    f0100c92 <debuginfo_eip+0x181>
f0100cae:	83 3c 8d 64 23 10 f0 	cmpl   $0x0,-0xfefdc9c(,%ecx,4)
f0100cb5:	00 
f0100cb6:	74 da                	je     f0100c92 <debuginfo_eip+0x181>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100cb8:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100cbb:	8b 14 85 5c 23 10 f0 	mov    -0xfefdca4(,%eax,4),%edx
f0100cc2:	b8 56 85 10 f0       	mov    $0xf0108556,%eax
f0100cc7:	2d f1 6a 10 f0       	sub    $0xf0106af1,%eax
f0100ccc:	39 c2                	cmp    %eax,%edx
f0100cce:	73 08                	jae    f0100cd8 <debuginfo_eip+0x1c7>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100cd0:	81 c2 f1 6a 10 f0    	add    $0xf0106af1,%edx
f0100cd6:	89 13                	mov    %edx,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0100cd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100cdb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0100cde:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0100ce3:	39 ca                	cmp    %ecx,%edx
f0100ce5:	7d 45                	jge    f0100d2c <debuginfo_eip+0x21b>
f0100ce7:	8d 42 01             	lea    0x1(%edx),%eax
		for (lline = lfun + 1;
f0100cea:	eb 04                	jmp    f0100cf0 <debuginfo_eip+0x1df>
			info->eip_fn_narg++;
f0100cec:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0100cf0:	39 c1                	cmp    %eax,%ecx
f0100cf2:	7e 33                	jle    f0100d27 <debuginfo_eip+0x216>
f0100cf4:	83 c0 01             	add    $0x1,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100cf7:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100cfa:	80 3c 95 54 23 10 f0 	cmpb   $0xa0,-0xfefdcac(,%edx,4)
f0100d01:	a0 
f0100d02:	74 e8                	je     f0100cec <debuginfo_eip+0x1db>
	return 0;
f0100d04:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d09:	eb 21                	jmp    f0100d2c <debuginfo_eip+0x21b>
		return -1;
f0100d0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d10:	eb 1a                	jmp    f0100d2c <debuginfo_eip+0x21b>
f0100d12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d17:	eb 13                	jmp    f0100d2c <debuginfo_eip+0x21b>
		return -1;
f0100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d1e:	eb 0c                	jmp    f0100d2c <debuginfo_eip+0x21b>
		return -1;
f0100d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d25:	eb 05                	jmp    f0100d2c <debuginfo_eip+0x21b>
	return 0;
f0100d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d2f:	5b                   	pop    %ebx
f0100d30:	5e                   	pop    %esi
f0100d31:	5f                   	pop    %edi
f0100d32:	5d                   	pop    %ebp
f0100d33:	c3                   	ret    

f0100d34 <mapcolor>:
	return ch <= '9' && ch >= '0';
}

static uint8_t
mapcolor(uint16_t ascii_color) 
{
f0100d34:	89 c2                	mov    %eax,%edx
	uint16_t default_value = 7; // white
f0100d36:	b9 07 00 00 00       	mov    $0x7,%ecx
	if (ascii_color >= 40) { // is background
f0100d3b:	66 83 f8 27          	cmp    $0x27,%ax
f0100d3f:	76 08                	jbe    f0100d49 <mapcolor+0x15>
		ascii_color -= 10;
f0100d41:	8d 50 f6             	lea    -0xa(%eax),%edx
		default_value = 0;
f0100d44:	b9 00 00 00 00       	mov    $0x0,%ecx
	}
	switch(ascii_color) {
f0100d49:	83 ea 1e             	sub    $0x1e,%edx
f0100d4c:	66 83 fa 07          	cmp    $0x7,%dx
f0100d50:	77 34                	ja     f0100d86 <mapcolor+0x52>
f0100d52:	0f b7 d2             	movzwl %dx,%edx
f0100d55:	ff 24 95 2c 21 10 f0 	jmp    *-0xfefded4(,%edx,4)
		case 30:// Black
			return 0;
		case 31:// Red
			return 4;
f0100d5c:	b8 04 00 00 00       	mov    $0x4,%eax
f0100d61:	c3                   	ret    
		case 32:// Green
			return 2;
f0100d62:	b8 02 00 00 00       	mov    $0x2,%eax
f0100d67:	c3                   	ret    
		case 33:// Yellow
			return 6;
f0100d68:	b8 06 00 00 00       	mov    $0x6,%eax
f0100d6d:	c3                   	ret    
		case 34:// Blue
			return 1;
f0100d6e:	b8 01 00 00 00       	mov    $0x1,%eax
f0100d73:	c3                   	ret    
		case 35:// Magenta
			return 5;
f0100d74:	b8 05 00 00 00       	mov    $0x5,%eax
f0100d79:	c3                   	ret    
		case 36:// Cyan
			return 3;
f0100d7a:	b8 03 00 00 00       	mov    $0x3,%eax
f0100d7f:	c3                   	ret    
		case 37:// White
			return 7;
f0100d80:	b8 07 00 00 00       	mov    $0x7,%eax
f0100d85:	c3                   	ret    
	}
	return default_value;
f0100d86:	89 c8                	mov    %ecx,%eax
f0100d88:	c3                   	ret    
			return 0;
f0100d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100d8e:	c3                   	ret    

f0100d8f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100d8f:	55                   	push   %ebp
f0100d90:	89 e5                	mov    %esp,%ebp
f0100d92:	57                   	push   %edi
f0100d93:	56                   	push   %esi
f0100d94:	53                   	push   %ebx
f0100d95:	83 ec 1c             	sub    $0x1c,%esp
f0100d98:	89 c7                	mov    %eax,%edi
f0100d9a:	89 d6                	mov    %edx,%esi
f0100d9c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100da2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100da5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100da8:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0100dab:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100db0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100db3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0100db6:	3b 45 10             	cmp    0x10(%ebp),%eax
f0100db9:	89 d0                	mov    %edx,%eax
f0100dbb:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
f0100dbe:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0100dc1:	73 15                	jae    f0100dd8 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0100dc3:	83 eb 01             	sub    $0x1,%ebx
f0100dc6:	85 db                	test   %ebx,%ebx
f0100dc8:	7e 43                	jle    f0100e0d <printnum+0x7e>
			putch(padc, putdat);
f0100dca:	83 ec 08             	sub    $0x8,%esp
f0100dcd:	56                   	push   %esi
f0100dce:	ff 75 18             	pushl  0x18(%ebp)
f0100dd1:	ff d7                	call   *%edi
f0100dd3:	83 c4 10             	add    $0x10,%esp
f0100dd6:	eb eb                	jmp    f0100dc3 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0100dd8:	83 ec 0c             	sub    $0xc,%esp
f0100ddb:	ff 75 18             	pushl  0x18(%ebp)
f0100dde:	8b 45 14             	mov    0x14(%ebp),%eax
f0100de1:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0100de4:	53                   	push   %ebx
f0100de5:	ff 75 10             	pushl  0x10(%ebp)
f0100de8:	83 ec 08             	sub    $0x8,%esp
f0100deb:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100dee:	ff 75 e0             	pushl  -0x20(%ebp)
f0100df1:	ff 75 dc             	pushl  -0x24(%ebp)
f0100df4:	ff 75 d8             	pushl  -0x28(%ebp)
f0100df7:	e8 84 0a 00 00       	call   f0101880 <__udivdi3>
f0100dfc:	83 c4 18             	add    $0x18,%esp
f0100dff:	52                   	push   %edx
f0100e00:	50                   	push   %eax
f0100e01:	89 f2                	mov    %esi,%edx
f0100e03:	89 f8                	mov    %edi,%eax
f0100e05:	e8 85 ff ff ff       	call   f0100d8f <printnum>
f0100e0a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0100e0d:	83 ec 08             	sub    $0x8,%esp
f0100e10:	56                   	push   %esi
f0100e11:	83 ec 04             	sub    $0x4,%esp
f0100e14:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100e17:	ff 75 e0             	pushl  -0x20(%ebp)
f0100e1a:	ff 75 dc             	pushl  -0x24(%ebp)
f0100e1d:	ff 75 d8             	pushl  -0x28(%ebp)
f0100e20:	e8 6b 0b 00 00       	call   f0101990 <__umoddi3>
f0100e25:	83 c4 14             	add    $0x14,%esp
f0100e28:	0f be 80 c0 22 10 f0 	movsbl -0xfefdd40(%eax),%eax
f0100e2f:	50                   	push   %eax
f0100e30:	ff d7                	call   *%edi
}
f0100e32:	83 c4 10             	add    $0x10,%esp
f0100e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e38:	5b                   	pop    %ebx
f0100e39:	5e                   	pop    %esi
f0100e3a:	5f                   	pop    %edi
f0100e3b:	5d                   	pop    %ebp
f0100e3c:	c3                   	ret    

f0100e3d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0100e3d:	55                   	push   %ebp
f0100e3e:	89 e5                	mov    %esp,%ebp
f0100e40:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0100e43:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0100e47:	8b 10                	mov    (%eax),%edx
f0100e49:	3b 50 04             	cmp    0x4(%eax),%edx
f0100e4c:	73 0a                	jae    f0100e58 <sprintputch+0x1b>
		*b->buf++ = ch;
f0100e4e:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100e51:	89 08                	mov    %ecx,(%eax)
f0100e53:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e56:	88 02                	mov    %al,(%edx)
}
f0100e58:	5d                   	pop    %ebp
f0100e59:	c3                   	ret    

f0100e5a <printfmt>:
{
f0100e5a:	55                   	push   %ebp
f0100e5b:	89 e5                	mov    %esp,%ebp
f0100e5d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0100e60:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0100e63:	50                   	push   %eax
f0100e64:	ff 75 10             	pushl  0x10(%ebp)
f0100e67:	ff 75 0c             	pushl  0xc(%ebp)
f0100e6a:	ff 75 08             	pushl  0x8(%ebp)
f0100e6d:	e8 05 00 00 00       	call   f0100e77 <vprintfmt>
}
f0100e72:	83 c4 10             	add    $0x10,%esp
f0100e75:	c9                   	leave  
f0100e76:	c3                   	ret    

f0100e77 <vprintfmt>:
{
f0100e77:	55                   	push   %ebp
f0100e78:	89 e5                	mov    %esp,%ebp
f0100e7a:	57                   	push   %edi
f0100e7b:	56                   	push   %esi
f0100e7c:	53                   	push   %ebx
f0100e7d:	83 ec 2c             	sub    $0x2c,%esp
f0100e80:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0100e83:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0100e86:	eb 0d                	jmp    f0100e95 <vprintfmt+0x1e>
			putch(ch, putdat);
f0100e88:	83 ec 08             	sub    $0x8,%esp
f0100e8b:	57                   	push   %edi
f0100e8c:	50                   	push   %eax
f0100e8d:	ff 55 08             	call   *0x8(%ebp)
f0100e90:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0100e93:	89 f3                	mov    %esi,%ebx
f0100e95:	8d 73 01             	lea    0x1(%ebx),%esi
f0100e98:	0f b6 03             	movzbl (%ebx),%eax
f0100e9b:	83 f8 25             	cmp    $0x25,%eax
f0100e9e:	0f 84 b2 00 00 00    	je     f0100f56 <vprintfmt+0xdf>
			if (ch == '\0') {
f0100ea4:	85 c0                	test   %eax,%eax
f0100ea6:	0f 84 0a 05 00 00    	je     f01013b6 <vprintfmt+0x53f>
			if (ch == 0x1b && *ufmt == '[' && isdigit(*(ufmt+1)) &&
f0100eac:	83 f8 1b             	cmp    $0x1b,%eax
f0100eaf:	75 d7                	jne    f0100e88 <vprintfmt+0x11>
f0100eb1:	80 7b 01 5b          	cmpb   $0x5b,0x1(%ebx)
f0100eb5:	75 d1                	jne    f0100e88 <vprintfmt+0x11>
f0100eb7:	0f b6 53 02          	movzbl 0x2(%ebx),%edx
	return ch <= '9' && ch >= '0';
f0100ebb:	8d 4a d0             	lea    -0x30(%edx),%ecx
			if (ch == 0x1b && *ufmt == '[' && isdigit(*(ufmt+1)) &&
f0100ebe:	80 f9 09             	cmp    $0x9,%cl
f0100ec1:	77 c5                	ja     f0100e88 <vprintfmt+0x11>
			    isdigit(*(ufmt+2)) && *(ufmt+3) == ';' &&
f0100ec3:	0f b6 4b 03          	movzbl 0x3(%ebx),%ecx
f0100ec7:	88 4d e0             	mov    %cl,-0x20(%ebp)
	return ch <= '9' && ch >= '0';
f0100eca:	83 e9 30             	sub    $0x30,%ecx
			if (ch == 0x1b && *ufmt == '[' && isdigit(*(ufmt+1)) &&
f0100ecd:	80 f9 09             	cmp    $0x9,%cl
f0100ed0:	77 b6                	ja     f0100e88 <vprintfmt+0x11>
			    isdigit(*(ufmt+2)) && *(ufmt+3) == ';' &&
f0100ed2:	80 7b 04 3b          	cmpb   $0x3b,0x4(%ebx)
f0100ed6:	75 b0                	jne    f0100e88 <vprintfmt+0x11>
			    isdigit(*(ufmt+4)) && isdigit(*(ufmt+5))
f0100ed8:	0f b6 4b 05          	movzbl 0x5(%ebx),%ecx
f0100edc:	88 4d dc             	mov    %cl,-0x24(%ebp)
	return ch <= '9' && ch >= '0';
f0100edf:	83 e9 30             	sub    $0x30,%ecx
			    isdigit(*(ufmt+2)) && *(ufmt+3) == ';' &&
f0100ee2:	80 f9 09             	cmp    $0x9,%cl
f0100ee5:	77 a1                	ja     f0100e88 <vprintfmt+0x11>
			    isdigit(*(ufmt+4)) && isdigit(*(ufmt+5))
f0100ee7:	0f b6 4b 06          	movzbl 0x6(%ebx),%ecx
f0100eeb:	88 4d d8             	mov    %cl,-0x28(%ebp)
	return ch <= '9' && ch >= '0';
f0100eee:	83 e9 30             	sub    $0x30,%ecx
			    isdigit(*(ufmt+4)) && isdigit(*(ufmt+5))
f0100ef1:	80 f9 09             	cmp    $0x9,%cl
f0100ef4:	77 92                	ja     f0100e88 <vprintfmt+0x11>
			    && *(ufmt+6) == 'm') {
f0100ef6:	80 7b 07 6d          	cmpb   $0x6d,0x7(%ebx)
f0100efa:	75 8c                	jne    f0100e88 <vprintfmt+0x11>
				uint8_t foreground = mapcolor((*(ufmt+1) - '0') * 10 +
f0100efc:	0f b6 d2             	movzbl %dl,%edx
f0100eff:	8d 94 92 10 ff ff ff 	lea    -0xf0(%edx,%edx,4),%edx
					(*(ufmt+2) - '0'));
f0100f06:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
				uint8_t foreground = mapcolor((*(ufmt+1) - '0') * 10 +
f0100f0a:	8d 44 50 d0          	lea    -0x30(%eax,%edx,2),%eax
f0100f0e:	0f b7 c0             	movzwl %ax,%eax
f0100f11:	e8 1e fe ff ff       	call   f0100d34 <mapcolor>
f0100f16:	89 c6                	mov    %eax,%esi
				uint8_t background = mapcolor((*(ufmt+4) - '0') * 10 + 
f0100f18:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
f0100f1c:	8d 84 80 10 ff ff ff 	lea    -0xf0(%eax,%eax,4),%eax
					(*(ufmt+5) - '0'));
f0100f23:	0f b6 55 d8          	movzbl -0x28(%ebp),%edx
				uint8_t background = mapcolor((*(ufmt+4) - '0') * 10 + 
f0100f27:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
f0100f2b:	0f b7 c0             	movzwl %ax,%eax
f0100f2e:	e8 01 fe ff ff       	call   f0100d34 <mapcolor>
				set_color_info(color);
f0100f33:	83 ec 0c             	sub    $0xc,%esp
				uint16_t color = (background << 12) | (foreground << 8);
f0100f36:	89 c2                	mov    %eax,%edx
f0100f38:	c1 e2 0c             	shl    $0xc,%edx
f0100f3b:	89 f0                	mov    %esi,%eax
f0100f3d:	c1 e0 08             	shl    $0x8,%eax
f0100f40:	09 d0                	or     %edx,%eax
				set_color_info(color);
f0100f42:	0f b7 c0             	movzwl %ax,%eax
f0100f45:	50                   	push   %eax
f0100f46:	e8 dc f7 ff ff       	call   f0100727 <set_color_info>
				fmt += 7;
f0100f4b:	83 c3 08             	add    $0x8,%ebx
				continue;	
f0100f4e:	83 c4 10             	add    $0x10,%esp
f0100f51:	e9 3f ff ff ff       	jmp    f0100e95 <vprintfmt+0x1e>
		padc = ' ';
f0100f56:	c6 45 d7 20          	movb   $0x20,-0x29(%ebp)
		altflag = 0;
f0100f5a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0100f61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
f0100f68:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
		lflag = 0;
f0100f6f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0100f74:	8d 5e 01             	lea    0x1(%esi),%ebx
f0100f77:	0f b6 16             	movzbl (%esi),%edx
f0100f7a:	8d 42 dd             	lea    -0x23(%edx),%eax
f0100f7d:	3c 55                	cmp    $0x55,%al
f0100f7f:	0f 87 13 04 00 00    	ja     f0101398 <vprintfmt+0x521>
f0100f85:	0f b6 c0             	movzbl %al,%eax
f0100f88:	ff 24 85 4c 21 10 f0 	jmp    *-0xfefdeb4(,%eax,4)
f0100f8f:	89 de                	mov    %ebx,%esi
			padc = '-';
f0100f91:	c6 45 d7 2d          	movb   $0x2d,-0x29(%ebp)
f0100f95:	eb dd                	jmp    f0100f74 <vprintfmt+0xfd>
		switch (ch = *(unsigned char *) fmt++) {
f0100f97:	89 de                	mov    %ebx,%esi
			padc = '0';
f0100f99:	c6 45 d7 30          	movb   $0x30,-0x29(%ebp)
f0100f9d:	eb d5                	jmp    f0100f74 <vprintfmt+0xfd>
		switch (ch = *(unsigned char *) fmt++) {
f0100f9f:	0f b6 d2             	movzbl %dl,%edx
f0100fa2:	89 de                	mov    %ebx,%esi
			for (precision = 0; ; ++fmt) {
f0100fa4:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
f0100fa9:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100fac:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0100fb0:	0f be 16             	movsbl (%esi),%edx
				if (ch < '0' || ch > '9')
f0100fb3:	8d 5a d0             	lea    -0x30(%edx),%ebx
f0100fb6:	83 fb 09             	cmp    $0x9,%ebx
f0100fb9:	77 52                	ja     f010100d <vprintfmt+0x196>
			for (precision = 0; ; ++fmt) {
f0100fbb:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
f0100fbe:	eb e9                	jmp    f0100fa9 <vprintfmt+0x132>
			precision = va_arg(ap, int);
f0100fc0:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fc3:	8b 00                	mov    (%eax),%eax
f0100fc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100fc8:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fcb:	8d 40 04             	lea    0x4(%eax),%eax
f0100fce:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0100fd1:	89 de                	mov    %ebx,%esi
			if (width < 0)
f0100fd3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0100fd7:	79 9b                	jns    f0100f74 <vprintfmt+0xfd>
				width = precision, precision = -1;
f0100fd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100fdc:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100fdf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
f0100fe6:	eb 8c                	jmp    f0100f74 <vprintfmt+0xfd>
f0100fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100feb:	85 c0                	test   %eax,%eax
f0100fed:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ff2:	0f 49 d0             	cmovns %eax,%edx
f0100ff5:	89 55 dc             	mov    %edx,-0x24(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0100ff8:	89 de                	mov    %ebx,%esi
f0100ffa:	e9 75 ff ff ff       	jmp    f0100f74 <vprintfmt+0xfd>
f0100fff:	89 de                	mov    %ebx,%esi
			altflag = 1;
f0101001:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0101008:	e9 67 ff ff ff       	jmp    f0100f74 <vprintfmt+0xfd>
f010100d:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101010:	eb c1                	jmp    f0100fd3 <vprintfmt+0x15c>
			lflag++;
f0101012:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0101015:	89 de                	mov    %ebx,%esi
			goto reswitch;
f0101017:	e9 58 ff ff ff       	jmp    f0100f74 <vprintfmt+0xfd>
			putch(va_arg(ap, int), putdat);
f010101c:	8b 45 14             	mov    0x14(%ebp),%eax
f010101f:	8d 70 04             	lea    0x4(%eax),%esi
f0101022:	83 ec 08             	sub    $0x8,%esp
f0101025:	57                   	push   %edi
f0101026:	ff 30                	pushl  (%eax)
f0101028:	ff 55 08             	call   *0x8(%ebp)
			break;
f010102b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f010102e:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
f0101031:	e9 5f fe ff ff       	jmp    f0100e95 <vprintfmt+0x1e>
			err = va_arg(ap, int);
f0101036:	8b 45 14             	mov    0x14(%ebp),%eax
f0101039:	8d 70 04             	lea    0x4(%eax),%esi
f010103c:	8b 00                	mov    (%eax),%eax
f010103e:	99                   	cltd   
f010103f:	31 d0                	xor    %edx,%eax
f0101041:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0101043:	83 f8 06             	cmp    $0x6,%eax
f0101046:	7f 25                	jg     f010106d <vprintfmt+0x1f6>
f0101048:	8b 14 85 a4 22 10 f0 	mov    -0xfefdd5c(,%eax,4),%edx
f010104f:	85 d2                	test   %edx,%edx
f0101051:	74 1a                	je     f010106d <vprintfmt+0x1f6>
				printfmt(putch, putdat, "%s", p);
f0101053:	52                   	push   %edx
f0101054:	68 e2 1b 10 f0       	push   $0xf0101be2
f0101059:	57                   	push   %edi
f010105a:	ff 75 08             	pushl  0x8(%ebp)
f010105d:	e8 f8 fd ff ff       	call   f0100e5a <printfmt>
f0101062:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0101065:	89 75 14             	mov    %esi,0x14(%ebp)
f0101068:	e9 28 fe ff ff       	jmp    f0100e95 <vprintfmt+0x1e>
				printfmt(putch, putdat, "error %d", err);
f010106d:	50                   	push   %eax
f010106e:	68 d8 22 10 f0       	push   $0xf01022d8
f0101073:	57                   	push   %edi
f0101074:	ff 75 08             	pushl  0x8(%ebp)
f0101077:	e8 de fd ff ff       	call   f0100e5a <printfmt>
f010107c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010107f:	89 75 14             	mov    %esi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0101082:	e9 0e fe ff ff       	jmp    f0100e95 <vprintfmt+0x1e>
			if ((p = va_arg(ap, char *)) == NULL)
f0101087:	8b 45 14             	mov    0x14(%ebp),%eax
f010108a:	83 c0 04             	add    $0x4,%eax
f010108d:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101090:	8b 45 14             	mov    0x14(%ebp),%eax
f0101093:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f0101095:	85 d2                	test   %edx,%edx
f0101097:	b8 d1 22 10 f0       	mov    $0xf01022d1,%eax
f010109c:	0f 45 c2             	cmovne %edx,%eax
f010109f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (width > 0 && padc != '-')
f01010a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01010a6:	7e 06                	jle    f01010ae <vprintfmt+0x237>
f01010a8:	80 7d d7 2d          	cmpb   $0x2d,-0x29(%ebp)
f01010ac:	75 0d                	jne    f01010bb <vprintfmt+0x244>
				for (width -= strnlen(p, precision); width > 0; width--)
f01010ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01010b1:	89 c6                	mov    %eax,%esi
f01010b3:	03 45 dc             	add    -0x24(%ebp),%eax
f01010b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01010b9:	eb 41                	jmp    f01010fc <vprintfmt+0x285>
f01010bb:	83 ec 08             	sub    $0x8,%esp
f01010be:	ff 75 e0             	pushl  -0x20(%ebp)
f01010c1:	50                   	push   %eax
f01010c2:	e8 59 04 00 00       	call   f0101520 <strnlen>
f01010c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01010ca:	29 c2                	sub    %eax,%edx
f01010cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01010cf:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f01010d2:	0f be 45 d7          	movsbl -0x29(%ebp),%eax
f01010d6:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01010d9:	89 d3                	mov    %edx,%ebx
f01010db:	89 c6                	mov    %eax,%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f01010dd:	85 db                	test   %ebx,%ebx
f01010df:	7e 59                	jle    f010113a <vprintfmt+0x2c3>
					putch(padc, putdat);
f01010e1:	83 ec 08             	sub    $0x8,%esp
f01010e4:	57                   	push   %edi
f01010e5:	56                   	push   %esi
f01010e6:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f01010e9:	83 eb 01             	sub    $0x1,%ebx
f01010ec:	83 c4 10             	add    $0x10,%esp
f01010ef:	eb ec                	jmp    f01010dd <vprintfmt+0x266>
					putch(ch, putdat);
f01010f1:	83 ec 08             	sub    $0x8,%esp
f01010f4:	57                   	push   %edi
f01010f5:	52                   	push   %edx
f01010f6:	ff 55 08             	call   *0x8(%ebp)
f01010f9:	83 c4 10             	add    $0x10,%esp
f01010fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01010ff:	29 f1                	sub    %esi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0101101:	83 c6 01             	add    $0x1,%esi
f0101104:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
f0101108:	0f be d0             	movsbl %al,%edx
f010110b:	85 d2                	test   %edx,%edx
f010110d:	74 4f                	je     f010115e <vprintfmt+0x2e7>
f010110f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0101113:	78 06                	js     f010111b <vprintfmt+0x2a4>
f0101115:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
f0101119:	78 39                	js     f0101154 <vprintfmt+0x2dd>
				if (altflag && (ch < ' ' || ch > '~'))
f010111b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f010111f:	74 d0                	je     f01010f1 <vprintfmt+0x27a>
f0101121:	0f be c0             	movsbl %al,%eax
f0101124:	83 e8 20             	sub    $0x20,%eax
f0101127:	83 f8 5e             	cmp    $0x5e,%eax
f010112a:	76 c5                	jbe    f01010f1 <vprintfmt+0x27a>
					putch('?', putdat);
f010112c:	83 ec 08             	sub    $0x8,%esp
f010112f:	57                   	push   %edi
f0101130:	6a 3f                	push   $0x3f
f0101132:	ff 55 08             	call   *0x8(%ebp)
f0101135:	83 c4 10             	add    $0x10,%esp
f0101138:	eb c2                	jmp    f01010fc <vprintfmt+0x285>
f010113a:	8b 5d 10             	mov    0x10(%ebp),%ebx
f010113d:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101140:	85 d2                	test   %edx,%edx
f0101142:	b8 00 00 00 00       	mov    $0x0,%eax
f0101147:	0f 49 c2             	cmovns %edx,%eax
f010114a:	29 c2                	sub    %eax,%edx
f010114c:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010114f:	e9 5a ff ff ff       	jmp    f01010ae <vprintfmt+0x237>
f0101154:	8b 75 08             	mov    0x8(%ebp),%esi
f0101157:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010115a:	89 cb                	mov    %ecx,%ebx
f010115c:	eb 08                	jmp    f0101166 <vprintfmt+0x2ef>
f010115e:	8b 75 08             	mov    0x8(%ebp),%esi
f0101161:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0101164:	89 cb                	mov    %ecx,%ebx
			for (; width > 0; width--)
f0101166:	85 db                	test   %ebx,%ebx
f0101168:	7e 10                	jle    f010117a <vprintfmt+0x303>
				putch(' ', putdat);
f010116a:	83 ec 08             	sub    $0x8,%esp
f010116d:	57                   	push   %edi
f010116e:	6a 20                	push   $0x20
f0101170:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0101172:	83 eb 01             	sub    $0x1,%ebx
f0101175:	83 c4 10             	add    $0x10,%esp
f0101178:	eb ec                	jmp    f0101166 <vprintfmt+0x2ef>
f010117a:	89 75 08             	mov    %esi,0x8(%ebp)
f010117d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
f0101180:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101183:	89 45 14             	mov    %eax,0x14(%ebp)
f0101186:	e9 0a fd ff ff       	jmp    f0100e95 <vprintfmt+0x1e>
	if (lflag >= 2)
f010118b:	83 f9 01             	cmp    $0x1,%ecx
f010118e:	7f 1f                	jg     f01011af <vprintfmt+0x338>
	else if (lflag)
f0101190:	85 c9                	test   %ecx,%ecx
f0101192:	74 68                	je     f01011fc <vprintfmt+0x385>
		return va_arg(*ap, long);
f0101194:	8b 45 14             	mov    0x14(%ebp),%eax
f0101197:	8b 30                	mov    (%eax),%esi
f0101199:	89 75 e0             	mov    %esi,-0x20(%ebp)
f010119c:	89 f0                	mov    %esi,%eax
f010119e:	c1 f8 1f             	sar    $0x1f,%eax
f01011a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01011a4:	8b 45 14             	mov    0x14(%ebp),%eax
f01011a7:	8d 40 04             	lea    0x4(%eax),%eax
f01011aa:	89 45 14             	mov    %eax,0x14(%ebp)
f01011ad:	eb 17                	jmp    f01011c6 <vprintfmt+0x34f>
		return va_arg(*ap, long long);
f01011af:	8b 45 14             	mov    0x14(%ebp),%eax
f01011b2:	8b 50 04             	mov    0x4(%eax),%edx
f01011b5:	8b 00                	mov    (%eax),%eax
f01011b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01011ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01011bd:	8b 45 14             	mov    0x14(%ebp),%eax
f01011c0:	8d 40 08             	lea    0x8(%eax),%eax
f01011c3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01011c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01011c9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
f01011cc:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f01011d1:	85 c9                	test   %ecx,%ecx
f01011d3:	0f 89 42 01 00 00    	jns    f010131b <vprintfmt+0x4a4>
				putch('-', putdat);
f01011d9:	83 ec 08             	sub    $0x8,%esp
f01011dc:	57                   	push   %edi
f01011dd:	6a 2d                	push   $0x2d
f01011df:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01011e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01011e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01011e8:	f7 da                	neg    %edx
f01011ea:	83 d1 00             	adc    $0x0,%ecx
f01011ed:	f7 d9                	neg    %ecx
f01011ef:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01011f2:	b8 0a 00 00 00       	mov    $0xa,%eax
f01011f7:	e9 1f 01 00 00       	jmp    f010131b <vprintfmt+0x4a4>
		return va_arg(*ap, int);
f01011fc:	8b 45 14             	mov    0x14(%ebp),%eax
f01011ff:	8b 30                	mov    (%eax),%esi
f0101201:	89 75 e0             	mov    %esi,-0x20(%ebp)
f0101204:	89 f0                	mov    %esi,%eax
f0101206:	c1 f8 1f             	sar    $0x1f,%eax
f0101209:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010120c:	8b 45 14             	mov    0x14(%ebp),%eax
f010120f:	8d 40 04             	lea    0x4(%eax),%eax
f0101212:	89 45 14             	mov    %eax,0x14(%ebp)
f0101215:	eb af                	jmp    f01011c6 <vprintfmt+0x34f>
	if (lflag >= 2)
f0101217:	83 f9 01             	cmp    $0x1,%ecx
f010121a:	7f 1e                	jg     f010123a <vprintfmt+0x3c3>
	else if (lflag)
f010121c:	85 c9                	test   %ecx,%ecx
f010121e:	74 32                	je     f0101252 <vprintfmt+0x3db>
		return va_arg(*ap, unsigned long);
f0101220:	8b 45 14             	mov    0x14(%ebp),%eax
f0101223:	8b 10                	mov    (%eax),%edx
f0101225:	b9 00 00 00 00       	mov    $0x0,%ecx
f010122a:	8d 40 04             	lea    0x4(%eax),%eax
f010122d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0101230:	b8 0a 00 00 00       	mov    $0xa,%eax
f0101235:	e9 e1 00 00 00       	jmp    f010131b <vprintfmt+0x4a4>
		return va_arg(*ap, unsigned long long);
f010123a:	8b 45 14             	mov    0x14(%ebp),%eax
f010123d:	8b 10                	mov    (%eax),%edx
f010123f:	8b 48 04             	mov    0x4(%eax),%ecx
f0101242:	8d 40 08             	lea    0x8(%eax),%eax
f0101245:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0101248:	b8 0a 00 00 00       	mov    $0xa,%eax
f010124d:	e9 c9 00 00 00       	jmp    f010131b <vprintfmt+0x4a4>
		return va_arg(*ap, unsigned int);
f0101252:	8b 45 14             	mov    0x14(%ebp),%eax
f0101255:	8b 10                	mov    (%eax),%edx
f0101257:	b9 00 00 00 00       	mov    $0x0,%ecx
f010125c:	8d 40 04             	lea    0x4(%eax),%eax
f010125f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0101262:	b8 0a 00 00 00       	mov    $0xa,%eax
f0101267:	e9 af 00 00 00       	jmp    f010131b <vprintfmt+0x4a4>
	if (lflag >= 2)
f010126c:	83 f9 01             	cmp    $0x1,%ecx
f010126f:	7f 1f                	jg     f0101290 <vprintfmt+0x419>
	else if (lflag)
f0101271:	85 c9                	test   %ecx,%ecx
f0101273:	74 61                	je     f01012d6 <vprintfmt+0x45f>
		return va_arg(*ap, long);
f0101275:	8b 45 14             	mov    0x14(%ebp),%eax
f0101278:	8b 30                	mov    (%eax),%esi
f010127a:	89 75 e0             	mov    %esi,-0x20(%ebp)
f010127d:	89 f0                	mov    %esi,%eax
f010127f:	c1 f8 1f             	sar    $0x1f,%eax
f0101282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101285:	8b 45 14             	mov    0x14(%ebp),%eax
f0101288:	8d 40 04             	lea    0x4(%eax),%eax
f010128b:	89 45 14             	mov    %eax,0x14(%ebp)
f010128e:	eb 17                	jmp    f01012a7 <vprintfmt+0x430>
		return va_arg(*ap, long long);
f0101290:	8b 45 14             	mov    0x14(%ebp),%eax
f0101293:	8b 50 04             	mov    0x4(%eax),%edx
f0101296:	8b 00                	mov    (%eax),%eax
f0101298:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010129b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010129e:	8b 45 14             	mov    0x14(%ebp),%eax
f01012a1:	8d 40 08             	lea    0x8(%eax),%eax
f01012a4:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01012a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01012aa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 8;
f01012ad:	b8 08 00 00 00       	mov    $0x8,%eax
			if ((long long) num < 0) {
f01012b2:	85 c9                	test   %ecx,%ecx
f01012b4:	79 65                	jns    f010131b <vprintfmt+0x4a4>
				putch('-', putdat);
f01012b6:	83 ec 08             	sub    $0x8,%esp
f01012b9:	57                   	push   %edi
f01012ba:	6a 2d                	push   $0x2d
f01012bc:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01012bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01012c2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01012c5:	f7 da                	neg    %edx
f01012c7:	83 d1 00             	adc    $0x0,%ecx
f01012ca:	f7 d9                	neg    %ecx
f01012cc:	83 c4 10             	add    $0x10,%esp
			base = 8;
f01012cf:	b8 08 00 00 00       	mov    $0x8,%eax
f01012d4:	eb 45                	jmp    f010131b <vprintfmt+0x4a4>
		return va_arg(*ap, int);
f01012d6:	8b 45 14             	mov    0x14(%ebp),%eax
f01012d9:	8b 30                	mov    (%eax),%esi
f01012db:	89 75 e0             	mov    %esi,-0x20(%ebp)
f01012de:	89 f0                	mov    %esi,%eax
f01012e0:	c1 f8 1f             	sar    $0x1f,%eax
f01012e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01012e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01012e9:	8d 40 04             	lea    0x4(%eax),%eax
f01012ec:	89 45 14             	mov    %eax,0x14(%ebp)
f01012ef:	eb b6                	jmp    f01012a7 <vprintfmt+0x430>
			putch('0', putdat);
f01012f1:	83 ec 08             	sub    $0x8,%esp
f01012f4:	57                   	push   %edi
f01012f5:	6a 30                	push   $0x30
f01012f7:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f01012fa:	83 c4 08             	add    $0x8,%esp
f01012fd:	57                   	push   %edi
f01012fe:	6a 78                	push   $0x78
f0101300:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f0101303:	8b 45 14             	mov    0x14(%ebp),%eax
f0101306:	8b 10                	mov    (%eax),%edx
f0101308:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010130d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0101310:	8d 40 04             	lea    0x4(%eax),%eax
f0101313:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101316:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010131b:	83 ec 0c             	sub    $0xc,%esp
f010131e:	0f be 75 d7          	movsbl -0x29(%ebp),%esi
f0101322:	56                   	push   %esi
f0101323:	ff 75 dc             	pushl  -0x24(%ebp)
f0101326:	50                   	push   %eax
f0101327:	51                   	push   %ecx
f0101328:	52                   	push   %edx
f0101329:	89 fa                	mov    %edi,%edx
f010132b:	8b 45 08             	mov    0x8(%ebp),%eax
f010132e:	e8 5c fa ff ff       	call   f0100d8f <printnum>
			break;
f0101333:	83 c4 20             	add    $0x20,%esp
f0101336:	e9 5a fb ff ff       	jmp    f0100e95 <vprintfmt+0x1e>
	if (lflag >= 2)
f010133b:	83 f9 01             	cmp    $0x1,%ecx
f010133e:	7f 1b                	jg     f010135b <vprintfmt+0x4e4>
	else if (lflag)
f0101340:	85 c9                	test   %ecx,%ecx
f0101342:	74 2c                	je     f0101370 <vprintfmt+0x4f9>
		return va_arg(*ap, unsigned long);
f0101344:	8b 45 14             	mov    0x14(%ebp),%eax
f0101347:	8b 10                	mov    (%eax),%edx
f0101349:	b9 00 00 00 00       	mov    $0x0,%ecx
f010134e:	8d 40 04             	lea    0x4(%eax),%eax
f0101351:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101354:	b8 10 00 00 00       	mov    $0x10,%eax
f0101359:	eb c0                	jmp    f010131b <vprintfmt+0x4a4>
		return va_arg(*ap, unsigned long long);
f010135b:	8b 45 14             	mov    0x14(%ebp),%eax
f010135e:	8b 10                	mov    (%eax),%edx
f0101360:	8b 48 04             	mov    0x4(%eax),%ecx
f0101363:	8d 40 08             	lea    0x8(%eax),%eax
f0101366:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101369:	b8 10 00 00 00       	mov    $0x10,%eax
f010136e:	eb ab                	jmp    f010131b <vprintfmt+0x4a4>
		return va_arg(*ap, unsigned int);
f0101370:	8b 45 14             	mov    0x14(%ebp),%eax
f0101373:	8b 10                	mov    (%eax),%edx
f0101375:	b9 00 00 00 00       	mov    $0x0,%ecx
f010137a:	8d 40 04             	lea    0x4(%eax),%eax
f010137d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101380:	b8 10 00 00 00       	mov    $0x10,%eax
f0101385:	eb 94                	jmp    f010131b <vprintfmt+0x4a4>
			putch(ch, putdat);
f0101387:	83 ec 08             	sub    $0x8,%esp
f010138a:	57                   	push   %edi
f010138b:	6a 25                	push   $0x25
f010138d:	ff 55 08             	call   *0x8(%ebp)
			break;
f0101390:	83 c4 10             	add    $0x10,%esp
f0101393:	e9 fd fa ff ff       	jmp    f0100e95 <vprintfmt+0x1e>
			putch('%', putdat);
f0101398:	83 ec 08             	sub    $0x8,%esp
f010139b:	57                   	push   %edi
f010139c:	6a 25                	push   $0x25
f010139e:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f01013a1:	83 c4 10             	add    $0x10,%esp
f01013a4:	89 f3                	mov    %esi,%ebx
f01013a6:	eb 03                	jmp    f01013ab <vprintfmt+0x534>
f01013a8:	83 eb 01             	sub    $0x1,%ebx
f01013ab:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f01013af:	75 f7                	jne    f01013a8 <vprintfmt+0x531>
f01013b1:	e9 df fa ff ff       	jmp    f0100e95 <vprintfmt+0x1e>
}
f01013b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01013b9:	5b                   	pop    %ebx
f01013ba:	5e                   	pop    %esi
f01013bb:	5f                   	pop    %edi
f01013bc:	5d                   	pop    %ebp
f01013bd:	c3                   	ret    

f01013be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01013be:	55                   	push   %ebp
f01013bf:	89 e5                	mov    %esp,%ebp
f01013c1:	83 ec 18             	sub    $0x18,%esp
f01013c4:	8b 45 08             	mov    0x8(%ebp),%eax
f01013c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01013ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01013cd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01013d1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01013d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01013db:	85 c0                	test   %eax,%eax
f01013dd:	74 26                	je     f0101405 <vsnprintf+0x47>
f01013df:	85 d2                	test   %edx,%edx
f01013e1:	7e 22                	jle    f0101405 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01013e3:	ff 75 14             	pushl  0x14(%ebp)
f01013e6:	ff 75 10             	pushl  0x10(%ebp)
f01013e9:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01013ec:	50                   	push   %eax
f01013ed:	68 3d 0e 10 f0       	push   $0xf0100e3d
f01013f2:	e8 80 fa ff ff       	call   f0100e77 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01013f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01013fa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01013fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101400:	83 c4 10             	add    $0x10,%esp
}
f0101403:	c9                   	leave  
f0101404:	c3                   	ret    
		return -E_INVAL;
f0101405:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010140a:	eb f7                	jmp    f0101403 <vsnprintf+0x45>

f010140c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010140c:	55                   	push   %ebp
f010140d:	89 e5                	mov    %esp,%ebp
f010140f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0101412:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0101415:	50                   	push   %eax
f0101416:	ff 75 10             	pushl  0x10(%ebp)
f0101419:	ff 75 0c             	pushl  0xc(%ebp)
f010141c:	ff 75 08             	pushl  0x8(%ebp)
f010141f:	e8 9a ff ff ff       	call   f01013be <vsnprintf>
	va_end(ap);

	return rc;
}
f0101424:	c9                   	leave  
f0101425:	c3                   	ret    

f0101426 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0101426:	55                   	push   %ebp
f0101427:	89 e5                	mov    %esp,%ebp
f0101429:	57                   	push   %edi
f010142a:	56                   	push   %esi
f010142b:	53                   	push   %ebx
f010142c:	83 ec 0c             	sub    $0xc,%esp
f010142f:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0101432:	85 c0                	test   %eax,%eax
f0101434:	74 11                	je     f0101447 <readline+0x21>
		cprintf("%s", prompt);
f0101436:	83 ec 08             	sub    $0x8,%esp
f0101439:	50                   	push   %eax
f010143a:	68 e2 1b 10 f0       	push   $0xf0101be2
f010143f:	e8 c9 f5 ff ff       	call   f0100a0d <cprintf>
f0101444:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0101447:	83 ec 0c             	sub    $0xc,%esp
f010144a:	6a 00                	push   $0x0
f010144c:	e8 d0 f2 ff ff       	call   f0100721 <iscons>
f0101451:	89 c7                	mov    %eax,%edi
f0101453:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0101456:	be 00 00 00 00       	mov    $0x0,%esi
f010145b:	eb 4b                	jmp    f01014a8 <readline+0x82>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f010145d:	83 ec 08             	sub    $0x8,%esp
f0101460:	50                   	push   %eax
f0101461:	68 4a 23 10 f0       	push   $0xf010234a
f0101466:	e8 a2 f5 ff ff       	call   f0100a0d <cprintf>
			return NULL;
f010146b:	83 c4 10             	add    $0x10,%esp
f010146e:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0101473:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101476:	5b                   	pop    %ebx
f0101477:	5e                   	pop    %esi
f0101478:	5f                   	pop    %edi
f0101479:	5d                   	pop    %ebp
f010147a:	c3                   	ret    
			if (echoing)
f010147b:	85 ff                	test   %edi,%edi
f010147d:	75 05                	jne    f0101484 <readline+0x5e>
			i--;
f010147f:	83 ee 01             	sub    $0x1,%esi
f0101482:	eb 24                	jmp    f01014a8 <readline+0x82>
				cputchar('\b');
f0101484:	83 ec 0c             	sub    $0xc,%esp
f0101487:	6a 08                	push   $0x8
f0101489:	e8 72 f2 ff ff       	call   f0100700 <cputchar>
f010148e:	83 c4 10             	add    $0x10,%esp
f0101491:	eb ec                	jmp    f010147f <readline+0x59>
				cputchar(c);
f0101493:	83 ec 0c             	sub    $0xc,%esp
f0101496:	53                   	push   %ebx
f0101497:	e8 64 f2 ff ff       	call   f0100700 <cputchar>
f010149c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f010149f:	88 9e 60 35 11 f0    	mov    %bl,-0xfeecaa0(%esi)
f01014a5:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01014a8:	e8 63 f2 ff ff       	call   f0100710 <getchar>
f01014ad:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01014af:	85 c0                	test   %eax,%eax
f01014b1:	78 aa                	js     f010145d <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01014b3:	83 f8 08             	cmp    $0x8,%eax
f01014b6:	0f 94 c2             	sete   %dl
f01014b9:	83 f8 7f             	cmp    $0x7f,%eax
f01014bc:	0f 94 c0             	sete   %al
f01014bf:	08 c2                	or     %al,%dl
f01014c1:	74 04                	je     f01014c7 <readline+0xa1>
f01014c3:	85 f6                	test   %esi,%esi
f01014c5:	7f b4                	jg     f010147b <readline+0x55>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01014c7:	83 fb 1f             	cmp    $0x1f,%ebx
f01014ca:	7e 0e                	jle    f01014da <readline+0xb4>
f01014cc:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01014d2:	7f 06                	jg     f01014da <readline+0xb4>
			if (echoing)
f01014d4:	85 ff                	test   %edi,%edi
f01014d6:	74 c7                	je     f010149f <readline+0x79>
f01014d8:	eb b9                	jmp    f0101493 <readline+0x6d>
		} else if (c == '\n' || c == '\r') {
f01014da:	83 fb 0a             	cmp    $0xa,%ebx
f01014dd:	74 05                	je     f01014e4 <readline+0xbe>
f01014df:	83 fb 0d             	cmp    $0xd,%ebx
f01014e2:	75 c4                	jne    f01014a8 <readline+0x82>
			if (echoing)
f01014e4:	85 ff                	test   %edi,%edi
f01014e6:	75 11                	jne    f01014f9 <readline+0xd3>
			buf[i] = 0;
f01014e8:	c6 86 60 35 11 f0 00 	movb   $0x0,-0xfeecaa0(%esi)
			return buf;
f01014ef:	b8 60 35 11 f0       	mov    $0xf0113560,%eax
f01014f4:	e9 7a ff ff ff       	jmp    f0101473 <readline+0x4d>
				cputchar('\n');
f01014f9:	83 ec 0c             	sub    $0xc,%esp
f01014fc:	6a 0a                	push   $0xa
f01014fe:	e8 fd f1 ff ff       	call   f0100700 <cputchar>
f0101503:	83 c4 10             	add    $0x10,%esp
f0101506:	eb e0                	jmp    f01014e8 <readline+0xc2>

f0101508 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0101508:	55                   	push   %ebp
f0101509:	89 e5                	mov    %esp,%ebp
f010150b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010150e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101513:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0101517:	74 05                	je     f010151e <strlen+0x16>
		n++;
f0101519:	83 c0 01             	add    $0x1,%eax
f010151c:	eb f5                	jmp    f0101513 <strlen+0xb>
	return n;
}
f010151e:	5d                   	pop    %ebp
f010151f:	c3                   	ret    

f0101520 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0101520:	55                   	push   %ebp
f0101521:	89 e5                	mov    %esp,%ebp
f0101523:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101526:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0101529:	ba 00 00 00 00       	mov    $0x0,%edx
f010152e:	39 c2                	cmp    %eax,%edx
f0101530:	74 0d                	je     f010153f <strnlen+0x1f>
f0101532:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0101536:	74 05                	je     f010153d <strnlen+0x1d>
		n++;
f0101538:	83 c2 01             	add    $0x1,%edx
f010153b:	eb f1                	jmp    f010152e <strnlen+0xe>
f010153d:	89 d0                	mov    %edx,%eax
	return n;
}
f010153f:	5d                   	pop    %ebp
f0101540:	c3                   	ret    

f0101541 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0101541:	55                   	push   %ebp
f0101542:	89 e5                	mov    %esp,%ebp
f0101544:	53                   	push   %ebx
f0101545:	8b 45 08             	mov    0x8(%ebp),%eax
f0101548:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010154b:	ba 00 00 00 00       	mov    $0x0,%edx
f0101550:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0101554:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0101557:	83 c2 01             	add    $0x1,%edx
f010155a:	84 c9                	test   %cl,%cl
f010155c:	75 f2                	jne    f0101550 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f010155e:	5b                   	pop    %ebx
f010155f:	5d                   	pop    %ebp
f0101560:	c3                   	ret    

f0101561 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0101561:	55                   	push   %ebp
f0101562:	89 e5                	mov    %esp,%ebp
f0101564:	53                   	push   %ebx
f0101565:	83 ec 10             	sub    $0x10,%esp
f0101568:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f010156b:	53                   	push   %ebx
f010156c:	e8 97 ff ff ff       	call   f0101508 <strlen>
f0101571:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0101574:	ff 75 0c             	pushl  0xc(%ebp)
f0101577:	01 d8                	add    %ebx,%eax
f0101579:	50                   	push   %eax
f010157a:	e8 c2 ff ff ff       	call   f0101541 <strcpy>
	return dst;
}
f010157f:	89 d8                	mov    %ebx,%eax
f0101581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101584:	c9                   	leave  
f0101585:	c3                   	ret    

f0101586 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0101586:	55                   	push   %ebp
f0101587:	89 e5                	mov    %esp,%ebp
f0101589:	56                   	push   %esi
f010158a:	53                   	push   %ebx
f010158b:	8b 45 08             	mov    0x8(%ebp),%eax
f010158e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101591:	89 c6                	mov    %eax,%esi
f0101593:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0101596:	89 c2                	mov    %eax,%edx
f0101598:	39 f2                	cmp    %esi,%edx
f010159a:	74 11                	je     f01015ad <strncpy+0x27>
		*dst++ = *src;
f010159c:	83 c2 01             	add    $0x1,%edx
f010159f:	0f b6 19             	movzbl (%ecx),%ebx
f01015a2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01015a5:	80 fb 01             	cmp    $0x1,%bl
f01015a8:	83 d9 ff             	sbb    $0xffffffff,%ecx
f01015ab:	eb eb                	jmp    f0101598 <strncpy+0x12>
	}
	return ret;
}
f01015ad:	5b                   	pop    %ebx
f01015ae:	5e                   	pop    %esi
f01015af:	5d                   	pop    %ebp
f01015b0:	c3                   	ret    

f01015b1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01015b1:	55                   	push   %ebp
f01015b2:	89 e5                	mov    %esp,%ebp
f01015b4:	56                   	push   %esi
f01015b5:	53                   	push   %ebx
f01015b6:	8b 75 08             	mov    0x8(%ebp),%esi
f01015b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01015bc:	8b 55 10             	mov    0x10(%ebp),%edx
f01015bf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01015c1:	85 d2                	test   %edx,%edx
f01015c3:	74 21                	je     f01015e6 <strlcpy+0x35>
f01015c5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01015c9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01015cb:	39 c2                	cmp    %eax,%edx
f01015cd:	74 14                	je     f01015e3 <strlcpy+0x32>
f01015cf:	0f b6 19             	movzbl (%ecx),%ebx
f01015d2:	84 db                	test   %bl,%bl
f01015d4:	74 0b                	je     f01015e1 <strlcpy+0x30>
			*dst++ = *src++;
f01015d6:	83 c1 01             	add    $0x1,%ecx
f01015d9:	83 c2 01             	add    $0x1,%edx
f01015dc:	88 5a ff             	mov    %bl,-0x1(%edx)
f01015df:	eb ea                	jmp    f01015cb <strlcpy+0x1a>
f01015e1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f01015e3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01015e6:	29 f0                	sub    %esi,%eax
}
f01015e8:	5b                   	pop    %ebx
f01015e9:	5e                   	pop    %esi
f01015ea:	5d                   	pop    %ebp
f01015eb:	c3                   	ret    

f01015ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01015ec:	55                   	push   %ebp
f01015ed:	89 e5                	mov    %esp,%ebp
f01015ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01015f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01015f5:	0f b6 01             	movzbl (%ecx),%eax
f01015f8:	84 c0                	test   %al,%al
f01015fa:	74 0c                	je     f0101608 <strcmp+0x1c>
f01015fc:	3a 02                	cmp    (%edx),%al
f01015fe:	75 08                	jne    f0101608 <strcmp+0x1c>
		p++, q++;
f0101600:	83 c1 01             	add    $0x1,%ecx
f0101603:	83 c2 01             	add    $0x1,%edx
f0101606:	eb ed                	jmp    f01015f5 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0101608:	0f b6 c0             	movzbl %al,%eax
f010160b:	0f b6 12             	movzbl (%edx),%edx
f010160e:	29 d0                	sub    %edx,%eax
}
f0101610:	5d                   	pop    %ebp
f0101611:	c3                   	ret    

f0101612 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0101612:	55                   	push   %ebp
f0101613:	89 e5                	mov    %esp,%ebp
f0101615:	53                   	push   %ebx
f0101616:	8b 45 08             	mov    0x8(%ebp),%eax
f0101619:	8b 55 0c             	mov    0xc(%ebp),%edx
f010161c:	89 c3                	mov    %eax,%ebx
f010161e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0101621:	eb 06                	jmp    f0101629 <strncmp+0x17>
		n--, p++, q++;
f0101623:	83 c0 01             	add    $0x1,%eax
f0101626:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0101629:	39 d8                	cmp    %ebx,%eax
f010162b:	74 16                	je     f0101643 <strncmp+0x31>
f010162d:	0f b6 08             	movzbl (%eax),%ecx
f0101630:	84 c9                	test   %cl,%cl
f0101632:	74 04                	je     f0101638 <strncmp+0x26>
f0101634:	3a 0a                	cmp    (%edx),%cl
f0101636:	74 eb                	je     f0101623 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0101638:	0f b6 00             	movzbl (%eax),%eax
f010163b:	0f b6 12             	movzbl (%edx),%edx
f010163e:	29 d0                	sub    %edx,%eax
}
f0101640:	5b                   	pop    %ebx
f0101641:	5d                   	pop    %ebp
f0101642:	c3                   	ret    
		return 0;
f0101643:	b8 00 00 00 00       	mov    $0x0,%eax
f0101648:	eb f6                	jmp    f0101640 <strncmp+0x2e>

f010164a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010164a:	55                   	push   %ebp
f010164b:	89 e5                	mov    %esp,%ebp
f010164d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101650:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101654:	0f b6 10             	movzbl (%eax),%edx
f0101657:	84 d2                	test   %dl,%dl
f0101659:	74 09                	je     f0101664 <strchr+0x1a>
		if (*s == c)
f010165b:	38 ca                	cmp    %cl,%dl
f010165d:	74 0a                	je     f0101669 <strchr+0x1f>
	for (; *s; s++)
f010165f:	83 c0 01             	add    $0x1,%eax
f0101662:	eb f0                	jmp    f0101654 <strchr+0xa>
			return (char *) s;
	return 0;
f0101664:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101669:	5d                   	pop    %ebp
f010166a:	c3                   	ret    

f010166b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010166b:	55                   	push   %ebp
f010166c:	89 e5                	mov    %esp,%ebp
f010166e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101671:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101675:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0101678:	38 ca                	cmp    %cl,%dl
f010167a:	74 09                	je     f0101685 <strfind+0x1a>
f010167c:	84 d2                	test   %dl,%dl
f010167e:	74 05                	je     f0101685 <strfind+0x1a>
	for (; *s; s++)
f0101680:	83 c0 01             	add    $0x1,%eax
f0101683:	eb f0                	jmp    f0101675 <strfind+0xa>
			break;
	return (char *) s;
}
f0101685:	5d                   	pop    %ebp
f0101686:	c3                   	ret    

f0101687 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0101687:	55                   	push   %ebp
f0101688:	89 e5                	mov    %esp,%ebp
f010168a:	57                   	push   %edi
f010168b:	56                   	push   %esi
f010168c:	53                   	push   %ebx
f010168d:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101690:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0101693:	85 c9                	test   %ecx,%ecx
f0101695:	74 31                	je     f01016c8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0101697:	89 f8                	mov    %edi,%eax
f0101699:	09 c8                	or     %ecx,%eax
f010169b:	a8 03                	test   $0x3,%al
f010169d:	75 23                	jne    f01016c2 <memset+0x3b>
		c &= 0xFF;
f010169f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01016a3:	89 d3                	mov    %edx,%ebx
f01016a5:	c1 e3 08             	shl    $0x8,%ebx
f01016a8:	89 d0                	mov    %edx,%eax
f01016aa:	c1 e0 18             	shl    $0x18,%eax
f01016ad:	89 d6                	mov    %edx,%esi
f01016af:	c1 e6 10             	shl    $0x10,%esi
f01016b2:	09 f0                	or     %esi,%eax
f01016b4:	09 c2                	or     %eax,%edx
f01016b6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01016b8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01016bb:	89 d0                	mov    %edx,%eax
f01016bd:	fc                   	cld    
f01016be:	f3 ab                	rep stos %eax,%es:(%edi)
f01016c0:	eb 06                	jmp    f01016c8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01016c2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016c5:	fc                   	cld    
f01016c6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01016c8:	89 f8                	mov    %edi,%eax
f01016ca:	5b                   	pop    %ebx
f01016cb:	5e                   	pop    %esi
f01016cc:	5f                   	pop    %edi
f01016cd:	5d                   	pop    %ebp
f01016ce:	c3                   	ret    

f01016cf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01016cf:	55                   	push   %ebp
f01016d0:	89 e5                	mov    %esp,%ebp
f01016d2:	57                   	push   %edi
f01016d3:	56                   	push   %esi
f01016d4:	8b 45 08             	mov    0x8(%ebp),%eax
f01016d7:	8b 75 0c             	mov    0xc(%ebp),%esi
f01016da:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01016dd:	39 c6                	cmp    %eax,%esi
f01016df:	73 32                	jae    f0101713 <memmove+0x44>
f01016e1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01016e4:	39 c2                	cmp    %eax,%edx
f01016e6:	76 2b                	jbe    f0101713 <memmove+0x44>
		s += n;
		d += n;
f01016e8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01016eb:	89 fe                	mov    %edi,%esi
f01016ed:	09 ce                	or     %ecx,%esi
f01016ef:	09 d6                	or     %edx,%esi
f01016f1:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01016f7:	75 0e                	jne    f0101707 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f01016f9:	83 ef 04             	sub    $0x4,%edi
f01016fc:	8d 72 fc             	lea    -0x4(%edx),%esi
f01016ff:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0101702:	fd                   	std    
f0101703:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0101705:	eb 09                	jmp    f0101710 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0101707:	83 ef 01             	sub    $0x1,%edi
f010170a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010170d:	fd                   	std    
f010170e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0101710:	fc                   	cld    
f0101711:	eb 1a                	jmp    f010172d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101713:	89 c2                	mov    %eax,%edx
f0101715:	09 ca                	or     %ecx,%edx
f0101717:	09 f2                	or     %esi,%edx
f0101719:	f6 c2 03             	test   $0x3,%dl
f010171c:	75 0a                	jne    f0101728 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010171e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0101721:	89 c7                	mov    %eax,%edi
f0101723:	fc                   	cld    
f0101724:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0101726:	eb 05                	jmp    f010172d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0101728:	89 c7                	mov    %eax,%edi
f010172a:	fc                   	cld    
f010172b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010172d:	5e                   	pop    %esi
f010172e:	5f                   	pop    %edi
f010172f:	5d                   	pop    %ebp
f0101730:	c3                   	ret    

f0101731 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0101731:	55                   	push   %ebp
f0101732:	89 e5                	mov    %esp,%ebp
f0101734:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0101737:	ff 75 10             	pushl  0x10(%ebp)
f010173a:	ff 75 0c             	pushl  0xc(%ebp)
f010173d:	ff 75 08             	pushl  0x8(%ebp)
f0101740:	e8 8a ff ff ff       	call   f01016cf <memmove>
}
f0101745:	c9                   	leave  
f0101746:	c3                   	ret    

f0101747 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0101747:	55                   	push   %ebp
f0101748:	89 e5                	mov    %esp,%ebp
f010174a:	56                   	push   %esi
f010174b:	53                   	push   %ebx
f010174c:	8b 45 08             	mov    0x8(%ebp),%eax
f010174f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101752:	89 c6                	mov    %eax,%esi
f0101754:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101757:	39 f0                	cmp    %esi,%eax
f0101759:	74 1c                	je     f0101777 <memcmp+0x30>
		if (*s1 != *s2)
f010175b:	0f b6 08             	movzbl (%eax),%ecx
f010175e:	0f b6 1a             	movzbl (%edx),%ebx
f0101761:	38 d9                	cmp    %bl,%cl
f0101763:	75 08                	jne    f010176d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0101765:	83 c0 01             	add    $0x1,%eax
f0101768:	83 c2 01             	add    $0x1,%edx
f010176b:	eb ea                	jmp    f0101757 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f010176d:	0f b6 c1             	movzbl %cl,%eax
f0101770:	0f b6 db             	movzbl %bl,%ebx
f0101773:	29 d8                	sub    %ebx,%eax
f0101775:	eb 05                	jmp    f010177c <memcmp+0x35>
	}

	return 0;
f0101777:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010177c:	5b                   	pop    %ebx
f010177d:	5e                   	pop    %esi
f010177e:	5d                   	pop    %ebp
f010177f:	c3                   	ret    

f0101780 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0101780:	55                   	push   %ebp
f0101781:	89 e5                	mov    %esp,%ebp
f0101783:	8b 45 08             	mov    0x8(%ebp),%eax
f0101786:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0101789:	89 c2                	mov    %eax,%edx
f010178b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f010178e:	39 d0                	cmp    %edx,%eax
f0101790:	73 09                	jae    f010179b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0101792:	38 08                	cmp    %cl,(%eax)
f0101794:	74 05                	je     f010179b <memfind+0x1b>
	for (; s < ends; s++)
f0101796:	83 c0 01             	add    $0x1,%eax
f0101799:	eb f3                	jmp    f010178e <memfind+0xe>
			break;
	return (void *) s;
}
f010179b:	5d                   	pop    %ebp
f010179c:	c3                   	ret    

f010179d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f010179d:	55                   	push   %ebp
f010179e:	89 e5                	mov    %esp,%ebp
f01017a0:	57                   	push   %edi
f01017a1:	56                   	push   %esi
f01017a2:	53                   	push   %ebx
f01017a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01017a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01017a9:	eb 03                	jmp    f01017ae <strtol+0x11>
		s++;
f01017ab:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01017ae:	0f b6 01             	movzbl (%ecx),%eax
f01017b1:	3c 20                	cmp    $0x20,%al
f01017b3:	74 f6                	je     f01017ab <strtol+0xe>
f01017b5:	3c 09                	cmp    $0x9,%al
f01017b7:	74 f2                	je     f01017ab <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01017b9:	3c 2b                	cmp    $0x2b,%al
f01017bb:	74 2a                	je     f01017e7 <strtol+0x4a>
	int neg = 0;
f01017bd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01017c2:	3c 2d                	cmp    $0x2d,%al
f01017c4:	74 2b                	je     f01017f1 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01017c6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01017cc:	75 0f                	jne    f01017dd <strtol+0x40>
f01017ce:	80 39 30             	cmpb   $0x30,(%ecx)
f01017d1:	74 28                	je     f01017fb <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01017d3:	85 db                	test   %ebx,%ebx
f01017d5:	b8 0a 00 00 00       	mov    $0xa,%eax
f01017da:	0f 44 d8             	cmove  %eax,%ebx
f01017dd:	b8 00 00 00 00       	mov    $0x0,%eax
f01017e2:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01017e5:	eb 50                	jmp    f0101837 <strtol+0x9a>
		s++;
f01017e7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f01017ea:	bf 00 00 00 00       	mov    $0x0,%edi
f01017ef:	eb d5                	jmp    f01017c6 <strtol+0x29>
		s++, neg = 1;
f01017f1:	83 c1 01             	add    $0x1,%ecx
f01017f4:	bf 01 00 00 00       	mov    $0x1,%edi
f01017f9:	eb cb                	jmp    f01017c6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01017fb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f01017ff:	74 0e                	je     f010180f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f0101801:	85 db                	test   %ebx,%ebx
f0101803:	75 d8                	jne    f01017dd <strtol+0x40>
		s++, base = 8;
f0101805:	83 c1 01             	add    $0x1,%ecx
f0101808:	bb 08 00 00 00       	mov    $0x8,%ebx
f010180d:	eb ce                	jmp    f01017dd <strtol+0x40>
		s += 2, base = 16;
f010180f:	83 c1 02             	add    $0x2,%ecx
f0101812:	bb 10 00 00 00       	mov    $0x10,%ebx
f0101817:	eb c4                	jmp    f01017dd <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0101819:	8d 72 9f             	lea    -0x61(%edx),%esi
f010181c:	89 f3                	mov    %esi,%ebx
f010181e:	80 fb 19             	cmp    $0x19,%bl
f0101821:	77 29                	ja     f010184c <strtol+0xaf>
			dig = *s - 'a' + 10;
f0101823:	0f be d2             	movsbl %dl,%edx
f0101826:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0101829:	3b 55 10             	cmp    0x10(%ebp),%edx
f010182c:	7d 30                	jge    f010185e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010182e:	83 c1 01             	add    $0x1,%ecx
f0101831:	0f af 45 10          	imul   0x10(%ebp),%eax
f0101835:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0101837:	0f b6 11             	movzbl (%ecx),%edx
f010183a:	8d 72 d0             	lea    -0x30(%edx),%esi
f010183d:	89 f3                	mov    %esi,%ebx
f010183f:	80 fb 09             	cmp    $0x9,%bl
f0101842:	77 d5                	ja     f0101819 <strtol+0x7c>
			dig = *s - '0';
f0101844:	0f be d2             	movsbl %dl,%edx
f0101847:	83 ea 30             	sub    $0x30,%edx
f010184a:	eb dd                	jmp    f0101829 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f010184c:	8d 72 bf             	lea    -0x41(%edx),%esi
f010184f:	89 f3                	mov    %esi,%ebx
f0101851:	80 fb 19             	cmp    $0x19,%bl
f0101854:	77 08                	ja     f010185e <strtol+0xc1>
			dig = *s - 'A' + 10;
f0101856:	0f be d2             	movsbl %dl,%edx
f0101859:	83 ea 37             	sub    $0x37,%edx
f010185c:	eb cb                	jmp    f0101829 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f010185e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101862:	74 05                	je     f0101869 <strtol+0xcc>
		*endptr = (char *) s;
f0101864:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101867:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0101869:	89 c2                	mov    %eax,%edx
f010186b:	f7 da                	neg    %edx
f010186d:	85 ff                	test   %edi,%edi
f010186f:	0f 45 c2             	cmovne %edx,%eax
}
f0101872:	5b                   	pop    %ebx
f0101873:	5e                   	pop    %esi
f0101874:	5f                   	pop    %edi
f0101875:	5d                   	pop    %ebp
f0101876:	c3                   	ret    
f0101877:	66 90                	xchg   %ax,%ax
f0101879:	66 90                	xchg   %ax,%ax
f010187b:	66 90                	xchg   %ax,%ax
f010187d:	66 90                	xchg   %ax,%ax
f010187f:	90                   	nop

f0101880 <__udivdi3>:
f0101880:	f3 0f 1e fb          	endbr32 
f0101884:	55                   	push   %ebp
f0101885:	57                   	push   %edi
f0101886:	56                   	push   %esi
f0101887:	53                   	push   %ebx
f0101888:	83 ec 1c             	sub    $0x1c,%esp
f010188b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010188f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0101893:	8b 74 24 34          	mov    0x34(%esp),%esi
f0101897:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f010189b:	85 d2                	test   %edx,%edx
f010189d:	75 49                	jne    f01018e8 <__udivdi3+0x68>
f010189f:	39 f3                	cmp    %esi,%ebx
f01018a1:	76 15                	jbe    f01018b8 <__udivdi3+0x38>
f01018a3:	31 ff                	xor    %edi,%edi
f01018a5:	89 e8                	mov    %ebp,%eax
f01018a7:	89 f2                	mov    %esi,%edx
f01018a9:	f7 f3                	div    %ebx
f01018ab:	89 fa                	mov    %edi,%edx
f01018ad:	83 c4 1c             	add    $0x1c,%esp
f01018b0:	5b                   	pop    %ebx
f01018b1:	5e                   	pop    %esi
f01018b2:	5f                   	pop    %edi
f01018b3:	5d                   	pop    %ebp
f01018b4:	c3                   	ret    
f01018b5:	8d 76 00             	lea    0x0(%esi),%esi
f01018b8:	89 d9                	mov    %ebx,%ecx
f01018ba:	85 db                	test   %ebx,%ebx
f01018bc:	75 0b                	jne    f01018c9 <__udivdi3+0x49>
f01018be:	b8 01 00 00 00       	mov    $0x1,%eax
f01018c3:	31 d2                	xor    %edx,%edx
f01018c5:	f7 f3                	div    %ebx
f01018c7:	89 c1                	mov    %eax,%ecx
f01018c9:	31 d2                	xor    %edx,%edx
f01018cb:	89 f0                	mov    %esi,%eax
f01018cd:	f7 f1                	div    %ecx
f01018cf:	89 c6                	mov    %eax,%esi
f01018d1:	89 e8                	mov    %ebp,%eax
f01018d3:	89 f7                	mov    %esi,%edi
f01018d5:	f7 f1                	div    %ecx
f01018d7:	89 fa                	mov    %edi,%edx
f01018d9:	83 c4 1c             	add    $0x1c,%esp
f01018dc:	5b                   	pop    %ebx
f01018dd:	5e                   	pop    %esi
f01018de:	5f                   	pop    %edi
f01018df:	5d                   	pop    %ebp
f01018e0:	c3                   	ret    
f01018e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01018e8:	39 f2                	cmp    %esi,%edx
f01018ea:	77 1c                	ja     f0101908 <__udivdi3+0x88>
f01018ec:	0f bd fa             	bsr    %edx,%edi
f01018ef:	83 f7 1f             	xor    $0x1f,%edi
f01018f2:	75 2c                	jne    f0101920 <__udivdi3+0xa0>
f01018f4:	39 f2                	cmp    %esi,%edx
f01018f6:	72 06                	jb     f01018fe <__udivdi3+0x7e>
f01018f8:	31 c0                	xor    %eax,%eax
f01018fa:	39 eb                	cmp    %ebp,%ebx
f01018fc:	77 ad                	ja     f01018ab <__udivdi3+0x2b>
f01018fe:	b8 01 00 00 00       	mov    $0x1,%eax
f0101903:	eb a6                	jmp    f01018ab <__udivdi3+0x2b>
f0101905:	8d 76 00             	lea    0x0(%esi),%esi
f0101908:	31 ff                	xor    %edi,%edi
f010190a:	31 c0                	xor    %eax,%eax
f010190c:	89 fa                	mov    %edi,%edx
f010190e:	83 c4 1c             	add    $0x1c,%esp
f0101911:	5b                   	pop    %ebx
f0101912:	5e                   	pop    %esi
f0101913:	5f                   	pop    %edi
f0101914:	5d                   	pop    %ebp
f0101915:	c3                   	ret    
f0101916:	8d 76 00             	lea    0x0(%esi),%esi
f0101919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0101920:	89 f9                	mov    %edi,%ecx
f0101922:	b8 20 00 00 00       	mov    $0x20,%eax
f0101927:	29 f8                	sub    %edi,%eax
f0101929:	d3 e2                	shl    %cl,%edx
f010192b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010192f:	89 c1                	mov    %eax,%ecx
f0101931:	89 da                	mov    %ebx,%edx
f0101933:	d3 ea                	shr    %cl,%edx
f0101935:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0101939:	09 d1                	or     %edx,%ecx
f010193b:	89 f2                	mov    %esi,%edx
f010193d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0101941:	89 f9                	mov    %edi,%ecx
f0101943:	d3 e3                	shl    %cl,%ebx
f0101945:	89 c1                	mov    %eax,%ecx
f0101947:	d3 ea                	shr    %cl,%edx
f0101949:	89 f9                	mov    %edi,%ecx
f010194b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010194f:	89 eb                	mov    %ebp,%ebx
f0101951:	d3 e6                	shl    %cl,%esi
f0101953:	89 c1                	mov    %eax,%ecx
f0101955:	d3 eb                	shr    %cl,%ebx
f0101957:	09 de                	or     %ebx,%esi
f0101959:	89 f0                	mov    %esi,%eax
f010195b:	f7 74 24 08          	divl   0x8(%esp)
f010195f:	89 d6                	mov    %edx,%esi
f0101961:	89 c3                	mov    %eax,%ebx
f0101963:	f7 64 24 0c          	mull   0xc(%esp)
f0101967:	39 d6                	cmp    %edx,%esi
f0101969:	72 15                	jb     f0101980 <__udivdi3+0x100>
f010196b:	89 f9                	mov    %edi,%ecx
f010196d:	d3 e5                	shl    %cl,%ebp
f010196f:	39 c5                	cmp    %eax,%ebp
f0101971:	73 04                	jae    f0101977 <__udivdi3+0xf7>
f0101973:	39 d6                	cmp    %edx,%esi
f0101975:	74 09                	je     f0101980 <__udivdi3+0x100>
f0101977:	89 d8                	mov    %ebx,%eax
f0101979:	31 ff                	xor    %edi,%edi
f010197b:	e9 2b ff ff ff       	jmp    f01018ab <__udivdi3+0x2b>
f0101980:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0101983:	31 ff                	xor    %edi,%edi
f0101985:	e9 21 ff ff ff       	jmp    f01018ab <__udivdi3+0x2b>
f010198a:	66 90                	xchg   %ax,%ax
f010198c:	66 90                	xchg   %ax,%ax
f010198e:	66 90                	xchg   %ax,%ax

f0101990 <__umoddi3>:
f0101990:	f3 0f 1e fb          	endbr32 
f0101994:	55                   	push   %ebp
f0101995:	57                   	push   %edi
f0101996:	56                   	push   %esi
f0101997:	53                   	push   %ebx
f0101998:	83 ec 1c             	sub    $0x1c,%esp
f010199b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f010199f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01019a3:	8b 74 24 30          	mov    0x30(%esp),%esi
f01019a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01019ab:	89 da                	mov    %ebx,%edx
f01019ad:	85 c0                	test   %eax,%eax
f01019af:	75 3f                	jne    f01019f0 <__umoddi3+0x60>
f01019b1:	39 df                	cmp    %ebx,%edi
f01019b3:	76 13                	jbe    f01019c8 <__umoddi3+0x38>
f01019b5:	89 f0                	mov    %esi,%eax
f01019b7:	f7 f7                	div    %edi
f01019b9:	89 d0                	mov    %edx,%eax
f01019bb:	31 d2                	xor    %edx,%edx
f01019bd:	83 c4 1c             	add    $0x1c,%esp
f01019c0:	5b                   	pop    %ebx
f01019c1:	5e                   	pop    %esi
f01019c2:	5f                   	pop    %edi
f01019c3:	5d                   	pop    %ebp
f01019c4:	c3                   	ret    
f01019c5:	8d 76 00             	lea    0x0(%esi),%esi
f01019c8:	89 fd                	mov    %edi,%ebp
f01019ca:	85 ff                	test   %edi,%edi
f01019cc:	75 0b                	jne    f01019d9 <__umoddi3+0x49>
f01019ce:	b8 01 00 00 00       	mov    $0x1,%eax
f01019d3:	31 d2                	xor    %edx,%edx
f01019d5:	f7 f7                	div    %edi
f01019d7:	89 c5                	mov    %eax,%ebp
f01019d9:	89 d8                	mov    %ebx,%eax
f01019db:	31 d2                	xor    %edx,%edx
f01019dd:	f7 f5                	div    %ebp
f01019df:	89 f0                	mov    %esi,%eax
f01019e1:	f7 f5                	div    %ebp
f01019e3:	89 d0                	mov    %edx,%eax
f01019e5:	eb d4                	jmp    f01019bb <__umoddi3+0x2b>
f01019e7:	89 f6                	mov    %esi,%esi
f01019e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f01019f0:	89 f1                	mov    %esi,%ecx
f01019f2:	39 d8                	cmp    %ebx,%eax
f01019f4:	76 0a                	jbe    f0101a00 <__umoddi3+0x70>
f01019f6:	89 f0                	mov    %esi,%eax
f01019f8:	83 c4 1c             	add    $0x1c,%esp
f01019fb:	5b                   	pop    %ebx
f01019fc:	5e                   	pop    %esi
f01019fd:	5f                   	pop    %edi
f01019fe:	5d                   	pop    %ebp
f01019ff:	c3                   	ret    
f0101a00:	0f bd e8             	bsr    %eax,%ebp
f0101a03:	83 f5 1f             	xor    $0x1f,%ebp
f0101a06:	75 20                	jne    f0101a28 <__umoddi3+0x98>
f0101a08:	39 d8                	cmp    %ebx,%eax
f0101a0a:	0f 82 b0 00 00 00    	jb     f0101ac0 <__umoddi3+0x130>
f0101a10:	39 f7                	cmp    %esi,%edi
f0101a12:	0f 86 a8 00 00 00    	jbe    f0101ac0 <__umoddi3+0x130>
f0101a18:	89 c8                	mov    %ecx,%eax
f0101a1a:	83 c4 1c             	add    $0x1c,%esp
f0101a1d:	5b                   	pop    %ebx
f0101a1e:	5e                   	pop    %esi
f0101a1f:	5f                   	pop    %edi
f0101a20:	5d                   	pop    %ebp
f0101a21:	c3                   	ret    
f0101a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101a28:	89 e9                	mov    %ebp,%ecx
f0101a2a:	ba 20 00 00 00       	mov    $0x20,%edx
f0101a2f:	29 ea                	sub    %ebp,%edx
f0101a31:	d3 e0                	shl    %cl,%eax
f0101a33:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101a37:	89 d1                	mov    %edx,%ecx
f0101a39:	89 f8                	mov    %edi,%eax
f0101a3b:	d3 e8                	shr    %cl,%eax
f0101a3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0101a41:	89 54 24 04          	mov    %edx,0x4(%esp)
f0101a45:	8b 54 24 04          	mov    0x4(%esp),%edx
f0101a49:	09 c1                	or     %eax,%ecx
f0101a4b:	89 d8                	mov    %ebx,%eax
f0101a4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0101a51:	89 e9                	mov    %ebp,%ecx
f0101a53:	d3 e7                	shl    %cl,%edi
f0101a55:	89 d1                	mov    %edx,%ecx
f0101a57:	d3 e8                	shr    %cl,%eax
f0101a59:	89 e9                	mov    %ebp,%ecx
f0101a5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0101a5f:	d3 e3                	shl    %cl,%ebx
f0101a61:	89 c7                	mov    %eax,%edi
f0101a63:	89 d1                	mov    %edx,%ecx
f0101a65:	89 f0                	mov    %esi,%eax
f0101a67:	d3 e8                	shr    %cl,%eax
f0101a69:	89 e9                	mov    %ebp,%ecx
f0101a6b:	89 fa                	mov    %edi,%edx
f0101a6d:	d3 e6                	shl    %cl,%esi
f0101a6f:	09 d8                	or     %ebx,%eax
f0101a71:	f7 74 24 08          	divl   0x8(%esp)
f0101a75:	89 d1                	mov    %edx,%ecx
f0101a77:	89 f3                	mov    %esi,%ebx
f0101a79:	f7 64 24 0c          	mull   0xc(%esp)
f0101a7d:	89 c6                	mov    %eax,%esi
f0101a7f:	89 d7                	mov    %edx,%edi
f0101a81:	39 d1                	cmp    %edx,%ecx
f0101a83:	72 06                	jb     f0101a8b <__umoddi3+0xfb>
f0101a85:	75 10                	jne    f0101a97 <__umoddi3+0x107>
f0101a87:	39 c3                	cmp    %eax,%ebx
f0101a89:	73 0c                	jae    f0101a97 <__umoddi3+0x107>
f0101a8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f0101a8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0101a93:	89 d7                	mov    %edx,%edi
f0101a95:	89 c6                	mov    %eax,%esi
f0101a97:	89 ca                	mov    %ecx,%edx
f0101a99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0101a9e:	29 f3                	sub    %esi,%ebx
f0101aa0:	19 fa                	sbb    %edi,%edx
f0101aa2:	89 d0                	mov    %edx,%eax
f0101aa4:	d3 e0                	shl    %cl,%eax
f0101aa6:	89 e9                	mov    %ebp,%ecx
f0101aa8:	d3 eb                	shr    %cl,%ebx
f0101aaa:	d3 ea                	shr    %cl,%edx
f0101aac:	09 d8                	or     %ebx,%eax
f0101aae:	83 c4 1c             	add    $0x1c,%esp
f0101ab1:	5b                   	pop    %ebx
f0101ab2:	5e                   	pop    %esi
f0101ab3:	5f                   	pop    %edi
f0101ab4:	5d                   	pop    %ebp
f0101ab5:	c3                   	ret    
f0101ab6:	8d 76 00             	lea    0x0(%esi),%esi
f0101ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0101ac0:	89 da                	mov    %ebx,%edx
f0101ac2:	29 fe                	sub    %edi,%esi
f0101ac4:	19 c2                	sbb    %eax,%edx
f0101ac6:	89 f1                	mov    %esi,%ecx
f0101ac8:	89 c8                	mov    %ecx,%eax
f0101aca:	e9 4b ff ff ff       	jmp    f0101a1a <__umoddi3+0x8a>
