dir_switchPointers equ [word ptr bp + 4] ;1 = down, -1 = up
proc switchPointers
	push bp
	mov bp,sp
	pusha
	    ;first, check if the dir is out of bounds, if so, skip printing in general
		mov ax,dir_switchPointers
		add [pointerCurrentPos],al
		cmp [pointerCurrentPos],1
		jg pointer_out_of_bouds
		cmp [pointerCurrentPos],-1
		jl pointer_out_of_bouds
		jmp finish_check_bounds_pointer

		pointer_out_of_bouds:
		sub [pointerCurrentPos],al
		jmp skip_pointers
		finish_check_bounds_pointer:
		sub [pointerCurrentPos],al
		;second, delete the current
		mov ax,116 ;the defult height of pointers
		cmp [pointerCurrentPos],0
		je finish_pointers_adjustment
		jg pointer_pos_1
		jl pointer_pos_minus_1
		pointer_pos_1:
		add ax,28 ;the diffrence
		jmp finish_pointers_adjustment
		pointer_pos_minus_1:
		sub ax,28 ;the diffrence
		finish_pointers_adjustment:
		
		push offset pointerPicture
		push 17
		push 4
		push 83
		push ax ;116, the middle
		call del_image_from_memory
		
		push offset pointerPicture
		push 17
		push 4
		push 223
		push ax ;116
		call del_image_from_memory
		
		mov bx,dir_switchPointers
		add [pointerCurrentPos],bl
		cmp dir_switchPointers,0
		jg pointer_plus_1
		jl pointer_minus_1
		pointer_plus_1:
		add ax,28 ;the diffrence
		jmp finish_pointers_redirection
		pointer_minus_1:
		sub ax,28 ;the diffrence
		finish_pointers_redirection:
		
		push offset pointerPicture
		push 17
		push 4
		push 83
		push ax
		call print_image_from_memory
		
		push offset pointerPicture
		push 17
		push 4
		push 223
		push ax
		call print_image_from_memory
		skip_pointers:
	popa
	pop bp
	ret 2
endp switchPointers

;================================
;in: nothing
;the proc prints the home screen and manages it, the proc ends when the player clicks 'start game'
;out: nothing
;================================
proc ManageHomeScreen
	pusha
		backfromsettings:
		;printing the home screen
		push 1
		push offset mainScreenFileName
		push 320 ; width
		push 200 ; height
		push 0 ; x
		push 200 ; y
		call HandleBmp
		
		;wait one tick 
		call WaitOneTick
		call WaitOneTick
		call WaitOneTick
		;every tick check if the user enter some window, if yes, switch to that window, else play a note
		mov ax, 40h
		mov es,ax
		mov bx,[tickCounter]
		wait_for_switch:
		push -2 ;the return value, if it doesn't change this means enter wasn't pressed
		call ReadKeyPressMain
		pop ax ;recive the return value
		
		mov cx, 40h
		mov es,cx
		mov cx,[tickCounter]
		cmp bx,cx
		ja wait_for_switch
		mov bx,[tickCounter]
		add bx,1
		;print a note from the song
		push offset MainTheme
		push offset MainThemeCounter
		push [MainThemeLength]
		call printSong
		cmp al,-2
		je wait_for_switch
		cmp al,0
		jl startGame
		je GoTosetting
		GoTosetting:
		;else, go to settings menu

		call ManageSettingsScreen
		jmp backfromsettings
		startGame:
	popa
	ret
endp ManageHomeScreen



