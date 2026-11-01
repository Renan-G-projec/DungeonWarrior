extends CharacterBody2D

@export var SPEED: float = 100.0
@export var damage: int = 10
@export var lifetime: float = 4.0

var direction: float = 0.0


func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	if is_inside_tree():
		_destroy()

func _physics_process(_delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(direction) * SPEED
	move_and_slide()
	_check_collisions()

func _destroy() -> void:
	queue_free()


func _check_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var collider := get_slide_collision(i).get_collider()
		
		var body := collider as CollisionObject2D
		if body != null and body.get_collision_layer_value(1):
			var health := body.get_node_or_null("HealthComponent") as HealthComponent
			if health:
				health.take_damage(damage, self)

		_destroy()
		return
		
