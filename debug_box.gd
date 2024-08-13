extends Label

@onready var actor:Actor = $".."

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = "Input %.2v \n" % [actor.control_manager.direction]
	text += "Spd %s \n" % [actor.actor_stat.speed]
	text += "V %.2v \n" % [actor.velocity]
	text += "P %.2v \n" % [actor.position]
	text += "S %.2v \n" % [actor.get_node("AnimatedSprite2D").scale]
