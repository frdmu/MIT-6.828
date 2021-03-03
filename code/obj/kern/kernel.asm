
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
f0100039:	e8 02 00 00 00       	call   f0100040 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <i386_init>:
#include <kern/pmap.h>
#include <kern/kclock.h>

void
i386_init(void)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	83 ec 0c             	sub    $0xc,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100046:	b8 60 39 11 f0       	mov    $0xf0113960,%eax
f010004b:	2d 20 33 11 f0       	sub    $0xf0113320,%eax
f0100050:	50                   	push   %eax
f0100051:	6a 00                	push   $0x0
f0100053:	68 20 33 11 f0       	push   $0xf0113320
f0100058:	e8 6c 16 00 00       	call   f01016c9 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010005d:	e8 81 04 00 00       	call   f01004e3 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100062:	83 c4 08             	add    $0x8,%esp
f0100065:	68 ac 1a 00 00       	push   $0x1aac
f010006a:	68 20 1b 10 f0       	push   $0xf0101b20
f010006f:	e8 db 09 00 00       	call   f0100a4f <cprintf>
	// Lab 2 memory management initialization functions
	mem_init();
f0100074:	e8 75 08 00 00       	call   f01008ee <mem_init>
f0100079:	83 c4 10             	add    $0x10,%esp

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010007c:	83 ec 0c             	sub    $0xc,%esp
f010007f:	6a 00                	push   $0x0
f0100081:	e8 07 07 00 00       	call   f010078d <monitor>
f0100086:	83 c4 10             	add    $0x10,%esp
f0100089:	eb f1                	jmp    f010007c <i386_init+0x3c>

f010008b <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f010008b:	55                   	push   %ebp
f010008c:	89 e5                	mov    %esp,%ebp
f010008e:	56                   	push   %esi
f010008f:	53                   	push   %ebx
f0100090:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100093:	83 3d 64 39 11 f0 00 	cmpl   $0x0,0xf0113964
f010009a:	74 0f                	je     f01000ab <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010009c:	83 ec 0c             	sub    $0xc,%esp
f010009f:	6a 00                	push   $0x0
f01000a1:	e8 e7 06 00 00       	call   f010078d <monitor>
f01000a6:	83 c4 10             	add    $0x10,%esp
f01000a9:	eb f1                	jmp    f010009c <_panic+0x11>
	panicstr = fmt;
f01000ab:	89 35 64 39 11 f0    	mov    %esi,0xf0113964
	asm volatile("cli; cld");
f01000b1:	fa                   	cli    
f01000b2:	fc                   	cld    
	va_start(ap, fmt);
f01000b3:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic at %s:%d: ", file, line);
f01000b6:	83 ec 04             	sub    $0x4,%esp
f01000b9:	ff 75 0c             	pushl  0xc(%ebp)
f01000bc:	ff 75 08             	pushl  0x8(%ebp)
f01000bf:	68 3b 1b 10 f0       	push   $0xf0101b3b
f01000c4:	e8 86 09 00 00       	call   f0100a4f <cprintf>
	vcprintf(fmt, ap);
f01000c9:	83 c4 08             	add    $0x8,%esp
f01000cc:	53                   	push   %ebx
f01000cd:	56                   	push   %esi
f01000ce:	e8 56 09 00 00       	call   f0100a29 <vcprintf>
	cprintf("\n");
f01000d3:	c7 04 24 77 1b 10 f0 	movl   $0xf0101b77,(%esp)
f01000da:	e8 70 09 00 00       	call   f0100a4f <cprintf>
f01000df:	83 c4 10             	add    $0x10,%esp
f01000e2:	eb b8                	jmp    f010009c <_panic+0x11>

f01000e4 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01000e4:	55                   	push   %ebp
f01000e5:	89 e5                	mov    %esp,%ebp
f01000e7:	53                   	push   %ebx
f01000e8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01000eb:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01000ee:	ff 75 0c             	pushl  0xc(%ebp)
f01000f1:	ff 75 08             	pushl  0x8(%ebp)
f01000f4:	68 53 1b 10 f0       	push   $0xf0101b53
f01000f9:	e8 51 09 00 00       	call   f0100a4f <cprintf>
	vcprintf(fmt, ap);
f01000fe:	83 c4 08             	add    $0x8,%esp
f0100101:	53                   	push   %ebx
f0100102:	ff 75 10             	pushl  0x10(%ebp)
f0100105:	e8 1f 09 00 00       	call   f0100a29 <vcprintf>
	cprintf("\n");
f010010a:	c7 04 24 77 1b 10 f0 	movl   $0xf0101b77,(%esp)
f0100111:	e8 39 09 00 00       	call   f0100a4f <cprintf>
	va_end(ap);
}
f0100116:	83 c4 10             	add    $0x10,%esp
f0100119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010011c:	c9                   	leave  
f010011d:	c3                   	ret    

f010011e <serial_proc_data>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010011e:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100123:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100124:	a8 01                	test   $0x1,%al
f0100126:	74 0a                	je     f0100132 <serial_proc_data+0x14>
f0100128:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010012d:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f010012e:	0f b6 c0             	movzbl %al,%eax
f0100131:	c3                   	ret    
		return -1;
f0100132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100137:	c3                   	ret    

f0100138 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100138:	55                   	push   %ebp
f0100139:	89 e5                	mov    %esp,%ebp
f010013b:	53                   	push   %ebx
f010013c:	83 ec 04             	sub    $0x4,%esp
f010013f:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100141:	ff d3                	call   *%ebx
f0100143:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100146:	74 29                	je     f0100171 <cons_intr+0x39>
		if (c == 0)
f0100148:	85 c0                	test   %eax,%eax
f010014a:	74 f5                	je     f0100141 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f010014c:	8b 0d 44 35 11 f0    	mov    0xf0113544,%ecx
f0100152:	8d 51 01             	lea    0x1(%ecx),%edx
f0100155:	88 81 40 33 11 f0    	mov    %al,-0xfeeccc0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f010015b:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f0100161:	b8 00 00 00 00       	mov    $0x0,%eax
f0100166:	0f 44 d0             	cmove  %eax,%edx
f0100169:	89 15 44 35 11 f0    	mov    %edx,0xf0113544
f010016f:	eb d0                	jmp    f0100141 <cons_intr+0x9>
	}
}
f0100171:	83 c4 04             	add    $0x4,%esp
f0100174:	5b                   	pop    %ebx
f0100175:	5d                   	pop    %ebp
f0100176:	c3                   	ret    

