/// ROOM_ON(room_id, method_name, method)

// params
var room_id = argument0;
var method_name = argument1;
var method = argument2;

with (room_id) {

    var methods;

    ON_FROM_ROOM_SERVER(name + '/' + method_name, method);
    
    if (ds_map_exists(method_map, method_name) == true) {
        methods = ds_map_find_value(method_map, method_name);
    } else {
        methods = ds_list_create();
        ds_map_add(method_map, method_name, methods);
    }
    
    ds_list_add(methods, method);
}
