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

func _on_gate_inner_area_area_entered(area):
	if area.get_name() == "PlayerArea" and is_open:
		var tw = create_tween()
		tw.tween_property($PortalHum, "volume_db", -60, 4.0)


func _on_gate_inner_area_area_exited(area):
	if area.get_name() == "PlayerArea" and is_open:
		var tw = create_tween()
		tw.tween_property($PortalHum, "volume_db", 15, 1.0)
