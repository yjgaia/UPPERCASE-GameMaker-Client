/// ON_FROM_ROOM_SERVER(method_name, method)

// params
var method_name = argument0;
var method = argument1;

with (ROOM_SERVER_CONNECTOR) {

    var methods;
    
    if (ds_map_exists(method_map, method_name) == true) {
        methods = ds_map_find_value(method_map, method_name);
    } else {
        methods = ds_list_create();
        ds_map_add(method_map, method_name, methods);
    }
    
    ds_list_add(methods, method);
}
