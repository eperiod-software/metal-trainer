import bb.cascades 1.0

Page {
    id: workoutStarterPage
    
    property int workoutIndex
    property int numRounds
    property alias finishedWorkout : finished.visible
    property bool showShare
    property int delayLeft
    
    onShowShareChanged: {
        shareWorkout.visible = false //showShare
        startWorkout.visible = !showShare
    }
    
    function workoutFinishing() {
        if (intervalManager.beginAccessWorkout(workoutIndex)) {
            workoutName.text = intervalManager.getWorkoutName()
            workoutName.visible = true
            workoutCountdown.visible = false
            
            intervalManager.endAccessWorkout()
            
            startWorkout.visible = true
        }
    }
    
    function load(index) {
        workoutIndex = index
        finishedWorkout = false
        
        if (intervalManager.beginAccessWorkout(index)) {
            workoutName.text = intervalManager.getWorkoutName()
            
            numRounds = intervalManager.getNumRounds()
            
            intervalManager.endAccessWorkout()
            
            startWorkout.visible = true
        }
    }

    function launchWorkout() {
        // Open the workout page
        var newPage = workingOutPageDefn.createObject()
        intervalManager.launchWorkout(workoutIndex)
        newPage.startPolling(numRounds)
        navigationPane.push(newPage)
    }
    
    function startCountdown() {
        // Delay
        delayLeft = settingsManager.workoutDelay
        finished.visible = false
        
        if (delayLeft > 0) {
            startWorkout.visible = false
            workoutName.visible = false 
            workoutCountdown.visible = true
            timer.start()
            workoutCountdown.text = delayLeft
        }
        else
            launchWorkout()
    }
    
    Container {
        layout: DockLayout {

        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        leftPadding: 20.0
        topPadding: 20.0
        rightPadding: 20.0
        bottomPadding: 20.0
        Container {
            layout: StackLayout {
                
            }
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Fill
            Label {
                id: workoutName
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.base: SystemDefaults.TextStyles.BigText
                textStyle.color: Color.create("#ff4386ba")
            }
            Label {
                id: workoutCountdown
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.Bold
                textStyle.color: Color.create("#ff4386ba")
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 60.0
                visible: false
            }
            Label {
                id: finished
                horizontalAlignment: HorizontalAlignment.Center
                text: "Finished workout!"
            }
            Button {
                id: shareWorkout
                topMargin: 100.0
                visible: false
                text: "BBM"
                horizontalAlignment: HorizontalAlignment.Center
                imageSource: "asset:///images/contrast/share.png"
                onClicked: {
                    invoke.query.data = "Just finished my " + workoutName.text + " workout with Metal Trainer for BB10."
                    invoke.trigger("bb.action.SHARE")
                }
                attachedObjects: [
                    Invocation {
                        id: invoke
                        query {
                            invokeTargetId: "sys.bbm.sharehandler"
                            mimeType: "text/plain"
                            data: "Just finished my workout with Metal Trainer for BB10."
                        }
                    }
                ]
                preferredWidth: 160.0
            }
            Button {
                id: startWorkout
                topMargin: 100.0
                text: "Start!"
                horizontalAlignment: HorizontalAlignment.Center
                onClicked: {
                    startCountdown()
                }
            }
        }
    }

    attachedObjects: [
        // Create ComponentDefinitions that represent the custom
        // components
        ComponentDefinition {
            id: workingOutPageDefn
            source: "workingOut.qml"
        },
        QTimer {
            id: timer
            
            // Set interval to poll every second
            interval: 1000
            
            singleShot: true
            
            onTimeout: {
                delayLeft -= 1
                workoutCountdown.text = delayLeft
                
                if (delayLeft == 0)
                    launchWorkout()
                else
                    timer.start()
            }
        }
    ]
    
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                timer.stop()
                navigationPane.pop()
            }
        }
    }
}
