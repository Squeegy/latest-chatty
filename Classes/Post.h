//
//  Post.h
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "TouchXML.h"

@interface Post : NSObject {
  id delegate;
  NSMutableData *partialData;
  
  Post *parent;
  NSString *author;
  NSString *preview;
  NSString *body;
  NSString *category;
  NSDate *date;
  int postId;
  NSMutableArray *children;

	NSURLConnection* theConnection;
	
  int depth;
  int cachedReplyCount;
  int recentIndex;
  int newPostCount;
}

- (id)initWithXmlElement:(CXMLElement *)xml parent:(Post *)aParent lastRefreshDict:(NSMutableDictionary *)lastRefresh;
- (BOOL)parseXml:(CXMLElement *)xml lastRefreshDict:(NSMutableDictionary *)lastRefresh;
  
- (id)initWithThreadId:(int)threadId delegate:(id)aDelegate;

- (NSString *)html;
- (int)replyCount;
- (Post *)postAtIndex:(int)index;
- (NSString *)cleanString:(NSString *)string;
- (void) abortLoadIfLoading;
- (int)compare:(Post *)otherPost;

@property (retain) Post *parent;
@property (readwrite, copy) NSString *author;
@property (readwrite, copy) NSString *preview;
@property (readwrite, copy) NSString *body;
@property (readwrite, copy) NSString *category;
@property (readwrite, copy) NSDate *date;
@property (readwrite) int postId;
@property (retain) NSMutableArray *children;
@property (readwrite, assign) int depth;
@property (readwrite, assign) int cachedReplyCount;
@property (readwrite, assign) int newPostCount;
@property (readonly) NSString *formattedDate;
@property (readwrite) int recentIndex;

@end
