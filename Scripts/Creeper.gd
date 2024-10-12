class_name Creeper extends Node2D 


@export
var health:int = 2: 
	set(hp_in):
		health = hp_in
		if(health) <= 0:
			EventBus.CreepDied.emit(gold_value)
			SfxSpawner.play_sound("res://Assets/creep_death.wav")
			queue_free()
var td: TowerDefence
var current_path: Array[Vector2i]
var target_location: Vector2i
var gold_value: int = 2
var speed:int = 100


func _process(delta: float) -> void:
	if current_path.is_empty(): return
	var next_position =  td.tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(next_position,speed * delta)
	if global_position == next_position:
		current_path.pop_front()
	if current_path.is_empty(): target_reached()


func target_reached() -> void:
	EventBus.TargetReached.emit()
	queue_free()


func take_damage(damage_in:int) -> void:
	health -= damage_in
