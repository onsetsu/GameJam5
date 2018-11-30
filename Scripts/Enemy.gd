extends KinematicBody2D

onready var nav_map = get_tree().get_root().get_node('Level1/nav_map')

var current_state = null
onready var states_map = {
    'idle': $States/States/idle,
    'chasing': $States/chasing,
    'searching': $States/searching
}

export(NodePath) var idle_path_init = null
export var speed = 50
var idle_path
export var idle_path_time = 4
var idle_path_index = 0

func _ready():
    current_state = $States/idle
    $States/idle.ready(self)
    $States/chasing.ready(self)
    $States/searching.ready(self)

func navigate_to_point(p):
    var path = nav_map.get_simple_path(position, p)
    move_and_slide((path[1] - position).normalized() * speed)

func _physics_process(delta):
    # state machine
    var state_name = current_state.update(self, delta)
    if state_name:
        _change_state(state_name)

func _change_state(state_name):
    current_state.exit(self)
    current_state = states_map[state_name]
    current_state.enter(self)
