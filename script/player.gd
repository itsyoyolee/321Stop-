extends Node2D
const GRAVITY_VEC = Vector2(0, 1500)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 1.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 350 # pixels/sec
const JUMP_SPEED = 500
const SIDING_CHANGE_SPEED = 10
var jump_count = 0
var freezeTime = 3
var freezeTimer = 0

var JUMP = false
var LEFT = false
var RIGHT = false
var SELECT = false

var control_type = 0

var ready = false
var player_color = null
var is_last = true
var is_first = false
var state = 0; # 0 = prepare 1 = normal 2 = freeze 3 = game over
var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var on_air = true
var anim
var new_anim = "idle"
var attack = false
var attacktime = 0
var pause = false
var index = 0
var bodyColor = Color(166,20,20)
func _ready():

	jump_count = 0
	#之後改成prepare
	state = 1
	setColor(index)
	pass

func _physics_process(delta):
	if (state == 0):#等待
		waiting()
		setColor(index)
	elif (state == 1):#遊戲中
		controlMatching()
		move(delta)
		anim(delta)
		pauseSkill()
	elif (state == 2):#被麻痺
		freezeColdDown(delta);
		anim(delta)
	elif (state == 3):#被淘汰
		anim(delta)
	elif (state == 5):#選腳色
		controlMatching()
		move(delta)
		anim(delta)
	pass

func move(var delta):

	linear_vel += delta * GRAVITY_VEC
	### 移動 ###
	linear_vel = $body.move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# 在地面
	
	if $body.is_on_floor():
		jump_count = 0
		on_air = false
		on_floor = true
	
	#在牆上
	if $body.is_on_wall():
		if(linear_vel.y < 0):
			linear_vel.y = 0
		linear_vel.y -= delta * 1300
		jump_count = 0
	
	### 操作 ###

	# 水平移動
	var target_speed = 0
	if LEFT:
		target_speed = -1
	if RIGHT:
		target_speed =  1 
	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# 跳躍
	#print(jump_count)
	if JUMP and jump_count < 2:
		on_floor = false
		jump_count += 1
		if($body.is_on_wall()):
			linear_vel.y = -JUMP_SPEED *0.9
			on_air = true
			if(LEFT):
				linear_vel.x = WALK_SPEED*1.2
			elif(RIGHT):
				linear_vel.x -= WALK_SPEED*1.2
			jump_count += 2
		else: 
			linear_vel.y = -JUMP_SPEED
			on_air = true
		#$jump.play()
		new_anim = "jump"
	pass
	
	
func anim(var delta):
	
	#new_anim = "idle"
	if RIGHT:
		$body.get_node("Sprite").scale.x = 1
	elif LEFT:
		$body.get_node("Sprite").scale.x = -1
	else:
		new_anim = "idle"
	if on_floor:
		if RIGHT:
			new_anim = "run"
		elif LEFT:
			new_anim = "run"
		else:
			new_anim = "idle"			

	else:
		if linear_vel.y > 50:
			new_anim = "jump"
			
	if(state == 2):
		new_anim = "freeze"
		$body/effect.show()
	elif(state == 1):
		$body/effect.hide()
	elif(state == 5):
		$body/effect.hide()
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)
func pauseSkill():
	if(is_last&&SELECT):
		get_node("../..").pausePlayer()
	pass
func isMoving():
	if((pow(linear_vel.x,2) + pow(linear_vel.y,2)) < 5000): 
		return false
	else : 
		return true
	pass
func freezeColdDown(delta):
	freezeTimer += delta
	if (freezeTimer > freezeTime):
		state = 1
	pass
func SetFreeze():
	state = 2
	freezeTimer = 0
	pass
func waiting():
	if (ready ): state = 1
	ready = false
	pass
func Start():
	ready = true
	pass
func SetLast(value):
	is_last = value
	pass
func SetFirst(value):
	is_first = value
	pass
func getX():
	return self.global_position.x
	pass
func gameOver():
	state = 0
	print("gameover")
	pass
func setColor(index):
	
	if(index == 0):
		bodyColor =  Color("#854eae")#purple
	elif (index == 1):
		bodyColor =  Color("dcce5d")#yellow
	elif (index == 2):
		bodyColor =  Color("bd3e3e")#red
	elif (index == 3):	
		bodyColor =  Color("74bb57")#green

	$body/Sprite.set_modulate(bodyColor)
	print($body/Sprite.get_modulate())
	pass
func controlMatching():
	JUMP = false
	LEFT = false
	RIGHT = false
	SELECT = false
	if(control_type == 0):
		JUMP = Input.is_action_just_pressed("ui_up")
		LEFT = Input.is_action_pressed("ui_left")
		RIGHT = Input.is_action_pressed("ui_right")
		SELECT = Input.is_action_just_pressed("ui_down")
	elif(control_type == 1):
		JUMP = Input.is_action_just_pressed("w")
		LEFT = Input.is_action_pressed("a")
		RIGHT = Input.is_action_pressed("d")
		SELECT = Input.is_action_just_pressed("s")
	elif(control_type == 2):
		JUMP = Input.is_action_just_pressed("joyJump1")
		LEFT = Input.is_action_pressed("joyLeft1")
		RIGHT = Input.is_action_pressed("joyRight1")
		SELECT = Input.is_action_just_pressed("joySelect1")
	elif(control_type == 3):
		JUMP = Input.is_action_just_pressed("joyJump2")
		LEFT = Input.is_action_pressed("joyLeft2")
		RIGHT = Input.is_action_pressed("joyRight2")
		SELECT = Input.is_action_just_pressed("joySelect2")
	pass
