#import <CocoaAsyncSocket/AsyncSocket.h>

@interface UGMCNative : NSObject <NSStreamDelegate>
{
    AsyncSocket * socket;
    AsyncSocket * appSocket;
    
    NSMutableString * message;
}

- (double) NATIVE_DISCONNECT_FROM_SOCKET_SERVER;
- (double) NATIVE_SEND_TO_SOCKET_SERVER:(char *)json;
- (double) NATIVE_CONNECT_TO_SOCKET_SERVER:(char *)host Arg2:(double)port Arg3:(double)appPort;

@end