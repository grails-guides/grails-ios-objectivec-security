//
//  ElementBuilderTests.m
//  IntranetClient
//
//  Created by Sergio del Amo on 11/01/2017.
//  Copyright © 2017 OCI. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AnnouncementBuilder.h"
#import "Announcement.h"

@interface AnnouncementBuilderTests : XCTestCase
{
    AnnouncementBuilder *builder;
    NSString *announcementsJSON;
    NSString *announcementJSON;
}
@end

@implementation AnnouncementBuilderTests

- (void)setUp {
    [super setUp];
    builder = [[AnnouncementBuilder alloc] init];
    announcementsJSON = [self fixtureAnnouncements];
    announcementJSON = [self fixtureAnnouncement];
}

- (void)tearDown {
    builder = nil;
    announcementsJSON = nil;
    announcementJSON = nil;
    [super tearDown];
}

- (void)testAnnouncementsFromJSON {
    NSError *error;
    XCTAssertNotNil(announcementsJSON);
    NSArray *announcements = [builder announcementsFromJSON:announcementsJSON error:&error];
    XCTAssertNil(error);
    XCTAssertEqual([announcements count], (NSUInteger)6, @"The builder should have parsed 6 announcements");
    
    for ( id obj in announcements ) {
        XCTAssertTrue([obj isKindOfClass:[Announcement class]]);
        Announcement *announcement = (Announcement *)obj;
        XCTAssertNotNil(announcement.title);
        XCTAssertNotNil(announcement.primaryKey);
        XCTAssertNotNil(announcement.body);
    }
}

- (void)testAnnouncementFromJSON {
    NSError *error;
    XCTAssertNotNil(announcementsJSON);
    Announcement *announcement = [builder announcementFromJSON:announcementJSON error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(announcement.title);
    XCTAssertNotNil(announcement.primaryKey);
    XCTAssertNotNil(announcement.body);
}

#pragma mark - Private methods

- (NSString *)loadJSONString:(NSString *)resourceName {
    NSBundle *bundle =  [NSBundle bundleForClass:[AnnouncementBuilderTests class]];
    NSString *path = [bundle pathForResource:resourceName ofType:@"json" inDirectory:nil];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path] options:@{} completionHandler:nil];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    return content;
}

- (NSString *)fixtureAnnouncement {
    return [self loadJSONString:@"announcement"];
}

- (NSString *)fixtureAnnouncements {
    return [self loadJSONString:@"announcements"];
}

@end
