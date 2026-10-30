# Ad Maiorem Dei Gloriam!
class_name BoomerangBullet
extends BulletBase

signal player_collected()

@export var speed: float = 40

var _is_coming_back: bool  = false
var _player_ref: Player

func _on_lifetime_timeout() -> void:
	player_collected.emit()
	queue_free()

func _physics_process(delta: float) -> void:
	if _is_coming_back:
		var target_position: Vector2 = _player_ref.global_position - global_position
		var target_velocity: Vector2 = target_position.normalized() * speed
		velocity = velocity.lerp(target_velocity, 0.05)
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.2);
		if velocity.length() <= 32:
			_is_coming_back = true
			set_collision_mask_value(5, false)
			set_collision_mask_value(1, true)

	rotation += 0.3
	global_position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if !_is_coming_back:
		velocity = Vector2.ZERO
		
		# Should stop colliding with map and collide with the player
		set_collision_mask_value(5, false)
		set_collision_mask_value(1, true)
		_is_coming_back = true
		
		var health := body.get_node_or_null("HealthComponent") as HealthComponent
		if health: health.take_damage(damage, self)
	else:
		if body.is_in_group("player"):
			player_collected.emit()
			_destroy()
		else:
			var health := body.get_node_or_null("HealthComponent") as HealthComponent
			if health:
				health.take_damage(damage, self)
