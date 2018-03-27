//
//  YMBrushBoard.m
//  YMBrushBoard
//
//  Created by Wisdom on 16/2/26.
//  Copyright © 2016年 Wisdom. All rights reserved.
//



#import "YMBrushBoard.h"


static CGFloat const _MAX_WIDTH = 13.0;//最大最小宽度
static CGFloat const _MIN_WIDTH = 5.0;


@interface YMBrushBoard ()
{
    BOOL _DEBUG;//调试
}

@property (nonatomic,strong)NSMutableArray *points;//存放点集合的数组
@property (nonatomic,unsafe_unretained)CGFloat currentWidth;//当前半径
@property (nonatomic,strong)UIImage *defaultImage;
@property (nonatomic,strong)UIImage *lastImage;


@end

@implementation YMBrushBoard


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //控件基本设定
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        //清除按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50);
        btn.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:18];
        btn.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        [btn setTitle:@"Clear" forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        //默认图片设定
        UIImage *image = [UIImage imageNamed:@"apple"];
        self.image = image;
        self.defaultImage = image;
        self.lastImage = image;
        
        
        if (_DEBUG) {
            
            
            
            self.points = [NSMutableArray array];
            [_points addObject:NSStringFromCGPoint(CGPointMake(100, 100))];
            [_points addObject:NSStringFromCGPoint(CGPointMake(200, 100))];
            [_points addObject:NSStringFromCGPoint(CGPointMake(200, 200))];
            
            _currentWidth = 10;
            
            [self changeImage];
        }
        
    }
    return self;
}



- (void)btnClick:(UIButton *)btn
{
    //图片恢复初始化
    self.image = _defaultImage;
    _lastImage = _defaultImage;
    _currentWidth = 13;
}


