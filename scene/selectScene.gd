extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = []
var player_count = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(player_count):
		player.insert(i,load("res://scene/player.tscn").instance())
		var pos = $players.get_child(i).get_position()
#		Vector2 pos = p.get_position()
		player[i].position = Vector2(pos.x, pos.y)
		player[i].index = i
		player[i].control_type = i
	
		$player.add_child(player[i])
		player[i].state = 5

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 如果人數按鈕有變動時 要重新產生玩家和相對應控制圖片
	# 如果按下開始時把玩家人數記下來告訴遊戲
	pass
