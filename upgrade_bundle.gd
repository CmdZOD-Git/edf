class_name UpgradeBundle extends Resource

enum UpgradeTag {
	PROJECTILE,
}

@export var title:String = "Default Upgrade Bundle"
@export var tag:Array[UpgradeTag]
@export  var upgrade_list:Array[UpgradeEffect]
@export var requirement:Array[UpgradeBundle] ## By default requirement is AND
