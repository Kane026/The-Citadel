extends CharacterBody3D

@export var speed: float = 15.0
@export var stop_distance: float = 1.5

var player: CharacterBody3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player == null:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Gewoon recht naar de speler toe, geen offset
	var my_pos = Vector2(global_position.x, global_position.z)
	var player_pos = Vector2(player.global_position.x, player.global_position.z)
	var distance = my_pos.distance_to(player_pos)

	if distance > stop_distance:
		var target = player.global_position
		target.y = global_position.y
		var direction = (target - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
