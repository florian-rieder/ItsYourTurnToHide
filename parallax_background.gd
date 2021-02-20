extends ParallaxBackground


export(NodePath) onready var player = get_node(player) as Player
export(NodePath) onready var _background = get_node(_background) as Sprite

func _ready():
	$ParallaxLayer.motion_mirroring = _background.texture.get_size()#.rotated(_background.global_rotation)
	
func _process(_delta):
	var scroll = Vector2(0,3) #Some default scrolling so there's always movement.
	if player != null:
		scroll += player._velocity / 100
	scroll_offset += scroll
