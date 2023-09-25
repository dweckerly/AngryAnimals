extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var s = "g_pos:(%f, %f)" % [
		global_position.x,
		global_position.y
	]
	SignalManager.on_update_debug_label.emit(s)
