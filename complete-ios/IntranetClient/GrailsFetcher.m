#import "GrailsFetcher.h"
#import <GrailsSpringSecurityRestObjc/GrailsApi.h>

@interface GrailsFetcher () <NSURLSessionDelegate>

@property (nonatomic, strong)GrailsApi *grailsApi;

@end

@implementation GrailsFetcher

#pragma mark - LifeCycle

- (id)init {
    if(self = [super init]) {
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration
                                                     delegate:self
                                                delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}


#pragma mark - Public


- (NSURLRequest *)getURLRequestWithUrlString:(NSString *)urlString
                                 cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                             timeoutInterval:(NSTimeInterval)timeoutInterval {    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:FAST_TIME_INTERVAL];
    [urlRequest setHTTPMethod:@"GET"];
    
    [[self headers] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [urlRequest setValue:obj forHTTPHeaderField:key];
    }];
    return urlRequest;
}

- (NSURLRequest *)postURLRequestWithUrlString:(NSString *)urlString
                                     jsonData:(NSData *)data {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:FAST_TIME_INTERVAL];
    if ( data ) {
        [urlRequest setHTTPBody:data];
    }
    [urlRequest setHTTPMethod:@"POST"];
    NSString *postLength = [NSString stringWithFormat:@"%@",@([data length])];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];

    [[self headers] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [urlRequest setValue:obj forHTTPHeaderField:key];
    }];
    return urlRequest;
}

#pragma mark - Private

- (NSDictionary *)headers {    
    NSString *accessToken = [self.grailsApi accessToken];
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]  init];
    [mutableDict setObject:kApiVersion forKey:@"Accept-Version"];
    if ( accessToken != nil ) {
        [mutableDict setObject:[NSString stringWithFormat:@"Bearer %@", accessToken] forKey:@"Authorization"];
    }
    
    return [mutableDict copy];
}

#pragma mark - Lazy

- (GrailsApi *)grailsApi {
    if(!_grailsApi) {
        _grailsApi = [[GrailsApi alloc] init];
    }
    return _grailsApi;
}

@end
