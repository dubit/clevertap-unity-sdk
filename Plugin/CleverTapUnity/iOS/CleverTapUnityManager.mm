#import "CleverTapUnityManager.h"
#import <CleverTapSDK/CleverTap.h>
#import <CleverTapSDK/CleverTap+Inbox.h>
#import <CleverTapSDK/CleverTap+ABTesting.h>
#import <CleverTapSDK/CleverTapSyncDelegate.h>
#import <CleverTapSDK/CleverTapInAppNotificationDelegate.h>

static CleverTap *clevertap;

static NSString * kCleverTapGameObjectName = @"CleverTapUnity";
static NSString * kCleverTapGameObjectProfileInitializedCallback = @"CleverTapProfileInitializedCallback";
static NSString * kCleverTapGameObjectProfileUpdatesCallback = @"CleverTapProfileUpdatesCallback";
static NSString * kCleverTapDeepLinkCallback = @"CleverTapDeepLinkCallback";
static NSString * kCleverTapPushReceivedCallback = @"CleverTapPushReceivedCallback";
static NSString * kCleverTapPushOpenedCallback = @"CleverTapPushOpenedCallback";
static NSString * kCleverTapInAppNotificationDismissedCallback = @"CleverTapInAppNotificationDismissedCallback";
static NSString * kCleverTapInboxDidInitializeCallback = @"CleverTapInboxDidInitializeCallback";
static NSString * kCleverTapInboxMessagesDidUpdateCallback = @"CleverTapInboxMessagesDidUpdateCallback";

@interface CleverTapUnityManager () <CleverTapInAppNotificationDelegate> {
}

@end

@implementation CleverTapUnityManager

+ (CleverTapUnityManager*)sharedInstance {
    static CleverTapUnityManager *sharedInstance = nil;
    
    if(!sharedInstance) {
        sharedInstance = [[CleverTapUnityManager alloc] init];
        [sharedInstance registerListeners];
        
        clevertap = [CleverTap sharedInstance];
        [clevertap setLibrary:@"Unity"];
        
        [clevertap setInAppNotificationDelegate:sharedInstance];
    }
    
    return sharedInstance;
}

#pragma mark Offline API

- (void)setOffline:(BOOL)enabled{
    [clevertap setOffline:enabled];
}

#pragma mark Opt-out API

- (void)setOptOut:(BOOL)enabled{
    [clevertap setOptOut:enabled];
}
- (void)enableDeviceNetworkInfoReporting:(BOOL)enabled{
    [clevertap enableDeviceNetworkInfoReporting:enabled];
}

#pragma mark Profile/Event/Session APIs

#pragma mark Profile API

- (void)onUserLogin:(NSDictionary *)properties {
    [clevertap onUserLogin:properties];
}

- (void)profilePush:(NSDictionary *)properties {
    [clevertap profilePush:properties];
}

- (void)profilePushGraphUser:(NSDictionary *)fbGraphUser {
    [clevertap profilePushGraphUser:fbGraphUser];
}

- (void)profilePushGooglePlusUser:(NSDictionary *)googleUser {
    [clevertap profilePushGooglePlusUser:googleUser];
}

- (id)profileGet:(NSString *)propertyName {
    return [clevertap profileGet:propertyName];
}

- (void)profileRemoveValueForKey:(NSString *)key {
    [clevertap profileRemoveValueForKey:key];
}

- (void)profileSetMultiValues:(NSArray<NSString *> *)values forKey:(NSString *)key {
    [clevertap profileSetMultiValues:values forKey:key];
}

- (void)profileAddMultiValue:(NSString *)value forKey:(NSString *)key {
    [clevertap profileAddMultiValue:value forKey:key];
}

- (void)profileAddMultiValues:(NSArray<NSString *> *)values forKey:(NSString *)key {
    [clevertap profileAddMultiValues:values forKey:key];
}

- (void)profileRemoveMultiValue:(NSString *)value forKey:(NSString *)key {
    [clevertap profileRemoveMultiValue:value forKey:key];
}

