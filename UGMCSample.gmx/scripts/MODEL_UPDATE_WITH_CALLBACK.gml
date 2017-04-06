/// MODEL_UPDATE_WITH_CALLBACK(model_room, data, callback)

// params
var model_room = argument0;
var data = argument1;
var callback = argument2;

ROOM_SEND_DATA_WITH_CALLBACK(model_room, 'update', data, callback);
