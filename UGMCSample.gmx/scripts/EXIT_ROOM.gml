/// EXIT_ROOM(room_id)

// params
var room_id = argument0;

with (room_id) {

    var method_names = ds_list_create();
    var method_name = ds_map_find_first(method_map);
    
    for (var i = 0; i < ds_map_size(method_map); i += 1) {
    
        ds_list_add(method_names, method_name);
    
        method_name = ds_map_find_next(method_map, method_name);
    }
    
    for (var i = 0; i < ds_list_size(method_names); i += 1) {
        ROOM_OFF_ALL(id, ds_list_find_value(method_names, i));
    }
    
    ds_list_destroy(method_names);

    with (ROOM_SERVER_CONNECTOR) {
        ds_list_delete(enter_room_names, ds_list_find_index(enter_room_names, other.name));
    }
    
    SEND_VALUE_TO_ROOM_SERVER('__EXIT_ROOM', name);
    
    instance_destroy();
}
