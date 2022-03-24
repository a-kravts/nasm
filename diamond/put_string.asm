; Print string to stdout
; put_string.asm

global put_string
extern string_length

section .text
put_string:					; [ebp+8] - address of the string
		push ebp
		mov ebp, esp
		push dword [ebp+8]
		call string_length	; put string length into eax
		add esp, 4
		mov edx, eax		; copy string length
		push ebx
		mov eax, 4			; preparing for syscall
		mov ebx, 1
		mov ecx, [ebp+8]
		int 80h				; syscall write
		pop ebx
		pop ebp
		ret
