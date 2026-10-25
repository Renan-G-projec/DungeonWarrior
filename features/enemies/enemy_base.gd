# Ad Maiorem Dei Gloriam!
class_name EnemyBase
extends CharacterBody2D

enum State {
	IDLE,
	GOING_TO_PLAYER,
	CONFUSED
}

const SPEED = 100.0

@onready var _target_on_radius: bool = %TriggerArea.has_overlapping_bodies()
@onready var _target: Node2D = null

var _state: State = State.IDLE

func _physics_process(delta: float) -> void:
	if _target_on_radius:
		%VisionToPlayer.target_position = to_local(_target.global_position)
		
		# The raycast should collide only with the walls. So if a collision happens its not seeing
		if %VisionToPlayer.collide_with_bodies:
			_state = State.CONFUSED
			velocity = Vector2.ZERO
	
	match _state:
		State.GOING_TO_PLAYER:
			if !_target || !_target_on_radius: return
			var direction: Vector2 = (_target.global_position - global_position).normalized()
			velocity = direction * SPEED
	
	move_and_slide()

func _on_health_component_died() -> void:
	queue_free()

func _on_health_component_took_damage(damage: float) -> void:
	$FeelComponent.hit_animation(%Sprite)

func _on_trigger_area_body_entered(body: Node2D) -> void:
	%VisionToPlayer.target_position = to_local(body.global_position)
	
	var player := body as Player
	if player:
		_target_on_radius = true
	else:
		_target_on_radius = false
	_target = player


func _on_trigger_area_body_exited(body: Node2D) -> void:
	_state = State.CONFUSED
	if body == _target:
		_target_on_radius = false
		_target = null
