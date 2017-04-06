/// CONNECT_TO_ROOM_SERVER(host, socket_server_port)

// params
var host = argument0;
var socket_server_port = argument1;

with (ROOM_SERVER_CONNECTOR) {

    socket = network_create_socket(network_socket_tcp);
    
    // when connected
    // Samsung Galaxy S6 Edge 및 Note 4에서 작동 불가, 무조건 -1만 반환
    if (network_connect_raw(socket, host, socket_server_port) >= 0) {
    
        to_off_callback_names = ds_list_create();
    
        for (var i = 0; i < ds_list_size(enter_room_names); i += 1) {
            SEND_VALUE_TO_ROOM_SERVER('__ENTER_ROOM', ds_list_find_value(enter_room_names, i));
        }
        
        is_still_alive = true;
        
        if (check_still_alive_room == -1) {
            check_still_alive_room = ENTER_ROOM('UPPERCASE/checkStillAliveRoom');
        }
        
        if (time_sync_room == -1) {
            time_sync_room = ENTER_ROOM('UPPERCASE/timeSyncRoom');
            
            var now = date_current_datetime();
            
            ROOM_SEND_VALUE_WITH_CALLBACK(time_sync_room, 'sync', TIME_TO_JS_TIME(now), __SYNC_TIME_CALLBACK);
        }
        
        script_execute(connection_listener);
        
        // after 5 seconds.
        alarm[0] = room_speed * 5;
    }
    
    // 아이폰 혹은 Samsung Galaxy S6 Edge 등에서는 익스텐션 사용
    else if (os_type == os_ios || os_type == os_android) {
    
        is_using_native = true;
        
        network_destroy(socket);
        
        socket = -1;
        
        if (app_server != -1) {
            network_destroy(app_server);
        }
        
        if (app_socket != -1) {
            network_destroy(app_socket);
        }
    
        var app_port = 6510;
        app_server = network_create_server_raw(network_socket_tcp, app_port, 32);
        while (app_server < 0 && app_port < 65535) {
            app_port += 1;
            app_server = network_create_server_raw(network_socket_tcp, app_port, 32);
        }
        
        NATIVE_CONNECT_TO_SOCKET_SERVER(host, socket_server_port, app_port);
    }
    
    // when error
    else {
        
        network_destroy(socket);
        
        socket = -1;
    
        script_execute(error_listener);
    }
}
