extends RigidBody2D


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	update_debug_label()

func update_debug_label() -> void:
	var s = "g_pos:%s\n" % Utils.vector2_to_string(global_position)
	s += "ang:%.1f linear: %s" % [
		angular_velocity,
		Utils.vector2_to_string(linear_velocity)
	]
	SignalManager.on_update_debug_label.emit(s)
