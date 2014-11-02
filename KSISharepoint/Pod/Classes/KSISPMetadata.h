//
//  KSISPMetadata.h
//  Pods
//
//  Created by Santi Fernández Muñoz on 29/10/14.
//
//

#import <Mantle.h>

@interface KSISPMetadata : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) NSString *etag;

@end
