/// MODEL_GET_BY_PARAMS(model_room, params, callback)

// params
var model_room = argument0;
var params = argument1;
var callback = argument2;

ROOM_SEND_DATA_WITH_CALLBACK(model_room, 'get', params, callback);
