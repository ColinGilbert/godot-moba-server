extends Viewport

var client_list = {}
var client_info = {
	"name": null,
	"room_id": null,
	"team": null
}
var player_count = 0;
var game_started = false
const MAX_PLAYERS = 8

func _ready():
	get_parent().add_room(self.name)

func decide_team():
	var t1 = 0
	var t2 = 0
	for c in client_list.keys():
		var t = client_list[c]["team"]
		if t ==1:
			t1 += 1
		elif t ==2:
			t2 += 1
	if t1 <= 3:
		return 1
	elif t2 <= 3:
		return 2
	else:
		print("BOTH TEAMS EXCEEDED THE LIMIT")
		return null

func switch_team(c_id):
	var t1 = 0
	var t2 = 0
	for c in client_list.keys():
		var t = client_list[c]["team"]
		if t == 1:
			t1 += 1
		elif t == 2:
			t2 += 1
	var current_team = client_list[str(c_id)]["team"]
	if current_team == 1 and t2 <= 3:
		client_list[str(c_id)]["team"] = 2
	elif current_team == 2 and t2 <= 3:
		client_list[str(c_id)]["team"] = 1
	# Update info
	var c = get_parent().get_parent().get_node("clients").get_node(str(c_id))
	c.client_info["team"] = client_list[str(c_id)]["team"]

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
	update_count()
	
func remove_client(client_id):
	client_info.erase(str(client_id))
	update_count()
	
func update_count():
	player_count = 0
	for c in client_list.keys():
		player_count += 1
	get_parent().update_room(self.name, {"player_count": player_count, "game_started": game_started})

func _on_Timer_timeout():
	if player_count == 0:
		get_parent().delete_room(self.name)
		self.queue_free()
