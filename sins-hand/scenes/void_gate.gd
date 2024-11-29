extends Node2D
signal gateEntered
signal gateOpened

@export var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$PortalHum.volume_db = -60


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gate_area_area_entered(area):
	print(area)
	if area.get_name() == "PlayerArea" and is_open:
		print(area)
		emit_signal("gateEntered")

func _on_gate_inner_area_area_entered(area):
	open()
	if area.get_name() == "PlayerArea" and is_open:
		var tw = create_tween()
		tw.tween_property($PortalHum, "volume_db", -60, 4.0)


func _on_gate_inner_area_area_exited(area):
	if area.get_name() == "PlayerArea" and is_open:
		var tw = create_tween()
		tw.tween_property($PortalHum, "volume_db", 15, 1.0)
		

func open():
	if !is_open:
		$AnimatedSprite2D.play()
		#is_open = true
		$Gate/GateBG.visible = true
		$"Gate-Inverted".visible = true
		$ColorRect.visible = true
		#$PortalHum.volume_db = 15


func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.stop()
	


func _on_key_area_area_entered(area):
	if area.get_name() == "HandArea" and !is_open:
		%Pickup.play()
