//
//  FSVenueViewController.m
//  CityGuide
//
//  Created by lushangshu on 15-8-7.
//  Copyright (c) 2015年 lushangshu. All rights reserved.
//

#import "FSVenueViewController.h"
#import "AFNetworking.h"
#import "FSConverter.h"
#import <MapKit/MapKit.h>
#import "FSPhoto.h"
#import "IKCell.h"
#import "InstagramKit.h"

@interface FSVenueViewController ()
{
    NSMutableArray *mediaArray;
}

@end

@implementation FSVenueViewController
@synthesize nameLabel;
@synthesize venueName;
@synthesize venue;
@synthesize venueId;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Location Detail"];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:venue.location.coordinate];
    [annotation setTitle:venue.name];
    [self.VenueMap addAnnotation:annotation];
    [self.VenueMap setRegion:MKCoordinateRegionMake(venue.location.coordinate, MKCoordinateSpanMake(0.001f, 0.001f)) animated:YES];
    self.nameLabel.text = venueName;
    //NSLog(@"location %@",venue.venueId);
    [self FetchVenuePhotsUsingVenueID];
    NSLog(@"venue id is %@",venue.venueId);
    self.phoneNumber = @"null";
    [self FetchVenueInfoUsingVenueID:venue.venueId];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FetchVenueInfoUsingVenueID: (NSString *)venueID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"M0AY5MCIO3I5HKZAU35MC1E4WQIBIVUFVPSL2MY0TSRP5JTI" forKey:@"client_id"];
    [params setObject:@"O3DM3WRVRABPMTMWMMGXC4WDEHUUIGGIRHP1Y0PTUEW2WTK3" forKey:@"client_secret"];
    [params setObject:@"20150812" forKey:@"v"];
    
    NSString *url1 = @"https://api.foursquare.com/v2/venues/";
    NSString *url2 = venueID;
    NSString *url = [url1 stringByAppendingString:url2];
    //NSLog(@"url is %@",url);
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *dic = responseObject;
        NSArray *detail = [dic valueForKeyPath:@"response"];
        FSConverter *converter = [[FSConverter alloc]init];
        FSVenueDetail *vd = [converter convertVDetailToObjects:detail];
        [self.VenuePhone setText:vd.phone];
        if ([vd.formattedAddress count]==3) {
            [self.VenueAddress setText:[vd.formattedAddress objectAtIndex:0]];
            [self.VenuePostCode setText:[vd.formattedAddress objectAtIndex:2]];
            [self.VenueRating setText:[vd.formattedAddress objectAtIndex:1]];
        }
        else if([vd.formattedAddress count]==2)
        {
            [self.VenueAddress setText:[vd.formattedAddress objectAtIndex:0]];
            [self.VenuePostCode setText:[vd.formattedAddress objectAtIndex:1]];
            [self.VenueRating setText:@" "];
        }
        else if([vd.formattedAddress count]==1){
            [self.VenueAddress setText:[vd.formattedAddress objectAtIndex:0]];
            [self.VenuePostCode setText:@" "];
            [self.VenueRating setText:@" "];
        }
        else {
            [self.VenueAddress setText:@" "];
            [self.VenuePostCode setText:@" "];
            [self.VenueRating setText:@" "];
        }
        self.phoneNumber = vd.phone;
        //NSLog(@"venud detail is %@,%@,%@,%@",vd.rating,vd.formattedAddress,vd.phone,vd.canonicalUrl);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    
}

