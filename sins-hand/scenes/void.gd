extends Node2D

@onready var main = get_parent().get_parent().get_parent().get_parent()
@onready var player = get_node_or_null("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	main.updatePickable()
	main.updateGate()
	player.closestGate = $GATE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
