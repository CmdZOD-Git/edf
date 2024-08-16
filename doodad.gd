class_name Doodad extends AnimatedSprite2D

enum DoodadList {
	bullet_impact,
	hit_type_1,
	hit_type_2,
	big_explosion,
	small_explosion,
	big_fragment,
	small_fragment,
	smoke,
	none = -1,
}

func _ready() -> void:
	animation_finished.connect(on_finish)

func make_random_anim(doodad:DoodadList, frame_to_pick:int) -> Doodad:
	var animation_name:String = DoodadList.keys()[doodad]
	
	if not sprite_frames.has_animation(animation_name):
		animation_name = DoodadList.keys()[0]
	
	if sprite_frames.has_animation("random"):
		sprite_frames.clear("random")
	else:
		sprite_frames.add_animation("random")
	
	sprite_frames.set_animation_loop("random", false)
	sprite_frames.set_animation_speed("random", 10)
	
	var base_anim_frame_count = sprite_frames.get_frame_count(animation_name)
	var last_pick_idx:int = -1
	
	for i in frame_to_pick:
		var random_frame_idx = randi_range(0, base_anim_frame_count - 1)
		if random_frame_idx == last_pick_idx and base_anim_frame_count > 1:
			i = i - 1
			continue
		last_pick_idx = random_frame_idx
		var picked_frame:Texture2D = sprite_frames.get_frame_texture( str(animation_name) , random_frame_idx )
		sprite_frames.add_frame( "random" , picked_frame )

	return self
	
func toast(doodad:DoodadList, time_second:float, offset:Vector2, direction:Vector2, speed:float) -> void:
	var animation_name:String = DoodadList.keys()[doodad]
	play(animation_name)

func on_finish() -> void:
	queue_free()
