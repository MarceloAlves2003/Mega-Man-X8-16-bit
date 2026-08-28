extends AttackAbility

export var hop_speed := 120.0
# hop_velocity = 190 → mesma altura máxima que o X
export var hop_velocity := 190.0

var _peaked := false

func _Setup() -> void:
	turn_and_face_player()
	play_animation("jump")
	set_vertical_speed(-hop_velocity)
	_peaked = false

func _Update(delta: float) -> void:
	process_gravity(delta)
	force_movement(hop_speed)
	# Troca animação ao começar a cair
	if character.get_vertical_speed() > 0 and character.get_animation() != "fall":
		play_animation("fall")
		_peaked = true
	# Só termina depois de ter atingido o pico E voltado ao chão
	if _peaked and character.is_on_floor():
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	_peaked = false
	if character.has_health():
		play_animation("idle")
