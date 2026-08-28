extends "res://src/Actors/Bosses/Bass/BassStraightShot.gd"

export var run_speed := 90.0
export var run_time := 0.65

func _Setup() -> void:
	turn_and_face_player()
	shots_fired = 0
	play_animation_again("run_shoot")

func _Update(delta: float) -> void:
	process_gravity(delta)
	force_movement(run_speed)
	fire_burst()
	if timer >= run_time or is_colliding_with_wall():
		EndAbility()
