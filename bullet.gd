extends CharacterBody3D

var speed = 10000

func _physics_process(delta):
	velocity = global_transform.basis.z * speed
	move_and_slide()
