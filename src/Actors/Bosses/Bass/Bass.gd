extends Panda

const LOW_HEALTH_IDLE_THRESHOLD := 0.7
const NORMAL_IDLE_ANIMATION := "idle"
const LOW_HEALTH_IDLE_ANIMATION := "idle_low"


func _physics_process(delta: float) -> void:
	._physics_process(delta)
	update_idle_health_animation()

func play_animation(anim: String, frame: = 0) -> void:
	.play_animation(resolve_idle_animation(anim), frame)

func play_animation_once(anim: String) -> void:
	.play_animation_once(resolve_idle_animation(anim))

func resolve_idle_animation(anim: String) -> String:
	if anim == NORMAL_IDLE_ANIMATION and should_use_low_health_idle():
		return LOW_HEALTH_IDLE_ANIMATION
	return anim

func should_use_low_health_idle() -> bool:
	return has_health() and current_health < max_health * LOW_HEALTH_IDLE_THRESHOLD

func update_idle_health_animation() -> void:
	if not has_health():
		return
	if get_animation() == NORMAL_IDLE_ANIMATION and should_use_low_health_idle():
		.play_animation(LOW_HEALTH_IDLE_ANIMATION)
	elif get_animation() == LOW_HEALTH_IDLE_ANIMATION and not should_use_low_health_idle():
		.play_animation(NORMAL_IDLE_ANIMATION)
