/// MODEL_UPDATE(model_room, data)

// params
var model_room = argument0;
var data = argument1;

ROOM_SEND_DATA(model_room, 'update', data);
