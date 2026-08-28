extends Area2D


func _on_body_entered(body: Node) -> void:
	var character := _get_character(body)
	if not character or character != GameManager.player:
		return
	if character.has_method("void_touch"):
		character.void_touch()
	elif character.has_method("spike_touch"):
		character.spike_touch()


func _get_character(body: Node) -> Node:
	if body.has_method("get_character"):
		return body.get_character()
	return body
