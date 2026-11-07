extends Control

@onready var final_score_label = $ColorRect/VBoxContainer/FinalScoreLabel
@onready var name_input = $ColorRect/VBoxContainer/NameInput
@onready var submit_button = $ColorRect/VBoxContainer/SubmitButton

var final_score: int = 0

func show_game_over(score: int) -> void:
	final_score = score
	final_score_label.text = "最终得分: " + str(final_score)
	show()

func _on_submit_button_pressed() -> void:
	var player_name = name_input.text.strip_edges()
	if player_name == "":
		player_name = "无名氏"
		
	submit_button.disabled = true
	submit_button.text = "提交中..."
	
	# 发送 POST 请求
	var http = HTTPRequest.new()
	# 👈 核心修复：给 HTTP 节点加上“免疫暂停”的特权！
	http.process_mode = Node.PROCESS_MODE_ALWAYS 
	add_child(http)
	http.request_completed.connect(_on_submit_completed)
	
	var json_data = {"name": player_name, "score": final_score}
	var headers = ["Content-Type: application/json"]
	var url = "http://127.0.0.1:5000/api/submit"
	
	var json_string = JSON.stringify(json_data)
	print("准备发送的数据: ", json_string) # 👈 调试打印
	
	# 👈 接收发送结果，如果发不出去会打印错误
	var error = http.request(url, headers, HTTPClient.METHOD_POST, json_string)
	if error != OK:
		print("❌ 请求发送失败，错误码: ", error)
		submit_button.disabled = false
		submit_button.text = "发送失败，重试"

func _on_submit_completed(_result, response_code, _headers, _body):
	print("收到服务器响应，状态码: ", response_code) # 👈 调试打印
	
	if response_code == 200:
		print("✅ 提交成功！前往排行榜...")
		get_tree().paused = false 
		get_tree().change_scene_to_file("res://data/control.tscn")
	else:
		print("❌ 提交失败，服务器返回: ", response_code)
		submit_button.disabled = false
		submit_button.text = "重试"
