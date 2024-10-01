extends Timer


@export var creeper:PackedScene
var spawn_location:Vector2i
var target_location:Vector2i
var creepers_spawned: int = 0

@onready var spawn_pos: Marker2D = $"../SpawnPos"
@onready var target_pos: Marker2D = $"../TargetPos"
@onready var creepers: Node = $"../Creepers"
@onready var tower_defence: Node = $".."
@onready var tile_map: TileMapLayer = $"../../TileMap"


func _ready() -> void:
	spawn_location = spawn_pos.global_position
	target_location = target_pos.global_position
	

func _on_spawn_timer_timeout() -> void:
	var newcreeper = creeper.instantiate()
	newcreeper.td = tower_defence
	newcreeper.global_position = spawn_location
	newcreeper.target_location = target_location
	newcreeper.current_path = tower_defence.get_path_to_target(newcreeper.target_location,newcreeper.global_position)
	newcreeper.health += newcreeper.health * (creepers_spawned / 10)
	creepers.add_child(newcreeper)
	creepers_spawned+=1
