extends CharacterBody3D

var movement_vectors : Array[Vector2] = [
	Vector2(1,0),
	Vector2(-1,0),
	Vector2(0,1),
	Vector2(0,-1),
	Vector2(1,1),
	Vector2(-1,1),
	Vector2(1,-1),
	Vector2(-1,-1),
	Vector2(2,0),
	Vector2(-2,0),
	Vector2(0,2),
	Vector2(0,-2),
]

func _physics_process(delta: float) -> void:
	#if velocity != Vector3.ZERO:
		#print(position, velocity)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
