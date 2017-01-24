#import "SaveAnnouncementTask.h"
#import "AnnouncementBuilder.h"
#import "GrailsApi.h"

@interface SaveAnnouncementTask () <NSURLSessionDelegate>

@property (nonatomic, strong)AnnouncementBuilder *builder;

@end

@implementation SaveAnnouncementTask


#pragma mark - LifeCycle

#pragma mark - Public

- (void)saveAnnouncementWithTitle:(NSString *)title body:(NSString *)body completionHandler:(void (^)(Announcement *announcement, NSError *))completionHandler {
    
    NSURLRequest *urlRequest = [self saveAnnouncementRequestWithTitle:title body:body];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            if ( completionHandler ) {
                completionHandler(nil, [self failureError]);
            }
            return;
        }
        
        NSInteger statusCode = [((NSHTTPURLResponse*)response) statusCode];
        
        if ( statusCode == 401 ) {
            if ( completionHandler ) {
                completionHandler(nil, [self unauthorizedError]);
            }
            return;
        }
        
        if ( statusCode == 403 ) {
            if ( completionHandler ) {
                completionHandler(nil, [self forbiddenError]);
            }
            return;
        }
        
        if(statusCode == 201) {
            NSString *objectNotation = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *builderError;
            Announcement *annoucement = [self.builder announcementFromJSON:objectNotation error:&builderError];
            if(builderError) {
                if ( completionHandler ) {
                    completionHandler(nil, [self failureError]);
                }
                return;
            }
        
            if ( completionHandler ) {
                completionHandler(annoucement, nil);
            }
            return;
        }
        
        if ( completionHandler ) {
            completionHandler(nil, [self failureError]);
        }
        return;
        
    }];
    [dataTask resume];
}

#pragma mark - Private methods


- ( NSError *)unauthorizedError {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    return [NSError errorWithDomain:kSaveAnnouncementErrorDomain
                               code:kSaveAnnouncementUnauthorizedError
                           userInfo:userInfo];
}

- ( NSError *)forbiddenError {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    return [NSError errorWithDomain:kSaveAnnouncementErrorDomain
                               code:kSaveAnnouncementForbiddenError
                           userInfo:userInfo];
}

- ( NSError *)failureError {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    return [NSError errorWithDomain:kSaveAnnouncementErrorDomain
                               code:kSaveAnnouncementFailureError
                           userInfo:userInfo];
}




- (NSURLRequest *)saveAnnouncementRequestWithTitle:(NSString *)title body:(NSString *)body {
    NSDictionary *params = @{@"title": title, @"body": body};
    NSData *data = [GrailsApi buildJSONBodyDataWithParams:params];
    return [super postURLRequestWithUrlString:[self saveAnnouncementURLString] jsonData:data];
}

- (NSString *)saveAnnouncementURLString {
    return [NSString stringWithFormat:@"%@/%@", kServerUrl, kAnnouncementsResourcePath];
}



#pragma mark - Lazy

- (AnnouncementBuilder *)builder {
    if ( _builder == nil) {
        _builder = [[AnnouncementBuilder alloc] init];
    }
    return _builder;
}

@end

NSString *kSaveAnnouncementErrorDomain = @"saveAnnouncementErrorDomain";
