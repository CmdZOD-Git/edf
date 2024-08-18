class_name Item extends Node2D

@onready var item_manager = $".."
@onready var actor:Actor = $"../.."

@export var item_resource:ItemResource

var range_area:Area2D
var draw_range_sprite:Sprite2D
var projectile:Projectile

var target_list:Array[Node2D] = []
var selected_target:Node2D = null
var target_refresh_timer:Timer

var spawn_list:Array[Node2D] = []

var cooldown_time:Timer
var is_primed:bool = true

func _ready() -> void:
	# Setting up area for target search
	if item_resource.area_size <= 0:
		print_debug("cannot work with area size 0 or less")
		return
		
	range_area = Area2D.new()
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	add_child(range_area)
	range_area.add_child(shape)
	range_area.set_monitorable(false)
	
	if actor.actor_stat.is_player == true:
		CollisionHelper.set_collision_scenario(range_area, CollisionHelper.Scenario.TARGETTING_ENEMY)
	else:
		CollisionHelper.set_collision_scenario(range_area, CollisionHelper.Scenario.TARGETTING_PLAYER)

	shape.shape = circle
	shape.debug_color = Color("RED", 0.10)
	circle.radius = item_resource.area_size
	
	if item_resource.draw_range:
		draw_range_sprite = Sprite2D.new()
		draw_range_sprite.texture = preload("res://circle_area_texture.tres")
		# Point 0 is the inside of the range
		# Point 1 is the outline of the range
		draw_range_sprite.texture.gradient.set_color(0, Color(item_resource.draw_range_color, 0 ) ) 
		draw_range_sprite.texture.gradient.set_color(1, Color(item_resource.draw_range_color, 0.2 ) )
		
		#draw_range_sprite.self_modulate = Color( item_resource.draw_range_color , 0.5 )
		draw_range_sprite.scale = Vector2(  2 * item_resource.area_size / 100 , 2 * item_resource.area_size / 100 )
		add_child(draw_range_sprite)
	
	# Setup fire cooldown
	cooldown_time = Timer.new()
	cooldown_time.wait_time = item_resource.cooldown_second
	cooldown_time.one_shot = true
	add_child(cooldown_time)
	
	# Setup target refresh timer so that closer target are considered
	target_refresh_timer = Timer.new()
	target_refresh_timer.wait_time = 1
	target_refresh_timer.one_shot = false
	target_refresh_timer.autostart = true
	add_child(target_refresh_timer)
	
	# Other Signal
	cooldown_time.timeout.connect(on_cooldown_timeout)
	target_refresh_timer.timeout.connect(on_target_refresh_timeout)
	actor.actor_radio.connect(on_actor_radio)
	range_area.body_entered.connect(on_body_entered)
	range_area.body_exited.connect(on_body_exited)
	
	# Initial target array setup
	target_list = range_area.get_overlapping_bodies()
	
func _process(_delta: float) -> void:
	if actor.is_active == false:
		return
	
	if item_resource.type == item_resource.Type.Weapon:
		if is_primed == true and selected_target == null:
			select_closest_target()
			
		if is_primed == true and not selected_target == null:
			if item_resource.hit_box_type == ItemResource.HitBoxType.PROJECTILE:
				fire_projectile(selected_target, global_position)
			elif item_resource.hit_box_type == ItemResource.HitBoxType.AREA:
				fire_projectile(selected_target, selected_target.global_position)
			is_primed = false
		
	elif item_resource.type == item_resource.Type.Spawner:
		if is_primed == true:
			spawn_in_range(item_resource.spawning_object)
			is_primed = false
			
	if is_primed == false and cooldown_time.is_stopped():
			cooldown_time.start()
		
func on_actor_radio(_data)-> void:
	pass
	
func on_cooldown_timeout() -> void:
	is_primed = true
	
func on_target_refresh_timeout() -> void:
	if target_list.size() > 0:
		select_closest_target()

func select_closest_target() -> void:
	var selected_target_distance:float
	
	# Find a target
	for item:Node2D in target_list:
		if not selected_target:
			selected_target = item
			selected_target_distance = item.global_position.distance_squared_to(global_position)
			continue
			
		var distance_to_target:float = item.global_position.distance_squared_to(global_position)

		if  distance_to_target < selected_target_distance:
			selected_target = item
			selected_target_distance = item.global_position.distance_squared_to(global_position)

func on_body_entered(body)->void:
	target_list.append(body)

func on_body_exited(body)->void:
	target_list.erase(body)
	if selected_target == body:
		selected_target = null
	

func fire_projectile(target, from ) -> void:
	# If target found, fire
	projectile = preload("res://projectile.tscn").instantiate()
	projectile.item_owner = actor
	projectile.shooting_item = self
	projectile.damage = item_resource.damage
	projectile.speed = item_resource.speed
	projectile.texture = item_resource.texture
	projectile.current_position = from
	projectile.direction = global_position.direction_to(target.global_position)
	projectile.radius = item_resource.hit_radius
	projectile.hit_max = item_resource.number_of_hit
	projectile.life_span_second = item_resource.hit_lifespan
	
	projectile.impact = item_resource.impact
	projectile.impact_random = item_resource.impact_random
	projectile.impact_random_framecount = item_resource.impact_random_framecount
	
	var applied_spray:float = randf_range( - item_resource.spray_degree , item_resource.spray_degree)
	projectile.direction = projectile.direction.rotated( deg_to_rad( applied_spray ) )
	add_child(projectile)

	actor.actor_radio.emit({"type" : "animation", "action" : ItemResource.Motion.keys()[item_resource.motion], "priority" : item_resource.priority } )
	actor.actor_radio.emit({"type" : "facing_mode" , "mode" : "focus" , "focused_item" : target })

func spawn_in_range(spawn_object:ActorStat) -> void:
	actor.text_box.text = "Spawn (%s/%s)" % [spawn_list.size() , item_resource.spawn_personal_limit]

	if spawn_list.size() >= item_resource.spawn_personal_limit:
		return
	
	var to_spawn:Actor = preload("res://actor_template.tscn").instantiate()
	to_spawn.actor_stat = spawn_object.duplicate()
	Global.main.add_child(to_spawn)
	spawn_list.append(to_spawn)
	
	to_spawn.actor_radio.connect(on_spawn_death)
	#to_spawn.tree_exiting.connect(func():spawn_list.erase(to_spawn)) # Used a signal instead
	
	var spawn_location:Vector2 = Vector2.from_angle(randf_range(- PI, PI))
	spawn_location *= item_resource.area_size
	to_spawn.global_position = global_position + spawn_location

func on_spawn_death(data) -> void:
	if data.type == "status" and data.status == "dead":
		spawn_list.erase(data.who)
