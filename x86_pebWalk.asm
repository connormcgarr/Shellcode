; PEB 
; Author Connor McGarr (@33y0re)

.386					; 32-bit
.model flat, stdcall			; __stdcall calling conventing for functions (uses the stack)
assume fs:flat				; Tell assembler we are going to access fs segment register

.data 					; Start data section
.code 					; Start code section

_start:
	xor ecx, ecx 			; Clear out ECX
	mov eax, fs:[30h]  		; Member of TEB structure, PEB, is at an offset of 0x30 inside TEB
	mov eax, [eax+0Ch]		; Member of PEB structure, PEB_LDR_DATA, is at an offset of 0x0c inside PEB
	mov esi, [eax+0Ch]		; Member of PEB_LDR_DATA, InLoadOrderModuleList (a doubly linked list), is at an offset of 0xC inside of PEB_LDR_DATA
	mov ebx, 006b0065h		; "ke" in unicode format
	call _walkPEB			; Call function to walk the loaded modules

; Walk loaded modules via InMemoryOrderModuleList (doubly linked list where each list points to an LDR_DATA_TABLE_ENTRY)
; Break upon loading a module with a predefined "name" and length
; We technically "skip" the first loaded module, which is the current process (the process in which this assembly is running in) in order to start the loop
_walkPEB:
	mov esi, [esi] 			; Dereference first member of the LDR_DATA_TABLE_ENTRY structure, InLoadOrderLinks, to get next module in the doubly linked list
	mov eax, [esi+18h]		; Save base address of the current module via LDR_DATA_TABLE_ENTRY into EAX
	mov edi, [esi+2Ch]		; Store name of module into EDI (_UNICODE_STRING)
	cmp edi, ebx 			; Have we found kernel32.dll?
	jne _walkPEB

end _start 				; Finished
	
ENDc
