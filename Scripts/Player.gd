extends KinematicBody2D

# class member variables go here, for example:
var velocity = Vector2(0, 0);
var speed = 20;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func processInput(delta):
	direction = Vector2(0,0)
	
	if Input.is_action_pressed('move_down'):
		direction.y -= 1
	if Input.is_action_pressed('move_up'):
		direction.y += 1
	
	if Input.is_action_pressed('move_right'):
		direction.x += 1
	if Input.is_action_pressed('move_left'):
		direction.x -= 1
		
	velocity += direction.normalized() * delta * speed

func _physics_process(delta):
	processInput(delta)
	velocity = self.move_and_slide(velocity)