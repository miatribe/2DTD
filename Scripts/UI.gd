extends Node2D

@onready var kills: Label = $Sidebar/Kills
@onready var money: Label = $Sidebar/Money
@onready var livesBox: HBoxContainer = $Sidebar/Lives
@onready var gameover: ColorRect = $Gameover
@onready var music_slider: HSlider = $Sidebar/SoundControls/MusicSlider
@onready var sfx_slider: HSlider = $Sidebar/SoundControls/SFXSlider
@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index = AudioServer.get_bus_index("Sfx")


func _ready() -> void:
	EventBus.GameOver.connect(show_game_over)
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))


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


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))
