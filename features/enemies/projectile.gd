extends CharacterBody2D

@export var SPEED = 100
@export var damage = 10
@export var lifetime = 4.0

var direction: float
	
func _destroy() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(direction) * SPEED
	move_and_slide()
	_check_player_collision()
	
func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	
func _check_player_collision() -> void:
	for i in get_slide_collision_count():
		var collider := get_slide_collision(i).get_collider() 
		var body := collider as CollisionObject2D
		
		print("BODY", body)
		if body and body.get_collision_layer_value(1):
			var health := body.get_node_or_null("HealthComponent") as HealthComponent
			if health:
				health.take_damage(damage, self)

		queue_free()  
		return

		
