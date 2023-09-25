extends Node2D

var animal_scene: PackedScene = preload("res://animal/animal.tscn")

@onready var debug_label = $DebugLabel
@onready var animal_start = $AnimalStart

func _ready():
	SignalManager.on_update_debug_label.connect(on_update_debug_label)
	SignalManager.on_animal_died.connect(on_animal_died)
	on_animal_died()

func _process(delta):
	pass

func on_animal_died() -> void:
	var animal = animal_scene.instantiate()
	animal.global_position = animal_start.global_position
	add_child(animal)

func on_update_debug_label(text: String) -> void:
	debug_label.text = text
