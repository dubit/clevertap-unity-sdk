#import "CleverTapUnityManager.h"

NSString* clevertap_stringToNSString(const char* str) {
    return str != NULL ? [NSString stringWithUTF8String:str] : [NSString stringWithUTF8String:""];
}

NSString* clevertap_toJsonString(id val) {
    NSString *jsonString;
    
    if (val == nil) {
        return nil;
    }
    
    if ([val isKindOfClass:[NSArray class]] || [val isKindOfClass:[NSDictionary class]]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:val options:NSJSONWritingPrettyPrinted error:&error];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (error != nil) {
            jsonString = nil;
        }
    } else {
        jsonString = [NSString stringWithFormat:@"%@", val];
    }
    
    return jsonString;
}

NSMutableArray* clevertap_NSArrayFromArray(const char* array[], int size) {
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:size];
    for (int i = 0; i < size; i ++) {
        NSString *value = clevertap_stringToNSString(array[i]);
        [values addObject:value];
    }
    
    return values;
}

NSMutableDictionary* clevertap_dictFromJsonString(const char* jsonString) {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (jsonString != NULL && jsonString != nil) {
        NSError *jsonError;
        NSData *objectData = [clevertap_stringToNSString(jsonString) dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:objectData
                                               options:NSJSONReadingMutableContainers
                                                 error:&jsonError];
    }
    
    return dict;
}

NSMutableArray* clevertap_NSArrayFromJsonString(const char* jsonString) {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    
    if (jsonString != NULL && jsonString != nil) {
        NSError *jsonError;
        NSData *objectData = [clevertap_stringToNSString(jsonString) dataUsingEncoding:NSUTF8StringEncoding];
        arr = [NSJSONSerialization JSONObjectWithData:objectData
                                              options:NSJSONReadingMutableContainers
                                                error:&jsonError];
    }
    
    return arr;
}

NSMutableDictionary* clevertap_eventDetailToDict(CleverTapEventDetail* detail) {
    
    NSMutableDictionary *_dict = [NSMutableDictionary new];
    
    if(detail) {
        if(detail.eventName) {
            [_dict setObject:detail.eventName forKey:@"eventName"];
        }
        
        if(detail.firstTime){
            [_dict setObject:@(detail.firstTime) forKey:@"firstTime"];
        }
        
        if(detail.lastTime){
            [_dict setObject:@(detail.lastTime) forKey:@"lastTime"];
        }
        
        if(detail.count){
            [_dict setObject:@(detail.count) forKey:@"count"];
        }
    }
    
    return _dict;
}

NSMutableDictionary* clevertap_utmDetailToDict(CleverTapUTMDetail* detail) {
    
    NSMutableDictionary *_dict = [NSMutableDictionary new];
    
    if(detail) {
        if(detail.source) {
            [_dict setObject:detail.source forKey:@"source"];
        }
        
        if(detail.medium) {
            [_dict setObject:detail.medium forKey:@"medium"];
        }
        
        if(detail.campaign) {
            [_dict setObject:detail.campaign forKey:@"campaign"];
        }
    }
    
    return _dict;
}

char* clevertap_cStringCopy(const char* string) {
    if (string == NULL)
        return NULL;
    
    char* res = (char*)malloc(strlen(string) + 1);
    strcpy(res, string);
    
    return res;
}

void CleverTap_launchWithCredentials(const char* accountID, const char* token) {
    [CleverTapUnityManager launchWithAccountID:clevertap_stringToNSString(accountID) andToken:clevertap_stringToNSString(token)];
}

void CleverTap_launchWithCredentialsForRegion(const char* accountID, const char* token, const char* region) {
    [CleverTapUnityManager launchWithAccountID:clevertap_stringToNSString(accountID) token:clevertap_stringToNSString(token) region:clevertap_stringToNSString(region)];
}

void CleverTap_setApplicationIconBadgeNumber(int num) {
    [CleverTapUnityManager setApplicationIconBadgeNumber:num];
}

