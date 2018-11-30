extends Node

func _ready():
    pass

func ready(host):
    pass

func enter(host):
    pass

func update(host, delta):
    # idle stuff
    var curve = idle_path.curve
    var target_pos = curve.get_point_position(idle_path_index)
    host.navigate_to_point(target_pos)
    if (host.position - target_pos).length() < 10:
        next_curve_point()
    
    # TODO: check for environment
    
func exit(host):
    pass