f0100177 <kbd_proc_data>:
{
f0100177:	55                   	push   %ebp
f0100178:	89 e5                	mov    %esp,%ebp
f010017a:	53                   	push   %ebx
f010017b:	83 ec 04             	sub    $0x4,%esp
f010017e:	ba 64 00 00 00       	mov    $0x64,%edx
f0100183:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f0100184:	a8 01                	test   $0x1,%al
f0100186:	0f 84 f2 00 00 00    	je     f010027e <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f010018c:	a8 20                	test   $0x20,%al
f010018e:	0f 85 f1 00 00 00    	jne    f0100285 <kbd_proc_data+0x10e>
f0100194:	ba 60 00 00 00       	mov    $0x60,%edx
f0100199:	ec                   	in     (%dx),%al
f010019a:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f010019c:	3c e0                	cmp    $0xe0,%al
f010019e:	74 61                	je     f0100201 <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f01001a0:	84 c0                	test   %al,%al
f01001a2:	78 70                	js     f0100214 <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f01001a4:	8b 0d 20 33 11 f0    	mov    0xf0113320,%ecx
f01001aa:	f6 c1 40             	test   $0x40,%cl
f01001ad:	74 0e                	je     f01001bd <kbd_proc_data+0x46>
		data |= 0x80;
f01001af:	83 c8 80             	or     $0xffffff80,%eax
f01001b2:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01001b4:	83 e1 bf             	and    $0xffffffbf,%ecx
f01001b7:	89 0d 20 33 11 f0    	mov    %ecx,0xf0113320
	shift |= shiftcode[data];
f01001bd:	0f b6 d2             	movzbl %dl,%edx
f01001c0:	0f b6 82 c0 1c 10 f0 	movzbl -0xfefe340(%edx),%eax
f01001c7:	0b 05 20 33 11 f0    	or     0xf0113320,%eax
	shift ^= togglecode[data];
f01001cd:	0f b6 8a c0 1b 10 f0 	movzbl -0xfefe440(%edx),%ecx
f01001d4:	31 c8                	xor    %ecx,%eax
f01001d6:	a3 20 33 11 f0       	mov    %eax,0xf0113320
	c = charcode[shift & (CTL | SHIFT)][data];
f01001db:	89 c1                	mov    %eax,%ecx
f01001dd:	83 e1 03             	and    $0x3,%ecx
f01001e0:	8b 0c 8d a0 1b 10 f0 	mov    -0xfefe460(,%ecx,4),%ecx
f01001e7:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f01001eb:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f01001ee:	a8 08                	test   $0x8,%al
f01001f0:	74 61                	je     f0100253 <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f01001f2:	89 da                	mov    %ebx,%edx
f01001f4:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f01001f7:	83 f9 19             	cmp    $0x19,%ecx
f01001fa:	77 4b                	ja     f0100247 <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f01001fc:	83 eb 20             	sub    $0x20,%ebx
f01001ff:	eb 0c                	jmp    f010020d <kbd_proc_data+0x96>
		shift |= E0ESC;
f0100201:	83 0d 20 33 11 f0 40 	orl    $0x40,0xf0113320
		return 0;
f0100208:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010020d:	89 d8                	mov    %ebx,%eax
f010020f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100212:	c9                   	leave  
f0100213:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100214:	8b 0d 20 33 11 f0    	mov    0xf0113320,%ecx
f010021a:	89 cb                	mov    %ecx,%ebx
f010021c:	83 e3 40             	and    $0x40,%ebx
f010021f:	83 e0 7f             	and    $0x7f,%eax
f0100222:	85 db                	test   %ebx,%ebx
f0100224:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100227:	0f b6 d2             	movzbl %dl,%edx
f010022a:	0f b6 82 c0 1c 10 f0 	movzbl -0xfefe340(%edx),%eax
f0100231:	83 c8 40             	or     $0x40,%eax
f0100234:	0f b6 c0             	movzbl %al,%eax
f0100237:	f7 d0                	not    %eax
f0100239:	21 c8                	and    %ecx,%eax
f010023b:	a3 20 33 11 f0       	mov    %eax,0xf0113320
		return 0;
f0100240:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100245:	eb c6                	jmp    f010020d <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f0100247:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f010024a:	8d 4b 20             	lea    0x20(%ebx),%ecx
f010024d:	83 fa 1a             	cmp    $0x1a,%edx
f0100250:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100253:	f7 d0                	not    %eax
f0100255:	a8 06                	test   $0x6,%al
f0100257:	75 b4                	jne    f010020d <kbd_proc_data+0x96>
f0100259:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010025f:	75 ac                	jne    f010020d <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f0100261:	83 ec 0c             	sub    $0xc,%esp
f0100264:	68 6d 1b 10 f0       	push   $0xf0101b6d
f0100269:	e8 e1 07 00 00       	call   f0100a4f <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010026e:	b8 03 00 00 00       	mov    $0x3,%eax
f0100273:	ba 92 00 00 00       	mov    $0x92,%edx
f0100278:	ee                   	out    %al,(%dx)
f0100279:	83 c4 10             	add    $0x10,%esp
f010027c:	eb 8f                	jmp    f010020d <kbd_proc_data+0x96>
		return -1;
f010027e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100283:	eb 88                	jmp    f010020d <kbd_proc_data+0x96>
		return -1;
f0100285:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f010028a:	eb 81                	jmp    f010020d <kbd_proc_data+0x96>

f010028c <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f010028c:	55                   	push   %ebp
f010028d:	89 e5                	mov    %esp,%ebp
f010028f:	57                   	push   %edi
f0100290:	56                   	push   %esi
f0100291:	53                   	push   %ebx
f0100292:	83 ec 0c             	sub    $0xc,%esp
f0100295:	89 c3                	mov    %eax,%ebx
	for (i = 0;
f0100297:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010029c:	bf fd 03 00 00       	mov    $0x3fd,%edi
f01002a1:	b9 84 00 00 00       	mov    $0x84,%ecx
f01002a6:	89 fa                	mov    %edi,%edx
f01002a8:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01002a9:	a8 20                	test   $0x20,%al
f01002ab:	75 13                	jne    f01002c0 <cons_putc+0x34>
f01002ad:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01002b3:	7f 0b                	jg     f01002c0 <cons_putc+0x34>
f01002b5:	89 ca                	mov    %ecx,%edx
f01002b7:	ec                   	in     (%dx),%al
f01002b8:	ec                   	in     (%dx),%al
f01002b9:	ec                   	in     (%dx),%al
f01002ba:	ec                   	in     (%dx),%al
	     i++)
f01002bb:	83 c6 01             	add    $0x1,%esi
f01002be:	eb e6                	jmp    f01002a6 <cons_putc+0x1a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002c0:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002c5:	89 d8                	mov    %ebx,%eax
f01002c7:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01002c8:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002cd:	bf 79 03 00 00       	mov    $0x379,%edi
f01002d2:	b9 84 00 00 00       	mov    $0x84,%ecx
f01002d7:	89 fa                	mov    %edi,%edx
f01002d9:	ec                   	in     (%dx),%al
f01002da:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01002e0:	7f 0f                	jg     f01002f1 <cons_putc+0x65>
f01002e2:	84 c0                	test   %al,%al
f01002e4:	78 0b                	js     f01002f1 <cons_putc+0x65>
f01002e6:	89 ca                	mov    %ecx,%edx
f01002e8:	ec                   	in     (%dx),%al
f01002e9:	ec                   	in     (%dx),%al
f01002ea:	ec                   	in     (%dx),%al
f01002eb:	ec                   	in     (%dx),%al
f01002ec:	83 c6 01             	add    $0x1,%esi
f01002ef:	eb e6                	jmp    f01002d7 <cons_putc+0x4b>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002f1:	ba 78 03 00 00       	mov    $0x378,%edx
f01002f6:	89 d8                	mov    %ebx,%eax
f01002f8:	ee                   	out    %al,(%dx)
f01002f9:	ba 7a 03 00 00       	mov    $0x37a,%edx
f01002fe:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100303:	ee                   	out    %al,(%dx)
f0100304:	b8 08 00 00 00       	mov    $0x8,%eax
f0100309:	ee                   	out    %al,(%dx)
	c |= color_flag;
f010030a:	0f b7 05 00 33 11 f0 	movzwl 0xf0113300,%eax
f0100311:	09 d8                	or     %ebx,%eax
	switch (c & 0xff) {
f0100313:	0f b6 d0             	movzbl %al,%edx
f0100316:	83 fa 09             	cmp    $0x9,%edx
f0100319:	0f 84 b1 00 00 00    	je     f01003d0 <cons_putc+0x144>
f010031f:	7e 73                	jle    f0100394 <cons_putc+0x108>
f0100321:	83 fa 0a             	cmp    $0xa,%edx
f0100324:	0f 84 99 00 00 00    	je     f01003c3 <cons_putc+0x137>
f010032a:	83 fa 0d             	cmp    $0xd,%edx
f010032d:	0f 85 d4 00 00 00    	jne    f0100407 <cons_putc+0x17b>
		crt_pos -= (crt_pos % CRT_COLS);
f0100333:	0f b7 05 48 35 11 f0 	movzwl 0xf0113548,%eax
f010033a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100340:	c1 e8 16             	shr    $0x16,%eax
f0100343:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100346:	c1 e0 04             	shl    $0x4,%eax
f0100349:	66 a3 48 35 11 f0    	mov    %ax,0xf0113548
	if (crt_pos >= CRT_SIZE) {
f010034f:	66 81 3d 48 35 11 f0 	cmpw   $0x7cf,0xf0113548
f0100356:	cf 07 
f0100358:	0f 87 cc 00 00 00    	ja     f010042a <cons_putc+0x19e>
	outb(addr_6845, 14);
f010035e:	8b 0d 50 35 11 f0    	mov    0xf0113550,%ecx
f0100364:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100369:	89 ca                	mov    %ecx,%edx
f010036b:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010036c:	0f b7 1d 48 35 11 f0 	movzwl 0xf0113548,%ebx
f0100373:	8d 71 01             	lea    0x1(%ecx),%esi
f0100376:	89 d8                	mov    %ebx,%eax
f0100378:	66 c1 e8 08          	shr    $0x8,%ax
f010037c:	89 f2                	mov    %esi,%edx
f010037e:	ee                   	out    %al,(%dx)
f010037f:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100384:	89 ca                	mov    %ecx,%edx
f0100386:	ee                   	out    %al,(%dx)
f0100387:	89 d8                	mov    %ebx,%eax
f0100389:	89 f2                	mov    %esi,%edx
f010038b:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010038c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010038f:	5b                   	pop    %ebx
f0100390:	5e                   	pop    %esi
f0100391:	5f                   	pop    %edi
f0100392:	5d                   	pop    %ebp
f0100393:	c3                   	ret    
	switch (c & 0xff) {
f0100394:	83 fa 08             	cmp    $0x8,%edx
f0100397:	75 6e                	jne    f0100407 <cons_putc+0x17b>
		if (crt_pos > 0) {
f0100399:	0f b7 15 48 35 11 f0 	movzwl 0xf0113548,%edx
f01003a0:	66 85 d2             	test   %dx,%dx
f01003a3:	74 b9                	je     f010035e <cons_putc+0xd2>
			crt_pos--;
f01003a5:	83 ea 01             	sub    $0x1,%edx
f01003a8:	66 89 15 48 35 11 f0 	mov    %dx,0xf0113548
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01003af:	0f b7 d2             	movzwl %dx,%edx
f01003b2:	b0 00                	mov    $0x0,%al
f01003b4:	83 c8 20             	or     $0x20,%eax
f01003b7:	8b 0d 4c 35 11 f0    	mov    0xf011354c,%ecx
f01003bd:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
f01003c1:	eb 8c                	jmp    f010034f <cons_putc+0xc3>
		crt_pos += CRT_COLS;
f01003c3:	66 83 05 48 35 11 f0 	addw   $0x50,0xf0113548
f01003ca:	50 
f01003cb:	e9 63 ff ff ff       	jmp    f0100333 <cons_putc+0xa7>
		cons_putc(' ');
f01003d0:	b8 20 00 00 00       	mov    $0x20,%eax
f01003d5:	e8 b2 fe ff ff       	call   f010028c <cons_putc>
		cons_putc(' ');
f01003da:	b8 20 00 00 00       	mov    $0x20,%eax
f01003df:	e8 a8 fe ff ff       	call   f010028c <cons_putc>
		cons_putc(' ');
f01003e4:	b8 20 00 00 00       	mov    $0x20,%eax
f01003e9:	e8 9e fe ff ff       	call   f010028c <cons_putc>
		cons_putc(' ');
f01003ee:	b8 20 00 00 00       	mov    $0x20,%eax
f01003f3:	e8 94 fe ff ff       	call   f010028c <cons_putc>
		cons_putc(' ');
f01003f8:	b8 20 00 00 00       	mov    $0x20,%eax
f01003fd:	e8 8a fe ff ff       	call   f010028c <cons_putc>
f0100402:	e9 48 ff ff ff       	jmp    f010034f <cons_putc+0xc3>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100407:	0f b7 15 48 35 11 f0 	movzwl 0xf0113548,%edx
f010040e:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100411:	66 89 0d 48 35 11 f0 	mov    %cx,0xf0113548
f0100418:	0f b7 d2             	movzwl %dx,%edx
f010041b:	8b 0d 4c 35 11 f0    	mov    0xf011354c,%ecx
f0100421:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
f0100425:	e9 25 ff ff ff       	jmp    f010034f <cons_putc+0xc3>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f010042a:	a1 4c 35 11 f0       	mov    0xf011354c,%eax
f010042f:	83 ec 04             	sub    $0x4,%esp
f0100432:	68 00 0f 00 00       	push   $0xf00
f0100437:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f010043d:	52                   	push   %edx
f010043e:	50                   	push   %eax
f010043f:	e8 cd 12 00 00       	call   f0101711 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f0100444:	8b 15 4c 35 11 f0    	mov    0xf011354c,%edx
f010044a:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100450:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0100456:	83 c4 10             	add    $0x10,%esp
f0100459:	66 c7 00 20 07       	movw   $0x720,(%eax)
f010045e:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100461:	39 d0                	cmp    %edx,%eax
f0100463:	75 f4                	jne    f0100459 <cons_putc+0x1cd>
		crt_pos -= CRT_COLS;
f0100465:	66 83 2d 48 35 11 f0 	subw   $0x50,0xf0113548
f010046c:	50 
f010046d:	e9 ec fe ff ff       	jmp    f010035e <cons_putc+0xd2>

f0100472 <serial_intr>:
	if (serial_exists)
f0100472:	80 3d 54 35 11 f0 00 	cmpb   $0x0,0xf0113554
f0100479:	75 01                	jne    f010047c <serial_intr+0xa>
f010047b:	c3                   	ret    
{
f010047c:	55                   	push   %ebp
f010047d:	89 e5                	mov    %esp,%ebp
f010047f:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100482:	b8 1e 01 10 f0       	mov    $0xf010011e,%eax
f0100487:	e8 ac fc ff ff       	call   f0100138 <cons_intr>
}
f010048c:	c9                   	leave  
f010048d:	c3                   	ret    

f010048e <kbd_intr>:
{
f010048e:	55                   	push   %ebp
f010048f:	89 e5                	mov    %esp,%ebp
f0100491:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100494:	b8 77 01 10 f0       	mov    $0xf0100177,%eax
f0100499:	e8 9a fc ff ff       	call   f0100138 <cons_intr>
}
f010049e:	c9                   	leave  
f010049f:	c3                   	ret    

f01004a0 <cons_getc>:
{
f01004a0:	55                   	push   %ebp
f01004a1:	89 e5                	mov    %esp,%ebp
f01004a3:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01004a6:	e8 c7 ff ff ff       	call   f0100472 <serial_intr>
	kbd_intr();
f01004ab:	e8 de ff ff ff       	call   f010048e <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01004b0:	8b 15 40 35 11 f0    	mov    0xf0113540,%edx
	return 0;
f01004b6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f01004bb:	3b 15 44 35 11 f0    	cmp    0xf0113544,%edx
f01004c1:	74 1e                	je     f01004e1 <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f01004c3:	8d 4a 01             	lea    0x1(%edx),%ecx
f01004c6:	0f b6 82 40 33 11 f0 	movzbl -0xfeeccc0(%edx),%eax
			cons.rpos = 0;
f01004cd:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f01004d3:	ba 00 00 00 00       	mov    $0x0,%edx
f01004d8:	0f 44 ca             	cmove  %edx,%ecx
f01004db:	89 0d 40 35 11 f0    	mov    %ecx,0xf0113540
}
f01004e1:	c9                   	leave  
f01004e2:	c3                   	ret    

f01004e3 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01004e3:	55                   	push   %ebp
f01004e4:	89 e5                	mov    %esp,%ebp
f01004e6:	57                   	push   %edi
f01004e7:	56                   	push   %esi
f01004e8:	53                   	push   %ebx
f01004e9:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f01004ec:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01004f3:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01004fa:	5a a5 
	if (*cp != 0xA55A) {
f01004fc:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100503:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100507:	0f 84 b7 00 00 00    	je     f01005c4 <cons_init+0xe1>
		addr_6845 = MONO_BASE;
f010050d:	c7 05 50 35 11 f0 b4 	movl   $0x3b4,0xf0113550
f0100514:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100517:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f010051c:	8b 3d 50 35 11 f0    	mov    0xf0113550,%edi
f0100522:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100527:	89 fa                	mov    %edi,%edx
f0100529:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010052a:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010052d:	89 ca                	mov    %ecx,%edx
f010052f:	ec                   	in     (%dx),%al
f0100530:	0f b6 c0             	movzbl %al,%eax
f0100533:	c1 e0 08             	shl    $0x8,%eax
f0100536:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100538:	b8 0f 00 00 00       	mov    $0xf,%eax
f010053d:	89 fa                	mov    %edi,%edx
f010053f:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100540:	89 ca                	mov    %ecx,%edx
f0100542:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f0100543:	89 35 4c 35 11 f0    	mov    %esi,0xf011354c
	pos |= inb(addr_6845 + 1);
f0100549:	0f b6 c0             	movzbl %al,%eax
f010054c:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f010054e:	66 a3 48 35 11 f0    	mov    %ax,0xf0113548
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100554:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100559:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f010055e:	89 d8                	mov    %ebx,%eax
f0100560:	89 ca                	mov    %ecx,%edx
f0100562:	ee                   	out    %al,(%dx)
f0100563:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100568:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010056d:	89 fa                	mov    %edi,%edx
f010056f:	ee                   	out    %al,(%dx)
f0100570:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100575:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010057a:	ee                   	out    %al,(%dx)
f010057b:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100580:	89 d8                	mov    %ebx,%eax
f0100582:	89 f2                	mov    %esi,%edx
f0100584:	ee                   	out    %al,(%dx)
f0100585:	b8 03 00 00 00       	mov    $0x3,%eax
f010058a:	89 fa                	mov    %edi,%edx
f010058c:	ee                   	out    %al,(%dx)
f010058d:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100592:	89 d8                	mov    %ebx,%eax
f0100594:	ee                   	out    %al,(%dx)
f0100595:	b8 01 00 00 00       	mov    $0x1,%eax
f010059a:	89 f2                	mov    %esi,%edx
f010059c:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010059d:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01005a2:	ec                   	in     (%dx),%al
f01005a3:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01005a5:	3c ff                	cmp    $0xff,%al
f01005a7:	0f 95 05 54 35 11 f0 	setne  0xf0113554
f01005ae:	89 ca                	mov    %ecx,%edx
f01005b0:	ec                   	in     (%dx),%al
f01005b1:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01005b6:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01005b7:	80 fb ff             	cmp    $0xff,%bl
f01005ba:	74 23                	je     f01005df <cons_init+0xfc>
		cprintf("Serial port does not exist!\n");
}
f01005bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01005bf:	5b                   	pop    %ebx
f01005c0:	5e                   	pop    %esi
f01005c1:	5f                   	pop    %edi
f01005c2:	5d                   	pop    %ebp
f01005c3:	c3                   	ret    
		*cp = was;
f01005c4:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01005cb:	c7 05 50 35 11 f0 d4 	movl   $0x3d4,0xf0113550
f01005d2:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01005d5:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f01005da:	e9 3d ff ff ff       	jmp    f010051c <cons_init+0x39>
		cprintf("Serial port does not exist!\n");
f01005df:	83 ec 0c             	sub    $0xc,%esp
f01005e2:	68 79 1b 10 f0       	push   $0xf0101b79
f01005e7:	e8 63 04 00 00       	call   f0100a4f <cprintf>
f01005ec:	83 c4 10             	add    $0x10,%esp
}
f01005ef:	eb cb                	jmp    f01005bc <cons_init+0xd9>

f01005f1 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01005f1:	55                   	push   %ebp
f01005f2:	89 e5                	mov    %esp,%ebp
f01005f4:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01005f7:	8b 45 08             	mov    0x8(%ebp),%eax
f01005fa:	e8 8d fc ff ff       	call   f010028c <cons_putc>
}
f01005ff:	c9                   	leave  
f0100600:	c3                   	ret    

f0100601 <getchar>:

int
getchar(void)
{
f0100601:	55                   	push   %ebp
f0100602:	89 e5                	mov    %esp,%ebp
f0100604:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100607:	e8 94 fe ff ff       	call   f01004a0 <cons_getc>
f010060c:	85 c0                	test   %eax,%eax
f010060e:	74 f7                	je     f0100607 <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100610:	c9                   	leave  
f0100611:	c3                   	ret    

f0100612 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f0100612:	b8 01 00 00 00       	mov    $0x1,%eax
f0100617:	c3                   	ret    

f0100618 <set_color_info>:

void
set_color_info(uint16_t new_color)
{
f0100618:	55                   	push   %ebp
f0100619:	89 e5                	mov    %esp,%ebp
	color_flag = new_color;
f010061b:	8b 45 08             	mov    0x8(%ebp),%eax
f010061e:	66 a3 00 33 11 f0    	mov    %ax,0xf0113300
}
f0100624:	5d                   	pop    %ebp
f0100625:	c3                   	ret    

f0100626 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100626:	55                   	push   %ebp
f0100627:	89 e5                	mov    %esp,%ebp
f0100629:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010062c:	68 c0 1d 10 f0       	push   $0xf0101dc0
f0100631:	68 de 1d 10 f0       	push   $0xf0101dde
f0100636:	68 e3 1d 10 f0       	push   $0xf0101de3
f010063b:	e8 0f 04 00 00       	call   f0100a4f <cprintf>
f0100640:	83 c4 0c             	add    $0xc,%esp
f0100643:	68 78 1e 10 f0       	push   $0xf0101e78
f0100648:	68 ec 1d 10 f0       	push   $0xf0101dec
f010064d:	68 e3 1d 10 f0       	push   $0xf0101de3
f0100652:	e8 f8 03 00 00       	call   f0100a4f <cprintf>
f0100657:	83 c4 0c             	add    $0xc,%esp
f010065a:	68 a0 1e 10 f0       	push   $0xf0101ea0
f010065f:	68 f5 1d 10 f0       	push   $0xf0101df5
f0100664:	68 e3 1d 10 f0       	push   $0xf0101de3
f0100669:	e8 e1 03 00 00       	call   f0100a4f <cprintf>
	return 0;
}
f010066e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100673:	c9                   	leave  
f0100674:	c3                   	ret    

f0100675 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100675:	55                   	push   %ebp
f0100676:	89 e5                	mov    %esp,%ebp
f0100678:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010067b:	68 ff 1d 10 f0       	push   $0xf0101dff
f0100680:	e8 ca 03 00 00       	call   f0100a4f <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100685:	83 c4 08             	add    $0x8,%esp
f0100688:	68 0c 00 10 00       	push   $0x10000c
f010068d:	68 c0 1e 10 f0       	push   $0xf0101ec0
f0100692:	e8 b8 03 00 00       	call   f0100a4f <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100697:	83 c4 0c             	add    $0xc,%esp
f010069a:	68 0c 00 10 00       	push   $0x10000c
f010069f:	68 0c 00 10 f0       	push   $0xf010000c
f01006a4:	68 e8 1e 10 f0       	push   $0xf0101ee8
f01006a9:	e8 a1 03 00 00       	call   f0100a4f <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01006ae:	83 c4 0c             	add    $0xc,%esp
f01006b1:	68 0f 1b 10 00       	push   $0x101b0f
f01006b6:	68 0f 1b 10 f0       	push   $0xf0101b0f
f01006bb:	68 0c 1f 10 f0       	push   $0xf0101f0c
f01006c0:	e8 8a 03 00 00       	call   f0100a4f <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01006c5:	83 c4 0c             	add    $0xc,%esp
f01006c8:	68 20 33 11 00       	push   $0x113320
f01006cd:	68 20 33 11 f0       	push   $0xf0113320
f01006d2:	68 30 1f 10 f0       	push   $0xf0101f30
f01006d7:	e8 73 03 00 00       	call   f0100a4f <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01006dc:	83 c4 0c             	add    $0xc,%esp
f01006df:	68 60 39 11 00       	push   $0x113960
f01006e4:	68 60 39 11 f0       	push   $0xf0113960
f01006e9:	68 54 1f 10 f0       	push   $0xf0101f54
f01006ee:	e8 5c 03 00 00       	call   f0100a4f <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01006f3:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01006f6:	b8 60 39 11 f0       	mov    $0xf0113960,%eax
f01006fb:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100700:	c1 f8 0a             	sar    $0xa,%eax
f0100703:	50                   	push   %eax
f0100704:	68 78 1f 10 f0       	push   $0xf0101f78
f0100709:	e8 41 03 00 00       	call   f0100a4f <cprintf>
	return 0;
}
f010070e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100713:	c9                   	leave  
f0100714:	c3                   	ret    

f0100715 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100715:	55                   	push   %ebp
f0100716:	89 e5                	mov    %esp,%ebp
f0100718:	57                   	push   %edi
f0100719:	56                   	push   %esi
f010071a:	53                   	push   %ebx
f010071b:	83 ec 38             	sub    $0x38,%esp
	// Your code here.
	cprintf("Stack backtrace:\n");
f010071e:	68 18 1e 10 f0       	push   $0xf0101e18
f0100723:	e8 27 03 00 00       	call   f0100a4f <cprintf>

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100728:	89 eb                	mov    %ebp,%ebx
	
	uint32_t ebp = read_ebp();
	uint32_t *p, eip;	
	while (ebp != 0) {
f010072a:	83 c4 10             	add    $0x10,%esp
		p = (uint32_t *)ebp;	
		eip = p[1];
		cprintf("ebp %x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, p[2], p[3], p[4], p[5], p[6]);
		
		struct Eipdebuginfo info;
		int ret = debuginfo_eip(eip, &info);
f010072d:	8d 7d d0             	lea    -0x30(%ebp),%edi
	while (ebp != 0) {
f0100730:	85 db                	test   %ebx,%ebx
f0100732:	74 4c                	je     f0100780 <mon_backtrace+0x6b>
		eip = p[1];
f0100734:	8b 73 04             	mov    0x4(%ebx),%esi
		cprintf("ebp %x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, eip, p[2], p[3], p[4], p[5], p[6]);
f0100737:	ff 73 18             	pushl  0x18(%ebx)
f010073a:	ff 73 14             	pushl  0x14(%ebx)
f010073d:	ff 73 10             	pushl  0x10(%ebx)
f0100740:	ff 73 0c             	pushl  0xc(%ebx)
f0100743:	ff 73 08             	pushl  0x8(%ebx)
f0100746:	56                   	push   %esi
f0100747:	53                   	push   %ebx
f0100748:	68 a4 1f 10 f0       	push   $0xf0101fa4
f010074d:	e8 fd 02 00 00       	call   f0100a4f <cprintf>
		int ret = debuginfo_eip(eip, &info);
f0100752:	83 c4 18             	add    $0x18,%esp
f0100755:	57                   	push   %edi
f0100756:	56                   	push   %esi
f0100757:	e8 f7 03 00 00       	call   f0100b53 <debuginfo_eip>
		cprintf("%s:%d: %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, eip - info.eip_fn_addr);
f010075c:	83 c4 08             	add    $0x8,%esp
f010075f:	2b 75 e0             	sub    -0x20(%ebp),%esi
f0100762:	56                   	push   %esi
f0100763:	ff 75 d8             	pushl  -0x28(%ebp)
f0100766:	ff 75 dc             	pushl  -0x24(%ebp)
f0100769:	ff 75 d4             	pushl  -0x2c(%ebp)
f010076c:	ff 75 d0             	pushl  -0x30(%ebp)
f010076f:	68 2a 1e 10 f0       	push   $0xf0101e2a
f0100774:	e8 d6 02 00 00       	call   f0100a4f <cprintf>
		ebp = p[0];
f0100779:	8b 1b                	mov    (%ebx),%ebx
f010077b:	83 c4 20             	add    $0x20,%esp
f010077e:	eb b0                	jmp    f0100730 <mon_backtrace+0x1b>
	}
		
	return 0;
	
}
f0100780:	b8 00 00 00 00       	mov    $0x0,%eax
f0100785:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100788:	5b                   	pop    %ebx
f0100789:	5e                   	pop    %esi
f010078a:	5f                   	pop    %edi
f010078b:	5d                   	pop    %ebp
f010078c:	c3                   	ret    

f010078d <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f010078d:	55                   	push   %ebp
f010078e:	89 e5                	mov    %esp,%ebp
f0100790:	57                   	push   %edi
f0100791:	56                   	push   %esi
f0100792:	53                   	push   %ebx
f0100793:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100796:	68 d8 1f 10 f0       	push   $0xf0101fd8
f010079b:	e8 af 02 00 00       	call   f0100a4f <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01007a0:	c7 04 24 fc 1f 10 f0 	movl   $0xf0101ffc,(%esp)
f01007a7:	e8 a3 02 00 00       	call   f0100a4f <cprintf>
f01007ac:	83 c4 10             	add    $0x10,%esp
f01007af:	e9 c6 00 00 00       	jmp    f010087a <monitor+0xed>
		while (*buf && strchr(WHITESPACE, *buf))
f01007b4:	83 ec 08             	sub    $0x8,%esp
f01007b7:	0f be c0             	movsbl %al,%eax
f01007ba:	50                   	push   %eax
f01007bb:	68 3e 1e 10 f0       	push   $0xf0101e3e
f01007c0:	e8 c7 0e 00 00       	call   f010168c <strchr>
f01007c5:	83 c4 10             	add    $0x10,%esp
f01007c8:	85 c0                	test   %eax,%eax
f01007ca:	74 63                	je     f010082f <monitor+0xa2>
			*buf++ = 0;
f01007cc:	c6 03 00             	movb   $0x0,(%ebx)
f01007cf:	89 f7                	mov    %esi,%edi
f01007d1:	8d 5b 01             	lea    0x1(%ebx),%ebx
f01007d4:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01007d6:	0f b6 03             	movzbl (%ebx),%eax
f01007d9:	84 c0                	test   %al,%al
f01007db:	75 d7                	jne    f01007b4 <monitor+0x27>
	argv[argc] = 0;
f01007dd:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01007e4:	00 
	if (argc == 0)
f01007e5:	85 f6                	test   %esi,%esi
f01007e7:	0f 84 8d 00 00 00    	je     f010087a <monitor+0xed>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01007ed:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f01007f2:	83 ec 08             	sub    $0x8,%esp
f01007f5:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01007f8:	ff 34 85 40 20 10 f0 	pushl  -0xfefdfc0(,%eax,4)
f01007ff:	ff 75 a8             	pushl  -0x58(%ebp)
f0100802:	e8 27 0e 00 00       	call   f010162e <strcmp>
f0100807:	83 c4 10             	add    $0x10,%esp
f010080a:	85 c0                	test   %eax,%eax
f010080c:	0f 84 8f 00 00 00    	je     f01008a1 <monitor+0x114>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100812:	83 c3 01             	add    $0x1,%ebx
f0100815:	83 fb 03             	cmp    $0x3,%ebx
f0100818:	75 d8                	jne    f01007f2 <monitor+0x65>
	cprintf("Unknown command '%s'\n", argv[0]);
f010081a:	83 ec 08             	sub    $0x8,%esp
f010081d:	ff 75 a8             	pushl  -0x58(%ebp)
f0100820:	68 60 1e 10 f0       	push   $0xf0101e60
f0100825:	e8 25 02 00 00       	call   f0100a4f <cprintf>
f010082a:	83 c4 10             	add    $0x10,%esp
f010082d:	eb 4b                	jmp    f010087a <monitor+0xed>
		if (*buf == 0)
f010082f:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100832:	74 a9                	je     f01007dd <monitor+0x50>
		if (argc == MAXARGS-1) {
f0100834:	83 fe 0f             	cmp    $0xf,%esi
f0100837:	74 2f                	je     f0100868 <monitor+0xdb>
		argv[argc++] = buf;
f0100839:	8d 7e 01             	lea    0x1(%esi),%edi
f010083c:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100840:	0f b6 03             	movzbl (%ebx),%eax
f0100843:	84 c0                	test   %al,%al
f0100845:	74 8d                	je     f01007d4 <monitor+0x47>
f0100847:	83 ec 08             	sub    $0x8,%esp
f010084a:	0f be c0             	movsbl %al,%eax
f010084d:	50                   	push   %eax
f010084e:	68 3e 1e 10 f0       	push   $0xf0101e3e
f0100853:	e8 34 0e 00 00       	call   f010168c <strchr>
f0100858:	83 c4 10             	add    $0x10,%esp
f010085b:	85 c0                	test   %eax,%eax
f010085d:	0f 85 71 ff ff ff    	jne    f01007d4 <monitor+0x47>
			buf++;
f0100863:	83 c3 01             	add    $0x1,%ebx
f0100866:	eb d8                	jmp    f0100840 <monitor+0xb3>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100868:	83 ec 08             	sub    $0x8,%esp
f010086b:	6a 10                	push   $0x10
f010086d:	68 43 1e 10 f0       	push   $0xf0101e43
f0100872:	e8 d8 01 00 00       	call   f0100a4f <cprintf>
f0100877:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f010087a:	83 ec 0c             	sub    $0xc,%esp
f010087d:	68 3a 1e 10 f0       	push   $0xf0101e3a
f0100882:	e8 e1 0b 00 00       	call   f0101468 <readline>
f0100887:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100889:	83 c4 10             	add    $0x10,%esp
f010088c:	85 c0                	test   %eax,%eax
f010088e:	74 ea                	je     f010087a <monitor+0xed>
	argv[argc] = 0;
f0100890:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100897:	be 00 00 00 00       	mov    $0x0,%esi
f010089c:	e9 35 ff ff ff       	jmp    f01007d6 <monitor+0x49>
			return commands[i].func(argc, argv, tf);
f01008a1:	83 ec 04             	sub    $0x4,%esp
f01008a4:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01008a7:	ff 75 08             	pushl  0x8(%ebp)
f01008aa:	8d 55 a8             	lea    -0x58(%ebp),%edx
f01008ad:	52                   	push   %edx
f01008ae:	56                   	push   %esi
f01008af:	ff 14 85 48 20 10 f0 	call   *-0xfefdfb8(,%eax,4)
			if (runcmd(buf, tf) < 0)
f01008b6:	83 c4 10             	add    $0x10,%esp
f01008b9:	85 c0                	test   %eax,%eax
f01008bb:	79 bd                	jns    f010087a <monitor+0xed>
				break;
	}
}
f01008bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01008c0:	5b                   	pop    %ebx
f01008c1:	5e                   	pop    %esi
f01008c2:	5f                   	pop    %edi
f01008c3:	5d                   	pop    %ebp
f01008c4:	c3                   	ret    

f01008c5 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f01008c5:	55                   	push   %ebp
f01008c6:	89 e5                	mov    %esp,%ebp
f01008c8:	56                   	push   %esi
f01008c9:	53                   	push   %ebx
f01008ca:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f01008cc:	83 ec 0c             	sub    $0xc,%esp
f01008cf:	50                   	push   %eax
f01008d0:	e8 13 01 00 00       	call   f01009e8 <mc146818_read>
f01008d5:	89 c3                	mov    %eax,%ebx
f01008d7:	83 c6 01             	add    $0x1,%esi
f01008da:	89 34 24             	mov    %esi,(%esp)
f01008dd:	e8 06 01 00 00       	call   f01009e8 <mc146818_read>
f01008e2:	c1 e0 08             	shl    $0x8,%eax
f01008e5:	09 d8                	or     %ebx,%eax
}
f01008e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01008ea:	5b                   	pop    %ebx
f01008eb:	5e                   	pop    %esi
f01008ec:	5d                   	pop    %ebp
f01008ed:	c3                   	ret    

f01008ee <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f01008ee:	55                   	push   %ebp
f01008ef:	89 e5                	mov    %esp,%ebp
f01008f1:	56                   	push   %esi
f01008f2:	53                   	push   %ebx
	basemem = nvram_read(NVRAM_BASELO);
f01008f3:	b8 15 00 00 00       	mov    $0x15,%eax
f01008f8:	e8 c8 ff ff ff       	call   f01008c5 <nvram_read>
f01008fd:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f01008ff:	b8 17 00 00 00       	mov    $0x17,%eax
f0100904:	e8 bc ff ff ff       	call   f01008c5 <nvram_read>
f0100909:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f010090b:	b8 34 00 00 00       	mov    $0x34,%eax
f0100910:	e8 b0 ff ff ff       	call   f01008c5 <nvram_read>
	if (ext16mem)
f0100915:	c1 e0 06             	shl    $0x6,%eax
f0100918:	74 38                	je     f0100952 <mem_init+0x64>
		totalmem = 16 * 1024 + ext16mem;
f010091a:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f010091f:	89 c2                	mov    %eax,%edx
f0100921:	c1 ea 02             	shr    $0x2,%edx
f0100924:	89 15 68 39 11 f0    	mov    %edx,0xf0113968
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010092a:	89 c2                	mov    %eax,%edx
f010092c:	29 da                	sub    %ebx,%edx
f010092e:	52                   	push   %edx
f010092f:	53                   	push   %ebx
f0100930:	50                   	push   %eax
f0100931:	68 64 20 10 f0       	push   $0xf0102064
f0100936:	e8 14 01 00 00       	call   f0100a4f <cprintf>

	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();

	// Remove this line when you're ready to test this function.
	panic("mem_init: This function is not finished\n");
f010093b:	83 c4 0c             	add    $0xc,%esp
f010093e:	68 a0 20 10 f0       	push   $0xf01020a0
f0100943:	68 80 00 00 00       	push   $0x80
f0100948:	68 cc 20 10 f0       	push   $0xf01020cc
f010094d:	e8 39 f7 ff ff       	call   f010008b <_panic>
		totalmem = basemem;
f0100952:	89 d8                	mov    %ebx,%eax
	else if (extmem)
f0100954:	85 f6                	test   %esi,%esi
f0100956:	74 c7                	je     f010091f <mem_init+0x31>
		totalmem = 1 * 1024 + extmem;
f0100958:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f010095e:	eb bf                	jmp    f010091f <mem_init+0x31>

f0100960 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f0100960:	55                   	push   %ebp
f0100961:	89 e5                	mov    %esp,%ebp
f0100963:	56                   	push   %esi
f0100964:	53                   	push   %ebx
f0100965:	8b 1d 58 35 11 f0    	mov    0xf0113558,%ebx
	//
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	size_t i;
	for (i = 0; i < npages; i++) {
f010096b:	ba 00 00 00 00       	mov    $0x0,%edx
f0100970:	b8 00 00 00 00       	mov    $0x0,%eax
f0100975:	be 01 00 00 00       	mov    $0x1,%esi
f010097a:	39 05 68 39 11 f0    	cmp    %eax,0xf0113968
f0100980:	76 26                	jbe    f01009a8 <page_init+0x48>
f0100982:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100989:	89 d1                	mov    %edx,%ecx
f010098b:	03 0d 70 39 11 f0    	add    0xf0113970,%ecx
f0100991:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100997:	89 19                	mov    %ebx,(%ecx)
	for (i = 0; i < npages; i++) {
f0100999:	83 c0 01             	add    $0x1,%eax
		page_free_list = &pages[i];
f010099c:	89 d3                	mov    %edx,%ebx
f010099e:	03 1d 70 39 11 f0    	add    0xf0113970,%ebx
f01009a4:	89 f2                	mov    %esi,%edx
f01009a6:	eb d2                	jmp    f010097a <page_init+0x1a>
f01009a8:	84 d2                	test   %dl,%dl
f01009aa:	74 06                	je     f01009b2 <page_init+0x52>
f01009ac:	89 1d 58 35 11 f0    	mov    %ebx,0xf0113558
	}
}
f01009b2:	5b                   	pop    %ebx
f01009b3:	5e                   	pop    %esi
f01009b4:	5d                   	pop    %ebp
f01009b5:	c3                   	ret    

f01009b6 <page_alloc>:
struct PageInfo *
page_alloc(int alloc_flags)
{
	// Fill this function in
	return 0;
}
f01009b6:	b8 00 00 00 00       	mov    $0x0,%eax
f01009bb:	c3                   	ret    

f01009bc <page_free>:
page_free(struct PageInfo *pp)
{
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
}
f01009bc:	c3                   	ret    

f01009bd <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f01009bd:	55                   	push   %ebp
f01009be:	89 e5                	mov    %esp,%ebp
f01009c0:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f01009c3:	66 83 68 04 01       	subw   $0x1,0x4(%eax)
		page_free(pp);
}
f01009c8:	5d                   	pop    %ebp
f01009c9:	c3                   	ret    

f01009ca <pgdir_walk>:
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
	// Fill this function in
	return NULL;
}
f01009ca:	b8 00 00 00 00       	mov    $0x0,%eax
f01009cf:	c3                   	ret    

f01009d0 <page_insert>:
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
	// Fill this function in
	return 0;
}
f01009d0:	b8 00 00 00 00       	mov    $0x0,%eax
f01009d5:	c3                   	ret    

