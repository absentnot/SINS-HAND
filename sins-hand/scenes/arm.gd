extends Line2D

var segment_to_follow
var anchor

var is_end = true 
var is_start = false
var side = "left"
@export var target = Vector2(0.0, 0.0)
@export var targetObj = PackedScene

@export var length = 20

var player_node
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	#print("TARGET POS:", target)
		
	if is_end and segment_to_follow:
		#target = get_viewport().get_mouse_position()
		target = segment_to_follow.points[0]
	elif is_start:
		#print(get_parent().get_parent().get_parent().get_parent())
		#var anchor_global_position = player_node.global_position + player_node.global_transform.basis_xform(anchor_offset)
		length = 28
		if side == "left":
			target = player_node.position + anchor.position / 2.0 + player_node.get_child(0).get_child(0).get_child(6).position + Vector2(-1.0, 0.0)
		else:
			target = player_node.position + anchor.position / 2.0 + player_node.get_child(0).get_child(0).get_child(7).position + Vector2(1.0, 0.0)
			#target = anchor.global_position
	else:
		if segment_to_follow:
			target = segment_to_follow.points[0]
	
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
	points[0] = target - dir * (length - 5.0)
	
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
