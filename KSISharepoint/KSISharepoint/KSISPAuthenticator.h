//
//  KSISharepoint.h
//  KSISharepoint
//
//  Created by Santi Fernández Muñoz on 19/10/14.
//  Copyright (c) 2014 Santi Fernández Muñoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSITypes.h"

/**
 * This class performs the authentication against different version of Sharepoint.
 *
 * This class do not perform any OAuth authentication. If you need OAuth authentication
 * use ADALiOS.
 *
 * @property: username
 * @property: password
 * @property: logonSite
 *
 * @todo: Implement authentication for Sharepoint OnPremise 2013, 2010 & 2007
 */

@interface KSISPAuthenticator : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *logonSite;

/**
 * This initializator creates a Authenticator with an implementation specific for
 * each supported version of Sharepoint. Once the Authenticator object has been creted
 * it is necesary to provide user, password and site to perform the authentication
 *
 * @param: version, refers to the version of Sharepoint for which this Authenticator
 * will perform any authentication. Supported versions are:
 *      - Office 365
 *      - Sharepoint OnPremises 2013
 *      - Sharepoint OnPremises 2010
 *      - Sharepoint OnPremises 2007
 */
- (instancetype) initAuthForVersion: (KSISPVersionAuth) version;

/**
 * This initializator creates a Authenticator with an implementation specific for
 * each supported version of Sharepoint. User, password and logon site are passed as
 * a parameter of the method. 
 *
 * @param: version, refers to the version of Sharepoint for which this Authenticator
 * will perform any authentication. Supported versions are:
 *      - Office 365
 *      - Sharepoint OnPremises 2013
 *      - Sharepoint OnPremises 2010
 *      - Sharepoint OnPremises 2007
 * @param: username
 * @param: password
 * @param: site
 */
- (instancetype) initAuthForVersion:(KSISPVersionAuth)version atSite: (NSString *) site withUser: (NSString *) user andPassword: (NSString *) password;

/**
 * This method performs the autentication itself once the object has been correctly
 * initializated.
 *
 * If the authentication is success then success block is executed, in any other case fail
 * block is executed
 */

- (void) authenticateWithSuccessBlock:(void (^)())success andFailBlock:(void (^)(NSError *error))fail;

@end
