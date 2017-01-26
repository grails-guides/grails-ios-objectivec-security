#import "AnnouncementUseCase.h"
#import "SaveAnnouncementTask.h"
#import "Announcement.h"
#import <GrailsSpringSecurityRestObjc/GrailsApi.h>
#import "GrailsFetcher.h"
#import "AnnouncementsFetcher.h"

@interface AnnouncementUseCase ()

@property (nonatomic, strong)GrailsApi *grailsApi;

@end

@implementation AnnouncementUseCase

#pragma mark - Public

- (void)saveAnnouncementWithTitle:(NSString *)title body:(NSString *)body completionHandler:(void (^)(Announcement *announcement, NSError *error))completionHandler {
    
    SaveAnnouncementTask *task = [[SaveAnnouncementTask alloc] init];
    
    [task saveAnnouncementWithTitle:title body:body completionHandler:^(Announcement *annoucement, NSError *error) {
        
        if ( !error ) {
            if ( completionHandler ) {
                completionHandler(annoucement, nil);
            }
            return;
        }
        
        if([error.domain isEqualToString:kAnnouncementsFetcherErrorDomain] && error.code == kSaveAnnouncementUnauthorizedError) {
            
            [self.grailsApi refreshAccessTokenGrailsServerUrl:kServerUrl withCompletionHandler:^(NSError *error) {
                if ( error ) {
                    if ( completionHandler) {
                        completionHandler(nil, error);
                    }
                    return;
                }
                [task saveAnnouncementWithTitle:title body:body completionHandler:^(Announcement *annoucement, NSError *error) {
                    completionHandler(annoucement, error);
                    return;
                }];
            }];
        } else {
            if ( completionHandler ) {
                completionHandler(nil, error);
            }
            return;
        }
    }];
}

- (void)findAllAnnouncementsWithCompletionHandler:(void (^)(NSArray *announcements, NSError *))completionHandler {
    
    AnnouncementsFetcher *task = [[AnnouncementsFetcher alloc] init];
    
    [task fetchAnnouncementsWithCompletionHandler:^(NSArray *announcements, NSError *error) {
        if ( !error ) {
            if ( completionHandler ) {
                completionHandler(announcements, nil);
            }
            return;
        }
        
        if([error.domain isEqualToString:kAnnouncementsFetcherErrorDomain] && error.code == kSaveAnnouncementUnauthorizedError) {
            
            [self.grailsApi refreshAccessTokenGrailsServerUrl:kServerUrl withCompletionHandler:^(NSError *error) {
                if ( error ) {
                    if ( completionHandler) {
                        completionHandler(nil, error);
                    }
                    return;
                }
                [task fetchAnnouncementsWithCompletionHandler:^(NSArray *announcements, NSError *error) {
                    completionHandler(announcements, error);
                }];
            }];
        } else {
            if ( completionHandler ) {
                completionHandler(nil, error);
            }
        }
    }];
    
}

- (void)findAnnouncementsByPrimaryKey:(NSNumber *)primaryKey withCompletionHandler:(void (^)(Announcement *announcement, NSError *))completionHandler {
 
    AnnouncementsFetcher *task = [[AnnouncementsFetcher alloc] init];
    
    [task fetchAnnouncement:primaryKey completionHandler:^(Announcement *announcement, NSError *error) {
        if ( !error ) {
            if ( completionHandler ) {
                completionHandler(announcement, nil);
            }
            return;
        }
        
        if([error.domain isEqualToString:kAnnouncementsFetcherErrorDomain] && error.code == kSaveAnnouncementUnauthorizedError) {
            
            [self.grailsApi refreshAccessTokenGrailsServerUrl:kServerUrl withCompletionHandler:^(NSError *error) {
                if ( error ) {
                    if ( completionHandler) {
                        completionHandler(nil, error);
                    }
                    return;
                }
                [task fetchAnnouncement:primaryKey completionHandler:^(Announcement *announcement, NSError *error) {
                    completionHandler(announcement, error);
                }];
            }];
        } else {
            if ( completionHandler ) {
                completionHandler(nil, error);
            }
        }
    }];
    
}


#pragma mark - Lazy

- (GrailsApi *)grailsApi {
    if ( _grailsApi == nil ) {
        _grailsApi = [[GrailsApi alloc] init];
    }
    return _grailsApi;
}

@end
