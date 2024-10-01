extends Node
class_name TowerDefence

@export var tile_map: TileMapLayer
@export var tower:PackedScene
@export var tower_cost:int = 10
@export var tower_remove_cost:int = 5
var astar = AStarGrid2D.new()
var map_rect = Rect2i()

@onready var towers: Node = $Towers
@onready var creepers: Node = $Creepers
@onready var spawn_pos: Marker2D = $SpawnPos
@onready var target_pos: Marker2D = $TargetPos


func _ready() -> void:
	var tile_size = tile_map.tile_set.tile_size
	map_rect = tile_map.get_used_rect()
	astar.region = map_rect
	astar.cell_size = tile_size
	astar.offset = tile_size * .5
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.update() 
	
	for i in range(map_rect.position.x,map_rect.end.x):
		for j in range(map_rect.position.y,map_rect.end.y):
			var coords = Vector2i(i,j)
			var tile_data = tile_map.get_cell_tile_data(coords)
			if tile_data and tile_data.get_custom_data('type') == 'wall':
				astar.set_point_solid(coords)


func block_cell(clicked_position):
	var map_postion = tile_map.local_to_map(clicked_position)
	if is_point_walkable(clicked_position) && !prevents_any_path(map_postion) && is_not_door(map_postion):
		astar.set_point_solid(map_postion)
		var new_tower = tower.instantiate()
		new_tower.global_position = tile_map.map_to_local(map_postion)
		towers.add_child(new_tower)
		return true
	return false


func un_block_cell(clicked_position):
	var map_postion = tile_map.local_to_map(clicked_position)
	var map_grid_position = tile_map.map_to_local(map_postion) #not the same as clicked_position (this will be the center of the actual cell)
	var blocker = towers.get_children().filter(func (x): return x.global_position == map_grid_position)
	if blocker:
		blocker[0].queue_free()
		astar.set_point_solid(map_postion, false)
		return true
	return false


func update_all_paths():
	for creeper in creepers.get_children():
		creeper.current_path = get_path_to_target(creeper.target_location, creeper.global_position)


func get_path_to_target(target_position, current_position):
	var path = astar.get_id_path(tile_map.local_to_map(current_position), tile_map.local_to_map(target_position))
	if path.size() > 1:
		path = path.slice(1)
	return path


func prevents_any_path(map_postion):
	var prevented:bool = false
	astar.set_point_solid(map_postion)
	if astar.get_id_path(tile_map.local_to_map(spawn_pos.global_position), tile_map.local_to_map(target_pos.global_position)).is_empty(): prevented = true
	if !prevented && creepers.get_children().any(creep_has_path): prevented = true;
	astar.set_point_solid(map_postion, false)
	return prevented


func creep_has_path(creeper):
	return get_path_to_target(creeper.target_location, creeper.global_position).is_empty()


func is_point_walkable(clicked_position):
	var map_postion = tile_map.local_to_map(clicked_position)
	return  map_rect.has_point(map_postion) && !astar.is_point_solid(map_postion)


func is_not_door(map_position):
	var tile_data = tile_map.get_cell_tile_data(map_position)
	return tile_data.get_custom_data('type') != 'door'
