extends MultiplayerSpawner

@export var network_player: PackedScene

var spawned_players: Dictionary[Player, int]
@export var player_spawns: Array[Node2D]

func _ready():
	multiplayer.peer_connected.connect(spawn_player)

func spawn_player(id: int):
	if !multiplayer.is_server(): return

	var player: Node = network_player.instantiate()
	player.name = str(id)

	get_node(spawn_path).call_deferred("add_child", player)

func _on_spawned(node: Node):
	if node is Player:
		spawned_players.get_or_add(node, int(node.name))
		node.global_position = player_spawns[spawned_players.size() - 1].global_position

func _on_despawned(node: Node):
	print("On despawned")
	if node is Player:
		print("Despawned something! ", spawned_players.size())
		spawned_players.erase(node)
		print("Despawned something! ", spawned_players.size())
