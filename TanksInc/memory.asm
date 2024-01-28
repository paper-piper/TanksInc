
DATASEG
;A few notes
; 6a is treated as transperent colot
;that's it, ye
; here is all of the vars stored
;================================
;general 
tickCounter equ es:06ch
isGameOver db 0 ;0 = no, 1 = yes
;================================
;setting menu qualities
speed_x equ 170
speed_y equ 95
health_x equ 155
health_y equ 123
music_x equ 172
music_y equ 147
game_speed db 2 ;the defult value
max_hit_points db 3 ;the defult value
hitpoint_pic db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
off_filename db 'off.bmp',0
on_filename db 'on.bmp',0
low_filename db 'low.bmp',0
mid_filename db 'mid.bmp',0
high_filename db 'high.bmp',0
;================================
;musics
;the length are saved * 2
is_mute db 0 ;0 = no, 1 = yes (so it will be simetrical)
GameTheme dw 3225,0,0,0,3225,0,3225,0,3225,0,0,0,2415,0,0,0,2415,0,2415,0,2415,0,3225,0,0,0,1612,0,1612,0,0,0,3225,0,0,0,3225,0,3225,0,3225,0,0,0,2415,0,0,0,2415,0,2415,0,2415,0,3225,0,0,0,1612,0,1612,0,0,0,3225,0,0,0,3225,0,3225,0,3225,0,0,0,2415,0,0,0,2415,0,2415,0,2415,0,3225,0,0,0,1522,0,1522,0,0,0,3225,0,0,0,3225,0,3225,0,3225,0,0,0,2415,0,0,0,2415,0,2415,0,2415,0,3225,0,0,0,1522,0,1522,0,0,0,3225,0,0,0,2033,0,0,0,2033,0,0,0,3225,0,0,0,2415,0,0,0,2415,0,3225,0,0,0,1522,0,0,0,1522,0,3225,0,0,0,2033,0,0,0,2033,0,0,0,3225,0,0,0,2415,0,0,0,2415,0,3225,0,0,0,1522,0,0,0,1522,0,3225,0,0,0,2033,0,0,0,2033,0,0,0,3225,0,0,0,2415,0,0,0,2415,0,3225,0,0,0,1522,0,0,0,1522,0,3225,0,0,0,2033,0,0,0,2033,0,0,0,3225,0,0,0,2415,0,0,0,2415,0,3225,0,2712,0,2154,0,1811,0,1811,0
GameThemeCounter dw 0
GameThemeLength dw 512
MainTheme dw 3225,0,0,0,3225,0,3225,0,0,0,2415,0,0,0,2415,0,2415,0,2415,0,3225,0,0,0,1612,0,1612,0,0,0,3225,0,0,0,3225,0,3225,0,0,0,2415,0,0,0,2415,0,2415,0,2415,0,3225,0,0,0,1612,0,1612,0,0,0,3225,0,0,0,3225,0,3225,0,0,0,2415,0,0,0,2415,0,2415,0,2415,0,3225,0,0,0,1522,0,1522,0,0,0,3225,0,0,0,3225,0,3225,0,0,0,2415,0,0,0,2415,0,2415,0,2415,0,3225,0,0,0,1522,0,1522,0,0,0,3225,0,0,0,2033,0,0,0,2033,0,0,0,3225,0,0,0,2415,0,0,0,2415,0,3225,0,0,0,1522,0,0,0,1522,0,3225,0,0,0,2033,0,0,0,2033,0,0,0,3225,0,0,0,2415,0,0,0,2415,0,3225,0,0,0,1522,0,0,0,1522,0,3225,0,0,0,2033,0,0,0,2033,0,0,0,3225,0,0,0,2415,0,0,0,2415,0,3225,0,0,0,1522,0,0,0,1522,0,3225,0,0,0,2033,0,0,0,2033,0,0,0,3225,0,0,0,2415,0,0,0,2415,0,3225,0,2712,0,2154,0,1811,0,1811,0
MainThemeCounter dw 0
MainThemeLength dw 256
SettingSong dw 4554,4554,0,4554,0,6088,0,0,3616,3616,0,3044,0,0,2712,0,0,3044,0,0,3616,0,4058,0,4554,0,0,6088,6088,4554,4554,3616,3616,0,3044,3044,3616,0,4058,4058,4554,4554,6088,0,0,3616,3616,0,3044,0,0,2712,0,0,3044,0,0,3616,0,4058,0,4554,0,0,6088,6088,4554,4554,3616,3616,0,3044,3044,3616,0,4058,4058,4554,4554,6088,0,0,0,3616,3616,0,0,0,0,2712,2712,0,0,3044,0,0,0,0,3616,0,0,0,0,0,0,0,0,0,0,0
SettingSongCounter dw 0
SettingSongLength dw 220
WinningSong dw 5966,5966,5966,4972,4972,4972,4261,4261,4261,3729,3729,3729,3314,3314,3314,2295,2295,2295,2295,2295,2295,2295,2295,2295,1989,1989,1989,1989,1989,1989,1989,1989,1989,5966,5966,5966,4972,4972,4972,4261,4261,4261,3729,3729,3729,3314,3314,3314,2295,2295,2295,2295,2295,2295,2295,2295,2295,1989,1989,1989,1989,1989,1989,1989,1989,1989,5966,5966,5966,4972,4972,4972,4261,4261,4261,3729,3729,3729,3314,3314,3314,2295,2295,2295,2295,2295,2295,2295,2295,2295,2295,2295,2295,2500,2295,2295,2295,2500,2295,2295,2295,2500,2295,2295,2295,2500,2295,2295,2295
WinningSongCounter dw 0
WinningSongLength dw 220
;sound effects
HitSound dw 5000,4500,4000,3900
HitSoundCounter dw 0
HitSoundLength dw 8
;================================
;printing bmp qualities
file_handle dw 0
tmpHeader db 54 dup (0)
Palette db 1024 dup (0) ; All files should have the same palette, so we apply it once.
ScrLine db 320 dup (0)
;================================
;screens qualities
backgroundFileName db 'gbg.bmp',0
mainScreenFileName db 'mscr.bmp',0
stgScreenFileName db 'sscr.bmp',0
tnk1WinFileName db 't1w.bmp',0
tnk2WinFileName db 't2w.bmp',0
;================================
;main screen realated qualities
pointerPicture  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
pointerCurrentPos db 0 ; 1 = down, 0 = middle, -1 = up
;================================
;keyboard qualities
is_enter_pressed db 1 ;0 = no, 1 = yes (I tried using this method but it didn't work, may be used later)
is_arrow_down_pressed db 0 ;0 = no, 1 = yes
is_arrow_up_pressed db  0 ;0 = no, 1 = yes
is_arrow_left_pressed db 0 ;0 = no, 1 = just pressed, 2 = pressed and used
is_arrow_right_pressed db 0 ;0 = no, 1 = just pressed, 2 = pressed and used
;================================
;tank general qualities
tank_height dw 33
tank_width dw 48
tank_con_y dw 155 ;the tank canno't move up or down so y is constant
;================================
;tanks models information
;we treet this arr as two dimentional arr, to get to a value multiply it by 10
models_names db 'tank0.bmp',0,'tank1.bmp',0,'tank2.bmp',0,'tank3.bmp',0,'tank4.bmp',0,'tank5.bmp',0,'tank6.bmp',0,'tank7.bmp',0,'tank8.bmp',0
;we treet this arr as two dimentional arr, to get to a value multiply it by 11
Rmodels_names db 'Rtank0.bmp',0,'Rtank1.bmp',0,'Rtank2.bmp',0,'Rtank3.bmp',0,'Rtank4.bmp',0,'Rtank5.bmp',0,'Rtank6.bmp',0,'Rtank7.bmp',0,'Rtank8.bmp',0
models_angles db 0,8,16,23,31,43,46,56,60 ;in radians ,the acual value is /100. for example 8 = 0.08
models_canon_x db 50,50,50,50,50,48,48,48,46
models_canon_y db 20,22,25,27,29,33,34,37,37
models_width db 48,48,48,48,48,47,47,47,47
;================================
;health bar general qualities
health_bar_file_name db 'hp_bar.bmp',0
health_bar_width equ 53
health_bar_height equ 7
;================================
;tank1 qualities
tank1_health_bar_x equ 7
tank1_health_bar_y equ 190
tank1_health db 3
tank1Model db 0
tank1x dw 20d
is_tank1_fired db 0 ;0 means no, 1 means yes
tank1MovKey dw 0 ; 0 = nothing | 1 = right | -1 = left
tank1CanonnKey dw 0 ;0 = nothing | 1 = up | -1 = down
tank1ShotKey dw 0 ; 0 = nothing | 1 = shot
;================================
;tank2 qualities
tank2_health_bar_x equ 250
tank2_health_bar_y equ 190
tank2_health db 3
tank2Model db 0
tank2x dw 262d
is_tank2_fired db 0 ;0 means no, 1 means yes
tank2MovKey dw 0 ; 0 = nothing | 1 = right | -1 = left
tank2CanonnKey dw 0 ;0 = nothing | 1 = up | -1 = down
tank2ShotKey dw 0 ; 0 = nothing | 1 = shot
;================================
;canonball general qualities
canonballPicture    db 06ah,16,16,16,06ah
					db 16,014h,014h,014h,16
					db 16,014h,014h,014h,16
					db 16,014h,014h,014h,16
					db 06ah,16,16,16,06ah
canonballHeight dw 5
canonballWidth dw 5
canonball_fileName db 'cnb.bmp',0
;================================
;canonball 1 qualities
canonball1_time db -1
canonball1_initial_y dw 0
canonball1_initial_x dw 0
canonball1_initial_angle db 0
canonball1_x dw 0
canonball1_y dw 0
canonball1_Velocity db 50
;================================
;particalss general qualities
;the array is just some random order of numbers
;the program selects a random place in the array, and then uses 5 * 5 of it as a particale square
part_pictures db 44,106,106,44,40
             db 106,106,106,106,40
             db 44,106,44,39,106
             db 106,106,106,106,106
             db 4,41,4,106,106
             db 39,4,106,106,43
             db 43,44,4,40,43
             db 106,106,106,106,106
             db 39,42,43,42,43
             db 106,106,42,106,42
             db 43,44,106,106,40
             db 40,42,39,40,106
             db 41,44,106,106,41
             db 44,42,106,40,106
             db 106,106,106,106,41
             db 41,42,41,4,106
             db 39,40,44,4,106
             db 44,44,106,44,106
             db 4,40,106,42,106
             db 39,41,42,106,43
             db 4,42,106,106,41
             db 42,39,44,39,44
             db 42,106,106,4,42
             db 106,44,40,106,42
             db 106,39,106,106,40
             db 4,40,40,42,106
             db 106,44,41,40,41
             db 41,4,40,41,106
             db 106,106,40,106,4
             db 106,39,44,44,106
             db 39,106,41,106,43
             db 43,39,43,41,106
             db 106,44,106,4,43
             db 43,106,4,41,106
             db 40,106,43,43,106
             db 106,44,106,43,106
             db 43,40,40,39,39
             db 44,106,4,41,43
             db 106,39,43,4,106
             db 4,43,106,106,40
             db 44,106,106,44,40
;================================
;canonball 1 particals qualities
part1_x dw 0
part1_y dw 0
part1_model dw 0
;================================
;canonball 2 particals qualities
part2_x dw 0
part2_y dw 0
part2_model dw 0
;================================
;canonball 2 qualities
canonball2_time db -1
canonball2_initial_y dw 0
canonball2_initial_x dw 0
canonball2_initial_angle db 0
canonball2_x dw 0
canonball2_y dw 0
canonball2_Velocity db 50
;================================