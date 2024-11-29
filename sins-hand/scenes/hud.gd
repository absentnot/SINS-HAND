extends Control
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	print("START GAME")
	emit_signal("start_game")
	var tw = create_tween()
	tw.tween_property($TitleCenterContainer, "modulate:a", 0.0, 0.5)
