extends CharacterBody2D

@export var SPEED = 100
@export var damage = 10
@export var lifetime = 4.0

var direction: float
	

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(direction) * SPEED
	move_and_slide()
	_check_player_collision()
	
func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
func _check_player_collision() -> void:
	if get_slide_collision_count() > 0:
		var body := get_slide_collision(0).get_collider()
		if body is Player:
			var player_health := body.get_node_or_null("HealthComponent") as HealthComponent
			if player_health:
				player_health.take_damage(damage, body)
			var player_knockback := body.get_node_or_null("KnockbackComponent") as KnockbackComponent
			if player_knockback:
				player_knockback.apply_knockback(Vector2.RIGHT.rotated(direction), )
		queue_free()
