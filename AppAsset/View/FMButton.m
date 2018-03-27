//
//  FMButton.m
//  AppAsset
//
//  Created by Wp on 2018/3/26.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "FMButton.h"

@interface FMButton()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *textLabel;

@end
@implementation FMButton
@synthesize font = _font;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    
//    NSLog(@"天赐良机");
//}

- (void)dealloc
{
    NSLog(@"销毁");
    [self removeObserver:self forKeyPath:@"contentAligment"];
    [self removeObserver:self forKeyPath:@"isTrailingImage"];
    [self removeObserver:self forKeyPath:@"text"];
    [self removeObserver:self forKeyPath:@"font"];
    
}

//- (void)layoutSubviews
//{
//    NSLog(@"条用");
//    [self refreshLayout];
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"初始化eee");
        self.contentAligment = FMContentAligmentLeft;
        [self setupUI];
        
        [self addObserver:self forKeyPath:@"contentAligment" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"isTrailingImage" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"初始化");
        self.contentAligment = FMContentAligmentLeft;
        [self setupUI];
        
        [self addObserver:self forKeyPath:@"contentAligment" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"isTrailingImage" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.textLabel];
    
    [self addTarget:self action:@selector(changeBackgroundColor:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(restoreBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)refreshLayout
{
    if (self.text && self.font) {
        CGSize size = [self.textLabel sizeThatFits:CGSizeZero];
        
        if (self.isTrailingImage) {
            [self.textLabel setFrame:CGRectMake(0, 0, size.width, CGRectGetHeight(self.frame))];
            [self.imgView setFrame:CGRectMake(CGRectGetMaxX(self.textLabel.frame) + 5, (CGRectGetHeight(self.frame) - size.height) / 2, size.height, size.height)];
            
        }
        else
        {
            [self.imgView setFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - size.height) / 2, size.height, size.height)];
            [self.textLabel setFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + 5, 0, size.width, CGRectGetHeight(self.frame))];
            
        }
        
        [self.contentView setBounds:CGRectMake(0, 0, size.height + 5 + size.width, CGRectGetHeight(self.frame))];
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"仅仅 %@",keyPath);
    if ([keyPath isEqualToString:@"contentAligment"]) {
        
        id obj = change[NSKeyValueChangeNewKey];
        switch ([obj integerValue]) {
            case FMContentAligmentLeft:
            {
                [_contentView setCenter:CGPointMake(CGRectGetWidth(_contentView.frame) / 2, CGRectGetHeight(self.frame) / 2)];
            }
                break;
            case FMContentAligmentCenter:
            {
                [_contentView setCenter:CGPointMake(self.center.x, CGRectGetHeight(self.frame) / 2)];
            }
                break;
            case FMContentAligmentRight:
            {
                [_contentView setCenter:CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(_contentView.frame) / 2, CGRectGetHeight(self.frame) / 2)];
            }
                break;
                
            default:
                break;
        }
    }
    else//font text isTrailingImage 发生改变
    {
        [self refreshLayout];
    }
}

- (void)changeBackgroundColor:(FMButton *)btn
{
    btn.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)restoreBackgroundColor:(FMButton *)btn
{
    btn.backgroundColor = [UIColor clearColor];
}

#pragma mark - getter

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = NO;
        [_contentView setCenter:CGPointMake(CGRectGetWidth(_contentView.frame) / 2, CGRectGetHeight(self.frame) / 2)];
    }
    return _contentView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _imgView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        
    }
    return _textLabel;
}

- (CGFloat)font
{
    return self.textLabel.font.pointSize;
}

#pragma mark - setter

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imgView.image = image;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
    
}

- (void)setFont:(CGFloat)font
{
    _font = font;
    self.textLabel.font = [UIFont systemFontOfSize:font];
    
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textLabel.textColor = textColor;
}




@end
