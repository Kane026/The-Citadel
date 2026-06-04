extends CharacterBody3D

enum State { IDLE, CHASE, ATTACK }

@export var move_speed: float = 4.0
@export var attack_range: float = 1.5
@export var chase_range: float = 15.0
@export var attack_damage: int = 10
@export var attack_cooldown: float = 1.5

var current_state: State = State.IDLE
var player: Node3D = null
var attack_timer: float = 0.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

const GRAVITY: float = -9.8

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5

func _physics_process(delta: float) -> void:
	attack_timer -= delta
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	match current_state:
		State.IDLE:   _handle_idle(distance)
		State.CHASE:  _handle_chase(distance)
		State.ATTACK: _handle_attack(distance)

	if not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()

func _handle_idle(distance: float) -> void:
	velocity.x = 0
	velocity.z = 0
	if distance < chase_range:
		current_state = State.CHASE

func _handle_chase(distance: float) -> void:
	if distance <= attack_range:
		current_state = State.ATTACK
		return
	if distance > chase_range:
		current_state = State.IDLE
		return
	nav_agent.set_target_position(player.global_position)
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))

func _handle_attack(distance: float) -> void:
	velocity.x = 0
	velocity.z = 0
	if distance > attack_range:
		current_state = State.CHASE
		return
	if attack_timer <= 0.0:
		_do_attack()
		attack_timer = attack_cooldown

func _do_attack() -> void:
	print("Duke_Smog valt aan voor ", attack_damage, " schade!")
	if player.has_method("take_damage"):
		player.take_damage(attack_damage)