f01009d6 <page_lookup>:
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
	// Fill this function in
	return NULL;
}
f01009d6:	b8 00 00 00 00       	mov    $0x0,%eax
f01009db:	c3                   	ret    

f01009dc <page_remove>:
//
void
page_remove(pde_t *pgdir, void *va)
{
	// Fill this function in
}
f01009dc:	c3                   	ret    

f01009dd <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f01009dd:	55                   	push   %ebp
f01009de:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01009e0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01009e3:	0f 01 38             	invlpg (%eax)
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
f01009e6:	5d                   	pop    %ebp
f01009e7:	c3                   	ret    

f01009e8 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f01009e8:	55                   	push   %ebp
f01009e9:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01009eb:	8b 45 08             	mov    0x8(%ebp),%eax
f01009ee:	ba 70 00 00 00       	mov    $0x70,%edx
f01009f3:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01009f4:	ba 71 00 00 00       	mov    $0x71,%edx
f01009f9:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01009fa:	0f b6 c0             	movzbl %al,%eax
}
f01009fd:	5d                   	pop    %ebp
f01009fe:	c3                   	ret    

f01009ff <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01009ff:	55                   	push   %ebp
f0100a00:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100a02:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a05:	ba 70 00 00 00       	mov    $0x70,%edx
f0100a0a:	ee                   	out    %al,(%dx)
f0100a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a0e:	ba 71 00 00 00       	mov    $0x71,%edx
f0100a13:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0100a14:	5d                   	pop    %ebp
f0100a15:	c3                   	ret    

f0100a16 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0100a16:	55                   	push   %ebp
f0100a17:	89 e5                	mov    %esp,%ebp
f0100a19:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0100a1c:	ff 75 08             	pushl  0x8(%ebp)
f0100a1f:	e8 cd fb ff ff       	call   f01005f1 <cputchar>
	*cnt++;
}
f0100a24:	83 c4 10             	add    $0x10,%esp
f0100a27:	c9                   	leave  
f0100a28:	c3                   	ret    

f0100a29 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0100a29:	55                   	push   %ebp
f0100a2a:	89 e5                	mov    %esp,%ebp
f0100a2c:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0100a2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0100a36:	ff 75 0c             	pushl  0xc(%ebp)
f0100a39:	ff 75 08             	pushl  0x8(%ebp)
f0100a3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100a3f:	50                   	push   %eax
f0100a40:	68 16 0a 10 f0       	push   $0xf0100a16
f0100a45:	e8 6f 04 00 00       	call   f0100eb9 <vprintfmt>
	return cnt;
}
f0100a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100a4d:	c9                   	leave  
f0100a4e:	c3                   	ret    

f0100a4f <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0100a4f:	55                   	push   %ebp
f0100a50:	89 e5                	mov    %esp,%ebp
f0100a52:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0100a55:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0100a58:	50                   	push   %eax
f0100a59:	ff 75 08             	pushl  0x8(%ebp)
f0100a5c:	e8 c8 ff ff ff       	call   f0100a29 <vcprintf>
	va_end(ap);

	return cnt;
}
f0100a61:	c9                   	leave  
f0100a62:	c3                   	ret    

f0100a63 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0100a63:	55                   	push   %ebp
f0100a64:	89 e5                	mov    %esp,%ebp
f0100a66:	57                   	push   %edi
f0100a67:	56                   	push   %esi
f0100a68:	53                   	push   %ebx
f0100a69:	83 ec 14             	sub    $0x14,%esp
f0100a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0100a6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100a72:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100a75:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100a78:	8b 1a                	mov    (%edx),%ebx
f0100a7a:	8b 01                	mov    (%ecx),%eax
f0100a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100a7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0100a86:	eb 23                	jmp    f0100aab <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0100a88:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0100a8b:	eb 1e                	jmp    f0100aab <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100a8d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100a90:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0100a93:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0100a97:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100a9a:	73 41                	jae    f0100add <stab_binsearch+0x7a>
			*region_left = m;
f0100a9c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100a9f:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0100aa1:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0100aa4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0100aab:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0100aae:	7f 5a                	jg     f0100b0a <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0100ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100ab3:	01 d8                	add    %ebx,%eax
f0100ab5:	89 c7                	mov    %eax,%edi
f0100ab7:	c1 ef 1f             	shr    $0x1f,%edi
f0100aba:	01 c7                	add    %eax,%edi
f0100abc:	d1 ff                	sar    %edi
f0100abe:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100ac1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0100ac4:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0100ac8:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0100aca:	39 c3                	cmp    %eax,%ebx
f0100acc:	7f ba                	jg     f0100a88 <stab_binsearch+0x25>
f0100ace:	0f b6 0a             	movzbl (%edx),%ecx
f0100ad1:	83 ea 0c             	sub    $0xc,%edx
f0100ad4:	39 f1                	cmp    %esi,%ecx
f0100ad6:	74 b5                	je     f0100a8d <stab_binsearch+0x2a>
			m--;
f0100ad8:	83 e8 01             	sub    $0x1,%eax
f0100adb:	eb ed                	jmp    f0100aca <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f0100add:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100ae0:	76 14                	jbe    f0100af6 <stab_binsearch+0x93>
			*region_right = m - 1;
f0100ae2:	83 e8 01             	sub    $0x1,%eax
f0100ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100ae8:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0100aeb:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0100aed:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100af4:	eb b5                	jmp    f0100aab <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0100af6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100af9:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0100afb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0100aff:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0100b01:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0100b08:	eb a1                	jmp    f0100aab <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0100b0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0100b0e:	75 15                	jne    f0100b25 <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0100b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100b13:	8b 00                	mov    (%eax),%eax
f0100b15:	83 e8 01             	sub    $0x1,%eax
f0100b18:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0100b1b:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0100b1d:	83 c4 14             	add    $0x14,%esp
f0100b20:	5b                   	pop    %ebx
f0100b21:	5e                   	pop    %esi
f0100b22:	5f                   	pop    %edi
f0100b23:	5d                   	pop    %ebp
f0100b24:	c3                   	ret    
		for (l = *region_right;
f0100b25:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100b28:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100b2a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100b2d:	8b 0f                	mov    (%edi),%ecx
f0100b2f:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100b32:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0100b35:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0100b39:	eb 03                	jmp    f0100b3e <stab_binsearch+0xdb>
		     l--)
