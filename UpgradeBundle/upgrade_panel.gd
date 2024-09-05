extends Control

@export var upgrade_list:Array[UpgradeBundle]

@onready var container = $MarginContainer/ScrollContainer/VBoxContainer
@onready var upgrade_choice_template = preload("res://UpgradeBundle/upgrade_choice.tscn")

func _ready() -> void:
	for upgrade_bundle_item:UpgradeBundle in upgrade_list:
		var upgrade_choice_panel = upgrade_choice_template.instantiate()
		container.add_child(upgrade_choice_panel)
		
		upgrade_choice_panel.texture_rect.texture = upgrade_bundle_item.icon

		for upgrade_effect_item:UpgradeEffect in upgrade_bundle_item.upgrade_list:
			var label = Label.new()
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			label.text = upgrade_effect_item.description
			upgrade_choice_panel.label_container.add_child(label)
	
		
	container.get_child(0).grab_focus()
