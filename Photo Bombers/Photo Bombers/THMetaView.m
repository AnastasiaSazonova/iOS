////
////  THMetaView.m
////  Photo Bombers
////
////  Created by Anastasia on 3/29/14.
////  Copyright (c) 2014 AD. All rights reserved.
////

#import "THMetaView.h"
#import <SAMCategories/NSDate+SAMAdditions.h>

NSString * caption = @"caption";
NSString * created_time = @"created_time";
NSString * user = @"user";
NSString * username = @"username";
NSString * from = @"from";
NSString * profile_picture = @"profile_picture";
NSString * comments = @"comments";
NSString * likes = @"likes";
NSString * count = @"count";
NSString * linkString = @"link";

@interface THMetaView()

@property(nonatomic, strong)UIButton * avatarButton;
@property(nonatomic, strong)UIButton * usernameButton;
@property(nonatomic, strong)UIButton * timeButton;
@property(nonatomic, strong)UIButton * likesButton;
@property(nonatomic, strong)UIButton * commentsButton;

@end

@implementation THMetaView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.usernameButton];
        [self addSubview:self.avatarButton];
        [self addSubview:self.timeButton];
        [self addSubview:self.likesButton];
        [self addSubview:self.commentsButton];
    }
    return self;
}

-(UIButton *)usernameButton
{
    if (!_usernameButton)
    {
        _usernameButton = [[UIButton alloc] initWithFrame:CGRectMake(47.0f, 0.0f, 200.0f, 32.0f)];
        _usernameButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _usernameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIColor * textColor = [[self class] darkColor];
        [_usernameButton setTitleColor:textColor forState:UIControlStateNormal];
        [_usernameButton setTitleColor:[textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        [_usernameButton addTarget:self action:@selector(openUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _usernameButton;
}

-(UIButton *)avatarButton
{
    if (!_avatarButton)
    {
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 32.0f, 32.0f)];
		_avatarButton.layer.cornerRadius = 16.0f;
		_avatarButton.layer.borderColor = [[self class] darkColor].CGColor;
		_avatarButton.layer.borderWidth = 1.0f;
		_avatarButton.layer.masksToBounds = YES;
		_avatarButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0f];
        [_avatarButton addTarget:self action:@selector(openUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}

-(UIButton *)timeButton
{
    if (!_timeButton)
    {
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(260.0f, 0.0f, 50.0f, 32.0f)];
		_timeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		[_timeButton setImage:[UIImage imageNamed:@"time"] forState:UIControlStateNormal];
		_timeButton.adjustsImageWhenHighlighted = NO;
		_timeButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 6.0f);
		_timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
		UIColor *textColor = [[self class]lightColor];
		[_timeButton setTitleColor:textColor forState:UIControlStateNormal];
		[_timeButton setTitleColor:[textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
		[_timeButton addTarget:self action:@selector(openPhoto:) forControlEvents:UIControlEventTouchUpInside];    }
    return _timeButton;
}

- (UIButton *)likesButton
{
	if (!_likesButton) {
		_likesButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 360.0f, 50.0f, 40.0f)];
		_likesButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		[_likesButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
		_likesButton.adjustsImageWhenHighlighted = NO;
		_likesButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 6.0f);
        
		UIColor *textColor = [[self class] lightColor];
		[_likesButton setTitleColor:textColor forState:UIControlStateNormal];
		[_likesButton setTitleColor:[textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
		[_likesButton addTarget:self action:@selector(openPhoto:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _likesButton;
}

- (UIButton *)commentsButton
{
	if (!_commentsButton) {
		_commentsButton = [[UIButton alloc] initWithFrame:CGRectMake(260.0f, 360.0f, 50.0f, 40.0f)];
		_commentsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		[_commentsButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
		_commentsButton.adjustsImageWhenHighlighted = NO;
		_commentsButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 6.0f);
		_commentsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
		UIColor *textColor = [[self class] lightColor];
		[_commentsButton setTitleColor:textColor forState:UIControlStateNormal];
		[_commentsButton setTitleColor:[textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
		[_commentsButton addTarget:self action:@selector(openPhoto:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _commentsButton;
}

-(void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    NSDate * createdAt = [NSDate dateWithTimeIntervalSince1970:[_photo[created_time]doubleValue]];
    [self.timeButton setTitle:[createdAt sam_briefTimeInWords] forState:UIControlStateNormal];
    [self.usernameButton setTitle:self.photo[user][username] forState:UIControlStateNormal];
    [self.likesButton setTitle:[NSString stringWithFormat:@"%@",self.photo[likes][count]] forState:UIControlStateNormal];
    [self.commentsButton setTitle:[NSString stringWithFormat:@"%@", self.photo[comments][count]] forState:UIControlStateNormal];
    NSURL *imageURL = [NSURL URLWithString:self.photo[user][profile_picture]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    [self.avatarButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
}

#pragma mark -Actions

-(void)openUserProfile:(id)sender
{
    NSString * userProfileURLString = [NSString stringWithFormat:@"http://instagram.com/%@", self.photo[user][username]];
    NSURL * userProfileURL = [NSURL URLWithString:userProfileURLString];
    [[UIApplication sharedApplication] openURL:userProfileURL];
}

-(void)openPhoto:(id)sender
{
    NSString * usersPhotoURLString = self.photo[linkString];
    NSURL * userPhotoURL = [NSURL URLWithString:usersPhotoURLString];
    [[UIApplication sharedApplication] openURL:userPhotoURL];
}

#pragma mark -private
+(UIColor *)darkColor
{
    return [UIColor colorWithRed:0.949f green:0.510f blue:0.380f alpha:1.0f];
}
                              
+ (UIColor *)lightColor
{
    return [UIColor colorWithRed:0.973f green:0.753f blue:0.686f alpha:1.0f];
}

@end
