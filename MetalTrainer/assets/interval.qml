import bb.cascades 1.0
import bb.system 1.0

Page {
    id: intervalPage
    
    titleBar: TitleBar {
        id: intervalTitleBar
        title: "Interval"
        dismissAction: ActionItem {
            title: "Cancel"
            onTriggered: {
                navigationPane.pop()
            }
        }
    }
    
    property int currentIndex
    property int currentWorkoutIndex
    
    function loadPage(rest, workoutIndex, intervalIndex) {
        currentWorkoutIndex = workoutIndex
        currentIndex = intervalIndex
        
        if (intervalManager.beginAccessWorkout(currentWorkoutIndex) == true) {
            if (intervalManager.beginAccessInterval(currentIndex) == true) {
                intervalControl.intervalName = intervalManager.getIntervalName()
                intervalControl.isRest = intervalManager.getIntervalRest()
                intervalControl.intervalTime = intervalManager.getIntervalTime()
                var reps = intervalManager.getIntervalReps()
                intervalControl.intervalReps = reps
                intervalControl.isTimed = (reps <= 0)
                intervalManager.endAccessInterval()
            }
            else {
                intervalControl.intervalName = ""
                intervalControl.isRest = rest
                intervalControl.intervalTime = settingsManager.defaultIntervalTime
            }

            intervalManager.endAccessWorkout()
        }
        
        if (intervalControl.isRest)
            intervalTitleBar.title = "Rest"
        else
            intervalTitleBar.title = "Interval"
    }
    
    function savePage() {
        // Save the interval name
        if (intervalManager.beginAccessWorkout(currentWorkoutIndex) == true) {
            if (intervalManager.beginAccessInterval(currentIndex) != true)
                intervalManager.addAndBeginAccessInterval()
            
            intervalManager.setIntervalName(intervalControl.intervalName)
            var timed = intervalControl.isTimed
            if (timed) {
                intervalManager.setIntervalTime(intervalControl.intervalTime)
                intervalManager.setIntervalReps(0)
            }
            else {
                intervalManager.setIntervalReps(intervalControl.intervalReps)
            }
            intervalManager.setIntervalRest(intervalControl.isRest)
            intervalManager.endAccessInterval()
            intervalManager.endAccessWorkout()
        }
        
        workoutPage.loadIntervals()
    }
    
    Container {
        layout: DockLayout {
        }
        Container {
            layout: StackLayout {
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            topPadding: 20.0
            leftPadding: 20.0
            bottomPadding: 20.0
            rightPadding: 20.0
            IntervalControl {
                id: intervalControl
                headerText: "Edit Interval"
                isTimed: true
                topMargin: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
            }
        }
    }
    
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                if (intervalControl.intervalName.length == 0 && !intervalControl.isRest) {
                    intervalNameRequired.show()
                    intervalControl.requestFocus()
                }
                else {
                    savePage()
                    navigationPane.pop()
                }
            }
            attachedObjects: [
                SystemToast {
                    id: intervalNameRequired
                    body: "Interval name required."
                    icon: "images/toast_error.png"
                }
            ]
        }
    }
}
