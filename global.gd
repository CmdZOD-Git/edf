extends Node

const MAX_ACTOR:int = 100
var is_main_paused:bool = false

@onready var main:Node2D = get_tree().root.get_node("Main")
@onready var player:Actor

@warning_ignore("unused_signal")
signal call_upgrade_panel(who:Actor, upgrade_bundle_list:Array[UpgradeBundle])
