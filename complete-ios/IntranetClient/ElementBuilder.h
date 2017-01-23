#import <Foundation/Foundation.h>

@interface ElementBuilder : NSObject

- (NSArray *)arrayFromJSON:(NSString *)objectNotation
                       key:(NSString *)key
                     error:(NSError **)error
      invalidJSONErrorCode:(NSInteger)invalidJSONErrorCode
      missingDataErrorCode:(NSInteger)missingDataErrorCode
               errorDomain:(NSString *)errorDomain;

- (NSDictionary *)parseJSON:(NSString *)objectNotation
                      error:(NSError **)error
       invalidJSONErrorCode:(NSInteger)invalidJSONErrorCode
                errorDomain:(NSString *)errorDomain;
@end
