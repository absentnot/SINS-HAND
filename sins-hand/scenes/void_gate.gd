extends Node2D
signal gateEntered

@export var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gate_area_area_entered(area):
	print(area)
	if area.get_name() == "PlayerArea" and is_open:
		print(area)
		emit_signal("gateEntered")
