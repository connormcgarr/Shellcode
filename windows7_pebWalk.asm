; PEB 
; Author Connor McGarr

.386						        ; 32-bit
.model flat, stdcall		; __stdcall calling conventing for functions (uses the stack)
assume fs:flat				  ; Tell assembler we are going to access fs segment register

.data 						      ; Start data section
.code 						      ; Start code section

_start:
	xor eax, eax			    ; Clear EAX
	mov eax, fs:[30h]  		; Member of TEB structure, PEB, is at an offset of 0x30 inside TEB
	mov eax, [eax+0Ch]		; Member of PEB structure, PEB_LDR_DATA, is at an offset of 0x0c inside PEB
	mov eax, [eax+14h]		; Member of PEB_LDR_DATA, InMemoryOrderModuleList (a doubly linked list), is at an offset of 0x1c inside of PEB_LDR_DATA
	call _walkPEB			    ; Call function to walk the loaded modules

; Walk all loaded modules via InMemoryOrderModuleList in order to locate a specific DLL
_walkPEB:
	ret

end _start 					    ; Finished
	
END
