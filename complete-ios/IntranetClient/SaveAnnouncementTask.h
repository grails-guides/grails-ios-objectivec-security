#import <Foundation/Foundation.h>
#import "GrailsFetcher.h"
@class Announcement;

extern NSString *kSaveAnnouncementErrorDomain;

typedef NS_ENUM(NSInteger, SaveAnnouncementError) {
    kSaveAnnouncementUnauthorizedError,
    kSaveAnnouncementForbiddenError,
    kSaveAnnouncementFailureError,
};

@interface SaveAnnouncementTask : GrailsFetcher

- (void)saveAnnouncementWithTitle:(NSString *)title body:(NSString *)body completionHandler:(void (^)(Announcement *annoucement, NSError *error))completionHandler;

@end
