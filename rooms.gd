extends Node

var rooms_list = {}

var room_info = {
	"player_count": null,
	"game_started": false
}

func add_room(room_id):
	var r = room_info.duplicate()
	rooms_list[room_id] = r
	
func delete_room(room_id):
	rooms_list.erase(room_id)
	
func update_room(room_id, r_info):
	rooms_list[room_id] = r_info
