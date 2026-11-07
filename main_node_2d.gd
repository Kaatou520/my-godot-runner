extends Node2D

# 👈 新增：计分和状态变量
var current_score: float = 0.0
var is_dead: bool = false

# 👈 新增：获取 UI 节点（请务必确认你的节点名字和路径是对得上的！）
# 假设你的分数 Label 叫 ScoreLabel，死亡弹窗叫 GameOverUI，且都在 UILayer_die 下面
@onready var score_label = $UILayer_die/ScoreLabel 
@onready var game_over_ui = $UILayer_die/GameOverUI

func _ready() -> void:
	print("Game.tscn 加载成功，游戏正式开始！")
	
	GameManager.is_game_running = true
	GameManager.current_speed = 1.0 
	GameManager.enable_obstacle_anim = false
	
	AudioManager.play_music()
	
	# 初始化游戏状态
	is_dead = false
	current_score = 0.0
	if score_label:
		score_label.text = "分数: 0"
	
	# 如果障碍物生成器搭好了，把这里的注释取消掉！
	# $ObstacleSpawnTimer.start()
	GameManager.enable_obstacle_anim = true

# 👈 新增：每一帧更新分数
func _process(delta: float) -> void:
	if not is_dead:
		# 分数 = 基础时间分 * 当前速度倍率（跑得越快分越高）
		current_score += delta * 10 * GameManager.current_speed
		if score_label:
			score_label.text = "分数: " + str(int(current_score))

# 👈 新增：统一的死亡触发函数
func die() -> void:
	if is_dead: return
	is_dead = true
	
	GameManager.is_game_running = false
	AudioManager.stopbgm()
	
	# 👈 暂停整个游戏树的物理和逻辑处理
	get_tree().paused = true 
	
	if game_over_ui:
		game_over_ui.show_game_over(int(current_score))

func _on_go_ui_pressed() -> void:
	AudioManager.stopbgm()
	get_tree().change_scene_to_file("res://UI/control.tscn")
