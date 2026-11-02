extends Node
#障碍物动画效果开关
var enable_obstacle_anim: bool = false
# 当前全局速度倍率（所有东西的基础速度）
var current_speed: float = 1.0
# 最大速度上限（防止游戏变成闪电侠）
@export var max_speed: float = 5.0 
# 每秒增加多少倍率
@export var speed_acceleration: float = 0.05 

# 游戏是否正在运行（用来控制主菜单不加速）
var is_game_running: bool = false

func _process(delta: float) -> void:
	# 只有在游戏运行中，且没达到最大速度时，才增加
	if is_game_running and current_speed < max_speed:
		current_speed += speed_acceleration * delta
