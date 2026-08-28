extends Area2D

export(NodePath) var gate_path

var started := false

func _on_body_entered(body: Node) -> void:
	if started or not is_player_body(body):
		return
	started = true
	call_deferred("start_bass_battle")

func is_player_body(body: Node) -> bool:
	if not body.is_in_group("Player"):
		return false
	if body.has_method("get_character"):
		return body.get_character() == GameManager.player
	return body.get_parent() == GameManager.player

func start_bass_battle() -> void:
	monitoring = false
	close_gate()
	GameManager.start_cutscene()
	Event.emit_signal("boss_door_open")
	Event.emit_signal("show_warning")

func close_gate() -> void:
	var gate = get_node_or_null(gate_path)
	if gate == null:
		return
	gate.visible = true
	var shape = gate.get_node_or_null("CollisionShape2D")
	if shape != null:
		shape.disabled = false
