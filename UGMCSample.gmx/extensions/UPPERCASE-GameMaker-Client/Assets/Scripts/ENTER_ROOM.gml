/// ENTER_ROOM(room_name)

// params
var _room_name = argument0;

var room_id = instance_create(0, 0, ROOM);

with (ROOM_SERVER_CONNECTOR) {
    ds_list_add(enter_room_names, _room_name);
}

with (room_id) {
    name = _room_name;
    
    SEND_VALUE_TO_ROOM_SERVER('__ENTER_ROOM', _room_name);
}

return room_id;
