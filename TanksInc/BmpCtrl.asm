IDEAL
MODEL small
STACK 100h
p186
;================================
;In: the file name offset in DX
;the function opens the file, and moves ax 0 if there is an error (for debugging)
;Out: nothing
;================================
CODESEG
proc OpenFile
  mov ah, 3Dh
  xor al, al
  int 21h
  jc openerror
  jmp openFinish
openerror:
  mov ax, 0
openFinish:
  ret
endp OpenFile

;================================
;In: 1. BX = file handle 2. DX = bmp header buffer
;the function Reads the header of the file into dx
;Out: nothing
;================================
proc ReadBMPHeader
  pusha
  mov ah,3fh
  mov cx,54
  int 21h
  popa
  ret
endp ReadBMPHeader

;================================
;In:  1. BX = file handle 2. DX = palette buffer
; Read BMP file color palette, 256 colors * 4 bytes (400h)
;Out: nothing
;================================
proc ReadBMPPalette
  pusha
  mov ah, 3fh
  mov cx, 400h
  int 21h
  popa
  ret
endp ReadBMPPalette	

;================================
;In: palette buffer
; Copy the colors palette to the video memory registers
;Out: nothing
;================================
proc CopyBMPPalette
  pusha
  mov cx,256
  mov dx,3C8h
  mov al,0
  ; Copy starting color to port 3C8h
  out dx,al
  ; Copy palette itself to port 3C9h
  inc dx
PalLoop:
  ; Note: Colors in a BMP file are saved as BGR values rather than RGB.
  mov al,[si+2] ; Get red value.
  shr al,2 ; Max. is 255, but video palette maximal
   ; value is 63. Therefore dividing by 4.
  out dx,al ; Send it.
  mov al,[si+1] ; Get green value.
  shr al,2
  out dx,al ; Send it.
  mov al,[si] ; Get blue value.
  shr al,2
  out dx,al ; Send it.
  add si,4 ; Point to next color.
   ; (There is a null chr. after every color.)
  loop PalLoop
  popa
  ret
endp CopyBMPPalette

;================================
;In: bx = file name offset
;the function closes the file
;Out: nothing
;================================
proc CloseFile
  pusha
  mov ah,3Eh
  int 21h
  popa
  ret
endp CloseFile

;================================
;In: does print or delete type, sizes and location of the image.
;the function copies the bmp file into the screen
;Out: nothing
;================================
does_print equ [word ptr bp + 12]
pic_width equ [word ptr bp + 10]
pic_height equ [word ptr bp + 8]
xPos equ [word ptr bp + 6]
yPos equ [word ptr bp + 4]
proc CopyBitmap
	; BMP graphics are saved upside-down .
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	push bp
	mov bp,sp
	pusha
	mov ax, 0A000h
	mov es, ax
	mov cx,yPos
	PrintBMPLoop :
	push cx
	; di = cx*320, point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di,xPos
	; Read one line
	mov ah,3fh
	mov cx,pic_width
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,pic_width
	mov si,offset ScrLine
	repmovsp:
	mov al,[ds:si]
	cmp al,06ah
	je transperent
	cmp does_print,1
	je printbmpImg
	mov al,04dh
	printbmpImg:
	mov [es:di],al
	delbmpImg:
	transperent:
	inc si
	inc di
	loop repmovsp

	pop cx
	mov ax,yPos
	sub ax,pic_height
	cmp cx,ax
	je endloop
	loop PrintBMPLoop
	endloop:
	popa
	pop bp
	ret 10
endp CopyBitmap

;================================
;In: the sizes and saved location offset
;the function copies the bmp file into the memory somewhere 
;Out: nothing
;================================
arr_width equ [word ptr bp + 8]
arr_height equ [word ptr bp + 6]
arr_offset equ [word ptr bp + 4]
proc SaveBitmap
		; BMP graphics are saved upside-down .
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	push bp
	mov bp,sp
	pusha
		mov dx,arr_offset
		mov cx,arr_height
		mov ax,arr_width ;the height and width won't exeed 256, so we can be sure ah and ch are clear
		mul cl
		add dx,ax ;dx contains the end of the arr
		mov cx,arr_width
		mov ax,arr_height
		CopyRows:
		sub dx,cx
		push ax
		mov ax, 03F00h
		int 21h; Read from file. BX = file handle, CX = number of bytes to read, DX = buffer
		pop ax
		dec ax
		cmp ax,0
		jne CopyRows
	popa
	pop bp
	ret 6
endp SaveBitmap

