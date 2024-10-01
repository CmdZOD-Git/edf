extends Node2D

var enemy_spawn_timer:Timer
@onready var main = Global.main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# dont start too soon
	await main.ready
	
	# Signal
	
	# Timer
	enemy_spawn_timer = Timer.new()
	enemy_spawn_timer.wait_time = 0.1
	enemy_spawn_timer.autostart = true
	#enemy_spawn_timer.timeout.connect(spawn_enemy)
	add_child(enemy_spawn_timer)
	
	
	# spawn player
	var player:Actor
	player = preload("res://actor_template.tscn").instantiate()
	player.actor_stat = load("res://ActorStat/player.tres").duplicate()
	main.add_child(player)
	player.global_position = Vector2(200,128)
	
	# spawn pickup
	#for i in range(5):
		#var pickup:Actor
		#pickup = preload("res://actor_template.tscn").instantiate()
		#pickup.actor_stat = load("res://Pickup/health_pickup.tres").duplicate()
		#main.add_child(pickup)
		#pickup.global_position = Vector2(230 + randi_range(-40, 40) ,140 + randi_range(-40, 40) ) 
	
	# spawn enemies
	#for i in range(Global.MAX_ACTOR):
		#var to spawn = load("res://ActorStat/scarab_lv1.tres")
		#spawn_enemy(to_spawn)
		
	for i in range(1):
		var to_spawn = load("res://ActorStat/spawner_lv1.tres")
		spawn_enemy(to_spawn)
		
	# Instant spawn upgrade panel
	#var test_list:Array[UpgradeBundle]
	#test_list.append(load("res://UpgradeBundle/damage_up_1.tres").duplicate())
	#test_list.append(load("res://UpgradeBundle/damage_up_2.tres").duplicate())
	#Global.call_upgrade_panel.emit(player, test_list)
	
	# spawn instant upgrade pickup
	for i in range(3):
		var pickup:Actor
		pickup = preload("res://actor_template.tscn").instantiate()
		pickup.actor_stat = load("res://Pickup/upgrade_pickup.tres").duplicate()
		main.add_child(pickup)
		pickup.global_position = Vector2(230 + randi_range(-40, 40) ,140 + randi_range(-40, 40) ) 
		
func spawn_enemy(data:ActorStat) -> void:
	if get_tree().root.get_node("Main").get_child_count() >= Global.MAX_ACTOR:
		return
	
	var enemy_spawn:Actor = preload("res://actor_template.tscn").instantiate()
	enemy_spawn.actor_stat = data.duplicate()
	var randx:int = randi_range( 10, 600 )
	var randy:int = randi_range( 10, 450 )
	main.add_child(enemy_spawn)
	enemy_spawn.global_position = Vector2( randx , randy )
