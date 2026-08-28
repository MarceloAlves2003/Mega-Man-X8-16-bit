extends Area2D

export var clear_flag := "neongrid_clear"
var finished := false


func _on_body_entered(body: Node) -> void:
	if finished:
		return
	var character := _get_character(body)
	if not character or character != GameManager.player:
		return
	finished = true
	if clear_flag != "":
		GameManager.add_collectible_to_savedata(clear_flag)
	GameManager.end_boss_death_cutscene()


func _get_character(body: Node) -> Node:
	if body.has_method("get_character"):
		return body.get_character()
	return body
