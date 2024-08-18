class_name PickupEffect extends Resource

enum Type {
	STAT_CHANGE,
}

enum Stat {
	current_hitpoint,
	max_hitpoint,
}

@export var type:Type
@export var stat:Stat
@export var amout:float

func picked_up(picker:Actor) -> void :
	if type == Type.STAT_CHANGE:
		picker.actor_stat[Stat.keys()[stat]] += amout
		picker.text_toast("HP %s" % [picker.actor_stat.current_hitpoint])
