extends "res://src/Actors/Modules/Enemy/BossDamage.gd"

export var damage_invulnerability_time := 1.75


func apply_invulnerability_or_death() -> void:
	if character.current_health <= 0:
		character.emit_zero_health_signal()
		return
	if invulnerability_time < damage_invulnerability_time:
		invulnerability_time = damage_invulnerability_time
		max_flash_time = max(max_flash_time, damage_invulnerability_time)
	character.set_invulnerability(invulnerability_time)
	character.emit_signal("got_hit")
