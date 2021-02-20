extends Position2D

const BULLET_VELOCITY = 300.0
const Rock = preload("res://Rock.tscn")

onready var cooldown = $RockCooldown

# This method is only called by Player.gd
func shoot(direction = Vector2(1,0)):
	if not cooldown.is_stopped():
		return false
	var rock = Rock.instance()
	rock.global_position = global_position
	rock.linear_velocity = Vector2(direction * BULLET_VELOCITY)

	rock.set_as_toplevel(true)
	add_child(rock)
	return true
