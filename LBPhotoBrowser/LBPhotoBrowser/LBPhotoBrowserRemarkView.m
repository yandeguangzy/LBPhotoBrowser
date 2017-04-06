//
//  LBPhotoBrowserRemarkView.m
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/21.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import "LBPhotoBrowserRemarkView.h"
#import "LBPhotoBrowser.h"

@interface LBPhotoBrowserRemarkView ()

@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation LBPhotoBrowserRemarkView

#define MaxHeightSelf [UIScreen mainScreen].bounds.size.height/4
#define LabelMargin 20

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bounces = NO;
    }
    return self;
}

- (UILabel *)contentLabel{
    if(!_contentLabel){
        _contentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _contentBackView.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_contentBackView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, LabelMargin, self.bounds.size.width -  LabelMargin * 2, self.bounds.size.height - LabelMargin * 2)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:17];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.numberOfLines = 0;
        
        [_contentBackView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (void) updateWithTitle:(NSString *)titleStr content:(NSString *)content{
    if(content.length == 0){
        self.hidden = YES;
        _isEnable = NO;
        return;
    }else{
        self.hidden = NO;
        _isEnable = YES;
    }
    
    [self.contentLabel setText:content];
    CGSize size = [self labelTextTosize:content];
    self.frame = CGRectMake(0, size.height > (MaxHeightSelf - LabelMargin * 2)?SCREEN_HEIGHT - MaxHeightSelf:SCREEN_HEIGHT - LabelMargin * 2 - size.height, SCREEN_WIDTH, size.height > (MaxHeightSelf - LabelMargin * 2)?MaxHeightSelf:size.height + LabelMargin * 2);
    _contentBackView.frame = CGRectMake(0, 0, self.bounds.size.width, size.height + LabelMargin * 2);
    
    self.contentLabel.frame = CGRectMake(LabelMargin, LabelMargin, self.bounds.size.width - LabelMargin * 2, size.height);
    [self setContentSize:CGSizeMake(self.bounds.size.width + 0.5f, size.height > (MaxHeightSelf - LabelMargin * 2)?size.height + LabelMargin * 2 + 0.5:self.bounds.size.height + 0.5)];
}

- (CGSize) labelTextTosize:(NSString *)text{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
    CGSize size= [text boundingRectWithSize:CGSizeMake(self.contentLabel.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
}


@end
