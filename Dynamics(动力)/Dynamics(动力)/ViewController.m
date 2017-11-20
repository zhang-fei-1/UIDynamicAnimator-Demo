//
//  ViewController.m
//  Dynamics(动力)
//
//  Created by MokZF on 2017/11/20.
//  Copyright © 2017年 MokZF. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollisionBehaviorDelegate>

@property(nonatomic, strong) UIView *targetView;
@property(nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation ViewController

/**
 * © ZF
 UIDynamicAnimator，封装了底层 iOS 物理引擎，为动力项（UIDynamicItem）
                    提供物理相关的功能和动画。
 UIDynamicBehavior，动力行为，为动力项提供不同的物理行为;
                    赋予动态行为给一个或多个动态项;在开发中，大部分情况下
                    使用 UIDynamicBehavior 的子类就足够了，因为UIKit
                    中已经有几个现成的模拟现实的 UIDynamicBehavior类。
 
    UIDynamicBehavior子类包括:
 
        1. UIGravityBehavior
            重力行为，可以指定重力的方向和大小。用gravityDirection指定一个向量，或者设置 angle 和 magnitude。
 
        2. UICollisionBehavior
            碰撞行为，指定一个边界，物体在到达这个边界的时候会发生碰撞行为。通过实现 UICollisionBehaviorDelegate 可以跟踪物体什么时候开始碰撞和结束碰撞。
 
        3. UIAttachmentBehavior
            附着行为，让物体附着在某个点或另外一个物体上。可以设置附着点的到物体的距离，阻尼系数和振动频率等。
 
        4. UIDynamicItemBehavior
            物体属性，如密度、弹性系数、摩擦系数、阻力、转动阻力等。
 
        5. UIPushBehavior
            对物体施加力，可以是持续性的力也可以是一次性的力。用一个向量(CGVector)来表示力的方向和大小。
 
        6. UISnapBehavior
            将一个物体钉在某一点。它只有一个初始化方法和一个属性。
 
 UIDynamicItem，动力项，相当于现实世界中的一个基本物体
 
 这三个类的结构是：UIDynamicAnimator 需要一个 refrence view 作为物理引擎的坐标系统，再根据不同需求添加各种动力行为（UIDynamicBehavior），而每个动力行为都可以指定一个或多个动力项（UIDynamicItem），常用的动力项就是一个普通的 View。
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.targetView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UITapGestureRecognizer *viewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushBehavior:)];
    [self.view addGestureRecognizer:viewTapGesture];
}

//重力行为
- (void)gravityBehavior {
    
    /**
     * © ZF
     * @ UIGravityBehavior 继承于UIDynamicBehavior：重力行为；可以指定重力的方向和大小
     */
    
    // 创建一个重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.targetView]];
    // 在垂直向下方向 500 点/平方秒 的速度
    gravity.gravityDirection = CGVectorMake(0, 1);
    [self.animator addBehavior:gravity];
}

- (void)pushBehavior:(UITapGestureRecognizer *)gestureRecognizer {
    
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.targetView] mode:UIPushBehaviorModeInstantaneous];
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint itemCenter = self.targetView.center;
    push.pushDirection = CGVectorMake((location.x - itemCenter.x) / 100, (location.y - itemCenter.y) / 100);
    [self.animator addBehavior:push];
    
    /** 属性说明
     * © ZF
     // 推力模式，UIPushBehaviorModeContinuous：持续型。UIPushBehaviorModeInstantaneous：一次性推力。
     @property (nonatomic, readonly) UIPushBehaviorMode mode;
     
     // 推力是否被激活，在激活状态下，物体才会受到推力效果
     @property(nonatomic, readwrite) BOOL active
     
     // 推力的大小和方向
     @property (readwrite, nonatomic) CGVector pushDirection;
     */
}

//碰撞行为
- (void)collision {
    
    // 创建碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.targetView]];
    
    // 指定 Reference view 的边界为可碰撞边界
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // UICollisionBehaviorModeItems:item 只会和别的 item 发生碰撞；UICollisionBehaviorModeBoundaries：item 只和碰撞边界进行碰撞；UICollisionBehaviorModeEverything:item 和 item 之间会发生碰撞，也会和指定的边界发生碰撞。
    collision.collisionMode = UICollisionBehaviorModeEverything;
    
    collision.collisionDelegate = self;
    
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    [self.animator addBehavior:collision];
}

