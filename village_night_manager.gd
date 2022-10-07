extends Node2D

export(Resource) var _runtime_data = _runtime_data as RuntimeData
export(NodePath) onready var _camera = get_node(_camera) as Camera2D
export(NodePath) onready var _scene_transition = get_node(_scene_transition) as ColorRect

var tween
var death_camera
var timer


func _ready():
    death_camera = Camera2D.new()
    death_camera.zoom = Vector2(0.25, 0.25)
    death_camera.offset = Vector2(-0.4, 0)
    tween = Tween.new()
    death_camera.add_child(tween)
    add_child(death_camera)
    
    
    GameEvents.connect("win", self, "_on_escape")
    GameEvents.connect("seen_by_enemy", self, "_on_player_seen")
    _runtime_data.current_game_state = Enums.GameState.STEALTH
    
    # turn off all radios on the map
    var radios = get_tree().get_nodes_in_group("Radios")
    for radio in radios:
        radio.activate()


func _on_player_seen(enemy : Enemy) -> void:
    # death
    death_camera.global_position = _camera.global_position
    _camera.current = false
    death_camera.current = true
    
    tween.interpolate_property(death_camera, "position",
    death_camera.global_position, enemy.global_position, 1,
    Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()
    
    timer.start()


func _init():
    timer = Timer.new()
    add_child(timer)
    timer.autostart = false
    timer.one_shot = true
    timer.wait_time = 1.5
    timer.connect("timeout", self, "_timeout1")


func _timeout1():
    _scene_transition.cut_to_black()
    $AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished():
    # wait for the shot sound to end before respawning
    # more dramatic death !
    get_tree().reload_current_scene()


func _on_escape() -> void:
    get_tree().change_scene("res://Outro.tscn")
