extends Node2D


func _on_Button_pressed() -> void:
	Events.emit_signal("scene_change_requested", "res://game_scene.tscn")
