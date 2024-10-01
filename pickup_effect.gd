class_name PickupEffect extends Resource

enum Type {
	STAT_CHANGE,
	TRIGGER,
}

enum Stat {
	current_hitpoint,
	max_hitpoint,
}

enum Trigger {
	UPGRADE,
}

@export var type:Type

@export_category("Stat change")
@export var stat:Stat
@export var amout:float

@export_category("Trigger")
@export var trigger:Trigger

func picked_up(picker:Actor) -> void :
	if type == Type.STAT_CHANGE:
		picker.actor_stat[Stat.keys()[stat]] += amout
		picker.text_toast("HP %s" % [picker.actor_stat.current_hitpoint])
		
	elif type == Type.TRIGGER:
		var test_list:Array[UpgradeBundle]
		test_list.append_array(Global.player.gather_upgrade())
		#test_list.append(load("res://UpgradeBundle/damage_up_1.tres").duplicate())
		if test_list.size() > 0:
			Global.call_upgrade_panel.emit(Global.player, test_list)
		else:
			picker.text_toast("No upgrade left !")
