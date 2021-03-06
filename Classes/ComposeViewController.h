//
//  ComposeViewController.h
//  LatestChatty
//
//  Created by Alex Wayne on 8/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LatestChattyAppDelegate.h"
#import "DetailViewController.h"
#import "ChattyViewController.h"
#import "Post.h"
#import "Image.h"

#import "NSStringAdditions.h"

@interface ComposeViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
  IBOutlet UILabel *parentPreview;
  IBOutlet UITextView *postContent;
  
  Post *parentPost;
  int storyId;
  UIImagePickerController *imagePickerController;
}

- (id)initWithStoryId:(int)aStoryId;
- (id)initWithStoryId:(int)aStoryId parentPost:(Post *)aPost;

- (IBAction)toggleKeyboard:(id)sender;
- (IBAction)sendPost:(id)sender;
- (void)sendPostConfirmed;

- (IBAction)tag:(id)sender;
- (IBAction)insert:(id)sender;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)chosenImage editingInfo:(NSDictionary *)editingInfo;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

- (void)postImage:(UIImagePickerControllerSourceType)sourceType;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
