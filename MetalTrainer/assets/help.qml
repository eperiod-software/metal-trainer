import bb.cascades 1.0

Page {
    onCreationCompleted: {
        var text = "<p><strong>Main Page</strong></p>"
        
        text += "<br /><p>The main page is where workouts are listed. If you're"
        text += " using Metal Trainer for the first time, there won't be any"
        text += " initially. Once you add some, they'll show up and you can"
        text += " run one by tapping on it, or edit one by pressing and holding"
        text += " one, and choosing \"Edit\" from the context menu.</p>"
        text += "<br /><p>If you want to delete a workout, choose \"Delete\""
        text += " from the context menu. To create a new workout, choose "
        text += "\"Add Workout\" from the action menu at the bottom of the "
        text += "screen.</p>"
        
        text += "<br /><p><strong>Workout Page</strong></p>"
        
        text += "<br /><p>When creating or editing a workout, you'll see the "
        text += "workout page. You can set a name for it, as well as the number "
        text += "of rounds - the number of times it repeats.</p>"
        text += "<br /><p>This is also where all your intervals are listed, and "
        text += "you can add or edit them much like you can with workouts. The "
        text += "main difference is you can add two types of intervals: regular "
        text += "intervals and rests.</p>"
        text += "<br /><p>When you add intervals, you can choose the number to "
        text += "add. For each interval, set the name that will show up in the "
        text += "workout page, and the amount of time the interval lasts. You "
        text += "can make the last empty interval into a rest by pushing the "
        text += "\"Add Rest\" button.</p>"
        text += "<br /><p>When you add a rest, you can only choose the "
        text += "time. Otherwise you can choose to add a timed interval or not. "
        text += "If you add a non-timed interval, while working out you'll need "
        text += "to tap a \"next\" button when your reps are done, to proceed "
        text += "to the next interval.</p>"
        
        text += "<br /><p><strong>Working Out</strong></p>"
        
        text += "<br /><p>When you have a workout ready, you can tap it in the "
        text += "main page to start. A screen with a \"Start\" button will appear, "
        text += "so hit the start button to start. If you specified a starting "
        text += "delay in the settings (described later), it will count down until "
        text += "that time is up and then workout starts.</p>"
        
        text += "<br /><p>During workout, you'll see some information about the "
        text += "workout: round number and total rounds, current interval, next "
        text += "interval, and time left until the end of the interval. If the "
        text += "current interval isn't timed, you'll see the number of reps.</p>"
        
        text += "<br /><p>You can cancel or pause the workout by pressing the "
        text += "respective buttons.</p>"
        
        text += "<br /><p><strong>Settings</strong></p>"
        
        text += "<br /><p>The settings page has notification and delay settings. "
        text += "Starting delay is the amount of time after hitting the start "
        text += "button and before the workout starts. Default interval time "
        text += "is the time all intervals will start with by default.</p>"
        text += "<br /><p>There are four notifications that are pretty "
        text += "self-explanatory. Start workout, finished workout, next interval "
        text += "(when it's time for a new non-rest interval), and rest. Warning "
        text += "notification lets you know when an interval is nearly finished; "
        text += "set the amount of time to warn before the end of an interval.</p>"
        
        text += "<br /><p>For each notification, you can choose one of several "
        text += "preset sounds, and click the preview button to listen to them. "
        text += "Some are serious, some are fun.</p>"
        
        textArea.text = text
    }
    
    Container {
        layout: StackLayout {

        }
        topPadding: 40.0
        rightPadding: 40.0
        bottomPadding: 40.0
        leftPadding: 40.0
        Label {
            text: "Metal Training Help"
            textStyle.color: Color.create("#ff4386ba")
            horizontalAlignment: HorizontalAlignment.Center
        }
        ScrollView {
            scrollViewProperties {
                scrollMode: scrollMode.Vertical
            }
            TextArea {
                id: textArea
                textFormat: TextFormat.Html
                editable: false
                maximumLength: 10000
            }
        }
    }
}
