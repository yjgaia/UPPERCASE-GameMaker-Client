/// MODEL_REMOVE(model_room, id)

// params
var model_room = argument0;
var _id = argument1;

ROOM_SEND_VALUE(model_room, 'remove', _id);
