class_name CollisionHelper extends Node

enum Scenario {
	PLAYER,
	ENEMY,
	TARGETTING_PLAYER,
	TARGETTING_ENEMY,
	TARGETTING_PICKUP,
	PICKUP,
}

static func set_collision_scenario(object, scenario:Scenario):
	match scenario:
		Scenario.PLAYER:
			object.set_collision_layer_value(1,true)
			object.set_collision_layer_value(2,true)
			object.set_collision_layer_value(3,false)
			
			object.set_collision_mask_value(1,true)
			object.set_collision_mask_value(2,false)
			object.set_collision_mask_value(3,true)
		
		Scenario.ENEMY:
			object.set_collision_layer_value(1,false)
			object.set_collision_layer_value(2,false)
			object.set_collision_layer_value(3,true)
			
			object.set_collision_mask_value(1,false) # FPS hack, remove enemy collision on terrain
			object.set_collision_mask_value(2,true)
			object.set_collision_mask_value(3,false)
		Scenario.TARGETTING_PLAYER:
			object.set_collision_layer_value(1, false)
			object.set_collision_mask_value(1,false)
			object.set_collision_mask_value(2,true)
			object.set_collision_mask_value(3,false)
		
		Scenario.TARGETTING_ENEMY:
			object.set_collision_layer_value(1, false)
			object.set_collision_mask_value(1,false)
			object.set_collision_mask_value(2,false)
			object.set_collision_mask_value(3,true) # Check enemy layer
			
		Scenario.TARGETTING_PICKUP:
			object.set_collision_layer_value(1,false)
			object.set_collision_layer_value(2,false)
			object.set_collision_layer_value(3,false)
			object.set_collision_layer_value(4,false)
		
			object.set_collision_mask_value(1,false)
			object.set_collision_mask_value(2,false)
			object.set_collision_mask_value(3,false)
			object.set_collision_mask_value(4,true)

		Scenario.PICKUP:
			object.set_collision_layer_value(1,false)
			object.set_collision_layer_value(2,false)
			object.set_collision_layer_value(3,false)
			object.set_collision_layer_value(4,true)
		
			object.set_collision_mask_value(1,false)
			object.set_collision_mask_value(2,false)
			object.set_collision_mask_value(3,false)
			object.set_collision_mask_value(4,false)
