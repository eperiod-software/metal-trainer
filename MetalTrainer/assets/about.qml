import bb.cascades 1.0

Page {
    onCreationCompleted: {
        var text = "<span style=\"color: #bbbbbb\"><p><em>ePeriod Software</em></p>"
        text += "<p><em>Version 1.1.0</em></p></span>"
        text += "<br /><p><strong>About</strong></p>"
        text += "<br /><p>Keep track of your interval workouts with Metal Trainer.</p>"
        text += "<br /><p><strong>Sound Effects</strong></p>"
        text += "<br /><p><a href=\"http://www.freesfx.co.uk/\">"
        text += "http://www.freesfx.co.uk</a></p>"
        text += "<p>Beep 1</p><p>Boxing 1 &amp; 2</p><p>Bell 1 &amp; 2</p>"
        text += "<br /><p><strong>Contact</strong></p>"
        text += "<br /><p>If you have any questions, comments or bug reports,"
        text += " please contact Vaughn Friesen, ePeriod Software.</p>"
        text += "<br /><p><a href=\"mailto:vaughn.friesen@masterofbinary.com\">"
        text += "vaughn.friesen@masterofbinary.com</a></p>"
        textArea.text = text
        
        if (intervalManager.trialVersion())
            titleText.text = "Metal Trainer Free"
    }
    
    Container {
        layout: StackLayout {

        }

        topPadding: 40.0
        leftPadding: 40.0
        rightPadding: 40.0
        bottomPadding: 40.0
        ImageView {
            imageSource: "asset:///images/app.png"
            horizontalAlignment: HorizontalAlignment.Center
            preferredWidth: 128.0
            preferredHeight: 128.0
        }
        Label {
            id: titleText
            text: "Metal Trainer"
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
