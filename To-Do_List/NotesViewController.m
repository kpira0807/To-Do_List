#import "NotesViewController.h"

@interface NotesViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isDetail) {
        self.textField.text = self.eventInfo;
        self.textField.userInteractionEnabled = NO;
        self.datePicker.userInteractionEnabled = NO;
        self.saveButton.alpha = 0;

        [self performSelector:@selector(setdatePickerValueWithAnimation) withObject:nil afterDelay:0.5];
    } else {
    // чтобы кнопка была не активной когда мы ничего не заполнили
     self.saveButton.userInteractionEnabled = NO;
    self.datePicker.minimumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    // подключение кнопки сохранения к методу сохранения
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    // для скрытия клавиатуры при нажатии на любую точку экрана
    UITapGestureRecognizer * handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndEditing)];
    [self.view addGestureRecognizer:handleTap];
    }
}

// для анимации даты в нотатках
- (void) setdatePickerValueWithAnimation {
    [self.datePicker setDate:self.eventDate animated:YES];
}

// метод который вызывается при прокручивании Date picker
- (void) datePickerValueChanged {
    self.eventDate = self.datePicker.date;
}

// для скрытия клавиатуры при нажатии на любут точку экрана
- (void) handleEndEditing {
    
    if ([self.textField.text length] != 0) {
        // свернуть клавиатуры от нажатия на кнопку done человеком на клавиатуре
        [self.view endEditing:YES];
        self.saveButton.userInteractionEnabled = YES;
    } else {
        [self showAlertWithMessage:@"Event field is empty"];
    }
}

- (void) save {
  
    if (self.eventDate) {
        if ([self.eventDate compare:[NSDate date]] == NSOrderedSame){
            [self showAlertWithMessage:@"Change date to a later date"];
        }
        else if ([self.eventDate compare:[NSDate date]] == NSOrderedAscending){
            [self showAlertWithMessage:@"Change date to a later date"];
        } else {
        [self setNotification];
        }
    } else {
         [self showAlertWithMessage:@"Change date to a later date"];
    }
}

- (void) setNotification {
    NSString * eventInfo = self.textField.text;
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"HH:mm dd.MM.yyyy";
    NSString *eventDate = [formater stringFromDate:self.eventDate];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                           eventInfo, @"eventInfo",
                           eventDate, @"eventDate", nil];
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.userInfo = dict;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = self.eventDate;
    notification.alertBody = eventInfo;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewEvent" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
    if ([textField isEqual:self.textField]) {
        if ([self.textField.text length] != 0) {
        // свернуть клавиатуры от нажатия на кнопку done человеком на клавиатуре
           [self.textField resignFirstResponder];
            self.saveButton.userInteractionEnabled = YES;
            return YES;
        } else {
            [self showAlertWithMessage:@"Event field is empty"];
        }
    }
    return NO;
}

- (void) showAlertWithMessage: (NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message: message
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Okey"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button Okey");
                                                          }];
    
    
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
