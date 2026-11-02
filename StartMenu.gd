extends Control

@onready var start_button: Button = $CenterContainer/VBoxContainer/Button

func _ready() -> void:
	# 连接按钮的点击事件
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	# 🌟 打开全局加速开关，并重置所有状态！
	GameManager.is_game_running = true
	GameManager.current_speed = 1.0
	GameManager.enable_obstacle_anim = false # 重置障碍物动画开关
	
	# 切换到游戏场景（只切换一次就够了）
	get_tree().change_scene_to_file("res://main_node_2d.tscn")
