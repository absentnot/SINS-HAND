extends CharacterBody2D

@onready var sin = %SIN
@onready var dust_particles = %DustParticles

@export var reflection = false
@export var can_dust = true
@export var footprint = preload("res://scenes/footstep.tscn")

@export var closestGate: Node2D

var canStep = true
var alternate_foot = false
var push_force = 250.0
var shake_dampen = 300.0
var move_speed = 300.0
var sprint_speed = 500.0

@onready var parent_level = get_parent()

func _ready():
	randomize()
	
func _process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	var is_sprinting : bool = Input.is_action_pressed("sprint")
	
#	camera offsetting when near gate
	if closestGate and position.distance_to(closestGate.position) < 1100.0 and position.distance_to(closestGate.position) > 300.0:
		$Camera2D.min_value = -abs(position.distance_to(closestGate.position) - 1100.0) / shake_dampen
		$Camera2D.max_value = abs(position.distance_to(closestGate.position) - 1100.0) / shake_dampen
		print($Camera2D.offset)
		$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(max(1.0 - abs(position.distance_to(closestGate.position) - 1100.0) / 1100.0, 0.5), max(1.0 - abs(position.distance_to(closestGate.position) - 1100.0) / 1100.0, 0.5)), 0.1)
		$Camera2D.offset_override = lerp($Camera2D.offset_override, Vector2(0.0, 0.0), 0.02)
	elif closestGate and position.distance_to(closestGate.position) < 300.0:
		$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(1.35, 1.35), 0.01)
		$Camera2D.offset_override = lerp($Camera2D.offset_override, Vector2(0.0, -150.0), 0.02)
	else:
		$Camera2D.min_value = 0.0
		$Camera2D.max_value = 0.0
		
	if canStep and input and !reflection:
		var footprint_inst = footprint.instantiate()
		
		if parent_level.level == 0:
			$VoidFootsteps.pitch_scale = randf_range(0.85, 1.15)
			$VoidFootsteps.play()
		elif parent_level.level == 1:
			$LimboFootsteps.pitch_scale = randf_range(0.85, 1.15)
			$LimboFootsteps.play()
			
		if alternate_foot:
			footprint_inst.set_angle(sin.direction + PI + 0.4)
			footprint_inst.position.x = position.x + 20.0 * input.y * -int(alternate_foot)
			footprint_inst.position.y = position.y + 50 + 20.0 * input.x * int(alternate_foot)
		else:
			footprint_inst.set_angle(sin.direction + PI - 0.4)
			footprint_inst.position.x = position.x + 20.0 * input.y * -int(alternate_foot)
			footprint_inst.position.y = position.y + 50 + 20.0 * input.x * int(alternate_foot)
		get_parent().add_child(footprint_inst)
		
		canStep = false
		alternate_foot = !alternate_foot
	
	if is_sprinting:
		tween_rotation(0.35)
	else:
		tween_rotation(0.15)
	%Shadow.scale = Vector2(0.528, 0.198) * (1.05 + abs(input.normalized().x) * 0.05 if is_sprinting else 1.0 + abs(input.normalized().x) * 0.05)
	%Shadow.offset.x = -input.normalized().x * 20.0
	
	dust_particles.position.x = -input.normalized().x * 50.0
	
	if Input.is_action_pressed("grab") and !reflection:
		# Get the screen size (viewport dimensions)
		var screen_size = get_viewport().get_visible_rect().size
		var inverse_target = position + get_viewport().get_mouse_position() - screen_size - Vector2(210.0, 30.0) + (get_viewport().get_camera_2d().get_screen_center_position() - position) # adjustment for camera offset
		var mouse_dir = (inverse_target - position).normalized()
		sin.direction = rotate_toward(sin.direction, -atan2(mouse_dir.x, mouse_dir.y), 10.0 * delta)
	
		
	if input:
		sin.direction = rotate_toward(sin.direction, -atan2(input.x, input.y), 8.0 * delta)
	
	
	
	sin.set_state("idle" if input.is_zero_approx() else "move")
	
	var target_move_speed = 1.5 if is_sprinting else 1.0
	
	sin.move_speed = move_toward(sin.move_speed, target_move_speed, 5.0 * delta)
	
	if can_dust:
		dust_particles.emitting = is_sprinting

func _physics_process(delta):
	#if !reflection:
		#print("PLAYER GLOBAL:", global_position)
	var input = Input.get_vector("left", "right", "up", "down")
	var is_sprinting : bool = Input.is_action_pressed("sprint")
	
	velocity = input.normalized() * (sprint_speed if is_sprinting else move_speed)
	#print(velocity)
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_impulse(-c.get_normal() * push_force * (1.5 if is_sprinting else 1.0))
	#if reflection and !colliding:
		#position = input.normalized() * (500.0 if is_sprinting else 300.0) * delta
		#position.y *= -1
	
	

func tween_rotation(degree):
	var input = Input.get_vector("left", "right", "up", "down")
	var tw = create_tween()
	tw.tween_property(%SIN, "rotation", input.normalized().x * degree, 0.1)


func _on_timer_timeout():
	canStep = true


func _on_player_area_area_entered(area):
	if area.get_name() == "GateLocalArea":
		move_speed = 90
		sprint_speed = 150


func _on_player_area_area_exited(area):
	if area.get_name() == "GateLocalArea":
		move_speed = 300
		sprint_speed = 500
