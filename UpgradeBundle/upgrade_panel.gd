extends Control

## Reminder of how the system works
## Upgrade panel
##	 	↳ Upgrade bundle
##			 ↳ Upgrade choice
##			 		↳ Upgrade effect
##
## - upgrade panel trigger is requested through a global signal
## - the upgrade bundle list given to the signal is already baked
## - upgrade bundle list comes from actor
## - upgrade bundle can unlock new upgrade when unlocked
## - upgrade bundle can have requirement (and/or)

@onready var container = $MarginContainer/ScrollContainer/VBoxContainer
@onready var upgrade_choice_template = preload("res://UpgradeBundle/upgrade_choice.tscn")

func _ready() -> void:
	Global.call_upgrade_panel.connect(show_panel)
	
func show_panel(who:Actor, upgrade_bundle_list:Array[UpgradeBundle]) -> void:
	if get_tree().paused == false:
		get_tree().paused = true
		visible = true
		process_mode = PROCESS_MODE_WHEN_PAUSED
		
	for upgrade_bundle_item:UpgradeBundle in upgrade_bundle_list:
		var upgrade_choice_panel = upgrade_choice_template.instantiate()
		upgrade_choice_panel.button_up.connect(choice_made.bind(upgrade_bundle_item))
		container.add_child(upgrade_choice_panel)
		
		upgrade_choice_panel.texture_rect.texture = upgrade_bundle_item.icon

		for upgrade_effect_item:UpgradeEffect in upgrade_bundle_item.upgrade_list:
			var label = Label.new()
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			label.text = upgrade_effect_item.description
			upgrade_choice_panel.label_container.add_child(label)
	
		
	container.get_child(0).grab_focus()
	
func choice_made(upgrade_bundle_item:UpgradeBundle) -> void:
	print("choice made %s" % [upgrade_bundle_item])
	
	if container.get_child_count() > 0:
		for item in container.get_children():
			item.queue_free()
			
	get_tree().paused = false
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		var input_event:InputEventAction = InputEventAction.new()
		input_event.action = "ui_up"
		input_event.pressed = true
		Input.parse_input_event(input_event)
		
	if event.is_action_pressed("down"):
		var input_event:InputEventAction = InputEventAction.new()
		input_event.action = "ui_down"
		input_event.pressed = true
		Input.parse_input_event(input_event)
	