;================================
;In: image size, location, print or delete, and name.
; the proc handles all of those bmp procs above in a more organized way for easier and cleaner code.
;Out: nothing
;================================
is_print equ [word ptr bp + 14] ;1 equal yes, 0 equal no
pic_name_offset equ [word ptr bp + 12]
pic_width equ [word ptr bp + 10]
pic_height equ [word ptr bp + 8]
xPos equ [word ptr bp + 6]
yPos equ [word ptr bp + 4]
proc HandleBmp
	push bp
	mov bp,sp
	pusha
		mov dx,pic_name_offset
		call OpenFile
		mov [file_handle],ax
		mov bx, ax ; AX is the file handle from OpenFile
		mov dx, offset tmpHeader ; 54 bytes on memory
		call ReadBMPHeader
		mov dx, offset Palette
		call ReadBMPPalette
		push is_print
		push pic_width ; width
		push pic_height ; height
		push xPos ; x
		push yPos ; y
		call CopyBitmap
		mov bx,[file_handle]
		call CloseFile
	popa
	pop bp
	ret 12
endp HandleBmp

;================================
;In: the sizes and saved location offset
;the function Handles all of the procces of copying a file to memory
;Out: nothing
;================================
pic_width_SaveBmpToMemory equ [word ptr bp + 10]
pic_height_SaveBmpToMemory equ [word ptr bp + 8]
file_name_offset equ [word ptr bp + 6]
buffer_offset equ [word ptr bp + 4]
proc SaveBmpToMemory
	push bp
	mov bp,sp
	pusha
		mov dx,file_name_offset
		call OpenFile
		mov [file_handle],ax
		mov bx, ax ; AX is the file handle from OpenFile
		mov dx, offset tmpHeader ; 54 bytes on memory
		call ReadBMPHeader
		mov dx, offset Palette
		call ReadBMPPalette
		push pic_width_SaveBmpToMemory
		push pic_height_SaveBmpToMemory
		push buffer_offset
		call SaveBitmap
		mov bx,[file_handle]
		call CloseFile
	popa
	pop bp
	ret 6
endp SaveBmpToMemory

;================================
;In: location and color
; the proc prints one pixel at the selected place
;Out: nothing
;================================
x_one_dot equ [word ptr bp + 8]
y_one_dot equ [word ptr bp + 6]
color_one_dot equ [word ptr bp + 4]
proc one_dot
	;----------------------------------------------
	;print a single dot
	;input:
	;	x_one_dot - the x coordiate of the dot
	;	y_one_dot - the y coordiate of the dot
	;	color_one_dot - the color of the dot	
	;----------------------------------------------
    push bp
	mov bp, sp
	pusha
	;mov bh,0h
	mov cx,x_one_dot
	mov dx,y_one_dot
	mov ax,color_one_dot
	mov ah,0ch
	int 10h
	popa
	pop bp
	ret 6
endp one_dot

;================================
;In: sizes, location and location in memory
; the function prints a image from memory (mostly used for small files)
;Out: nothing
;================================
offset_print_image equ [word ptr bp + 12d]
width_print_image equ [word ptr bp + 10]
height_print_image equ [word ptr bp + 8d]
x_print_image equ [word ptr bp + 6]
y_print_image_ equ [word ptr bp + 4]
proc print_image_from_memory
	;----------------------------------------------
	;In: offset to arr, height,width,x,y
	;The function prints the pushed image to the screen
	;Out: nothing
	;----------------------------------------------
	push bp
	mov bp,sp
	pusha
	mov bx, offset_print_image
	xor si, si
	xor dx,dx
	mov cx, height_print_image
	printcols:
		push cx
		push x_print_image
		mov cx, width_print_image
		printRows:
			mov dl, [byte ptr bx + si]
			cmp dl,06ah
			je skip_print
			push x_print_image
			push y_print_image_
			push dx
			call one_dot
			skip_print:
			inc x_print_image
			inc si
		loop printRows
		inc y_print_image_
		pop x_print_image
		pop cx
	loop printcols
	popa
	pop bp
	ret 10 
endp print_image_from_memory

