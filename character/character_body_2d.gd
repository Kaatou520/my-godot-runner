extends CharacterBody2D

@export_group("Movement")
@export var gravity: float = 3500.0
@export var jump_velocity: float = -1300.0
@export var double_jump_velocity: float = -353.0 
@export var double_jump_delay: float = 0.05 
@export var fast_fall_gravity: float = 20000.0 

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var can_double_jump := false 
var jump_timer := 0.0        
var is_fast_falling := false 

func _physics_process(delta: float) -> void:
	animated_sprite.speed_scale = GameManager.current_speed

	# 🌟 1. 核心修改：检测 "fast_fall" 动作！
	# 不管是按键盘 S，还是点屏幕按钮，都会触发这个动作
	if Input.is_action_pressed("roll") and not is_on_floor():
		is_fast_falling = true
	else:
		is_fast_falling = false

	# 如果已经落地，立即重置
	if is_on_floor():
		is_fast_falling = false

	# 2. 重力
	if not is_on_floor():
		var current_gravity = fast_fall_gravity if is_fast_falling else gravity
		velocity.y += current_gravity * delta

	# 3. 计时器递减
	if jump_timer > 0.0:
		jump_timer -= delta

	# 4. 跳跃逻辑
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			can_double_jump = true       
			jump_timer = double_jump_delay 
		elif can_double_jump and jump_timer <= 0.0:
			velocity.y = double_jump_velocity
			can_double_jump = false      

	# 5. 落地重置二段跳
	if is_on_floor() and velocity.y >= 0:
		can_double_jump = false
		jump_timer = 0.0

	# 6. 原地跑，朝左
	velocity.x = 0
	animated_sprite.flip_h = true

	# 7. 动画控制
	if is_on_floor():
		if animated_sprite.animation != "run":
			animated_sprite.play("run")

	move_and_slide()
