class_name Actor extends CharacterBody2D

@export var actor_stat:ActorStat
@onready var control_manager = $ControlManager
@onready var collision_box:CollisionShape2D = $CollisionBox
@onready var animation_manager:Node2D = $AnimationManager
@onready var item_manager = $ItemManager
@onready var text_box = $TextBox
var direction:Vector2 = Vector2.ZERO
var collision_push:Vector2 = Vector2.ZERO

signal actor_radio(data:Dictionary)
signal projectile_hit(projectile)

func _ready() -> void:
	actor_stat.current_hitpoint = actor_stat.max_hitpoint
	
	projectile_hit.connect(on_hit)
	actor_radio.connect(on_radio)
	
	# Camera
	if actor_stat.is_player == true:
		var camera = Camera2D.new()
		camera.zoom = Vector2 (1,1) * 3
		add_child(camera)
	
	# Controller
	var control_logic
	if actor_stat.is_player == true:
		control_logic = load("res://player_control.tscn").instantiate()
	else:
		control_logic = load("res://detect_and_move_control.tscn").instantiate()
	control_manager.add_child(control_logic)
	
	# Collision and mask
	if actor_stat.is_player == true:
		CollisionHelper.set_collision_scenario(self, CollisionHelper.Scenario.PLAYER)
	else:
		CollisionHelper.set_collision_scenario(self, CollisionHelper.Scenario.ENEMY)
	
	# item
	for item in actor_stat.item_list:
		var item_to_add:Item = preload("res://Item/item_template.tscn").instantiate()
		item_to_add.item_resource = item
		item_manager.add_child(item_to_add)
		
func _physics_process(_delta: float) -> void:
	
	if not control_manager or not control_manager.direction:
		direction = Vector2.ZERO
	else:
		direction = control_manager.direction
	
	if direction:
		velocity = direction * actor_stat.speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func on_radio(data) -> void:
	match data.type:
		"status":
			if data.status == "dead":
				die()
	
func on_hit(projectile) -> void:
	take_damage(projectile.damage)

func text_toast(text:String) -> void:
	var label = Label.new()
	var tween = create_tween()
	label.text = text
	label.position.y = -15
	label.add_theme_font_size_override("font_size", 8 )
	tween.set_parallel(true)
	tween.tween_property( label , "position:y", -40 , 1 )
	tween.tween_property( label , "self_modulate:a", 0 , 1 )
	tween.set_parallel(false)
	tween.tween_callback(label.queue_free)
	label.z_index = 10
	add_child(label)

func take_damage(damage:float) -> void:
	actor_stat.current_hitpoint -= damage
	if actor_stat.current_hitpoint <= 0:
		text_toast("I die !")
		actor_radio.emit({"type" : "status" , "status" : "dead" })
	else:
		text_toast("HP %s" % [actor_stat.current_hitpoint])

func die() -> void:
	collision_box.set_deferred("disabled", true)
	actor_stat.speed = 0
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "self_modulate:a", 0, 5)
	actor_radio.emit({"type" : "animation", "action" : "death", "priority" : 10 , "hold" : true } )
	await get_tree().create_timer(5).timeout
	queue_free()
