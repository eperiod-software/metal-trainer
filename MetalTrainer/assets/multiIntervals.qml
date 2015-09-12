import bb.cascades 1.0

Page {
    id: multiIntervalPage
    
    titleBar: TitleBar {
        id: intervalsTitleBar
        title: "Intervals"
        dismissAction: ActionItem {
            title: "Cancel"
            onTriggered: {
                navigationPane.pop()
            }
        }
    }
    
    property int currentWorkoutIndex
    
    function loadPage(workoutIndex) {
        currentWorkoutIndex = workoutIndex
        
        var defIntervalReps = settingsManager.defaultIntervalReps
        var defIntervalTime = settingsManager.defaultIntervalTime
        var defIntervalIsTimed = true
        
        intervalControl1.intervalReps = defIntervalReps
        intervalControl2.intervalReps = defIntervalReps
        intervalControl3.intervalReps = defIntervalReps
        intervalControl4.intervalReps = defIntervalReps
        intervalControl5.intervalReps = defIntervalReps
        intervalControl6.intervalReps = defIntervalReps
        intervalControl7.intervalReps = defIntervalReps
        intervalControl8.intervalReps = defIntervalReps
        intervalControl9.intervalReps = defIntervalReps
        intervalControl10.intervalReps = defIntervalReps
        
        intervalControl1.intervalTime = defIntervalTime
        intervalControl2.intervalTime = defIntervalTime
        intervalControl3.intervalTime = defIntervalTime
        intervalControl4.intervalTime = defIntervalTime
        intervalControl5.intervalTime = defIntervalTime
        intervalControl6.intervalTime = defIntervalTime
        intervalControl7.intervalTime = defIntervalTime
        intervalControl8.intervalTime = defIntervalTime
        intervalControl9.intervalTime = defIntervalTime
        intervalControl10.intervalTime = defIntervalTime
        
        intervalControl1.isTimed = defIntervalIsTimed
        intervalControl2.isTimed = defIntervalIsTimed
        intervalControl3.isTimed = defIntervalIsTimed
        intervalControl4.isTimed = defIntervalIsTimed
        intervalControl5.isTimed = defIntervalIsTimed
        intervalControl6.isTimed = defIntervalIsTimed
        intervalControl7.isTimed = defIntervalIsTimed
        intervalControl8.isTimed = defIntervalIsTimed
        intervalControl9.isTimed = defIntervalIsTimed
        intervalControl10.isTimed = defIntervalIsTimed
    }
    
    function savePage() {
        // Save the intervals
        if (intervalManager.beginAccessWorkout(currentWorkoutIndex) == true) {
            if (intervalControl1.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl1.intervalName)
                intervalManager.setIntervalTime(intervalControl1.intervalTime)
                
                if (intervalControl1.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                	intervalManager.setIntervalReps(intervalControl1.intervalReps)
                	
                intervalManager.setIntervalRest(intervalControl1.isRest)
                intervalManager.endAccessInterval()
            }
            
            if (intervalControl2.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl2.intervalName)
                intervalManager.setIntervalTime(intervalControl2.intervalTime)
                
                if (intervalControl2.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                    intervalManager.setIntervalReps(intervalControl2.intervalReps)
                
                intervalManager.setIntervalRest(intervalControl2.isRest)
                intervalManager.endAccessInterval()
            }
            
            if (intervalControl3.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl3.intervalName)
                intervalManager.setIntervalTime(intervalControl3.intervalTime)
                
                if (intervalControl3.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                    intervalManager.setIntervalReps(intervalControl3.intervalReps)
                
                intervalManager.setIntervalRest(intervalControl3.isRest)
                intervalManager.endAccessInterval()
            }
            
            if (intervalControl4.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl4.intervalName)
                intervalManager.setIntervalTime(intervalControl4.intervalTime)
                
                if (intervalControl4.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                    intervalManager.setIntervalReps(intervalControl4.intervalReps)
                
                intervalManager.setIntervalRest(intervalControl4.isRest)
                intervalManager.endAccessInterval()
            }
            
            if (intervalControl5.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl5.intervalName)
                intervalManager.setIntervalTime(intervalControl5.intervalTime)
                
                if (intervalControl5.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                    intervalManager.setIntervalReps(intervalControl5.intervalReps)
                
                intervalManager.setIntervalRest(intervalControl5.isRest)
                intervalManager.endAccessInterval()
            }
            
            if (intervalControl6.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl6.intervalName)
                intervalManager.setIntervalTime(intervalControl6.intervalTime)
                
                if (intervalControl6.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                    intervalManager.setIntervalReps(intervalControl6.intervalReps)
                
                intervalManager.setIntervalRest(intervalControl6.isRest)
                intervalManager.endAccessInterval()
            }
            
            if (intervalControl7.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl7.intervalName)
                intervalManager.setIntervalTime(intervalControl7.intervalTime)
                
                if (intervalControl7.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                    intervalManager.setIntervalReps(intervalControl7.intervalReps)
                
                intervalManager.setIntervalRest(intervalControl7.isRest)
                intervalManager.endAccessInterval()
            }
            
            if (intervalControl8.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl8.intervalName)
                intervalManager.setIntervalTime(intervalControl8.intervalTime)
                
                if (intervalControl8.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                    intervalManager.setIntervalReps(intervalControl8.intervalReps)
                
                intervalManager.setIntervalRest(intervalControl8.isRest)
                intervalManager.endAccessInterval()
            }
            
            if (intervalControl9.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl9.intervalName)
                intervalManager.setIntervalTime(intervalControl9.intervalTime)
                
                if (intervalControl9.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                    intervalManager.setIntervalReps(intervalControl9.intervalReps)
                
                intervalManager.setIntervalRest(intervalControl9.isRest)
                intervalManager.endAccessInterval()
            }
            
            if (intervalControl10.isValid) {
                intervalManager.addAndBeginAccessInterval()
                intervalManager.setIntervalName(intervalControl10.intervalName)
                intervalManager.setIntervalTime(intervalControl10.intervalTime)
                
                if (intervalControl10.isTimed)
                    intervalManager.setIntervalReps(0)
                else
                    intervalManager.setIntervalReps(intervalControl10.intervalReps)
                
                intervalManager.setIntervalRest(intervalControl10.isRest)
                intervalManager.endAccessInterval()
            }
            
            intervalManager.endAccessWorkout()
        }
        
        workoutPage.loadIntervals()
    }
    
    actions: [
        ActionItem {
            title: "Add Rest"
            onTriggered: {
                if (!intervalControl1.isValid) {
                    intervalControl1.isRest = true
                }
                else if (!intervalControl2.isValid) {
                    intervalControl2.isRest = true
                }
                else if (!intervalControl3.isValid) {
                    intervalControl3.isRest = true
                }
                else if (!intervalControl4.isValid) {
                    intervalControl4.isRest = true
                }
                else if (!intervalControl5.isValid) {
                    intervalControl5.isRest = true
                }
                else if (!intervalControl6.isValid) {
                    intervalControl6.isRest = true
                }
                else if (!intervalControl7.isValid) {
                    intervalControl7.isRest = true
                }
                else if (!intervalControl8.isValid) {
                    intervalControl8.isRest = true
                }
                else if (!intervalControl9.isValid) {
                    intervalControl9.isRest = true
                }
                else if (!intervalControl10.isValid) {
                    intervalControl10.isRest = true
                }
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "images/gray/add_rest.png"
        }
    ]
    
    Container {
        layout: StackLayout {
        }

        topPadding: 20.0
        leftPadding: 20.0
        bottomPadding: 20.0
        rightPadding: 20.0
        
        ScrollView {
            scrollViewProperties.scrollMode: ScrollMode.Vertical

			Container {
			    DropDown {
                    id: numIntervals
                    title: "Intervals"
                    selectedIndex: 0
                    
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    Option {
                        text: "1"
                    }
                    Option {
                        text: "2"
                    }
                    Option {
                        text: "3"
                    }
                    Option {
                        text: "4"
                    }
                    Option {
                        text: "5"
                    }
                    Option {
                        text: "6"
                    }
                    Option {
                        text: "7"
                    }
                    Option {
                        text: "8"
                    }
                    Option {
                        text: "9"
                    }
                    Option {
                        text: "10"
                    }
                    
                    onSelectedIndexChanged: {
                        if (selectedIndex == 0) {
                        	intervalControl1.visible = true
                            intervalControl2.visible = false
                            intervalControl3.visible = false
                            intervalControl4.visible = false
                            intervalControl5.visible = false
                            intervalControl6.visible = false
                            intervalControl7.visible = false
                            intervalControl8.visible = false
                            intervalControl9.visible = false
                            intervalControl10.visible = false
                        }
                        else if (selectedIndex == 1) {
                            intervalControl1.visible = true
                            intervalControl2.visible = true
                            intervalControl3.visible = false
                            intervalControl4.visible = false
                            intervalControl5.visible = false
                            intervalControl6.visible = false
                            intervalControl7.visible = false
                            intervalControl8.visible = false
                            intervalControl9.visible = false
                            intervalControl10.visible = false
                        }
                        else if (selectedIndex == 2) {
                            intervalControl1.visible = true
                            intervalControl2.visible = true
                            intervalControl3.visible = true
                            intervalControl4.visible = false
                            intervalControl5.visible = false
                            intervalControl6.visible = false
                            intervalControl7.visible = false
                            intervalControl8.visible = false
                            intervalControl9.visible = false
                            intervalControl10.visible = false
                        }
                        else if (selectedIndex == 3) {
                            intervalControl1.visible = true
                            intervalControl2.visible = true
                            intervalControl3.visible = true
                            intervalControl4.visible = true
                            intervalControl5.visible = false
                            intervalControl6.visible = false
                            intervalControl7.visible = false
                            intervalControl8.visible = false
                            intervalControl9.visible = false
                            intervalControl10.visible = false
                        }
                        else if (selectedIndex == 4) {
                            intervalControl1.visible = true
                            intervalControl2.visible = true
                            intervalControl3.visible = true
                            intervalControl4.visible = true
                            intervalControl5.visible = true
                            intervalControl6.visible = false
                            intervalControl7.visible = false
                            intervalControl8.visible = false
                            intervalControl9.visible = false
                            intervalControl10.visible = false
                        }
                        else if (selectedIndex == 5) {
                            intervalControl1.visible = true
                            intervalControl2.visible = true
                            intervalControl3.visible = true
                            intervalControl4.visible = true
                            intervalControl5.visible = true
                            intervalControl6.visible = true
                            intervalControl7.visible = false
                            intervalControl8.visible = false
                            intervalControl9.visible = false
                            intervalControl10.visible = false
                        }
                        else if (selectedIndex == 6) {
                            intervalControl1.visible = true
                            intervalControl2.visible = true
                            intervalControl3.visible = true
                            intervalControl4.visible = true
                            intervalControl5.visible = true
                            intervalControl6.visible = true
                            intervalControl7.visible = true
                            intervalControl8.visible = false
                            intervalControl9.visible = false
                            intervalControl10.visible = false
                        }
                        else if (selectedIndex == 7) {
                            intervalControl1.visible = true
                            intervalControl2.visible = true
                            intervalControl3.visible = true
                            intervalControl4.visible = true
                            intervalControl5.visible = true
                            intervalControl6.visible = true
                            intervalControl7.visible = true
                            intervalControl8.visible = true
                            intervalControl9.visible = false
                            intervalControl10.visible = false
                        }
                        else if (selectedIndex == 8) {
                            intervalControl1.visible = true
                            intervalControl2.visible = true
                            intervalControl3.visible = true
                            intervalControl4.visible = true
                            intervalControl5.visible = true
                            intervalControl6.visible = true
                            intervalControl7.visible = true
                            intervalControl8.visible = true
                            intervalControl9.visible = true
                            intervalControl10.visible = false
                        }
                        else {
                            intervalControl1.visible = true
                            intervalControl2.visible = true
                            intervalControl3.visible = true
                            intervalControl4.visible = true
                            intervalControl5.visible = true
                            intervalControl6.visible = true
                            intervalControl7.visible = true
                            intervalControl8.visible = true
                            intervalControl9.visible = true
                            intervalControl10.visible = true
                        }
                    }
                }
			    
                IntervalControl {
                    id: intervalControl1
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 1"
                    isRest: false
                    isTimed: true
                }
                
                IntervalControl {
                    id: intervalControl2
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 2"
                    isRest: false
                    isTimed: true
                    visible: false
                }
                
                IntervalControl {
                    id: intervalControl3
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 3"
                    isRest: false
                    isTimed: true
                    visible: false
                }
                
                IntervalControl {
                    id: intervalControl4
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 4"
                    isRest: false
                    isTimed: true
                    visible: false
                }
                
                IntervalControl {
                    id: intervalControl5
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 5"
                    isRest: false
                    isTimed: true
                    visible: false
                }
                
                IntervalControl {
                    id: intervalControl6
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 6"
                    isRest: false
                    isTimed: true
                    visible: false
                }
                
                IntervalControl {
                    id: intervalControl7
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 7"
                    isRest: false
                    isTimed: true
                    visible: false
                }
                
                IntervalControl {
                    id: intervalControl8
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 8"
                    isRest: false
                    isTimed: true
                    visible: false
                }
                
                IntervalControl {
                    id: intervalControl9
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 9"
                    isRest: false
                    isTimed: true
                    visible: false
                }
                
                IntervalControl {
                    id: intervalControl10
                    topMargin: 20
                    horizontalAlignment: HorizontalAlignment.Fill
                    headerText: "Interval 10"
                    isRest: false
                    isTimed: true
                    visible: false
                }
            }
        }
    }
    
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                savePage()
                navigationPane.pop()
            }
        }
    }
}
