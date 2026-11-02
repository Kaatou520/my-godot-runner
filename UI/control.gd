extends Control

@onready var video_container = $AspectRatioContainer
@onready var video_player = $AspectRatioContainer/VideoStreamPlayer
@onready var main_menu = $CenterContainer
@onready var fade_overlay = $FadeOverlay

func _ready() -> void:
	# 1. 初始化状态：遮罩透明，主菜单隐藏，开始播放视频
	fade_overlay.modulate.a = 0.0
	main_menu.hide() 
	
	if not video_player.autoplay:
		video_player.play()
		
	video_player.finished.connect(_on_video_finished)

func _on_video_finished() -> void:
	# 2. 视频播完后，开始黑屏过渡
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 0.5)
	await tween.finished
	
	# 3. 完全黑屏后，隐藏视频，显示主菜单
	video_container.hide()
	main_menu.show()
	
	# 4. 再让黑屏遮罩淡出，露出主菜单
	var tween2 = create_tween()
	tween2.tween_property(fade_overlay, "modulate:a", 0.0, 0.5)


func _on_button_pressed() -> void:
	print("按钮确实被点击了！准备切换场景...")
	
	# 注意这里：把多余的 .tscn 删掉了
	var next_scene = "res://main_node_2d.tscn" 
	get_tree().change_scene_to_file(next_scene)
