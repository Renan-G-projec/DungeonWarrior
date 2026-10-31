# Ad Maiorem Dei Gloriam!
class_name WandBullet
extends BulletBase

enum BulletType {
	FIRE,
	PSYQUIC,
	ICE
}

@export var type: BulletType = BulletType.PSYQUIC:
	set(new_type):
		type = new_type
		match type:
			BulletType.FIRE:
				$Sprite2D.self_modulate = Color.WHITE
			BulletType.PSYQUIC:
				$Sprite2D.self_modulate = Color(3.294, 0.854, 3.294)
			BulletType.ICE:
				$Sprite2D.self_modulate = Color(0.0, 3.867, 4.087)

func _ready() -> void:
	# Randomize the sprite
	$Sprite2D.frame = range($Sprite2D.hframes).pick_random()

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
	
func _on_body_entered(body: Node2D) -> void:
	if type == BulletType.FIRE:
		var burning_component := body.get_node_or_null("BurningComponent") as BurningComponent
		if burning_component:
			burning_component.start_burning_effect()
	if type == BulletType.ICE:
		var freeze_component := body.get_node_or_null("FreezeComponent") as FreezeComponent
		if freeze_component:
			freeze_component.start_freeze_effect()
	
	super._on_body_entered(body)
