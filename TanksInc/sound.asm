;================================
;In: nothing
; opens the speaker
;Out: nothing
;================================
proc openSpeaker
pusha
	in al, 61h
	or al, 00000011b
	out 61h, al
	; send control word to change frequency
	mov al, 0B6h
	out 43h, al
	popa
ret
endp openSpeaker

;================================
;In: whice note (in hz)
; plays one note
;Out: nothing
;================================
Mynote equ [word ptr bp + 4]
proc playNote
	push bp
	mov bp,sp
	pusha
		mov ax, Mynote
		out 42h, al ; Sending lower byte
		mov al, ah
		out 42h, al ; Sending upper byte
	popa
	pop bp
	ret 2
endp playNote

;================================
;In: nothing
; closes the speaker
;Out: nothing
;================================
proc closeSpeaker
pusha
	in al, 61h
	and al, 11111100b
	out 61h, al
	popa
	ret
endp closeSpeaker

;================================
;In: song name, song counter (of which note are we currently in), and its length (to know when to resttart)
; handles keypresses in the game
;Out: nothing
;================================
songName equ [word ptr bp + 8]
songCounter equ [word ptr bp + 6]
songLength equ [word ptr bp +4]
proc printSong
push bp
mov bp,sp
pusha
	cmp [is_mute],0
	jne music_muted
	mov bx,songCounter
	mov dx,[word ptr bx]
	cmp dx,songLength
	jb allOkay
	mov [word ptr bx],0
	mov dx,0
	allOkay:
	mov di,dx
	mov bx,songName
	mov ax,[word ptr bx + di]
	cmp ax,0
	je skipPlay
	call openSpeaker
	push ax
	call playNote
	jmp finishPlaying
	skipPlay:
	call closeSpeaker
	finishPlaying:
	inc dx
	inc dx
	mov bx,songCounter
	mov [word ptr bx],dx
	jmp not_muted
	music_muted:
	call closeSpeaker
	not_muted:
popa
pop bp
ret 6
endp printSong