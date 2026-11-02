extends Sprite2D

# 基础滚动速度（你可以在右侧面板调整这个基础值）
@export var base_scroll_speed: float = 20.0 

func _process(delta: float) -> void:
	# 🌟 核心逻辑：当前实际速度 = 基础速度 × 全局速度倍率
	var current_scroll_speed = base_scroll_speed * GameManager.current_speed
	
	# 让 UV 偏移持续向左（或向右）滚动
	region_rect.position.x += current_scroll_speed * delta
