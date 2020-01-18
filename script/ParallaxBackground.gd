extends ParallaxBackground

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var gb0 = load("res://image/background/green/G_background_0.png")
var gb2 = load("res://image/background/green/G_background_2.png")
var pb0 = load("res://image/background/purple/P_background_0.png")
var pb2 = load("res://image/background/purple/P_background_2.png")
var rb0 = load("res://image/background/red/R_background_0.png")
var rb2 = load("res://image/background/red/R_background_2.png")
var yb0 = load("res://image/background/yellow/Y_background_0.png")
var yb2 = load("res://image/background/yellow/Y_background_2.png")
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
func changeColor(color):
	if(color == 0):
		$ParallaxLayer/Sprite.set_texture(pb0)
		$ParallaxLayer3/Sprite3.set_texture(pb2)
	elif(color == 1):
		$ParallaxLayer/Sprite.set_texture(yb0)
		$ParallaxLayer3/Sprite3.set_texture(yb2)
	elif(color == 2):
		$ParallaxLayer/Sprite.set_texture(rb0)
		$ParallaxLayer3/Sprite3.set_texture(rb2)
	elif(color == 3):
		$ParallaxLayer/Sprite.set_texture(gb0)
		$ParallaxLayer3/Sprite3.set_texture(gb2)
	pass
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
