//
//  TestResolver.m
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
#import "IGLUResolver.h"

@interface TestResolver : XCTestCase

@end

@implementation TestResolver

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testResolverInitEmbedded {
    IGLUResolver * embedded = [[IGLUResolver alloc] initWithDictionary:[self getEmbeddedResolverDict]];
    XCTAssertEqual(3, embedded.getVendorPrefixes.count);
    XCTAssertEqualObjects(@"Self Embedded", embedded.getName);
    XCTAssertEqualObjects(@"embedded", embedded.getType);
    XCTAssertEqualObjects(kIGLUEmbeddedDirectory, embedded.getPath);
    XCTAssertEqualObjects(nil, embedded.getUri);
    XCTAssertEqual(-1, [embedded.getPriority integerValue]);
}

- (void)testResolverInitHttp {
    IGLUResolver * http = [[IGLUResolver alloc] initWithDictionary:[self getHttpResolverDict]];
    XCTAssertEqual(3, http.getVendorPrefixes.count);
    XCTAssertEqualObjects(@"Self Http", http.getName);
    XCTAssertEqualObjects(@"http", http.getType);
    XCTAssertEqualObjects(nil, http.getPath);
    XCTAssertEqualObjects(@"http://iglucentral.com", http.getUri);
    XCTAssertEqual(-1, [http.getPriority integerValue]);
}

- (void)testSchemaGetWithGoodKey {
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:kIGLUEmbeddedBundle ofType:@"bundle"];
    NSBundle * bundle = [NSBundle bundleWithPath:path];
    
    IGLUResolver * embedded = [[IGLUResolver alloc] initWithDictionary:[self getHttpResolverDict]];
    NSDictionary * schema = [embedded getSchemaForKey:kIGLUInstanceIgluOnly withBundles:[[NSMutableArray alloc] initWithObjects:bundle, nil]];
    
    XCTAssertNotNil(schema);
}

- (void)testSchemaGetWithBadKey {
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:kIGLUEmbeddedBundle ofType:@"bundle"];
    NSBundle * bundle = [NSBundle bundleWithPath:path];
    
    IGLUResolver * embedded = [[IGLUResolver alloc] initWithDictionary:[self getEmbeddedResolverDict]];
    NSDictionary * schema = [embedded getSchemaForKey:@"bad-key" withBundles:[[NSMutableArray alloc] initWithObjects:bundle, nil]];
    XCTAssertNil(schema);
    
    schema = [embedded getSchemaForKey:@"iglu:bad-key" withBundles:[[NSMutableArray alloc] initWithObjects:bundle, nil]];
    XCTAssertNil(schema);
}

// --- Helpers

- (NSDictionary *)getEmbeddedResolverDict {
    NSMutableArray * vendors = [[NSMutableArray alloc] init];
    [vendors addObject:@"com.snowplowanalytics.self-desc"];
    [vendors addObject:@"com.snowplowanalytics.iglu"];
    [vendors addObject:@"com.snowplowanalytics"];
    NSMutableDictionary * path = [[NSMutableDictionary alloc] init];
    [path setObject:kIGLUEmbeddedDirectory forKey:kIGLUResolverPath];
    NSMutableDictionary * embedded = [[NSMutableDictionary alloc] init];
    [embedded setObject:path forKey:kIGLUResolverTypeEmbedded];
    NSMutableDictionary * selfRepo = [[NSMutableDictionary alloc] init];
    [selfRepo setObject:@"Self Embedded" forKey:kIGLUResolverName];
    [selfRepo setObject:vendors forKey:kIGLUResolverVendor];
    [selfRepo setObject:embedded forKey:kIGLUResolverConnection];
    [selfRepo setObject:[NSNumber numberWithInt:-1] forKey:kIGLUResolverPriority];
    
    return selfRepo;
}

- (NSDictionary *)getHttpResolverDict {
    NSMutableArray * vendors = [[NSMutableArray alloc] init];
    [vendors addObject:@"com.snowplowanalytics.self-desc"];
    [vendors addObject:@"com.snowplowanalytics.iglu"];
    [vendors addObject:@"com.snowplowanalytics"];
    NSMutableDictionary * uri = [[NSMutableDictionary alloc] init];
    [uri setObject:@"http://iglucentral.com" forKey:kIGLUResolverUri];
    NSMutableDictionary * http = [[NSMutableDictionary alloc] init];
    [http setObject:uri forKey:kIGLUResolverTypeHttp];
    NSMutableDictionary * selfRepo = [[NSMutableDictionary alloc] init];
    [selfRepo setObject:@"Self Http" forKey:kIGLUResolverName];
    [selfRepo setObject:vendors forKey:kIGLUResolverVendor];
    [selfRepo setObject:http forKey:kIGLUResolverConnection];
    [selfRepo setObject:[NSNumber numberWithInt:-1] forKey:kIGLUResolverPriority];
    
    return selfRepo;
}

@end
