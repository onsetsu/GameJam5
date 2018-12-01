extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var throwImpulse = 1000
var shouldEmitBasicSound = false

func _ready():
	self.set_max_contacts_reported(1)

func _process(delta):
	pass
	#var minScale = 0.4
	#var maxScale = 0.6
	#var scale = clamp((get_linear_velocity().length() / 1000) + minScale, minScale, maxScale)
	#$Sprite.set_scale(Vector2(scale,scale))


func _on_PickupArea_body_entered(body):
	if body.has_method('pick_up'):
		body.pick_up(self)

func _physics_process(delta):
	if get_linear_velocity().abs().length() <= 15:
		if shouldEmitBasicSound:
			emit_sound('basic')
			shouldEmitBasicSound = false

func set_collision(active):
	self.set_collision_mask_bit(0, active)
	self.set_collision_layer_bit(2, active)

func picked_up_by(player):
	$PickupArea.set_monitoring(false)
	set_collision(false)
	self.set_linear_velocity(Vector2(0,0))
	self.set_angular_velocity(0)
	get_parent().remove_child(self)
	set_position(Vector2(0,0))

func emit_sound(type):
	for enemy in get_tree().get_nodes_in_group('enemy'):
		enemy._sound_emitted(self.get_global_position(), type)

func create_timer(seconds):
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(seconds)
	self.add_child(timer)
	timer.start()
	return timer

func thrown_by(player, direction):
	shouldEmitBasicSound = true
	$PickupArea.set_monitoring(false)
	self.apply_impulse(to_global(Vector2(0,0)), direction * throwImpulse)
	set_collision(true)
	
	yield(create_timer(1), 'timeout')
	$PickupArea.set_monitoring(true)

func _on_Pickup_body_entered(body):
	$BumpSoundPlayer.play()
	emit_sound('bump')
