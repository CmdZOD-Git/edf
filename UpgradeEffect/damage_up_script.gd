extends UpgradeEffect

func _apply(projectile:Projectile) -> Projectile:
	projectile.damage += 1
	return projectile
