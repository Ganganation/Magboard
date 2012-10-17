//
//  DashboardVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 03-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "DashboardVC.h"
#import "Webshop.h"
#import "ShopSingleton.h"
#import "CustomNavBar.h"
#import "UIBarButtonItem.h"

//Imports for networking
#import "LRResty.h"

@interface DashboardVC ()

@end

@implementation DashboardVC

@synthesize orderHolder, shopInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"linnen_bg@2x.png"]]];
        shopInfo = [ShopSingleton shopSingleton];
        [self drawNavigationBar];
        [self fetchAllOrders:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password]];
    }
    return self;
}

//Navigationbar opmaken
-(void)drawNavigationBar
{
    //Gradient voor de navigationbar maken
    [self.navigationController setValue:[[CustomNavBar alloc]init] forKeyPath:@"navigationBar"];
    NSString* title = [[NSString alloc] initWithFormat:@"%@", [shopInfo shopName]];
    self.navigationItem.title = title;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarButtonItemWithTarget:self selector:@selector(backButtonTouched)];

}

-(void)backButtonTouched
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

-(void)fetchAllOrders:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:shopUrl forKey:@"url"];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    
    [[LRResty client] post:@"http://www.magboard.nl/soap.php" payload:params delegate:self];
}

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
{
    // do something with the response
    if(response.status == 200) {;
        
        orderHolder = [NSJSONSerialization JSONObjectWithData:[response responseData] options:kNilOptions error:nil];
        NSLog(@"Status: %@", [orderHolder valueForKey:@"session"]);
     }
     else
     {
        NSLog(@"Er ging iets mis %d", [response status]);
     }
    
    [self makeTable];
}

//Hier wordt de table geinitialiseerd
-(void)makeTable
{
    
    if(orderHolder == NULL)
    {
        // Add label for text when no shops are available
        UILabel *noShopsText = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 130.0f, 280.0f, 70.0f)];
        [noShopsText setText:@"Er zijn nog geen orders geplaatst op uw webshop."];
        [noShopsText setFont:[UIFont fontWithName:@"Lobster" size:12]];
        [noShopsText setTextColor:[UIColor whiteColor]];
        [noShopsText setBackgroundColor:[UIColor clearColor]];
        [noShopsText setTextAlignment:UITextAlignmentCenter];
        [noShopsText setNumberOfLines:0];
        [self.view addSubview:noShopsText];
    }
    else
    {
        //Tableview toevoegen aan de view
        UITableView *shopsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        shopsTable.dataSource = self;
        shopsTable.delegate = self;
        shopsTable.backgroundColor = [UIColor clearColor];
        shopsTable.separatorColor = [UIColor clearColor];
        [self.view addSubview:shopsTable];
    }
    NSLog(@"Number of orders: %d", [[orderHolder valueForKey:@"data-items"] count]);
    
}

//Aangeven hoeveel hoeveel items er moeten worden getoond in de table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[orderHolder valueForKey:@"data-items"] count];
}

// Hoogte van de cellen setten
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

//Hier wordt de inhoud van de cel bepaald
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *webshopCell = @"OrderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:webshopCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:webshopCell];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString* firstName = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"firstname"]];
    NSString* lastName = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"lastname"]];
    NSString* totalValue = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"base_grand_total"]];
    NSString* orderId = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"increment_id"]];
    
    NSString* totalName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
    NSString* grandTotal = [[NSString alloc] initWithFormat:@"$ %@", totalValue];
    
    //Add orderlabel image to table cell
    UILabel *orderHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 301.0f, 53.0f)];
    UIImage *image = [UIImage imageNamed:@"order_holder_pending"];
    orderHolderLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    [cell addSubview:orderHolderLabel];
    
    //Add consumer name to order label
    UILabel *orderName = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 200, 20)];
    orderName.font = [UIFont boldSystemFontOfSize:12.0f];
    orderName.backgroundColor = [UIColor clearColor];
    orderName.text = totalName;
    [orderHolderLabel addSubview:orderName];
    
    //Add grandtotal to order label
    UILabel *grandTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 7, 80, 20)];
    grandTotalLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    grandTotalLabel.backgroundColor = [UIColor clearColor];
    grandTotalLabel.text = grandTotal;
    grandTotalLabel.textAlignment = UITextAlignmentRight;
    [orderHolderLabel addSubview:grandTotalLabel];
    
    //Add ordernumber to order label
    UILabel *orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 23, 100, 20)];
    orderNumberLabel.font = [UIFont systemFontOfSize:11.0f];
    orderNumberLabel.backgroundColor = [UIColor clearColor];
    orderNumberLabel.text = orderId;
    [orderHolderLabel addSubview:orderNumberLabel];
    
    NSLog(@"All fields: %@", [orderHolder valueForKey:@"data-items"]);
    
}

//Hier wordt bepaald welke actie er wordt gedaan als de gebruiker op de shop drukt
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
