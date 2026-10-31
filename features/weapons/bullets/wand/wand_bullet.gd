# Ad Maiorem Dei Gloriam!
class_name WandBullet
extends BulletBase

enum BulletType {
	FIRE,
	PSYQUIC,
	ICE
}

@export var type: BulletType = BulletType.PSYQUIC

func _physics_process(delta: float) -> void:
	# Psyquic ligerally follows the enemy
	if type == BulletType.PSYQUIC:
		var nearest_enemy: EnemyBase = null
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if !(enemy is EnemyBase): continue
			if !enemy: continue
			if !nearest_enemy: nearest_enemy = enemy
			
			var min_near_enemy_distance: float = global_position.distance_squared_to(nearest_enemy.global_position)
			var current_enemy_distance: float = global_position.distance_squared_to(enemy.global_position)
			
			if min_near_enemy_distance > current_enemy_distance:
				nearest_enemy = enemy
		if nearest_enemy:
			var enemy_angle: float = (nearest_enemy.global_position - global_position).normalized().angle()
			velocity = velocity.rotated((enemy_angle - velocity.angle()) * 0.01)
			global_rotation = velocity.angle()
	
	super._physics_process(delta)
