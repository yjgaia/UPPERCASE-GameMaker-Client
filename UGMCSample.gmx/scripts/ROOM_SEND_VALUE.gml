/// ROOM_SEND_VALUE(room_id, method_name, value)

// params
var room_id = argument0;
var method_name = argument1;
var value = argument2;

with (room_id) {
    SEND_VALUE_TO_ROOM_SERVER(name + '/' + method_name, value);
}
