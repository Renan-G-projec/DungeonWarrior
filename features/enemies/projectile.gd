extends CharacterBody2D

@export var SPEED: float = 100.0
@export var damage: int = 10
@export var lifetime: float = 4.0

var direction: float = 0.0


func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	_destroy()


func _physics_process(_delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(direction) * SPEED
	move_and_slide()
	_check_player_collision()


func _destroy() -> void:
	queue_free()


func _check_player_collision() -> void:
	for i in range(get_slide_collision_count()):
		var body := get_slide_collision(i).get_collider() as CollisionObject2D

		if body == null or not body.get_collision_layer_value(1):
			continue

		var health := body.get_node_or_null("HealthComponent") as HealthComponent
		if health:
			health.take_damage(damage, self)

		_destroy()
		return
