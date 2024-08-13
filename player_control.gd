extends Node2D

@onready var controller = $".."
var input_direction:Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	input_direction = Input.get_vector("left","right","up","down")
	controller.direction = input_direction
