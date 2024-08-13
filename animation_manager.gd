extends AnimatedSprite2D

@onready var actor:Actor = $".."
var breathing:bool = true
var breath_tween:Tween
var action_playing:Dictionary = { "action" : "idle" , "priority" : 0 }
var action_received:Dictionary = {}
var show_state:bool = false
var facing_mode:Dictionary = { "mode" : "move" }
var interrupt_animation:bool

func _ready() -> void:
	actor.actor_radio.connect(on_radio)
	animation_finished.connect(on_action_finished)
	animation_looped.connect(on_action_finished)
	
func _process(_delta: float) -> void:
	if action_received:
		if not sprite_frames.has_animation(action_received.action):
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
		
	play(str(action_playing.action))
	
	if facing_mode.mode == "move":
		if actor.velocity.x > 0:
			flip_h = false
		if actor.velocity.x < 0:
			flip_h = true
	elif facing_mode.mode == "focus":
		if facing_mode.has("focused_item"):
			if facing_mode.focused_item.global_position.x - global_position.x > 0:
				flip_h = false
			else:
				flip_h = true
	
	#Tween squash and strech implementation
	if breathing == true:
		if not breath_tween or not breath_tween.is_valid():
			breath_tween = self.create_tween()
			breath_tween.set_ease(Tween.EASE_IN_OUT)
			breath_tween.set_trans(Tween.TRANS_ELASTIC)
			breath_tween.tween_property(self,"scale",Vector2( randf_range(0.95,1.05) , randf_range(0.95,1.05) ) , 0.3 * randf_range(0.90,1.10) )
	
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
			
func on_action_finished() -> void:
		if action_playing.has("hold") and action_playing.hold == true:
			if not sprite_frames.has_animation("hold"):
				var action:String = str(action_playing.action)
				var last_frame:Texture2D = sprite_frames.get_frame_texture( action , sprite_frames.get_frame_count(action) - 1)
				sprite_frames.add_animation("hold")
				sprite_frames.add_frame("hold", last_frame)
				sprite_frames.set_animation_loop("hold" , true)
				action_playing.action = "hold"
			else:
				play("hold")
		else:
			action_playing = {}
			facing_mode = { "mode" : "move" }
