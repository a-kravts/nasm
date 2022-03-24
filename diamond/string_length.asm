; Counting string length
; string_length.asm

global string_length

section .text
string_length:				; [ebp+8] - address of the string
		push ebp
		mov ebp, esp
		xor eax, eax		; eax = 0
		mov edx, [ebp+8]
.lp		cmp [edx+eax], byte 0	; current byte == 0?
		je .quit			; if yes => quit
		inc eax
		jmp short .lp
.quit	pop ebp
		ret
