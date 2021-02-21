extends Node2D

export(Resource) var _ending_dialogue = _ending_dialogue as Dialogue
export(Resource) var _mother_call = _mother_call as Dialogue
export(NodePath) onready var _scene_transition = get_node(_scene_transition) as ColorRect
export(NodePath) onready var _end_dialog = get_node(_end_dialog) as NPCDialog
export(NodePath) onready var _player = get_node(_player) as Player
export(Resource) var _runtime_data = _runtime_data as RuntimeData

var _children_found = 0
var timer

func _ready():
	GameEvents.connect("dialog_finished", self, "_on_dialog_finished")
	GameEvents.connect("child_found", self, "_on_child_found")
	_player.connect("win", self, "_on_escape")


func _on_child_found() -> void:
	_children_found += 1
	if _children_found == 4:
		_on_all_children_found()


func _on_all_children_found() -> void:
	#_end_dialog._dialogue = _ending_dialogue
	_end_dialog.visible = true
	_end_dialog.get_node("Area2D/CollisionShape2D").disabled = false
	timer.start()

func _on_dialog_finished(dialogue : Dialogue) -> void:
	if dialogue == _ending_dialogue:
		_scene_transition.fade_out()


func _on_FadeOutTween_completed(object, key) -> void:
	get_tree().change_scene("res://transition.tscn")


func _init():
	timer = Timer.new()
	add_child(timer)
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = 5
	timer.connect("timeout", self, "_timeout")


func _timeout():
	if _runtime_data.current_game_state != Enums.GameState.IN_DIALOG:
		GameEvents.emit_dialog_initiated(_mother_call)
		
func _on_escape() -> void:
	get_tree().change_scene("res://Outro.tscn")
