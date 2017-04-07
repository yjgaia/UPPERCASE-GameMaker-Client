/// sample_connection_listener

// 첫 접속시에만 실행
if (object_global.is_first_connect == true) {
    object_global.is_first_connect = false;

    ON_FROM_ROOM_SERVER('__DISCONNECTED', sample_disconnected_listener);
    
    // 룸들을 생성합니다.
    with (object_global) {
    
        SampleRoom = ENTER_ROOM('SampleProejct/Sample');
        ROOM_ON(SampleRoom, 'messageFromServer', sample_on_new_message_callback);
        
        SampleRoom2 = ENTER_ROOM('SampleProejct/Sample2');
    }
}

var data = ds_map_create();
ds_map_add(data, 'a', 1);
ds_map_add(data, 'b', 2);
ds_map_add(data, 'c', 3);

ROOM_SEND_DATA_WITH_CALLBACK(object_global.SampleRoom, 'messageFromClient', data, sample_send_message_callback);

ds_map_destroy(data);
