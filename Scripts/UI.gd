extends Node2D

@onready var kills: Label = $VBoxContainer/Kills
@onready var money: Label = $VBoxContainer/Money
@onready var livesBox: HBoxContainer = $VBoxContainer/Lives


func update_kills(kill_count:int)-> void:
	kills.text =  'Kills: %d' % kill_count


func update_gold(gold:int)-> void:
	money.text =  '$%d' % gold


func update_lives(lives:int) -> void:
	for i in livesBox.get_child_count():
		livesBox.get_child(i).visible = lives > i
