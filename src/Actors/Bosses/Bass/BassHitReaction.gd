extends "res://src/Actors/Bosses/BossStun.gd"

func _ready() -> void:
	var _hit = damage.connect("got_hit", self, "start_hit_reaction")

func start_hit_reaction(inflicter) -> void:
	if active and character.has_health():
		side_hit = get_inflicter_direction(inflicter)
		character.interrupt_all_moves()
		ExecuteOnce()

func get_inflicter_direction(inflicter) -> int:
	if is_instance_valid(inflicter) and inflicter.global_position.x < character.global_position.x:
		return 1
	return -1

func _Setup() -> void:
	play_animation_again("damage")
	character.set_direction(-side_hit, true)
	force_movement_toward_direction(horizontal_velocity, side_hit)
	set_vertical_speed(-jump_velocity)

func _Update(delta: float) -> void:
	process_gravity(delta)
	force_movement_toward_direction(horizontal_velocity, side_hit)
	if character.is_on_floor() and timer > floor_time:
		force_movement_toward_direction(0, side_hit)

func _Interrupt() -> void:
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	if character.has_health():
		play_animation("idle")
