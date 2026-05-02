extends Node3D

var dimensions : Vector2
var index_to_vec : Dictionary[int, Vector2]
var vec_to_index : Dictionary[Vector2, int]

var tile_value : Array = []
var tile_attribute : Array = []

var prev_selected_idx : int = -1
var selected_index : int = -1

var is_movement_tiles_shown : bool = false
const GRID_SHADER = preload("uid://dgyyqxnhjyqrs")

func setup_index_vec_dict():
	for i in range(dimensions.x * dimensions.y):
		var vector = Vector2(i % int(dimensions.x), int(i / dimensions.y))
		index_to_vec[i] = vector
		vec_to_index[vector] = i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Grab the wanted battle level
	$Level.add_child(GameState.battle_level.instantiate())
	var battle_level : BattleLevel = $Level.get_child(0)
	# Utility (fill useful variables)
	dimensions = battle_level.dimensions
	tile_value.resize(int(dimensions.x * dimensions.y))
	tile_attribute.resize(int(dimensions.x * dimensions.y))
	setup_index_vec_dict()
	# Set camera and floor to render properly
	# TODO bake in camera settings in the battle_level (i am NOT making an algorithm...)
	$Level.size = dimensions * 16
	#$Floor.mesh.size = dimensions
	$Floor.position.x = dimensions.x / 2
	$Floor.position.z = dimensions.y / 2
	# Grid Shader setup
	$Floor.material_override.set_shader_parameter("dimensions", dimensions)
	# Empty all tiles
	var arr_fill : Array[Vector2]
	arr_fill.resize(100)
	arr_fill.fill(Vector2(-1,-1))
	$Floor.material_override.set_shader_parameter("tiles", arr_fill)
	# SETUP UNITS
	# load in player units
	for i in range( len(GameState.player_units)):
		var unit = GameState.player_units[i].instantiate()
		# Multiply by 16 bc tile size
		# Add 0.5 to center
		var index = GameState.player_spawn_locations[i]
		unit.position.x = index_to_vec[index].x + 0.5
		unit.position.y = 5
		unit.position.z = index_to_vec[index].y + 0.5
		tile_value[index] = unit
		$Units.add_child(unit)
	# load in enemy units
	for i in range( len(GameState.enemy_units)):
		var unit = GameState.enemy_units[i].instantiate()
		# Add 0.5 to center
		var index = GameState.enemy_spawn_locations[i]
		unit.position.x = index_to_vec[index].x + 0.5
		unit.position.y = 5
		unit.position.z = index_to_vec[index].y + 0.5
		tile_value[index] = unit
		$Units.add_child(unit)

func display_movement_tiles(selected_unit):
	var movement_vectors : Array[Vector2] = selected_unit.movement_vectors.duplicate()
	for i in range(len(movement_vectors)):
		movement_vectors[i] += index_to_vec[selected_index]
	# NOTE Due to shader shenanigaans, we must fill it with a bunch of Vector(-1,-1)
	var arr_fill : Array[Vector2]
	arr_fill.resize(100)
	arr_fill.fill(Vector2(-1,-1))
	movement_vectors += arr_fill
	$Floor.material_override.set_shader_parameter("tiles", movement_vectors)
	
	is_movement_tiles_shown = true

func hide_movement_tiles():
	# NOTE Due to shader shenanigaans, we must fill it with a bunch of Vector(-1,-1)
	var arr_fill : Array[Vector2]
	arr_fill.resize(100)
	arr_fill.fill(Vector2(-1,-1))
	$Floor.material_override.set_shader_parameter("tiles", arr_fill)
	
	is_movement_tiles_shown = false

func _physics_process(delta : float):
	if Input.is_action_just_pressed("select_tile"):
		var result = raycast()
		var tile_vec = Vector2(floor(result.position.x), floor(result.position.z))
		if tile_vec not in vec_to_index: return
		var tile_idx = vec_to_index[tile_vec]
		prev_selected_idx = selected_index
		selected_index = tile_idx
	
	if selected_index != -1:
		if tile_value[selected_index] != null:# If unit selected, show movement vector
			display_movement_tiles(tile_value[selected_index])
		elif is_movement_tiles_shown:# If clicked on a space, and we can see movement tiles, maaaybe they wanan move the guy?
			var selected_vec = index_to_vec[selected_index]
			var last_selected_unit : CharacterBody3D = tile_value[prev_selected_idx]
			if (selected_vec - index_to_vec[prev_selected_idx]) in last_selected_unit.movement_vectors:
				var movement_comp : MovementComponent = last_selected_unit.find_child("MovementComponent")
				var target_vec := Vector3(
					selected_vec.x,
					0,
					selected_vec.y
				)
				movement_comp.go_to_location(target_vec)
				hide_movement_tiles()
				tile_value[prev_selected_idx] = null
				selected_index = -1
				await movement_comp.target_reached
				tile_value[selected_index] = last_selected_unit
		else:
			hide_movement_tiles()

# WARNING Must be called in physics_process, or kaboom
'''
{
   position: Vector2 # point in world space for collision
   normal: Vector2 # normal in world space for collision
   collider: Object # Object collided or null (if unassociated)
   collider_id: ObjectID # Object it collided against
   rid: RID # RID it collided against
   shape: int # shape index of collider
   metadata: Variant() # metadata of collider
}
'''
func raycast():
	var space_state = get_world_3d().direct_space_state
	var cam = $Camera3D
	var mousepos = get_viewport().get_mouse_position()
	
	var RAY_LENGTH = 200
	
	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	return result
