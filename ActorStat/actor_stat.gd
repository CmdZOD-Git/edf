class_name ActorStat extends Resource

enum DisplayMode {
	SPRITEFRAME,
	SCENE,
}

@export var is_player:bool = false
@export var terrain_collide = true

@export var can_grab:bool = false
@export var grab_range:float = 20

@export var speed:float = 25
@export var max_hitpoint:float = 10
@export var current_hitpoint:float
@export var hitbox_size:Vector2 = Vector2(13,7)

@export_group("display")
@export var display_mode:DisplayMode = DisplayMode.SPRITEFRAME
@export var sprite_frame:SpriteFrames = load("res://SpriteFrame/squadleader_spriteframe.tres")
@export var scene_to_display:PackedScene = null

@export_group("item")
@export var item_list:Array[ItemResource]

@export_group("pickup")
@export var is_pickup:bool = false
@export var pickup_effect_list:Array[PickupEffect]

