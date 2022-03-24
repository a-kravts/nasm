; Reading a number from 0 to 255
; read_uint8.asm

global read_uint8

section .text
read_uint8:					; [ebp+8] - success, [ebp+12] - number
		push ebp
		mov ebp, esp
		push edi
		sub esp, 4			; [ebp-8] - temporary buffer
		mov edi, esp		; temporary buffer address => edi
		push ebx
		mov eax, 3			; preparing for syscall
		mov ebx, 0
		mov ecx, edi
		mov edx, 4
		int 80h				; syscall read
		cmp eax, 0			; were characters read?
		jle .fail			; if no => fail
		mov ecx, eax		; characters number => counter
		xor eax, eax		; eax = 0
.lp:	cmp [edi], byte 10	; is current character == '\n'?
		je .quit			; if yes => quit
		cmp [edi], byte '0'	; is character code < '0'?
		jl .fail			; if yes => fail
		cmp [edi], byte '9'	; is character code > '9'?
		jg .fail			; if yes => fail
		mov dl, 10
		mul dl				; al * dl => ax
		jc .fail			; if result didn't fit in 8 bits => fail
		mov dl, [edi]		; current character => dl
		sub dl, '0'			; character - '0' == digit => dl
		add al, dl			; current result in al
		jc .fail			; if result didn't fit in 8 bits => fail
		mov [ebp+12], eax	; result => number
		mov [ebp+8], dword 1	; success = 1
		inc edi				; next character
		loop .lp

.fail:	mov [ebp+8], dword 0	; success = 0
.quit:	pop ebx
		add esp, 4			; remove temporary buffer
		pop edi
		pop ebp
		ret
