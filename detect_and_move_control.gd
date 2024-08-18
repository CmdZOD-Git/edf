extends Node2D

@onready var controller = $".."
@export var area_size:float = 100
@export var draw_range:bool
var range_area:Area2D
var draw_range_sprite:Sprite2D
var cooldown_timer:Timer

var target_list:Array[Node2D]
var selected_target:Node2D = null
var selectecd_target_distance:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setting up area
	if area_size > 0:
		range_area = Area2D.new()
		var shape = CollisionShape2D.new()
		var circle = CircleShape2D.new()
		add_child(range_area)
		range_area.add_child(shape)
		range_area.monitorable = false
		range_area.set_collision_mask_value(1,false)
		range_area.set_collision_mask_value(2,true) # By default, only check player layer
		range_area.set_collision_mask_value(3,false)
		shape.shape = circle
		circle.radius = area_size
		shape.debug_color = Color("SPRING_GREEN", 0.01)
		
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
	
	# signal
	range_area.body_entered.connect(on_entered)
	range_area.body_exited.connect(on_exited)
	
	# First filling
	target_array_init()

func on_cooldown_timeout():
	if not selected_target:
		controller.direction =  Vector2.ZERO
	else:
		controller.direction = global_position.direction_to(selected_target.global_position)

func target_array_init() -> void:
	target_list = range_area.get_overlapping_bodies()
	
	# Find a target
	for item:Node2D in target_list:
		target_wrapper(item)

func on_entered(body) -> void:
	target_list.append(body)
	target_wrapper(body)
	
func on_exited(body) -> void:
	target_list.erase(body)

func target_wrapper(body) -> void:
	call_deferred("target_if_closer", body)
	#target_if_closer(body)

func target_if_closer(body) -> void:
	if not selected_target:
		selected_target = body
		selectecd_target_distance = body.global_position.distance_squared_to(global_position)
		
	var distance_to_target:float = body.global_position.distance_squared_to(global_position)

	if  distance_to_target < selectecd_target_distance:
		selected_target = body
		selectecd_target_distance = body.global_position.distance_squared_to(global_position)
