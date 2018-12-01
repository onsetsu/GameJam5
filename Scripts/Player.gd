extends KinematicBody2D

# class member variables go here, for example:
var velocity = Vector2(0, 0);
var speed = 300;
var maxSpeed = 200
var stepTime = 0.5
var stepTimer = 0.5
var stepVelocity = 1

var stepSounds = [preload('res://Ressources/Sound/sfx_step_grass_r.wav'), preload('res://Ressources/Sound/sfx_step_grass_l.wav')]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group('player')

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func process_flashlight(delta):
	$camera.set_position(Vector2(300, 0) if $Flashlight.is_activated() else Vector2(0,0))

func is_moving():
	return velocity.length() > stepVelocity


func process_movement_animations():
	if is_moving():
		if !$Sprite/AnimationPlayer.is_playing():
			$Sprite/AnimationPlayer.play('Walking')
	else:
		$Sprite/AnimationPlayer.stop(false)

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
	
	velocity += direction.normalized() * acceleration(delta)
	velocity = velocity.clamped(maxSpeed)
	if direction.length() == 0:
		process_dampening(delta)
		
	process_movement_animations()
	
func process_action_input():
	if Input.is_action_just_pressed('throw_pickup'):
		throw_pickup()
	
func process_input(delta):
	process_movement_input(delta)
	process_action_input()
	
func acceleration(delta):
	return speed * delta * 5

func process_dampening(delta):
	velocity *= 0.8

func rotate_toward_mouse():
	var mousePos = self.get_global_mouse_position()
	var transform = self.get_transform()
	self.look_at(mousePos)

func emit_sound(type):
	for enemy in get_tree().get_nodes_in_group('enemy'):
		enemy._sound_emitted(self.get_global_position(), type)


func emit_step_sounds(delta):
	stepTimer -= delta
	if is_moving() && stepTimer <= 0:
		emit_sound('step')
		$StepSoundPlayer.set_stream(stepSounds[randi() % stepSounds.size()])
		$StepSoundPlayer.play(0)
		stepTimer = stepTime

func _physics_process(delta):
	process_input(delta)
	rotate_toward_mouse()
	process_flashlight(delta)
	emit_step_sounds(delta)
	velocity = self.move_and_slide(velocity)





#----------------- Pickup handling -------------------
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