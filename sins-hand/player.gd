extends CharacterBody2D

@onready var sin = %SIN
@onready var dust_particles = %DustParticles

@export var reflection = false

func _process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	var is_sprinting : bool = Input.is_action_pressed("sprint")
	
	var colliding = move_and_collide(input.normalized() * (500.0 if is_sprinting else 300.0) * delta)
	if reflection and !colliding:
		print(position)
		position = input.normalized() * (500.0 if is_sprinting else 300.0) * delta
		#position.y *= -1
	
	%SIN.rotation = input.normalized().x * (0.35 if is_sprinting else 0.15)
	%Shadow.scale = Vector2(0.528, 0.198) * (1.05 + abs(input.normalized().x) * 0.05 if is_sprinting else 1.0 + abs(input.normalized().x) * 0.05)
	%Shadow.offset.x = -input.normalized().x * 20.0
	
	dust_particles.position.x = -input.normalized().x * 50.0
	
	if input:
		sin.direction = rotate_toward(sin.direction,  -atan2(input.x, input.y), 8.0 * delta)
	
	sin.set_state("idle" if input.is_zero_approx() else "move")
	
	var target_move_speed = 1.5 if is_sprinting else 1.0
	
	sin.move_speed = move_toward(sin.move_speed, target_move_speed, 5.0 * delta)
	dust_particles.emitting = is_sprinting
