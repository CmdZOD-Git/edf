class_name Projectile extends Area2D

var damage:float

var texture:Texture:
	get:
		return $Sprite2D.texture
	set(new_texture):
		$Sprite2D.texture = new_texture

var direction:Vector2 = Vector2.RIGHT
var speed:float = 2
var current_position:Vector2 = Vector2.ZERO
var target_layer:int #Layer index to check
var hit_max:int = 1
var hit_current:int

var life_span_timer:Timer
var life_span_second:float = 1

var radius:float:
	set(x):
		$CollisionShape2D.shape.radius = x

var impact:Doodad.DoodadList
var impact_random:bool
var impact_random_framecount:int

var item_owner:Actor
var shooting_item:Node2D

@onready var collision_area:CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	global_position = current_position
	hit_current = hit_max
	
	area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)
	
	if item_owner.actor_stat.is_player == true:
		CollisionHelper.set_collision_scenario(self, CollisionHelper.Scenario.TARGETTING_ENEMY)
	else:
		CollisionHelper.set_collision_scenario(self, CollisionHelper.Scenario.TARGETTING_PLAYER)
	
	life_span_timer = Timer.new()
	life_span_timer.one_shot = true
	add_child(life_span_timer)
	life_span_timer.start(life_span_second)
	life_span_timer.timeout.connect(queue_free)

	#var masking_layer:String = "m %s %s %s" % [get_collision_mask_value(1), get_collision_mask_value(2), get_collision_mask_value(3)]
	#print(masking_layer)
	
func _physics_process(_delta: float) -> void:
	current_position += direction * speed
	global_position = current_position

func on_area_entered(_area):
	print("area")
	
func on_body_entered(body:Node2D):
	if body.has_signal("projectile_hit") and hit_current > 0 :
		body.emit_signal("projectile_hit", self)
		hit_current -= 1

		if  impact >= 0:
			var impact_doodad:Doodad = preload("res://doodad.tscn").instantiate()
			if impact_random == true and impact_random_framecount > 0:
				impact_doodad.make_random_anim(impact, impact_random_framecount)
			get_tree().root.get_node("Main").add_child(impact_doodad)
			impact_doodad.z_index = 5
			
			impact_doodad.global_position = lerp(global_position, body.global_position, 0.75)
			if impact_random == true and impact_random_framecount > 0:
				impact_doodad.play("random")
			else:
				impact_doodad.play(Doodad.DoodadList.keys()[impact])
	
	if hit_current <= 0:
		queue_free()
	
	
	if OS.is_debug_build():
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 5)
		label.text = "HIT"
		add_child(label)
