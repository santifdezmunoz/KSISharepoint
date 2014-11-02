//
//  KSISharepointSessionManager.m
//  Pods
//
//  Created by Santi Fernández Muñoz on 23/10/14.
//
//

#import "KSISharepointSessionManager.h"
#import "KSISPList.h"
#import "KSISPMetadata.h"

@implementation KSISharepointSessionManager

{

    BOOL captureBinaryToken;
    BOOL captureEndpointURL;
    NSMutableString *binaryToken;
    NSMutableString *endPoint;
    NSString *formDigestValue;
    NSString *userAgent;
}

static KSISharepointSessionManager *SINGLETON = nil;

static bool isFirstAccess = YES;


#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[KSISharepointSessionManager alloc] init];
}

- (id)mutableCopy
{
    return [[KSISharepointSessionManager alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    [self initializeVariables];
    return self;
}

#pragma mark - AFHTTPSessionManager inits

- (id) initWithBaseURL:(NSURL *)url {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024 //10MB memory cache
                                                      diskCapacity:50 * 1024 * 1024 //50MB on disk cache
                                                          diskPath:nil];
    configuration.URLCache = cache;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    [self initializeVariables];
    return self;
}

- (id) initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    
    if (!configuration.URLCache) {
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024 //10MB memory cache
                                                          diskCapacity:50 * 1024 * 1024 //50MB on disk cache
                                                              diskPath:nil];
        configuration.URLCache = cache;
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    [self initializeVariables];
    return self;
}

- (id) initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    
    if (!configuration.URLCache) {
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024 //10MB memory cache
                                                          diskCapacity:50 * 1024 * 1024 //50MB on disk cache
                                                              diskPath:nil];
        configuration.URLCache = cache;
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    self = [super initWithSessionConfiguration:configuration];
    [self initializeVariables];
    return self;
}

- (void) initializeVariables {
    captureEndpointURL = NO;
    captureBinaryToken = NO;
    binaryToken = [[NSMutableString alloc] init];
    endPoint = [[NSMutableString alloc] init];
    userAgent = @"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)";
}

#pragma mark - Authentication methods

- (void) authenticateVersion: (KSISPVersionAuth) version
                    withUser: (NSString *) user
                withPassword: (NSString *) pass
            withSuccessBlock:(void (^)())success
                andFailBlock:(void (^)(NSError *))fail {
    NSAssert(version == kAuthSharepointOffice365, @"Unsuported Sharepoint Version");
    [self authenticateO365WithUser:user withPassword:pass withSuccessBlock:success andFailBlock:fail];
}

