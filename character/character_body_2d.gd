extends CharacterBody2D

@export_group("Movement")
@export var gravity: float = 3500.0
@export var jump_velocity: float = -1300.0
@export var double_jump_velocity: float = -353.0 
@export var double_jump_delay: float = 0.05 
@export var fast_fall_gravity: float = 20000.0 

# 引用两个精灵节点
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anna_beat: AnimatedSprite2D = $anna_beat

var can_double_jump := false 
var jump_timer := 0.0        
var is_fast_falling := false 
var is_attacking := false 

func _ready() -> void:
	anna_beat.hide()
	anna_beat.animation_finished.connect(_on_anna_beat_animation_finished)

func _physics_process(delta: float) -> void:
	animated_sprite.speed_scale = GameManager.current_speed
	anna_beat.speed_scale = GameManager.current_speed

	# 攻击输入检测
	if Input.is_action_just_pressed("attack"):
		play_attack()

	# ===== 以下是你原本的物理逻辑 =====
	if Input.is_action_pressed("roll") and not is_on_floor():
		is_fast_falling = true
	else:
		is_fast_falling = false

	if is_on_floor():
		is_fast_falling = false

	if not is_on_floor():
		var current_gravity = fast_fall_gravity if is_fast_falling else gravity
		velocity.y += current_gravity * delta

	if jump_timer > 0.0:
		jump_timer -= delta

	# 🌟 跳跃逻辑
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			can_double_jump = true       
			jump_timer = double_jump_delay 
		elif can_double_jump and jump_timer <= 0.0:
			velocity.y = double_jump_velocity
			can_double_jump = false      
			
		# 🌟 新增：如果按下跳跃时正在攻击，立刻打断攻击切回 run
		if is_attacking:
			end_attack()

	if is_on_floor() and velocity.y >= 0:
		can_double_jump = false
		jump_timer = 0.0

	velocity.x = 0
	animated_sprite.flip_h = true
	anna_beat.flip_h = true 

	# 只要没在攻击，就播放 run
	if not is_attacking:
		if animated_sprite.animation != "run":
			animated_sprite.play("run")

	move_and_slide()

# 触发攻击
func play_attack() -> void:
	is_attacking = true
	animated_sprite.stop()  
	animated_sprite.hide()
	anna_beat.show()
	
	anna_beat.stop() 
	anna_beat.play("beat")

# 🌟 提取出来的结束攻击函数（供动画播完和跳跃打断共用）
func end_attack() -> void:
	if not is_attacking:
		return # 防止重复执行
		
	is_attacking = false
	anna_beat.stop()        
	anna_beat.hide()        
	animated_sprite.show()  
	animated_sprite.play("run") 

# 攻击动画自然播放完毕的回调
func _on_anna_beat_animation_finished() -> void:
	end_attack()
