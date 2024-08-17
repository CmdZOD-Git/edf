extends Node2D

const MAX_ENEMY:int = 100

@onready var main = get_tree().root.get_node("Main")
var enemy_spawn_timer:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# dont start too soon
	await main.ready
	
	# Signal
	
	# Timer
	enemy_spawn_timer = Timer.new()
	enemy_spawn_timer.wait_time = 0.1
	enemy_spawn_timer.autostart = true
	enemy_spawn_timer.timeout.connect(spawn_enemy)
	add_child(enemy_spawn_timer)
	
	
	# spawn player
	var player:Actor
	player = preload("res://actor_template.tscn").instantiate()
	player.actor_stat = load("res://ActorStat/player.tres").duplicate()
	main.add_child(player)
	player.global_position = Vector2(200,128)
	
	 # spawn test_item pistol
	var test_item:Item = preload("res://Item/item_template.tscn").instantiate()
	test_item.item_resource = load("res://Item/pistol_gun_itemresource.tres").duplicate()
	#player.item_manager.add_child(test_item)
	
	# spawn test_item melee
	var test_item_2:Item = preload("res://Item/item_template.tscn").instantiate()
	test_item_2.item_resource = load("res://Item/melee_strike.tres").duplicate()
	#player.item_manager.add_child(test_item_2)
	
	# spawn enemies
	for i in range(MAX_ENEMY):
		spawn_enemy()
		
func spawn_enemy() -> void:
	if get_tree().root.get_node("Main").get_child_count() >= MAX_ENEMY:
		return
	
	var enemy_spawn:Actor = preload("res://actor_template.tscn").instantiate()
	enemy_spawn.actor_stat = load("res://ActorStat/scarab_lv1.tres").duplicate()
	var randx:int = randi_range( 10, 600 )
	var randy:int = randi_range( 10, 450 )
	main.add_child(enemy_spawn)
	enemy_spawn.global_position = Vector2( randx , randy )
	
	 # Give enemy bite
	var weapon_item:Item = preload("res://Item/item_template.tscn").instantiate()
	weapon_item.item_resource = load("res://Item/scarab_melee_strike.tres").duplicate()
	enemy_spawn.item_manager.add_child(weapon_item)
