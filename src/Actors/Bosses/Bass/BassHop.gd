extends AttackAbility

export var hop_speed := 120.0
export var hop_velocity := 320.0

func _Setup() -> void:
	turn_and_face_player()
	play_animation("jump")
	set_vertical_speed(-hop_velocity)

func _Update(delta: float) -> void:
	process_gravity(delta)
	force_movement(hop_speed)
	if timer > 0.12 and character.is_on_floor():
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	if character.has_health():
		play_animation("idle")
