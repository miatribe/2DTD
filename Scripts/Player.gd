extends Node

@export var td:TowerDefence
var gold:int = 40:
	set(gold_in):
		gold = gold_in
		ui.update_gold(gold)
var kills:int = 0:
	set(kills_in):
		kills = kills_in
		ui.update_kills(kills)
var lives:int = 5:
	set(lives_in):
		lives = lives_in
		ui.update_lives(lives)
@onready var ui: Node2D = $"../UI"


func _ready() -> void:
	EventBus.CreepDied.connect(creep_died)
	EventBus.TargetReached.connect(player_damaged)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") && gold >= td.tower_cost:
		if td.block_cell(td.tile_map.get_global_mouse_position()):
			gold-= td.tower_cost
			td.update_all_paths()
	if event.is_action_pressed("right_click") && gold >= td.tower_remove_cost:
		if td.un_block_cell(td.tile_map.get_global_mouse_position()):
			gold-= td.tower_remove_cost
			td.update_all_paths()
	if event.is_action_pressed("debug_damage_creeps"):
		print("debug_damage_creeps")
		for creeper in td.creepers.get_children():
			creeper.take_damage(2)
	if event.is_action_pressed("debug_damage_player"):
		print("debug_damage_player")
		lives -= 1


func creep_died(gold_in:int) -> void:
	gold +=gold_in
	kills +=1


func player_damaged() -> void:
	lives -= 1
