/// DISCONNECT_FROM_ROOM_SERVER()

with (ROOM_SERVER_CONNECTOR) {

    // off all to off callbacks.
    for (var i = 0; i < ds_list_size(to_off_callback_names); i += 1) {
        OFF_ALL_FROM_ROOM_SERVER(ds_list_find_value(to_off_callback_names, i));
    }
    ds_list_destroy(to_off_callback_names);
    
    if (is_using_native == true) {
    
        NATIVE_DISCONNECT_FROM_SOCKET_SERVER();
        
        network_destroy(app_server);
        
        app_server = -1;
    
    } else {
        
        network_destroy(socket);
        
        socket = -1;
    }

    RUN_METHOD('__DISCONNECTED', '');
}
