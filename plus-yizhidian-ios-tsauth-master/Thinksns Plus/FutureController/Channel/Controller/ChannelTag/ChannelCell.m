//
//  ChannelCell.m
//  ChannelTag
//
//  Created by Shin on 2017/11/26.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import "ChannelCell.h"

@interface ChannelCell (){
    
}



@end

@implementation ChannelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //title
        _title = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc]init];
        [self.contentView addSubview:_title];
        _title.frame = CGRectMake(5, 5, frame.size.width-10, frame.size.height-10);
        [_title setBackgroundImage:[UIImage imageNamed:@"com_bg"] forState:UIControlStateNormal];
        [_title setBackgroundImage:[UIImage imageNamed:@"com_bg_sel"] forState:UIControlStateSelected];
        _title.layer.masksToBounds = YES;
        _title.layer.cornerRadius = M_PI;
        _title.titleLabel.font =  [UIFont systemFontOfSize:14];
        [_title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
//        _title.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
        
        _delBtn = [[UIButton alloc]init];
        [self.contentView addSubview:_delBtn];
        _delBtn.frame = CGRectMake(frame.size.width-16, 0, 16, 16);
        [_delBtn setImage:[UIImage imageNamed:@"cell_del"] forState:UIControlStateNormal];
        [_delBtn setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateSelected];
        [_delBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setModel:(Channel *)model{
    
    _model = model;
    model.title = model.title;
    if (model.tagType == MyChannel) {
        
        if (model.editable) {
        }else{
            model.editable = YES;
        }
        if (model.resident) {
            _delBtn.hidden = YES;
        }else{
            _delBtn.hidden = NO;
        }
        
        //选择出来的tag高亮显示
        _title.selected = model.selected;
        
    }else if (model.tagType == RecommandChannel){
        
        if (model.editable) {
            model.editable = NO;
        }else{
        }

        if (model.resident) {
            _delBtn.hidden = YES;
        }else{
            _delBtn.hidden = NO;
        }
    }
    [_title setTitle:model.title forState:UIControlStateNormal];
    
}



- (void)delete:(UIButton *)sender{
    
    [_delegate deleteCell:sender];
}



@end
