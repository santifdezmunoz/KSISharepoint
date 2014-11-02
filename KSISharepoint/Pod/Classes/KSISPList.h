//
//  KSISPList.h
//  Pods
//
//  Created by Santi Fernández Muñoz on 27/10/14.
//
//

#import <Mantle.h>
#import "KSITypes.h"

@class KSISPMetadata;

@interface KSISPList : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *guid;
@property (nonatomic, strong) KSISPMetadata *metadata;
@property (nonatomic, copy) NSString *listDescription;
@property BOOL contentTypesEnabled;
@property BOOL allowContentTypes;
@property KSIListTemplateType baseTemplate; //Generic List Reference: http://msdn.microsoft.com/en-us/library/microsoft.sharepoint.splisttemplatetype(v=office.15).aspx

@end
