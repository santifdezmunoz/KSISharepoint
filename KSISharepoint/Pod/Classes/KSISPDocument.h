//
//  KSISPDocument.h
//  Pods
//
//  Created by Santi Fernández Muñoz on 29/10/14.
//
//

#import <Mantle.h>

@class KSISPMetadata;

@interface KSISPDocument : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, readonly) NSString *guid;
@property (nonatomic, strong) KSISPMetadata *metadata;

@end