f0100b3b:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0100b3e:	39 c1                	cmp    %eax,%ecx
f0100b40:	7d 0a                	jge    f0100b4c <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0100b42:	0f b6 1a             	movzbl (%edx),%ebx
f0100b45:	83 ea 0c             	sub    $0xc,%edx
f0100b48:	39 f3                	cmp    %esi,%ebx
f0100b4a:	75 ef                	jne    f0100b3b <stab_binsearch+0xd8>
		*region_left = l;
f0100b4c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100b4f:	89 06                	mov    %eax,(%esi)
}
f0100b51:	eb ca                	jmp    f0100b1d <stab_binsearch+0xba>

f0100b53 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100b53:	55                   	push   %ebp
f0100b54:	89 e5                	mov    %esp,%ebp
f0100b56:	57                   	push   %edi
f0100b57:	56                   	push   %esi
f0100b58:	53                   	push   %ebx
f0100b59:	83 ec 3c             	sub    $0x3c,%esp
f0100b5c:	8b 75 08             	mov    0x8(%ebp),%esi
f0100b5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100b62:	c7 03 d8 20 10 f0    	movl   $0xf01020d8,(%ebx)
	info->eip_line = 0;
f0100b68:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0100b6f:	c7 43 08 d8 20 10 f0 	movl   $0xf01020d8,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0100b76:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0100b7d:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0100b80:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100b87:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0100b8d:	0f 86 1c 01 00 00    	jbe    f0100caf <debuginfo_eip+0x15c>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100b93:	b8 9b 8f 10 f0       	mov    $0xf0108f9b,%eax
f0100b98:	3d 6d 72 10 f0       	cmp    $0xf010726d,%eax
f0100b9d:	0f 86 aa 01 00 00    	jbe    f0100d4d <debuginfo_eip+0x1fa>
f0100ba3:	80 3d 9a 8f 10 f0 00 	cmpb   $0x0,0xf0108f9a
f0100baa:	0f 85 a4 01 00 00    	jne    f0100d54 <debuginfo_eip+0x201>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100bb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100bb7:	b8 6c 72 10 f0       	mov    $0xf010726c,%eax
f0100bbc:	2d 34 23 10 f0       	sub    $0xf0102334,%eax
f0100bc1:	c1 f8 02             	sar    $0x2,%eax
f0100bc4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100bca:	83 e8 01             	sub    $0x1,%eax
f0100bcd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100bd0:	83 ec 08             	sub    $0x8,%esp
f0100bd3:	56                   	push   %esi
f0100bd4:	6a 64                	push   $0x64
f0100bd6:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100bd9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100bdc:	b8 34 23 10 f0       	mov    $0xf0102334,%eax
f0100be1:	e8 7d fe ff ff       	call   f0100a63 <stab_binsearch>
	if (lfile == 0)
