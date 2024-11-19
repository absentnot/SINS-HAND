extends Line2D

var segment_to_follow
var anchor

var is_end = true 
var is_start = false
@export var target = Vector2(0.0, 0.0)
@export var targetObj = PackedScene

@export var length = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if is_end and segment_to_follow:
		#target = get_viewport().get_mouse_position()
		target = segment_to_follow.points[0]
	elif is_start:
		#print(get_parent().get_parent().get_parent().get_parent())
		target = anchor.global_position
		#target = get_parent().get_parent().get_parent().get_parent().position
	else:
		if segment_to_follow:
			target = segment_to_follow.points[0]
	
	#if target:
	var dir = (target - points[0]).normalized()
	var angle = points[0].angle_to_point(target)
	
	var dx = length * cos(angle)
	var dy = length * sin(angle)
	
	points[1] = Vector2(points[0].x + dx, points[0].y + dy)
	points[0] = target - dir * (length - 2.0)
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
