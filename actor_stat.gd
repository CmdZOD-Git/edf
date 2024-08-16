class_name ActorStat extends Resource

@export var is_player:bool = false
@export var terrain_collide = true
@export var can_grab:bool = false

@export var speed:float = 25
@export var max_hitpoint:float = 10
@export var current_hitpoint:float

@export var sprite_frame:SpriteFrames = load("res://SpriteFrame/squadleader_spriteframe.tres")