f0100be6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100be9:	83 c4 10             	add    $0x10,%esp
f0100bec:	85 c0                	test   %eax,%eax
f0100bee:	0f 84 67 01 00 00    	je     f0100d5b <debuginfo_eip+0x208>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100bf4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0100bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100bfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100bfd:	83 ec 08             	sub    $0x8,%esp
f0100c00:	56                   	push   %esi
f0100c01:	6a 24                	push   $0x24
f0100c03:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100c06:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100c09:	b8 34 23 10 f0       	mov    $0xf0102334,%eax
f0100c0e:	e8 50 fe ff ff       	call   f0100a63 <stab_binsearch>

	if (lfun <= rfun) {
f0100c13:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100c16:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0100c19:	83 c4 10             	add    $0x10,%esp
f0100c1c:	39 d0                	cmp    %edx,%eax
f0100c1e:	0f 8f 9f 00 00 00    	jg     f0100cc3 <debuginfo_eip+0x170>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100c24:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0100c27:	c1 e1 02             	shl    $0x2,%ecx
f0100c2a:	8d b9 34 23 10 f0    	lea    -0xfefdccc(%ecx),%edi
f0100c30:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0100c33:	8b b9 34 23 10 f0    	mov    -0xfefdccc(%ecx),%edi
f0100c39:	b9 9b 8f 10 f0       	mov    $0xf0108f9b,%ecx
f0100c3e:	81 e9 6d 72 10 f0    	sub    $0xf010726d,%ecx
f0100c44:	39 cf                	cmp    %ecx,%edi
f0100c46:	73 09                	jae    f0100c51 <debuginfo_eip+0xfe>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100c48:	81 c7 6d 72 10 f0    	add    $0xf010726d,%edi
f0100c4e:	89 7b 08             	mov    %edi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100c51:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100c54:	8b 4f 08             	mov    0x8(%edi),%ecx
f0100c57:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0100c5a:	29 ce                	sub    %ecx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0100c5c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0100c5f:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100c62:	83 ec 08             	sub    $0x8,%esp
f0100c65:	6a 3a                	push   $0x3a
f0100c67:	ff 73 08             	pushl  0x8(%ebx)
f0100c6a:	e8 3e 0a 00 00       	call   f01016ad <strfind>
f0100c6f:	2b 43 08             	sub    0x8(%ebx),%eax
f0100c72:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0100c75:	83 c4 08             	add    $0x8,%esp
f0100c78:	56                   	push   %esi
f0100c79:	6a 44                	push   $0x44
f0100c7b:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0100c7e:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0100c81:	b8 34 23 10 f0       	mov    $0xf0102334,%eax
f0100c86:	e8 d8 fd ff ff       	call   f0100a63 <stab_binsearch>
	if (lline <= rline) {
f0100c8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100c8e:	83 c4 10             	add    $0x10,%esp
f0100c91:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0100c94:	0f 8f c8 00 00 00    	jg     f0100d62 <debuginfo_eip+0x20f>
		info->eip_line = stabs[lline].n_desc;
f0100c9a:	89 d0                	mov    %edx,%eax
f0100c9c:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0100c9f:	0f b7 14 95 3a 23 10 	movzwl -0xfefdcc6(,%edx,4),%edx
f0100ca6:	f0 
f0100ca7:	89 53 04             	mov    %edx,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100caa:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100cad:	eb 28                	jmp    f0100cd7 <debuginfo_eip+0x184>
  	        panic("User address");
f0100caf:	83 ec 04             	sub    $0x4,%esp
f0100cb2:	68 e2 20 10 f0       	push   $0xf01020e2
f0100cb7:	6a 7f                	push   $0x7f
f0100cb9:	68 ef 20 10 f0       	push   $0xf01020ef
f0100cbe:	e8 c8 f3 ff ff       	call   f010008b <_panic>
		info->eip_fn_addr = addr;
f0100cc3:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0100cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100cc9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0100ccc:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100ccf:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100cd2:	eb 8e                	jmp    f0100c62 <debuginfo_eip+0x10f>
f0100cd4:	83 e8 01             	sub    $0x1,%eax
	while (lline >= lfile
f0100cd7:	39 c6                	cmp    %eax,%esi
f0100cd9:	7f 3f                	jg     f0100d1a <debuginfo_eip+0x1c7>
f0100cdb:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
	       && stabs[lline].n_type != N_SOL
f0100cde:	0f b6 14 8d 38 23 10 	movzbl -0xfefdcc8(,%ecx,4),%edx
f0100ce5:	f0 
f0100ce6:	80 fa 84             	cmp    $0x84,%dl
f0100ce9:	74 0f                	je     f0100cfa <debuginfo_eip+0x1a7>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100ceb:	80 fa 64             	cmp    $0x64,%dl
f0100cee:	75 e4                	jne    f0100cd4 <debuginfo_eip+0x181>
f0100cf0:	83 3c 8d 3c 23 10 f0 	cmpl   $0x0,-0xfefdcc4(,%ecx,4)
f0100cf7:	00 
f0100cf8:	74 da                	je     f0100cd4 <debuginfo_eip+0x181>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100cfa:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100cfd:	8b 14 85 34 23 10 f0 	mov    -0xfefdccc(,%eax,4),%edx
f0100d04:	b8 9b 8f 10 f0       	mov    $0xf0108f9b,%eax
f0100d09:	2d 6d 72 10 f0       	sub    $0xf010726d,%eax
f0100d0e:	39 c2                	cmp    %eax,%edx
f0100d10:	73 08                	jae    f0100d1a <debuginfo_eip+0x1c7>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100d12:	81 c2 6d 72 10 f0    	add    $0xf010726d,%edx
f0100d18:	89 13                	mov    %edx,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0100d1a:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100d1d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0100d20:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0100d25:	39 ca                	cmp    %ecx,%edx
f0100d27:	7d 45                	jge    f0100d6e <debuginfo_eip+0x21b>
f0100d29:	8d 42 01             	lea    0x1(%edx),%eax
		for (lline = lfun + 1;
f0100d2c:	eb 04                	jmp    f0100d32 <debuginfo_eip+0x1df>
			info->eip_fn_narg++;
f0100d2e:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0100d32:	39 c1                	cmp    %eax,%ecx
f0100d34:	7e 33                	jle    f0100d69 <debuginfo_eip+0x216>
f0100d36:	83 c0 01             	add    $0x1,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100d39:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100d3c:	80 3c 95 2c 23 10 f0 	cmpb   $0xa0,-0xfefdcd4(,%edx,4)
f0100d43:	a0 
f0100d44:	74 e8                	je     f0100d2e <debuginfo_eip+0x1db>
	return 0;
f0100d46:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d4b:	eb 21                	jmp    f0100d6e <debuginfo_eip+0x21b>
		return -1;
f0100d4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d52:	eb 1a                	jmp    f0100d6e <debuginfo_eip+0x21b>
f0100d54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d59:	eb 13                	jmp    f0100d6e <debuginfo_eip+0x21b>
		return -1;
f0100d5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d60:	eb 0c                	jmp    f0100d6e <debuginfo_eip+0x21b>
		return -1;
f0100d62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d67:	eb 05                	jmp    f0100d6e <debuginfo_eip+0x21b>
	return 0;
f0100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d71:	5b                   	pop    %ebx
f0100d72:	5e                   	pop    %esi
f0100d73:	5f                   	pop    %edi
f0100d74:	5d                   	pop    %ebp
f0100d75:	c3                   	ret    

f0100d76 <mapcolor>:
	return ch <= '9' && ch >= '0';
}

static uint8_t
mapcolor(uint16_t ascii_color) 
{
f0100d76:	89 c2                	mov    %eax,%edx
	uint16_t default_value = 7; // white
f0100d78:	b9 07 00 00 00       	mov    $0x7,%ecx
	if (ascii_color >= 40) { // is background
f0100d7d:	66 83 f8 27          	cmp    $0x27,%ax
f0100d81:	76 08                	jbe    f0100d8b <mapcolor+0x15>
		ascii_color -= 10;
f0100d83:	8d 50 f6             	lea    -0xa(%eax),%edx
		default_value = 0;
f0100d86:	b9 00 00 00 00       	mov    $0x0,%ecx
	}
	switch(ascii_color) {
f0100d8b:	83 ea 1e             	sub    $0x1e,%edx
f0100d8e:	66 83 fa 07          	cmp    $0x7,%dx
f0100d92:	77 34                	ja     f0100dc8 <mapcolor+0x52>
f0100d94:	0f b7 d2             	movzwl %dx,%edx
f0100d97:	ff 24 95 00 21 10 f0 	jmp    *-0xfefdf00(,%edx,4)
		case 30:// Black
			return 0;
		case 31:// Red
			return 4;
f0100d9e:	b8 04 00 00 00       	mov    $0x4,%eax
f0100da3:	c3                   	ret    
		case 32:// Green
			return 2;
f0100da4:	b8 02 00 00 00       	mov    $0x2,%eax
f0100da9:	c3                   	ret    
		case 33:// Yellow
			return 6;
f0100daa:	b8 06 00 00 00       	mov    $0x6,%eax
f0100daf:	c3                   	ret    
		case 34:// Blue
			return 1;
f0100db0:	b8 01 00 00 00       	mov    $0x1,%eax
f0100db5:	c3                   	ret    
		case 35:// Magenta
			return 5;
f0100db6:	b8 05 00 00 00       	mov    $0x5,%eax
f0100dbb:	c3                   	ret    
		case 36:// Cyan
			return 3;
f0100dbc:	b8 03 00 00 00       	mov    $0x3,%eax
f0100dc1:	c3                   	ret    
		case 37:// White
			return 7;
f0100dc2:	b8 07 00 00 00       	mov    $0x7,%eax
f0100dc7:	c3                   	ret    
	}
	return default_value;
f0100dc8:	89 c8                	mov    %ecx,%eax
f0100dca:	c3                   	ret    
			return 0;
f0100dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100dd0:	c3                   	ret    

f0100dd1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100dd1:	55                   	push   %ebp
f0100dd2:	89 e5                	mov    %esp,%ebp
f0100dd4:	57                   	push   %edi
f0100dd5:	56                   	push   %esi
f0100dd6:	53                   	push   %ebx
f0100dd7:	83 ec 1c             	sub    $0x1c,%esp
f0100dda:	89 c7                	mov    %eax,%edi
f0100ddc:	89 d6                	mov    %edx,%esi
f0100dde:	8b 45 08             	mov    0x8(%ebp),%eax
f0100de1:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100de4:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100de7:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100dea:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0100ded:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100df2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100df5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0100df8:	3b 45 10             	cmp    0x10(%ebp),%eax
f0100dfb:	89 d0                	mov    %edx,%eax
f0100dfd:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
f0100e00:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0100e03:	73 15                	jae    f0100e1a <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0100e05:	83 eb 01             	sub    $0x1,%ebx
f0100e08:	85 db                	test   %ebx,%ebx
f0100e0a:	7e 43                	jle    f0100e4f <printnum+0x7e>
			putch(padc, putdat);
f0100e0c:	83 ec 08             	sub    $0x8,%esp
f0100e0f:	56                   	push   %esi
f0100e10:	ff 75 18             	pushl  0x18(%ebp)
f0100e13:	ff d7                	call   *%edi
f0100e15:	83 c4 10             	add    $0x10,%esp
f0100e18:	eb eb                	jmp    f0100e05 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0100e1a:	83 ec 0c             	sub    $0xc,%esp
f0100e1d:	ff 75 18             	pushl  0x18(%ebp)
f0100e20:	8b 45 14             	mov    0x14(%ebp),%eax
f0100e23:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0100e26:	53                   	push   %ebx
f0100e27:	ff 75 10             	pushl  0x10(%ebp)
f0100e2a:	83 ec 08             	sub    $0x8,%esp
f0100e2d:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100e30:	ff 75 e0             	pushl  -0x20(%ebp)
f0100e33:	ff 75 dc             	pushl  -0x24(%ebp)
f0100e36:	ff 75 d8             	pushl  -0x28(%ebp)
f0100e39:	e8 82 0a 00 00       	call   f01018c0 <__udivdi3>
f0100e3e:	83 c4 18             	add    $0x18,%esp
f0100e41:	52                   	push   %edx
f0100e42:	50                   	push   %eax
f0100e43:	89 f2                	mov    %esi,%edx
f0100e45:	89 f8                	mov    %edi,%eax
f0100e47:	e8 85 ff ff ff       	call   f0100dd1 <printnum>
f0100e4c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0100e4f:	83 ec 08             	sub    $0x8,%esp
f0100e52:	56                   	push   %esi
f0100e53:	83 ec 04             	sub    $0x4,%esp
f0100e56:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100e59:	ff 75 e0             	pushl  -0x20(%ebp)
f0100e5c:	ff 75 dc             	pushl  -0x24(%ebp)
f0100e5f:	ff 75 d8             	pushl  -0x28(%ebp)
f0100e62:	e8 69 0b 00 00       	call   f01019d0 <__umoddi3>
f0100e67:	83 c4 14             	add    $0x14,%esp
f0100e6a:	0f be 80 94 22 10 f0 	movsbl -0xfefdd6c(%eax),%eax
f0100e71:	50                   	push   %eax
f0100e72:	ff d7                	call   *%edi
}
f0100e74:	83 c4 10             	add    $0x10,%esp
f0100e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e7a:	5b                   	pop    %ebx
f0100e7b:	5e                   	pop    %esi
f0100e7c:	5f                   	pop    %edi
f0100e7d:	5d                   	pop    %ebp
f0100e7e:	c3                   	ret    

f0100e7f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0100e7f:	55                   	push   %ebp
f0100e80:	89 e5                	mov    %esp,%ebp
f0100e82:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0100e85:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0100e89:	8b 10                	mov    (%eax),%edx
f0100e8b:	3b 50 04             	cmp    0x4(%eax),%edx
f0100e8e:	73 0a                	jae    f0100e9a <sprintputch+0x1b>
		*b->buf++ = ch;
f0100e90:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100e93:	89 08                	mov    %ecx,(%eax)
f0100e95:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e98:	88 02                	mov    %al,(%edx)
}
f0100e9a:	5d                   	pop    %ebp
f0100e9b:	c3                   	ret    

f0100e9c <printfmt>:
{
f0100e9c:	55                   	push   %ebp
f0100e9d:	89 e5                	mov    %esp,%ebp
f0100e9f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0100ea2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0100ea5:	50                   	push   %eax
f0100ea6:	ff 75 10             	pushl  0x10(%ebp)
f0100ea9:	ff 75 0c             	pushl  0xc(%ebp)
f0100eac:	ff 75 08             	pushl  0x8(%ebp)
f0100eaf:	e8 05 00 00 00       	call   f0100eb9 <vprintfmt>
}
f0100eb4:	83 c4 10             	add    $0x10,%esp
f0100eb7:	c9                   	leave  
f0100eb8:	c3                   	ret    

f0100eb9 <vprintfmt>:
{
f0100eb9:	55                   	push   %ebp
f0100eba:	89 e5                	mov    %esp,%ebp
f0100ebc:	57                   	push   %edi
f0100ebd:	56                   	push   %esi
f0100ebe:	53                   	push   %ebx
f0100ebf:	83 ec 2c             	sub    $0x2c,%esp
f0100ec2:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0100ec5:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0100ec8:	eb 0d                	jmp    f0100ed7 <vprintfmt+0x1e>
			putch(ch, putdat);
f0100eca:	83 ec 08             	sub    $0x8,%esp
f0100ecd:	57                   	push   %edi
f0100ece:	50                   	push   %eax
f0100ecf:	ff 55 08             	call   *0x8(%ebp)
f0100ed2:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0100ed5:	89 f3                	mov    %esi,%ebx
f0100ed7:	8d 73 01             	lea    0x1(%ebx),%esi
f0100eda:	0f b6 03             	movzbl (%ebx),%eax
f0100edd:	83 f8 25             	cmp    $0x25,%eax
f0100ee0:	0f 84 b2 00 00 00    	je     f0100f98 <vprintfmt+0xdf>
			if (ch == '\0') {
f0100ee6:	85 c0                	test   %eax,%eax
f0100ee8:	0f 84 0a 05 00 00    	je     f01013f8 <vprintfmt+0x53f>
			if (ch == 0x1b && *ufmt == '[' && isdigit(*(ufmt+1)) &&
f0100eee:	83 f8 1b             	cmp    $0x1b,%eax
f0100ef1:	75 d7                	jne    f0100eca <vprintfmt+0x11>
f0100ef3:	80 7b 01 5b          	cmpb   $0x5b,0x1(%ebx)
f0100ef7:	75 d1                	jne    f0100eca <vprintfmt+0x11>
f0100ef9:	0f b6 53 02          	movzbl 0x2(%ebx),%edx
	return ch <= '9' && ch >= '0';
f0100efd:	8d 4a d0             	lea    -0x30(%edx),%ecx
			if (ch == 0x1b && *ufmt == '[' && isdigit(*(ufmt+1)) &&
f0100f00:	80 f9 09             	cmp    $0x9,%cl
f0100f03:	77 c5                	ja     f0100eca <vprintfmt+0x11>
			    isdigit(*(ufmt+2)) && *(ufmt+3) == ';' &&
f0100f05:	0f b6 4b 03          	movzbl 0x3(%ebx),%ecx
f0100f09:	88 4d e0             	mov    %cl,-0x20(%ebp)
	return ch <= '9' && ch >= '0';
f0100f0c:	83 e9 30             	sub    $0x30,%ecx
			if (ch == 0x1b && *ufmt == '[' && isdigit(*(ufmt+1)) &&
f0100f0f:	80 f9 09             	cmp    $0x9,%cl
f0100f12:	77 b6                	ja     f0100eca <vprintfmt+0x11>
			    isdigit(*(ufmt+2)) && *(ufmt+3) == ';' &&
f0100f14:	80 7b 04 3b          	cmpb   $0x3b,0x4(%ebx)
f0100f18:	75 b0                	jne    f0100eca <vprintfmt+0x11>
			    isdigit(*(ufmt+4)) && isdigit(*(ufmt+5))
f0100f1a:	0f b6 4b 05          	movzbl 0x5(%ebx),%ecx
f0100f1e:	88 4d dc             	mov    %cl,-0x24(%ebp)
	return ch <= '9' && ch >= '0';
f0100f21:	83 e9 30             	sub    $0x30,%ecx
			    isdigit(*(ufmt+2)) && *(ufmt+3) == ';' &&
f0100f24:	80 f9 09             	cmp    $0x9,%cl
f0100f27:	77 a1                	ja     f0100eca <vprintfmt+0x11>
			    isdigit(*(ufmt+4)) && isdigit(*(ufmt+5))
f0100f29:	0f b6 4b 06          	movzbl 0x6(%ebx),%ecx
f0100f2d:	88 4d d8             	mov    %cl,-0x28(%ebp)
	return ch <= '9' && ch >= '0';
f0100f30:	83 e9 30             	sub    $0x30,%ecx
			    isdigit(*(ufmt+4)) && isdigit(*(ufmt+5))
f0100f33:	80 f9 09             	cmp    $0x9,%cl
f0100f36:	77 92                	ja     f0100eca <vprintfmt+0x11>
			    && *(ufmt+6) == 'm') {
f0100f38:	80 7b 07 6d          	cmpb   $0x6d,0x7(%ebx)
f0100f3c:	75 8c                	jne    f0100eca <vprintfmt+0x11>
				uint8_t foreground = mapcolor((*(ufmt+1) - '0') * 10 +
f0100f3e:	0f b6 d2             	movzbl %dl,%edx
f0100f41:	8d 94 92 10 ff ff ff 	lea    -0xf0(%edx,%edx,4),%edx
					(*(ufmt+2) - '0'));
f0100f48:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
				uint8_t foreground = mapcolor((*(ufmt+1) - '0') * 10 +
f0100f4c:	8d 44 50 d0          	lea    -0x30(%eax,%edx,2),%eax
f0100f50:	0f b7 c0             	movzwl %ax,%eax
f0100f53:	e8 1e fe ff ff       	call   f0100d76 <mapcolor>
f0100f58:	89 c6                	mov    %eax,%esi
				uint8_t background = mapcolor((*(ufmt+4) - '0') * 10 + 
f0100f5a:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
f0100f5e:	8d 84 80 10 ff ff ff 	lea    -0xf0(%eax,%eax,4),%eax
					(*(ufmt+5) - '0'));
f0100f65:	0f b6 55 d8          	movzbl -0x28(%ebp),%edx
				uint8_t background = mapcolor((*(ufmt+4) - '0') * 10 + 
f0100f69:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
f0100f6d:	0f b7 c0             	movzwl %ax,%eax
f0100f70:	e8 01 fe ff ff       	call   f0100d76 <mapcolor>
				set_color_info(color);
f0100f75:	83 ec 0c             	sub    $0xc,%esp
				uint16_t color = (background << 12) | (foreground << 8);
f0100f78:	89 c2                	mov    %eax,%edx
f0100f7a:	c1 e2 0c             	shl    $0xc,%edx
f0100f7d:	89 f0                	mov    %esi,%eax
f0100f7f:	c1 e0 08             	shl    $0x8,%eax
f0100f82:	09 d0                	or     %edx,%eax
				set_color_info(color);
f0100f84:	0f b7 c0             	movzwl %ax,%eax
f0100f87:	50                   	push   %eax
f0100f88:	e8 8b f6 ff ff       	call   f0100618 <set_color_info>
				fmt += 7;
f0100f8d:	83 c3 08             	add    $0x8,%ebx
				continue;	
f0100f90:	83 c4 10             	add    $0x10,%esp
f0100f93:	e9 3f ff ff ff       	jmp    f0100ed7 <vprintfmt+0x1e>
		padc = ' ';
f0100f98:	c6 45 d7 20          	movb   $0x20,-0x29(%ebp)
		altflag = 0;
f0100f9c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0100fa3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		width = -1;
f0100faa:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
		lflag = 0;
f0100fb1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0100fb6:	8d 5e 01             	lea    0x1(%esi),%ebx
f0100fb9:	0f b6 16             	movzbl (%esi),%edx
f0100fbc:	8d 42 dd             	lea    -0x23(%edx),%eax
f0100fbf:	3c 55                	cmp    $0x55,%al
f0100fc1:	0f 87 13 04 00 00    	ja     f01013da <vprintfmt+0x521>
f0100fc7:	0f b6 c0             	movzbl %al,%eax
f0100fca:	ff 24 85 20 21 10 f0 	jmp    *-0xfefdee0(,%eax,4)
f0100fd1:	89 de                	mov    %ebx,%esi
			padc = '-';
f0100fd3:	c6 45 d7 2d          	movb   $0x2d,-0x29(%ebp)
f0100fd7:	eb dd                	jmp    f0100fb6 <vprintfmt+0xfd>
		switch (ch = *(unsigned char *) fmt++) {
f0100fd9:	89 de                	mov    %ebx,%esi
			padc = '0';
f0100fdb:	c6 45 d7 30          	movb   $0x30,-0x29(%ebp)
f0100fdf:	eb d5                	jmp    f0100fb6 <vprintfmt+0xfd>
		switch (ch = *(unsigned char *) fmt++) {
f0100fe1:	0f b6 d2             	movzbl %dl,%edx
f0100fe4:	89 de                	mov    %ebx,%esi
			for (precision = 0; ; ++fmt) {
f0100fe6:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
f0100feb:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100fee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0100ff2:	0f be 16             	movsbl (%esi),%edx
				if (ch < '0' || ch > '9')
f0100ff5:	8d 5a d0             	lea    -0x30(%edx),%ebx
f0100ff8:	83 fb 09             	cmp    $0x9,%ebx
f0100ffb:	77 52                	ja     f010104f <vprintfmt+0x196>
			for (precision = 0; ; ++fmt) {
f0100ffd:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
f0101000:	eb e9                	jmp    f0100feb <vprintfmt+0x132>
			precision = va_arg(ap, int);
f0101002:	8b 45 14             	mov    0x14(%ebp),%eax
f0101005:	8b 00                	mov    (%eax),%eax
f0101007:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010100a:	8b 45 14             	mov    0x14(%ebp),%eax
f010100d:	8d 40 04             	lea    0x4(%eax),%eax
f0101010:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0101013:	89 de                	mov    %ebx,%esi
			if (width < 0)
f0101015:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0101019:	79 9b                	jns    f0100fb6 <vprintfmt+0xfd>
				width = precision, precision = -1;
f010101b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010101e:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0101021:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
f0101028:	eb 8c                	jmp    f0100fb6 <vprintfmt+0xfd>
f010102a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010102d:	85 c0                	test   %eax,%eax
f010102f:	ba 00 00 00 00       	mov    $0x0,%edx
f0101034:	0f 49 d0             	cmovns %eax,%edx
f0101037:	89 55 dc             	mov    %edx,-0x24(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010103a:	89 de                	mov    %ebx,%esi
f010103c:	e9 75 ff ff ff       	jmp    f0100fb6 <vprintfmt+0xfd>
f0101041:	89 de                	mov    %ebx,%esi
			altflag = 1;
f0101043:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f010104a:	e9 67 ff ff ff       	jmp    f0100fb6 <vprintfmt+0xfd>
f010104f:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101052:	eb c1                	jmp    f0101015 <vprintfmt+0x15c>
			lflag++;
f0101054:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0101057:	89 de                	mov    %ebx,%esi
			goto reswitch;
f0101059:	e9 58 ff ff ff       	jmp    f0100fb6 <vprintfmt+0xfd>
			putch(va_arg(ap, int), putdat);
f010105e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101061:	8d 70 04             	lea    0x4(%eax),%esi
f0101064:	83 ec 08             	sub    $0x8,%esp
f0101067:	57                   	push   %edi
f0101068:	ff 30                	pushl  (%eax)
f010106a:	ff 55 08             	call   *0x8(%ebp)
			break;
f010106d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0101070:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
f0101073:	e9 5f fe ff ff       	jmp    f0100ed7 <vprintfmt+0x1e>
			err = va_arg(ap, int);
f0101078:	8b 45 14             	mov    0x14(%ebp),%eax
f010107b:	8d 70 04             	lea    0x4(%eax),%esi
f010107e:	8b 00                	mov    (%eax),%eax
f0101080:	99                   	cltd   
f0101081:	31 d0                	xor    %edx,%eax
f0101083:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0101085:	83 f8 06             	cmp    $0x6,%eax
f0101088:	7f 25                	jg     f01010af <vprintfmt+0x1f6>
f010108a:	8b 14 85 78 22 10 f0 	mov    -0xfefdd88(,%eax,4),%edx
f0101091:	85 d2                	test   %edx,%edx
f0101093:	74 1a                	je     f01010af <vprintfmt+0x1f6>
				printfmt(putch, putdat, "%s", p);
f0101095:	52                   	push   %edx
f0101096:	68 b5 22 10 f0       	push   $0xf01022b5
f010109b:	57                   	push   %edi
f010109c:	ff 75 08             	pushl  0x8(%ebp)
f010109f:	e8 f8 fd ff ff       	call   f0100e9c <printfmt>
f01010a4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01010a7:	89 75 14             	mov    %esi,0x14(%ebp)
f01010aa:	e9 28 fe ff ff       	jmp    f0100ed7 <vprintfmt+0x1e>
				printfmt(putch, putdat, "error %d", err);
f01010af:	50                   	push   %eax
f01010b0:	68 ac 22 10 f0       	push   $0xf01022ac
f01010b5:	57                   	push   %edi
f01010b6:	ff 75 08             	pushl  0x8(%ebp)
f01010b9:	e8 de fd ff ff       	call   f0100e9c <printfmt>
f01010be:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01010c1:	89 75 14             	mov    %esi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01010c4:	e9 0e fe ff ff       	jmp    f0100ed7 <vprintfmt+0x1e>
			if ((p = va_arg(ap, char *)) == NULL)
f01010c9:	8b 45 14             	mov    0x14(%ebp),%eax
f01010cc:	83 c0 04             	add    $0x4,%eax
f01010cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01010d2:	8b 45 14             	mov    0x14(%ebp),%eax
f01010d5:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f01010d7:	85 d2                	test   %edx,%edx
f01010d9:	b8 a5 22 10 f0       	mov    $0xf01022a5,%eax
f01010de:	0f 45 c2             	cmovne %edx,%eax
f01010e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (width > 0 && padc != '-')
f01010e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01010e8:	7e 06                	jle    f01010f0 <vprintfmt+0x237>
f01010ea:	80 7d d7 2d          	cmpb   $0x2d,-0x29(%ebp)
f01010ee:	75 0d                	jne    f01010fd <vprintfmt+0x244>
				for (width -= strnlen(p, precision); width > 0; width--)
f01010f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01010f3:	89 c6                	mov    %eax,%esi
f01010f5:	03 45 dc             	add    -0x24(%ebp),%eax
f01010f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01010fb:	eb 41                	jmp    f010113e <vprintfmt+0x285>
f01010fd:	83 ec 08             	sub    $0x8,%esp
f0101100:	ff 75 e0             	pushl  -0x20(%ebp)
f0101103:	50                   	push   %eax
f0101104:	e8 59 04 00 00       	call   f0101562 <strnlen>
f0101109:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010110c:	29 c2                	sub    %eax,%edx
f010110e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101111:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f0101114:	0f be 45 d7          	movsbl -0x29(%ebp),%eax
f0101118:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010111b:	89 d3                	mov    %edx,%ebx
f010111d:	89 c6                	mov    %eax,%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f010111f:	85 db                	test   %ebx,%ebx
f0101121:	7e 59                	jle    f010117c <vprintfmt+0x2c3>
					putch(padc, putdat);
f0101123:	83 ec 08             	sub    $0x8,%esp
f0101126:	57                   	push   %edi
f0101127:	56                   	push   %esi
f0101128:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f010112b:	83 eb 01             	sub    $0x1,%ebx
f010112e:	83 c4 10             	add    $0x10,%esp
f0101131:	eb ec                	jmp    f010111f <vprintfmt+0x266>
					putch(ch, putdat);
f0101133:	83 ec 08             	sub    $0x8,%esp
f0101136:	57                   	push   %edi
f0101137:	52                   	push   %edx
f0101138:	ff 55 08             	call   *0x8(%ebp)
f010113b:	83 c4 10             	add    $0x10,%esp
f010113e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0101141:	29 f1                	sub    %esi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0101143:	83 c6 01             	add    $0x1,%esi
f0101146:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
f010114a:	0f be d0             	movsbl %al,%edx
f010114d:	85 d2                	test   %edx,%edx
f010114f:	74 4f                	je     f01011a0 <vprintfmt+0x2e7>
f0101151:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0101155:	78 06                	js     f010115d <vprintfmt+0x2a4>
f0101157:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
f010115b:	78 39                	js     f0101196 <vprintfmt+0x2dd>
				if (altflag && (ch < ' ' || ch > '~'))
f010115d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0101161:	74 d0                	je     f0101133 <vprintfmt+0x27a>
f0101163:	0f be c0             	movsbl %al,%eax
f0101166:	83 e8 20             	sub    $0x20,%eax
f0101169:	83 f8 5e             	cmp    $0x5e,%eax
f010116c:	76 c5                	jbe    f0101133 <vprintfmt+0x27a>
					putch('?', putdat);
f010116e:	83 ec 08             	sub    $0x8,%esp
f0101171:	57                   	push   %edi
f0101172:	6a 3f                	push   $0x3f
f0101174:	ff 55 08             	call   *0x8(%ebp)
f0101177:	83 c4 10             	add    $0x10,%esp
f010117a:	eb c2                	jmp    f010113e <vprintfmt+0x285>
f010117c:	8b 5d 10             	mov    0x10(%ebp),%ebx
f010117f:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101182:	85 d2                	test   %edx,%edx
f0101184:	b8 00 00 00 00       	mov    $0x0,%eax
f0101189:	0f 49 c2             	cmovns %edx,%eax
f010118c:	29 c2                	sub    %eax,%edx
f010118e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101191:	e9 5a ff ff ff       	jmp    f01010f0 <vprintfmt+0x237>
f0101196:	8b 75 08             	mov    0x8(%ebp),%esi
f0101199:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010119c:	89 cb                	mov    %ecx,%ebx
f010119e:	eb 08                	jmp    f01011a8 <vprintfmt+0x2ef>
f01011a0:	8b 75 08             	mov    0x8(%ebp),%esi
f01011a3:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01011a6:	89 cb                	mov    %ecx,%ebx
			for (; width > 0; width--)
f01011a8:	85 db                	test   %ebx,%ebx
f01011aa:	7e 10                	jle    f01011bc <vprintfmt+0x303>
				putch(' ', putdat);
f01011ac:	83 ec 08             	sub    $0x8,%esp
f01011af:	57                   	push   %edi
f01011b0:	6a 20                	push   $0x20
f01011b2:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01011b4:	83 eb 01             	sub    $0x1,%ebx
f01011b7:	83 c4 10             	add    $0x10,%esp
f01011ba:	eb ec                	jmp    f01011a8 <vprintfmt+0x2ef>
f01011bc:	89 75 08             	mov    %esi,0x8(%ebp)
f01011bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
f01011c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01011c5:	89 45 14             	mov    %eax,0x14(%ebp)
f01011c8:	e9 0a fd ff ff       	jmp    f0100ed7 <vprintfmt+0x1e>
	if (lflag >= 2)
f01011cd:	83 f9 01             	cmp    $0x1,%ecx
f01011d0:	7f 1f                	jg     f01011f1 <vprintfmt+0x338>
	else if (lflag)
f01011d2:	85 c9                	test   %ecx,%ecx
f01011d4:	74 68                	je     f010123e <vprintfmt+0x385>
		return va_arg(*ap, long);
f01011d6:	8b 45 14             	mov    0x14(%ebp),%eax
f01011d9:	8b 30                	mov    (%eax),%esi
f01011db:	89 75 e0             	mov    %esi,-0x20(%ebp)
f01011de:	89 f0                	mov    %esi,%eax
f01011e0:	c1 f8 1f             	sar    $0x1f,%eax
f01011e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01011e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01011e9:	8d 40 04             	lea    0x4(%eax),%eax
f01011ec:	89 45 14             	mov    %eax,0x14(%ebp)
f01011ef:	eb 17                	jmp    f0101208 <vprintfmt+0x34f>
		return va_arg(*ap, long long);
f01011f1:	8b 45 14             	mov    0x14(%ebp),%eax
f01011f4:	8b 50 04             	mov    0x4(%eax),%edx
f01011f7:	8b 00                	mov    (%eax),%eax
f01011f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01011fc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01011ff:	8b 45 14             	mov    0x14(%ebp),%eax
f0101202:	8d 40 08             	lea    0x8(%eax),%eax
f0101205:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0101208:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010120b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 10;
f010120e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f0101213:	85 c9                	test   %ecx,%ecx
f0101215:	0f 89 42 01 00 00    	jns    f010135d <vprintfmt+0x4a4>
				putch('-', putdat);
f010121b:	83 ec 08             	sub    $0x8,%esp
f010121e:	57                   	push   %edi
f010121f:	6a 2d                	push   $0x2d
f0101221:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f0101224:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0101227:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010122a:	f7 da                	neg    %edx
f010122c:	83 d1 00             	adc    $0x0,%ecx
f010122f:	f7 d9                	neg    %ecx
f0101231:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0101234:	b8 0a 00 00 00       	mov    $0xa,%eax
f0101239:	e9 1f 01 00 00       	jmp    f010135d <vprintfmt+0x4a4>
		return va_arg(*ap, int);
f010123e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101241:	8b 30                	mov    (%eax),%esi
f0101243:	89 75 e0             	mov    %esi,-0x20(%ebp)
f0101246:	89 f0                	mov    %esi,%eax
f0101248:	c1 f8 1f             	sar    $0x1f,%eax
f010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010124e:	8b 45 14             	mov    0x14(%ebp),%eax
f0101251:	8d 40 04             	lea    0x4(%eax),%eax
f0101254:	89 45 14             	mov    %eax,0x14(%ebp)
f0101257:	eb af                	jmp    f0101208 <vprintfmt+0x34f>
	if (lflag >= 2)
f0101259:	83 f9 01             	cmp    $0x1,%ecx
f010125c:	7f 1e                	jg     f010127c <vprintfmt+0x3c3>
	else if (lflag)
f010125e:	85 c9                	test   %ecx,%ecx
f0101260:	74 32                	je     f0101294 <vprintfmt+0x3db>
		return va_arg(*ap, unsigned long);
f0101262:	8b 45 14             	mov    0x14(%ebp),%eax
f0101265:	8b 10                	mov    (%eax),%edx
f0101267:	b9 00 00 00 00       	mov    $0x0,%ecx
f010126c:	8d 40 04             	lea    0x4(%eax),%eax
f010126f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0101272:	b8 0a 00 00 00       	mov    $0xa,%eax
f0101277:	e9 e1 00 00 00       	jmp    f010135d <vprintfmt+0x4a4>
		return va_arg(*ap, unsigned long long);
f010127c:	8b 45 14             	mov    0x14(%ebp),%eax
f010127f:	8b 10                	mov    (%eax),%edx
f0101281:	8b 48 04             	mov    0x4(%eax),%ecx
f0101284:	8d 40 08             	lea    0x8(%eax),%eax
f0101287:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010128a:	b8 0a 00 00 00       	mov    $0xa,%eax
f010128f:	e9 c9 00 00 00       	jmp    f010135d <vprintfmt+0x4a4>
		return va_arg(*ap, unsigned int);
f0101294:	8b 45 14             	mov    0x14(%ebp),%eax
f0101297:	8b 10                	mov    (%eax),%edx
f0101299:	b9 00 00 00 00       	mov    $0x0,%ecx
f010129e:	8d 40 04             	lea    0x4(%eax),%eax
f01012a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01012a4:	b8 0a 00 00 00       	mov    $0xa,%eax
f01012a9:	e9 af 00 00 00       	jmp    f010135d <vprintfmt+0x4a4>
	if (lflag >= 2)
f01012ae:	83 f9 01             	cmp    $0x1,%ecx
f01012b1:	7f 1f                	jg     f01012d2 <vprintfmt+0x419>
	else if (lflag)
f01012b3:	85 c9                	test   %ecx,%ecx
f01012b5:	74 61                	je     f0101318 <vprintfmt+0x45f>
		return va_arg(*ap, long);
f01012b7:	8b 45 14             	mov    0x14(%ebp),%eax
f01012ba:	8b 30                	mov    (%eax),%esi
f01012bc:	89 75 e0             	mov    %esi,-0x20(%ebp)
f01012bf:	89 f0                	mov    %esi,%eax
f01012c1:	c1 f8 1f             	sar    $0x1f,%eax
f01012c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01012c7:	8b 45 14             	mov    0x14(%ebp),%eax
f01012ca:	8d 40 04             	lea    0x4(%eax),%eax
f01012cd:	89 45 14             	mov    %eax,0x14(%ebp)
f01012d0:	eb 17                	jmp    f01012e9 <vprintfmt+0x430>
		return va_arg(*ap, long long);
f01012d2:	8b 45 14             	mov    0x14(%ebp),%eax
f01012d5:	8b 50 04             	mov    0x4(%eax),%edx
f01012d8:	8b 00                	mov    (%eax),%eax
f01012da:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01012dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01012e0:	8b 45 14             	mov    0x14(%ebp),%eax
f01012e3:	8d 40 08             	lea    0x8(%eax),%eax
f01012e6:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01012e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01012ec:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
			base = 8;
f01012ef:	b8 08 00 00 00       	mov    $0x8,%eax
			if ((long long) num < 0) {
f01012f4:	85 c9                	test   %ecx,%ecx
f01012f6:	79 65                	jns    f010135d <vprintfmt+0x4a4>
				putch('-', putdat);
f01012f8:	83 ec 08             	sub    $0x8,%esp
f01012fb:	57                   	push   %edi
f01012fc:	6a 2d                	push   $0x2d
f01012fe:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f0101301:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0101304:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101307:	f7 da                	neg    %edx
f0101309:	83 d1 00             	adc    $0x0,%ecx
f010130c:	f7 d9                	neg    %ecx
f010130e:	83 c4 10             	add    $0x10,%esp
			base = 8;
f0101311:	b8 08 00 00 00       	mov    $0x8,%eax
f0101316:	eb 45                	jmp    f010135d <vprintfmt+0x4a4>
		return va_arg(*ap, int);
f0101318:	8b 45 14             	mov    0x14(%ebp),%eax
f010131b:	8b 30                	mov    (%eax),%esi
f010131d:	89 75 e0             	mov    %esi,-0x20(%ebp)
f0101320:	89 f0                	mov    %esi,%eax
f0101322:	c1 f8 1f             	sar    $0x1f,%eax
f0101325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101328:	8b 45 14             	mov    0x14(%ebp),%eax
f010132b:	8d 40 04             	lea    0x4(%eax),%eax
f010132e:	89 45 14             	mov    %eax,0x14(%ebp)
f0101331:	eb b6                	jmp    f01012e9 <vprintfmt+0x430>
			putch('0', putdat);
f0101333:	83 ec 08             	sub    $0x8,%esp
f0101336:	57                   	push   %edi
f0101337:	6a 30                	push   $0x30
f0101339:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f010133c:	83 c4 08             	add    $0x8,%esp
f010133f:	57                   	push   %edi
f0101340:	6a 78                	push   $0x78
f0101342:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f0101345:	8b 45 14             	mov    0x14(%ebp),%eax
f0101348:	8b 10                	mov    (%eax),%edx
f010134a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010134f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0101352:	8d 40 04             	lea    0x4(%eax),%eax
f0101355:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101358:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010135d:	83 ec 0c             	sub    $0xc,%esp
f0101360:	0f be 75 d7          	movsbl -0x29(%ebp),%esi
f0101364:	56                   	push   %esi
f0101365:	ff 75 dc             	pushl  -0x24(%ebp)
f0101368:	50                   	push   %eax
f0101369:	51                   	push   %ecx
f010136a:	52                   	push   %edx
f010136b:	89 fa                	mov    %edi,%edx
f010136d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101370:	e8 5c fa ff ff       	call   f0100dd1 <printnum>
			break;
f0101375:	83 c4 20             	add    $0x20,%esp
f0101378:	e9 5a fb ff ff       	jmp    f0100ed7 <vprintfmt+0x1e>
	if (lflag >= 2)
f010137d:	83 f9 01             	cmp    $0x1,%ecx
f0101380:	7f 1b                	jg     f010139d <vprintfmt+0x4e4>
	else if (lflag)
f0101382:	85 c9                	test   %ecx,%ecx
f0101384:	74 2c                	je     f01013b2 <vprintfmt+0x4f9>
		return va_arg(*ap, unsigned long);
f0101386:	8b 45 14             	mov    0x14(%ebp),%eax
f0101389:	8b 10                	mov    (%eax),%edx
f010138b:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101390:	8d 40 04             	lea    0x4(%eax),%eax
f0101393:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101396:	b8 10 00 00 00       	mov    $0x10,%eax
f010139b:	eb c0                	jmp    f010135d <vprintfmt+0x4a4>
		return va_arg(*ap, unsigned long long);
f010139d:	8b 45 14             	mov    0x14(%ebp),%eax
f01013a0:	8b 10                	mov    (%eax),%edx
f01013a2:	8b 48 04             	mov    0x4(%eax),%ecx
f01013a5:	8d 40 08             	lea    0x8(%eax),%eax
f01013a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01013ab:	b8 10 00 00 00       	mov    $0x10,%eax
f01013b0:	eb ab                	jmp    f010135d <vprintfmt+0x4a4>
		return va_arg(*ap, unsigned int);
f01013b2:	8b 45 14             	mov    0x14(%ebp),%eax
f01013b5:	8b 10                	mov    (%eax),%edx
f01013b7:	b9 00 00 00 00       	mov    $0x0,%ecx
f01013bc:	8d 40 04             	lea    0x4(%eax),%eax
f01013bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01013c2:	b8 10 00 00 00       	mov    $0x10,%eax
f01013c7:	eb 94                	jmp    f010135d <vprintfmt+0x4a4>
			putch(ch, putdat);
f01013c9:	83 ec 08             	sub    $0x8,%esp
f01013cc:	57                   	push   %edi
f01013cd:	6a 25                	push   $0x25
f01013cf:	ff 55 08             	call   *0x8(%ebp)
			break;
f01013d2:	83 c4 10             	add    $0x10,%esp
f01013d5:	e9 fd fa ff ff       	jmp    f0100ed7 <vprintfmt+0x1e>
			putch('%', putdat);
f01013da:	83 ec 08             	sub    $0x8,%esp
f01013dd:	57                   	push   %edi
f01013de:	6a 25                	push   $0x25
f01013e0:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f01013e3:	83 c4 10             	add    $0x10,%esp
f01013e6:	89 f3                	mov    %esi,%ebx
f01013e8:	eb 03                	jmp    f01013ed <vprintfmt+0x534>
f01013ea:	83 eb 01             	sub    $0x1,%ebx
f01013ed:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f01013f1:	75 f7                	jne    f01013ea <vprintfmt+0x531>
f01013f3:	e9 df fa ff ff       	jmp    f0100ed7 <vprintfmt+0x1e>
}
f01013f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01013fb:	5b                   	pop    %ebx
f01013fc:	5e                   	pop    %esi
f01013fd:	5f                   	pop    %edi
f01013fe:	5d                   	pop    %ebp
f01013ff:	c3                   	ret    

f0101400 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0101400:	55                   	push   %ebp
f0101401:	89 e5                	mov    %esp,%ebp
f0101403:	83 ec 18             	sub    $0x18,%esp
f0101406:	8b 45 08             	mov    0x8(%ebp),%eax
f0101409:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f010140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010140f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0101413:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f010141d:	85 c0                	test   %eax,%eax
f010141f:	74 26                	je     f0101447 <vsnprintf+0x47>
f0101421:	85 d2                	test   %edx,%edx
f0101423:	7e 22                	jle    f0101447 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0101425:	ff 75 14             	pushl  0x14(%ebp)
f0101428:	ff 75 10             	pushl  0x10(%ebp)
f010142b:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010142e:	50                   	push   %eax
f010142f:	68 7f 0e 10 f0       	push   $0xf0100e7f
f0101434:	e8 80 fa ff ff       	call   f0100eb9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0101439:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010143c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f010143f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101442:	83 c4 10             	add    $0x10,%esp
}
f0101445:	c9                   	leave  
f0101446:	c3                   	ret    
		return -E_INVAL;
f0101447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010144c:	eb f7                	jmp    f0101445 <vsnprintf+0x45>

f010144e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010144e:	55                   	push   %ebp
f010144f:	89 e5                	mov    %esp,%ebp
f0101451:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0101454:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0101457:	50                   	push   %eax
f0101458:	ff 75 10             	pushl  0x10(%ebp)
f010145b:	ff 75 0c             	pushl  0xc(%ebp)
f010145e:	ff 75 08             	pushl  0x8(%ebp)
f0101461:	e8 9a ff ff ff       	call   f0101400 <vsnprintf>
	va_end(ap);

	return rc;
}
f0101466:	c9                   	leave  
f0101467:	c3                   	ret    

f0101468 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0101468:	55                   	push   %ebp
f0101469:	89 e5                	mov    %esp,%ebp
f010146b:	57                   	push   %edi
f010146c:	56                   	push   %esi
f010146d:	53                   	push   %ebx
f010146e:	83 ec 0c             	sub    $0xc,%esp
f0101471:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0101474:	85 c0                	test   %eax,%eax
f0101476:	74 11                	je     f0101489 <readline+0x21>
		cprintf("%s", prompt);
f0101478:	83 ec 08             	sub    $0x8,%esp
f010147b:	50                   	push   %eax
f010147c:	68 b5 22 10 f0       	push   $0xf01022b5
f0101481:	e8 c9 f5 ff ff       	call   f0100a4f <cprintf>
f0101486:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0101489:	83 ec 0c             	sub    $0xc,%esp
f010148c:	6a 00                	push   $0x0
f010148e:	e8 7f f1 ff ff       	call   f0100612 <iscons>
f0101493:	89 c7                	mov    %eax,%edi
f0101495:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0101498:	be 00 00 00 00       	mov    $0x0,%esi
f010149d:	eb 4b                	jmp    f01014ea <readline+0x82>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f010149f:	83 ec 08             	sub    $0x8,%esp
f01014a2:	50                   	push   %eax
f01014a3:	68 21 23 10 f0       	push   $0xf0102321
f01014a8:	e8 a2 f5 ff ff       	call   f0100a4f <cprintf>
			return NULL;
f01014ad:	83 c4 10             	add    $0x10,%esp
f01014b0:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f01014b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01014b8:	5b                   	pop    %ebx
f01014b9:	5e                   	pop    %esi
f01014ba:	5f                   	pop    %edi
f01014bb:	5d                   	pop    %ebp
f01014bc:	c3                   	ret    
			if (echoing)
f01014bd:	85 ff                	test   %edi,%edi
f01014bf:	75 05                	jne    f01014c6 <readline+0x5e>
			i--;
f01014c1:	83 ee 01             	sub    $0x1,%esi
f01014c4:	eb 24                	jmp    f01014ea <readline+0x82>
				cputchar('\b');
f01014c6:	83 ec 0c             	sub    $0xc,%esp
f01014c9:	6a 08                	push   $0x8
f01014cb:	e8 21 f1 ff ff       	call   f01005f1 <cputchar>
f01014d0:	83 c4 10             	add    $0x10,%esp
f01014d3:	eb ec                	jmp    f01014c1 <readline+0x59>
				cputchar(c);
f01014d5:	83 ec 0c             	sub    $0xc,%esp
f01014d8:	53                   	push   %ebx
f01014d9:	e8 13 f1 ff ff       	call   f01005f1 <cputchar>
f01014de:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01014e1:	88 9e 60 35 11 f0    	mov    %bl,-0xfeecaa0(%esi)
f01014e7:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01014ea:	e8 12 f1 ff ff       	call   f0100601 <getchar>
f01014ef:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01014f1:	85 c0                	test   %eax,%eax
f01014f3:	78 aa                	js     f010149f <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01014f5:	83 f8 08             	cmp    $0x8,%eax
f01014f8:	0f 94 c2             	sete   %dl
f01014fb:	83 f8 7f             	cmp    $0x7f,%eax
f01014fe:	0f 94 c0             	sete   %al
f0101501:	08 c2                	or     %al,%dl
f0101503:	74 04                	je     f0101509 <readline+0xa1>
f0101505:	85 f6                	test   %esi,%esi
f0101507:	7f b4                	jg     f01014bd <readline+0x55>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0101509:	83 fb 1f             	cmp    $0x1f,%ebx
f010150c:	7e 0e                	jle    f010151c <readline+0xb4>
f010150e:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0101514:	7f 06                	jg     f010151c <readline+0xb4>
			if (echoing)
f0101516:	85 ff                	test   %edi,%edi
f0101518:	74 c7                	je     f01014e1 <readline+0x79>
f010151a:	eb b9                	jmp    f01014d5 <readline+0x6d>
		} else if (c == '\n' || c == '\r') {
f010151c:	83 fb 0a             	cmp    $0xa,%ebx
f010151f:	74 05                	je     f0101526 <readline+0xbe>
f0101521:	83 fb 0d             	cmp    $0xd,%ebx
f0101524:	75 c4                	jne    f01014ea <readline+0x82>
			if (echoing)
f0101526:	85 ff                	test   %edi,%edi
f0101528:	75 11                	jne    f010153b <readline+0xd3>
			buf[i] = 0;
f010152a:	c6 86 60 35 11 f0 00 	movb   $0x0,-0xfeecaa0(%esi)
			return buf;
f0101531:	b8 60 35 11 f0       	mov    $0xf0113560,%eax
f0101536:	e9 7a ff ff ff       	jmp    f01014b5 <readline+0x4d>
				cputchar('\n');
f010153b:	83 ec 0c             	sub    $0xc,%esp
f010153e:	6a 0a                	push   $0xa
f0101540:	e8 ac f0 ff ff       	call   f01005f1 <cputchar>
f0101545:	83 c4 10             	add    $0x10,%esp
f0101548:	eb e0                	jmp    f010152a <readline+0xc2>

f010154a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f010154a:	55                   	push   %ebp
f010154b:	89 e5                	mov    %esp,%ebp
f010154d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0101550:	b8 00 00 00 00       	mov    $0x0,%eax
f0101555:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0101559:	74 05                	je     f0101560 <strlen+0x16>
		n++;
f010155b:	83 c0 01             	add    $0x1,%eax
f010155e:	eb f5                	jmp    f0101555 <strlen+0xb>
	return n;
}
f0101560:	5d                   	pop    %ebp
f0101561:	c3                   	ret    

f0101562 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0101562:	55                   	push   %ebp
f0101563:	89 e5                	mov    %esp,%ebp
f0101565:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101568:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010156b:	ba 00 00 00 00       	mov    $0x0,%edx
f0101570:	39 c2                	cmp    %eax,%edx
f0101572:	74 0d                	je     f0101581 <strnlen+0x1f>
f0101574:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0101578:	74 05                	je     f010157f <strnlen+0x1d>
		n++;
f010157a:	83 c2 01             	add    $0x1,%edx
f010157d:	eb f1                	jmp    f0101570 <strnlen+0xe>
f010157f:	89 d0                	mov    %edx,%eax
	return n;
}
f0101581:	5d                   	pop    %ebp
f0101582:	c3                   	ret    

f0101583 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0101583:	55                   	push   %ebp
f0101584:	89 e5                	mov    %esp,%ebp
f0101586:	53                   	push   %ebx
f0101587:	8b 45 08             	mov    0x8(%ebp),%eax
f010158a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010158d:	ba 00 00 00 00       	mov    $0x0,%edx
f0101592:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0101596:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0101599:	83 c2 01             	add    $0x1,%edx
f010159c:	84 c9                	test   %cl,%cl
f010159e:	75 f2                	jne    f0101592 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f01015a0:	5b                   	pop    %ebx
f01015a1:	5d                   	pop    %ebp
f01015a2:	c3                   	ret    

f01015a3 <strcat>:

char *
strcat(char *dst, const char *src)
{
f01015a3:	55                   	push   %ebp
f01015a4:	89 e5                	mov    %esp,%ebp
f01015a6:	53                   	push   %ebx
f01015a7:	83 ec 10             	sub    $0x10,%esp
f01015aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01015ad:	53                   	push   %ebx
f01015ae:	e8 97 ff ff ff       	call   f010154a <strlen>
f01015b3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f01015b6:	ff 75 0c             	pushl  0xc(%ebp)
f01015b9:	01 d8                	add    %ebx,%eax
f01015bb:	50                   	push   %eax
f01015bc:	e8 c2 ff ff ff       	call   f0101583 <strcpy>
	return dst;
}
f01015c1:	89 d8                	mov    %ebx,%eax
f01015c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01015c6:	c9                   	leave  
f01015c7:	c3                   	ret    

f01015c8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01015c8:	55                   	push   %ebp
f01015c9:	89 e5                	mov    %esp,%ebp
f01015cb:	56                   	push   %esi
f01015cc:	53                   	push   %ebx
f01015cd:	8b 45 08             	mov    0x8(%ebp),%eax
f01015d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01015d3:	89 c6                	mov    %eax,%esi
f01015d5:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01015d8:	89 c2                	mov    %eax,%edx
f01015da:	39 f2                	cmp    %esi,%edx
f01015dc:	74 11                	je     f01015ef <strncpy+0x27>
		*dst++ = *src;
f01015de:	83 c2 01             	add    $0x1,%edx
f01015e1:	0f b6 19             	movzbl (%ecx),%ebx
f01015e4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01015e7:	80 fb 01             	cmp    $0x1,%bl
f01015ea:	83 d9 ff             	sbb    $0xffffffff,%ecx
f01015ed:	eb eb                	jmp    f01015da <strncpy+0x12>
	}
	return ret;
}
f01015ef:	5b                   	pop    %ebx
f01015f0:	5e                   	pop    %esi
f01015f1:	5d                   	pop    %ebp
f01015f2:	c3                   	ret    

f01015f3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01015f3:	55                   	push   %ebp
f01015f4:	89 e5                	mov    %esp,%ebp
f01015f6:	56                   	push   %esi
f01015f7:	53                   	push   %ebx
f01015f8:	8b 75 08             	mov    0x8(%ebp),%esi
f01015fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01015fe:	8b 55 10             	mov    0x10(%ebp),%edx
f0101601:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0101603:	85 d2                	test   %edx,%edx
f0101605:	74 21                	je     f0101628 <strlcpy+0x35>
f0101607:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f010160b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f010160d:	39 c2                	cmp    %eax,%edx
f010160f:	74 14                	je     f0101625 <strlcpy+0x32>
f0101611:	0f b6 19             	movzbl (%ecx),%ebx
f0101614:	84 db                	test   %bl,%bl
f0101616:	74 0b                	je     f0101623 <strlcpy+0x30>
			*dst++ = *src++;
f0101618:	83 c1 01             	add    $0x1,%ecx
f010161b:	83 c2 01             	add    $0x1,%edx
f010161e:	88 5a ff             	mov    %bl,-0x1(%edx)
f0101621:	eb ea                	jmp    f010160d <strlcpy+0x1a>
f0101623:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0101625:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0101628:	29 f0                	sub    %esi,%eax
}
f010162a:	5b                   	pop    %ebx
f010162b:	5e                   	pop    %esi
f010162c:	5d                   	pop    %ebp
f010162d:	c3                   	ret    

f010162e <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010162e:	55                   	push   %ebp
f010162f:	89 e5                	mov    %esp,%ebp
f0101631:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101634:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0101637:	0f b6 01             	movzbl (%ecx),%eax
f010163a:	84 c0                	test   %al,%al
f010163c:	74 0c                	je     f010164a <strcmp+0x1c>
f010163e:	3a 02                	cmp    (%edx),%al
f0101640:	75 08                	jne    f010164a <strcmp+0x1c>
		p++, q++;
f0101642:	83 c1 01             	add    $0x1,%ecx
f0101645:	83 c2 01             	add    $0x1,%edx
f0101648:	eb ed                	jmp    f0101637 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f010164a:	0f b6 c0             	movzbl %al,%eax
f010164d:	0f b6 12             	movzbl (%edx),%edx
f0101650:	29 d0                	sub    %edx,%eax
}
f0101652:	5d                   	pop    %ebp
f0101653:	c3                   	ret    

f0101654 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0101654:	55                   	push   %ebp
f0101655:	89 e5                	mov    %esp,%ebp
f0101657:	53                   	push   %ebx
f0101658:	8b 45 08             	mov    0x8(%ebp),%eax
f010165b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010165e:	89 c3                	mov    %eax,%ebx
f0101660:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0101663:	eb 06                	jmp    f010166b <strncmp+0x17>
		n--, p++, q++;
f0101665:	83 c0 01             	add    $0x1,%eax
f0101668:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f010166b:	39 d8                	cmp    %ebx,%eax
f010166d:	74 16                	je     f0101685 <strncmp+0x31>
f010166f:	0f b6 08             	movzbl (%eax),%ecx
f0101672:	84 c9                	test   %cl,%cl
f0101674:	74 04                	je     f010167a <strncmp+0x26>
f0101676:	3a 0a                	cmp    (%edx),%cl
f0101678:	74 eb                	je     f0101665 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f010167a:	0f b6 00             	movzbl (%eax),%eax
f010167d:	0f b6 12             	movzbl (%edx),%edx
f0101680:	29 d0                	sub    %edx,%eax
}
f0101682:	5b                   	pop    %ebx
f0101683:	5d                   	pop    %ebp
f0101684:	c3                   	ret    
		return 0;
f0101685:	b8 00 00 00 00       	mov    $0x0,%eax
f010168a:	eb f6                	jmp    f0101682 <strncmp+0x2e>

f010168c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010168c:	55                   	push   %ebp
f010168d:	89 e5                	mov    %esp,%ebp
f010168f:	8b 45 08             	mov    0x8(%ebp),%eax
f0101692:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0101696:	0f b6 10             	movzbl (%eax),%edx
f0101699:	84 d2                	test   %dl,%dl
f010169b:	74 09                	je     f01016a6 <strchr+0x1a>
		if (*s == c)
f010169d:	38 ca                	cmp    %cl,%dl
f010169f:	74 0a                	je     f01016ab <strchr+0x1f>
	for (; *s; s++)
f01016a1:	83 c0 01             	add    $0x1,%eax
f01016a4:	eb f0                	jmp    f0101696 <strchr+0xa>
			return (char *) s;
	return 0;
f01016a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01016ab:	5d                   	pop    %ebp
f01016ac:	c3                   	ret    

f01016ad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01016ad:	55                   	push   %ebp
f01016ae:	89 e5                	mov    %esp,%ebp
f01016b0:	8b 45 08             	mov    0x8(%ebp),%eax
f01016b3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01016b7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01016ba:	38 ca                	cmp    %cl,%dl
f01016bc:	74 09                	je     f01016c7 <strfind+0x1a>
f01016be:	84 d2                	test   %dl,%dl
f01016c0:	74 05                	je     f01016c7 <strfind+0x1a>
	for (; *s; s++)
f01016c2:	83 c0 01             	add    $0x1,%eax
f01016c5:	eb f0                	jmp    f01016b7 <strfind+0xa>
			break;
	return (char *) s;
}
f01016c7:	5d                   	pop    %ebp
f01016c8:	c3                   	ret    

f01016c9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01016c9:	55                   	push   %ebp
f01016ca:	89 e5                	mov    %esp,%ebp
f01016cc:	57                   	push   %edi
f01016cd:	56                   	push   %esi
f01016ce:	53                   	push   %ebx
f01016cf:	8b 7d 08             	mov    0x8(%ebp),%edi
f01016d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01016d5:	85 c9                	test   %ecx,%ecx
f01016d7:	74 31                	je     f010170a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01016d9:	89 f8                	mov    %edi,%eax
f01016db:	09 c8                	or     %ecx,%eax
f01016dd:	a8 03                	test   $0x3,%al
f01016df:	75 23                	jne    f0101704 <memset+0x3b>
		c &= 0xFF;
f01016e1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01016e5:	89 d3                	mov    %edx,%ebx
f01016e7:	c1 e3 08             	shl    $0x8,%ebx
f01016ea:	89 d0                	mov    %edx,%eax
f01016ec:	c1 e0 18             	shl    $0x18,%eax
f01016ef:	89 d6                	mov    %edx,%esi
f01016f1:	c1 e6 10             	shl    $0x10,%esi
f01016f4:	09 f0                	or     %esi,%eax
f01016f6:	09 c2                	or     %eax,%edx
f01016f8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01016fa:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01016fd:	89 d0                	mov    %edx,%eax
f01016ff:	fc                   	cld    
f0101700:	f3 ab                	rep stos %eax,%es:(%edi)
f0101702:	eb 06                	jmp    f010170a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0101704:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101707:	fc                   	cld    
f0101708:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f010170a:	89 f8                	mov    %edi,%eax
f010170c:	5b                   	pop    %ebx
f010170d:	5e                   	pop    %esi
f010170e:	5f                   	pop    %edi
f010170f:	5d                   	pop    %ebp
f0101710:	c3                   	ret    

f0101711 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0101711:	55                   	push   %ebp
f0101712:	89 e5                	mov    %esp,%ebp
f0101714:	57                   	push   %edi
f0101715:	56                   	push   %esi
f0101716:	8b 45 08             	mov    0x8(%ebp),%eax
f0101719:	8b 75 0c             	mov    0xc(%ebp),%esi
f010171c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010171f:	39 c6                	cmp    %eax,%esi
f0101721:	73 32                	jae    f0101755 <memmove+0x44>
f0101723:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0101726:	39 c2                	cmp    %eax,%edx
f0101728:	76 2b                	jbe    f0101755 <memmove+0x44>
		s += n;
		d += n;
f010172a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010172d:	89 fe                	mov    %edi,%esi
f010172f:	09 ce                	or     %ecx,%esi
f0101731:	09 d6                	or     %edx,%esi
f0101733:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0101739:	75 0e                	jne    f0101749 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f010173b:	83 ef 04             	sub    $0x4,%edi
f010173e:	8d 72 fc             	lea    -0x4(%edx),%esi
f0101741:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0101744:	fd                   	std    
f0101745:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0101747:	eb 09                	jmp    f0101752 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0101749:	83 ef 01             	sub    $0x1,%edi
f010174c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010174f:	fd                   	std    
f0101750:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0101752:	fc                   	cld    
f0101753:	eb 1a                	jmp    f010176f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0101755:	89 c2                	mov    %eax,%edx
f0101757:	09 ca                	or     %ecx,%edx
f0101759:	09 f2                	or     %esi,%edx
f010175b:	f6 c2 03             	test   $0x3,%dl
f010175e:	75 0a                	jne    f010176a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0101760:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0101763:	89 c7                	mov    %eax,%edi
f0101765:	fc                   	cld    
f0101766:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0101768:	eb 05                	jmp    f010176f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f010176a:	89 c7                	mov    %eax,%edi
f010176c:	fc                   	cld    
f010176d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010176f:	5e                   	pop    %esi
f0101770:	5f                   	pop    %edi
f0101771:	5d                   	pop    %ebp
f0101772:	c3                   	ret    

f0101773 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0101773:	55                   	push   %ebp
f0101774:	89 e5                	mov    %esp,%ebp
f0101776:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0101779:	ff 75 10             	pushl  0x10(%ebp)
f010177c:	ff 75 0c             	pushl  0xc(%ebp)
f010177f:	ff 75 08             	pushl  0x8(%ebp)
f0101782:	e8 8a ff ff ff       	call   f0101711 <memmove>
}
f0101787:	c9                   	leave  
f0101788:	c3                   	ret    

f0101789 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0101789:	55                   	push   %ebp
f010178a:	89 e5                	mov    %esp,%ebp
f010178c:	56                   	push   %esi
f010178d:	53                   	push   %ebx
f010178e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101791:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101794:	89 c6                	mov    %eax,%esi
f0101796:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101799:	39 f0                	cmp    %esi,%eax
f010179b:	74 1c                	je     f01017b9 <memcmp+0x30>
		if (*s1 != *s2)
f010179d:	0f b6 08             	movzbl (%eax),%ecx
f01017a0:	0f b6 1a             	movzbl (%edx),%ebx
f01017a3:	38 d9                	cmp    %bl,%cl
f01017a5:	75 08                	jne    f01017af <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01017a7:	83 c0 01             	add    $0x1,%eax
f01017aa:	83 c2 01             	add    $0x1,%edx
f01017ad:	eb ea                	jmp    f0101799 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f01017af:	0f b6 c1             	movzbl %cl,%eax
f01017b2:	0f b6 db             	movzbl %bl,%ebx
f01017b5:	29 d8                	sub    %ebx,%eax
f01017b7:	eb 05                	jmp    f01017be <memcmp+0x35>
	}

	return 0;
f01017b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01017be:	5b                   	pop    %ebx
f01017bf:	5e                   	pop    %esi
f01017c0:	5d                   	pop    %ebp
f01017c1:	c3                   	ret    

f01017c2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01017c2:	55                   	push   %ebp
f01017c3:	89 e5                	mov    %esp,%ebp
f01017c5:	8b 45 08             	mov    0x8(%ebp),%eax
f01017c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01017cb:	89 c2                	mov    %eax,%edx
f01017cd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01017d0:	39 d0                	cmp    %edx,%eax
f01017d2:	73 09                	jae    f01017dd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01017d4:	38 08                	cmp    %cl,(%eax)
f01017d6:	74 05                	je     f01017dd <memfind+0x1b>
	for (; s < ends; s++)
f01017d8:	83 c0 01             	add    $0x1,%eax
f01017db:	eb f3                	jmp    f01017d0 <memfind+0xe>
			break;
	return (void *) s;
}
f01017dd:	5d                   	pop    %ebp
f01017de:	c3                   	ret    

f01017df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01017df:	55                   	push   %ebp
f01017e0:	89 e5                	mov    %esp,%ebp
f01017e2:	57                   	push   %edi
f01017e3:	56                   	push   %esi
f01017e4:	53                   	push   %ebx
f01017e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01017e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01017eb:	eb 03                	jmp    f01017f0 <strtol+0x11>
		s++;
f01017ed:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01017f0:	0f b6 01             	movzbl (%ecx),%eax
f01017f3:	3c 20                	cmp    $0x20,%al
f01017f5:	74 f6                	je     f01017ed <strtol+0xe>
f01017f7:	3c 09                	cmp    $0x9,%al
f01017f9:	74 f2                	je     f01017ed <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01017fb:	3c 2b                	cmp    $0x2b,%al
f01017fd:	74 2a                	je     f0101829 <strtol+0x4a>
	int neg = 0;
f01017ff:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0101804:	3c 2d                	cmp    $0x2d,%al
f0101806:	74 2b                	je     f0101833 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101808:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f010180e:	75 0f                	jne    f010181f <strtol+0x40>
f0101810:	80 39 30             	cmpb   $0x30,(%ecx)
f0101813:	74 28                	je     f010183d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0101815:	85 db                	test   %ebx,%ebx
f0101817:	b8 0a 00 00 00       	mov    $0xa,%eax
f010181c:	0f 44 d8             	cmove  %eax,%ebx
f010181f:	b8 00 00 00 00       	mov    $0x0,%eax
f0101824:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0101827:	eb 50                	jmp    f0101879 <strtol+0x9a>
		s++;
f0101829:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f010182c:	bf 00 00 00 00       	mov    $0x0,%edi
f0101831:	eb d5                	jmp    f0101808 <strtol+0x29>
		s++, neg = 1;
f0101833:	83 c1 01             	add    $0x1,%ecx
f0101836:	bf 01 00 00 00       	mov    $0x1,%edi
f010183b:	eb cb                	jmp    f0101808 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010183d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0101841:	74 0e                	je     f0101851 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f0101843:	85 db                	test   %ebx,%ebx
f0101845:	75 d8                	jne    f010181f <strtol+0x40>
		s++, base = 8;
f0101847:	83 c1 01             	add    $0x1,%ecx
f010184a:	bb 08 00 00 00       	mov    $0x8,%ebx
f010184f:	eb ce                	jmp    f010181f <strtol+0x40>
		s += 2, base = 16;
f0101851:	83 c1 02             	add    $0x2,%ecx
f0101854:	bb 10 00 00 00       	mov    $0x10,%ebx
f0101859:	eb c4                	jmp    f010181f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f010185b:	8d 72 9f             	lea    -0x61(%edx),%esi
f010185e:	89 f3                	mov    %esi,%ebx
f0101860:	80 fb 19             	cmp    $0x19,%bl
f0101863:	77 29                	ja     f010188e <strtol+0xaf>
			dig = *s - 'a' + 10;
f0101865:	0f be d2             	movsbl %dl,%edx
f0101868:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f010186b:	3b 55 10             	cmp    0x10(%ebp),%edx
f010186e:	7d 30                	jge    f01018a0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f0101870:	83 c1 01             	add    $0x1,%ecx
f0101873:	0f af 45 10          	imul   0x10(%ebp),%eax
f0101877:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0101879:	0f b6 11             	movzbl (%ecx),%edx
f010187c:	8d 72 d0             	lea    -0x30(%edx),%esi
f010187f:	89 f3                	mov    %esi,%ebx
f0101881:	80 fb 09             	cmp    $0x9,%bl
f0101884:	77 d5                	ja     f010185b <strtol+0x7c>
			dig = *s - '0';
f0101886:	0f be d2             	movsbl %dl,%edx
f0101889:	83 ea 30             	sub    $0x30,%edx
f010188c:	eb dd                	jmp    f010186b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f010188e:	8d 72 bf             	lea    -0x41(%edx),%esi
f0101891:	89 f3                	mov    %esi,%ebx
f0101893:	80 fb 19             	cmp    $0x19,%bl
f0101896:	77 08                	ja     f01018a0 <strtol+0xc1>
			dig = *s - 'A' + 10;
f0101898:	0f be d2             	movsbl %dl,%edx
f010189b:	83 ea 37             	sub    $0x37,%edx
f010189e:	eb cb                	jmp    f010186b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f01018a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01018a4:	74 05                	je     f01018ab <strtol+0xcc>
		*endptr = (char *) s;
f01018a6:	8b 75 0c             	mov    0xc(%ebp),%esi
f01018a9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01018ab:	89 c2                	mov    %eax,%edx
f01018ad:	f7 da                	neg    %edx
f01018af:	85 ff                	test   %edi,%edi
f01018b1:	0f 45 c2             	cmovne %edx,%eax
}
f01018b4:	5b                   	pop    %ebx
f01018b5:	5e                   	pop    %esi
f01018b6:	5f                   	pop    %edi
f01018b7:	5d                   	pop    %ebp
f01018b8:	c3                   	ret    
f01018b9:	66 90                	xchg   %ax,%ax
f01018bb:	66 90                	xchg   %ax,%ax
f01018bd:	66 90                	xchg   %ax,%ax
f01018bf:	90                   	nop

