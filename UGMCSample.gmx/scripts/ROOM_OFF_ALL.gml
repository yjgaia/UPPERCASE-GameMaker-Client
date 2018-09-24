/// ROOM_OFF_ALL(room_id, method_name)

// params
var room_id = argument0;
var method_name = argument1;

with (room_id) {
    
    if (method_map != -1 && ds_exists(method_map, ds_type_map) == true && ds_map_exists(method_map, method_name) == true) {
        
        var methods = ds_map_find_value(method_map, method_name);
        
        for (var i = 0; i < ds_list_size(methods); i += 1) {
        
            var method = ds_list_find_value(methods, i);
            
            OFF_FROM_ROOM_SERVER(name + '/' + method_name, method);
        }
        
        ds_list_destroy(methods);
        
        ds_map_delete(method_map, method_name);
    }
}
