//
//  KSISharepointSessionManager.h
//  Pods
//
//  Created by Santi Fernández Muñoz on 23/10/14.
//
//

#import "AFNetworking.h"
#import "KSITypes.h"

@class KSISPList;
@class KSISPItem;

@interface KSISharepointSessionManager : AFHTTPSessionManager <NSXMLParserDelegate>

/**
 * gets singleton object.
 * @return singleton
 */
+ (KSISharepointSessionManager*)sharedInstance;

/**
 * Authenticates the user at the site that has been configured as baseURL
 *
 * @param, version, sets the Sharepoint version that should be used for authentication
 * @param, user, username to be authenticated
 * @param, pass, password
 * @param, success, block to be executed when authentication is success
 * @param, fail, block to be executed when authentication fails
 */
- (void) authenticateVersion: (KSISPVersionAuth) version
                    withUser: (NSString *) user
                withPassword: (NSString *) pass
            withSuccessBlock:(void (^)())success
                andFailBlock:(void (^)(NSError *))fail;

/**
 * Lists all subsites under a sharepoint collection
 *
 * @param, completion, block that will be executed once that fetching operation finishes.
 */
- (void) fetchSitesWithBlock: (void (^)(NSArray *sites, NSError *error))completion;

/**
 * Get all lists on the site
 *
 * @param, completion, block that will be executed once that fetching operation finishes.
 */
- (void) fetchListsWithBlock: (void (^)(NSArray *lists, NSError *error))completion;

/**
 * Get a list by its name. The list is represented by the class KSISPList
 *
 * @param, listName, name of the list
 * @param, completion, block that will be executed once that fetching operation finishes
 */
- (void) fetchListByName: (NSString *)listName withBlock:(void (^)(KSISPList *list, NSError *error))completion;

/**
 * Get a list by its name. The list is represented by the class KSISPList
 *
 * @param, listGUID, Global Univeral ID that identifies a list inside Sharepoint
 * @param, completion, block that will be executed once that fetching operation finishes
 */
- (void) fetchListByGUID: (NSString *)listGUID withBlock:(void (^)(KSISPList *list, NSError *error))completion;

/**
 * Create a new list in sharepoint
 *
 * @param, list, an KSISPList that represents the list that will be created
 */
- (void) createList: (KSISPList *) list withBlock: (void (^)()) success failure: (void (^)(NSError *error)) fail;

/**
 * Modifies a new list in sharepoint, changing attributes of the list.
 *
 * This method should not be used to add items to the list. Use addItem:toList:withBlock:Failure instead
 *
 * @param, list, an KSISPList that represents the list that will be modified
 */
- (void) modifyList: (KSISPList *) list withBlock: (void (^)()) success failure: (void (^)(NSError *error)) fail;

/**
 * Append a Item to a list
 *
 * @param, item, Item to be added
 * @param, list, list where the item will be added
 */
- (void) addItem: (KSISPItem *) item toList:(KSISPList *) list withBlock: (void (^)()) success failure: (void (^)(NSError *error)) fail;

@end
