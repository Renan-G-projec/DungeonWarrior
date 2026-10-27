# Ad Maiorem Dei Gloriam!
class_name EnemyBase
extends CharacterBody2D

enum State {
	IDLE,
	GOING_TO_PLAYER,
	DEAD
}

const SPEED = 10.0
 
@onready var _target_on_radius: bool = %TriggerArea.has_overlapping_bodies()
@onready var _target: Node2D = null

var _state: State = State.IDLE

signal died()

func _physics_process(delta: float) -> void:
	if _target_on_radius:
		%VisionToPlayer.target_position = to_local(_target.global_position)
		
		# The raycast should collide only with the walls. So if a collision happens its not seeing
		if %VisionToPlayer.is_colliding():
			velocity = Vector2.ZERO
			%Sprite.play("idle")
		else:
			_state = State.GOING_TO_PLAYER
	
	match _state:
		State.GOING_TO_PLAYER:
			if !_target || !_target_on_radius: return
			var direction: Vector2 = (_target.global_position - global_position).normalized()
			%Sprite.flip_h = direction.x < 0
			%Sprite.play("run")
			
			velocity = direction * SPEED
	
	move_and_slide()

func _on_health_component_died() -> void:
	died.emit()
	%Sprite.play("death")
	
	# We need to check this otherwise when calling queue free or if the player exits before the animation ends this will change the animation or crash the engine because %Sprite will also be null.
	%TriggerArea.monitoring = false
	await %Sprite.animation_finished
	queue_free()

func _on_health_component_took_damage(_character, _damage: float, _position: Vector2) -> void:
	$FeelComponent.hit_animation(%Sprite)
	$FeelComponent.squash_animation(%Sprite, Vector2(1.2, 0.8), 0.3)

func _on_trigger_area_body_entered(body: Node2D) -> void:
	%VisionToPlayer.target_position = to_local(body.global_position)
	
	var player := body as Player
	if player:
		_target_on_radius = true
	else:
		_target_on_radius = false
	_target = player

func _on_trigger_area_body_exited(body: Node2D) -> void:
	_state = State.IDLE
	velocity = Vector2.ZERO
	%Sprite.play("idle")
	if body == _target:
		_target_on_radius = false
		_target = null
