class_name ItemResource extends Resource

enum Type {
	Weapon,
}

enum Motion {
	fire,
	melee,
}

@export var area_size:float
@export var cooldown_second:float
@export var type:Type
@export var texture:Texture2D
@export var damage:float
@export var spray_degree:float = 0
@export var draw_range:bool
@export var piercing:int = 1
@export var motion:Motion = Motion.fire
