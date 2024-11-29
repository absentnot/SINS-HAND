extends Camera2D

@export var min_value = 0.0
@export var max_value = 0.0

@export var offset_override = Vector2(0.0, 0.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if min_value != 0.0 and max_value != 0.0:
		offset = shakeOffset() + offset_override

func shakeOffset():
	return Vector2(randf_range(min_value, max_value), randf_range(min_value, max_value))
