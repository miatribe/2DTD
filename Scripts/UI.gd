extends Node2D

@onready var kills: Label = $VBoxContainer/Kills
@onready var money: Label = $VBoxContainer/Money


func update_kills(kill_count:int)-> void:
	kills.text =  'Kills: %d' % kill_count


func update_gold(gold:int)-> void:
	money.text =  '$%d' % gold
