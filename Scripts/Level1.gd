extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var counter = 0
var sound_emitted = false

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func _process(delta):
    counter += delta
    if !sound_emitted && counter > 2:
        sound_emitted = true
        for enemy in get_tree().get_nodes_in_group('enemy'):
            enemy._sound_emitted($Player, 'basic')
