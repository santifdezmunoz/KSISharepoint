//
//  KSISPItem.m
//  Pods
//
//  Created by Santi Fernández Muñoz on 29/10/14.
//
//

#import "KSISPItem.h"

@implementation KSISPItem

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"title": @"Title",
             @"guid": @"Id"
             };
}

//+ (NSValueTransformer *) titleJSONTransformer {
//    return [NSValueTransformer valueTransformerForName:MTL];
//}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    
    if (self) {
        //Store a value that needs to be determined locally upon initialization
    }
    
    return self;
}

@end
