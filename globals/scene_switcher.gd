extends Node

func goto_scene(scene: PackedScene):	
	deferred_goto_scene.call_deferred(scene)

func deferred_goto_scene(scene: PackedScene):
	var new_scene = scene.instantiate()
	
	var tree_ref = get_tree()
		
	tree_ref.root.get_child(-1).free()
	
	tree_ref.root.add_child(new_scene)
	tree_ref.current_scene = new_scene
