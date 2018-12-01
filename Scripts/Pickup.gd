extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var throwImpulse = 500

func _ready():
	self.set_max_contacts_reported(1)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_PickupArea_body_entered(body):
	if body.has_method('pick_up'):
		body.pick_up(self)

func set_collision(active):
	self.set_collision_mask_bit(0, active)
	self.set_collision_layer_bit(2, active)

func picked_up_by(player):
	print('picked up')
	$PickupArea.set_monitoring(false)
	set_collision(false)
	self.set_linear_velocity(Vector2(0,0))
	self.set_angular_velocity(0)
	get_parent().remove_child(self)
	set_position(Vector2(0,0))

func emit_sound():
	for enemy in get_tree().get_nodes_in_group('enemy'):
		enemy._sound_emitted(self.get_global_position(), 'basic')

func create_timer(seconds):
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(seconds)
	self.add_child(timer)
	timer.start()
	return timer

func thrown_by(player, direction):
	$PickupArea.set_monitoring(false)
	self.apply_impulse(to_global(Vector2(0,0)), direction * throwImpulse)
	set_collision(true)
	
	yield(create_timer(1), 'timeout')
	$PickupArea.set_monitoring(true)
	
	yield(create_timer(2), 'timeout')
	emit_sound()

func _on_Pickup_body_entered(body):
	emit_sound()
