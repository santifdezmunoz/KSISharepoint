//
//  KSISharepoint.m
//  KSISharepoint
//
//  Created by Santi Fernández Muñoz on 19/10/14.
//  Copyright (c) 2014 Santi Fernández Muñoz. All rights reserved.
//

#import "KSISPAuthenticator.h"
#import "KSISPO365Authenticator.h"

@implementation KSISPAuthenticator

-(instancetype) initAuthForVersion:(KSISPVersionAuth)version {
    NSAssert(version == kAuthSharepointOffice365, @"Version not yet implemented");
    return [[KSISPO365Authenticator alloc] initAuthForVersion:version];
}

- (instancetype) initAuthForVersion:(KSISPVersionAuth)version atSite:(NSString *)site withUser:(NSString *)user andPassword:(NSString *)password {
    self = [self initAuthForVersion:version];
    self.username = user;
    self.password = password;
    self.logonSite = site;
    
    return self;
}

- (void) authenticateWithSuccessBlock:(void (^)())success andFailBlock:(void (^)(NSError *error))fail {
    NSAssert(NO, @"This method should not be called directly on the class %@", [self class]);
}

@end
