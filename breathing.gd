extends Node2D

@onready var parent:Node2D = $".."
var parent_object_property:String = "scale:x" #must be provided by the animation manager

var breathing_force:float = 0.15
var amount_to_apply:float = 0
var amount_total:float = 0
var amount_sub_total:float = 0 # Always go in the same way as amount_target
var amount_target:float
var amount_current:float
var mult_side:int = 1
var spring_tween:Tween
var duration:float
var node_path:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if spring_tween and spring_tween.is_valid():
		amount_to_apply = amount_current - amount_sub_total
		amount_sub_total += amount_to_apply
		amount_to_apply = mult_side * amount_to_apply
		amount_total += amount_to_apply
		
		var value_to_watch:float = parent.get_indexed(parent_object_property)
		var value_to_set:float = value_to_watch
		
		if value_to_watch < 0:
			value_to_set -= amount_to_apply
			parent.set_indexed(parent_object_property, value_to_set)		
		else:
			value_to_set += amount_to_apply
			parent.set_indexed(parent_object_property, value_to_set)
		
	if not spring_tween or not spring_tween.is_valid():
		if amount_total >= 0:
			mult_side = -1
		else:
			mult_side = 1
		amount_target = randf_range(0 , breathing_force )
		duration = 1 * randf_range(0.90,1.10)
		amount_current = 0
		amount_sub_total = 0
		amount_to_apply = 0
		spring_tween = self.create_tween()
		spring_tween.set_ease(Tween.EASE_IN_OUT)
		spring_tween.set_trans(Tween.TRANS_CUBIC)
		spring_tween.tween_property(self,"amount_current", amount_target, duration)
