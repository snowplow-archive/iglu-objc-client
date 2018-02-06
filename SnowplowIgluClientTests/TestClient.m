//
//  TestClient.m
//  SnowplowIgluClient
//
//  This program is licensed to you under the Apache License Version 2.0,
//  and you may not use this file except in compliance with the Apache License
//  Version 2.0. You may obtain a copy of the Apache License Version 2.0 at
//  http://www.apache.org/licenses/LICENSE-2.0.
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the Apache License Version 2.0 is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
//  express or implied. See the Apache License Version 2.0 for the specific
//  language governing permissions and limitations there under.
//
//  Authors: Joshua Beemster
//  Copyright: Copyright (c) 2015 Snowplow Analytics Ltd
//  License: Apache License Version 2.0
//

#import <XCTest/XCTest.h>
#import "IGLUConstants.h"
#import "IGLUClient.h"
#import "IGLUUtilities.h"
#import "IGLUResolver.h"

@interface TestClient : XCTestCase

@end

@implementation TestClient

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitWithString {
    NSString * jsonStr = [IGLUUtilities getStringWithFilePath:@"iglu_resolver.json" andDirectory:@"TestResources" andBundle:[NSBundle bundleForClass:[self class]]];
    IGLUClient * client = [[IGLUClient alloc] initWithJsonString:jsonStr andBundles:[[NSMutableArray alloc] initWithObjects:[NSBundle bundleForClass:[self class]], nil]];
    
    XCTAssertNotNil(client);
    XCTAssertEqual(500, client.getCacheSize);
    XCTAssertEqual(2, client.getSuccessSize);
    XCTAssertEqual(0, client.getFailedSize);
    XCTAssertEqual(3, client.getResolvers.count);
    XCTAssertTrue(client.getBundles.count > 0);
    
    [client clearCaches];
    XCTAssertEqual(0, client.getSuccessSize);
    XCTAssertEqual(0, client.getFailedSize);
}

- (void)testInitWithUrl {
    IGLUClient * client = [[IGLUClient alloc] initWithUrlPath:@"https://raw.githubusercontent.com/snowplow/snowplow/master/3-enrich/config/iglu_resolver.json" andBundles:[[NSMutableArray alloc] initWithObjects:[NSBundle bundleForClass:[self class]], nil]];
    
    XCTAssertNotNil(client);
    XCTAssertEqual(500, client.getCacheSize);
    XCTAssertEqual(2, client.getSuccessSize);
    XCTAssertEqual(0, client.getFailedSize);
    XCTAssertEqual(3, client.getResolvers.count);
    
    [client clearCaches];
    XCTAssertEqual(0, client.getSuccessSize);
    XCTAssertEqual(0, client.getFailedSize);
}

- (void)testInvalidJson {
    NSString * jsonStr = [IGLUUtilities getStringWithFilePath:@"iglu_resolver.json" andDirectory:@"TestResources" andBundle:[NSBundle bundleForClass:[self class]]];
    IGLUClient * client = [[IGLUClient alloc] initWithJsonString:jsonStr andBundles:[[NSMutableArray alloc] initWithObjects:[NSBundle bundleForClass:[self class]], nil]];
    
    XCTAssertFalse([client validateJson:nil]);
    XCTAssertEqual(2, client.getSuccessSize);
    
    NSMutableDictionary * sdj = [[NSMutableDictionary alloc] init];
    [sdj setObject:@"iglu:com.acme/mobile_context/jsonschema/1-0-1" forKey:@"schema"];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:@"OSX" forKey:@"osType"];
    [sdj setObject:data forKey:@"data"];
    
    XCTAssertFalse([client validateJson:sdj]);
    XCTAssertEqual(2, client.getSuccessSize);
    XCTAssertEqual(1, client.getFailedSize);
    XCTAssertFalse([client validateJson:sdj]);
    XCTAssertEqual(2, client.getSuccessSize);
    XCTAssertEqual(1, client.getFailedSize);
    
    sdj = [[NSMutableDictionary alloc] init];
    [sdj setObject:@"world" forKeyedSubscript:@"hello"];
    
    XCTAssertFalse([client validateJson:sdj]);
    XCTAssertEqual(2, client.getSuccessSize);
    XCTAssertEqual(1, client.getFailedSize);
}

- (void)testValidSelfDescribingJson {
    NSMutableDictionary * sdj = [[NSMutableDictionary alloc] init];
    [sdj setObject:@"iglu:com.snowplowanalytics.snowplow/mobile_context/jsonschema/1-0-1" forKey:@"schema"];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:@"OSX" forKey:@"osType"];
    [data setObject:@"OSX" forKey:@"osVersion"];
    [data setObject:@"OSX" forKey:@"deviceManufacturer"];
    [data setObject:@"OSX" forKey:@"deviceModel"];
    [sdj setObject:data forKey:@"data"];
    
    NSString * jsonStr = [IGLUUtilities getStringWithFilePath:@"iglu_resolver.json" andDirectory:@"TestResources" andBundle:[NSBundle bundleForClass:[self class]]];
    IGLUClient * client = [[IGLUClient alloc] initWithJsonString:jsonStr andBundles:[[NSMutableArray alloc] initWithObjects:[NSBundle bundleForClass:[self class]], nil]];
    
    XCTAssertTrue([client validateJson:sdj]);
    XCTAssertEqual(3, client.getSuccessSize);
}

- (void)testInvalidSelfDescribingJson {
    NSMutableDictionary * sdj = [[NSMutableDictionary alloc] init];
    [sdj setObject:@"iglu:com.snowplowanalytics.snowplow/mobile_context/jsonschema/1-0-1" forKey:@"schema"];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:@"OSX" forKey:@"osType"];
    [sdj setObject:data forKey:@"data"];
    
    NSString * jsonStr = [IGLUUtilities getStringWithFilePath:@"iglu_resolver.json" andDirectory:@"TestResources" andBundle:[NSBundle bundleForClass:[self class]]];
    IGLUClient * client = [[IGLUClient alloc] initWithJsonString:jsonStr andBundles:[[NSMutableArray alloc] initWithObjects:[NSBundle bundleForClass:[self class]], nil]];
    
    XCTAssertFalse([client validateJson:sdj]);
    XCTAssertEqual(3, client.getSuccessSize);
}

@end
