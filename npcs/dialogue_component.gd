extends Node3D

@export var dialogue = preload("uid://dtagxrifo0ju4")

@export var interaction_radius : float = 1

var is_player_inbounds : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D/CollisionShape3D.shape.radius = interaction_radius
	Signals.npc_interaction.connect(on_npc_interact)


func on_npc_interact():
	if is_player_inbounds:
		DialogueManager.show_dialogue_balloon(dialogue, "start")


# Store whether the player is within the bounds or not
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		is_player_inbounds = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		is_player_inbounds = false
