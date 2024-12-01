extends Node2D

@onready var main = get_parent().get_parent().get_parent().get_parent()
@onready var player = get_node_or_null("Player")

var gateOpened = false

var beastSatisfied = false

var level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	main.updatePickable()
	main.updateGate()
	player.closestGate = $GATE
	$Player/Camera2D.zoom = Vector2(0.9, 0.9)
	%cage.connect("finishEating", cageCleared)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func cageCleared():
	%DraggableKey.pickable = true
	%DraggableKey.set_collision_mask_value(4, true)
	beastSatisfied = true

func _on_gate_gate_opened():
	player.knockback($GATE.position, 2500.0)


func _on_beast_area_area_entered(area):
	if area.get_name() == "HandArea" and !beastSatisfied:
		%BeastGrowl.play()
		var tw = create_tween()
		tw.tween_property($cage, "scale", Vector2(1.2, 1.2), 0.5)
		tw.tween_property($cage, "scale", Vector2(1.0, 1.0), 0.1)
		player.knockback($cage.position, 1750.0)
		
