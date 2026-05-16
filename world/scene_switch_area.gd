extends Area3D


## path or uid. I'm using paths since more readable
@export var to_scene: String # Can't be packed scene due to weird engine bug
## if blank or dne, will default to spawn_pos, otherwise will override. 
@export var spawn_name: String
## position to spawn player anew
@export var spawn_pos: Vector3 = Vector3(0,0.5,0)


func _on_body_entered(body) -> void:
	if body.name.to_lower() == "player":
		SceneSwitcher.switch_scene(load(to_scene) as PackedScene, spawn_pos, spawn_name)
