extends CharacterBody3D

@export var speed: float = 4.0
@export var stop_distance: float = 1.5

var player: CharacterBody3D
var anim: AnimationPlayer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	anim = _find_animation_player(self)

func _find_animation_player(node: Node) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var result = _find_animation_player(child)
		if result:
			return result
	return null

func _physics_process(delta: float) -> void:
	if player == null:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	var my_pos = Vector2(global_position.x, global_position.z)
	var player_pos = Vector2(player.global_position.x, player.global_position.z)
	var distance = my_pos.distance_to(player_pos)

	if distance > stop_distance:
		if anim:
			anim.play("Armature|Run_02|baselayer")
		var target = player.global_position
		target.y = global_position.y
		var direction = (target - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		# Draai naar de speler toe
		var look_target = player.global_position
		look_target.y = global_position.y
		look_at(look_target)
		rotate_y(deg_to_rad(90))
	else:
		if anim:
			anim.stop()
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
