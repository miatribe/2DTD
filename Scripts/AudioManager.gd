extends Node

var background_music = preload("res://Assets/music_or_sometihng.wav")
var num_audio_players = 16
var available = []
var queue = []

 
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"
	music_player.stream = background_music
	music_player.play()
	for i in num_audio_players:
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		available.append(audio_player)
		audio_player.finished.connect(_on_stream_finished.bind(audio_player))
		audio_player.bus = "Sfx"


func _process(delta: float) -> void:
	if !queue.is_empty() && !available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()


func _on_stream_finished(stream:AudioStreamPlayer) -> void:
	available.append(stream)


func play_sound(sound_path) -> void:
	queue.append(sound_path)
