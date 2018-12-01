extends KinematicBody2D

onready var LEVEL = get_tree().get_root().get_node('Level1')
onready var nav_map = get_tree().get_root().get_node('Level1/nav_map')

var current_state = null
onready var states_map = {
    'idle': $States/idle,
    'chasing': $States/chasing,
    'searching': $States/searching,
    'waiting': $States/waiting
}
var direction = Vector2(1,0)

export(NodePath) var idle_path_init = null
export var speed = 70

func _ready():
    add_to_group('enemy')
    current_state = $States/idle
    $States/idle.ready(self)
    $States/chasing.ready(self)
    $States/searching.ready(self)
    $States/waiting.ready(self)

func navigate_to_point(p):
    var path = nav_map.get_simple_path(position, p)
    direction = (path[1] - position).normalized()
    $rotation.rotation = direction.angle()
    move_and_slide(direction * speed * current_state.speed_modifier)

func length_to_point(p):
    var path = nav_map.get_simple_path(position, p)
    var length = 0
    var current_point = path[0]
    for i in range(path.size()):
        length += (path[i] - current_point).length()
        current_point = path[i]
    return length
    
func _physics_process(delta):
    # state machine
    
    
    var state_name = current_state.update(self, delta)
    if state_name:
        _change_state(state_name)

func _change_state(state_name):
    current_state.exit(self)
    current_state = states_map[state_name]
    current_state.enter(self)

func is_pickup_type(type):
    return type == 'bump' || type == 'basic'

func _sound_emitted(pos, type):
	
	if current_state == $States/chasing: return
	if is_pickup_type(type) && (position - pos).length() > 500: return
	if type == 'step' && (position - (pos + (-direction * 70))).length() > 140: return
	
	$States/searching.target_pos = pos
	if type == 'step':
		$ChasingSoundPlayer.play()
		_change_state('chasing')
	else: if is_pickup_type(type):
		_change_state('searching')

func _on_range_area_body_entered(body):
	if body.is_in_group('player'):
		get_tree().reload_current_scene()
		print('YOU DIED')