- (void) authenticateO365WithUser: (NSString *) user
                     withPassword: (NSString *) pass
                 withSuccessBlock:(void (^)())success
                     andFailBlock:(void (^)(NSError *))fail {
    
    NSString *soapTemplate =  @"<?xml version=\"1.0\" encoding=\"utf-8\"?><s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:u=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\"><s:Header><a:Action s:mustUnderstand=\"1\">http://schemas.xmlsoap.org/ws/2005/02/trust/RST/Issue</a:Action><a:MessageID>urn:uuid:%@</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">https://login.microsoftonline.com/extSTS.srf</a:To><o:Security s:mustUnderstand=\"1\" xmlns:o=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\"><u:Timestamp u:Id=\"_0\"><u:Created>%@</u:Created><u:Expires>%@</u:Expires></u:Timestamp><o:UsernameToken u:Id=\"uuid-%@-1\"><o:Username>%@</o:Username><o:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">%@</o:Password></o:UsernameToken></o:Security></s:Header><s:Body><t:RequestSecurityToken xmlns:t=\"http://schemas.xmlsoap.org/ws/2005/02/trust\"><wsp:AppliesTo xmlns:wsp=\"http://schemas.xmlsoap.org/ws/2004/09/policy\"><a:EndpointReference><a:Address>%@/_forms/default.aspx?wa=wsignin1.0</a:Address></a:EndpointReference></wsp:AppliesTo><t:KeyType>http://schemas.xmlsoap.org/ws/2005/05/identity/NoProofKey</t:KeyType><t:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</t:RequestType><t:TokenType>urn:oasis:names:tc:SAML:1.0:assertion</t:TokenType></t:RequestSecurityToken></s:Body></s:Envelope>";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate *timeNow = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDate *timeExpiry = [NSDate dateWithTimeIntervalSinceNow:300];
    
    NSString *msgId = [[[NSUUID UUID] UUIDString] lowercaseString];
    NSString *usernameTokenId = [[[NSUUID UUID] UUIDString] lowercaseString];
    
    soapTemplate = [NSString stringWithFormat:soapTemplate, msgId, [dateFormatter stringFromDate:timeNow], [dateFormatter stringFromDate:timeExpiry], usernameTokenId, user, pass, [self.baseURL absoluteString]];
    //TODO: Check that site is a well formed URL string
    
    NSURL *logonURL = [NSURL URLWithString:@"https://login.microsoftonline.com/extSTS.srf"];
    NSMutableURLRequest *requestURL = [NSMutableURLRequest requestWithURL:logonURL];
    NSDictionary *headers = @{@"Content-Type":@"text/xml; charset=utf-8",
                              @"User-Agent":userAgent};
    
    [requestURL setAllHTTPHeaderFields:headers];
    [requestURL setHTTPMethod:@"POST"];
    [requestURL setHTTPBody:[soapTemplate dataUsingEncoding:NSUTF8StringEncoding]];
    [requestURL setHTTPShouldHandleCookies:YES];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/soap+xml", nil];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSXMLParser *xmlParser = (NSXMLParser *) responseObject;
        xmlParser.delegate = self;
        xmlParser.shouldProcessNamespaces = YES;
        [xmlParser parse];
        
        NSMutableURLRequest *secondRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endPoint]];

        NSDictionary *headers = @{@"Content-Type":@"application/x-www-form-urlencoded",
                                  @"User-Agent":userAgent};
        [secondRequest setAllHTTPHeaderFields:headers];
        [secondRequest setHTTPMethod:@"POST"];
        [secondRequest setHTTPBody:[binaryToken dataUsingEncoding:NSUTF8StringEncoding]];
        AFHTTPRequestOperation *secondOperation = [[AFHTTPRequestOperation alloc] initWithRequest:secondRequest];
        secondOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
        [secondOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableURLRequest *thirdRequest = [NSMutableURLRequest requestWithURL:[self.baseURL URLByAppendingPathComponent:@"_api/contextinfo"]];
            NSDictionary *headers = @{@"Content-Type":@"application/x-www-form-urlencoded",
                                      @"User-Agent":userAgent,
                                      @"Accept":@"application/json;odata=verbose"};
            [thirdRequest setAllHTTPHeaderFields:headers];
            [thirdRequest setHTTPMethod:@"POST"];
            AFHTTPRequestOperation *thirdOperation = [[AFHTTPRequestOperation alloc] initWithRequest:thirdRequest];
            thirdOperation.responseSerializer = [AFJSONResponseSerializer serializer];
            [thirdOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict = (NSDictionary *) responseObject;
                if ([dict objectForKey:@"d"] &&
                    [dict[@"d"] objectForKey:@"GetContextWebInformation"] &&
                    [dict[@"d"][@"GetContextWebInformation"] objectForKey:@"FormDigestValue"]) {
                    formDigestValue = dict[@"d"][@"GetContextWebInformation"][@"FormDigestValue"];
                    success();
                } else {
                    //TODO: Create an enum in order to standarize error codes
                    NSError *error = [NSError errorWithDomain:@"KSISPAuthenticationERROR" code:1 userInfo:nil];
                    fail(error);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                fail(error);
            }];
            
            [thirdOperation start];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            fail(error);
        }];
        
        [secondOperation start];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Authentication failure");
        fail(error);
    }];
    
    [operation start];
}

#pragma mark - fetching methods

- (void) fetchSitesWithBlock:(void (^)(NSArray *, NSError *))completion {
    
    NSString *path = @"_api/site/Features";
    //set request headers in order to get response in JSON format
    [self.requestSerializer setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"response: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error: %@", error);
        completion(nil, error);
    }];
}

