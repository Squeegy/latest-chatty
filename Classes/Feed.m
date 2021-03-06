//
//  Feed.m
//  LatestChatty
//
//  Created by Alex Wayne on 7/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Feed.h"

@implementation Feed

@synthesize storyId;
@synthesize lastPageLoaded;

+ (NSString *)urlStringWithPath:(NSString *)path {
  NSString *prefix = [[NSUserDefaults standardUserDefaults] stringForKey:@"api_server"];
  if (prefix == nil) prefix = @"http://ws.shackchatty.com/";
  return [prefix stringByAppendingString:path];
}



// Designated Initializer.
- (id)init {
  [super init];
  posts = [[NSMutableArray alloc] init];
  partialData = [[NSMutableData alloc] init];
  return self;
}

// Init with an XML feed at this URL
- (id)initWithUrl:(NSString *)urlString delegate:(id)aDelegate {
  [self init];
  delegate = [aDelegate retain];
  [self addPostsInFeedWithUrl:urlString];
  return self;
}

// Use the default feed that just includes the latest chatty.
- (id)initWithLatestChattyAndDelegate:(id)aDelegate {
  return [self initWithUrl:[Feed urlStringWithPath:@"index.xml"] delegate:aDelegate];
}

// Get a feed for a specific storyId
- (id)initWithStoryId:(int)aStoryId delegate:(id)aDelegate {
	[aDelegate retain];
  return [self initWithUrl:[Feed urlStringWithPath:[NSString stringWithFormat:@"%d.xml", aStoryId]] delegate:aDelegate];
}

- (void)addPostsInFeedWithUrl:(NSString *)urlString {
	download = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self startImmediately:YES];
	//download = [NSURLConnection connectionWithRequest: delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if( !partialData ) partialData = [[NSMutableData alloc] init];
  [partialData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Died!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	/* FIXME: for some reason, I can't run this in release/distribution 
	 * build. The app fails right here -- can't make a NSString out
	 * of the data coming out of the URL download. I'll fix it sometime.
	 *	Oh, this is in the simulator.
	 */
	[download release];
	download = nil;
	NSString* test = [[NSString alloc] initWithData:partialData encoding:NSASCIIStringEncoding];
	[self addPostsInFeedWithString:test];
	[test release];
	[delegate feedDidFinishLoading];
  [delegate release];
	[partialData release];
	partialData = nil;
	//partialData = [[NSMutableData alloc] init];
}
- (void)abortLoadIfInProgress
{
	if( download ) [download cancel];
}
- (void)addPostsInFeedWithString:(NSString *)dataString {
  NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
  [formatter setDateFormat:@"Dyyyy"];
  NSString* postCountFile = [NSString stringWithFormat:@"/%@/%@.postcount", NSTemporaryDirectory(), [formatter stringFromDate:[NSDate date]]];
	NSMutableDictionary* postCounts = [NSMutableDictionary dictionaryWithContentsOfFile:postCountFile];
  if(postCounts == nil) postCounts = [[[NSMutableDictionary alloc] init] autorelease];
	// Parse XML
	NSError *err=nil;
	xml = [[CXMLDocument alloc] initWithXMLString:dataString options:1 error:&err];
	//[dataString release];
	// Parse response into post objects
	NSArray *postElements = [[xml rootElement] nodesForXPath:@"comment" error:nil];
	int i;
	for (i = 0; i < [postElements count]; i++ ) {
		Post *postObject = [[Post alloc] initWithXmlElement:(CXMLElement*)[postElements objectAtIndex:i] parent:nil lastRefreshDict:postCounts];
		if (postObject != nil) [posts addObject:postObject];
		[postObject release];
	}
	
	storyId         = [[[[xml rootElement] attributeForName:@"story_id"]    stringValue] intValue];
	storyName       =  [[[xml rootElement] attributeForName:@"story_name"]  stringValue];
	lastPageLoaded  = [[[[xml rootElement] attributeForName:@"page"]        stringValue] intValue];
	lastPage        = [[[[xml rootElement] attributeForName:@"last_page"]   stringValue] intValue];
  
  [postCounts description];
  
  [postCounts writeToFile:postCountFile atomically:NO];
	[xml release];
}


// Load the next page of posts.
- (void)loadNextPage {
  if (lastPageLoaded < lastPage) {
    lastPageLoaded++;
    [self addPostsInFeedWithUrl:[Feed urlStringWithPath:[NSString stringWithFormat:@"%d.%d.xml", storyId, lastPageLoaded]]];
  }
}

// Return tue if there are more pages to display
- (BOOL)hasMorePages {
  return lastPageLoaded < lastPage;
}


- (void)dealloc {
  [posts release];
  [super dealloc];
}




- (NSString *)description {
  return [NSString stringWithFormat:@"XMLDoc: %@", [xml description]];
}

- (NSArray *)posts {
  return posts;
}

- (NSString *)storyName {
  return storyName;
}

@end
