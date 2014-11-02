//
//  KSISPMetadata.m
//  Pods
//
//  Created by Santi Fernández Muñoz on 29/10/14.
//
//

#import "KSISPMetadata.h"

@implementation KSISPMetadata

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"type": @"type",
             @"guid": @"Id",
             @"uri" : @"uri",
             @"etag" : @"etag"
             };
}

//+ (NSValueTransformer *) titleJSONTransformer {
//    return [NSValueTransformer valueTransformerForName:MTL];
//}

+ (NSValueTransformer *) uriJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    
    if (self) {
        //Store a value that needs to be determined locally upon initialization
    }
    
    return self;
}

@end
