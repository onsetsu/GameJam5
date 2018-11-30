extends Navigation2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var path = []
var touchPos = Vector2(0,0)
onready var enemy = get_tree().get_root().get_node('Level1/Enemy')
onready var enemy2 = get_tree().get_root().get_node('Level1/Enemy2')
onready var player = get_tree().get_root().get_node('Level1/Player')

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    print(enemy)

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _draw():
    print('DRAW')
    path = get_simple_path(enemy.position, player.position)
    if(path.size()):
        for f in range(path.size()):
            draw_circle(path[f], 10, Color(1,1,1))

func _input(event):
    pass