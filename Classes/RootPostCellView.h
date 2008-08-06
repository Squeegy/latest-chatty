//
//  RootPostCellView.h
//  LatestChatty
//
//  Created by Alex Wayne on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface RootPostCellView : UITableViewCell {
  Post *post;
  UILabel *username;
  UILabel *timestamp;
  UILabel *preview;
}

- (id)initLoadMore;
- (id)initWithPost:(Post *)aPost;

@end
