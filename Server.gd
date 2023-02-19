extends Node

var room = preload("res://room.tscn")
var client = preload("res://client.tscn")
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
	var new_client = client.instance()
	new_client.name = str(player_id)
	$clients.add_child(new_client)

func player_disconnected(player_id):
	print(str(player_id) + " has disconnected.")
	$clients.get_node(str(player_id)).terminate()

remote func create_room():
	print("Creating room.")
	var client_id = get_tree().get_rpc_sender_id()
	var new_room = room.instance()
	var room_id = rng.randi_range(10000, 99999)
	new_room.name = str(room_id)	
	$rooms.add_child(new_room)
	print("Room " + str(room_id) + " created.")
	if client_id in get_tree().get_network_connected_peers():
		print("Connecting client to room")
		rpc_id(client_id, "enter_room", room_id)
	else:
		print("Freeing room")
		$rooms.get_node(str(room_id)).queue_free()

remote func add_client(room_id):
	var client_id = get_tree().get_rpc_sender_id()
	var r = $rooms.get_node_or_null(str(room_id))
	if r != null:
		print("Adding client " + str(client_id) + " to room " + str(room_id))
		r.add_client(client_id)
	else:
		print("Tried adding client " + str(client_id) + " to nonexistent room " + str(room_id))

remote func update_clients(room_id):
	var client_id = get_tree().get_rpc_sender_id()
	var r = $rooms.get_node_or_null(str(room_id))
	if r != null:
			if client_id in get_tree().get_network_connected_peers():
				#print("Sending client list for room " + str(room_id) + " to client " + str(client_id))
				rpc_id(client_id, "updated_clients", r.client_list)
			else:
				pass
				#print("Tried sending updated room to nonexistent client.")
	else:
		print("Couldn't find room " + str(room_id))

remote func exit_room(room_id):
	var client_id = get_tree().get_rpc_sender_id()
	var r = $rooms.get_node_or_null(str(room_id))
	r.remove_client(client_id)

remote func update_rooms():
	var client_id = get_tree().get_rpc_sender_id()
	rpc_id(client_id, "updated_rooms", $rooms.rooms_list)