- (void) fetchListsWithBlock: (void (^)(NSArray *, NSError *)) completion {
    NSString *path = @"_api/web/lists";
    //set request headers in order to get response in JSON format
    [self.requestSerializer setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSDictionary *params = @{
                             @"$filter":@"Hidden eq false"
                             };
    [self GET:path parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSArray *results = responseObject[@"d"][@"results"];
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:KSISPList.class];
        NSArray *lists = [transformer transformedValue:results];
        completion(lists,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error %@", error);
        completion(nil, error);
    }];
}

- (void) fetchListByName:(NSString *)listName withBlock:(void (^)(KSISPList *, NSError *))completion {
    NSString *path = [[NSString stringWithFormat:@"_api/web/lists/getByTitle('%@')", listName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //set request headers in order to get response in JSON format
    [self.requestSerializer setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
//        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:KSISPList.class];
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:KSISPList.class];
        KSISPList *list = [transformer transformedValue:responseObject[@"d"]];
        completion(list,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error %@", error);
        completion(nil, error);
    }];
}

//TODO: include a GUID pattern checker for the param listGUID
- (void) fetchListByGUID:(NSString *)listGUID withBlock:(void (^)(KSISPList *, NSError *))completion {
    NSString *path = [[NSString stringWithFormat:@"_api/web/Lists(guid'%@')", listGUID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //set request headers in order to get response in JSON format
    [self.requestSerializer setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        //        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:KSISPList.class];
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:KSISPList.class];
        KSISPList *list = [transformer transformedValue:responseObject[@"d"]];
        completion(list,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error %@", error);
        completion(nil, error);
    }];
}

#pragma mark - Modify methods

- (void) modifyList: (KSISPList *) list withBlock: (void (^)()) success failure: (void (^)(NSError *error)) fail {
    
}

#pragma mark - Adding objects methods

- (void) addItem: (KSISPItem *) item toList:(KSISPList *) list withBlock: (void (^)()) success failure: (void (^)(NSError *error)) fail {
    
}

#pragma mark - Creation methods

- (void) createList:(KSISPList *)list withBlock:(void (^)())success failure:(void (^)(NSError *))fail {

    //Override any metadata in order to ensure that correct metadata is appended
    KSISPMetadata *metadata = [[KSISPMetadata alloc] init];
    metadata.type = @"SP.List";
    metadata.etag = @"0"; //Correct this
    list.metadata = metadata;
    list.guid = @"00000000-0000-0000-0000-000000000000";
    
    NSDictionary *listDict = [MTLJSONAdapter JSONDictionaryFromModel:list];
    NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:listDict];
    
    NSString *path = @"_api/web/lists";
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"accept"];
    [self.requestSerializer setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"content-type"];
//    [self.requestSerializer setValue:[@"Bearer " stringByAppendingString:binaryToken] forHTTPHeaderField:@"Authorization"]; //This header should be used only if OAuth is used to authenticate user
    [self.requestSerializer setValue:formDigestValue forHTTPHeaderField:@"X-RequestDigest"];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[listData length]] forHTTPHeaderField:@"content-length"];
    [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    [self POST:path parameters:listDict success:^(NSURLSessionDataTask *task, id responseObject) {
#ifdef DEBUG
        NSLog(@"List %@ created succesfully: %@", list.title, responseObject);
#endif
        success();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
#ifdef DEBUG
        NSLog(@"Error creating %@: %@", list.title, error);
#endif
        fail(error);
    }];
}

#pragma mark - NSXMLParserDelegate

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"BinarySecurityToken"]) {
        captureBinaryToken = NO;
    } else if ([elementName isEqualToString:@"EndpointReference"]) {
        captureEndpointURL = NO;
    }
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"BinarySecurityToken"]) {
        captureBinaryToken = YES;
    } else if ([elementName isEqualToString:@"EndpointReference"]) {
        captureEndpointURL = YES;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (captureEndpointURL) {
        [endPoint appendString:string];
    }
    if (captureBinaryToken) {
        [binaryToken appendString:string];
    }
}

@end
