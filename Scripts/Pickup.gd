extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var throwImpulse = 500

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_PickupArea_body_entered(body):
	if body.has_method('pick_up'):
		body.pick_up(self)
		
func picked_up_by(player):
	print('picked up')
	$PickupArea.set_monitoring(false)
	print(self.get_collision_layer_bit(2))
	self.set_collision_layer_bit(2, false)
	self.set_linear_velocity(Vector2(0,0))
	self.set_angular_velocity(0)
	get_parent().remove_child(self)
	set_position(Vector2(0,0))

func emit_sound():
	for enemy in get_tree().get_nodes_in_group('enemy'):
		enemy._sound_emitted(self.get_global_position(), 'basic')

func thrown_by(player, direction):
	$PickupArea.set_monitoring(false)
	self.apply_impulse(to_global(Vector2(0,0)), direction * throwImpulse)
	
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	
	$PickupArea.set_monitoring(true)
	emit_sound()