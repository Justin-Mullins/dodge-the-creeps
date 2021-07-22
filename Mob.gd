extends RigidBody2D

export var min_speed = 150 # Mix speed range
export var max_speed = 250 # Max speed range

# Called when the node enters the scene tree for the first time
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	# This chooses a random animation for each enemy.


func _on_VisibilityNotifier2D_screen_exited(): # When enemies exit the screen
	queue_free()	# They will delete themeselves