- (void)changeImage
{
    UIGraphicsBeginImageContext(self.frame.size);
    
    [_lastImage drawInRect:self.bounds];

    //贝塞尔曲线开始和终点
    CGPoint tempPoint1 = CGPointMake((CGPointFromString(self.points[0]).x + CGPointFromString(self.points[1]).x) / 2, (CGPointFromString(self.points[0]).y + CGPointFromString(self.points[1]).y) / 2);
    CGPoint tempPoint2 = CGPointMake((CGPointFromString(self.points[1]).x + CGPointFromString(self.points[2]).x) / 2, (CGPointFromString(self.points[1]).y + CGPointFromString(self.points[2]).y) / 2);

    
    if (_DEBUG) {
        UIBezierPath *pointPath = [UIBezierPath bezierPathWithArcCenter:CGPointFromString(self.points[2]) radius:3 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
        [[UIColor redColor] set];//同时设置边框和填充色
        [pointPath stroke];
        pointPath = [UIBezierPath bezierPathWithArcCenter:CGPointFromString(self.points[1]) radius:3 startAngle:0 endAngle:M_PI*2.0 clockwise:YES];
        [pointPath stroke];
        pointPath = [UIBezierPath bezierPathWithArcCenter:CGPointFromString(self.points[0]) radius:3 startAngle:0 endAngle:M_PI *2.0 clockwise:YES];
        [pointPath stroke];
        pointPath = [UIBezierPath bezierPathWithArcCenter:tempPoint1 radius:3 startAngle:0 endAngle:M_PI*2.0 clockwise:YES];
        [pointPath stroke];
        pointPath = [UIBezierPath bezierPathWithArcCenter:tempPoint2 radius:3 startAngle:0 endAngle:M_PI*2.0 clockwise:YES];
        [pointPath stroke];
        
    }
    
    
    // 贝塞尔曲线估算长度
    
    double x1 = fabs(tempPoint1.x - tempPoint2.x);
    double x2 = fabs(tempPoint1.y - tempPoint2.y);
    int len = (int)(sqrt(pow(x1, 2.0) + pow(x2, 2.0)) * 10);
    
    //如果仅点击一下
    if (len == 0) {
        UIBezierPath *zeroPath = [UIBezierPath bezierPathWithArcCenter:CGPointFromString(self.points[1]) radius:_MAX_WIDTH / 2 - 2 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
        [[UIColor blackColor] setFill];
        [zeroPath fill];
        
        //绘图
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        _lastImage = self.image;
        UIGraphicsEndImageContext();
        return;
    }
    
    
    // 如果距离过短，直接画线
    if (len == 1) {
        UIBezierPath *zeroPath = [UIBezierPath bezierPath];
        [zeroPath moveToPoint:tempPoint1];
        [zeroPath addLineToPoint:tempPoint2];
        
        _currentWidth += 0.05;
        if (_currentWidth > _MAX_WIDTH) { _currentWidth = _MAX_WIDTH; }
        if (_currentWidth < _MIN_WIDTH) { _currentWidth = _MIN_WIDTH; }
        
        //划线
        zeroPath.lineWidth = _currentWidth;
        zeroPath.lineCapStyle = kCGLineCapRound;
        zeroPath.lineJoinStyle = kCGLineJoinRound;
        [[UIColor colorWithWhite:0 alpha:(_currentWidth - _MIN_WIDTH) / _MAX_WIDTH * 0.6 + 0.2] setStroke];
        [zeroPath stroke];
        
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return;
    }

    // 目标半径
    CGFloat aimWidth = 300 / len * (_MAX_WIDTH - _MIN_WIDTH);
    
    // 获取贝塞尔点集
    NSArray *curvePoints = [self curveFactorizationWithFromPoint:tempPoint1 toPoint:tempPoint2 controlPoints:@[self.points[1]] count:len];
    
    
    // 画每条线段
    CGPoint lastPoint = tempPoint1;
    for (int i = 0; i < len + 1; i ++) {
        UIBezierPath *bPath = [UIBezierPath bezierPath];
        [bPath moveToPoint:lastPoint];
        
        //省略多余的点
        double delta = sqrt(pow(CGPointFromString(curvePoints[i]).x - lastPoint.x, 2) + pow(CGPointFromString(curvePoints[i]).y - lastPoint.y, 2));
        if (delta < 1) {continue;}
        
        lastPoint = CGPointMake(CGPointFromString(curvePoints[i]).x, CGPointFromString(curvePoints[i]).y);
        
        [bPath addLineToPoint:CGPointMake(CGPointFromString(curvePoints[i]).x, CGPointFromString(curvePoints[i]).y)];
        
        
        // 计算当前点
        if (_currentWidth > aimWidth) {
            _currentWidth -= 0.05;
        } else {
            _currentWidth += 0.05;
        }
        
        if (_currentWidth > _MAX_WIDTH) { _currentWidth = _MAX_WIDTH; }
        if (_currentWidth < _MIN_WIDTH) { _currentWidth = _MIN_WIDTH; }
        
        //划线
        bPath.lineWidth = _currentWidth;
        bPath.lineCapStyle = kCGLineCapRound;
        bPath.lineJoinStyle = kCGLineJoinRound;
        [[UIColor colorWithWhite:0 alpha:(_currentWidth - _MIN_WIDTH) / _MAX_WIDTH * 0.3 + 0.1] setStroke];
        [bPath stroke];
    }
    
    
    
    // 保存图片
    _lastImage = UIGraphicsGetImageFromCurrentImageContext();
    
    int pointCount = (int)(sqrt(pow(tempPoint2.x - CGPointFromString(self.points[2]).x, 2) + pow(tempPoint2.y - CGPointFromString(self.points[2]).y , 2))) * 2;
    CGFloat delX = (tempPoint2.x - CGPointFromString(self.points[2]).x) / (CGFloat)(pointCount);
    CGFloat delY = (tempPoint2.y - CGPointFromString(self.points[2]).y) / (CGFloat)(pointCount);
    
    CGFloat addRadius = _currentWidth;
    
    
    // 尾部线段
    for (int i = 0; i < pointCount; i ++) {
        UIBezierPath *bPath = [UIBezierPath bezierPath];
        [bPath moveToPoint:lastPoint];
        
        CGPoint newPoint = CGPointMake(lastPoint.x - delX, lastPoint.y - delY);
        lastPoint = newPoint;
        
        [bPath addLineToPoint:newPoint];
        
        //计算当前点
        if (addRadius > aimWidth) {
            addRadius -= 0.02;
        }
        else
        {
            addRadius += 0.02;
        }
        
        if (addRadius > _MAX_WIDTH) { addRadius = _MAX_WIDTH; }
        if (addRadius < _MIN_WIDTH) { addRadius = _MIN_WIDTH; }
        
        //画线
        bPath.lineWidth = addRadius;
        bPath.lineCapStyle = kCGLineCapRound;
        bPath.lineJoinStyle = kCGLineJoinRound;
        [[UIColor colorWithWhite:0 alpha:(_currentWidth - _MIN_WIDTH) / _MAX_WIDTH * 0.05 + 0.05] setStroke];
        [bPath stroke];
    }
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
}


#pragma mark - touch 事件


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint poi = [touch locationInView:self];
    
    
    NSArray *ps = @[NSStringFromCGPoint(poi),NSStringFromCGPoint(poi),NSStringFromCGPoint(poi)];
    self.points = [NSMutableArray arrayWithArray:ps];
    
    _currentWidth = 13;
    [self changeImage];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint poi = [touch locationInView:self];
    
    NSArray *ps = @[_points[1],_points[2],NSStringFromCGPoint(poi)];
    self.points = [NSMutableArray arrayWithArray:ps];
    [self changeImage];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _lastImage = self.image;
}



#pragma mark - 分解曲线

/**
 * @brief 分解贝赛尔曲线
 *
 * @param controlPoints : 控制点集 ， count : 分解数量
 *
 */
- (NSArray *)curveFactorizationWithFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint controlPoints:(NSArray *)controlPoints count:(NSInteger)count
{
    //如果分解数为0，生成默认分解数量
    if (count == 0) {
        double x1 = fabs(fromPoint.x - toPoint.x);
        double x2 = fabs(fromPoint.y - toPoint.y);
        count = (NSInteger)(sqrt(pow(x1, 2) + pow(x2, 2)));
    }
    
    //贝赛尔曲线的计算
    CGFloat s = 0.0;
    NSMutableArray *t = [NSMutableArray array];
    CGFloat pc = 1 / (CGFloat)(count);
    
    NSInteger power = controlPoints.count + 1;
    for (int i = 0; i <= count + 1; i ++) {
        [t addObject:[NSNumber numberWithFloat:s]];
        s = s + pc;
    }
    
    NSMutableArray *newPoints = [NSMutableArray array];
    for (NSInteger i = 0; i <= count + 1; i ++) {
        
        CGFloat resultX = fromPoint.x * [self bezMakerWithN:power  K:0 T:[t[i] floatValue]] + toPoint.x * [self bezMakerWithN:power K:power T:[t[i] floatValue]];
        
        for (NSInteger j = 1; j < power; j ++) {
            resultX += CGPointFromString(controlPoints[j-1]).x * [self bezMakerWithN:power K:j T:[t[i] floatValue]];
        }
        
        
        CGFloat resultY = fromPoint.y *[self bezMakerWithN:power K:0 T:[t[i] floatValue]] + toPoint.y * [self bezMakerWithN:power K:power T:[t[i] floatValue]];
        
        for (NSInteger j = 1; j < power; j ++) {
            resultY += CGPointFromString(controlPoints[j-1]).y * [self bezMakerWithN:power K:j T:[t[i] floatValue]];
        }
        
        [newPoints addObject:NSStringFromCGPoint(CGPointMake(resultX, resultY))];
        
    }
    
    return newPoints;
}


- (CGFloat)compWithN:(NSInteger)N K:(NSInteger)K
{
    NSInteger s1 = 1;
    NSInteger s2 = 1;
    
    if (K == 0) return 1.0;
    
    for (NSInteger i = N; i >= N - K + 1; i --) {
        s1 = s1 * i;
    }
    for (NSInteger i = K; i >= 2; i --) {
        s2 = s2 * i;
    }
    
    return s1 / (CGFloat)s2;
}


- (CGFloat)realPowWithN:(CGFloat)N K:(NSInteger)K
{
    if (K == 0) return 1.0;
    return pow(N, (CGFloat)K);
}


- (CGFloat)bezMakerWithN:(NSInteger)N K:(NSInteger)K T:(CGFloat)T
{
    CGFloat ONE = [self compWithN:N K:K];
    CGFloat TWO = [self realPowWithN:1 - T K:N - K];
    CGFloat THREE = [self realPowWithN:T K:K];
    
    return ONE * TWO * THREE;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
