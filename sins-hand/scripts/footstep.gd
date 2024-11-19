extends Sprite2D

@export var timefade = 1.25

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("STEP")
	$Timer.wait_time = timefade
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if modulate == Color(1,1,1,0):
		#print("DELETE")
		queue_free()

func _on_timer_timeout():
	var tw = create_tween()
	tw.tween_property(self, "modulate", Color(1,1,1,0), 0.6)
	$Timer.stop()

func set_angle(degrees):
	rotation = degrees
