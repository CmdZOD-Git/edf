class_name Item extends Node2D

@onready var item_manager = $".."
@onready var actor = $"../.."

@export var item_resource:ItemResource

var range_area:Area2D
var draw_range_sprite:Sprite2D
var cooldown_time:Timer
var projectile:Projectile

func _ready() -> void:
	# Setting up area for target search
	if item_resource.area_size > 0:
		range_area = Area2D.new()
		var shape = CollisionShape2D.new()
		var circle = CircleShape2D.new()
		add_child(range_area)
		range_area.add_child(shape)
		range_area.set_monitorable(false)
		range_area.set_collision_layer_value(1, false)
		range_area.set_collision_mask_value(1,false) # By default, only check enemy layer
		range_area.set_collision_mask_value(2,false) # By default, only check enemy layer
		range_area.set_collision_mask_value(3,true) # By default, only check enemy layer
		shape.shape = circle
		shape.debug_color = Color("RED", 0.10)
		circle.radius = item_resource.area_size
		
		if item_resource.draw_range:
			draw_range_sprite = Sprite2D.new()
			draw_range_sprite.texture = preload("res://circle_area_texture.tres")
			draw_range_sprite.self_modulate = Color("RED", 0.1)
			draw_range_sprite.scale = Vector2(  2 * item_resource.area_size / 100 , 2 * item_resource.area_size / 100 )
			add_child(draw_range_sprite)
	
	cooldown_time = Timer.new()
	add_child(cooldown_time)
	cooldown_time.wait_time = item_resource.cooldown_second
	cooldown_time.one_shot = true
	cooldown_time.start()
	
	actor.actor_radio.connect(on_actor_radio)
	cooldown_time.timeout.connect(on_cooldown_timeout)
	
func on_actor_radio(_data)-> void:
	pass
	
func on_cooldown_timeout() -> void:
	if item_resource.type == item_resource.Type.Weapon:
		var target:Node2D = find_target()
		if target:
			if item_resource.hit_box_type == ItemResource.HitBoxType.PROJECTILE:
				fire_projectile(target, global_position)
			elif item_resource.hit_box_type == ItemResource.HitBoxType.AREA:
				fire_projectile(target, target.global_position)
	
	cooldown_time.start()
	pass

func find_target() -> Node2D:
	var target_list:Array[Node2D] = range_area.get_overlapping_bodies()
	var selected_target:Node2D = null
	var selectecd_target_distance:float
	
	# Find a target
	for item:Node2D in target_list:
		if not selected_target:
			selected_target = item
			selectecd_target_distance = item.global_position.distance_squared_to(global_position)
			continue
			
		var distance_to_target:float = item.global_position.distance_squared_to(global_position)

		if  distance_to_target < selectecd_target_distance:
			selected_target = item
			selectecd_target_distance = item.global_position.distance_squared_to(global_position)
	
	return selected_target

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
	
	projectile.impact = item_resource.impact
	projectile.impact_random = item_resource.impact_random
	projectile.impact_random_framecount = item_resource.impact_random_framecount
	
	var applied_spray:float = randf_range( - item_resource.spray_degree , item_resource.spray_degree)
	projectile.direction = projectile.direction.rotated( deg_to_rad( applied_spray ) )
	add_child(projectile)

	actor.actor_radio.emit({"type" : "animation", "action" : ItemResource.Motion.keys()[item_resource.motion], "priority" : 5 } )
	actor.actor_radio.emit({"type" : "facing_mode" , "mode" : "focus" , "focused_item" : target })

func fire_area(target) -> void:
	#var attack_area:Area2D = Area2D.new()
	#var shape:CollisionShape2D = CollisionShape2D.new()
	#var circle:CircleShape2D = CircleShape2D.new()
	#add_child(attack_area)
	#attack_area.add_child(shape)
	#shape.shape = circle
	#
	#attack_area.set_monitorable(false)
	#shape.debug_color = Color("GREEN", 0.10)
	#circle.radius = item_resource.melee_area_size
	#
	#attack_area.set_collision_mask_value(1,false) # By default, only check enemy layer
	#attack_area.set_collision_mask_value(2,false) # By default, only check enemy layer
	#attack_area.set_collision_mask_value(3,true) # By default, only check enemy layer
	#
	#
	#attack_area.get_overlapping_bodies()
	
	actor.actor_radio.emit({"type" : "animation", "action" : ItemResource.Motion.keys()[item_resource.motion], "priority" : 5 } )
	actor.actor_radio.emit({"type" : "facing_mode" , "mode" : "focus" , "focused_item" : target })
