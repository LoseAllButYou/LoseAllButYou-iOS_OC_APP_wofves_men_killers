//
//  VCCharactor.m
//  wolfmen_killers
//
//  Created by 裴培华 on 17/4/18.
//  Copyright © 2017年 裴培华. All rights reserved.
//

#import "VCCharactor.h"
#import "NSObject+DBPart.h"
#import "Vcell.h"
@interface VCCharactor ()
@property (weak, nonatomic) IBOutlet UICollectionView *Coll_charactorList;
@property (strong,nonatomic)FMResultSet* charactor;
@end

@implementation VCCharactor

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // Do any additional setup after loading the view.
     DBPart* dbPart=[DBPart alloc];
     NSLog(@"op Source==%d",[dbPart openOrCreatDB:@"werwolf_killer_DB/werwolf_killer_DB.db"]);
     NSLog(@"openDB res ==%d",[dbPart openDB]);
     //_charactor=[dbPart selectAllFromDB:@"select * from history_info"];
     
     _charactor=[FMResultSet alloc];
     _charactor= [dbPart selectAllFromDB:@"select * from game_identity"];
  
     NSLog(@"char NUM ==%d %d",_charactor.columnCount,[_charactor intForColumn:@"id"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---UICollectionView DataSource
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
     return 1;
}



//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return _charactor.columnCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *identify = @"c1";
     if(indexPath.row!=0)
          [ _charactor next];
     UIImage* img=[UIImage imageNamed:[_charactor stringForColumn:@"image_name"]];
     Vcell* cell=(Vcell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
     cell.Cell_img.image= img;
     cell.Cell_label.text=[_charactor stringForColumn:@"identity"];
     return cell;
}



@end
