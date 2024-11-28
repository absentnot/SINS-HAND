extends Node2D

@onready var main = get_parent().get_parent().get_parent().get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	main.updatePickable()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
