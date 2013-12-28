#import "Chromecast.h"
#import <Cordova/CDV.h>

NSString *const kReceiverAppName = @"fbecad4f-6140-4245-8a21-7f9e3894ffa4";

@interface Chromecast () <GCKLoggerDelegate, GCKDeviceManagerListener>{

    NSMutableArray *deviceList;
    NSMutableArray *_devices;
    GCKApplicationSupportFilterListener *_deviceFilter;
}
@property(nonatomic, strong, readwrite) GCKContext *context;
@property(nonatomic, strong, readwrite) GCKDeviceManager *deviceManager;


@end

@implementation Chromecast

- (void)pluginInitialize
{
    NSLog(@"pluginInit");
    deviceList = [[NSMutableArray alloc] init];
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appIdentifier = [info objectForKey:@"CFBundleIdentifier"];
    [GCKLogger sharedInstance].delegate = self;
    self.context = [[GCKContext alloc] initWithUserAgent:appIdentifier];
    self.deviceManager = [[GCKDeviceManager alloc] initWithContext:self.context];
    
    _devices = [[NSMutableArray alloc] init];
    _deviceFilter = [[GCKApplicationSupportFilterListener alloc] initWithContext:self.context
                                                                 applicationName:kReceiverAppName
                                                                       protocols:nil
                                                              downstreamListener:self];
    [_deviceManager addListener:_deviceFilter];
    [_deviceManager startScan];
    
    //[self populateRegistrationDomain];
    
    //self.mediaList = [[MediaList alloc] init];
}

- (void)echo:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;
  NSString* echo = [command.arguments objectAtIndex:0];
  if (echo != nil && [echo length] > 0) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSString *) arrToJSON:(NSMutableArray *)arr{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:0
                                                         error:&error];
    NSString *jsonString = @"";
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark - GCKDeviceManagerListener

- (void)scanStarted {
    NSLog(@"scanStarted");
}

- (void)scanStopped {
    NSLog(@"scanStopped");
}

- (void)deviceDidComeOnline:(GCKDevice *)device {
    [_devices addObject:device];
    
    NSMutableDictionary *deviceDict = [[NSMutableDictionary alloc] init];
    [deviceDict setValue:device.deviceID forKey:@"deviceID"];
    [deviceDict setValue:device.friendlyName forKey:@"friendlyName"];
    [deviceList addObject:deviceDict];
    
    NSString *jsString = [NSString stringWithFormat:@"app.addDevices('%@');", [self arrToJSON:deviceList]];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
    [_devices removeObject:device];
}

#pragma mark - GCKLoggerDelegate

- (void)logFromFunction:(const char *)function message:(NSString *)message {
    NSLog(@"%s  %@", function, message);
}
@end
