extends KinematicBody2D

# class member variables go here, for example:
var velocity = Vector2(0, 0);
var speed = 200;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group('player')

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func process_movement_input(delta):
	var direction = Vector2(0,0)
	
	if Input.is_action_pressed('move_down'):
		direction.y += 1
	if Input.is_action_pressed('move_up'):
		direction.y -= 1
	
	if Input.is_action_pressed('move_right'):
		direction.x += 1
	if Input.is_action_pressed('move_left'):
		direction.x -= 1
	
	velocity = direction.normalized() * speed
	
func process_action_input():
	if Input.is_action_just_pressed('throw_pickup'):
		throw_pickup()
	
func process_input(delta):
	process_movement_input(delta)
	process_action_input()
	
func rotate_toward_mouse():
	var mousePos = self.get_global_mouse_position()
	var transform = self.get_transform()
	self.look_at(mousePos)
	


func _physics_process(delta):
	process_input(delta)
	rotate_toward_mouse()
	velocity = self.move_and_slide(velocity)

func has_pickup():
	return $GrabbingHand.get_child_count() > 0


func pick_up(pickup):
	if !has_pickup():
		pickup.picked_up_by(self)
		$GrabbingHand.add_child(pickup)

func get_pickup():
	return $GrabbingHand.get_child(0)
	
func throw_pickup():
	if has_pickup():
		var pickup = get_pickup()
		var pickupPosition = pickup.get_global_position()
		$GrabbingHand.remove_child(pickup)
		get_parent().add_child(pickup)
		pickup.set_global_position(pickupPosition)
		
		pickup.thrown_by(self, (self.get_global_mouse_position() - pickup.get_global_position()).normalized())