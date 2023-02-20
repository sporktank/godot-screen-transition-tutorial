class_name ScreenTransition
extends CanvasLayer


signal transition_complete()

export(float, 0.01, 2.0) var duration := 0.55
export(float, 0.0, 0.1) var delay_duration := 0.2


var is_transitioning := false
var transition_amount := 0.0 setget _set_transition_amount

onready var color_rect: ColorRect = $ColorRect
onready var audio_out: AudioStreamPlayer = $AudioOut
onready var audio_in: AudioStreamPlayer = $AudioIn


func _set_transition_amount(value: float) -> void:
	# Used to allow easier changing of shader param via tweens.
	transition_amount = value
	color_rect.material.set_shader_param("amount", value)


func transition_out() -> void:
	is_transitioning = true
	audio_out.play()
	transition_amount = 0.0
	
	yield(get_tree().create_tween().tween_property(self, "transition_amount", 1.0, duration), "finished")
	yield(get_tree().create_timer(delay_duration), "timeout")
	
	is_transitioning = false
	emit_signal("transition_complete")


func transition_in() -> void:
	is_transitioning = true
	audio_in.play()
	transition_amount = 1.0
	
	yield(get_tree().create_tween().tween_property(self, "transition_amount", 0.0, duration), "finished")
	yield(get_tree().create_timer(delay_duration), "timeout")
	
	is_transitioning = false
	emit_signal("transition_complete")
