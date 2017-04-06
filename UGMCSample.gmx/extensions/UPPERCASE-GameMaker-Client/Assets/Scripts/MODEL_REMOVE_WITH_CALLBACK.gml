/// MODEL_REMOVE_WITH_CALLBACK(model_room, id, callback)

// params
var model_room = argument0;
var _id = argument1;
var callback = argument2;

ROOM_SEND_VALUE_WITH_CALLBACK(model_room, 'remove', _id, callback);
