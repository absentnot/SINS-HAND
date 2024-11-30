extends Node2D
signal finishEating

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func eat():
	var tw = create_tween()
	tw.tween_property($Sprite2D, "scale", Vector2(1.1, 0.9), 0.2)
	tw.tween_property($Sprite2D, "scale", Vector2(1.2, 0.7), 0.2)
	tw.tween_property($Sprite2D, "scale", Vector2(1.0, 0.95), 0.2)
	tw.tween_property($Sprite2D, "scale", Vector2(1.2, 0.7), 0.2)
	tw.tween_property($Sprite2D, "scale", Vector2(1.0, 0.95), 0.2)
	tw.tween_property($Sprite2D, "scale", Vector2(0.8, 0.8), 0.75)
	tw.tween_property($Sprite2D, "scale", Vector2(1.1, 1.1), 0.2)
	tw.tween_property($Sprite2D, "scale", Vector2(1.0, 1.0), 0.1)
	tw.tween_callback(finish_eating)

func finish_eating():
	$Sprite2D.texture = load("res://assets/cage-noeyes.png")
	emit_signal("finishEating")

func _on_eat_area_area_entered(area):
	if area.get_name() == "LimboManArea2D":
		eat()
		area.get_parent().queue_free()
