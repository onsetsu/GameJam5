extends Node

var speed_modifier = 0

var time_to_normalize = 1
var current_time = 0

func _ready():
    pass

func ready(host):
    pass

func enter(host):
    current_time = 0

func update(host, delta):
    current_time += delta
    
    # TODO: check for environment
    if current_time > time_to_normalize:
        return 'idle'
    
func exit(host):
    pass
