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
var piercing_max:int = 1
var piercing_current:int

var item_owner:Node2D
var shooting_item:Node2D

@onready var collision_area:CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	global_position = current_position
	piercing_current = piercing_max
	set_collision_mask_value(3, true)
	area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)
	
	#var masking_layer:String = "m %s %s %s" % [get_collision_mask_value(1), get_collision_mask_value(2), get_collision_mask_value(3)]
	#print(masking_layer)
	
func _physics_process(_delta: float) -> void:
	current_position += direction * speed
	global_position = current_position

func on_area_entered(_area):
	print("area")
	
func on_body_entered(body:Node2D):
	if body.has_signal("projectile_hit"):
		body.emit_signal("projectile_hit", self)
		piercing_current -= 1
	
	if piercing_current <= 0:
		queue_free()
	
	if OS.is_debug_build():
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 5)
		label.text = "HIT"
		add_child(label)
	
		
