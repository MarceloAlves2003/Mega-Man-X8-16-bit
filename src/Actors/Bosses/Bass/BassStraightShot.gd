extends AttackAbility

export var projectile: PackedScene
export var shot_count := 2
export var max_active_projectiles := 2
export var first_shot_delay := 0.12
export var shot_interval := 0.13
export var recovery_time := 0.24
export var shot_offset := Vector2(36, 12)

var shots_fired := 0

func _Setup() -> void:
	turn_and_face_player()
	shots_fired = 0
	character.set_horizontal_speed(0)
	play_animation_again("shoot")

func _Update(delta: float) -> void:
	process_gravity(delta)
	character.set_horizontal_speed(0)
	fire_burst()
	if timer >= first_shot_delay + shot_interval * shot_count + recovery_time:
		EndAbility()

func fire_burst() -> void:
	if shots_fired >= shot_count:
		return
	if timer < first_shot_delay + shot_interval * shots_fired:
		return
	if active_projectile_count() >= max_active_projectiles:
		return
	create_projectile()
	shots_fired += 1

func active_projectile_count() -> int:
	var count := 0
	for node in get_tree().get_nodes_in_group("Enemy Projectile"):
		if node.name.begins_with("BassProjectile") and "creator" in node and node.creator == character:
			count += 1
	return count

func create_projectile() -> void:
	if projectile == null:
		return
	var shot = projectile.instance()
	get_tree().current_scene.add_child(shot)
	var direction = character.get_facing_direction()
	shot.global_position = character.global_position + Vector2(shot_offset.x * direction, shot_offset.y)
	shot.set_creator(character)
	shot.initialize(direction)
