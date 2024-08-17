class_name ActorStat extends Resource

enum DisplayMode {
	SPRITEFRAME,
	SCENE,
}

@export var is_player:bool = false
@export var terrain_collide = true
@export var can_grab:bool = false

@export var speed:float = 25
@export var max_hitpoint:float = 10
@export var current_hitpoint:float

@export_group("display")
@export var display_mode:DisplayMode = DisplayMode.SPRITEFRAME
@export var sprite_frame:SpriteFrames = load("res://SpriteFrame/squadleader_spriteframe.tres")
@export var scene_to_display:PackedScene = null

@export_group("item")
@export var item_list:Array[ItemResource]

