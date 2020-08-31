; PEB 
; Author Connor McGarr

.386				; 32-bit
.model flat, stdcall		; __stdcall calling conventing for functions (uses the stack)
assume fs:flat			; Tell assembler we are going to access fs segment register

.data 				; Start data section
.code 				; Start code section

_start:
	xor eax, eax		; Clear EAX
	mov eax, fs:[30h]  	; Member of TEB structure, PEB, is at an offset of 0x30 inside TEB
	mov eax, [eax+0Ch]	; Member of PEB structure, PEB_LDR_DATA, is at an offset of 0x0c inside PEB
	mov eax, [eax+14h]	; Member of PEB_LDR_DATA, InMemoryOrderModuleList (a doubly linked list), is at an offset of 0x1c inside of PEB_LDR_DATA
	call _walkPEB		; Call function to walk the loaded modules

; Walk loaded modules via InMemoryOrderModuleList (doubly linked list where each list points to an LDR_DATA_TABLE_ENTRY)
; Break upon loading a module with a predefined "name" and length
_walkPEB:
	xor ebx, ebx		; Clear out EBX
	xor ecx, ecx 		; Clear out ECX
	mov ebx, 6b65726eh	; "kern"
	mov eax, [eax-08h]	; Dereference InMemoryOrderModuleList to extract the LDR_DATA_TABLE_ENTRY structure
	mov ecx, [eax+18h]	; Save base address of the current module via LDR_DATA_TABLE_ENTRY into ECX
	mov eax, [eax+2Ch]	; Store name of module into EAX (_UNICODE_STRING)

end _start 			; Finished
	
END	
