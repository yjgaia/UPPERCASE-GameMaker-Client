/// ROOM_SEND_DATA(room_id, method_name, data)

// params
var room_id = argument0;
var method_name = argument1;
var data = argument2;

with (room_id) {
    SEND_DATA_TO_ROOM_SERVER(name + '/' + method_name, data);
}
