extends Control

@onready var http_request = $HTTPRequest
@onready var rank_list = $RankList

func _ready() -> void:
	# 连接请求完成的信号
	http_request.request_completed.connect(_on_request_completed)
	
	# 发送 GET 请求到你的本地服务器
	var error = http_request.request("http://127.0.0.1:5000/api/rank")
	if error != OK:
		print("请求发送失败！")

func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		print("服务器返回错误，状态码: ", response_code)
		return
		
	# 把拿到的字节流转换成字符串
	var json_string = body.get_string_from_utf8()
	
	# 解析 JSON
	var json = JSON.new()
	var parse_error = json.parse(json_string)
	
	if parse_error == OK:
		var data = json.data # 这是一个数组
		
		# 清空原有的列表（防止重复刷新）
		for child in rank_list.get_children():
			child.queue_free()
			
		# 遍历数据，生成文本
		for i in range(data.size()):
			var player = data[i]
			var label = Label.new()
			label.text = "%d. %s : %d分" % [i + 1, player["name"], player["score"]]
			rank_list.add_child(label)
	else:
		print("JSON 解析失败: ", json.get_error_message())


func _on_go_ui_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/control.tscn")
