class_name UpgradeEffect extends Resource

## This is the UpgradeEffect template
## Real effect must extend this class and overide the apply method

enum Target {
	Actor,
	Item,
	Projectile,
}

enum Timing {
	BASE,
	MULT,
	POWER,
	FINAL,
}

@export var title:String
@export var description:String
@export var icon:Texture

@export var target:Target
@export var timing:Timing = Timing.BASE

@export var amount:float

func _apply(_to_what):
	pass
