extends Node

var BATTLE = load("uid://ct6bp0rkuvq1x")
var battle_level = load("uid://btbu5sudhwx8o")

## The three possible spawn locations. If party is less than 3, the first index saved is the first location used
var player_spawn_locations : Array[int] = [0,1,2]
var player_units : Array = [load("uid://bawmjshgd75us")]

var enemy_spawn_locations : Array[int] = [99]
var enemy_units : Array = [load("uid://bawmjshgd75us")]

func _ready() -> void:
	Signals.battle_start.connect(on_battle_start)

func on_battle_start():
	SceneSwitcher.goto_scene(BATTLE)
