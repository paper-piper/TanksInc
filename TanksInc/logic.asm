;the equasions for caculating the path of a thrown object by time is as follows:
; (this aren't the real equasions, but a simplified version made by me). (:
; Horizontal motion:  x = v * t (1 - angle * angle / 2) 
; Vertical motion:  y = v*t *angle-  5t^2 

;================================
;In: nothing
; moves canonball 1 according to too many things
;Out: nothing
;================================
proc movCannonBall1
	pusha
		;pushing all the values so we can delete the cannonball image right before printing it again
		push offset canonballPicture
		push [canonballWidth]
		push [canonballHeight]
		push [canonball1_x]
		push [canonball1_y]
		call del_image_from_memory
		inc [canonball1_time]
		;del the privios partical
		push [part1_model]
		push 5
		push 5
		push [part1_x]
		push [part1_y]
		call del_image_from_memory
		;print the new partical
		mov ax,[canonball1_x]
		mov [part1_x],ax
		mov ax,[canonball1_y]
		mov [part1_y],ax
		mov bl,[tickCounter]
		and bl,00001111b ;get a random number between 1-16
		mov ax,12 ;get the right place of item in the arr
		mul bl
		add ax,offset part_pictures
		mov [part1_model],ax
		push ax
		push 5
		push 5
		push [part1_x]
		push [part1_y]
		call print_image_from_memory
		;calculating x
		
		mov al,[canonball1_Velocity]
		mul [canonball1_time] 
		mov bx,10
		mov dx,0
		div bx ;ax = v * t
		mov [canonball1_x],ax ;canonX = v * t
		mov al,[canonball1_initial_angle]
		mul [canonball1_initial_angle] ;ax = a * a
		mov bx,20000
		sub bx,ax
		mov ax,bx ;ax = 20,000 - a * a
		mov bx,200
		mov dx,0
		div bx
		mul [canonball1_x] ;ax = (v * t *((20,000 - a * a) / 200))
		mov bx,100
		mov dx,0
		div bx
		add ax,[canonball1_initial_x]
		mov [canonball1_x],ax
		;calculating y
		mov al,[canonball1_Velocity]
		mul [canonball1_time] 
		mov bx,10
		mov dx,0
		div bx ;ax = v * t
		mul [canonball1_initial_angle] ;ax probably won't overflow, becuase the max amount is approximate for 48,000
		mov bx,100
		mov dx,0
		div bx
		mov [canonball1_y],ax 	;canonball1_y = v * t * angle
		mov ax,5
		mov bl,[canonball1_time]
		xor bh,bh
		mul bl
		mul bx
		mov bx,100
		mov dx,0
		div bx ;ax = 5 * t * t
		mov bx,[canonball1_y]
		sub bx,ax ;canonbally = ((v * t * a /10) /100) - (5 * t * t/100)
		mov ah,bh
		and ah,10000000b
		cmp ah,0
		;je notNegitive
		neg bx
		notNegitive:
		add bx,[canonball1_initial_y]
		mov [canonball1_y],bx
		cmp bx,0 ;not exact number, need to check
		jl OutOfBounds
		cmp bx,150
		jg OutOfBounds
		
		mov ax,[canonball1_x]
		cmp ax,0 ;not exact number, need to check
		jl OutOfBounds
		cmp ax,320
		jg OutOfBounds
		mov [canonball1_x],ax ;canonball_x =(v * t *((20,000 - a * a) / 200))/100 + InitialX
		
		
		;call handle collusion
		;check every 
		mov cx,9
		mov dx,[canonball1_x]
		mov bx,[canonball1_y]
		sub bx,5
		check_pixels:
		
		push 0 ;the return value, the defult is 0
		push 2
		push dx
		push bx
		call Handle_collision
		pop ax ;the return value
		cmp ax,1
		je OutOfBounds ;not really out of bounds, but collide
		
		cmp cx, 5
		jb dec_x1
		inc bx
		jmp dec_y1
		dec_x1:
		dec dx
		dec_y1:
		loop check_pixels
		;deleting the image with the values we already pushed
		
		;printing cannonball at his new location
		push offset canonballPicture
		push [canonballWidth]
		push [canonballHeight]
		push [canonball1_x]
		push [canonball1_y]
		call print_image_from_memory
		jmp skipOutOfBounds
		OutOfBounds:
		;call del_image_from_memory
		push [part1_model]
		push 5
		push 5
		push [part1_x]
		push [part1_y]
		call del_image_from_memory
		mov [is_tank1_fired],0
		skipOutOfBounds:
	popa
	ret
endp movCannonBall1

;================================
;In: nothing
; moves canonball 2 according to too many things
;Out: nothing
;================================
proc movCannonBall2
	pusha
		;pushing all the values so we can delete the cannonball image right before printing it again
		push offset canonballPicture
		push [canonballWidth]
		push [canonballHeight]
		push [canonball2_x]
		push [canonball2_y]
		call del_image_from_memory
		inc [canonball2_time]
		;del the privios partical
		push [part2_model]
		push 5
		push 5
		push [part2_x]
		push [part2_y]
		call del_image_from_memory
		;print the new partical
		mov ax,[canonball2_x]
		mov [part2_x],ax
		mov ax,[canonball2_y]
		mov [part2_y],ax
		mov bl,[tickCounter]
		and bl,00000111b ;get a random number between 1-8
		mov ax,25 ;get the right place of item in the arr
		mul bl
		add ax,offset part_pictures
		mov [part2_model],ax
		push ax
		push 5
		push 5
		push [part2_x]
		push [part2_y]
		call print_image_from_memory
		;calculating x
		
		mov al,[canonball2_Velocity]
		mul [canonball2_time] 
		mov bx,10
		mov dx,0
		div bx ;ax = v * t
		mov [canonball2_x],ax ;canonX = v * t
		mov al,[canonball2_initial_angle]
		mul [canonball2_initial_angle] ;ax = a * a
		mov bx,20000
		sub bx,ax
		mov ax,bx ;ax = 20,000 - a * a
		mov bx,200
		mov dx,0
		div bx
		mul [canonball2_x] ;ax = (v * t *((20,000 - a * a) / 200))
		mov bx,100
		mov dx,0
		div bx
		mov bx,[canonball2_initial_x]
		sub bx,ax
		mov [canonball2_x],bx
		;calculating y
		mov al,[canonball2_Velocity]
		mul [canonball2_time] 
		mov bx,10
		mov dx,0
		div bx ;ax = v * t
		mul [canonball2_initial_angle] ;ax probably won't overflow, becuase the max amount is approximate for 48,000
		mov bx,100
		mov dx,0
		div bx
		mov [canonball2_y],ax 	;canonball1_y = v * t * angle
		mov ax,5
		mov bl,[canonball2_time]
		xor bh,bh
		mul bl
		mul bx
		mov bx,100
		mov dx,0
		div bx ;ax = 5 * t * t
		mov bx,[canonball2_y]
		sub bx,ax ;canonbally = ((v * t * a /10) /100) - (5 * t * t/100)
		mov ah,bh
		and ah,10000000b
		cmp ah,0
		;je notNegitive
		neg bx
		notNegitive2:
		add bx,[canonball2_initial_y]
		mov [canonball2_y],bx
		cmp bx,0 ;not exact number, need to check
		jl OutOfBounds2
		cmp bx,150
		jg OutOfBounds2
		
		mov ax,[canonball2_x]
		cmp ax,0 ;not exact number, need to check
		jl OutOfBounds2
		cmp ax,320
		jg OutOfBounds2
		mov [canonball2_x],ax ;canonball_x =(v * t *((20,000 - a * a) / 200))/100 + InitialX
		
		
		;call handle collusion
		;check every pixel on the
		mov cx,9
		mov dx,[canonball2_x]
		sub dx,6
		mov bx,[canonball2_y]	
		sub bx,5
		check_pixels2:
		
		push 0 ;the return value, the defult is 0
		push 1
		push dx
		push bx
		call Handle_collision
		pop ax ;the return value
		cmp ax,1
		je OutOfBounds2 ;not really out of bounds, but collide
		
		cmp cx, 5
		jb dec_x2
		inc bx
		jmp dec_y2
		dec_x2:
		inc dx
		dec_y2:
		loop check_pixels2
		;deleting the image with the values we already pushed
		;call del_image_from_memory
		
		;printing cannonball at his new location
		push offset canonballPicture
		push [canonballWidth]
		push [canonballHeight]
		push [canonball2_x]
		push [canonball2_y]
		call print_image_from_memory
		jmp skipOutOfBounds2
		OutOfBounds2:
		;del the partical
		push [part2_model]
		push 5
		push 5
		push [part2_x]
		push [part2_y]
		call del_image_from_memory
		mov [is_tank2_fired],0
		skipOutOfBounds2:
	popa
	ret
endp movCannonBall2

;================================
;In: the return value, and the attacked tank
; check if the canonball collided and acts accordingly
;Out: if the canonball colided, therefor should the canonball stop moving
;================================
DoesCollide equ [word ptr bp + 10] ;a return value, so the proc doesnt pop it 1 = true, 0 = false (it is 0 by defult)
AttackedTank equ [word ptr bp + 8]
xPos equ [word ptr bp + 6]
yPos equ [word ptr bp + 4]
proc Handle_collision 
	push bp
	mov bp,sp
	pusha
		;a loot to check 5 ver and 5 hor pixels
		mov cx,xPos
		add cx,5
		mov dx,yPos
		add dx,5
		mov ah,0dh
		int 10h ;now al contains the pixel color

		cmp al,04dh
		je backgroundColor
		cmp al,04eh
		je backgroundColor
		cmp al,0fh
		je backgroundColor
		cmp al,10h
		je backgroundColor
		cmp al,16
		je backgroundColor
		cmp al,14h
		je backgroundColor
		cmp al,4
		je backgroundColor
		;if it is in the range of 39 - 44, then bg (canonball particals)
		cmp al,39
		jb collide
		cmp al,44
		ja collide
		backgroundColor:
		jmp bg_color
		
		collide:
		;if its not  bg color, it is neceerly colide and we finish the loop
		mov DoesCollide,1
		cmp al,48d
		je finish_colliding

		;cmp al,2  ;also the tank color
		;je half_finish_colliding
		
		cmp AttackedTank,1 ;check which tank is attacked
		je Tank1_Damaged
		push [part1_model]
		push 5
		push 5
		push [part1_x]
		push [part1_y]
		call del_image_from_memory
		;make the tank flash red and play hit music
		call tank2Hit
		;if the tank is dead, present win screen
		cmp [tank2_health],0
		jne finish_colliding
		push 1
		call ManageWinScreen
		jmp finish_colliding
		
		Tank1_Damaged:
		push [part2_model]
		push 5
		push 5
		push [part2_x]
		push [part2_y]
		call del_image_from_memory
		call tank1Hit
		cmp [tank1_health],0
		jne finish_colliding
		push 2
		call ManageWinScreen
		jmp finish_colliding

		bg_color:
		mov DoesCollide,0
		finish_colliding:
	popa
	pop bp
	ret 6
endp Handle_collision

;================================
;In: nothing
; handles the hit of tank2
;Out: nothing
;================================
proc tank2Hit
	pusha
		mov al,45 ;the length of the health bar
		xor ah,ah
		mov bl,[max_hit_points]
		div bl
		dec [tank2_health]
		mov bl,[tank2_health]
		mov bh,al ;bh = 50 / full hp
		mul bl ;al = 50 / full_hp  * current hp
		xor ah,ah
		add ax,257 ;the length from the screen edge
		mov bl,bh
		xor bh,bh
		push offset hitpoint_pic
		push bx
		push 4
		push ax
		push 185
		call print_image_from_memory

		;flashing red loop
		mov cx,4
		mov dl,0
		tank2HitLoop:
		push cx
		cmp dl,0
		jne print_tank2
		push 2
		call RedTank
		jmp finish_tank2Hit
		print_tank2:
		push 1
		mov bx,offset Rmodels_names
		mov ax,11
		mov cl,[tank2Model]
		mul cl
		add ax,bx
		push ax
		push 48
		push 33
		push [tank2x]
		push 155
		call HandleBmp
		finish_tank2Hit:
		push offset HitSound
		push offset HitSoundCounter
		push [HitSoundLength]
		call printSong
		xor dl,1
		call WaitOneTick
		pop cx
		loop tank2HitLoop
	popa
	ret
endp tank2Hit

;================================
;In: nothing
; handles the hit of tank 1
;Out: nothing
;================================
proc tank1Hit
	pusha
	mov al,45 ;the length of the health bar
	xor ah,ah
	mov bl,[max_hit_points]
	div bl
	dec [tank1_health]
	mov bl,[tank1_health]
	mov bh,al ;bh = 50 / full hp
	mul bl ;al = 50 / full_hp  * current hp
	xor ah,ah
	add ax,14 ; the length from the screen edge
	mov bl,bh
	xor bh,bh
	push offset hitpoint_pic
	push bx
	push 4
	push ax
	push 185
	call print_image_from_memory
	mov cx,4
		mov dl,0
		tank1HitLoop:
		push cx
		cmp dl,0
		jne print_tank1
		push 1
		call RedTank
		jmp finish_tank1Hit
		print_tank1:
		push 1
		mov bx,offset models_names
		mov ax,10
		mov cl,[tank1Model]
		mul cl
		add ax,bx
		push ax
		push 48
		push 33
		push [tank1x]
		push 155
		call HandleBmp
		finish_tank1Hit:
		push offset HitSound
		push offset HitSoundCounter
		push [HitSoundLength]
		call printSong
		xor dl,1
		call WaitOneTick
		pop cx
		loop tank1HitLoop
	popa
	ret
endp tank1Hit

;================================
;In: nothing
; waits one tick
;Out: nothing
;================================
proc WaitOneTick
	pusha
		mov ax, 40h
		mov es,ax
		mov bx,[tickCounter]
		add bx,2
		wait_for_tick:
		mov cx,[tickCounter]
		cmp bx,cx
		ja wait_for_tick
	popa
	ret
endp WaitOneTick

;================================
;In: which tank won
; handles the winning of one of the tanks
;Out: nothing
;================================
winningTank equ [word ptr bp + 4]
proc GameOver
	push bp
	mov bp,sp
	pusha
		cmp winningTank,1
		je tank1_wins
		;get the right model type
		mov ax,11
		mov bl,[tank2Model]
		mul bl
		add ax,offset models_names
		;delete the tank photo
		push 0
		push ax
		push [tank_width]
		push [tank_height]
		push [tank2x]
		push [tank_con_y]
		call HandleBmp
		jmp finish_winning
		
		tank1_wins:
		mov ax,11
		mov bl,[tank1Model]
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
		finish_winning:
	popa
	pop bp
	ret 2
endp GameOver



;================================
;In: nothing
; handles keypresses in the game
;Out: nothing
;================================
proc ReadKeyPressGame
push ax
	;check if a key was presses, if not, then finish the proc
	in al, 64h
	cmp al, 10b
	je noNewKey 
	in ax, 60h
		
	cmp al,1
	je escDown
	cmp al,10h
	je qDown
	cmp al,90h
	je qUp
	cmp al,011h
	je wDown
	cmp al,12h
	je eDown
	cmp al,01eh
	je aDown
	cmp al,09eh
	je aUp
	cmp al,01fh
	je sDown
	cmp al,020h
	je dDown
	cmp al,0a0h
	je dIsUp ;dUp is dup
	
	noNewKey:
	;In case no key was pressed
	jmp third_finishing
	
	escDown:
	call closeSpeaker
	mov ah, 0
    mov al, 2
    int 10h
	mov ah,04ch
	int 21h
	jmp third_finishing
	
	qDown:
	;for Vel, later
	jmp third_finishing
	
	qUp:
	;for Vel, later
	jmp third_finishing
	
	wDown:
	mov [tank1CanonnKey],1
	jmp third_finishing
	
	eDown:
	cmp [is_tank1_fired],1
	je third_finishing
	mov [tank1ShotKey],1
	jmp third_finishing

	aDown:
	mov [tank1MovKey],-1
	jmp third_finishing
	
	aUp:
	cmp [tank1MovKey],-1
	jne third_finishing
	mov [tank1MovKey],0
	jmp third_finishing
	
	sDown:
	mov [tank1CanonnKey],-1
	jmp third_finishing
	
	
	dDown:
	mov [tank1MovKey],1
	jmp half_finishReading
	
	dIsUp:
	cmp [tank1MovKey],1
	jne half_finishReading
	mov [tank1MovKey],0
	jmp half_finishReading
	
	third_finishing:
	

	cmp al,034h
	je dotDown
	cmp al,0b4h
	je dotUp
	cmp al,035h
	je slashDown
	cmp al,48h
	je upArrowDown
	cmp al,04bh
	je leftArrowDown
	cmp al,0cbh
	je leftArrowUp
	cmp al,04dh
	je rightArrowDown
	cmp al,0cdh
	je rightArrowUp
	cmp al,050h
	je downArrowDown
	
	dotDown:
	;for vel,later
	jmp half_finishReading
	
	dotUp:
	;for vel,later
	jmp half_finishReading
	
	half_finishReading:
	jmp finishReading
	
	slashDown:
	cmp [is_tank2_fired],1
	je finishReading
	mov [tank2ShotKey],1
	jmp finishReading
	
	upArrowDown:
	mov [tank2CanonnKey],1
	jmp finishReading
	
	
	leftArrowDown:
	mov [tank2MovKey],-1
	jmp finishReading
	
	leftArrowUp:
	cmp [tank2MovKey],-1
	jne finishReading
	mov [tank2MovKey],0
	jmp finishReading 
	
	rightArrowDown:
	mov [tank2MovKey],1
	jmp finishReading
	
	rightArrowUp:
	cmp [tank2MovKey],1
	jne finishReading
	mov [tank2MovKey],0
	jmp finishReading 
	
	downArrowDown:
	mov [tank2CanonnKey],-1
	
	finishReading:
	pop ax
	ret
endp ReadKeyPressGame

;================================
;In: the return value
; handles keypresses in the setting menu
;Out: did the user pressed enter therefor the proc should return to main
;================================
returnToMain equ [word ptr bp + 4] ;return value, 0 = no, 1 = yes
proc ReadKeyPressSettings
push bp
mov bp,sp
push ax
	in al, 64h
	cmp al, 10b
	je half_finish_read
	in ax, 60h
	
	
	cmp al,1
	je esc_prs
	cmp al,01ch
	je enter_prs
	cmp al,48h
	je up_arrow_prs
	cmp al,050h
	je down_arrow_prs
	cmp al,04bh
	je leftArrowDown_prs
	cmp al,0cbh
	je leftArrowUp_prs
	cmp al,04dh
	je rightArrowDown_prs
	cmp al,0cdh
	je rightArrowUp_prs
	
	jmp half_finish_read
	
	esc_prs:
	call closeSpeaker
	mov ah, 0
    mov al, 2
    int 10h
	mov ah,04ch
	int 21h
	
	enter_prs:
	mov [is_enter_pressed],1
	mov al,1
	xor ah,ah
	mov returnToMain,ax
	jmp half_finish_read

	up_arrow_prs:
	push -1
	call switchpointers
	half_finish_read:
	jmp finish_read
	
	down_arrow_prs:
	push 1
	call switchpointers
	jmp finish_read
	
	leftArrowDown_prs:
	cmp [is_arrow_left_pressed],2 ;if arrow already pressed and used, do not active until deactivated
	je finish_read
	mov [is_arrow_left_pressed],1 ;to activate
	jmp finish_read

	leftArrowUp_prs:
	mov [is_arrow_left_pressed],0
	jmp finish_read

	rightArrowDown_prs:
	cmp [is_arrow_right_pressed],2 ;if arrow already pressed and used, do not active until deactivated
	je finish_read
	mov [is_arrow_right_pressed],1 ;to activate
	jmp finish_read

	rightArrowUp_prs:
	mov [is_arrow_right_pressed],0
	jmp finish_read
	finish_read:
	pop ax
	pop bp
	ret
endp ReadKeyPressSettings

;================================
;In: the return value
; handles keypresses in the Main meny
;Out: should the proc switch window, and which one.
;================================
switchwindow equ [word ptr bp + 4] ;return value, 0 = no, 1 = start game, -1 = settings
proc ReadKeyPressMain
push bp
mov bp,sp
push ax
	in al, 64h
	cmp al, 10b
	je half_finish_prs 
	in ax, 60h
	
	cmp al,1
	je prs_esc
	cmp al,01ch
	je prs_enter
	cmp al,48h
	je prs_up_arrow
	cmp al,0c8h
	je un_prs_up_arrow
	cmp al,0d0h
	je un_prs_down_arrow
	cmp al,050h
	je prs_down_arrow
	jmp half_finish_prs
	
	prs_esc:
	call closeSpeaker
	mov ah, 0
    mov al, 2
    int 10h
	mov ah,04ch
	int 21h
	
	prs_enter:
	mov al,[pointerCurrentPos]
	xor ah,ah
	mov switchwindow,ax
	mov [is_enter_pressed],1
	jmp half_finish_prs

	
	prs_up_arrow:
	cmp [is_arrow_up_pressed],1
	je finish_prs
		push -1
		call switchpointers
	mov [is_arrow_up_pressed],1

	half_finish_prs:
	jmp finish_prs

	un_prs_up_arrow:
	mov [is_arrow_up_pressed],0
	jmp finish_prs

	prs_down_arrow:
	cmp [is_arrow_down_pressed],1
	je finish_prs
		push 1
		call switchpointers
	mov [is_arrow_down_pressed],1
	jmp finish_prs

	un_prs_down_arrow:
	mov [is_arrow_down_pressed],0
	finish_prs:
	pop ax
	pop bp
	ret
endp ReadKeyPressMain