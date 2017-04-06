/// OFF_ALL_FROM_ROOM_SERVER(method_name)

// params
var method_name = argument0;

with (ROOM_SERVER_CONNECTOR) {

    if (ds_map_exists(method_map, method_name) == true) {
    
        ds_list_destroy(ds_map_find_value(method_map, method_name));
        
        ds_map_delete(method_map, method_name);
    }
}
