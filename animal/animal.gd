extends RigidBody2D

@onready var stretch_sound = $StretchSound
@onready var launch_sound = $LaunchSound

const DRAG_LIM_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0)
const IMPULSE_MULT: float = 20.0

var _dead: bool = false
var _dragging: bool = false
var _released: bool = false
var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_position: Vector2 = Vector2.ZERO
var _last_drag_amount: float = 0.0
var _fired_time: float = 0.0

func _ready():
	_start = global_position

func _physics_process(delta):
	update_debug_label()
	if _released:
		pass
	else:
		if !_dragging:
			return
		else:
			if Input.is_action_just_released("drag"):
				release_it()
			else:
				drag_it()

func update_debug_label() -> void:
	var s = "g_pos:%s\n" % Utils.vector2_to_string(global_position)
	s += "dragging:%s released: %s\n" % [
		_dragging,    
		_released
	]
	s += "start:%s drag_start: %s dragged_vector:%s\n" % [
		Utils.vector2_to_string(_start),    
		Utils.vector2_to_string(_drag_start),
		Utils.vector2_to_string(_dragged_vector)
	]
	s += "last_dragged_position:%s last_drag_amount: %.1f\n" % [
		Utils.vector2_to_string(_last_dragged_position),    
		_last_drag_amount
	]
	s += "ang:%.1f linear: %s fired_time:%.1f\n" % [
		angular_velocity,    
		Utils.vector2_to_string(linear_velocity),
		_fired_time
	]
	SignalManager.on_update_debug_label.emit(s)

func grab_it() -> void:
	_dragging = true
	_drag_start = get_global_mouse_position()
	_last_dragged_position = _drag_start

func drag_it() -> void:
	var gmp = get_global_mouse_position()
	_last_drag_amount = (_last_dragged_position - gmp).length()
	_last_dragged_position = gmp
	_dragged_vector = gmp - _drag_start
	if _last_drag_amount > 0 and !stretch_sound.playing:
		stretch_sound.play()
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIM_MIN.x,
		DRAG_LIM_MAX.x
	)
	_dragged_vector.y = clampf(
		_dragged_vector.y,
		DRAG_LIM_MIN.y,
		DRAG_LIM_MAX.y
	)
	global_position = _start + _dragged_vector

func release_it() -> void:
	_dragging = false
	_released = true
	freeze = false
	apply_central_impulse(get_impluse())
	stretch_sound.stop()
	launch_sound.play()

func get_impluse() -> Vector2:
	return _dragged_vector * -1 * IMPULSE_MULT

func die() -> void:
	if _dead:
		return
	_dead = true
	SignalManager.on_animal_died.emit()
	queue_free()

func _on_screen_exited():
	die()

func _on_input_event(viewport, event: InputEvent, shape_idx):
	if _dragging or _released:
		return
	if event.is_action_pressed("drag"):
		grab_it()
