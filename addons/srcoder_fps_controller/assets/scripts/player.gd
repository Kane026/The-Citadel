extends CharacterBody3D

@export_range(1.0,30.0) var speed : float = 15.0
@export_range(2.0,10.0) var jump_velocity : float = 6.0
@export_range(1.0,5.0) var mouse_sensitivity = 3.0
var mouse_motion : Vector2 = Vector2.ZERO
var pitch = 0
@export_range(1.0,10.0) var ground_acceleration := 4.0
@export_range(0.0,5.0) var air_acceleration := 0.5
@export_range(5.0,25.0) var gravity : float = 15.0
var bullets_fired: int = 0

@onready var camera_pivot : Node3D = $CameraPivot
@onready var knife = $CameraPivot/Camera3D/Knife
@onready var gun = $CameraPivot/Camera3D/Gun
var bullet = load("res://bullet.tscn")
@onready var barrel_position = $CameraPivot/Camera3D/Gun/barrel_position

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_just_pressed("shoot"):
		if gun.visible:
			var instance = bullet.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = barrel_position.global_position
			instance.global_transform.basis = barrel_position.global_transform.basis
			bullets_fired += 1
			if bullets_fired >= 10:
				var duke = get_tree().get_first_node_in_group("dukesmog")
				if duke:
					duke.neem_schade(duke.max_hp)
				bullets_fired = 0

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	var target_velocity := Vector3.ZERO
	if direction:
		target_velocity = direction
	if is_on_floor():
		velocity.x = move_toward(velocity.x, target_velocity.x * speed, speed * ground_acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z * speed, speed * ground_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, target_velocity.x * speed, speed * air_acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z * speed, speed * air_acceleration * delta)
	move_and_slide()

	rotate_y(-mouse_motion.x * mouse_sensitivity / 1000)
	pitch -= mouse_motion.y * mouse_sensitivity / 1000
	pitch = clampf(pitch, -1.35, 1.35)
	camera_pivot.rotation.x = pitch
	mouse_motion = Vector2.ZERO

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		mouse_motion = event.relative
	if event.is_action_pressed("weapon_1"):
		knife.visible = true
		gun.visible = false
	if event.is_action_pressed("weapon_2"):
		knife.visible = false
		gun.visible = true
