#import <Foundation/Foundation.h>
#import "GrailsFetcher.h"

@class Announcement;

extern NSString *kAnnouncementsFetcherErrorDomain;

typedef NS_ENUM(NSInteger, AnnouncementsError) {
    kAnnouncementsFetcherUnauthorizedError,
    kAnnouncementsFetcherError
};

@protocol AnnouncementsFetcherDelegate;

@interface AnnouncementsFetcher : GrailsFetcher

- (void)fetchAnnouncement:(NSNumber *)primaryKey
        completionHandler:(void (^)(Announcement *announcement, NSError *))completionHandler;
    
- (void)fetchAnnouncementsWithCompletionHandler:(void (^)(NSArray *announcements, NSError *error))completionHandler;

@end
