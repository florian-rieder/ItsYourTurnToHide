class_name Player
extends Actor

signal canInteract(message)
signal resetInteract
signal credits_song_finished


const FLOOR_DETECT_DISTANCE = 20.0

var visibility = 1.0 setget visibility_set
export(float) var max_detect_distance = 70
export(Resource) var _runtime_data = _runtime_data as RuntimeData

onready var platform_detector = $PlatformDetector
onready var sprite = $AnimatedSprite
onready var gun = $AnimatedSprite/RockOrigin

var _canInteract = false
var _currentInteractor = null
var _canMove = true
var _old_visibility = 1.0
var _is_moving = false
var _interactorInstance = null
var _has_been_seen = false


func _ready():
    # this is actually really dumb.
    # why have the ambience on the player and then change it in function of the
    # level when you could have one ambiance on each level ? This is fascinating
    var current_scene = get_tree().get_current_scene().get_name()
    if current_scene == "Intro" or current_scene == "VillageDay":
        $AnimationPlayer.play("village_ambiant_day")
    elif current_scene == "VillageNight":
        speed = Vector2(100, 0)
        $AnimationPlayer.play("village_ambiant_night")
    elif current_scene == "Outro":
        $AnimationPlayer.play("credits_song")


func _physics_process(_delta):
    if _runtime_data.current_game_state == Enums.GameState.FREEWALK \
        or _runtime_data.current_game_state == Enums.GameState.STEALTH:
        var direction = get_direction()

        _velocity = calculate_move_velocity(_velocity, direction, speed)
        
        # gestion des animations course/idle
        if _velocity.x == 0:
            _is_moving = false
            sprite.play("idle")
        else:
            _is_moving = true
            if _runtime_data.current_game_state == Enums.GameState.STEALTH:
                sprite.play("stealth_walk")
            else:
                sprite.play("run")

        var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
        var is_on_platform = platform_detector.is_colliding()
        _velocity = move_and_slide_with_snap(
            _velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
        )

        # When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
        if direction.x != 0:
            sprite.scale.x = 1 if direction.x > 0 else -1

func _process(delta):
    # throwing rocks
    # fuck rock throwing, it doesn't do anything anyway and is not introduced.
#    if Input.is_action_just_pressed("ui_select") and _canMove: #\
#        #and _runtime_data.current_game_state == Enums.GameState.STEALTH:
#        var cursorPos = get_global_mouse_position()
#        var projectile_direction = -(position - cursorPos).normalized()
#        # Flip if shooting behind
#        if projectile_direction.x * sprite.scale.x < 0:
#            sprite.scale.x *= -1
#        # Add more force when lauching in the same direction of the movement
#        if abs(_velocity.x) > 0.1 and (projectile_direction.x * _velocity.x > 0):
#            gun.shoot(projectile_direction*1.5)
#        else:
#            gun.shoot(projectile_direction)

    # Hide behind cover
    if Input.is_action_just_pressed("interact") and _canInteract \
        and (_runtime_data.current_game_state == Enums.GameState.FREEWALK \
        or _runtime_data.current_game_state == Enums.GameState.STEALTH):
        match _currentInteractor:
            "Cover":
                if _interactorInstance and _interactorInstance.has_method("try_to_trigger_dialog"):
                    _interactorInstance.try_to_trigger_dialog()
                elif _canMove:
                    _old_visibility = visibility
                    z_index = 9 # get behind cover
                    visibility_set(0)
                    sprite.modulate.a = 0.2
                    _canMove = false
                    
                else:
                    visibility_set(_old_visibility)
                    z_index = 20 # get back to original z-index
                    _canMove = true
                    sprite.modulate.a = 1
            "Radio":
                if _interactorInstance:
                    _interactorInstance.activate()
                    
            "Exit":
                GameEvents.emit_signal("win")
            
            # Teleportation (doors)
            var TPposition:
                global_position = TPposition


func get_direction():
    if _canMove:
        return Vector2(
            Input.get_action_strength("right") - Input.get_action_strength("left"),
            0
        )
    else:
        return Vector2(0,0)


# This function calculates a new velocity whenever you need it.
func calculate_move_velocity(linear_velocity, direction, speed):
    var velocity = linear_velocity
    velocity.x = speed.x * direction.x
    if direction.y != 0.0:
        velocity.y = speed.y * direction.y

    return velocity


# Ajust alpha depending on the visibility, maybe not a good idea
func visibility_set(newVisibility = 1):
    newVisibility = clamp(newVisibility,0.0,2.0)
    visibility = newVisibility
    #sprite.modulate.a = visibility


# Called by interactors
func canInteract(message, interactor, interactorInstance = null):
    if not _has_been_seen:
        _canInteract = true
        _currentInteractor = interactor
        _interactorInstance = interactorInstance
        emit_signal("canInteract", message)


# To reset the msg print on the HUD
func resetInteract():
        _canInteract = false
        _currentInteractor = ""
        _interactorInstance = null
        emit_signal("resetInteract")


func isInSight(distance: float, enemyEntity : Enemy):
    if distance < max_detect_distance*visibility and not _has_been_seen:
        _has_been_seen = true
        _canMove = false
        get_tree().call_group("Ennemies","stop")
        emit_signal("resetInteract")
        GameEvents.emit_signal("seen_by_enemy",enemyEntity)
        enemyEntity.turn_red()

func emit_song_finished():
    emit_signal("credits_song_finished")
