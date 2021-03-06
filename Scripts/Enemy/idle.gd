extends Node

var speed_modifier = 0.8

var idle_path = null
export var idle_path_time = 4
var idle_path_index = 0

func _ready():
    pass

func ready(host):
    if host.idle_path_init != null:
        idle_path = host.get_node(host.idle_path_init)

func enter(host):
    pass

func next_curve_point():
    print('next point')
    idle_path_index += 1
    idle_path_index %= idle_path.curve.get_point_count()

func update(host, delta):
    # idle stuff
    if idle_path != null:
        var curve = idle_path.curve
        var target_pos = curve.get_point_position(idle_path_index)
        host.navigate_to_point(target_pos)
        if (host.position - target_pos).length() < 10:
            next_curve_point()

func exit(host):
    pass