void CleverTap_registerPush() {
    [CleverTapUnityManager registerPush];
}

void CleverTap_setOffline(const BOOL enabled) {
    [[CleverTapUnityManager sharedInstance] setOffline:enabled];
}

void CleverTap_setOptOut(const BOOL enabled) {
    [[CleverTapUnityManager sharedInstance] setOptOut:enabled];
}

void CleverTap_enableDeviceNetworkInfoReporting(const BOOL enabled) {
    [[CleverTapUnityManager sharedInstance] enableDeviceNetworkInfoReporting:enabled];
}

void CleverTap_setDebugLevel(int level) {
    [CleverTapUnityManager setDebugLevel:level];
}

void CleverTap_enablePersonalization() {
    [CleverTapUnityManager enablePersonalization];
}

void CleverTap_disablePersonalization() {
    [CleverTapUnityManager disablePersonalization];
}

void CleverTap_setLocation(double lat, double lon) {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lon);
    [CleverTapUnityManager setLocation:coord];
}

void CleverTap_recordScreenView(const char* screenName) {
    [[CleverTapUnityManager sharedInstance] recordScreenView:clevertap_stringToNSString(screenName)];
}

void CleverTap_recordEvent(const char* eventName, const char* properties) {
    NSMutableDictionary *eventProperties = clevertap_dictFromJsonString(properties);
    if (eventProperties == nil || eventProperties == NULL) {
        [[CleverTapUnityManager sharedInstance] recordEvent:clevertap_stringToNSString(eventName)];
    }else {
        [[CleverTapUnityManager sharedInstance] recordEvent:clevertap_stringToNSString(eventName) withProps:eventProperties];
    }
}

void CleverTap_recordChargedEventWithDetailsAndItems(const char* chargeDetails, const char* items) {
    NSDictionary *details = clevertap_dictFromJsonString(chargeDetails);
    NSArray *_items = clevertap_NSArrayFromJsonString(items);
    [[CleverTapUnityManager sharedInstance] recordChargedEventWithDetails:details andItems:_items];
}

void CleverTap_onUserLogin(const char* properties) {
    NSMutableDictionary *profileProperties = clevertap_dictFromJsonString(properties);
    [[CleverTapUnityManager sharedInstance] onUserLogin:profileProperties];
}

void CleverTap_profilePush(const char* properties) {
    NSMutableDictionary *profileProperties = clevertap_dictFromJsonString(properties);
    [[CleverTapUnityManager sharedInstance] profilePush:profileProperties];
}

void CleverTap_profilePushGraphUser(const char* fbGraphUser) {
    NSMutableDictionary *user = clevertap_dictFromJsonString(fbGraphUser);
    [[CleverTapUnityManager sharedInstance] profilePush:user];
}

void CleverTap_profilePushGooglePlusUser(const char* googleUser) {
    NSMutableDictionary *user = clevertap_dictFromJsonString(googleUser);
    [[CleverTapUnityManager sharedInstance] profilePush:user];
}

char* CleverTap_profileGet(const char* key) {
    id ret = [[CleverTapUnityManager sharedInstance] profileGet:clevertap_stringToNSString(key)];
    
    NSString *jsonString = clevertap_toJsonString(ret);
    
    if (jsonString == nil) {
        return NULL;
    }
    
    return clevertap_cStringCopy([jsonString UTF8String]);
}

char* CleverTap_profileGetCleverTapID() {
    NSString *ret = [[CleverTapUnityManager sharedInstance] profileGetCleverTapID];
    
    if (ret == nil) {
        return NULL;
    }
    
    return clevertap_cStringCopy([ret UTF8String]);
}

char* CleverTap_profileGetCleverTapAttributionIdentifier() {
    NSString *ret = [[CleverTapUnityManager sharedInstance] profileGetCleverTapAttributionIdentifier];
    
    if (ret == nil) {
        return NULL;
    }
    
    return clevertap_cStringCopy([ret UTF8String]);
}

