extends Line2D


func _draw():
	draw_polyline(points, Color("#353535"), width + 6.0)
	draw_polyline(points, Color("#f3f3f3"), width)
