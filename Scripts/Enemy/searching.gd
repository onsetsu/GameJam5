extends Node

var target_pos = Vector2(0,0)

func _ready():
    pass

func ready(host):
    pass

func enter(host):
    target_pos = host.LEVEL.get_node('Player').position

func update(host, delta):
    host.navigate_to_point(target_pos)
    
    # TODO: check for environment
    if (target_pos - host.position).length() < 20:
        return 'idle'
    
func exit(host):
    pass