;================================
;in: nothing
;the proc prints the settings screen and manages it, the proc ends when the player presses enter and then
;returns to the home screen menu
;out: nothing
;================================
proc ManageSettingsScreen
	pusha
		;print setting screen
		push 1
		push offset stgScreenFileName
		push 320 ; width
		push 200 ; height
		push 0 ; x
		push 200 ; y
		call HandleBmp
		
		;wait one tick in order to avoid enter problems
		call WaitOneTick

		winning_wait:
		;get keyboard press


		;wait for enter to finish display.
		
		mov ax, 40h
		mov es,ax
		mov bx,[tickCounter]
		wait_for_return:
		mov cx, 40h
		mov es,cx
		mov cx,[tickCounter]
		cmp bx,cx
		ja wait_for_return
		mov bx,[tickCounter]
		add bx,2
		push offset SettingSong
		push offset SettingSongCounter
		push [SettingSongLength]
		call printSong
		push 0 ;the return value
		call ReadKeyPressSettings
		;before checking the return value, check other key strokes
		;check left key
		cmp [is_arrow_left_pressed],1
		jne half_finish_left_arrow_prs
		mov [is_arrow_left_pressed],2 ;to signle that the pressed was used
		
		;figure out the pointer pos
		cmp [pointerCurrentPos],0
		jg music_stg
		je health_stg
		jmp speed_stg
		health_stg:
		

		;else, health stg
		cmp [max_hit_points],1
		je half_finish_left_arrow_prs
		cmp [max_hit_points],4
		jg dec_hit_point_3

		;else, health = 3
		push 0
		push offset mid_filename
		push 37
		push 11
		push health_x
		push health_y
		call HandleBmp
		mov [max_hit_points],1
		push 1
		push offset low_filename
		push 38
		push 11
		push health_x
		push health_y
		call HandleBmp
		jmp finish_left_arrow_prs

		dec_hit_point_3:
		push 0
		push offset high_filename
		push 46
		push 11
		push health_x
		push health_y
		call HandleBmp
		mov [max_hit_points],3
		push 1
		push offset mid_filename
		push 37
		push 11
		push health_x
		push health_y
		call HandleBmp
		jmp finish_left_arrow_prs

		half_finish_left_arrow_prs:
		jmp finish_left_arrow_prs

		music_stg:
		push 0
		push offset on_filename
		push 23
		push 11
		push music_x
		push music_y
		call HandleBmp
		push 1
		push offset off_filename
		push 35
		push 11
		push music_x
		push music_y
		call HandleBmp
		mov [is_mute],1
		jmp finish_left_arrow_prs

		;figure out the current speed, and change it and his display accordingly
		speed_stg:
		cmp [game_speed],2
		jg finish_left_arrow_prs
		jl set_speed_2
		;else speed = 2, so we set it to 1
		;first, delete the Current Image
		push 0
		push offset mid_filename
		push 37
		push 11
		push speed_x
		push speed_y
		call HandleBmp

		;and then print the new one
		push 1
		push offset low_filename
		push 38
		push 11
		push speed_x
		push speed_y
		call HandleBmp
		mov [game_speed],3
		jmp finish_left_arrow_prs
		
		set_speed_2:
		;first,delete the Current Image
		push 0
		push offset high_filename
		push 46
		push 11
		push speed_x
		push speed_y
		call HandleBmp
		;and then print the new one
		push 1
		push offset mid_filename
		push 37
		push 11
		push speed_x
		push speed_y
		call HandleBmp
		mov [game_speed],2
		jmp finish_left_arrow_prs

		finish_left_arrow_prs:
		
		;figure out right press
		cmp [is_arrow_right_pressed],1
		jne half_finish_right_arrow_prs
		mov [is_arrow_right_pressed],2 ;to signle that the pressed was used
		
		;figure out the pointer pos
		cmp [pointerCurrentPos],0
		jg music_stg_right
		je health_stg_right
		jmp speed_stg_right
		health_stg_right:
		;else, health stg
		cmp [max_hit_points],5
		je finish_left_arrow_prs
		cmp [max_hit_points],2
		jg inc_hit_point_5

		;else, health = 1
		push 0
		push offset low_filename
		push 38
		push 11
		push health_x
		push health_y
		call HandleBmp
		mov [max_hit_points],3
		push 1
		push offset mid_filename
		push 37
		push 11
		push health_x
		push health_y
		call HandleBmp
		jmp finish_right_arrow_prs

		half_finish_right_arrow_prs:
		jmp finish_right_arrow_prs

		inc_hit_point_5:
		mov [max_hit_points],5
		push 0
		push offset mid_filename
		push 37
		push 11
		push health_x
		push health_y
		call HandleBmp
		push 1
		push offset high_filename
		push 46
		push 11
		push health_x
		push health_y
		call HandleBmp
		jmp finish_right_arrow_prs

		music_stg_right:
		push 0
		push offset off_filename
		push 35
		push 11
		push music_x
		push music_y
		call HandleBmp
		push 1
		push offset on_filename
		push 23
		push 11
		push music_x
		push music_y
		call HandleBmp
		mov [is_mute],0
		call closeSpeaker
		jmp finish_right_arrow_prs

		speed_stg_right:
		cmp [game_speed],2
		jl finish_right_arrow_prs
		jg inc_speed_2 ;acually set_speed_2, but this label is already used for a diffrent purpse.
		;else speed = 2, so set it to 3.
		;first, delete the current image
		push 0
		push offset mid_filename
		push 37
		push 11
		push speed_x
		push speed_y
		call HandleBmp
		;and then print the current
		push 1
		push offset high_filename
		push 46
		push 11
		push speed_x
		push speed_y
		call HandleBmp
		mov [game_speed],1
		jmp finish_right_arrow_prs
		
		inc_speed_2:
		push 0
		push offset low_filename
		push 38
		push 11
		push speed_x
		push speed_y
		call HandleBmp

		mov [game_speed],2
		push 1
		push offset mid_filename
		push 37
		push 11
		push speed_x
		push speed_y
		call HandleBmp
		jmp finish_right_arrow_prs

		finish_right_arrow_prs:
		pop ax ;the return value
		cmp ax,0
		jne finish_settings
		jmp wait_for_return

		pop ax ;the return value
		cmp ax,0
		jne finish_settings
		jmp wait_for_return
		finish_settings:
	popa
	ret
endp ManageSettingsScreen


;================================
;in: nothing
;the proc prints the correct photo of the winning tank, and plays winning music until enter is pressed
;out: nothing
;================================
which_tank_wins equ [word ptr bp + 4]
proc ManageWinScreen
	push bp
	mov bp,sp
	pusha
		mov [isGameOver],1
		;print the correct screen:
		push 1
		cmp which_tank_wins,1
		je tank1_win
		push offset tnk2WinFileName
		jmp finish_win
		tank1_win:
		push offset tnk1WinFileName
		finish_win:
		push 320 ; width
		push 200 ; height
		push 0 ; x
		push 200 ; y
		call HandleBmp
		
		mov ax, 40h
		mov es,ax
		mov bx,[tickCounter]
		wait_for_enter:
		;get keyboard press
		mov cx, 40h
		mov es,cx
		mov cx,[tickCounter]
		cmp bx,cx
		ja wait_for_enter
		mov cx, 40h
		mov es,cx
		mov bx,[tickCounter]
		add bx,1
		;wait for enter to finish display.
		push offset WinningSong
		push offset WinningSongCounter
		push [WinningSongLength]
		call printSong
		in al, 64h
		cmp al, 10b
		je wait_for_enter
		in ax, 60h
		cmp al,01ch
		jne wait_for_enter
		mov [WinningSongCounter],0
	popa
	pop bp
	ret 2
endp ManageWinScreen