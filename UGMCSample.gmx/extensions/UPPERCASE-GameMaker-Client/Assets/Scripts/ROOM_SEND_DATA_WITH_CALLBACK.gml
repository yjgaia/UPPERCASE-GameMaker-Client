/// ROOM_SEND_DATA_WITH_CALLBACK(room_id, method_name, data, callback)

// params
var room_id = argument0;
var method_name = argument1;
var data = argument2;
var callback = argument3;

with (room_id) {
    SEND_DATA_TO_ROOM_SERVER_WITH_CALLBACK(name + '/' + method_name, data, callback);
}
