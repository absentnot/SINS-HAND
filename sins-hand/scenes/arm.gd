extends Line2D

var segment_to_follow
var anchor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	follow_segment()

func set_segment(point1, point2):
	add_point(point1)
	add_point(point2)
	
func follow_segment():
	if segment_to_follow:
		set_point_position(0, segment_to_follow.get_point_position(1))
	if anchor:
		set_point_position(0, anchor.position)

func _draw():
	draw_polyline(points, Color("#353535"), width + 6.0)
	draw_polyline(points, Color("#b7b7b7"), width)
