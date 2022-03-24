; print diamond lines
; print_diamond.asm

global print_diamond

section .bss
buf			resb	1088		; 1058 maximum value

section .text
; [ebp+8]  - n - (half-height of diamond - 1)
; [ebp+12] - N - height of diamond
print_diamond:
		push ebp
		mov ebp, esp
		mov edx, 1			; k - line number
		push edi
		mov edi, buf		; current buffer index
; top part of diamond
.lp1:	mov ecx, 1			; calculating number of spaces:
		add ecx, [ebp+8]	; n + 1 = ecx
		sub ecx, edx		; n + 1 - k = ecx
		cmp ecx, 0			; is number of spaces = 0?
		je .pst1			; if yes => put star
.ps1:	mov [edi], byte ' '	; put space character => current buffer index
		inc edi
		loop .ps1
.pst1:	mov [edi], byte '*'	; put star
		inc edi
		cmp edx, 1			; is k == 1?
		je .pnlc1			; if yes => put newline character
		mov al, 2			; calculating number of spaces:
		mul dl				; 2 * k = ax
		sub eax, 3			; 2 * k - 3 = eax
		mov ecx, eax
.ps2:	mov [edi], byte ' '	; put space character
		inc edi
		loop .ps2
.pst2	mov [edi], byte '*'	; put star
		inc edi
.pnlc1:	mov [edi], byte 10	; put newline character
		inc edi
		inc edx				; k + 1
		mov eax, 1
		add eax, [ebp+8]	; n + 1 => eax
		cmp edx, eax		; is k > n + 1?
		jg .lp2				; if yes => lp2
		jmp short .lp1
; bottom part of diamond
.lp2:	mov ecx, edx		; calculating number of spaces:
		sub ecx, [ebp+8]	; k - n = ecx
		dec ecx				; k - n - 1 = ecx
.ps3:	mov [edi], byte ' '	; put space character
		inc edi
		loop .ps3
		mov [edi], byte '*'	; put star
		inc edi
		cmp edx, [ebp+12]	; is k == N?
		je .pnlc2			; if yes => put newline character
		mov al, 4			; calculating number of spaces:
		mov ecx, [ebp+8]	; n => ecx
		mul cl				; 4 * n = ax
		mov cx, ax
		mov al, 2
		mul dl				; 2 * k = ax
		sub cx, ax			; 4 * n - 2 * k = cx
		inc cx				; 4 * n - 2 * k + 1 = cx
.ps4:	mov [edi], byte ' '	; put space character
		inc edi
		loop .ps4
		mov [edi], byte '*'	; put star
		inc edi
.pnlc2:	mov [edi], byte 10	; put newline character
		inc edi
		inc edx				; k + 1
		cmp edx, [ebp+12]	; is k > N?
		jg .done			; if yes => done
		jmp short .lp2

.done:	sub edi, buf		; number of characters in buffer => edi
		push ebx
		mov eax, 4			; preparing for syscall
		mov ebx, 1
		mov ecx, buf
		mov edx, edi
		int 80h				; syscall write
		pop ebx				; preparing for return
		pop edi
		pop ebp
		ret