;================================
;In: sizes, location and location in memory
; the function deletes a image from memory (mostly used for small files)
;Out: nothing
;================================
offset_del_image equ [word ptr bp + 12d]
width_del_image equ [word ptr bp + 10]
height_del_image equ [word ptr bp + 8d]
x_del_image equ [word ptr bp + 6]
y_del_image equ [word ptr bp + 4]
proc del_image_from_memory
	push bp
	mov bp,sp
	pusha
	mov bx, offset_del_image
	xor si, si
	xor dx,dx
	mov cx, height_del_image
	delCols:
		push cx
		push x_del_image
		mov cx, width_del_image
		delRows:
			mov dl, [byte ptr bx + si]
			cmp dl,06ah
			je skip_del
				pusha
				mov bx,y_del_image
				mov ax,320d
				mul y_del_image
				add ax,x_del_image
				mov si,ax
				push x_del_image
				push y_del_image
				push 04dh
				call one_dot
				popa
			skip_del:
			inc x_del_image
			inc si
		loop delRows
		inc y_del_image
		pop x_del_image
		pop cx
	loop delCols
	popa
	pop bp
	ret 10 
endp del_image_from_memory

;================================
;In: nothing
; the proc Inisiates the game by loading the background and two tanks and health bars.
;Out: nothing
;================================
proc InisiateGame
	pusha
		mov dx,offset backgroundFileName
		call OpenFile
		mov [file_handle],ax
		mov bx, ax ; AX is the file handle from OpenFile
		mov dx, offset tmpHeader ; 54 bytes on memory
		call ReadBMPHeader
		mov dx, offset Palette
		call ReadBMPPalette
		mov si, dx
		call CopyBMPPalette
		push 1
		push 320 ; width
		push 200 ; height
		push 0 ; x
		push 200 ; y
		call CopyBitmap
		mov bx,[file_handle]
		call CloseFile
		
		push 1
		push offset models_names
		push [tank_width]
		push [tank_height]
		push [tank1x] 
		push [tank_con_y]
		call HandleBmp
		
		push 1
		push offset Rmodels_names
		push [tank_width]
		push [tank_height]
		push [tank2x] 
		push [tank_con_y]
		call HandleBmp
		
		push 1
		push offset health_bar_file_name
		push health_bar_width
		push health_bar_height
		push tank1_health_bar_x
		push tank1_health_bar_y
		call HandleBmp

		push 1
		push offset health_bar_file_name
		push health_bar_width
		push health_bar_height
		push tank2_health_bar_x
		push tank2_health_bar_y
		call HandleBmp
	popa
	ret
endp InisiateGame

;================================
;In: which tank
; the function handles the procces of printing a image of the tank only in red to indicate hit
;Out: nothing
;================================
whichTank equ [word ptr bp + 4]
proc RedTank
	push bp
	mov bp,sp
	pusha
		cmp whichTank,1
		je r_tank1
		mov bx,offset Rmodels_names
		mov ax,11
		mov cl,[tank2Model]
		mul cl
		add ax,bx
		push [tank2x]
		jmp r_finish_modeling
		r_tank1:
		mov bx,offset models_names
		mov ax,10
		mov cl,[tank1Model]
		mul cl
		add ax,bx
		push [tank1x]
		r_finish_modeling:
		
		mov dx,ax ;ax = pic_name_offset
		call OpenFile
		mov [file_handle],ax
		mov bx, ax ; AX is the file handle from OpenFile
		mov dx, offset tmpHeader ; 54 bytes on memory
		call ReadBMPHeader
		mov dx, offset Palette
		call ReadBMPPalette
		pop ax
		push 48 ; width
		push 33 ; height
		push ax ; x
		push 155 ; y
		call RedBmp
		mov bx,[file_handle]
		call CloseFile
	popa
	pop bp
	ret 2
endp RedTank

;================================
;In: sizes and location
; the function prints the tank in red
;Out: nothing
;================================
R_pic_width equ [word ptr bp + 10]
R_pic_height equ [word ptr bp + 8]
R_xPos equ [word ptr bp + 6]
R_yPos equ [word ptr bp + 4]
proc RedBmp
	; BMP graphics are saved upside-down .
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	push bp
	mov bp,sp
	pusha
	mov ax, 0A000h
	mov es, ax
	mov cx,R_yPos
	R_PrintBMPLoop :
	push cx
	; di = cx*320, point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di,R_xPos
	; Read one line
	mov ah,3fh
	mov cx,R_pic_width
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,R_pic_width
	mov si,offset ScrLine
	R_repmovsp:
	mov al,[ds:si]
	cmp al,06ah
	je R_transperent
	mov al,4
	mov [es:di],al
	R_transperent:
	inc si
	inc di
	loop R_repmovsp

	;rep movsb is same as the following code :
	;mov es:di, ds:si
	;inc si
	;inc di
	;dec cx
	 ;loop until cx=0

	pop cx
	mov ax,R_yPos
	sub ax,R_pic_height
	cmp cx,ax
	je R_endloop
	loop R_PrintBMPLoop
	R_endloop:
	popa
	pop bp
	ret 8
endp RedBmp
