extends "res://src/Actors/Bosses/Bass/BassStraightShot.gd"

const RUN_SHOOT_FRAME_COUNT := 15
const RUN_SHOOT_FRAME_PATH := "res://src/Actors/Bosses/Bass/run_shoot_frames/run_shoot_%d.png"
const RUN_SHOOT_ANIMATION_SPEED := 14.0

export var run_speed := 90.0
export var run_time := 1.1

var run_shoot_shot_offsets = [
	Vector2(36, 12),
	Vector2(35, 12),
	Vector2(35, 12),
	Vector2(36, 12),
	Vector2(38, 13),
	Vector2(39, 13),
	Vector2(37, 12),
	Vector2(36, 12),
	Vector2(35, 12),
	Vector2(36, 12),
	Vector2(37, 11),
	Vector2(39, 13),
	Vector2(40, 13),
	Vector2(39, 14),
	Vector2(38, 12)
]

func _Setup() -> void:
	turn_and_face_player()
	shots_fired = 0
	configure_run_shoot_frames()
	play_animation_again("run_shoot")

func _Update(delta: float) -> void:
	process_gravity(delta)
	force_movement(run_speed)
	fire_burst()
	if timer >= run_time or is_colliding_with_wall():
		EndAbility()

func configure_run_shoot_frames() -> void:
	if character == null or not character.has_node("animatedSprite"):
		return
	var sprite = character.get_node("animatedSprite")
	var frames = sprite.frames
	if frames == null:
		return
	if not frames.has_animation("run_shoot"):
		frames.add_animation("run_shoot")
	while frames.get_frame_count("run_shoot") > 0:
		frames.remove_frame("run_shoot", 0)
	for frame_index in range(1, RUN_SHOOT_FRAME_COUNT + 1):
		var texture = load(RUN_SHOOT_FRAME_PATH % frame_index)
		if texture != null:
			frames.add_frame("run_shoot", texture)
	frames.set_animation_loop("run_shoot", true)
	frames.set_animation_speed("run_shoot", RUN_SHOOT_ANIMATION_SPEED)

func get_shot_offset() -> Vector2:
	if run_shoot_shot_offsets.empty():
		return .get_shot_offset()
	var frame := 0
	if character != null and character.has_node("animatedSprite"):
		frame = int(clamp(character.get_node("animatedSprite").frame, 0, run_shoot_shot_offsets.size() - 1))
	return run_shoot_shot_offsets[frame]
