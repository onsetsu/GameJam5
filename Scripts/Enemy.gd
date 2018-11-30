extends KinematicBody2D

onready var nav_map = get_tree().get_root().get_node('Level1/nav_map')

var current_state = null
onready var states_map = {
    'idle': $States/States/idle,
    'chasing': $States/chasing
}

export var idle_path = 5

func _ready():
    current_state = $States/idle

func _physics_process(delta):
    var state_name = current_state.update(self, delta)
    if state_name:
        _change_state(state_name)

func _change_state(state_name):
    current_state.exit(self)
    current_state = states_map[state_name]
    current_state.enter(self)
