extends Viewport

var client_list = {}
var client_info = {
	"name": null,
	"room_id": null,
	"team": null
}
const MAX_PLAYERS = 8

func add_client(client_id):
	if client_list.size() >= MAX_PLAYERS:
		print("Room full.")
		return
	var new_client = client_info.duplicate()
	var c = get_parent().get_parent().get_node("clients").get_node(str(client_id))
	new_client["name"] = c.client_info["name"]
	new_client["room_id"] = self.name
	new_client["team"] = 1 # TODO: Change
	c.client_info = new_client
	client_list[str(client_id)] = new_client
