extends Node

func goto_scene(scene: PackedScene):	
	deferred_goto_scene.call_deferred(scene)

func deferred_goto_scene(scene: PackedScene): # replace full tree
	var new_scene = scene.instantiate()
	
	var tree_ref = get_tree()
		
	tree_ref.root.get_child(-1).free()
	
	tree_ref.root.add_child(new_scene)
	tree_ref.current_scene = new_scene

var game # game node
var current_level
var player


func switch_scene(scene: PackedScene, player_spawn_loc: Vector3, spawn_name: String):
	FadeToBlack.get_node("AnimationPlayer").play("fade_in_out")
	await get_tree().create_timer(0.5).timeout
	deferred_switch_scene(scene, player_spawn_loc, spawn_name)

func deferred_switch_scene(scene: PackedScene, player_spawn_loc: Vector3, spawn_name: String): # remove old level if possible, add new level
	var new_scene = scene.instantiate()
	
	if not game:
		game = get_tree().root.get_child(-1)
	if not current_level:
		current_level = game.get_child(-1)
	
	current_level.queue_free()
	
	current_level = new_scene
	game.add_child(new_scene)
	if not player:
		player = game.find_child("Player")
	if player:
		var spawn
		if spawn_name:
			spawn = new_scene.find_child(spawn_name)
		if spawn:
			player.position = spawn.position
		else:
			player.position = player_spawn_loc
