//
//  TestUtilities.m
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
#import "IGLUUtilities.h"

@interface TestUtilities : XCTestCase

@end

@implementation TestUtilities

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParseGoodJsonString {
    NSMutableDictionary * expected = [[NSMutableDictionary alloc] init];
    [expected setObject:@"world" forKey:@"hello"];
    NSString * jsonStr = @"{\"hello\":\"world\"}";
    NSDictionary * jsonDict = [IGLUUtilities parseToJsonWithString:jsonStr];
    XCTAssertEqualObjects(expected, jsonDict);
}

- (void)testParseBadJsonString {
    NSString * jsonStr = @"\"hello\":\"world\"";
    NSDictionary * jsonDict = [IGLUUtilities parseToJsonWithString:jsonStr];
    XCTAssertEqualObjects(nil, jsonDict);
    
    jsonStr = nil;
    jsonDict = [IGLUUtilities parseToJsonWithString:jsonStr];
    XCTAssertEqualObjects(nil, jsonDict);
}

- (void)testGetJsonStringFromUrl {
    NSString * jsonStr = [IGLUUtilities getStringWithUrlPath:@"http://iglucentral.com/schemas/com.snowplowanalytics.iglu/resolver-config/jsonschema/1-0-0"];
    XCTAssertNotNil(jsonStr);
    
    NSDictionary * jsonDict = [IGLUUtilities parseToJsonWithString:jsonStr];
    XCTAssertNotNil(jsonDict);
}

- (void)testGetJsonDictionaryFromFilePath {
    NSDictionary * jsonDict = [IGLUUtilities getJsonAsDictionaryWithFilePath:@"iglu_resolver.json" andDirectory:@"TestResources" andBundle:[NSBundle bundleForClass:[self class]]];
    XCTAssertNotNil(jsonDict);
    
    jsonDict = [IGLUUtilities getJsonAsDictionaryWithFilePath:@"iglu_resolver_2.json" andDirectory:@"TestResources" andBundle:[NSBundle bundleForClass:[self class]]];
    XCTAssertNil(jsonDict);
}

- (void)testGetJsonStringFromFilePath {
    NSString * jsonStr = [IGLUUtilities getStringWithFilePath:@"iglu_resolver.json" andDirectory:@"TestResources" andBundle:[NSBundle bundleForClass:[self class]]];
    XCTAssertNotNil(jsonStr);
    
    jsonStr = [IGLUUtilities getStringWithFilePath:@"iglu_resolver_2.json" andDirectory:@"TestResources" andBundle:[NSBundle bundleForClass:[self class]]];
    XCTAssertNil(jsonStr);
    
    jsonStr = [IGLUUtilities getStringWithFilePath:nil andDirectory:nil andBundle:[NSBundle bundleForClass:[self class]]];
    XCTAssertNil(jsonStr);
}

- (void)testCheckArgument {
    @try {
        [IGLUUtilities checkArgument:NO withMessage:@"This will throw an exception."];
    }
    @catch (NSException *exception) {
        XCTAssertEqualObjects(@"This will throw an exception.", exception.reason);
    }
}

@end
