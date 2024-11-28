extends RigidBody2D
signal clicked

var held = false
var inHandArea = false			
var mouse_speed = 5.0
func pickup():
	print("GRAB!")
	if held:
		return
	#freeze = true
	#position = position.slerp(position + Vector2(0.0, -20.0), 0.5)
	held = true

func drop(impulse=Input.get_last_mouse_velocity() * mouse_speed):
	if held:
		#freeze = false
		#position = position.slerp(position + Vector2(0.0, +20.0), 0.5)
		apply_impulse(impulse)
		held = false

#func _input(event):
	#print(event.as_text())
	#if Input.is_action_pressed("grab"):
		#print("CLICK")
		#emit_signal("clicked", self)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !inHandArea and held:
		drop()
	if Input.is_action_pressed("grab") and inHandArea and !held:
		print("CLICK")
		emit_signal("clicked", self)
	if held:
		global_transform.origin = get_global_mouse_position()


func _on_area_2d_area_entered(area):
	print(area.is_in_group("hands"))
	if area.is_in_group("hands"):
		inHandArea = true



func _on_area_2d_large_area_exited(area):
	if area.is_in_group("hands"):
		inHandArea = false
