extends Node

var room = preload("res://room.tscn")
var network = NetworkedMultiplayerENet.new()
var rng = RandomNumberGenerator.new()
var max_players = 12
var port = 1909

func _ready():
	start_server()
	rng.randomize()
	
func start_server():
	network.create_server(port, max_players)
	get_tree().network_peer = network
	print("Server started.")
	get_tree().connect("network_peer_connected", self, "player_connected")
	get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	
func player_connected(player_id):
	print(str(player_id) + " has connected.")

func player_disconnected(player_id):
	print(str(player_id) + " has disconnected.")

remote func create_room():
	print("Creating room.")
	var client_id = get_tree().get_rpc_sender_id()
	var new_room = room.instance()
	var room_id = rng.randi_range(10000, 99999)
	new_room.name = str(room_id)	
	$rooms.add_child(new_room)
	print("Room " + str(room_id) + " created.")
	if client_id in get_tree().get_network_connected_peers():
		rpc_id(client_id, "enter_room", room_id)
	else:
		$rooms.get_node(str(room_id)).queue_free()
