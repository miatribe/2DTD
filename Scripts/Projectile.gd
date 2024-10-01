extends Node2D

var target:Creeper
var damage:int
var speed:int = 300


func _process(delta: float) -> void:
	if !target:
		queue_free()
		return
	look_at(target.global_position)
	global_position = global_position.move_toward(target.global_position, speed * delta)
	if global_position == target.global_position:
		target.take_damage(damage)
		queue_free()
