class_name UpgradeBundle extends Resource

enum UpgradeTag {
	PROJECTILE,
}

@export var title:String = "Default Upgrade Bundle"
var holder:Node ## Where does the bundle come from (can't use "owner" word because it's in godot namespace)
@export var tag:Array[UpgradeTag]
@export  var upgrade_list:Array[UpgradeEffect]
@export var requirement:Array[UpgradeBundle] ## By default requirement is AND
@export var icon:Texture2D = preload("res://Texture/placeholder_texture.tres")
