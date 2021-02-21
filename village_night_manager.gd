extends Node2D

export(Resource) var _runtime_data = _runtime_data as RuntimeData

func _ready():
	_runtime_data.current_game_state = Enums.GameState.STEALTH
	
	# turn off all radios on the map
	var radios = get_tree().get_nodes_in_group("Radios")
	for radio in radios:
		radio.activate()

