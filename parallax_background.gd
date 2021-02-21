extends ParallaxBackground


export(NodePath) onready var player = get_node(player) as Player

export(NodePath) onready var _mountains_layer = get_node(_mountains_layer) as ParallaxLayer
export(NodePath) onready var _mountains_sprite = get_node(_mountains_sprite) as Sprite
export(Vector2) var _mountains_motion_scale

export(NodePath) onready var _dark_dunes_layer = get_node(_dark_dunes_layer) as ParallaxLayer
export(NodePath) onready var _dark_dunes_sprite = get_node(_dark_dunes_sprite) as Sprite
export(Vector2) var _dark_dunes_motion_scale

export(NodePath) onready var _dunes_layer = get_node(_dunes_layer) as ParallaxLayer
export(NodePath) onready var _dunes_sprite = get_node(_dunes_sprite) as Sprite
export(Vector2) var _dunes_motion_scale

export(NodePath) onready var _dunes_foreground_layer = get_node(_dunes_foreground_layer) as ParallaxLayer
export(NodePath) onready var _dunes_foreground_sprite = get_node(_dunes_foreground_sprite) as Sprite
export(Vector2) var _dunes_foreground_motion_scale

func _ready():
	_mountains_layer.motion_mirroring = _mountains_sprite.texture.get_size()#.rotated(_background.global_rotation)
	_mountains_layer.motion_scale = _mountains_motion_scale
	
	_dark_dunes_layer.motion_mirroring = _dark_dunes_sprite.texture.get_size()#.rotated(_background.global_rotation)
	_dark_dunes_layer.motion_scale = _dark_dunes_motion_scale
	
	_dunes_layer.motion_mirroring = _dunes_sprite.texture.get_size()#.rotated(_background.global_rotation)
	_dunes_layer.motion_scale = _dunes_motion_scale
	
	_dunes_foreground_layer.motion_mirroring = _dunes_foreground_sprite.texture.get_size()#.rotated(_background.global_rotation)
	_dunes_foreground_layer.motion_scale = _dunes_foreground_motion_scale


func _process(_delta):
	var scroll = Vector2(0,3) #Some default scrolling so there's always movement.
	if player != null: #and _runtime_data.current_game_state != Enums.GameState.IN_DIALOG:
		scroll += player._velocity / 100
	scroll_offset += scroll
