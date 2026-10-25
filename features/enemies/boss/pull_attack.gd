class_name PullAttack
extends Node

@export var cooldown: float = 6.0
@export var windup: float = 0.8
@export var min_range: float = 80.0
@export var max_range: float = 160.0
@export var pull_force: float = 130.0
@export var pull_duration: float = 1.0
@export var stop_distance: float = 60.0
@export var follow: FollowPlayer

var cooldown_left: float = 0.0
var busy: bool = false
var player: Player

@onready var body: CharacterBody2D = get_parent()

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player
	
func _physics_process(delta: float) -> void:
	cooldown_left = maxf(cooldown_left - delta, 0.0)
	if player == null:
		print("PullAttack: _player is null")
		return
	if busy or cooldown_left > 0.0:
		return

	var distance := body.global_position.distance_to(player.global_position)
	print("PullAttack distance: ", distance, " (needs ", min_range, "-", max_range, ")")
	if distance >= min_range and distance <= max_range:
		_start_pull()
			
func _start_pull() -> void:
	print("START PULL")
	busy = true
	if follow:
		follow.stop_for(windup + 0.3)
		
	await get_tree().create_timer(windup).timeout

	var pull := player.get_node_or_null("Pull") as Pull if is_instance_valid(player) else null
	print("PullAttack: pull node = ", pull)
	if pull:
		pull.apply_pull(body, pull_force, pull_duration, stop_distance)

	cooldown_left = cooldown
	busy = false
