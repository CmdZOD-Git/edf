class_name Item extends Node2D

@onready var item_manager = $".."
@onready var actor = $"../.."

@export var item_resource:ItemResource

var range_area:Area2D
var draw_range_sprite:Sprite2D
var cooldown_time:Timer
var projectile:Projectile

func _ready() -> void:
	if item_resource.area_size > 0:
		range_area = Area2D.new()
		var shape = CollisionShape2D.new()
		var circle = CircleShape2D.new()
		add_child(range_area)
		range_area.add_child(shape)
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
		fire_projectile()
	cooldown_time.start()
	pass

func fire_projectile() -> void:
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
			
	if not selected_target:
		return
	
	# If target found, fire
	projectile = preload("res://projectile.tscn").instantiate()
	projectile.item_owner = actor
	projectile.shooting_item = self
	projectile.damage = item_resource.damage
	projectile.texture = item_resource.texture
	projectile.current_position = global_position
	projectile.direction = global_position.direction_to(selected_target.global_position)
	var applied_spray:float = randf_range( - item_resource.spray_degree , item_resource.spray_degree)
	projectile.direction = projectile.direction.rotated( deg_to_rad( applied_spray ) )
	add_child(projectile)

	actor.actor_radio.emit({"type" : "animation", "action" : ItemResource.Motion.keys()[item_resource.motion], "priority" : 5 } )
	actor.actor_radio.emit({"type" : "facing_mode" , "mode" : "focus" , "focused_item" : selected_target })
