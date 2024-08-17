class_name ItemResource extends Resource

enum Type {
	Weapon,
}

enum HitBoxType {
	PROJECTILE,
	AREA,
}

enum Motion {
	fire,
	melee,
}

@export var title:String = "default gun"
@export var type:Type
@export var hit_box_type:HitBoxType = HitBoxType.PROJECTILE
@export var cooldown_second:float
@export var damage:float
@export var number_of_hit:int = 1
@export var texture:Texture2D
@export var hit_radius:float = 5
@export var hit_lifespan:float = 1

@export_category("Range")
@export var area_size:float ## Range of the search area for target
@export var draw_range:bool
@export var draw_range_color:Color = Color.RED

@export_category("Animation")
@export var motion:Motion = Motion.fire
@export var priority:int = 5

@export_category("firing projectile only")
@export var speed:float
@export var spray_degree:float = 0

@export_category("impact")
@export var impact:Doodad.DoodadList
@export var impact_random:bool = false
@export var impact_random_framecount:int