- (void)profileRemoveMultiValues:(NSArray<NSString *> *)values forKey:(NSString *)key {
    [clevertap profileRemoveMultiValues:values forKey:key];
}

- (NSString *)profileGetCleverTapID {
    return [clevertap profileGetCleverTapID];
}

- (NSString*)profileGetCleverTapAttributionIdentifier {
    return [clevertap profileGetCleverTapAttributionIdentifier];
}

#pragma mark User Action Events API

- (void)recordScreenView:(NSString *)screenName {
    if (!screenName) {
        return;
    }
    [clevertap recordScreenView:screenName];
}

- (void)recordEvent:(NSString *)event {
    [clevertap recordEvent:event];
}

- (void)recordEvent:(NSString *)event withProps:(NSDictionary *)properties {
    [clevertap recordEvent:event withProps:properties];
}

- (void)recordChargedEventWithDetails:(NSDictionary *)chargeDetails andItems:(NSArray *)items {
    [clevertap recordChargedEventWithDetails:chargeDetails andItems:items];
}

- (void)recordErrorWithMessage:(NSString *)message andErrorCode:(int)code {
    [clevertap recordErrorWithMessage:message andErrorCode:code];
}

- (NSTimeInterval)eventGetFirstTime:(NSString *)event {
    return [clevertap eventGetFirstTime:event];
}

- (NSTimeInterval)eventGetLastTime:(NSString *)event {
    return [clevertap eventGetLastTime:event];
}

- (int)eventGetOccurrences:(NSString *)event {
    return [clevertap eventGetOccurrences:event];
}

- (NSDictionary *)userGetEventHistory {
    return [clevertap userGetEventHistory];
}

- (CleverTapEventDetail *)eventGetDetail:(NSString *)event {
    return [clevertap eventGetDetail:event];
}


#pragma mark Session API

- (NSTimeInterval)sessionGetTimeElapsed {
    return [clevertap sessionGetTimeElapsed];
}

- (CleverTapUTMDetail *)sessionGetUTMDetails {
    return [clevertap sessionGetUTMDetails];
}

- (int)userGetTotalVisits {
    return [clevertap userGetTotalVisits];
}

- (int)userGetScreenCount {
    return [clevertap userGetScreenCount];
}

- (NSTimeInterval)userGetPreviousVisitTime {
    return [clevertap userGetPreviousVisitTime];
}

# pragma mark Notifications

+ (void)registerPush {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
                                                categories:nil];
        
        
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
#endif
    }
}

- (void)setPushToken:(NSData *)pushToken {
    [clevertap setPushToken:pushToken];
}

- (void)setPushTokenAsString:(NSString *)pushTokenString {
    [clevertap setPushTokenAsString:pushTokenString];
}

- (void)handleNotificationWithData:(id)data {
    [clevertap handleNotificationWithData:data];
}

- (void)showInAppNotificationIfAny {
    [clevertap showInAppNotificationIfAny];
}

- (void)registerApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification {
    [self handleNotificationWithData:notification];
    
    // generate a new dictionary that rearrange the notification elements
    NSMutableDictionary *aps = [NSMutableDictionary dictionaryWithDictionary:[notification objectForKey:@"aps"]];
    
    // check if the object for key alert is a string; if it is, then convert it to a dictionary
    id alert = [aps objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSString class]]) {
        NSDictionary *alertDictionary = [NSDictionary dictionaryWithObject:alert forKey:@"body"];
        [aps setObject:alertDictionary forKey:@"alert"];
    }
    
    // move all other dictionarys other than aps in payload to key extra in aps dictionary
    NSMutableDictionary *extraDictionary = [NSMutableDictionary dictionaryWithDictionary:notification];
    [extraDictionary removeObjectForKey:@"aps"];
    if ([extraDictionary count] > 0) {
        [aps setObject:extraDictionary forKey:@"extra"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:aps]) {
        NSError *pushParsingError = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:aps options:0 error:&pushParsingError];
        
        if (pushParsingError == nil) {
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSString *methodName = (application.applicationState == UIApplicationStateActive) ? kCleverTapPushReceivedCallback : kCleverTapPushOpenedCallback;
            
            [self callUnityObject:kCleverTapGameObjectName forMethod:methodName withMessage:dataString];
        }
    }
}


