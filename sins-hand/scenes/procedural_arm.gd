extends Node2D


@export var arm_segment: PackedScene
@export var arm_length = 5
@export var num_segments = 7
@export var arm_side = "left"

var segments = []
var player_node

# Called when the node enters the scene tree for the first time.
func _ready():
	player_node = get_parent().get_parent().get_parent()
	if !player_node.reflection:
		generate_arm()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Anchor.position = get_viewport().get_mouse_position()
	#print("ANCHOR GLOBAL POSITION:", $Anchor.global_position)"res://scenes/arm_segment.tscn"
	pass

func generate_arm():
	var anchor_pos = $Anchor.position
	var previous_segment = $Anchor
	for seg in range(num_segments):
		var segment = arm_segment.instantiate()
		
		segment.set_segment(Vector2((seg) * arm_length,0.0), Vector2((seg + 1) * arm_length, 0.0))
		
		if seg == 0:
			# First Segment
			segment.anchor = $Anchor
			segment.is_start = true
			segment.is_end = false
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
			segment.get_child(0).visible = true #GET HAND
			
			
		
		segment.side = arm_side
		segment.player_node = player_node
		if seg > 0:
			previous_segment.following_segment = segment
		player_node.get_parent().add_child.call_deferred(segment)
		#segments.append(segment)
		#print("NEW")	
		previous_segment = segment
		
		
