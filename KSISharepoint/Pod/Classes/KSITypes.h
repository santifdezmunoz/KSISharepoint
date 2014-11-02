//
//  KSITypes.h
//  KSISharepoint
//
//  Created by Santi Fernández Muñoz on 22/10/14.
//  Copyright (c) 2014 Santi Fernández Muñoz. All rights reserved.
//

#ifndef KSISharepoint_KSITypes_h
#define KSISharepoint_KSITypes_h

// Supported Versions of Sharepoint Authentication
typedef NS_ENUM(int, KSISPVersionAuth) {
    kAuthSharepointOffice365,
    kAuthSharepoint2013,
    kAuthSharepoint2010,
    kAuthSharepoint2007
} ;


// Error codes
typedef NS_ENUM(int, KSIAuthErrorDomain) {
    kAuthErrorDomainUnauthorized        = 1,
    kAuthErrorDomainURLNotReacheable    = 2
};

// List types
typedef NS_ENUM(int, KSIListTemplateType) {
    kListTemplateGenericList            = 100, //Custom list
    kListTemplateDocumentLibrary        = 101, //Document library
    kListTemplateSurvey                 = 102, //Survey
    kListTemplateLinks                  = 103, //Links
    kListTemplateAnnouncements          = 104,
    kListTemplateContacts               = 105,
    kListTemplateEvents                 = 106,
    kListTemplateTasks                  = 107,
    kListTemplateDiscussionBoard        = 108,
    kListTemplatePictureLibrary         = 109
};
#endif