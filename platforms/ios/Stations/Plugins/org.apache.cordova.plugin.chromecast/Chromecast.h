#import <Cordova/CDV.h>
#import <GCKFramework/GCKFramework.h>

extern NSString *const kReceiverAppName;

@interface Chromecast : CDVPlugin


- (void)pluginInitialize;
- (void)echo:(CDVInvokedUrlCommand*)command;
- (NSString *) arrToJSON:(NSMutableArray *)arr;

//@property(nonatomic, readwrite) NSMutableDictionary *deviceList;
@property(nonatomic, strong, readonly) GCKContext *context;
@property(nonatomic, strong, readonly) GCKDeviceManager *deviceManager;

@end
