extends Area2D
signal hit

export var speed = 400 # Speed the player will move (pixels / sec).
var screen_size # Size of the game window.

# The ready function is called when the node enters the scene tree.
func _ready():
	# this is a good time to get the window size.
	screen_size = get_viewport_rect().size
	hide()

# The process fucntion defines what the player will do and is called evey frame.
func _process(delta):
	# 1) Check for input. 2) Move the player in given direction.
	# 3) Play the appropriate animation.
	var velocity = Vector2() # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0: 
		# keeps velocity constant while moving
		velocity = velocity.normalized() * speed 
		$AnimatedSprite.play() 
		# $ returns node at relative path from current node or returns null
	else:
		$AnimatedSprite.stop()
	# delta is the time it took for the previous frame to complete.
	position += velocity * delta
	# These clamps will prevent the player from leaving the edge of the screen.
	position.x = clamp(position.x, 0, screen_size.x) 
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0: # if the player is moving horizontally
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false # don't flip AnimatedSprite vertically
		$AnimatedSprite.flip_h = velocity.x < 0 # flip h if player is moving right
	elif velocity.y != 0: # if player is moving verically
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide()	 # Player dissapears after being hit.
	emit_signal("hit")	# When an enemy hits the player, the hit signal is emitted
	$CollisionShape2D.set_deferred("disabled", true) # set_deferred waits to act until its safe
	# Collision is disabled so the hit does't trigger more than once.

# The start function is called to reset the player when starting a new game.
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
