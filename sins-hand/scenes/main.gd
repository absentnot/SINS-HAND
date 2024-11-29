extends Node2D

var held_object = null
var mouse_speed = 5.0

@onready var current_level = %Void
@export var levels : Array[PackedScene]
var level = 0

func _unhandled_input(event):
	if event.is_action_released("grab") and held_object:
		print("DROP!")
		held_object.drop(Input.get_last_mouse_velocity() * mouse_speed)
		held_object = null

func _ready():
	updatePickable()
	updateGate()
	current_level.get_tree().paused = true

func updatePickable():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.connect("clicked", _on_pickable_clicked)
		
func updateGate():
	for node in get_tree().get_nodes_in_group("gate"):
		node.connect("gateEntered", whiteTransition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()

func nextLevel():
	level += 1
	current_level.queue_free()
	var nextLevel_inst = levels[level].instantiate()
	current_level = nextLevel_inst
	%MainViewport.add_child(current_level)
	
	if level == 1:
		$Music.get_stream_playback().switch_to_clip_by_name("Limbo Music Loop")	
	

func blackTransition():
	current_level.get_tree().paused = false
	%BlackTransition.modulate.a = 1.0
	var tw = create_tween()
	tw.tween_property(%BlackTransition, "modulate:a", 0.0, 3.0)

func whiteTransition():
	print("TRANSITION")
	%WhiteTransition.modulate.a = 0.0
	
	if level == 0:
		$Atmosphere.get_stream_playback().switch_to_clip_by_name("Limbo Atmosphere")
		
	var tw = create_tween()
	tw.tween_property(%WhiteTransition, "modulate:a", 1.0, 1.5)
	tw.tween_callback(nextLevel)
	tw.tween_property(%WhiteTransition, "modulate:a", 0.0, 1.5)


func _on_hud_start_game():
	blackTransition()
	var tw = create_tween()
	tw.tween_property($Atmosphere, "volume_db", 0, 1.0)
