; printing a diamond of a given height
; diamond.asm

global _start
extern read_uint8
extern put_string
extern print_diamond

section .data
epon	db	"Enter a positive odd height from 3 to 23 inclusive: ", 0
ivri	db	"Incorrecd value. Repeat input: ", 0
fmsg	db	10, "Fault or EOF has occurred. Exit.", 10, 0

section .text
_start:	push ebp
		mov ebp, esp
		push dword epon
		call put_string
		add esp, 4
		sub esp, 8			; [ebp-4] - height of diamond
							; [ebp-8] - success
.lp		call read_uint8
		cmp [ebp-8], dword 1	; is success == 1?
		jne .fault			; if no => fault
		mov ax, [ebp-4]		; height => ax
		cmp ax, 23			; is height > 23?
		jg .error			; if yes => error
		cmp ax, 3			; is height < 3?
		jl .error			; if yes => error
		mov cl, 2
		div cl				; ax / cl => al, ax % cl => ah
		cmp ah, 0			; is height even?
		je .error			; if yes => error
		xor ecx, ecx		; ecx = 0
		mov cl, al			; n = half-height of diamond - 1 => ecx
		push dword [ebp-4]
		push ecx
		call print_diamond
		jmp short .quit

.error:	push dword ivri
		call put_string
		add esp, 4
		jmp short .lp
.fault:	cmp eax, 0			; did EOF or fault occur?
		jg .error			; if no => error
		push dword fmsg
		call put_string
		add esp, 4

.quit:	mov eax, 1			; preparing for syscall
		mov ebx, 0
		int 80h				; syscall _exit
