#import "YlUsercenterPlugin.h"
#if __has_include(<yl_usercenter/yl_usercenter-Swift.h>)
#import <yl_usercenter/yl_usercenter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "yl_usercenter-Swift.h"
#endif

@implementation YlUsercenterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYlUsercenterPlugin registerWithRegistrar:registrar];
}
@end
