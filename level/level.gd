extends Node2D

@onready var debug_label = $DebugLabel

func _ready():
	SignalManager.on_update_debug_label.connect(on_update_debug_label)

func _process(delta):
	pass

func on_update_debug_label(text: String) -> void:
	debug_label.text = text
