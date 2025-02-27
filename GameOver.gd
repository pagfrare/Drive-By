extends Node

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")


func _on_dnv_pressed() -> void:
	get_tree().change_scene_to_file("res://loading.tscn")
