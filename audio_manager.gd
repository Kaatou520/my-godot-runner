extends Node

@onready var bgm_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var bgm_rainlove: AudioStreamPlayer = $rainlove 

func _ready() -> void:
	# ❌ 删掉或注释掉这行，启动时不播
	# bgm_player.play() 
	bgm_rainlove.play()

# 切换音乐开关（保持不变）
func toggle_music() -> bool:
	if bgm_player.playing:
		bgm_player.stop()
		return false 
	else:
		bgm_player.play()
		return true 

# 新增一个直接开始播放的方法
func play_music() -> void:
	bgm_rainlove.stop()
	if not bgm_player.playing:
		bgm_player.play()

# 获取状态（保持不变）
func is_music_playing() -> bool:
	return bgm_player.playing
