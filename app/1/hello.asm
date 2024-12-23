; hello.asm
; Prints "Hello, world!" and then exits.
; Comment start from ; symbol https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html#section-3.1
; Like most assemblers, each NASM source line contains (unless it is a macro, a preprocessor directive or an assembler directive: see chapter 4 and chapter 7) some combination of the four fields
; label:    instruction operands        ; comment
; As usual, most of these fields are optional; the presence or absence of any combination of a label, an instruction and a comment is allowed.
; Of course, the operand field is either required or forbidden by the presence and nature of the instruction field.

section .data
; Section for data. About sections: https://www.nasm.us/xdoc/2.16.03/html/nasmdoc7.html#section-7.3
; The Unix object formats, and the bin object format (but see section 8.1.3), all support the standardized section names .text, .data and .bss for the code, data and uninitialized-data sections.
    message_label: db "Hello, world..."
    ; message_label is a label that represents the address of the string https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html#section-3.1
    ; label:    instruction operands        ; comment

    ; db (declare byte) is a directive that declares one or more bytes https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html#section-3.2.1

    length_symbol equ $ - message_label ; length of the string (from message_label to current address).
    ; length_symbol is a symbol that represents the length of the string. https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html#section-3.2.4
    ; equ (equate) is a directive that defines a symbol to be a constant https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html#section-3.2.4
    ; $ is a special symbol that represents the current address https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html#section-3.5
    ; - is a subtraction operator https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html#section-3.5.10
    ; message_label is a label that represents the address of the string, it is already defined above

section .text
; Main section, really it is not a text, it is the main part of the program. https://www.nasm.us/xdoc/2.16.03/html/nasmdoc7.html#section-7.3
; .text is a standard section name for code, some tradition.

    global _start ; entry point
    ; global is a directive that makes the symbol visible to the linker https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html#section-7.7
    ; _start is the default entry point for the ld -e=_start linker, but need to find more references later about this.

_start:
; _start is a label that represents the entry point of the program.

    ; === Call write(fd=1, buf=message_label, count=length_symbol) ===
    mov rax, 1      ; syscall number: sys_write
    ; mov (move) is an instruction that moves data between registers and memory https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html Intel 64 and IA-32 Architectures Software Developer's Manual Combined Volumes 2A, 2B, 2C, and  2D: Instruction Set Reference, A- Z.
    ; Also Intel 64 and IA-32 Architectures Software Developer's Manual Volume 1: Basic Architecture, 5 Instruction set summary, 5.1 General-purpose instructions, 5.1.1 Data transfer instructions, mov.
    ; rax is a 64-bit general-purpose register, accumulator, system function number https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html Intel 64 and IA-32 Architectures Software Developer's Manual Volume 1: Basic Architecture, 3 Basic execution environment, 3.4 Basic program execution registers, 3.4.1 General-Purpose Registers, 3.4.1.1 General-Purpose Registers in 64-Bit Mode.
    ; 1	common	write sys_write https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl
    ; https://man7.org/linux/man-pages/man2/write.2.html
    mov rdi, 1      ; file descriptor: stdout
    ; rdi is a 64-bit general-purpose register, destination pointer for string operations, 1st argument, https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html Intel 64 and IA-32 Architectures Software Developer's Manual Volume 1: Basic Architecture, 3 Basic execution environment, 3.4 Basic program execution registers, 3.4.1 General-Purpose Registers, 3.4.1.1 General-Purpose Registers in 64-Bit Mode.
    mov rsi, message_label    ; address of the string
    ; rsi is a 64-bit general-purpose register, source pointer for string operations, 2nd argument, https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html Intel 64 and IA-32 Architectures Software Developer's Manual Volume 1: Basic Architecture, 3 Basic execution environment, 3.4 Basic program execution registers, 3.4.1 General-Purpose Registers, 3.4.1.1 General-Purpose Registers in 64-Bit Mode.
    mov rdx, length_symbol    ; length of the string
    ; rdx is a 64-bit general-purpose register, I/O pointer, 3rd argument, https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html Intel 64 and IA-32 Architectures Software Developer's Manual Volume 1: Basic Architecture, 3 Basic execution environment, 3.4 Basic program execution registers, 3.4.1 General-Purpose Registers,
    syscall
    ; syscall is an instruction that makes a system call https://man7.org/linux/man-pages/man2/syscall.2.html

    ; the instruction used to transition to kernel mode
    ; Arch/ABI    Instruction           System  Ret  Ret  Error    Notes
    ;                                   call #  val  val2
    ; x86-64      syscall               rax     rax  rdx  -        5

    ; the registers used to pass the system call arguments.
    ; Arch          arg1  arg2  arg3  arg4  arg5  arg6  arg7  Notes
    ; x86-64        rdi   rsi   rdx   r10   r8    r9    -

    ; Also, Intel 64 and IA-32 Architectures Software Developer's Manual Combined Volumes 2A, 2B, 2C, and  2D: Instruction Set Reference, A- Z https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html

    ; === Exit the process (exit(0)) ===
    mov rax, 60     ; syscall number: sys_exit
    ; 60	common	exit			sys_exit https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl
    ; https://man7.org/linux/man-pages/man2/exit.2.html
    mov rdi, 0      ; exit code
    syscall

    ; Summary:
    ; 1. It is mostly the syscall x64 processor command usage https://man7.org/linux/man-pages/man2/syscall.2.html
    ; 2. List of system commands https://man7.org/linux/man-pages/dir_section_2.html and numbers https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl
    ; 3. mov is a simple assembler command, like on mov rax, 1 is rax=1.
    ; 4. _start is used by the ld linker.
    ; 5. Section, label, symbol, db, equ, $, global: these are parts of the NASM assembler syntax.
    ; So, only mov, syscall, and register names are parts of the x64 processor syntax.
