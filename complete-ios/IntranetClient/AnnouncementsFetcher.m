#import "AnnouncementsFetcher.h"
#import "AnnouncementBuilder.h"


@interface AnnouncementsFetcher ()

@property ( nonatomic, strong) AnnouncementBuilder *builder;

@end

@implementation AnnouncementsFetcher

#pragma mark - Public

- (void)fetchAnnouncement:(NSNumber *)primaryKey
        completionHandler:(void (^)(Announcement *announcement, NSError *))completionHandler {
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:[self announcementURLRequest:primaryKey] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            if ( completionHandler ) {
                completionHandler(nil, error);
            }
            return;
        }
        
        NSInteger statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if(statusCode == 401) {
            if ( completionHandler ) {
                completionHandler(nil, [self errorWithCode:kAnnouncementsFetcherUnauthorizedError]);
            }
            return;
        }
        
        if(statusCode == 200) {
            NSString *objectNotation = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *builderError;
            Announcement *announcement = [self.builder announcementFromJSON:objectNotation error:&builderError];
            if(builderError) {
                if ( completionHandler ) {
                    completionHandler(nil, builderError);
                }
                return;
            }
            
            if ( completionHandler ) {
                completionHandler(announcement, builderError);
            }
            return;
        }
        
        
        if ( completionHandler ) {
            completionHandler(nil, [self errorWithCode:kAnnouncementsFetcherError]);
        }
    }];
    
    [dataTask resume];
}

- (void)fetchAnnouncementsWithCompletionHandler:(void (^)(NSArray *announcements, NSError *error))completionHandler {

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:[self announcementsURLRequest] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            if ( completionHandler ) {
                completionHandler(nil, error);
            }
            return;
        }
        
        NSInteger statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if(statusCode == 401) {
            if ( completionHandler ) {
                completionHandler(nil, [self errorWithCode:kAnnouncementsFetcherUnauthorizedError]);
            }
            return;
        }
        
        if(statusCode == 200) {
            NSString *objectNotation = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *builderError;
            NSArray *announcements = [self.builder announcementsFromJSON:objectNotation error:&builderError];
            if(builderError) {
                if ( completionHandler ) {
                    completionHandler(nil, builderError);
                }
                return;
            }
            
            if ( completionHandler ) {
                completionHandler(announcements, builderError);
            }
            return;
        }
        
        
        if ( completionHandler ) {
            completionHandler(nil, [self errorWithCode:kAnnouncementsFetcherError]);
        }
    }];
    
    [dataTask resume];
}

#pragma mark - Private Methods


- (NSURLRequest *)announcementsURLRequest {
    NSString *urlStr = [self announcementsURLString];
    return [super getURLRequestWithUrlString:urlStr
                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                             timeoutInterval:FAST_TIME_INTERVAL];
}


- ( NSError *)errorWithCode:(NSInteger)errorCode {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    return [NSError errorWithDomain:kAnnouncementsFetcherErrorDomain
                               code:errorCode
                           userInfo:userInfo];
}


- (NSString *)announcementsURLString {
    return [NSString stringWithFormat:@"%@/%@", kServerUrl, kAnnouncementsResourcePath];
}

- (NSURLRequest *)announcementURLRequest:(NSNumber *)primaryKey {
    NSString *urlStr = [self announcementURLString:primaryKey];
    return [super getURLRequestWithUrlString:urlStr
                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                             timeoutInterval:FAST_TIME_INTERVAL];
}

- (NSString *)announcementURLString:(NSNumber *)primaryKey {
    return [NSString stringWithFormat:@"%@/%@/%@", kServerUrl, kAnnouncementsResourcePath, primaryKey];
}



#pragma mark - Lazy

- (AnnouncementBuilder *)builder {
    if ( _builder == nil ) {
        _builder = [[AnnouncementBuilder alloc] init];
    }
    return _builder;
}

@end

NSString *kAnnouncementsFetcherErrorDomain = @"AnnouncementFetcherErrorDomain";
