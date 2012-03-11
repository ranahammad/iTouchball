//
//  SettingsView.h
//  theBall
//
//  Created by Faisal Saeed on 5/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsView : UIViewController 
{
	UISlider *m_pGameSpeedSlider;
	UISwitch *m_pGameSoundSwitch;
	UISwitch *m_pGameVibrationSwitch;
}

@property (nonatomic, retain) IBOutlet UISlider *m_pGameSpeedSlider;
@property (nonatomic, retain) IBOutlet UISwitch *m_pGameSoundSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *m_pGameVibrationSwitch;

-(IBAction) mainScreenBtnClicked;
@end
