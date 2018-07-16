extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var type = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	intMap()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
	pass
func setType(newtype):
	type = newtype
	pass