-(IBAction)LikeVenue{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"favorateVenues.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"favorateVenues" ofType:@"plist"];
    }
    NSMutableArray *venu = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSArray *v = [NSArray arrayWithObjects:self.venue,self.venueName, nil];
    [venu addObject:v];
    NSArray *vv = [venu copy];
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:vv  format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListMutableContainersAndLeaves error:&error];
    
    if(plistData)
    {
        [plistData writeToFile:plistPath atomically:YES];
        NSLog(@"saved venue data to favorateVenue.plist");
    }
    else
    {
        NSLog(@"save failed");
    }
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
-(IBAction)dialVenue:(id)sender{
    NSString *tel = @"tel:";
    NSString *phone = [tel stringByAppendingString:self.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}
-(void)FetchVenuePhotsUsingVenueID
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"M0AY5MCIO3I5HKZAU35MC1E4WQIBIVUFVPSL2MY0TSRP5JTI" forKey:@"client_id"];
    [params setObject:@"O3DM3WRVRABPMTMWMMGXC4WDEHUUIGGIRHP1Y0PTUEW2WTK3" forKey:@"client_secret"];
    [params setObject:@"30" forKey:@"limit"];
    [params setObject:@"20140118" forKey:@"v"];
    
    NSString *url1 = @"http://api.foursquare.com/v2/venues/";
    NSString *url2 = venue.venueId;
    NSString *url3 = @"/photos";
    NSString *url = [[url1 stringByAppendingString:url2]stringByAppendingString:url3];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary *dic = responseObject;
        NSArray *photos = [dic valueForKeyPath:@"response.photos.items"];
        FSConverter *converter = [[FSConverter alloc]init];
        self.photos = [converter convertVPhotoToObjects :photos];
        [mediaArray addObjectsFromArray:self.photos];
        if ([self.photos count]>=3) {
            NSString *str1_1 = [[self.photos objectAtIndex:0] prefix];
            NSString *str1_2 = [[self.photos objectAtIndex:0] suffix];
            NSString *str2_1 = [[self.photos objectAtIndex:1] prefix];
            NSString *str2_2 = [[self.photos objectAtIndex:1] suffix];
            NSString *str3_1 = [[self.photos objectAtIndex:2] prefix];
            NSString *str3_2 = [[self.photos objectAtIndex:2] suffix];
            
            NSString *str3 = @"80x80";
            NSString *url1 = [[str1_1 stringByAppendingString:str3]stringByAppendingString:str1_2];
            NSString *url2 = [[str2_1 stringByAppendingString:str3]stringByAppendingString:str2_2];
            NSString *url3 = [[str3_1 stringByAppendingString:str3]stringByAppendingString:str3_2];
            //NSLog(@"photo image is %@,%@,%@",url1,url2,url3);
            [self downloadImageWithURL:[NSURL URLWithString:url1] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    // change the image in the cell
                    self.imagePhoto.image = image ;
                }
            }];
            [self downloadImageWithURL:[NSURL URLWithString:url2] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    // change the image in the cell
                    self.imagePhoto2.image = image ;
                }
            }];
            [self downloadImageWithURL:[NSURL URLWithString:url3] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    // change the image in the cell
                    self.imagePhoto3.image = image ;
                }
            }];
        }
        else if([self.photos count]==2){
            NSString *str1_1 = [[self.photos objectAtIndex:0] prefix];
            NSString *str1_2 = [[self.photos objectAtIndex:0] suffix];
            NSString *str2_1 = [[self.photos objectAtIndex:1] prefix];
            NSString *str2_2 = [[self.photos objectAtIndex:1] suffix];
            NSString *str3 = @"80x80";
            NSString *url1 = [[str1_1 stringByAppendingString:str3]stringByAppendingString:str1_2];
            NSString *url2 = [[str2_1 stringByAppendingString:str3]stringByAppendingString:str2_2];
            [self downloadImageWithURL:[NSURL URLWithString:url1] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    // change the image in the cell
                    self.imagePhoto.image = image ;
                }
            }];
            [self downloadImageWithURL:[NSURL URLWithString:url2] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    // change the image in the cell
                    self.imagePhoto2.image = image ;
                }
            }];
        }
        else if([self.photos count]==1){
            NSString *str1_1 = [[self.photos objectAtIndex:0] prefix];
            NSString *str1_2 = [[self.photos objectAtIndex:0] suffix];
            NSString *str3 = @"80x80";
            NSString *url1 = [[str1_1 stringByAppendingString:str3]stringByAppendingString:str1_2];
            [self downloadImageWithURL:[NSURL URLWithString:url1] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    // change the image in the cell
                    self.imagePhoto.image = image ;
                }
            }];
        }
        else {
            NSLog(@"image not found");
        }
        [self.imagePhoto reloadInputViews];
        [self.imagePhoto2 reloadInputViews];
        [self.imagePhoto3 reloadInputViews];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
#pragma mark -- venue map delegate

#pragma mark - UICollection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mediaArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"vpCell" forIndexPath:indexPath];
    if (mediaArray.count >= indexPath.row+1) {
//        FSPhoto *media = mediaArray[indexPath.row];
//        NSString *str = [media prefix];
//        NSString *str1 = [media suffix];
//        NSString *str3 = @"80x80";
//        NSString *url = [[str stringByAppendingString:str3]stringByAppendingString:str1];
//        NSLog(@"photo image is %@",url);
//        [self downloadImageWithURL:[NSURL URLWithString:url] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                [cell.imageView setImage:0];
//            }
//        }];
        
    }
    else
        cell.imageView.image = [UIImage imageNamed:@"0.png"];
    return cell;

    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [self VenueGallery].bounds.size.width / 3 - 1;
    return CGSizeMake(width, width);
}

@end
