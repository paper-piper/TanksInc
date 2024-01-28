IDEAL
MODEL small
STACK 100h
p186
include 'memory.asm'
include 'BmpCtrl.asm'
include 'logic.asm'
include 'sound.asm'
include 'uiMgr.asm'
;================================
CODESEG

;================================
;In: which diraction to move
;the function moves tank2 to the passed direction in 1 pixel
;Out: nothing
;================================
dir_mov_tank2 equ [word ptr bp + 4]
proc mov_tank2
	push bp 
	mov bp,sp
	pusha
		;check borders
		mov ax,[tank2x]
		add ax,dir_mov_tank2
		cmp ax,186
		jl out_of_borders_move2
		mov bx,offset models_width
		mov dl,[tank2Model]
		xor dh,dh
		mov si,dx
		mov cx,320d
		mov dl,[byte ptr bx + si]
		sub cx,dx
		cmp ax,cx
		jg out_of_borders_move2
		;get the right model type
		mov ax,11
		mov bl,[tank2Model]
		mul bl
		add ax,offset Rmodels_names
		;delete the tank photo
		push 0
		push ax
		push [tank_width]
		push [tank_height]
		push [tank2x]
		push [tank_con_y]
		call HandleBmp
		
		;mov the tank x in one pixel to the required diraction
		mov bx,dir_mov_tank2
		add [tank2x],bx	
		
		;print the tank again at the new location
		push 1
		push ax
		push [tank_width]
		push [tank_height]
		push [tank2x]
		push [tank_con_y]
		call HandleBmp
		out_of_borders_move2:
	popa
	pop bp
	ret 2
endp mov_tank2

;================================
;In: which diraction to move
;the function moves the tank1 to the passed direction in 1 pixel
;Out: nothing
;================================
dir_mov_tank1 equ [word ptr bp + 4]
proc mov_tank1
	push bp 
	mov bp,sp
	pusha
		;check borders
		mov ax,[tank1x]
		add ax,dir_mov_tank1
		cmp ax,0
		jl out_of_borders_move1
		mov bx,offset models_width
		mov dl,[tank1Model]
		xor dh,dh
		mov si,dx
		mov cx,139d
		mov dl,[byte ptr bx + si]
		sub cx,dx
		cmp ax,cx
		jg out_of_borders_move1
		;get the right model type
		mov ax,10
		mov bl,[tank1Model]
		mul bl
		add ax,offset models_names
		;delete the tank photo
		push 0
		push ax
		push [tank_width]
		push [tank_height]
		push [tank1x]
		push [tank_con_y]
		call HandleBmp
		
		;mov the tank x in one pixel to the required diraction
		mov bx,dir_mov_tank1
		add [tank1x],bx
		
		;print the tank again at the new location
		push 1
		push ax
		push [tank_width]
		push [tank_height]
		push [tank1x]
		push [tank_con_y]
		call HandleBmp
		out_of_borders_move1:
	popa
	pop bp
	ret 2
endp mov_tank1

;================================
;In: which "direction" should the tank model switch
;The proc switches the tank1 model and prints it to the screen
;Out: nothing
;================================
dir_switch_tank1_model equ [word ptr bp + 4] ;-1 = left, 1 = right
proc switch_tank1_model
	push bp
	mov bp,sp
	pusha
		mov al,[tank1Model]
		mov bl,al
		xor bh,bh
		add bx,dir_switch_tank1_model
		cmp bl,-1
		je cant_switch_tank1_model
		cmp bl,9d
		je cant_switch_tank1_model
		
		
		mov bl,10
		mul bl ;now ax contains the addision of the offset for the models names arr
		mov bx,offset models_names
		add bx,ax 
		
		push 0 ;to delete the current tank model
		push bx ;the curent tank model names
		push [tank_width]
		push [tank_height]
		push [tank1x]
		push [tank_con_y]
		call HandleBmp
		
		mov ax,dir_switch_tank1_model
		add [tank1Model],al
		mov al,[tank1Model]
		mov bl,10
		mul bl ;now ax contains the addision of the offset for the models names arr
		mov bx,offset models_names
		add bx,ax 
		
		push 1 ;to print the new tank model
		push bx ;the curent tank model names
		push [tank_width]
		push [tank_height]
		push [tank1x]
		push [tank_con_y]
		call HandleBmp
		
		
	cant_switch_tank1_model:	
	popa
	pop bp
	ret 2
