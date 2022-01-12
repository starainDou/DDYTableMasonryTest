#import "TestCell.h"
#import "Masonry.h"

#define DDYMargin 10

@implementation TestModel

+ (id)testModelWithIndex:(int)index {
    return [[self alloc] initWithModelIndex:index];
}

- (instancetype)initWithModelIndex:(int)index {
    if (self = [super init]) {
        _view0Hidden = (index%2  == 0);
        _view1Hidden = (index%3  == 0);
        _view2Hidden = (index%4  == 0);
        _view3Hidden = (index%5  == 0);
        _view4Hidden = (index%6  == 0);
        _view5Hidden = index==0 ? NO : (index%7  == 0);
    }
    return self;
}

@end


@interface TestCell ()

@property (nonatomic, strong) NSMutableArray *rightViewArray;
@property (nonatomic, strong) UILabel *testLabel;

@end

@implementation TestCell

- (NSMutableArray *)rightViewArray {
    if (!_rightViewArray) {
        _rightViewArray = [NSMutableArray array];
    }
    return _rightViewArray;
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView {
    NSString *cellID = NSStringFromClass([self class]);
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell?cell:[[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView {
    [self.contentView addSubview:self.testLabel];
    for (int i = 0 ; i < 6; i++) {
        [self.rightViewArray addObject:({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 30, 30);
            button.titleLabel.font =  [UIFont systemFontOfSize:20];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:40*i/255. green:(255-50*i)/255. blue:(255-20*i)/255. alpha:1.]];
            [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [button setTag:i + 100];
            [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            button;
        })];
    }
}

- (UILabel *)testLabel {
    if (!_testLabel) {
        _testLabel = [[UILabel alloc] init];
        NSUInteger random = arc4random_uniform(3);
        NSArray *tempArray = @[@"建立约束", @"建立约束，自动撑开，自动高度", @"建立约束，自动撑开，自动高度, 无拘无束,点击按钮,打印标识"];
        [_testLabel setText:tempArray[random]];
        [_testLabel setFont:[UIFont systemFontOfSize:15]];
        [_testLabel setTextColor:[UIColor blueColor]];
        [_testLabel setNumberOfLines:0];
        [_testLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _testLabel;
}

- (void)setModel:(TestModel *)model {
    _model = model;
    [self.rightViewArray[0] setHidden:model.view0Hidden];
    [self.rightViewArray[1] setHidden:model.view1Hidden];
    [self.rightViewArray[2] setHidden:model.view2Hidden];
    [self.rightViewArray[3] setHidden:model.view3Hidden];
    [self.rightViewArray[4] setHidden:model.view4Hidden];
    [self.rightViewArray[5] setHidden:model.view5Hidden];
    [self setViewsConstraints];
}

- (void)setViewsConstraints {
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(DDYMargin);
        make.top.mas_equalTo(self.contentView).offset(DDYMargin);
        make.width.mas_equalTo(80);
        make.height.mas_greaterThanOrEqualTo(DDYMargin * 2 + 30);
        make.bottom.mas_equalTo(self.contentView).offset(-DDYMargin).priorityHigh();
    }];
    [self ddy_remakeConstraints:self.rightViewArray];
}

- (void)ddy_remakeConstraints:(NSArray *)views {
    UIView *lastView = nil;
    NSArray *reverseArray = [[views reverseObjectEnumerator] allObjects];
    for (UIView *tempView in reverseArray) {
        if (lastView) {
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.width.height.mas_equalTo(30);
                make.right.mas_equalTo(lastView.mas_left).offset(-DDYMargin);
            }];
        } else if (!tempView.hidden) {
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.width.height.mas_equalTo(30);
                make.right.mas_equalTo(self.contentView).offset(-DDYMargin);
            }];
        }
        if (!tempView.hidden) {
            lastView = tempView;
        }
    }
}

- (void)handleClick:(UIButton *)sender {
    NSLog(@"click : %ld", (long)sender.tag);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    [self dealDeleteButton];
}

- (void)dealDeleteButton {
    UIView *superView = self.superview;
    if ([superView isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")]) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, superView.bounds.size.width - 4, superView.bounds.size.height - 4) byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight  cornerRadii:CGSizeMake(6, 6)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, superView.bounds.size.width - 4, superView.bounds.size.height - 4);//superView.bounds;
        maskLayer.path = maskPath.CGPath;
        superView.layer.mask = maskLayer;
    }
}

@end
