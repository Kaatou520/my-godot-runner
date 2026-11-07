extends Area2D

@export var base_speed: float = 400.0 

@export_group("Jelly Squash Effect")
@export var squash_speed: float = 10.0      # 挤压频率
@export var squash_amount: float = 0.3      # 左右挤压幅度
@export var height_grow_amount: float = 1.5 # 高度增加倍数

@onready var sprite: Sprite2D = $Sprite2D
var time_passed: float = 0.0
var base_height: float = 1.0 
var base_width: float = 1.0  

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	time_passed = randf() * 10.0 
	
	# 记录初始缩放
	base_height = sprite.scale.y
	base_width = sprite.scale.x

func _process(delta: float) -> void:
	# 1. 向左移动
	position.x -= base_speed * GameManager.current_speed * delta
	
	# 2. 计算形变波形
	time_passed += delta
	var t = 0.0
	
	# 只有全局开关开启了，才播放动画
	if GameManager.enable_obstacle_anim:
		t = (sin(time_passed * squash_speed) + 1.0) / 2.0
	
	# 3. X轴：两侧向中间挤压
	sprite.scale.x = base_width * (1.0 - (squash_amount * t))
	
	# 4. Y轴：高度增加
	sprite.scale.y = base_height * (1.0 + (height_grow_amount * t))
	
	if position.x < -100:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		# 核心逻辑：撞到第一个障碍物
		if not GameManager.enable_obstacle_anim:
			GameManager.enable_obstacle_anim = true
			print("撞上第一个障碍物！后续障碍物开始 Q 弹！")
			
		print("游戏结束！")
		
		# 👈 用这行代码呼叫主场景的 die() 函数！
		get_tree().current_scene.die()
