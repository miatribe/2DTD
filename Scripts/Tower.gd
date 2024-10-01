class_name Tower extends Node2D

@export var projectile:PackedScene
var current_target:Creeper
var tower_range:int = 150
var tower_damge:int = 1


func _process(delta: float) -> void:
	if current_target == null:
		current_target = Get_Closest_Target_In_Range(tower_range)
	elif !Range_To_Target(current_target) < tower_range:
		current_target = null


func Range_To_Target(target: Node) -> float:
	return target.global_position.distance_to(global_position)


func Attack() -> void:
	var new_projectile = projectile.instantiate() 
	new_projectile.global_position = global_position
	new_projectile.target = current_target
	new_projectile.damage = tower_damge
	get_parent().add_child(new_projectile)
	#todo play a shoot sound


func Get_Closest_Target_In_Range(range:int) -> Creeper:
	var creepers = get_tree().get_nodes_in_group("Creeper")
	var new_target:Creeper = null
	for creep in creepers:
		var dist_to_creep = Range_To_Target(creep)
		if dist_to_creep < range:
			if new_target == null:
				new_target = creep
				continue
			elif dist_to_creep < Range_To_Target(new_target):
				new_target = creep
	return new_target


func _on_attack_timer_timeout() -> void:
	if current_target != null && Range_To_Target(current_target) <  tower_range: #A bit redundant as process should have handled this
		Attack()
