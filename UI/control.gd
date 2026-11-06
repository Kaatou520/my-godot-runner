extends Control

@onready var video_container = $AspectRatioContainer
@onready var video_player = $AspectRatioContainer/VideoStreamPlayer
@onready var main_menu = $CenterContainer
@onready var fade_overlay = $FadeOverlay
@onready var skip_button = $SkipButton

func _ready() -> void:
	fade_overlay.modulate.a = 0.0
	
	# 👈 核心判断：如果已经播过了，直接显示主菜单，不播视频
	if GameManager.has_played_video:
		video_container.hide()
		skip_button.hide()
		main_menu.show()
	else:
		# 第一次进来，正常播视频
		main_menu.hide() 
		video_container.show()
		skip_button.show()
		
		video_player.play()
			
		if not video_player.finished.is_connected(_on_video_finished):
			video_player.finished.connect(_on_video_finished)

# 视频自然播放结束时触发
func _on_video_finished() -> void:
	GameManager.has_played_video = true # 👈 标记为已播放
	skip_button.hide() 
	_do_transition_to_menu()

# 点击跳过按钮时触发
func _on_skip_button_pressed() -> void:
	GameManager.has_played_video = true # 👈 标记为已播放
	skip_button.hide() 
	video_player.stop() 
	_do_transition_to_menu() 

# 把转场逻辑抽离出来
func _do_transition_to_menu() -> void:
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 0.5)
	await tween.finished
	
	video_container.hide()
	main_menu.show()
	
	var tween2 = create_tween()
	tween2.tween_property(fade_overlay, "modulate:a", 0.0, 0.5)

# 开始游戏按钮
func _on_button_pressed() -> void:
	print("准备切换场景...")
	# 👈 顺便加一句：重置游戏速度，保证每次开局都是正常速度
	GameManager.current_speed = 1.0 
	get_tree().change_scene_to_file("res://main_node_2d.tscn")

# 排行榜按钮
func _on_go_leaderboard_pressed() -> void:
	AudioManager.stoprainlove()
	get_tree().change_scene_to_file("res://UI/control.tscn")
