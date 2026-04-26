extends Node

var BATTLE = load("uid://ct6bp0rkuvq1x")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.battle_start.connect(on_battle_start)

func on_battle_start():
	SceneSwitcher.goto_scene(BATTLE)
