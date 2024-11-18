@tool
extends Node2D

@onready var foot_sprite_l = %FootSpriteL
@onready var foot_sprite_r = %FootSpriteR
@onready var body_sprite = %BodySprite
@onready var mouth_sprite = %MouthSprite
@onready var face_sprite_group = %FaceSpriteGroup
@onready var anchors = [%HornsSideAnchor, %HornsTopAnchor, %MouthAnchor, %EyesAnchor, %ArmLAnchor, %ArmRAnchor, %LegsAnchor]
@onready var animation_tree : AnimationTree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

@export_range(0.0, 360.0, 0.1, "radians") var direction : float = 4.713 : set = _set_direction

const HALF_PI : float = PI / 2.0
var move_speed : float = 1.0 : set = _set_move_speed

func _set_direction(value : float):
	if !is_inside_tree(): return
	direction = value

	var angle = wrapf(direction - HALF_PI, 0.0, TAU)
	#print(angle)
	if angle < 1.0 or angle >= 4.71:
		#print(angle)
		%HornSideBaseSpriteL.scale.x = -1
		%HornSideTipSpriteL.scale.x = -1
		%HornSideBaseSpriteR.scale.x = 1
		%HornSideTipSpriteR.scale.x = 1
		if angle > 6.1:
			%HornSideBaseSpriteL.scale.x = 1
			%HornSideTipSpriteL.scale.x = 1
	elif angle < 1.75:
		#print("FLIP")
		%HornSideBaseSpriteL.scale.x = 1
		%HornSideTipSpriteL.scale.x = 1
		%HornSideBaseSpriteR.scale.x = -1
		%HornSideTipSpriteR.scale.x = -1
	elif angle > 3.8:
		%HornSideBaseSpriteL.scale.x = -1
		%HornSideTipSpriteL.scale.x = -1
	else:
		%HornSideBaseSpriteL.scale.x = -1
		%HornSideTipSpriteL.scale.x = -1
		%HornSideBaseSpriteR.scale.x = -1
		%HornSideTipSpriteR.scale.x = -1
		
	if angle < 1.0 or angle > 4.71:
		#set side horn base visibility
		%HornSideBaseSpriteL.z_index = -5
		%HornSideBaseSpriteR.z_index = -5
		if angle > 5.0 or angle < 1.0:
			%HornSideBaseSpriteR.z_index = 3
		%HornSideTipSpriteR.z_index = 4
		%HornSideTipSpriteL.z_index = 6
		if angle > 5.3 or angle < 1.0:
			%HornSideTipSpriteL.z_index = -6
		#if angle < 1.5:
			#%
	#elif angle > 3.8:
		#%HornSideTipSpriteL.z_index = -6
		#pass
	elif angle < 1.75:
		%HornSideBaseSpriteL.z_index = -5
		%HornSideTipSpriteL.z_index = -6
		%HornSideBaseSpriteR.z_index = -5
		%HornSideTipSpriteR.z_index = -6
	else:
		
		%HornSideBaseSpriteR.z_index = -5
		%HornSideTipSpriteR.z_index = -6
		
		%HornSideBaseSpriteL.visible = true
		%HornSideBaseSpriteL.z_index = 3
		%HornSideTipSpriteL.z_index = 4
	
	if angle > 0.8 and angle < 3.8 or angle > 3.8 and angle < 5.0:
#		top horn zindexing
		%HornTopSpriteL.z_index = 4
		%HornTopSpriteR.z_index = 3
	else:
		%HornTopSpriteL.z_index = 3
		%HornTopSpriteR.z_index = 4
		
	
	#print(%EyeSpriteR.scale)
	if angle > 3.1 or angle < 0.5:
		%MouthSprite.z_index = 3
		#if angle > 6.7 or angle < 0.1:
			#%MouthSprite.scale.x = max(0.0, %MouthSprite.scale.x - 0.06)
		#if angle < 3.7 and angle > 3.3:
			#%MouthSprite.scale.x = min(1.0, %MouthSprite.scale.x + 0.06)
	else:
		%MouthSprite.z_index = -2
		
	if angle > 3.0 and angle < 5.2:
		%EyeSpriteL.z_index = 3
		#if angle > 5.0:
			#%EyeSpriteL.scale.x = max(0.0, %EyeSpriteL.scale.x - 0.06)
		#if angle < 3.4:
			#%EyeSpriteL.scale.x = min(1.0, %EyeSpriteL.scale.x + 0.06)
	else:
		%EyeSpriteL.z_index = -2
		
		
	if angle > 3.9 or angle < 1.0:
		%EyeSpriteR.z_index = 3
		#if angle > 0.8 and angle < 1.0:
			#%EyeSpriteR.scale.x = max(0.0, %EyeSpriteR.scale.x - 0.06)
		#if angle < 4.3 and angle > 3.9:
			#%EyeSpriteR.scale.x = min(1.0, %EyeSpriteR.scale.x + 0.06)
	else:
		%EyeSpriteR.z_index = -2
	
	
	if angle > 5.0 or angle < 2.0:
		$Visual/ArmL/ArmLine.scale.x = -1.0
		%ArmL.z_index = -2
	else:
		$Visual/ArmL/ArmLine.scale.x = 1.0
		%ArmL.z_index = 0
		
	if angle > 4.0 or angle < 1.0:
		$Visual/ArmR/ArmLine.scale.x = -1.0
		$Visual/ArmR/ArmLine.z_index = 0
	else:
		$Visual/ArmR/ArmLine.scale.x = 1.0
		$Visual/ArmR/ArmLine.z_index = -2
		
	for anchor in anchors:
		anchor.rotation = angle
		if anchor == %MouthAnchor:
			anchor.rotation -= 4.71
			

	%ArmLAnchor.rotation = angle + 0.6
	%ArmRAnchor.rotation = angle + 0.74
	
	#foot_sprite_l.rotation = angle + 0.5
	#foot_sprite_r.rotation = angle - 0.5

	var z_index_value = -1 if angle > HALF_PI and angle < PI + HALF_PI else 1
	
	face_sprite_group.z_index = z_index_value
	body_sprite.z_index = 1.0 - z_index_value
	
	if angle > 1.0 and angle < 4.5:
		#print(%FootSpriteL.rotation)
		#print(%FootSpriteL.scale)
		%FootSpriteL.scale = Vector2(1.0, 1.0)
		%FootSpriteL.rotation = 0.0
	else:
		#%FootSpriteL.scale.x = -1.0
		%FootSpriteL.scale = Vector2(-1.0, 1.0)
		%FootSpriteL.rotation = 0.0
		
	if angle < 6.0 and angle > 3.0:
		%FootSpriteR.scale = Vector2(1.0, 1.0)
		%FootSpriteR.rotation = 0.0
	else:
		%FootSpriteR.scale = Vector2(-1.0, 1.0)
		%FootSpriteR.rotation = 0.0

func _set_move_speed(value : float):
	move_speed = value
	animation_tree.set("parameters/StateMachine/move/MoveSpeed/scale", move_speed)
	


func set_state(state : String):
	state_machine.travel(state)

#func _process(delta):
	#direction += delta
