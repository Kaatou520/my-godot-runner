extends Node2D

@export var obstacle_scene: PackedScene 
# 🌟 默认坐标改成 X = 1270, Y = 450
@export var spawn_position: Vector2 = Vector2(1270, 500) 
@export var obstacle_scale: float = 1.0 

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	if obstacle_scene == null:
		return
		
	# 实例化障碍物
	var new_obstacle = obstacle_scene.instantiate()
	
	# 使用指定的固定坐标
	new_obstacle.position = spawn_position
	
	# 缩放
	new_obstacle.scale = Vector2(obstacle_scale, obstacle_scale)
	
	# 添加到场景
	add_child(new_obstacle)
	
	# 调整下次生成时间（随全局速度变快）
	timer.wait_time = randf_range(1, 5) / GameManager.current_speed
