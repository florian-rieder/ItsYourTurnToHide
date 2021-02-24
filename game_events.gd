extends Node

signal dialog_initiated(dialogue)
signal dialog_finished(dialogue)
signal child_found
signal win
signal seen_by_enemy(enemyEntity)

func emit_dialog_initiated(dialogue : Dialogue) -> void:
	# prevents last click to close dialog from being considered as a real click,
	# avoiding clicking on food when closing dialog
	call_deferred("emit_signal", "dialog_initiated", dialogue)

func emit_dialog_finished(dialogue : Dialogue) -> void:
	call_deferred("emit_signal", "dialog_finished", dialogue)
