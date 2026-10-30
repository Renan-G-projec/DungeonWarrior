# Ad Maiorem Dei Gloriam!
class_name ShoorikenBullet
extends BulletBase

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	rotation += PI * 4 * delta
