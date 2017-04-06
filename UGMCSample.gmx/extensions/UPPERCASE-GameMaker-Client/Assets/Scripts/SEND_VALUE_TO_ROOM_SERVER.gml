/// SEND_VALUE_TO_ROOM_SERVER(method_name, value)

// params
var method_name = argument0;
var value = argument1;

with (ROOM_SERVER_CONNECTOR) {

    var map = ds_map_create();
    ds_map_add(map, 'methodName', method_name);
    ds_map_add(map, 'data', value);

    if (is_using_native == true) {
    
        NATIVE_SEND_TO_SOCKET_SERVER(json_encode(map));
    
    } else {
        
        var buffer = buffer_create(256, buffer_grow, 1);
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_string, chr(13) + chr(10) + json_encode(map) + chr(13) + chr(10));
        network_send_packet(socket, buffer, buffer_tell(buffer));
        buffer_delete(buffer);
    }
    
    ds_map_destroy(map);
}