endp switch_tank1_model

;================================
;In: which "direction" should the tank model switch
;The proc switches the tank1 model and prints it to the screen
;Out: nothing
;================================
dir_switch_tank2_model equ [word ptr bp + 4] ;-1 = left, 1 = right
proc switch_tank2_model
	push bp
	mov bp,sp
	pusha
		mov al,[tank2Model]
		mov bl,al
		xor bh,bh
		add bx,dir_switch_tank2_model
		cmp bl,-1
		je cant_switch_tank2_model
		cmp bl,9d
		je cant_switch_tank2_model
		
		
		mov bl,11
		mul bl ;now ax contains the addision of the offset for the models names arr
		mov bx,offset Rmodels_names
		add bx,ax 
		
		push 0 ;to delete the current tank model
		push bx ;the curent tank model names
		push [tank_width]
		push [tank_height]
		push [tank2x]
		push [tank_con_y]
		call HandleBmp
		
		mov ax,dir_switch_tank2_model
		add [tank2Model],al
		mov al,[tank2Model]
		mov bl,11
		mul bl ;now ax contains the addision of the offset for the models names arr
		mov bx,offset Rmodels_names
		add bx,ax 
		
		push 1 ;to print the new tank model
		push bx ;the curent tank model names
		push [tank_width]
		push [tank_height]
		push [tank2x]
		push [tank_con_y]
		call HandleBmp
		
		
	cant_switch_tank2_model:	
	popa
	pop bp
	ret 2
endp switch_tank2_model


;================================
;In: nothing
;The proc fires the cannon of the second tank if possible
;out: nothing
;================================
proc shot_cannon2
	pusha
		cmp [is_tank2_fired],0
		jne finish_shoot2
		
		mov bx,offset models_canon_x
		mov ax,[tank_width]
		mov cl,[tank2Model]
		xor ch,ch
		mov si,cx
		mov cl,[byte ptr bx + si]
		sub ax,cx
		sub ax,5
		add ax,[tank2x]
		mov [canonball2_initial_x],ax
		mov [canonball2_x],ax
		;canonball1 x = tank1x + canonball x - tank width
		
		mov bx, offset models_canon_y
		mov al,155
		sub al,[byte ptr bx + si] ;si is already set to the model number
		xor ah,ah
		mov [canonball2_initial_y],ax
		mov [canonball2_y],ax
		;canonball2 y = canonball y + the tank's distance form the button of the screen

		push offset canonballPicture
		push [canonballWidth]
		push [canonballHeight]
		push [canonball2_initial_x]
		push [canonball2_initial_y]
		call print_image_from_memory
		
		
		
		mov [canonball2_time],0
		mov bx,offset models_angles
		mov al,[byte ptr bx + si] ;si is already set to the model number
		mov [canonball2_initial_angle],al
		mov[is_tank2_fired],1
		finish_shoot2:
	popa
	ret 
endp shot_cannon2
;================================
;In: nothing
;The proc fires the cannon of the first tank if possible
;out: nothing
;================================
proc shot_cannon1
	pusha
		cmp [is_tank1_fired],0
		jne finish_shoot1
		
		mov bx,offset models_canon_x
		xor ah,ah
		mov al,[tank1Model]
		mov si,ax
		mov al,[byte ptr bx + si]
		add ax,[tank1x]
		mov [canonball1_initial_x],ax
		mov [canonball1_x],ax
		;canonball1 x = tank1x + canonball x - tank width
		
		mov bx, offset models_canon_y
		mov al,155
		sub al,[byte ptr bx + si] ;si is already set to the model number
		xor ah,ah
		mov [canonball1_initial_y],ax
		mov [canonball1_y],ax
		;canonball2 y = canonball y + the tank's distance form the button of the screen

		push offset canonballPicture
		push [canonballWidth]
		push [canonballHeight]
		push [canonball1_initial_x]
		push [canonball1_initial_y]
		call print_image_from_memory
		
		
		
		mov [canonball1_time],0
		mov bx,offset models_angles
		mov al,[byte ptr bx + si] ;si is already set to the model number
		mov [canonball1_initial_angle],al
		mov[is_tank1_fired],1
		finish_shoot1:
	popa
	ret 
