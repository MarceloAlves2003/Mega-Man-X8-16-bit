extends AttackAbility

export var dash_speed := 90.0
export var dash_time := 0.45

func _Setup() -> void:
	turn_and_face_player()
	play_animation("run")

func _Update(delta: float) -> void:
	process_gravity(delta)
	force_movement(dash_speed)
	if timer > dash_time or is_colliding_with_wall():
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	if character.has_health():
		play_animation("idle")
