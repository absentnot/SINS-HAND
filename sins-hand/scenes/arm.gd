extends Line2D

var segment_to_follow
var following_segment
var anchor

var is_end = true 
var is_start = false
var side = "left"
@export var target = Vector2(0.0, 0.0)
@export var inverse_target = Vector2(0.0, 0.0)
@export var targetObj = PackedScene

@export var length = 20
var num_segments = 7
var speed = 1000.0

var player_node
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	#print("TARGET POS:", target)
		
	if is_end and segment_to_follow:
		#target = get_viewport().get_mouse_position()
		target = segment_to_follow.points[0]
		
		# Get the screen size (viewport dimensions)
		var screen_size = get_viewport().get_visible_rect().size

		# Calculate the screen center
		var screen_center = screen_size * 0.5

		#inverse_target = player_node.position + get_viewport().get_mouse_position() - screen_center + Vector2(0.0, 15.0) # adjustment for anchor positioning
		#print(get_viewport().get_camera_2d().offset)
		inverse_target = player_node.position + get_viewport().get_mouse_position() - screen_size - Vector2(210.0, 30.0) + (get_viewport().get_camera_2d().get_screen_center_position() - player_node.position) # adjustment for camera offset
		#inverse_target = inverse_target - (inverse_target - points[0]).normalized() * player_node.position.distance_to(inverse_target) / 2.0
		if player_node.position.distance_to(inverse_target) >= num_segments * length * 1.2:
			inverse_target = player_node.position + (inverse_target - points[0]).normalized() *  num_segments * length
	elif is_start:
		#print(get_parent().get_parent().get_parent().get_parent())
		#var anchor_global_position = player_node.global_position + player_node.global_transform.basis_xform(anchor_offset)
		length = 28
		if side == "left":
			target = player_node.position + anchor.position / 2.0 + player_node.get_child(0).get_child(0).get_child(6).position + Vector2(-1.0, 0.0)
		else:
			target = player_node.position + anchor.position / 2.0 + player_node.get_child(0).get_child(0).get_child(7).position + Vector2(1.0, 0.0)
			#target = anchor.global_position
			
		if following_segment:
			inverse_target = following_segment.points[0]
	else:
		if segment_to_follow:
			target = segment_to_follow.points[0]
		if following_segment:
			inverse_target = following_segment.points[0]
	
	#if target:
	var dir = (target - points[0]).normalized()
	var angle = points[0].angle_to_point(target)
	
	#var min_angle = -1 * PI/3
	#var max_angle = 1 * PI/3
	#
	#angle = clampf(angle, min_angle, max_angle)
	
	var dx = length * cos(angle)
	var dy = length * sin(angle)
	
	points[1] = Vector2(points[0].x + dx, points[0].y + dy)
	
		## Move the first point towards the target, respecting max_distance
	#var distance_to_target = points[0].distance_to(target - dir * (length - 5.0))
	#if distance_to_target > speed * delta:
		#points[0] += dir * speed * delta
	#else:
		#points[0] = target - dir * (length - 5.0)
	
	# Move the first point towards the target, respecting max_distance
	#var distance_to_target = points[0].distance_to(target - dir * (length - 5.0))
	#if distance_to_target > speed * delta:
		#points[0].lerp(points[0] + dir, speed * delta)
	#else:
	points[0] = points[0].lerp(target - dir * (length - 5.0), 0.75)
		
	var inverse_dir = (inverse_target - points[0]).normalized()

	if Input.is_action_pressed("grab"):
		if side == "left":
			points[0] = points[0].lerp(inverse_target - inverse_dir.rotated(0.2) * (length - 5.0), 0.5)
		else:
			points[0] = points[0].lerp(inverse_target - inverse_dir.rotated(-0.2) * (length - 5.0), 0.5)
	#var inverse_dir = (inverse_target - points[0]).normalized()
	#var distance_to_inverse_target = points[0].distance_to(inverse_target)
	#var temp_target = inverse_dir * num_segments * length 
	#if Input.is_action_pressed("grab") and distance_to_inverse_target > speed * delta:
		#points[0] += inverse_dir * speed * delta
	#else:
		#points[0] = temp_target - inverse_dir * (length - 5.0)

	
	# Ensure the updated point maintains the specified distance from the target
	#points[0] = target - dir * (length - 5.0)
	
	if is_end:
		$"Sin-hand".position = target - 2.0 * dir * (length - 5.0)
		$"Sin-hand".rotation = angle
		if side != "left":
			$"Sin-hand".scale.x = -1
			$"Sin-hand".rotation = angle + PI
		
		
		
		#follow_segment()
		#print(points)

func set_segment(point1, point2):
	add_point(point1)
	add_point(point2)
	
#func follow_segment():
	#if segment_to_follow:
		#set_point_position(0, segment_to_follow.get_point_position(1))
	#if anchor:
		#set_point_position(0, anchor.position)

func _draw():
	draw_polyline(points, Color("#353535"), width + 6.0)
	draw_polyline(points, Color("#b7b7b7"), width)
	#if is_end:
		#draw_circle(inverse_target, 10.0, Color("#b7b7b7"))
