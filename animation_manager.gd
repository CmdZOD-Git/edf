class_name AnimationManager extends Node2D
# enum Verb { death, fire, idle, melee, walk }
@onready var actor:Actor = $".."
var breathing:bool = true
var breath_tween:Tween
var action_playing:Dictionary = { "action" : "idle" , "priority" : 0 }
var action_received:Dictionary = {}
var show_state:bool = false
var facing_mode:Dictionary = { "mode" : "move" }
var should_flip:bool = false
var flip_h_current:bool = false
var interrupt_animation:bool

var display_mode:ActorStat.DisplayMode
var spriteframe_node:AnimatedSprite2D
var sprite_frames:SpriteFrames
var scene_node:Node2D
var scene_node_player:AnimationPlayer

func _ready() -> void:
	display_mode = actor.actor_stat.display_mode
	
	if display_mode == ActorStat.DisplayMode.SPRITEFRAME:
		if actor.actor_stat.sprite_frame:
			spriteframe_node = AnimatedSprite2D.new()
			spriteframe_node.sprite_frames = actor.actor_stat.sprite_frame.duplicate()
			add_child(spriteframe_node)
			sprite_frames = spriteframe_node.sprite_frames
			spriteframe_node.animation_finished.connect(on_action_finished)
			spriteframe_node.animation_looped.connect(on_action_finished)
	
	if display_mode == ActorStat.DisplayMode.SCENE:
		if actor.actor_stat.scene_to_display:
			scene_node = actor.actor_stat.scene_to_display.instantiate()
			add_child(scene_node)
			scene_node_player = scene_node.get_node("AnimationPlayer")
			scene_node_player.animation_finished.connect(on_scene_action_finished)
	
	actor.actor_radio.connect(on_radio)
	
	if breathing == true:
		var breathing_node_x = preload("res://AnimationExtra/breathing.tscn").instantiate()
		breathing_node_x.parent_object_property = "scale:x"
		add_child(breathing_node_x)
		
		var breathing_node_y = preload("res://AnimationExtra/breathing.tscn").instantiate()
		breathing_node_y.parent_object_property = "scale:y"
		add_child(breathing_node_y)
	
func _process(_delta: float) -> void:
	if action_received:
		if display_mode == ActorStat.DisplayMode.SPRITEFRAME:
			if not spriteframe_node.sprite_frames.has_animation(action_received.action):
				print_debug("action %s doesnt exist, switched to idle" % [ action_received.action ])
				action_received = { "action" : "idle" , "priority" : 0 }
		elif display_mode == ActorStat.DisplayMode.SCENE:
			if not scene_node_player.has_animation(action_received.action):
				print_debug("action %s doesnt exist, switched to idle" % [ action_received.action ])
				action_received = { "action" : "idle" , "priority" : 0 }
	elif not actor.velocity == Vector2.ZERO:
		action_received = { "action" : "walk" , "priority" : 3 }
	else:
		action_received = { "action" : "idle" , "priority" : 0 }
		
	if not action_received.has("priority"):
		action_received.priority = 0
	if not action_playing.has("priority"):
		action_playing.priority = -1
	
	if action_received.priority >= action_playing.priority:
		action_playing = action_received
		action_received = {}

	if show_state == true:
		actor.text_box.text = "%s" % [action_playing.action]
	
	if display_mode == ActorStat.DisplayMode.SPRITEFRAME:
		spriteframe_node.play(str(action_playing.action))
	elif display_mode == ActorStat.DisplayMode.SCENE:
		scene_node_player.play(str(action_playing.action))
	
	if facing_mode.mode == "move":
		if actor.velocity.x > 0:
			should_flip = false
		if actor.velocity.x < 0:
			should_flip = true
	elif facing_mode.mode == "focus":
		if facing_mode.has("focused_item"):
			if facing_mode.focused_item.global_position.x - global_position.x > 0:
				should_flip = false
			else:
				should_flip = true
	
	if not should_flip == flip_h_current:
		scale.x = -scale.x
		flip_h_current = should_flip
	
func on_radio(data) -> void:
	match data.type:
		"animation":
			if data.has("action"):
				action_received = data
		"facing_mode":
			facing_mode = data
		
		"status":
			if data.status == "dead":
				breathing = false

func on_scene_action_finished(_anim_name)->void:
	on_action_finished()

func on_action_finished() -> void:
	if action_playing.has("hold") and action_playing.hold == true:
		if display_mode == ActorStat.DisplayMode.SPRITEFRAME:
			if not sprite_frames.has_animation("hold"):
				var action:String = str(action_playing.action)
				var last_frame:Texture2D = sprite_frames.get_frame_texture( action , sprite_frames.get_frame_count(action) - 1)
				sprite_frames.add_animation("hold")
				sprite_frames.add_frame("hold", last_frame)
				sprite_frames.set_animation_loop("hold" , true)
				action_playing.action = "hold"
			else:
				spriteframe_node.play("hold")
		if display_mode == ActorStat.DisplayMode.SCENE:
			pass
	else:
		action_playing = {}
		facing_mode = { "mode" : "move" }
