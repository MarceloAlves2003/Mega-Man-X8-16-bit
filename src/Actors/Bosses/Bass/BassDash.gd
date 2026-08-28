extends AttackAbility

# Velocidade e duração igual ao dash do X (horizontal_velocity=210, dash_duration=0.55)
export var dash_speed := 210.0
export var dash_time := 0.55
# Ajuste vertical para baixar a animação de dash (positivo = desce)
export var dash_sprite_offset_y := 12.0

var _original_sprite_offset: Vector2

func _Setup() -> void:
	turn_and_face_player()
	play_animation("dash")
	# Salva o offset original e aplica o ajuste para descer o sprite
	_original_sprite_offset = character.animatedSprite.offset
	character.animatedSprite.offset = Vector2(
		_original_sprite_offset.x,
		_original_sprite_offset.y + dash_sprite_offset_y
	)

func _Update(delta: float) -> void:
	process_gravity(delta)
	force_movement(dash_speed)
	if timer > dash_time or is_colliding_with_wall():
		EndAbility()

func _Interrupt() -> void:
	# Restaura o offset original ao terminar
	if character.animatedSprite:
		character.animatedSprite.offset = _original_sprite_offset
	._Interrupt()
	if character.has_health():
		play_animation("idle")