#pragma mark DeepLink handling

- (void)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    
    [self callUnityObject:kCleverTapGameObjectName forMethod:kCleverTapDeepLinkCallback withMessage:[url absoluteString]];
}

#pragma mark Referrer Tracking

- (void)pushInstallReferrerSource:(NSString *)source
                           medium:(NSString *)medium
                         campaign:(NSString *)campaign {
    
    [clevertap pushInstallReferrerSource:source medium:medium campaign:campaign];
}

#pragma mark Admin

+ (void)launchWithAccountID:(NSString*)accountID andToken:(NSString *)token {
    [self launchWithAccountID:accountID token:token region:nil];
}

+ (void)launchWithAccountID:(NSString*)accountID token:(NSString *)token region:(NSString *)region {
    [CleverTap setCredentialsWithAccountID:accountID token:token region:region];
    [[CleverTap sharedInstance] notifyApplicationLaunchedWithOptions:nil];
}

+ (void)setApplicationIconBadgeNumber:(int)num {
    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
}

+ (void)setDebugLevel:(int)level {
    [CleverTap setDebugLevel:level];
}

- (void)setSyncDelegate:(id <CleverTapSyncDelegate>)delegate {
    [clevertap setSyncDelegate:delegate];
}

+ (void)enablePersonalization {
    [CleverTap enablePersonalization];
}

+ (void)disablePersonalization {
    [CleverTap disablePersonalization];
}

+ (void)setLocation:(CLLocationCoordinate2D)location {
    [CleverTap setLocation:location];
}

# pragma mark CleverTapInAppNotificationDelegate

- (void)inAppNotificationDismissedWithExtras:(NSDictionary *)extras andActionExtras:(NSDictionary *)actionExtras {
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary new];
    
    if (extras != nil) {
        jsonDict[@"extras"] = extras;
    }
    
    if (actionExtras != nil) {
        jsonDict[@"actionExtras"] = actionExtras;
    }
    
    NSString *jsonString = [self dictToJson:jsonDict];
    
    if (jsonString != nil) {
        [self callUnityObject:kCleverTapGameObjectName forMethod:kCleverTapInAppNotificationDismissedCallback withMessage:jsonString];
    }
}

# pragma mark CleverTapSyncDelegate/Listener

- (void)registerListeners {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveCleverTapProfileDidChangeNotification:)
                                                 name:CleverTapProfileDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveCleverTapProfileDidInitializeNotification:)
                                                 name:CleverTapProfileDidInitializeNotification object:nil];
}

- (void)didReceiveCleverTapProfileDidInitializeNotification:(NSNotification*)notification {
    NSString *jsonString = [self dictToJson:notification.userInfo];
    if (jsonString != nil) {
        [self callUnityObject:kCleverTapGameObjectName forMethod:kCleverTapGameObjectProfileInitializedCallback withMessage:jsonString];
    }
}


- (void)didReceiveCleverTapProfileDidChangeNotification:(NSNotification*)notification {
    NSString *jsonString = [self dictToJson:notification.userInfo];
    if (jsonString != nil) {
        [self callUnityObject:kCleverTapGameObjectName forMethod:kCleverTapGameObjectProfileUpdatesCallback withMessage:jsonString];
    }
}

#pragma mark private helpers

-(void)callUnityObject:(NSString *)objectName forMethod:(NSString *)method withMessage:(NSString *)message {
    UnitySendMessage([objectName UTF8String], [method UTF8String], [message UTF8String]);
}

