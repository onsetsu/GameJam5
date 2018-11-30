extends Node

var idle_path
export var idle_path_time = 4
var idle_path_index = 0

func _ready():
    pass

func ready(host):
    idle_path = host.get_node(host.idle_path_init)

func enter(host):
    pass

func next_curve_point():
    print('next point')
    idle_path_index += 1
    idle_path_index %= idle_path.curve.get_point_count()

func update(host, delta):
    # idle stuff
    var curve = idle_path.curve
    var target_pos = curve.get_point_position(idle_path_index)
    host.navigate_to_point(target_pos)
    if (host.position - target_pos).length() < 10:
        next_curve_point()
    
    # TODO: check for environment
    if host.LEVEL.sound_emitted:
        return 'searching'
    
func exit(host):
    pass
