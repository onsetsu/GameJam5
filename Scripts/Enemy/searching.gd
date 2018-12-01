extends Node

var speed_modifier = 1.0

var target_pos = Vector2(0,0)

func _ready():
    pass

func ready(host):
    pass

func enter(host):
    pass

func update(host, delta):
    host.navigate_to_point(target_pos)
    
    # TODO: check for environment
    if (target_pos - host.position).length() < 40:
        return 'waiting'
    
    #nav_map.get_simple_path(position, p)
    
func exit(host):
    pass
