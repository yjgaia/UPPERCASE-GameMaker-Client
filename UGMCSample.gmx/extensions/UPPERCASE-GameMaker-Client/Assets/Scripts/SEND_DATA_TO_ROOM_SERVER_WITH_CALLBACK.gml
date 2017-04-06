/// SEND_DATA_TO_ROOM_SERVER_WITH_CALLBACK(method_name, data, callback)

// params
var method_name = argument0;
var data = argument1;
var callback = argument2;

with (ROOM_SERVER_CONNECTOR) {

    var callback_name = '__CALLBACK_' + string(send_key);
    
    var map = ds_map_create();
    ds_map_add(map, 'methodName', method_name);
    ds_map_add_map(map, 'data', COPY_MAP(data));
    ds_map_add(map, 'sendKey', send_key);
    
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
    
    send_key += 1;
    
    // on callback.
    ON_FROM_ROOM_SERVER(callback_name, callback);
    
    // to off callback.
    ds_list_add(to_off_callback_names, callback_name);
}
