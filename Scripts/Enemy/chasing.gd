extends Node

var speed_modifier = 1.3

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func ready(host):
    pass

func enter(host):
    pass

func update(host, delta):
    var target_pos = get_tree().get_root().get_node('Level1/Player').position
    host.navigate_to_point(target_pos)
    if host.length_to_point(target_pos) > 500:
        host.get_node('States/searching').target_pos = target_pos
        return 'searching'

func exit(host):
    pass
