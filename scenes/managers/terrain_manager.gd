extends Node
class_name TerrainManager

signal on_ground
signal on_stairs

enum TerrainType {
	STONE_TILE    = 1,
	STONE_FLAT    = 2,
	STONE_BRICK   = 3,
	STONE_CRACKED = 4,
	WOOD_PLANK    = 5,
	STAIRS        = 6
}

@export var tile_map  : TileMap = null
var         tile_data : TileData
var         terrain_type = "terrain_type"

const FLOOR_LAYER = 0


func _ready():
	if tile_map == null: return


func _process(_delta):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return

	var tile_player_pos : Vector2i = tile_map.local_to_map(player.global_position)
	tile_data = tile_map.get_cell_tile_data(0, tile_player_pos)
	if tile_data == null: return

	var type = tile_data.get_custom_data("terrain_type")
	match type:
		TerrainType.STONE_TILE    : on_ground.emit()
		TerrainType.STONE_FLAT    : on_ground.emit()
		TerrainType.STONE_BRICK   : on_ground.emit()
		TerrainType.STONE_CRACKED : on_ground.emit()
		TerrainType.WOOD_PLANK    : on_ground.emit()
		TerrainType.STAIRS        : on_stairs.emit()
