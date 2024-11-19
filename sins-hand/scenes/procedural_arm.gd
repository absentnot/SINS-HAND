extends Node2D


@export var arm_segment: PackedScene
@export var arm_length = 5
@export var num_segments = 15

var segments = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#generate_arm()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Anchor.position = get_viewport().get_mouse_position()
	pass

func generate_arm():
	var anchor_pos = $Anchor.position
	var previous_segment = $Anchor
	for seg in range(num_segments):
		#print("SEGMENT "+str(seg))
		var segment = arm_segment.instantiate()
		
		segment.set_segment(Vector2((seg) * arm_length,0.0), Vector2((seg + 1) * arm_length, 0.0))
		
		if seg == 0:
			# First Segment
			segment.anchor = $Anchor
			segment.is_start = true
			#segment.modulate = Color(1.0, 0.0, 0.0)
		elif seg != num_segments - 1:
			# Middle Segments
			segment.segment_to_follow = previous_segment
			segment.is_end = false
			#segment.modulate = Color(0.0, 1.0, 0.0)
		else:
			# Last Segment
			segment.segment_to_follow = previous_segment
			#segment.modulate = Color(0.0, 0.0, 1.0)
		
		add_child(segment)
		previous_segment = segment
		