f01018c0 <__udivdi3>:
f01018c0:	f3 0f 1e fb          	endbr32 
f01018c4:	55                   	push   %ebp
f01018c5:	57                   	push   %edi
f01018c6:	56                   	push   %esi
f01018c7:	53                   	push   %ebx
f01018c8:	83 ec 1c             	sub    $0x1c,%esp
f01018cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f01018cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01018d3:	8b 74 24 34          	mov    0x34(%esp),%esi
f01018d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01018db:	85 d2                	test   %edx,%edx
f01018dd:	75 49                	jne    f0101928 <__udivdi3+0x68>
f01018df:	39 f3                	cmp    %esi,%ebx
f01018e1:	76 15                	jbe    f01018f8 <__udivdi3+0x38>
f01018e3:	31 ff                	xor    %edi,%edi
f01018e5:	89 e8                	mov    %ebp,%eax
f01018e7:	89 f2                	mov    %esi,%edx
f01018e9:	f7 f3                	div    %ebx
f01018eb:	89 fa                	mov    %edi,%edx
f01018ed:	83 c4 1c             	add    $0x1c,%esp
f01018f0:	5b                   	pop    %ebx
f01018f1:	5e                   	pop    %esi
f01018f2:	5f                   	pop    %edi
f01018f3:	5d                   	pop    %ebp
f01018f4:	c3                   	ret    
f01018f5:	8d 76 00             	lea    0x0(%esi),%esi
f01018f8:	89 d9                	mov    %ebx,%ecx
f01018fa:	85 db                	test   %ebx,%ebx
f01018fc:	75 0b                	jne    f0101909 <__udivdi3+0x49>
f01018fe:	b8 01 00 00 00       	mov    $0x1,%eax
f0101903:	31 d2                	xor    %edx,%edx
f0101905:	f7 f3                	div    %ebx
f0101907:	89 c1                	mov    %eax,%ecx
f0101909:	31 d2                	xor    %edx,%edx
f010190b:	89 f0                	mov    %esi,%eax
f010190d:	f7 f1                	div    %ecx
f010190f:	89 c6                	mov    %eax,%esi
f0101911:	89 e8                	mov    %ebp,%eax
f0101913:	89 f7                	mov    %esi,%edi
f0101915:	f7 f1                	div    %ecx
f0101917:	89 fa                	mov    %edi,%edx
f0101919:	83 c4 1c             	add    $0x1c,%esp
f010191c:	5b                   	pop    %ebx
f010191d:	5e                   	pop    %esi
f010191e:	5f                   	pop    %edi
f010191f:	5d                   	pop    %ebp
f0101920:	c3                   	ret    
f0101921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0101928:	39 f2                	cmp    %esi,%edx
f010192a:	77 1c                	ja     f0101948 <__udivdi3+0x88>
f010192c:	0f bd fa             	bsr    %edx,%edi
f010192f:	83 f7 1f             	xor    $0x1f,%edi
f0101932:	75 2c                	jne    f0101960 <__udivdi3+0xa0>
f0101934:	39 f2                	cmp    %esi,%edx
f0101936:	72 06                	jb     f010193e <__udivdi3+0x7e>
f0101938:	31 c0                	xor    %eax,%eax
f010193a:	39 eb                	cmp    %ebp,%ebx
f010193c:	77 ad                	ja     f01018eb <__udivdi3+0x2b>
f010193e:	b8 01 00 00 00       	mov    $0x1,%eax
f0101943:	eb a6                	jmp    f01018eb <__udivdi3+0x2b>
f0101945:	8d 76 00             	lea    0x0(%esi),%esi
f0101948:	31 ff                	xor    %edi,%edi
f010194a:	31 c0                	xor    %eax,%eax
f010194c:	89 fa                	mov    %edi,%edx
f010194e:	83 c4 1c             	add    $0x1c,%esp
f0101951:	5b                   	pop    %ebx
f0101952:	5e                   	pop    %esi
f0101953:	5f                   	pop    %edi
f0101954:	5d                   	pop    %ebp
f0101955:	c3                   	ret    
f0101956:	8d 76 00             	lea    0x0(%esi),%esi
f0101959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0101960:	89 f9                	mov    %edi,%ecx
f0101962:	b8 20 00 00 00       	mov    $0x20,%eax
f0101967:	29 f8                	sub    %edi,%eax
f0101969:	d3 e2                	shl    %cl,%edx
f010196b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010196f:	89 c1                	mov    %eax,%ecx
f0101971:	89 da                	mov    %ebx,%edx
f0101973:	d3 ea                	shr    %cl,%edx
f0101975:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0101979:	09 d1                	or     %edx,%ecx
f010197b:	89 f2                	mov    %esi,%edx
f010197d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0101981:	89 f9                	mov    %edi,%ecx
f0101983:	d3 e3                	shl    %cl,%ebx
f0101985:	89 c1                	mov    %eax,%ecx
f0101987:	d3 ea                	shr    %cl,%edx
f0101989:	89 f9                	mov    %edi,%ecx
f010198b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010198f:	89 eb                	mov    %ebp,%ebx
f0101991:	d3 e6                	shl    %cl,%esi
f0101993:	89 c1                	mov    %eax,%ecx
f0101995:	d3 eb                	shr    %cl,%ebx
f0101997:	09 de                	or     %ebx,%esi
f0101999:	89 f0                	mov    %esi,%eax
f010199b:	f7 74 24 08          	divl   0x8(%esp)
f010199f:	89 d6                	mov    %edx,%esi
f01019a1:	89 c3                	mov    %eax,%ebx
f01019a3:	f7 64 24 0c          	mull   0xc(%esp)
f01019a7:	39 d6                	cmp    %edx,%esi
f01019a9:	72 15                	jb     f01019c0 <__udivdi3+0x100>
f01019ab:	89 f9                	mov    %edi,%ecx
f01019ad:	d3 e5                	shl    %cl,%ebp
f01019af:	39 c5                	cmp    %eax,%ebp
f01019b1:	73 04                	jae    f01019b7 <__udivdi3+0xf7>
f01019b3:	39 d6                	cmp    %edx,%esi
f01019b5:	74 09                	je     f01019c0 <__udivdi3+0x100>
f01019b7:	89 d8                	mov    %ebx,%eax
f01019b9:	31 ff                	xor    %edi,%edi
f01019bb:	e9 2b ff ff ff       	jmp    f01018eb <__udivdi3+0x2b>
f01019c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01019c3:	31 ff                	xor    %edi,%edi
f01019c5:	e9 21 ff ff ff       	jmp    f01018eb <__udivdi3+0x2b>
f01019ca:	66 90                	xchg   %ax,%ax
f01019cc:	66 90                	xchg   %ax,%ax
f01019ce:	66 90                	xchg   %ax,%ax

