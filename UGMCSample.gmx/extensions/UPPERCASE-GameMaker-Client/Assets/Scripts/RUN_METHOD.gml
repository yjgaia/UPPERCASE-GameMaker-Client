/// RUN_METHOD(method_name, data)

// params
var __METHOD_NAME = argument0;
var __DATA = argument1;

with (ROOM_SERVER_CONNECTOR) {
        
    if (ds_map_exists(method_map, __METHOD_NAME) == true) {
    
        var __INNER_METHODS = ds_list_create();
        
        var __METHODS = ds_map_find_value(method_map, __METHOD_NAME);
        
        for (var __I = 0; __I < ds_list_size(__METHODS); __I += 1) {
            ds_list_add(__INNER_METHODS, ds_list_find_value(__METHODS, __I));
        }
        
        for (var __I = 0; __I < ds_list_size(__INNER_METHODS); __I += 1) {
        
            var __METHOD = ds_list_find_value(__INNER_METHODS, __I);
            
            script_execute(__METHOD, __DATA);
        }
        
        ds_list_destroy(__INNER_METHODS);
    }
}
