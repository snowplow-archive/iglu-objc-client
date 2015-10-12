//
//  TestSchema.m
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
#import "IGLUSchema.h"

@interface TestSchema : XCTestCase

@end

@implementation TestSchema {
    NSRegularExpression * _schemaRegex;
}

- (void)setUp {
    [super setUp];
    _schemaRegex = [NSRegularExpression regularExpressionWithPattern:kIGLUSchemaRegex options:0 error:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSchemaInitWithGoodKey {
    IGLUSchema * schema = [[IGLUSchema alloc] initWithKey:kIGLUInstanceIgluOnly andSchema:nil andRegex:_schemaRegex];
    
    XCTAssertNotNil(schema);
    XCTAssertEqualObjects(nil, schema.getSchema);
    XCTAssertEqualObjects(kIGLUInstanceIgluOnly, schema.getKey);
    XCTAssertEqual(YES, schema.getValid);
    XCTAssertEqualObjects(@"com.snowplowanalytics.self-desc", schema.getVendor);
    XCTAssertEqualObjects(@"instance-iglu-only", schema.getName);
    XCTAssertEqualObjects(@"jsonschema", schema.getFormat);
    XCTAssertEqualObjects(@"1-0-0", schema.getVersion);
}

- (void)testSchemaInitWithBadKey {
    IGLUSchema * schema = [[IGLUSchema alloc] initWithKey:@"iglu:bad-key" andSchema:nil andRegex:_schemaRegex];
    
    XCTAssertNotNil(schema);
    XCTAssertEqualObjects(nil, schema.getSchema);
    XCTAssertEqualObjects(@"iglu:bad-key", schema.getKey);
    XCTAssertEqual(NO, schema.getValid);
    XCTAssertEqualObjects(nil, schema.getVendor);
    XCTAssertEqualObjects(nil, schema.getName);
    XCTAssertEqualObjects(nil, schema.getFormat);
    XCTAssertEqualObjects(nil, schema.getVersion);
}

@end

