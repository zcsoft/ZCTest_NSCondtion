//
//  ViewController.m
//  CondtionTest
//
//  Created by cuibo on 11/12/14.
//  Copyright (c) 2014 cuibo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(strong, nonatomic)NSCondition *condition;
@property(strong, nonatomic)NSMutableArray *products;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.products = [[NSMutableArray alloc] init];
    self.condition = [[NSCondition alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点一下表示开始接受
- (IBAction)test1Button:(id)sender
{
    [NSThread detachNewThreadSelector:@selector(thread1) toTarget:self withObject:nil];
}

//点一下表示收到一个数据
- (IBAction)test2Button:(id)sender
{
    [NSThread detachNewThreadSelector:@selector(thread2) toTarget:self withObject:nil];
}

//发送线程
- (void)thread1
{
    while (1)
    {
        NSLog(@"thread1：等待发送");
        [self.condition lock];
        [self.condition wait];
        
        NSLog(@"thread1:发送");
        [self.condition unlock];
    }
}

//接收线程
- (void)thread2
{
    [self.condition lock];
    NSLog(@"thread2：收到数据");
    [self.condition signal];
    [self.condition unlock];
}


@end
