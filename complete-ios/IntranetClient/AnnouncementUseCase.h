#import <Foundation/Foundation.h>

@class Announcement;

@interface AnnouncementUseCase : NSObject

- (void)saveAnnouncementWithTitle:(NSString *)title body:(NSString *)body completionHandler:(void (^)(Announcement *announcement, NSError *))completionHandler;

- (void)findAllAnnouncementsWithCompletionHandler:(void (^)(NSArray *announcements, NSError *))completionHandler;

- (void)findAnnouncementsByPrimaryKey:(NSNumber *)primaryKey withCompletionHandler:(void (^)(Announcement *announcement, NSError *))completionHandler;

@end
