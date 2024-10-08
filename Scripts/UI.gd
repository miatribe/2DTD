extends Node2D

@onready var kills: Label = $Sidebar/Kills
@onready var money: Label = $Sidebar/Money
@onready var livesBox: HBoxContainer = $Sidebar/Lives
@onready var gameover: ColorRect = $Gameover


func _ready() -> void:
	EventBus.GameOver.connect(show_game_over)


func update_kills(kill_count:int)-> void:
	kills.text =  'Kills: %d' % kill_count


func update_gold(gold:int)-> void:
	money.text =  '$%d' % gold


func update_lives(lives:int) -> void:
	for i in livesBox.get_child_count():
		livesBox.get_child(i).visible = lives > i


func show_game_over() ->void:
	gameover.visible = true


func restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
