class_name ItemResource extends Resource

enum Type {
	Weapon,
	Spawner,
}

enum HitBoxType {
	PROJECTILE,
	AREA,
}

enum Motion {
	fire,
	melee,
	spawn,
}

@export var title:String = "default gun"
@export var type:Type
@export var hit_box_type:HitBoxType = HitBoxType.PROJECTILE
@export var cooldown_second:float

@export_group("weapon related")
@export var damage:float
@export var number_of_hit:int = 1
@export var texture:Texture2D
@export var hit_radius:float = 5
@export var hit_lifespan:float = 1

@export_group("upgrade")
@export var available_upgrade_bundle:Array[UpgradeBundle]
var selected_upgrade_bundle:Array[UpgradeBundle]
var selected_upgrade_effect:Array[UpgradeEffect]

@export_group("Range")
@export var area_size:float = 10 ## Range of the search area for target
@export var draw_range:bool
@export var draw_range_color:Color = Color.RED

@export_group("Animation")
@export var motion:Motion = Motion.fire
@export var priority:int = 5

@export_group("firing projectile only")
@export var speed:float
@export var spray_degree:float = 0

@export_group("firing projectile only")
@export var spawning_object:ActorStat
@export var spawn_personal_limit:int = 0

@export_group("impact")
@export var impact:Doodad.DoodadList
@export var impact_random:bool = false
@export var impact_random_framecount:int