void CleverTap_profileRemoveValueForKey(const char* key) {
    [[CleverTapUnityManager sharedInstance] profileRemoveValueForKey:clevertap_stringToNSString(key)];
}

void CleverTap_profileSetMultiValuesForKey(const char* key, const char* array[], int size) {
    
    if (array == NULL || array == nil || size == 0) {
        return;
    }
    
    NSArray *values = clevertap_NSArrayFromArray(array, size);
    
    [[CleverTapUnityManager sharedInstance] profileSetMultiValues:values forKey:clevertap_stringToNSString(key)];
}

void CleverTap_profileAddMultiValuesForKey(const char* key, const char* array[], int size) {
    
    if (array == NULL || array == nil || size == 0) {
        return;
    }
    
    NSArray *values = clevertap_NSArrayFromArray(array, size);
    
    [[CleverTapUnityManager sharedInstance] profileAddMultiValues:values forKey:clevertap_stringToNSString(key)];
    
}

void CleverTap_profileRemoveMultiValuesForKey(const char* key, const char* array[], int size) {
    
    if (array == NULL || array == nil || size == 0) {
        return;
    }
    
    NSArray *values = clevertap_NSArrayFromArray(array, size);
    
    [[CleverTapUnityManager sharedInstance] profileRemoveMultiValues:values forKey:clevertap_stringToNSString(key)];
}

void CleverTap_profileAddMultiValueForKey(const char* key, const char* value) {
    [[CleverTapUnityManager sharedInstance] profileAddMultiValue:clevertap_stringToNSString(value) forKey:clevertap_stringToNSString(key)];
}

void CleverTap_profileRemoveMultiValueForKey(const char* key, const char* value) {
    [[CleverTapUnityManager sharedInstance] profileRemoveMultiValue:clevertap_stringToNSString(value) forKey:clevertap_stringToNSString(key)];
}

int CleverTap_eventGetFirstTime(const char* eventName) {
    return [[CleverTapUnityManager sharedInstance] eventGetFirstTime:clevertap_stringToNSString(eventName)];
}

int CleverTap_eventGetLastTime(const char* eventName) {
    return [[CleverTapUnityManager sharedInstance] eventGetLastTime:clevertap_stringToNSString(eventName)];
}

int CleverTap_eventGetOccurrences(const char* eventName) {
    return [[CleverTapUnityManager sharedInstance] eventGetOccurrences:clevertap_stringToNSString(eventName)];
}

char* CleverTap_userGetEventHistory() {
    NSDictionary *history = [[CleverTapUnityManager sharedInstance] userGetEventHistory];
    
    NSMutableDictionary *_history = [NSMutableDictionary new];
    
    for (NSString *key in history.allKeys) {
        _history[key] = clevertap_eventDetailToDict(history[key]);
    }
    
    NSString *jsonString = clevertap_toJsonString(_history);
    
    if (jsonString == nil) {
        return NULL;
    }
    
    return clevertap_cStringCopy([jsonString UTF8String]);
}

char* CleverTap_sessionGetUTMDetails() {
    CleverTapUTMDetail *detail = [[CleverTapUnityManager sharedInstance] sessionGetUTMDetails];
    
    NSMutableDictionary *_detail = clevertap_utmDetailToDict(detail);
    
    NSString *jsonString = clevertap_toJsonString(_detail);
    
    if (jsonString == nil) {
        return NULL;
    }
    
    return clevertap_cStringCopy([jsonString UTF8String]);
}

int CleverTap_sessionGetTimeElapsed() {
    return [[CleverTapUnityManager sharedInstance] sessionGetTimeElapsed];
}

char* CleverTap_eventGetDetail(const char* eventName) {
    CleverTapEventDetail *detail = [[CleverTapUnityManager sharedInstance] eventGetDetail:clevertap_stringToNSString(eventName)];
    
    NSMutableDictionary *_detail = clevertap_eventDetailToDict(detail);
    
    NSString *jsonString = clevertap_toJsonString(_detail);
    
    if (jsonString == nil) {
        return NULL;
    }
    
    return clevertap_cStringCopy([jsonString UTF8String]);
}

