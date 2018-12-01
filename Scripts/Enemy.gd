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
    var direction = (path[1] - position).normalized()
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

func _sound_emitted(pos, type):
    if (position - pos).length() > 500: return
    print(length_to_point(pos))
    $States/searching.target_pos = pos
    _change_state('searching')

func _on_range_area_body_entered(body):
    if body.is_in_group('player'):
        get_tree().reload_current_scene()
        print('YOU DIED')
