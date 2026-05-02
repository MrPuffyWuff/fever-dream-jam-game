extends Node3D

class_name MovementComponent

signal target_reached

@onready var parent : CharacterBody3D = get_parent()

@export var speed : int = 10

## The y coordinate is irrelevant
var target_position : Vector3 = Vector3(-1, -1,-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#If near position within some error
	if parent.velocity != Vector3.ZERO and (parent.position - target_position).length_squared() < 0.01:
		parent.position = target_position
		parent.velocity = Vector3.ZERO
		target_reached.emit()

func go_to_location(target : Vector3):
	#offset because positions are centered
	target_position = target + Vector3(0.5, 0, 0.5)
	target_position.y = parent.position.y
	var vec_to_target = target_position - parent.position
	parent.velocity =  vec_to_target.normalized() * speed
