extends Node

var num_audio_players = 16
var audio_bus = "Sfx"
var available = []
var queue = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in num_audio_players:
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		available.append(audio_player)
		audio_player.finished.connect(_on_stream_finished.bind(audio_player))
		audio_player.bus = audio_bus


func _process(delta: float) -> void:
	if !queue.is_empty() && !available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()


func _on_stream_finished(stream:AudioStreamPlayer) -> void:
	available.append(stream)


func play_sound(sound_path) -> void:
	queue.append(sound_path)