//附着行为
- (void)attachment {
    
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:self.targetView attachedToAnchor:self.targetView.center];
    
    attachment.length = 150;
    
    attachment.damping = 0.5;
    
    attachment.frequency = 1;
    
    [self.animator addBehavior:attachment];
    
    /**
     * © ZF UIAttachmentBehavior属性说明
     // UIAttachmentBehaviorTypeAnchor类型的依赖行为的锚点，锚点与行为相关的动力动画的坐标系统有关。
     @property(readwrite, nonatomic) CGPoint anchorPoint
     
     // 吸附行为的类型
     @property(readonly, nonatomic) UIAttachmentBehaviorType attachedBehaviorType
     
     // 描述吸附行为减弱的阻力大小
     @property(readwrite, nonatomic) CGFloat damping
     
     // 吸附行为震荡的频率
     @property(readwrite, nonatomic) CGFloat frequency
     
     // 与吸附行为相连的动态项目，当吸附行为类型是UIAttachmentBehaviorTypeItems时有2个元素，当吸附行为类型是UIAttachmentBehaviorTypeAnchor时只有一个元素。
     @property(nonatomic, readonly, copy) NSArray *items
     
     // 吸附行为中的两个吸附点之间的距离，通常用这个属性来调整吸附的长度，可以创建吸附行为之后调用。系统基于你创建吸附行为的方法来自动初始化这个长度
     @property(readwrite, nonatomic) CGFloat length
     */
}

//物体属性，如密度、弹性系数、摩擦系数、阻力、转动阻力等。
- (void)itemBehavior {
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.targetView]];
    itemBehavior.elasticity = 0.8; // 改变弹性
    itemBehavior.allowsRotation = YES; // 允许旋转
    [itemBehavior addAngularVelocity:1 forItem:self.targetView]; // 让物体旋转
    
    [self.animator addBehavior:itemBehavior];
    
    /** 属性说明
     * © ZF
     // 弹力，通常设置 0~1 之间
     @property (readwrite, nonatomic) CGFloat elasticity;
     
     // 摩擦力，0表示完全光滑无摩擦
     @property (readwrite, nonatomic) CGFloat friction;
     
     // 密度，一个 100x100 points（1 point 在 retina 屏幕上等于2像素，在普通屏幕上为1像素。）大小的物体，密度1.0，在上面施加 1.0 的力，会产生 100 point/平方秒 的加速度。
     @property (readwrite, nonatomic) CGFloat density;
     
     // 线性阻力，物体在移动过程中受到的阻力大小
     @property (readwrite, nonatomic) CGFloat resistance;
     
     // 旋转阻力，物体旋转过程中的阻力大小
     @property (readwrite, nonatomic) CGFloat angularResistance;
     
     // 是否允许旋转
     @property (readwrite, nonatomic) BOOL allowsRotation;
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSValue *vale = [NSValue valueWithCGPoint:self.targetView.center];
    if (![vale isEqualToValue:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, 150)]]) {
//        _targetView.center = CGPointMake(self.view.frame.size.width/2, 150);
//        [self.animator removeAllBehaviors];
    }else {

        //重力行为
//        [self gravityBehavior];
        //碰撞行为
        [self collision];
        //附着行为
        //    [self attachment];
        //物体属性
        [self itemBehavior];
    }
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p
{
    // 结束碰撞为 squareView 设置一个随机背景
    self.targetView.backgroundColor = [UIColor redColor];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier
{
    // 结束碰撞为 squareView 设置一个随机背景
    self.targetView.backgroundColor = [UIColor redColor];
}

- (UIView *)targetView {
    if (!_targetView) {
        _targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        _targetView.center = CGPointMake(self.view.frame.size.width/2, 150);
        _targetView.backgroundColor = [UIColor orangeColor];
    }
    return _targetView;
}


@end
