extends Node


var _current_scene: Node = null

onready var screen_transition: ScreenTransition = $ScreenTransition
onready var current_scene_container: Node = $CurrentSceneContainer


func _ready() -> void:
	Events.connect("scene_change_requested", self, "_on_scene_change_requested")
	
	# Have a slight delay while program loads (Godot icon, etc.), then show the menu screen.
	screen_transition.transition_amount = 1.0
	yield(get_tree().create_timer(0.5), "timeout")
	change_scene_with_transition("res://menu_scene.tscn")


func _on_scene_change_requested(scene_path: String) -> void:
	change_scene_with_transition(scene_path)


func change_scene_with_transition(scene_path: String) -> void:
	if screen_transition.is_transitioning:
		return
	
	# If we have a current scene then transition out and remove it first.
	if is_instance_valid(_current_scene):
		screen_transition.transition_out()
		yield(screen_transition, "transition_complete")
		current_scene_container.remove_child(_current_scene)
		_current_scene.queue_free()
	
	_current_scene = load(scene_path).instance()
	current_scene_container.add_child(_current_scene)
	
	screen_transition.transition_in()
	yield(screen_transition, "transition_complete")  # May or may not want to wait on this.
