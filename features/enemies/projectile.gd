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
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	
func _check_player_collision() -> void:
	for i in get_slide_collision_count():
		var body := get_slide_collision(i).get_collider()
		if body.is_in_group("player"):
			var player_health := body.get_node_or_null("HealthComponent") as HealthComponent
			if player_health:
				player_health.take_damage(damage, body)
