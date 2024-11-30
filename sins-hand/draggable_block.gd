extends RigidBody2D
signal clicked

@export var rotatable = true
@export var pickable = true

var held = false
var inHandArea = false			
var mouse_speed = 8.0
func pickup():
	if !pickable:
		return
	print("GRAB!")
	if held:
		return
	#freeze = true
	#position = position.slerp(position + Vector2(0.0, -20.0), 0.5)
	held = true
	%Pickup.play()

func drop(impulse=Input.get_last_mouse_velocity() * mouse_speed):
	if held:
		#freeze = false
		#position = position.slerp(position + Vector2(0.0, +20.0), 0.5)
		apply_impulse(impulse)
		held = false
		%Drop.play()

#func _input(event):
	#print(event.as_text())
	#if Input.is_action_pressed("grab"):
		#print("CLICK")
		#emit_signal("clicked", self)



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if rotatable:
		rotation = randf_range(-PI, PI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if abs(angular_velocity) > 10.0:
		angular_velocity = sign(angular_velocity) * 10.0
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


func _on_area_2d_large_area_entered(area):
	if area.get_name() =="PlayerArea":
		$BumpIntoObject.pitch_scale = randf_range(0.85, 1.15)
		$BumpIntoObject.play()
