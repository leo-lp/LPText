//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "YYImage.h"
#import "YYText.h"

#import "UIControl+YYAdd.h"
#import "UIImage+YYWebImage.h"
#import "UIView+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYGestureRecognizer.h"
#import "NSData+YYAdd.h"
#import "NSBundle+YYAdd.h"


/**
 桥接`Objective-C`为`Swift`提供`try catch`功能
 */
NS_INLINE void lp_try_objc(void(^_Nonnull tryBlock)(void),
                           void(^_Nonnull catchBlock)(NSException* _Nonnull exception),
                           void(^_Nullable finallyBlock)(void)) {
    @try {
        tryBlock();
    } @catch (NSException* exception) {
        catchBlock(exception);
    } @finally {
        if (finallyBlock != NULL) { finallyBlock(); }
    }
}