-(NSString *)dictToJson:(NSDictionary *)dict {
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    
    if(err != nil) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark inbox handling

- (void)initializeInbox {
    [clevertap initializeInboxWithCallback:^(BOOL success) {
        NSLog(@"Inbox initialized %d", success);
        [self callUnityObject:kCleverTapGameObjectName forMethod:kCleverTapInboxDidInitializeCallback withMessage:[NSString stringWithFormat:@"%@", success? @"YES": @"NO"]];
        [self inboxMessagesDidUpdate];
    }];
}

- (void)inboxMessagesDidUpdate {
    [clevertap registerInboxUpdatedBlock:^{
        NSLog(@"Inbox Messages updated");
        [self callUnityObject:kCleverTapGameObjectName forMethod:kCleverTapInboxMessagesDidUpdateCallback withMessage:@"inbox updated."];
    }];
}

- (int)getInboxMessageUnreadCount {
    return (int)[clevertap getInboxMessageUnreadCount];
}

- (int)getInboxMessageCount {
     return (int)[clevertap getInboxMessageCount];
}

- (void)showAppInbox:(NSDictionary *)styleConfig {
    CleverTapInboxViewController *inboxController = [clevertap newInboxViewControllerWithConfig:[self _dictToInboxStyleConfig:styleConfig? styleConfig : nil] andDelegate:nil];
    if (inboxController) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:inboxController];
        [UnityGetGLViewController() presentViewController:navigationController animated:YES completion:nil];
    }
}

- (CleverTapInboxStyleConfig*)_dictToInboxStyleConfig: (NSDictionary *)dict {
    CleverTapInboxStyleConfig *_config = [CleverTapInboxStyleConfig new];
    NSString *title = [dict valueForKey:@"navBarTitle"];
    if (title) {
        _config.title = title;
    }
    NSArray *messageTags = [dict valueForKey:@"tabs"];
    if (messageTags) {
        _config.messageTags = messageTags;
    }
    NSString *backgroundColor = [dict valueForKey:@"inboxBackgroundColor"];
    if (backgroundColor) {
        _config.backgroundColor = [self ct_colorWithHexString:backgroundColor alpha:1.0];
    }
    NSString *navigationBarTintColor = [dict valueForKey:@"navBarColor"];
    if (navigationBarTintColor) {
        _config.navigationBarTintColor = [self ct_colorWithHexString:navigationBarTintColor alpha:1.0];
    }
    NSString *navigationTintColor = [dict valueForKey:@"navBarTitleColor"];
    if (navigationTintColor) {
        _config.navigationTintColor = [self ct_colorWithHexString:navigationTintColor alpha:1.0];
    }
    NSString *tabBackgroundColor = [dict valueForKey:@"tabBackgroundColor"];
    if (tabBackgroundColor) {
        _config.navigationBarTintColor = [self ct_colorWithHexString:tabBackgroundColor alpha:1.0];
    }
    NSString *tabSelectedBgColor = [dict valueForKey:@"tabSelectedBgColor"];
    if (tabSelectedBgColor) {
        _config.tabSelectedBgColor = [self ct_colorWithHexString:tabSelectedBgColor alpha:1.0];
    }
    NSString *tabSelectedTextColor = [dict valueForKey:@"tabSelectedTextColor"];
    if (tabSelectedTextColor) {
        _config.tabSelectedTextColor = [self ct_colorWithHexString:tabSelectedTextColor alpha:1.0];
    }
    NSString *tabUnSelectedTextColor = [dict valueForKey:@"tabUnSelectedTextColor"];
    if (tabUnSelectedTextColor) {
        _config.tabUnSelectedTextColor = [self ct_colorWithHexString:tabUnSelectedTextColor alpha:1.0];
    }
    return _config;
}

- (UIColor *)ct_colorWithHexString:(NSString *)string alpha:(CGFloat)alpha{
    if (![string isKindOfClass:[NSString class]] || [string length] == 0) {
        return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    }
    unsigned int hexint = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    return color;
}

#pragma mark screenAB Handling