int CleverTap_userGetTotalVisits() {
    return [[CleverTapUnityManager sharedInstance] userGetTotalVisits];
}

int CleverTap_userGetScreenCount() {
    return [[CleverTapUnityManager sharedInstance] userGetScreenCount];
}

int CleverTap_userGetPreviousVisitTime() {
    return [[CleverTapUnityManager sharedInstance] userGetPreviousVisitTime];
}

void CleverTap_pushInstallReferrerSource(const char* source, const char* medium, const char* campaign) {
    [[CleverTapUnityManager sharedInstance] pushInstallReferrerSource:clevertap_stringToNSString(source) medium:clevertap_stringToNSString(medium) campaign:clevertap_stringToNSString(campaign)];
}

int CleverTap_getInboxMessageUnreadCount() {
    return [[CleverTapUnityManager sharedInstance] getInboxMessageUnreadCount];
}

int CleverTap_getInboxMessageCount() {
    return [[CleverTapUnityManager sharedInstance] getInboxMessageCount];
}

void CleverTap_initializeInbox() {
    [[CleverTapUnityManager sharedInstance] initializeInbox];
}

void CleverTap_showAppInbox(const char* styleConfig) {
    NSMutableDictionary *styleConfigDict = clevertap_dictFromJsonString(styleConfig);
    [[CleverTapUnityManager sharedInstance] showAppInbox: styleConfigDict];
}

void CleverTap_setUIEditorConnectionEnabled(const BOOL enabled) {
    [[CleverTapUnityManager sharedInstance] setUIEditorConnectionEnabled:enabled];
}

void CleverTap_registerStringVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerStringVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerBooleanVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerBooleanVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerIntegerVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerIntegerVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerDoubleVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerDoubleVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerMapOfStringVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerMapOfStringVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerMapOfBooleanVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerMapOfBooleanVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerMapOfIntegerVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerMapOfIntegerVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerMapOfDoubleVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerMapOfDoubleVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerListOfStringVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerListOfStringVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerListOfBooleanVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerListOfBooleanVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerListOfIntegerVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerListOfIntegerVariable:clevertap_stringToNSString(name)];
}

void CleverTap_registerListOfDoubleVariable(const char* name) {
   [[CleverTapUnityManager sharedInstance] registerListOfDoubleVariable:clevertap_stringToNSString(name)];
}

BOOL CleverTap_getBooleanVariable(const char* name, const BOOL defaultValue) {
   return [[CleverTapUnityManager sharedInstance] getBooleanVariable:clevertap_stringToNSString(name) defaultValue:defaultValue];
}

char* CleverTap_getStringVariable(const char* name, const char* defaultValue) {
    NSString *ret = [[CleverTapUnityManager sharedInstance] getStringVariable:clevertap_stringToNSString(name) defaultValue:clevertap_stringToNSString(defaultValue)];
    
    if (ret == nil) {
        return NULL;
    }
    return clevertap_cStringCopy([ret UTF8String]);
}

int CleverTap_getIntegerVariable(const char* name, const int defaultValue) {
   return [[CleverTapUnityManager sharedInstance] getIntegerVariable:clevertap_stringToNSString(name) defaultValue:defaultValue];
}

double CleverTap_getDoubleVariable(const char* name, const double defaultValue) {
   return [[CleverTapUnityManager sharedInstance] getDoubleVariable:clevertap_stringToNSString(name) defaultValue:defaultValue];
}

char* CleverTap_getMapOfBooleanVariable(const char* name, const char* defaultValue) {
      NSMutableDictionary *_defaultValue = clevertap_dictFromJsonString(defaultValue);
      id ret = [[CleverTapUnityManager sharedInstance] getMapOfBooleanVariable:clevertap_stringToNSString(name) defaultValue:_defaultValue];
      NSString *jsonString = clevertap_toJsonString(ret);
      if (jsonString == nil) {
          return NULL;
      }
      return clevertap_cStringCopy([jsonString UTF8String]);
}

