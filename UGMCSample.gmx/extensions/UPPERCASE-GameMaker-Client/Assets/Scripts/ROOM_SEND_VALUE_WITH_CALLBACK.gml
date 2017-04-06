/// ROOM_SEND_VALUE_WITH_CALLBACK(room_id, method_name, value, callback)

// params
var room_id = argument0;
var method_name = argument1;
var value = argument2;
var callback = argument3;

with (room_id) {
    SEND_VALUE_TO_ROOM_SERVER_WITH_CALLBACK(name + '/' + method_name, value, callback);
}
