extends Node2D

var held_object = null
var mouse_speed = 5.0

func _input(event):
	if event.is_action_released("grab") and held_object:
		print("DROP!")
		held_object.drop(Input.get_last_mouse_velocity() * mouse_speed)
		held_object = null

func _ready():
	updatePickable()

func updatePickable():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.connect("clicked", _on_pickable_clicked)
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()
