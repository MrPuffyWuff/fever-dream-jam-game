extends Node3D

var dimensions : Vector2
var index_to_vec : Dictionary[int, Vector2]
var vec_to_index : Dictionary[Vector2, int]

var tile_data : Array = []

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
	setup_index_vec_dict()
	# Set camera and floor to render properly
	# TODO bake in camera settings in the battle_level (i am NOT making an algorithm...)
	$Level.size = dimensions * 16
	$Ground/Floor.mesh.size = dimensions
	$Ground/Floor.position.x = dimensions.x / 2
	$Ground/Floor.position.z = dimensions.y / 2
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
		$Units.add_child(unit)
	# load in enemy units
	for i in range( len(GameState.enemy_units)):
		var unit = GameState.enemy_units[i].instantiate()
		# Add 0.5 to center
		var index = GameState.enemy_spawn_locations[i]
		print(index_to_vec[index])
		unit.position.x = index_to_vec[index].x + 0.5
		unit.position.y = 5
		unit.position.z = index_to_vec[index].y + 0.5
		$Units.add_child(unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
