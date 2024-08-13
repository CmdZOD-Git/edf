extends Node2D

@onready var controller = $".."
@export var area_size:float = 100
@export var draw_range:bool
var range_area:Area2D
var draw_range_sprite:Sprite2D
var cooldown_timer:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if area_size > 0:
		range_area = Area2D.new()
		var shape = CollisionShape2D.new()
		var circle = CircleShape2D.new()
		add_child(range_area)
		range_area.add_child(shape)
		range_area.set_collision_mask_value(1,false)
		range_area.set_collision_mask_value(2,true) # By default, only check player layer
		range_area.set_collision_mask_value(3,false)
		shape.shape = circle
		circle.radius = area_size
		
		if draw_range:
			draw_range_sprite = Sprite2D.new()
			draw_range_sprite.texture = preload("res://circle_area_texture.tres")
			draw_range_sprite.self_modulate = Color("CHARTREUSE", 0.1)
			draw_range_sprite.scale = Vector2(  2 * area_size / 100 , 2 * area_size / 100 )
			add_child(draw_range_sprite)
	
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.wait_time = 1
	cooldown_timer.one_shot = false
	cooldown_timer.start()
	cooldown_timer.timeout.connect(on_cooldown_timeout)
	
	

func on_cooldown_timeout():
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
		controller.direction =  Vector2.ZERO
	else:
		controller.direction = global_position.direction_to(selected_target.global_position)
	
	
	