endp shot_cannon1

start :
	mov ax, @data
	mov ds, ax
	; Your code here
	mov ax, 13h
	int 10h ;go into graphics mode
	mov ax,offset pointerCurrentPos
	;before Painting the tanks starting the game, we have opening screen, we finna finnes this general
	backToStart:
	call closeSpeaker
	mov [pointerCurrentPos],0
	call ManageHomeScreen
	
	;reset all values
	mov al,[max_hit_points]
	mov [tank2_health],al
	mov [tank1_health],al
	mov [isGameOver],0
	mov [tank1x],20d
	mov [tank2x],262d
	mov [tank1Model],0
	mov [tank2Model],0
	mov [is_tank1_fired],0
	mov [is_tank2_fired],0
	
	call InisiateGame ;paint the background and two tanks
	;open the speaker


	mov bx, offset tank1CanonnKey
	;wait for the first tick to pass
	mov ax, 40h
	mov es,ax
	mov bx,[tickCounter]
	WaitForFirstTick:
	cmp bx,[tickCounter]
	je WaitForFirstTick
	mov bx, offset tank1CanonnKey
	mov bx,[tickCounter]	

	WaitForTick:
	cmp [isGameOver],1
	je backToStart
	;read the players keys
	mov ax, 40h
	mov es,ax
	call ReadKeyPressGame
	mov cx,[tickCounter]
	cmp bx,cx
	ja WaitForTick
	mov ax, 40h
	mov es,ax
	mov bx,[tickCounter]
	mov al,[game_speed]
	add bx,ax ;ah = 0 becuase we set ax to 40h right before
	
	;play next char in the musics
	push offset GameTheme
	push offset GameThemeCounter
	push [GameThemeLength]
	call printSong
	;when a tick is passed, appply all register moves	
	
	cmp [tank1ShotKey],0
	je tank1NoShot
	call shot_cannon1
	mov [tank1ShotKey],0
	tank1NoShot:
	
	cmp [tank2ShotKey],0
	je tank2NoShot
	call shot_cannon2
	mov [tank2ShotKey],0
	tank2NoShot:
	
	cmp [tank1MovKey],0
	je tank1NoMov
	push [tank1MovKey]
	call mov_tank1
	tank1NoMov:
	
	cmp [tank2MovKey],0
	je tank2NoMov
	push [tank2MovKey]
	call mov_tank2
	tank2NoMov:
	
	cmp [tank1CanonnKey],0
	je tank1NoCanon
	push [tank1CanonnKey]
	call switch_tank1_model
	mov [tank1CanonnKey],0
	tank1NoCanon:
	
	cmp [tank2CanonnKey],0
	je tank2NoCanon
	push [tank2CanonnKey]
	call switch_tank2_model
	mov [tank2CanonnKey],0
	tank2NoCanon:
	
	cmp [is_tank1_fired],0
	je canonball1NoMove
	call movCannonBall1
	cmp [is_tank1_fired],0
	je canonball1NoMove
	call movCannonBall1
	canonball1NoMove:
	
	cmp [is_tank2_fired],0
	je HalfWaitForTick
	call movCannonBall2
	cmp [is_tank2_fired],0
	je HalfWaitForTick
	call movCannonBall2
	HalfWaitForTick:
	jmp WaitForTick
; --------------------------
exit :
	mov ax, 4c00h
	int 21h
END start