f01019d0 <__umoddi3>:
f01019d0:	f3 0f 1e fb          	endbr32 
f01019d4:	55                   	push   %ebp
f01019d5:	57                   	push   %edi
f01019d6:	56                   	push   %esi
f01019d7:	53                   	push   %ebx
f01019d8:	83 ec 1c             	sub    $0x1c,%esp
f01019db:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01019df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01019e3:	8b 74 24 30          	mov    0x30(%esp),%esi
f01019e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01019eb:	89 da                	mov    %ebx,%edx
f01019ed:	85 c0                	test   %eax,%eax
f01019ef:	75 3f                	jne    f0101a30 <__umoddi3+0x60>
f01019f1:	39 df                	cmp    %ebx,%edi
f01019f3:	76 13                	jbe    f0101a08 <__umoddi3+0x38>
f01019f5:	89 f0                	mov    %esi,%eax
f01019f7:	f7 f7                	div    %edi
f01019f9:	89 d0                	mov    %edx,%eax
f01019fb:	31 d2                	xor    %edx,%edx
f01019fd:	83 c4 1c             	add    $0x1c,%esp
f0101a00:	5b                   	pop    %ebx
f0101a01:	5e                   	pop    %esi
f0101a02:	5f                   	pop    %edi
f0101a03:	5d                   	pop    %ebp
f0101a04:	c3                   	ret    
f0101a05:	8d 76 00             	lea    0x0(%esi),%esi
f0101a08:	89 fd                	mov    %edi,%ebp
f0101a0a:	85 ff                	test   %edi,%edi
f0101a0c:	75 0b                	jne    f0101a19 <__umoddi3+0x49>
f0101a0e:	b8 01 00 00 00       	mov    $0x1,%eax
f0101a13:	31 d2                	xor    %edx,%edx
f0101a15:	f7 f7                	div    %edi
f0101a17:	89 c5                	mov    %eax,%ebp
f0101a19:	89 d8                	mov    %ebx,%eax
f0101a1b:	31 d2                	xor    %edx,%edx
f0101a1d:	f7 f5                	div    %ebp
f0101a1f:	89 f0                	mov    %esi,%eax
f0101a21:	f7 f5                	div    %ebp
f0101a23:	89 d0                	mov    %edx,%eax
f0101a25:	eb d4                	jmp    f01019fb <__umoddi3+0x2b>
f0101a27:	89 f6                	mov    %esi,%esi
f0101a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0101a30:	89 f1                	mov    %esi,%ecx
f0101a32:	39 d8                	cmp    %ebx,%eax
f0101a34:	76 0a                	jbe    f0101a40 <__umoddi3+0x70>
f0101a36:	89 f0                	mov    %esi,%eax
f0101a38:	83 c4 1c             	add    $0x1c,%esp
f0101a3b:	5b                   	pop    %ebx
f0101a3c:	5e                   	pop    %esi
f0101a3d:	5f                   	pop    %edi
f0101a3e:	5d                   	pop    %ebp
f0101a3f:	c3                   	ret    
f0101a40:	0f bd e8             	bsr    %eax,%ebp
f0101a43:	83 f5 1f             	xor    $0x1f,%ebp
f0101a46:	75 20                	jne    f0101a68 <__umoddi3+0x98>
f0101a48:	39 d8                	cmp    %ebx,%eax
f0101a4a:	0f 82 b0 00 00 00    	jb     f0101b00 <__umoddi3+0x130>
f0101a50:	39 f7                	cmp    %esi,%edi
f0101a52:	0f 86 a8 00 00 00    	jbe    f0101b00 <__umoddi3+0x130>
f0101a58:	89 c8                	mov    %ecx,%eax
f0101a5a:	83 c4 1c             	add    $0x1c,%esp
f0101a5d:	5b                   	pop    %ebx
f0101a5e:	5e                   	pop    %esi
f0101a5f:	5f                   	pop    %edi
f0101a60:	5d                   	pop    %ebp
f0101a61:	c3                   	ret    
f0101a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101a68:	89 e9                	mov    %ebp,%ecx
f0101a6a:	ba 20 00 00 00       	mov    $0x20,%edx
f0101a6f:	29 ea                	sub    %ebp,%edx
f0101a71:	d3 e0                	shl    %cl,%eax
f0101a73:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101a77:	89 d1                	mov    %edx,%ecx
f0101a79:	89 f8                	mov    %edi,%eax
f0101a7b:	d3 e8                	shr    %cl,%eax
f0101a7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0101a81:	89 54 24 04          	mov    %edx,0x4(%esp)
f0101a85:	8b 54 24 04          	mov    0x4(%esp),%edx
f0101a89:	09 c1                	or     %eax,%ecx
f0101a8b:	89 d8                	mov    %ebx,%eax
f0101a8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0101a91:	89 e9                	mov    %ebp,%ecx
f0101a93:	d3 e7                	shl    %cl,%edi
f0101a95:	89 d1                	mov    %edx,%ecx
f0101a97:	d3 e8                	shr    %cl,%eax
f0101a99:	89 e9                	mov    %ebp,%ecx
f0101a9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0101a9f:	d3 e3                	shl    %cl,%ebx
f0101aa1:	89 c7                	mov    %eax,%edi
f0101aa3:	89 d1                	mov    %edx,%ecx
f0101aa5:	89 f0                	mov    %esi,%eax
f0101aa7:	d3 e8                	shr    %cl,%eax
f0101aa9:	89 e9                	mov    %ebp,%ecx
f0101aab:	89 fa                	mov    %edi,%edx
f0101aad:	d3 e6                	shl    %cl,%esi
f0101aaf:	09 d8                	or     %ebx,%eax
f0101ab1:	f7 74 24 08          	divl   0x8(%esp)
f0101ab5:	89 d1                	mov    %edx,%ecx
f0101ab7:	89 f3                	mov    %esi,%ebx
f0101ab9:	f7 64 24 0c          	mull   0xc(%esp)
f0101abd:	89 c6                	mov    %eax,%esi
f0101abf:	89 d7                	mov    %edx,%edi
f0101ac1:	39 d1                	cmp    %edx,%ecx
f0101ac3:	72 06                	jb     f0101acb <__umoddi3+0xfb>
f0101ac5:	75 10                	jne    f0101ad7 <__umoddi3+0x107>
f0101ac7:	39 c3                	cmp    %eax,%ebx
f0101ac9:	73 0c                	jae    f0101ad7 <__umoddi3+0x107>
f0101acb:	2b 44 24 0c          	sub    0xc(%esp),%eax
f0101acf:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0101ad3:	89 d7                	mov    %edx,%edi
f0101ad5:	89 c6                	mov    %eax,%esi
f0101ad7:	89 ca                	mov    %ecx,%edx
f0101ad9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0101ade:	29 f3                	sub    %esi,%ebx
f0101ae0:	19 fa                	sbb    %edi,%edx
f0101ae2:	89 d0                	mov    %edx,%eax
f0101ae4:	d3 e0                	shl    %cl,%eax
f0101ae6:	89 e9                	mov    %ebp,%ecx
f0101ae8:	d3 eb                	shr    %cl,%ebx
f0101aea:	d3 ea                	shr    %cl,%edx
f0101aec:	09 d8                	or     %ebx,%eax
f0101aee:	83 c4 1c             	add    $0x1c,%esp
f0101af1:	5b                   	pop    %ebx
f0101af2:	5e                   	pop    %esi
f0101af3:	5f                   	pop    %edi
f0101af4:	5d                   	pop    %ebp
f0101af5:	c3                   	ret    
f0101af6:	8d 76 00             	lea    0x0(%esi),%esi
f0101af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0101b00:	89 da                	mov    %ebx,%edx
f0101b02:	29 fe                	sub    %edi,%esi
f0101b04:	19 c2                	sbb    %eax,%edx
f0101b06:	89 f1                	mov    %esi,%ecx
f0101b08:	89 c8                	mov    %ecx,%eax
f0101b0a:	e9 4b ff ff ff       	jmp    f0101a5a <__umoddi3+0x8a>
