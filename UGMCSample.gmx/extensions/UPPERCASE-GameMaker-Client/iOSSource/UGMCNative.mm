#import "UGMCNative.h"

@implementation UGMCNative

const int EVENT_OTHER_SOCIAL = 70;
extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);

- (double) NATIVE_DISCONNECT_FROM_SOCKET_SERVER
{
    [socket setDelegate:nil];
    [socket disconnect];
    [socket release];
    socket = nil;
    
    return (double)-1;
}

- (double) NATIVE_SEND_TO_SOCKET_SERVER:(char *)json
{
    if (socket != nil) {
        
        NSString * str  = [NSString stringWithFormat:@"%@\r\n", [NSString stringWithUTF8String:json]];
        NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        [socket writeData:data withTimeout:-1 tag:-1];
    }
    
    return (double)-1;
}

- (void) NATIVE_SEND_TO_APP_SERVER:(int)status Arg2:(NSString *)json
{
    NSString * str  = [NSString stringWithFormat:@"%d:%@\r\n", status, json];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [appSocket writeData:data withTimeout:-1 tag:-1];
}

- (double) NATIVE_CONNECT_TO_SOCKET_SERVER:(char *)host Arg2:(double)port Arg3:(double)appPort
{
    socket = [[AsyncSocket alloc] initWithDelegate:self];
    BOOL success = [socket connectToHost:[NSString stringWithUTF8String:host] onPort:port error:nil];
    
    appSocket = [[AsyncSocket alloc] initWithDelegate:self];
    [appSocket connectToHost:@"127.0.0.1" onPort:appPort error:nil];
    
    if (!success) {
        
        // connection failed
        [self NATIVE_SEND_TO_APP_SERVER:1 Arg2:@""];
    }
    
    else {
        message = [NSMutableString new];
        
        [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:-1];
    }
    
    return (double)-1;
}

- (void) onSocketDidDisconnect:(AsyncSocket *)thisSocket
{
    [thisSocket setDelegate:nil];
    [thisSocket release];
    
    if (thisSocket == socket) {
        socket = nil;
        
        CreateAsynEventWithDSMap(CreateDsMap(1,
            "type", 0.0, "__UGMC__DISCONNECTED", (void *)NULL
        ), EVENT_OTHER_SOCIAL);
    }
}

- (void) onSocket:(AsyncSocket *)thisSocket didConnectToHost:(NSString *)host port:(UInt16)port {
    if (thisSocket == socket) {
        
        // connected
        [self NATIVE_SEND_TO_APP_SERVER:0 Arg2:@""];
    }
}

- (void) onSocket:(AsyncSocket *)thisSocket didReadData:(NSData *)data withTag:(long)tag {
    if (thisSocket == socket) {
        
        NSString * str = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        
        if (str != nil) {
            
            [message appendString:str];
            
            while (true) {
                
                NSRange range = [message rangeOfString:@"\r\n"];
                
                if (range.location == NSNotFound) {
                    break;
                }
                
                else {
                    
                    // message
                    [self NATIVE_SEND_TO_APP_SERVER:2 Arg2:[message substringToIndex:range.location]];
                    
                    [message setString:[message substringFromIndex:range.location + range.length]];
                }
            }
        }
        
        [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:-1];
    }
}

- (void) dealloc {
    [socket release];
    [super dealloc];
}

@end