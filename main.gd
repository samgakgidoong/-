extends Node2D

const PLAYER_SCENE : PackedScene = preload("res://player.tscn")
@onready var host_button : Button = $CanvasLayer/VBoxContainer/HostButton
@onready var multiplayer_spawner : MultiplayerSpawner = $MultiplayerSpawner

var players : Array[Player]

func _ready() -> void:
	host_button.pressed.connect(_on_host_button_pressed)
	multiplayer_spawner.spawned.connect(_on_multiplayer_spawner_spawned)
	Networking.host_created.connect(_on_host_created)

func _on_host_created() -> void:
	_spawn_player(multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(_spawn_player)

func _spawn_player(peer_id : int) -> void:
	var player : Player = PLAYER_SCENE.instantiate()
	
	player.name = str(peer_id)
	add_child(player)
	_initialize_player(player)

func _initialize_player(player : Player) -> void:
	player.global_position = $SpawnPoint.global_position
	
	for other in players:
		player.add_collision_exception_with(other)
	
	players.append(player)

func _on_host_button_pressed() -> void:
	Networking.host_lobby()

func _on_multiplayer_spawner_spawned(node : Node) -> void:
	if node is Player:
		_initialize_player(node)
