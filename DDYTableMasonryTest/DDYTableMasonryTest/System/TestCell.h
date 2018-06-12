#import <UIKit/UIKit.h>

@interface TestModel : NSObject

@property (nonatomic, assign) BOOL view0Hidden;
@property (nonatomic, assign) BOOL view1Hidden;
@property (nonatomic, assign) BOOL view2Hidden;
@property (nonatomic, assign) BOOL view3Hidden;
@property (nonatomic, assign) BOOL view4Hidden;
@property (nonatomic, assign) BOOL view5Hidden;

+ (id)testModelWithIndex:(int)index;

@end



@interface TestCell : UITableViewCell

@property (nonatomic, strong) TestModel *model;

+ (instancetype)cellWithTabelView:(UITableView *)tableView;

@end
