# UPPERCASE-GameMaker-Client

## 설치하기
1. 게임메이커 스튜디오의 `Import Extension`으로 `UPPERCASE-GameMaker-Client.gmez`를 불러옵니다.
2. 불러온 익스텐션을 열어 `Import Resources` 탭으로 이동하여 `Import All` 버튼을 누릅니다.

## 설정하기
아래 세가지 변수를 글로벌 변수로 설정합니다.
* `UPPERCASE_SERVER_HOST` 서버의 호스트를 설정합니다.
* `UPPERCASE_WEB_SERVER_PORT` 웹 서버의 포트를 설정합니다.
* `UPPERCASE_SOCKET_SERVER_PORT` 소켓 서버의 포트를 설정합니다.

```gml
globalvar UPPERCASE_SERVER_HOST = 'localhost';
globalvar UPPERCASE_WEB_SERVER_PORT = 8888;
globalvar UPPERCASE_SOCKET_SERVER_PORT = 8888;
```

## 서버 접속하기
소켓 서버 호스트를 가져온 뒤 자동으로 접속합니다.
```gml
// 서버에 접속합니다.

// ROOM_SERVER_CONNECTOR가 없으면 생성합니다.
if (instance_exists(ROOM_SERVER_CONNECTOR) != true) {

    instance_create(0, 0, ROOM_SERVER_CONNECTOR);
    
    with (ROOM_SERVER_CONNECTOR) {
        connection_listener = sample_connection_listener;
        error_listener = sample_connection_error_listener;
    }
}

// 재접속 하는 경우
else {

    with (ROOM_SERVER_CONNECTOR) {
        http_get_socket_server_host = http_get('http://' + UPPERCASE_SERVER_HOST + ':' + string(UPPERCASE_WEB_SERVER_PORT) + '/__SOCKET_SERVER_HOST?defaultHost=' + UPPERCASE_SERVER_HOST);
    }
}
```

## Connection Listener 작성하기
```gml
// 접속하였습니다.

// 첫 접속시에만 실행
if (object_global.is_first_connected == true) {
    object_global.is_first_connected = false;

    ON_FROM_ROOM_SERVER('__DISCONNECTED', sample_disconnected_listener);
    
    // 룸들을 생성합니다.
    with (object_global) {
    
        SampleRoom = ENTER_ROOM('SampleProejct/Sample');
        ROOM_ON(SampleRoom, 'message', sample_on_new_message_callback);
        
        SampleRoom2 = ENTER_ROOM('SampleProejct/Sample2');
    }
}

// 접속 후 처리
```

## Disconnected Listener 작성하기
```gml
// 접속이 끊어졌습니다.

// 재접속을 시도합니다.
CONNECT_TO_ROOM_SERVER(ROOM_SERVER_CONNECTOR.socket_server_host, UPPERCASE_SOCKET_SERVER_PORT);
```

## 룸 관련 기능

### `ENTER_ROOM(room_name)`
### `ROOM_ON(room_id, method_name, method)`
### `ROOM_OFF(room_id, method_name, method)`
### `ROOM_OFF_ALL(room_id, method_name)`
### `ROOM_SEND_VALUE(room_id, method_name, value)`
### `ROOM_SEND_VALUE_WITH_CALLBACK(room_id, method_name, value, callback)`
### `ROOM_SEND_DATA(room_id, method_name, data)`
### `ROOM_SEND_DATA_WITH_CALLBACK(room_id, method_name, data, callback)`
### `EXIT_ROOM(room_id)`

## 모델 관련 기능
### `MODEL_CREATE(model_room, data)`
### `MODEL_CREATE_WITH_CALLBACK(model_room, data, callback)`
### `MODEL_GET(model_room, id, callback)`
### `MODEL_GET_BY_PARAMS(model_room, params, callback)`
### `MODEL_UPDATE(model_room, data)`
### `MODEL_UPDATE_WITH_CALLBACK(model_room, data, callback)`
### `MODEL_REMOVE(model_room, id)`
### `MODEL_REMOVE_WITH_CALLBACK(model_room, id, callback)`
### `MODEL_FIND(model_room, params, callback)`
### `MODEL_COUNT(model_room, params, callback)`
### `MODEL_CHECK_IS_EXISTS(model_room, params, callback)`

## 기타 기능
### `TIME(time_milliseconds)`