extends Node2D

const cdTime = 3
var cdTimer = 0
var state = 0 # 0 = intgame; 1 = prepare; 2 =  game; 2 = result
var player = []
var last_index = 0
var first_index = 0
var last_pos = 0
var first_pos = 0
export var player_count = 4
var maptypes = 11
var next_mapX = 200
var total_pos = Vector2(0,0)
var eye =false
var pauseTimer = 0
var PAUSE_TIME = 3.5
var count1 = load("res://image/1-sheet.png")
var count2 = load("res://image/2-sheet.png")
var count3 = load("res://image/3-sheet.png")
var count_stop = load("res://image/stop-sheet.png")
var eyeSprite = [
		load("res://image/purple_eye_op_00-sheet.png"),	
		load("res://image/yellow_eye_op_00-sheet.png"),
		load("res://image/red_eye_op_00-sheet.png"),
		load("res://image/green_eye_op_00-sheet.png"),
	] 
var eye_anim = "close"
var new_anim = "idle"
var deadPlayer = 0
var winSprite = load("res://win.png")
var isOver = false
var overTimer = 0
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if (isOver):
		overTimer += delta
		if (overTimer >= 3):
			get_tree().change_scene("res://scene/menu.tscn")
	else:
		state(delta)
	pass
func state(delta):
	if(state == 0):#int game
		spawnMap()
		spawnPlayer()
		state = 1
	if(state == 1):#prepare
		countDown(delta)
	if(state == 2):#in game
		checkLast()
		spawnNewMap()
		deleteMap()
		setCameraPos()
		eyeCountDown(delta)
		
	pass
func spawnPlayer():
	for i in range(player_count):
		player.insert(i,load("res://scene/player.tscn").instance())
		player[i].position = Vector2(80,-500)
		player[i].index = i
		player[i].control_type = i
		$player.add_child(player[i])
	pass
func countDown(delta):
	cdTimer += delta
	if(cdTimer >= cdTimer):
		state = 2
	pass
func pausePlayer():
	pauseTimer = 0
	eye = true
	pass
func changeEye(index):
	$ParallaxBackground/ParallaxLayer/eye.texture = eyeSprite[index]
	pass
func eyeAnim():
	if eye_anim != new_anim:
		eye_anim = new_anim
		$eyeAnim.play(eye_anim)
	pass
func eyeCountDown(delta):
	pauseTimer += delta
	if (pauseTimer < 1 and eye):
		$Camera2D/timer.show()
		$Camera2D/timer.texture = count3
	elif(pauseTimer < 2 and eye):
		new_anim = "open"
		eyeAnim()
		$Camera2D/timer.texture = count2
	elif(pauseTimer < 3 and eye):
		new_anim = "shake"
		$Camera2D/timer.texture = count1
		eyeAnim()
	elif(pauseTimer < 4 and eye):
		new_anim = "close"
		$Camera2D/timer.texture = count_stop
		eyeAnim()
	if(pauseTimer >= PAUSE_TIME and eye):	
	
		for i in range(player_count):
			if(player[i].isMoving()):
				player[i].SetFreeze()
		eye = false
		$Camera2D/timer.hide()
	pass
func checkLast():
	last_pos = 99999999
	first_pos = -9999999
	#var pc = $player.get_children().size()
	for i in range(player_count):
		player[i].SetFirst(false)
		player[i].SetLast(false)
		if(player[i].state != 3):
			if(player[i].get_node("body").global_position.x < last_pos):
				last_index = i
				last_pos = player[i].get_node("body").global_position.x
			if(player[i].get_node("body").global_position.x > first_pos):
				first_index = i
				first_pos = player[i].get_node("body").global_position.x
			
	player[last_index].SetLast(true)
	player[first_index].SetFirst(true)
	$ParallaxBackground.changeColor(player[last_index].index)
	changeEye(player[last_index].index)
	pass
func spawnMap():
	
	for i in range(100):
		randomize()
		var maptype = randi() % maptypes
		var map = load("res://scene/map" + String(maptype) + ".tscn").instance()
		$scene.add_child(map)
		map.global_position.x = next_mapX
		var yoff = randi() % 200 + 100
		map.global_position.y = yoff
		next_mapX += map.get_node("body/Sprite").texture.get_size().x - 30
	pass
func spawnNewMap():
	pass
func deleteMap():
	pass
func setCameraPos():
	total_pos = Vector2(0,0)
	if(player_count != 1):
		for i in range(player_count):
			if(player[i].is_first):
				$Camera2D.position.x = player[i].get_node("body").global_position.x
	else:
		var only_player = player[0].get_node("body")
		$Camera2D.position.x = only_player.global_position.x	
	pass
func _on_Area2D_body_entered(body):
	if(body.is_in_group("player")):
		print("body enter")
		var index = body.get_parent().index
		player[index].get_node("body").hide()
		player[index].state = 3
		deadPlayer += 1
		if (deadPlayer== 3):
			gameOver()
	pass
func gameOver():
	print("game over")
	$Camera2D/win.show()
	isOver = true
	pass
