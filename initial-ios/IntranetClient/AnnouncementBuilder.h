#import <Foundation/Foundation.h>
#import "ElementBuilder.h"

@class Announcement;

extern NSString *kAnnouncementBuilderErrorDomain;

enum {
    kAnnouncementBuilderInvalidJSONError,
    kAnnouncementBuilderMissingDataError,
};

@interface AnnouncementBuilder : ElementBuilder

- (NSArray *)announcementsFromJSON:(NSString *)objectNotation
                             error:(NSError **)error;

- (Announcement *)announcementFromJSON:(NSString *)objectNotation
                                 error:(NSError **)error;

@end
