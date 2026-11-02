extends Node2D

func _ready() -> void:
	# 游戏场景一旦加载，就说明玩家点了“开始游戏”
	print("Game.tscn 加载成功，游戏正式开始！")
	
	# 1. 🌟 重点：告诉全局管理器，游戏开始了，开始加速！
	# 如果你加了我上一条给你的 reset_game() 方法，就直接用 GameManager.reset_game()
	# 如果没有加，就写下面这两行：
	GameManager.is_game_running = true
	GameManager.current_speed = 1.0 
	GameManager.enable_obstacle_anim = false
	
	# 2. 播放背景音乐
	AudioManager.play_music()
	
	
	# 3. 🌟 如果障碍物生成器搭好了，把这里的注释取消掉！
	# $ObstacleSpawnTimer.start()
	#障碍物开始q弹
	GameManager.enable_obstacle_anim = true
