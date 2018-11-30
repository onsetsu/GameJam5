extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var throwImpulse = 100

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	print(self.is_contact_monitor_enabled())

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
	self.set_linear_velocity(Vector2(0,0))
	self.set_angular_velocity(0)
	get_parent().remove_child(self)
	set_position(Vector2(0,0))
	
func thrown_by(player, direction):
	$PickupArea.set_monitoring(false)
	self.apply_impulse(to_global(Vector2(0,0)), direction * throwImpulse)