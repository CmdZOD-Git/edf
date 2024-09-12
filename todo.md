# Now
Still need a method to select UpgradeBundle available
Apply effect of the pickup
player death + health bar (beginning of an UI ?)
XP and level up ?

# Later
+ Gameplay, for real ?
+ Melee as hitscan rather than projectile reskin ?
+ Changing projectile to use a raycast first ? -> Avoid too fast projectile missing collision
+ Meta layer

# Idea

# DONE (in reverse)
Moving closer to the real thing → upgrade framework (as a pickup for now)
Learned how to call a specific event through another action
Spawner framework 
Make something about hitbox size -> custom to scene and linked to actor size collision_box_vector
Animation manager rework to support fully scene and animated sprite + breathing complete rework
Add item to actor stat and display of scene instead of spriteframe
Decouple cooldown and target seek
Enemy melee attack & melee attack logic -> Need team logic
Melee attack logic (simple reskinning of fire projectile)
Hit Spark
Hit point current -> now set at actor node ready
Optimisation - no nav on enemy and area to find player is not monitorable
Item motion enum

# COPY/PASTA
get_last_slide_collision() -> KinematicCollision2D
