/// OFF_FROM_ROOM_SERVER(method_name, method)

// params
var method_name = argument0;
var method = argument1;

with (ROOM_SERVER_CONNECTOR) {

    if (ds_map_exists(method_map, method_name) == true) {

        var methods = ds_map_find_value(method_map, method_name);

        var index = ds_list_find_index(methods, method);
        
        if (index != -1) {
        
            ds_list_delete(methods, index);
            
            if (ds_list_size(methods) == 0) {
            
                ds_list_destroy(methods);
                
                ds_map_delete(method_map, method_name);
            }
        }
    }
}
