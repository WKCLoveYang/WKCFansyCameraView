//
//  UIDevice+Common.m
//  abab
//
//  Created by 魏昆超 on 2019/2/18.
//  Copyright © 2019 SecretLisa. All rights reserved.
//

#import "UIDevice+Common.h"
#import <AdSupport/AdSupport.h>
@import CommonCrypto;

@interface NSString (md5)

@property (nonatomic, copy, readonly) NSString * toMD5;

@end

@implementation NSString (md5)

- (NSString *)toMD5
{
    return [self encryptWithLength:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)encryptWithLength:(NSInteger)length
{
    const char * cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char buffer[length];
    CC_MD5(cStr,(CC_LONG)strlen(cStr), buffer);
    NSMutableString * md5Str = [NSMutableString string];
    for (NSInteger i = 0; i < length; i ++) {
        [md5Str appendFormat:@"%02x", buffer[i]];
    }
    return md5Str;
}

@end

static inline NSDictionary * bundleInfo()
{
    return NSBundle.mainBundle.infoDictionary;
}

#define BUNDLE_INFO bundleInfo()

static NSString * const kSCSUDKDeviceId = @"UDKDeviceId";
static NSString * const kSCSUDKUUID = @"UDKUUID";
static NSString * const kSCSUDKAnonymousUserId = @"UDKAnonymousUserId";


@implementation UIDevice (Common)

+ (NSString *)appVersion
{
    return BUNDLE_INFO[@"CFBundleShortVersionString"];
}

+ (NSString *)appName
{
    return BUNDLE_INFO[@"CFBundleName"];
}

+ (NSString *)appBuild
{
    return BUNDLE_INFO[@"CFBundleVersion"];
}

+ (NSString *)genarateUuidString
{
    return [self genarateUUIDString];
}




+ (NSString *)genarateUUIDString
{
    NSString * uuid = [NSUserDefaults.standardUserDefaults stringForKey:kSCSUDKUUID];
    if (!uuid) {
        uuid = [[NSUUID alloc] init].UUIDString;
        [NSUserDefaults.standardUserDefaults setObject:uuid
                                                forKey:kSCSUDKUUID];
    }
    return uuid;
}

+ (NSString *)idfaString
{
    NSBundle * adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    if (!adSupportBundle) {
        return [self genarateUUIDString];
    }
    Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
    if (!asIdentifierMClass) {
        return [self genarateUUIDString];
    }
    ASIdentifierManager * asiManager = ASIdentifierManager.sharedManager;
    if (asiManager.isAdvertisingTrackingEnabled) {
        return asiManager.advertisingIdentifier.UUIDString;
    }
    return [self genarateUUIDString];
}

+ (NSString *)deviceUUID
{
    NSString * uuid = [self idfaString];
    if (!uuid || uuid.length == 0) {
        NSString * device_name = UIDevice.currentDevice.name;
        NSString * system_name = UIDevice.currentDevice.systemName;
        NSString * system_version = UIDevice.currentDevice.systemVersion;
        NSString * model = UIDevice.currentDevice.model;
        NSString * localized_model = UIDevice.currentDevice.localizedModel;
        NSString * country = NSLocale.currentLocale.localeIdentifier;
        NSString * language = [NSLocale preferredLanguages].firstObject;
        uuid = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@_%@_%@", device_name, system_name, system_version, model, localized_model, country, language, NSUUID.new.UUIDString];
    }
    return uuid;
}

+ (NSString *)anonymousUserId
{
    NSString * userId = [NSUserDefaults.standardUserDefaults stringForKey:kSCSUDKAnonymousUserId];
    if (!userId || userId.length == 0) {
        userId = [NSString stringWithFormat:@"%@_%@",NSBundle.mainBundle.bundleIdentifier, [self deviceId].toMD5].toMD5;
        [NSUserDefaults.standardUserDefaults setObject:userId
                                                forKey:kSCSUDKAnonymousUserId];
    }
    return userId;
}

+ (NSString *)deviceId
{
    NSString * deId = [NSUserDefaults.standardUserDefaults stringForKey:kSCSUDKDeviceId];
    if (!deId || deId.length == 0) {
        deId = [self deviceUUID].toMD5;
        [NSUserDefaults.standardUserDefaults setObject:deId
                                                forKey:kSCSUDKDeviceId];
    }
    return deId;
}

@end






@implementation UIDevice (UI)

+ (BOOL)is5OrSE
{
    return UIScreen.mainScreen.bounds.size.height == 480 || UIScreen.mainScreen.bounds.size.height == 568;
}

+ (BOOL)is6
{
    return UIScreen.mainScreen.bounds.size.height == 667;
}

+ (BOOL)is6P
{
    return UIScreen.mainScreen.bounds.size.height == 736;
}

+ (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)isX
{
    return self.isPad ? NO : (UIScreen.mainScreen.bounds.size.height >= 812);
}

+ (CGFloat)XTopSpace
{
    return self.isX ? 44 : 0;
}

+ (CGFloat)XBottomSpace
{
    return self.isX ? 34 : 0;
}

+ (CGFloat)statusBarHeight
{
    return self.isX ? 44 : 20;
}

+ (CGFloat)tabBarHeight
{
    return 49 + self.XBottomSpace;
}

+ (CGFloat)navigationBarHeight
{
    return 44;
}

+ (CGFloat)navigationHeight
{
    return self.navigationBarHeight + self.statusBarHeight;
}

@end
