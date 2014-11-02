//
//  KSISPO365Authenticator.m
//  
//
//  Created by Santi Fernández Muñoz on 22/10/14.
//
//

#import <AFNetworking.h>

#import "KSISPO365Authenticator.h"

@implementation KSISPO365Authenticator

{
    NSString *soapTemplate;
}

// In O365 username must comply with email format so we should check it before using it
// @todo: Implement username format checker
-(void) setUsername:(NSString *)user {
    super.username = user;
}

// logonSite must be a well formed URL
// @todo: Implemente URL site checker
- (void) setLogonSite:(NSString *)site {
    super.logonSite = site;
}

- (instancetype) initAuthForVersion:(KSISPVersionAuth)version {
    NSAssert(version == kAuthSharepointOffice365, @"Incorrect version, this class is only valid for O365 Authetication");
    
    if (self = [super init]) {

    }

    return self;
}

- (instancetype) initAuthForVersion:(KSISPVersionAuth)version atSite:(NSString *)site withUser:(NSString *)user andPassword:(NSString *)password {
    self = [self initAuthForVersion:version];
    self.username = user;
    self.password = password;
    self.logonSite = site;
    
    return self;
}

- (void) authenticateWithSuccessBlock:(void (^)())success andFailBlock:(void (^)(NSError *))fail {
    
    soapTemplate =  @"<?xml version='1.0' encoding='utf-8'?> \
    <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> \
    <soap:Body> \
    <Login xmlns='http://schemas.microsoft.com/sharepoint/soap/'> \
    <username>%@</username> \
    <password>%@</password> \
    </Login> \
    </soap:Body> \
    </soap:Envelope>";
    
    soapTemplate = [NSString stringWithFormat:soapTemplate, self.username, self.password];
    
    NSURL *siteURL = [NSURL URLWithString:[self.logonSite stringByAppendingString:@"_vti_bin/authentication.asmx"]];
    NSMutableURLRequest *requestURL = [NSMutableURLRequest requestWithURL:siteURL];
    [requestURL setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [requestURL setValue:@"http://schemas.microsoft.com/sharepoint/soap/Login" forHTTPHeaderField:@"SOAPAction"];
    [requestURL setHTTPMethod:@"POST"];
    [requestURL setHTTPBody:[soapTemplate dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Authentication success");
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Authentication failure");
        fail(error);
    }];
    
    [operation start];
}

@end
