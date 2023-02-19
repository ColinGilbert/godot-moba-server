extends Node

onready var rooms = get_parent().get_parent().get_node("rooms")

var client_info = {
	"name": null,
	"room_id": null,
	"team": null, 
}

func terminate():
	var r = rooms.get_node_or_null(str(client_info["room_id"]))
	if r != null:
		r.remove_client(self.name)
#		self.queue_free()