char* CleverTap_getMapOfStringVariable(const char* name, const char* defaultValue) {
       NSMutableDictionary *_defaultValue = clevertap_dictFromJsonString(defaultValue);
       id ret = [[CleverTapUnityManager sharedInstance] getMapOfStringVariable:clevertap_stringToNSString(name) defaultValue:_defaultValue];
       NSString *jsonString = clevertap_toJsonString(ret);
       if (jsonString == nil) {
           return NULL;
       }
       return clevertap_cStringCopy([jsonString UTF8String]);
}

char*  CleverTap_getMapOfIntegerVariable(const char* name, const char* defaultValue) {
        NSMutableDictionary *_defaultValue = clevertap_dictFromJsonString(defaultValue);
        id ret = [[CleverTapUnityManager sharedInstance] getMapOfIntegerVariable:clevertap_stringToNSString(name) defaultValue:_defaultValue];
        NSString *jsonString = clevertap_toJsonString(ret);
        if (jsonString == nil) {
            return NULL;
        }
        return clevertap_cStringCopy([jsonString UTF8String]);
}

char* CleverTap_getMapOfDoubleVariable(const char* name, const char* defaultValue) {
       NSMutableDictionary *_defaultValue = clevertap_dictFromJsonString(defaultValue);
       id ret = [[CleverTapUnityManager sharedInstance] getMapOfDoubleVariable:clevertap_stringToNSString(name) defaultValue:_defaultValue];
       NSString *jsonString = clevertap_toJsonString(ret);
       if (jsonString == nil) {
           return NULL;
       }
       return clevertap_cStringCopy([jsonString UTF8String]);
}

char* CleverTap_getListOfBooleanVariable(const char* name, const char* defaultValue) {
    NSArray *_defaultValue = clevertap_NSArrayFromJsonString(defaultValue);
    id ret = [[CleverTapUnityManager sharedInstance] getListOfBooleanVariable:clevertap_stringToNSString(name) defaultValue:_defaultValue];
    NSString *jsonString = clevertap_toJsonString(ret);
    if (jsonString == nil) {
        return NULL;
    }
    return clevertap_cStringCopy([jsonString UTF8String]);
}

char* CleverTap_getListOfStringVariable(const char* name, const char* defaultValue) {
    NSArray *_defaultValue = clevertap_NSArrayFromJsonString(defaultValue);
     id ret = [[CleverTapUnityManager sharedInstance] getListOfStringVariable:clevertap_stringToNSString(name) defaultValue:_defaultValue];
     NSString *jsonString = clevertap_toJsonString(ret);
     if (jsonString == nil) {
         return NULL;
     }
     return clevertap_cStringCopy([jsonString UTF8String]);
}

char* CleverTap_getListOfIntegerVariable(const char* name, const char* defaultValue) {
    NSArray *_defaultValue = clevertap_NSArrayFromJsonString(defaultValue);
      id ret = [[CleverTapUnityManager sharedInstance] getListOfIntegerVariable:clevertap_stringToNSString(name) defaultValue:_defaultValue];
      NSString *jsonString = clevertap_toJsonString(ret);
      if (jsonString == nil) {
          return NULL;
      }
      return clevertap_cStringCopy([jsonString UTF8String]);
}

char* CleverTap_getListOfDoubleVariable(const char* name, const char* defaultValue) {
   NSArray *_defaultValue = clevertap_NSArrayFromJsonString(defaultValue);
   id ret = [[CleverTapUnityManager sharedInstance] getListOfDoubleVariable:clevertap_stringToNSString(name) defaultValue:_defaultValue];
   NSString *jsonString = clevertap_toJsonString(ret);
   if (jsonString == nil) {
       return NULL;
   }
   return clevertap_cStringCopy([jsonString UTF8String]);
}



