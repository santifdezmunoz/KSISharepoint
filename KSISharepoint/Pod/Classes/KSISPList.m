//
//  KSISPList.m
//  Pods
//
//  Created by Santi Fernández Muñoz on 27/10/14.
//
//

#import "KSISPList.h"
#import "KSISPMetadata.h"

@implementation KSISPList

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"title": @"Title",
             @"guid": @"Id",
             @"metadata" : @"__metadata",
             @"allowContentTypes" : @"AllowContentTypes",
             @"baseTemplate" : @"BaseTemplate",
             @"contentTypesEnabled" : @"ContentTypesEnabled",
             @"listDescription" : @"Description"
             };
}

//+ (NSValueTransformer *) titleJSONTransformer {
//    return [NSValueTransformer valueTransformerForName:MTL];
//}

+ (NSValueTransformer *) metadataJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:KSISPMetadata.class];
}

+ (NSValueTransformer *) allowContentTypesJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *) contentTypesEnabledJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    
    if (self) {
        //Store a value that needs to be determined locally upon initialization
    }
    
    return self;
}
@end
