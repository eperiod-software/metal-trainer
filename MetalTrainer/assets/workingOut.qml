import bb.cascades 1.0
import bb.multimedia 1.0

Page {
    id: workingOutPage
    
    property int numRounds
    property bool pausedWorkout
    property bool canceledWorkout
    
    property string soundStart
    property string soundFinish
    property string soundNewInterval
    property string soundRest
    property string soundWarning
    
    function quitWorkout() {
        // Quit the timer and close the window
        stopTimer()
        workoutStarterPage.workoutFinishing()
        navigationPane.pop()
        
        navigationPane.backButtonsVisible = true
        
        // Turn on screen timeout
        settingsManager.setDeviceScreenOn(false)
    }
    
    function startPolling(rounds) {
        pausedWorkout = false
        canceledWorkout = false
        
        var soundExt = settingsManager.soundExt
        
        var sound = settingsManager.startSound
        if (sound.length == 0)
            soundStart = ""
        else
            soundStart = "asset:///sounds/" + sound + soundExt
            
        sound = settingsManager.finishSound
        if (sound.length == 0)
            soundFinish = ""
        else
            soundFinish = "asset:///sounds/" + sound + soundExt
        
        sound = settingsManager.intervalSound
        if (sound.length == 0)
            soundNewInterval = ""
        else
        	soundNewInterval = "asset:///sounds/" + sound + soundExt
        	
        sound = settingsManager.restSound
        if (sound.length == 0)
            soundRest = ""
        else
            soundRest = "asset:///sounds/" + sound + soundExt
        
        sound = settingsManager.warningSound
        if (sound.length == 0)
            soundWarning = ""
        else
            soundWarning = "asset:///sounds/" + sound + soundExt
            
        playSound(soundStart)
        
        numRounds = rounds
        navigationPane.backButtonsVisible = false
        
        // Turn off screen timeout
        settingsManager.setDeviceScreenOn(settingsManager.keepScreenOn)
        
    	// Start the timer
        intervalPoller.init()
        intervalPoller.setWarningTimeSeconds(settingsManager.warningTime)
    	startTimer()
    }
    
    function pollOnce() {
        intervalPoller.poll()
        var done = intervalPoller.isFinished()
        
        if (done) {
            // Play sound
            playSound(soundFinish)
            
            quitWorkout()
            
            if (!canceledWorkout) {
                workoutStarterPage.finishedWorkout = true
                workoutStarterPage.showShare = true
            }
        }
        
        roundNum.text = intervalPoller.getRound() + "/" + numRounds
        
        if (intervalPoller.isStarted()) {
            intervalTimeRemaining.visible = true
            
            var reps = intervalPoller.getIntervalReps()
            
            if (reps > 0) {
                intervalTimeRemaining.text = reps + " reps"
                nextInterval.visible = true
                roundNum.visible = false
            }
            else {
                var timeRemaining = intervalPoller.getIntervalRemainingTime()
                intervalTimeRemaining.text = intervalManager.timeMsToString(timeRemaining)
                nextInterval.visible = false
                roundNum.visible = true
            }
            
            // Set the interval name
            intervalName.text = intervalPoller.getIntervalName()
            nextIntervalName.text = "Next: " + intervalPoller.getNextIntervalName()
            
            // See if we should play a sound
            playSounds()
        }
        else
            intervalTimeRemaining.visible = false
    }
    
    function playSound(filename) {
        if (filename.length == 0)
        	return
        soundPlayer.stop()
        soundPlayer.setSourceUrl(filename)
        soundPlayer.play()
    }
    
    function playSounds() {
        if (intervalPoller.isNewWarning())
        	playSound(soundWarning)
        if (intervalPoller.isNewInterval())
            playSound(soundNewInterval)
        else if (intervalPoller.isNewRest())
            playSound(soundRest)
    }
    
    function startTimer() {
        timer.start()
    }
    
    function stopTimer() {
        timer.stop()
    }
    
    actions: [
        ActionItem {
            id: stopButton
            title: "Stop"
            onTriggered: {
                canceledWorkout = true
                intervalManager.killWorkout()
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/gray/stop.png"
        },
        ActionItem {
            id: pauseButton
            title: "Pause"
            onTriggered: {
                if (pausedWorkout) {
                    pausedWorkout = false
                    intervalManager.pauseWorkout(false)
                    intervalTimeRemaining.textStyle.color = Color.create("#ff4386ba")
                    pauseButton.title = "Pause"
                    pauseButton.imageSource = "asset:///images/gray/pause.png"
                    startTimer()
                } else {
                    pausedWorkout = true
                    intervalManager.pauseWorkout(true)
                    intervalTimeRemaining.textStyle.color = Color.LightGray
                    pauseButton.title = "Resume"
                    pauseButton.imageSource = "asset:///images/gray/play.png"
                    stopTimer()
                }
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/gray/pause.png"
        }
    ]
    
    Container {
        layout: DockLayout {

        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        topPadding: 20.0
        bottomPadding: 20.0
        
        Container {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Fill
            
            Label {
                id: roundNum
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 22.0
            }
            Label {
                id: intervalName
                horizontalAlignment: HorizontalAlignment.Center
                topMargin: 20.0
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 18.0
            }
            Label {
                id: intervalTimeRemaining
                horizontalAlignment: HorizontalAlignment.Center
                topMargin: 20.0
                textStyle.fontWeight: FontWeight.Bold
                textStyle.color: Color.create("#ff4386ba")
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 40.0
            }
            Label {
                id: nextIntervalName
                horizontalAlignment: HorizontalAlignment.Center
                topMargin: 20.0
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 18.0
            }
            Button {
                id: nextInterval
                text: "Next"
                horizontalAlignment: HorizontalAlignment.Center
                topMargin: 20.0
                visible: false
                onClicked: {
                    intervalManager.nextWorkout()
                }
            }

        }
    }

    attachedObjects: [
        QTimer {
            id: timer

            // Set interval to poll every 50 ms
            interval: 50

            onTimeout: {
                pollOnce()
            }
        },
        MediaPlayer {
            id: soundPlayer
        }
    ]
}