- (void)setUIEditorConnectionEnabled:(BOOL)enabled {
    [CleverTap setUIEditorConnectionEnabled:enabled];
}
- (void)registerStringVariable:(NSString *)name {
    [clevertap registerStringVariableWithName:name];
}
- (void)registerIntegerVariable:(NSString *)name {
    [clevertap registerIntegerVariableWithName:name];
}
- (void)registerDoubleVariable:(NSString *)name {
    [clevertap registerDoubleVariableWithName:name];
}
- (void)registerBooleanVariable:(NSString *)name {
    [clevertap registerBoolVariableWithName:name];
}
- (void)registerMapOfStringVariable:(NSString *)name {
    [clevertap registerDictionaryOfStringVariableWithName:name];
}
- (void)registerMapOfIntegerVariable:(NSString *)name {
    [clevertap registerDictionaryOfIntegerVariableWithName:name];
}
- (void)registerMapOfDoubleVariable:(NSString *)name {
    [clevertap registerDictionaryOfDoubleVariableWithName:name];
}
- (void)registerMapOfBooleanVariable:(NSString *)name {
    [clevertap registerDictionaryOfBoolVariableWithName:name];
}
- (void)registerListOfStringVariable:(NSString *)name {
    [clevertap registerArrayOfStringVariableWithName:name];
}
- (void)registerListOfDoubleVariable:(NSString *)name {
    [clevertap registerArrayOfDoubleVariableWithName:name];
}
- (void)registerListOfIntegerVariable:(NSString *)name {
    [clevertap registerArrayOfIntegerVariableWithName:name];
}
- (void)registerListOfBooleanVariable:(NSString *)name {
    [clevertap registerArrayOfBoolVariableWithName:name];
}

- (BOOL)getBooleanVariable:(NSString *)name defaultValue:(BOOL)defaultValue {
    return [clevertap getBoolVariableWithName:name defaultValue:defaultValue];
}
- (double)getDoubleVariable:(NSString *)name defaultValue:(double)defaultValue {
    return [clevertap getDoubleVariableWithName:name defaultValue:defaultValue];
}
- (int)getIntegerVariable:(NSString *)name defaultValue:(int)defaultValue {
    return [clevertap getIntegerVariableWithName:name defaultValue:defaultValue];
}
- (NSString *)getStringVariable:(NSString *)name defaultValue:(NSString *)defaultValue {
    return [clevertap getStringVariableWithName:name defaultValue:defaultValue];
}
- (NSArray *)getListOfBooleanVariable:(NSString *)name defaultValue:(NSArray *)defaultValue {
    return [clevertap getArrayOfBoolVariableWithName:name defaultValue:defaultValue];
}
- (NSArray *)getListOfDoubleVariable:(NSString *)name defaultValue:(NSArray *)defaultValue {
    return [clevertap getArrayOfDoubleVariableWithName:name defaultValue:defaultValue];
}
- (NSArray *)getListOfIntegerVariable:(NSString *)name defaultValue:(NSArray *)defaultValue {
    return [clevertap getArrayOfIntegerVariableWithName:name defaultValue:defaultValue];
}
- (NSArray *)getListOfStringVariable:(NSString *)name defaultValue:(NSArray *)defaultValue {
    return [clevertap getArrayOfStringVariableWithName:name defaultValue:defaultValue];
}
- (NSDictionary *)getMapOfBooleanVariable:(NSString *)name defaultValue:(NSDictionary *)defaultValue {
    return [clevertap getDictionaryOfBoolVariableWithName:name defaultValue:defaultValue];
}
- (NSDictionary *)getMapOfDoubleVariable:(NSString *)name defaultValue:(NSDictionary *)defaultValue {
    return [clevertap getDictionaryOfDoubleVariableWithName:name defaultValue:defaultValue];
}
- (NSDictionary *)getMapOfIntegerVariable:(NSString *)name defaultValue:(NSDictionary *)defaultValue {
    return [clevertap getDictionaryOfIntegerVariableWithName:name defaultValue:defaultValue];
}
- (NSDictionary *)getMapOfStringVariable:(NSString *)name defaultValue:(NSDictionary *)defaultValue {
    return [clevertap getDictionaryOfStringVariableWithName:name defaultValue:defaultValue];
}

@end
