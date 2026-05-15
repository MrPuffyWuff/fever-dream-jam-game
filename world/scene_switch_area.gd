extends Area3D

@export var starting_location: String 
@export var to_scene: String # Can't be packed scene due to weird engine bug
@export var shape: Shape3D

func _ready():
	if shape:
		$CollisionShape3D.shape = shape

func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower() == "player":
		SceneSwitcher.goto_scene(load(to_scene) as PackedScene, starting_location)
