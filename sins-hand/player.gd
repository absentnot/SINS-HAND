extends CharacterBody2D

@onready var sin = %SIN
@onready var dust_particles = %DustParticles

@export var reflection = false
@export var can_dust = true
@export var footprint = preload("res://scenes/footstep.tscn")

var canStep = true
var alternate_foot = false

func _process(delta):
	if !reflection:
		print("PLAYER GLOBAL:", global_position)
	var input = Input.get_vector("left", "right", "up", "down")
	var is_sprinting : bool = Input.is_action_pressed("sprint")
	
	var colliding = move_and_collide(input.normalized() * (500.0 if is_sprinting else 300.0) * delta)
	if reflection and !colliding:
		position = input.normalized() * (500.0 if is_sprinting else 300.0) * delta
		#position.y *= -1
	
	if canStep and input and !reflection:
		var footprint_inst = footprint.instantiate()
		
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
	
	if input:
		sin.direction = rotate_toward(sin.direction,  -atan2(input.x, input.y), 8.0 * delta)
	
	sin.set_state("idle" if input.is_zero_approx() else "move")
	
	var target_move_speed = 1.5 if is_sprinting else 1.0
	
	sin.move_speed = move_toward(sin.move_speed, target_move_speed, 5.0 * delta)
	
	if can_dust:
		dust_particles.emitting = is_sprinting

func tween_rotation(degree):
	var input = Input.get_vector("left", "right", "up", "down")
	var tw = create_tween()
	tw.tween_property(%SIN, "rotation", input.normalized().x * degree, 0.1)


func _on_timer_timeout():
	canStep = true
