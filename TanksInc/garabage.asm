;tanks pictures
tank0_picture db 1584 dup (0)
tank1_picture db 1584 dup (0)
tank2_picture db 1584 dup (0)
tank3_picture db 1584 dup (0)
tank4_picture db 1584 dup (0)
tank5_picture db 1584 dup (0)
tank6_picture db 1584 dup (0)
tank7_picture db 1584 dup (0)
tank8_picture db 1584 dup (0)
;Rtank pictures
Rtank0_picture db 1584 dup (0)
Rtank1_picture db 1584 dup (0)
Rtank2_picture db 1584 dup (0)
Rtank3_picture db 1584 dup (0)
Rtank4_picture db 1584 dup (0)
Rtank5_picture db 1584 dup (0)
Rtank6_picture db 1584 dup (0)
Rtank7_picture db 1584 dup (0)
Rtank8_picture db 1584 dup (0)
;================================
;tank's model based qualities
models_pictures_pointers dw offset tank0_picture,offset tank1_picture,offset tank2_picture,offset tank3_picture,offset tank4_picture,offset tank5_picture,offset tank6_picture,offset tank7_picture,offset tank8_picture

;part of initiate game proc
;================================
		mov dx,offset models_names
		mov bx,offset models_pictures_pointers
		mov cx,9
		SaveAllTanksModels:
		push 48
		push 33
		push dx
		add dx,10
		push [word ptr bx]
		add bx,4
		call SaveBmpToMemory
		loop SaveAllTanksModels
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

offset_print_image equ [word ptr bp + 12d]
height_print_image equ [word ptr bp + 10d]
width_print_image equ [word ptr bp + 8]
x_print_image equ [word ptr bp + 6]
y_print_image_ equ [word ptr bp + 4]
proc print_image
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
endp print_image

offset_del_image equ [word ptr bp + 12d]
height_del_image equ [word ptr bp + 10d]
width_del_image equ [word ptr bp + 8]
x_del_image equ [word ptr bp + 6]
y_del_image equ [word ptr bp + 4]
proc del_image
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
				mov bx,offset background
				mov dl, [byte ptr bx + si]
				push x_del_image
				push y_del_image
				push dx
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
endp del_image

proc mov_tank1
	push bp 
	mov bp,sp
	pusha
		;check borders
		mov ax,[tank1x]
		add ax,dir_mov_tank1
		cmp ax,-1
		je out_of_borders_move1
		mov bx,offset models_width
		mov dl,[tank1Model]
		xor dh,dh
		mov si,dx
		mov cx,321d
		mov dl,[byte ptr bx + si]
		sub cx,dx
		cmp ax,cx
		je out_of_borders_move1
		;get the right model type
		mov ax,4
		mov bl,[tank1Model]
		mul bl
		add ax,offset models_pictures_pointers
		;delete the tank photo
		push ax
		push [tank_width]
		push [tank_height]
		push [tank1x]
		push [tank_con_y]
		call del_image
		
		;mov the tank x in one pixel to the required diraction
		mov bx,dir_mov_tank1
		add [tank1x],bx
		
		;print the tank again at the new location
		push ax
		push [tank_width]
		push [tank_height]
		push [tank1x]
		push [tank_con_y]
		call print_image
		out_of_borders_move1:
	popa
	pop bp
	ret 2
endp mov_tank1
