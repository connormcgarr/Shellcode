; PEB Walking Assembly (64-bit)
; Compares length of desired DLL to current DLL and also perfoms a check on the first letter of the DLL name
; Author: Connor McGarr (@33y0re)

; Declare ExitProcess
EXTERNDEF ExitProcess:near

.data						; Start data section
.code						; Start code section

ALIGN						; Ensure alignment of the frame
_start PROC
	xor rcx, rcx				; Clear out RCX
	xor rdx, rdx				; Clear out RDX
	mov rax, gs:[60h]			; 64-bit uses GS segment register. Member of TEB structure, PEB, is at an offset of 0x30 inside TEB
	mov rax, [rax+18h]			; Member of PEB structure, PEB_LDR_DATA, is at an offset of 0x18 inside PEB
	mov rsi, [rax+10h]			; Member of PEB_LDR_DATA, InLoadOrderModuleList
	mov dl, 4bh				; "K" (Change this to the first letter of the DLL you want to find)
	call _walkPEB
_start ENDP

; Walk loaded modules via InLoadOrderModuleList (doubly linked list where each list points to an LDR_DATA_TABLE_ENTRY)
; We technically "skip" the first loaded module, which is the current process (the process in which this assembly is running in) in order to start the loop
_walkPEB PROC
	mov rsi, [rsi]				; Dereference first member of LDR_DATA_TABLE_ENTRY structure, InLoadOrderLinks, to get next module in the doubly linked list
	mov rax, [rsi+30h]			; Save base address of current module via LDR_DATA_TABLE_ENTRY
	mov rdi, [rsi+58h+8h]			; Store name of module into RDI (_UNICODE_STRING). First 8 bytes of BaseDLLName consists of Length and MaximumLength members
	cmp [rdi+12*2], cx			; KERNEL32.DLL is 12 bytes (x2 for unicode). Does the 24th byte, which should be a NULL terminator, equal 00?
	jne _walkPEB				; Didn't equal 00? Keep looping
	cmp [rdi], dl				; Have we located the desired module?
	jne _walkPEB				; Didn't find it? Keep looping
    	call ExitProcess                        ; We found the DLL? Exit the process
_walkPEB ENDP
END
