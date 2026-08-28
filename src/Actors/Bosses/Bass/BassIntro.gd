extends "res://src/Actors/Bosses/BossIntro.gd"

export var intro_start_height := 144.0
export var fall_speed := 96.0
export var settle_time := 0.25

var landing_position := Vector2.ZERO
var landed := false
var land_timer := 0.0
var battle_started := false
var intro_started := false

func _ready() -> void:
	._ready()
	if not animatedSprite.is_connected("animation_finished", self, "on_finished_animation"):
		connect_animation_finished_event()
	if not skip_intro:
		prepare_for_intro()

func connect_events() -> void:
	Event.listen("boss_door_open", self, "prepare_for_intro")
	Event.listen("warning_done", self, "execute_intro")
	Event.listen("boss_cutscene_start", self, "execute_intro")

func prepare_for_intro() -> void:
	intro_started = false
	animatedSprite.modulate = Color(1, 1, 1, 0.01)

func execute_intro() -> void:
	if intro_started:
		return
	intro_started = true
	ExecuteOnce()

func _Setup() -> void:
	if not skip_intro:
		GameManager.start_cutscene()
	battle_started = false
	landed = false
	land_timer = 0.0
	landing_position = character.global_position
	character.stop_all_movement()
	character.global_position.y = get_intro_start_y()
	animatedSprite.modulate = Color(1, 1, 1, 1)
	play_animation_again("intro")

func get_intro_start_y() -> float:
	var start_y = landing_position.y - intro_start_height
	if GameManager.camera != null:
		var camera_top = GameManager.camera.get_camera_screen_center().y - 112.0
		start_y = max(start_y, camera_top + 32.0)
	return start_y

func _Update(delta: float) -> void:
	character.stop_all_movement()
	if not landed:
		character.global_position.y = min(character.global_position.y + fall_speed * delta, landing_position.y)
		if character.global_position.y >= landing_position.y:
			character.global_position = landing_position
			landed = true
		return

	land_timer += delta
	if land_timer >= settle_time and intro_animation_done():
		finish_intro()

func intro_animation_done() -> bool:
	if has_finished_animation("intro"):
		return true
	if animatedSprite.frames == null or not animatedSprite.frames.has_animation("intro"):
		return true
	return animatedSprite.frame >= animatedSprite.frames.get_frame_count("intro") - 1

func finish_intro() -> void:
	if battle_started:
		return
	battle_started = true
	character.global_position = landing_position
	play_animation("idle")
	Event.emit_signal("play_boss_music")
	Event.emit_signal("boss_start", character)
	if show_health:
		Event.emit_signal("boss_health_appear", character)
	EndAbility()

func _Interrupt() -> void:
	character.global_position = landing_position
	if not skip_intro:
		GameManager.end_cutscene()
	animatedSprite.modulate = Color(1, 1, 1, 1)
	character.emit_signal("intro_concluded")
