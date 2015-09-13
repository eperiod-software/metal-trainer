import bb.cascades 1.0
import bb.multimedia 1.0

Page {
    id: settingsPage
    
    onCreationCompleted: {
        load()
    }
    
    function load() {
        screenAwake.checked = settingsManager.keepScreenOn
        lightTheme.checked = settingsManager.lightTheme
        startSettings.setSound(settingsManager.startSound)
        finishSettings.setSound(settingsManager.finishSound)
        nextIntervalSettings.setSound(settingsManager.intervalSound)
        restSettings.setSound(settingsManager.restSound)
        warningSettings.setSound(settingsManager.warningSound)
        delay.selectedIndex = settingsManager.workoutDelay / 5
        defaultIntervalTime.selectedIndex = getTimeIndexDefaultIntervalTime(settingsManager.defaultIntervalTime)
        defaultIntervalReps.selectedIndex = getRepsIndexDefaultIntervalReps(settingsManager.defaultIntervalReps)
        warningTime.selectedIndex = settingsManager.warningTime / 5 - 1
    }
    
    function save() {
        settingsManager.keepScreenOn = screenAwake.checked
        settingsManager.lightTheme = lightTheme.checked
        settingsManager.startSound = startSettings.soundName
        settingsManager.finishSound = finishSettings.soundName
        settingsManager.intervalSound = nextIntervalSettings.soundName
        settingsManager.restSound = restSettings.soundName
        settingsManager.warningSound = warningSettings.soundName
        settingsManager.workoutDelay = delay.selectedIndex * 5
        settingsManager.defaultIntervalTime = getDropDownDefaultIntervalTime()
        settingsManager.defaultIntervalReps = getDropDownDefaultIntervalReps()
        settingsManager.warningTime = warningTime.selectedIndex * 5 + 5
    }
    
    function getTimeIndexDefaultIntervalTime(time) {
        var index = 0
        
        if (time <= 30)
            index = (time / 5) - 1
        else if (time <= 120)
            index = (time - 30) / 10 + 5
        else if (time <= 300)
            index = (time - 120) / 30 + 14
        else
            index = (time - 300) / 60 + 20
        
        return index
    }
    
    function getRepsIndexDefaultIntervalReps(reps) {
        var index = 0
        
        if (reps <= 10)
            index = reps - 1
        else
            index = (reps - 10) / 5 + 9
        
        return index
    }
    
    function getDropDownDefaultIntervalTime() {
        // Get the index of the drop down control
        var index = defaultIntervalTime.selectedIndex
        var time = 0
        
        // Figure out the time based on that index
        if (index <= 5)
            time = (index + 1) * 5
        else if (index <= 14)
            time = (index - 5) * 10 + 30
        else if (index <= 20)
            time = (index - 14) * 30 + 120
        else
            time = (index - 20) * 60 + 300
        
        return time
    }
    
    function getDropDownDefaultIntervalReps() {
        var index = defaultIntervalReps.selectedIndex
        var reps = 0
        
        if (index <= 9)
            reps = index + 1
        else
            reps = (index - 9) * 5 + 10
        
        return reps
    }
    
    ScrollView {
        id: scrollView
        
        scrollViewProperties {
            scrollMode: ScrollMode.Vertical
        }

        Container {
            layout: StackLayout {
            
            }
            
            topPadding: 20.0
            rightPadding: 20.0
            leftPadding: 20.0
            bottomPadding: 20.0
            
            Header {
                title: "Screen"
                topMargin: 20.0
            }
            CheckBox {
                id: screenAwake
                text: "Keep screen on"
                horizontalAlignment: HorizontalAlignment.Fill
                topMargin: 20.0
            }
            CheckBox {
                id: lightTheme
                text: "Use light theme"
                horizontalAlignment: HorizontalAlignment.Fill
                topMargin: 20.0
            }
            
            Header {
                title: "Starting delay"
                topMargin: 20.0
            }
            DropDown {
                id: delay
                horizontalAlignment: HorizontalAlignment.Fill
                topMargin: 20.0
                title: "Delay"
                selectedIndex: 2
                Option {
                    text: "0:00"
                }
                Option {
                    text: "0:05"
                }
                Option {
                    text: "0:10"
                }
                Option {
                    text: "0:15"
                }
                Option {
                    text: "0:20"
                }
                Option {
                    text: "0:25"
                }
                Option {
                    text: "0:30"
                }
                Option {
                    text: "0:35"
                }
                Option {
                    text: "0:40"
                }
                Option {
                    text: "0:45"
                }
                Option {
                    text: "0:50"
                }
                Option {
                    text: "0:55"
                }
                Option {
                    text: "1:00"
                }
            }
            
            Header {
                title: "Default interval settings"
                topMargin: 20.0
            }
            DropDown {
                id: defaultIntervalTime
                horizontalAlignment: HorizontalAlignment.Fill
                topMargin: 20.0
                title: "Time"
                options: [
                    Option {
                        text: "0:05" // 0
                    },
                    Option {
                        text: "0:10"
                    },
                    Option {
                        text: "0:15"
                    },
                    Option {
                        text: "0:20"
                    },
                    Option {
                        text: "0:25"
                    },
                    Option {
                        text: "0:30" // 5
                    },
                    Option {
                        text: "0:40"
                    },
                    Option {
                        text: "0:50"
                    },
                    Option {
                        text: "1:00"
                    },
                    Option {
                        text: "1:10"
                    },
                    Option {
                        text: "1:20" // 10
                    },
                    Option {
                        text: "1:30"
                    },
                    Option {
                        text: "1:40"
                    },
                    Option {
                        text: "1:50"
                    },
                    Option {
                        text: "2:00" // 14
                    },
                    Option {
                        text: "2:30" // 15
                    },
                    Option {
                        text: "3:00"
                    },
                    Option {
                        text: "3:30"
                    },
                    Option {
                        text: "4:00"
                    },
                    Option {
                        text: "4:30"
                    },
                    Option {
                        text: "5:00" // 20
                    },
                    Option {
                        text: "6:00"
                    },
                    Option {
                        text: "7:00"
                    },
                    Option {
                        text: "8:00"
                    },
                    Option {
                        text: "9:00"
                    },
                    Option {
                        text: "10:00" // 25
                    }
                ]
            }
            DropDown {
                id: defaultIntervalReps
                title: "Reps"
                horizontalAlignment: HorizontalAlignment.Fill
                topMargin: 20.0
                
                options: [
                    Option {
                        text: "1"
                    },
                    Option {
                        text: "2"
                    },
                    Option {
                        text: "3"
                    },
                    Option {
                        text: "4"
                    },
                    Option {
                        text: "5"
                    },
                    Option {
                        text: "6"
                    },
                    Option {
                        text: "7"
                    },
                    Option {
                        text: "8"
                    },
                    Option {
                        text: "9"
                    },
                    Option {
                        text: "10"
                    },
                    Option {
                        text: "15"
                    },
                    Option {
                        text: "20"
                    },
                    Option {
                        text: "25"
                    },
                    Option {
                        text: "30"
                    },
                    Option {
                        text: "35"
                    },
                    Option {
                        text: "40"
                    },
                    Option {
                        text: "45"
                    },
                    Option {
                        text: "50"
                    },
                    Option {
                        text: "55"
                    },
                    Option {
                        text: "60"
                    },
                    Option {
                        text: "65"
                    },
                    Option {
                        text: "70"
                    },
                    Option {
                        text: "75"
                    },
                    Option {
                        text: "80"
                    },
                    Option {
                        text: "85"
                    },
                    Option {
                        text: "90"
                    },
                    Option {
                        text: "95"
                    },
                    Option {
                        text: "100"
                    }
                ]
            }
            
            NotificationControl {
                id: startSettings
                topPadding: 20.0
                soundDescription: "Start workout notification"
                horizontalAlignment: HorizontalAlignment.Fill
                
                onPlaySound: {
                    settingsSoundPlayer.stop()
                    settingsSoundPlayer.setSourceUrl(filename);
                    settingsSoundPlayer.play()
                }
            }
            
            NotificationControl {
                id: finishSettings
                topPadding: 20.0
                soundDescription: "Finished workout notification"
                horizontalAlignment: HorizontalAlignment.Fill
                
                onPlaySound: {
                    settingsSoundPlayer.stop()
                    settingsSoundPlayer.setSourceUrl(filename);
                    settingsSoundPlayer.play()
                }
            }
            
            NotificationControl {
                id: nextIntervalSettings
                topPadding: 20.0
                soundDescription: "Next interval notification"
                horizontalAlignment: HorizontalAlignment.Fill
                
                onPlaySound: {
                    settingsSoundPlayer.stop()
                    settingsSoundPlayer.setSourceUrl(filename);
                    settingsSoundPlayer.play()
                }
            }
            
            NotificationControl {
                id: restSettings
                topPadding: 20.0
                soundDescription: "Rest notification"
                horizontalAlignment: HorizontalAlignment.Fill
                
                onPlaySound: {
                    settingsSoundPlayer.stop()
                    settingsSoundPlayer.setSourceUrl(filename);
                    settingsSoundPlayer.play()
                }
            }
            
            NotificationControl {
                id: warningSettings
                topPadding: 20.0
                soundDescription: "Warning notification"
                horizontalAlignment: HorizontalAlignment.Fill
                
                onPlaySound: {
                    settingsSoundPlayer.stop()
                    settingsSoundPlayer.setSourceUrl(filename);
                    settingsSoundPlayer.play()
                }
            }
            
            DropDown {
                id: warningTime
                horizontalAlignment: HorizontalAlignment.Fill
                topMargin: 20.0
                title: "Time before warning"
                selectedIndex: 1
                Option {
                    text: "0:05"
                }
                Option {
                    text: "0:10"
                }
                Option {
                    text: "0:15"
                }
                Option {
                    text: "0:20"
                }
                Option {
                    text: "0:25"
                }
                Option {
                    text: "0:30"
                }
                Option {
                    text: "0:35"
                }
                Option {
                    text: "0:40"
                }
                Option {
                    text: "0:45"
                }
                Option {
                    text: "0:50"
                }
                Option {
                    text: "0:55"
                }
                Option {
                    text: "1:00"
                }
            }
        }
    }

    paneProperties: NavigationPaneProperties {
	    backButton: ActionItem {
		    onTriggered: {
                save()
                navigationPane.pop()
		    }
		}
	}
    
    attachedObjects: [
        MediaPlayer {
            id: settingsSoundPlayer
        }
    ]
}
