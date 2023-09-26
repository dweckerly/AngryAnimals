extends TextureButton

const HOVER_SCALE: Vector2 = Vector2(1.2, 1.2)
const DEFAULT_SCALE: Vector2 = Vector2(1.0, 1.0)

@export var level_number: int  = 1

@onready var level_label = $MC/VB/LevelLabel
@onready var score_label = $MC/VB/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	level_label.text = str(level_number)

func _on_pressed():
	pass # Replace with function body.


func _on_mouse_entered():
	scale = HOVER_SCALE


func _on_mouse_exited():
	scale = DEFAULT_SCALE
