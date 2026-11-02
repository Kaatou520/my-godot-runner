extends Parallax2D
## 挂在 Parallax2D 节点上，负责自动滚动 + 跟随 GameManager 全局倍率
## 地面和背景可以共用这一个脚本，各自在检查器里设置不同的 base_autoscroll_speed

# 基础滚动速度（像素/秒），x 为负表示向左
# 地面建议 -30 ~ -60，背景建议 -10 ~ -15，保持视差比例
@export var base_autoscroll_speed: Vector2 = Vector2(-30, 0)

# 游戏未开始时是否停止滚动（主菜单时地面不动）
@export var stop_when_game_not_running: bool = true

func _ready() -> void:
	_update_autoscroll()

func _process(_delta: float) -> void:
	_update_autoscroll()

func _update_autoscroll() -> void:
	if stop_when_game_not_running and not GameManager.is_game_running:
		autoscroll = Vector2.ZERO
		return

	autoscroll = base_autoscroll_speed * GameManager.current_speed
