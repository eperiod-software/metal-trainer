import bb.cascades 1.0

Container {
    property alias soundDescription : header.title
    property alias soundIndex : sound.selectedIndex
    property alias soundName : sound.selectedValue
    
    function setSound(name) {
        var index = 0
        for (var x = 0; x < sound.options.length; x++) {
            if (sound.options[x].value == name) {
                index = x
                break
            }
        }
        
        soundIndex = index
    }
    
    signal playSound(string filename)
    
    Header {
        id: header
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        topMargin: 20.0
        DropDown {
            id: sound
            title: "Sound"
            horizontalAlignment: HorizontalAlignment.Fill
            
            Option {
                text: "None"
                value: ""
            }
            Option {
                text: "Alarm 1"
                value: "alarm1"
            }
            Option {
                text: "Alarm 2"
                value: "alarm2"
            }
            Option {
                text: "Alarm 3"
                value: "alarm3"
            }
            Option {
                text: "Bell 1"
                value: "bell1"
            }
            Option {
                text: "Bell 2"
                value: "bell2"
            }
            Option {
                text: "Bell 3"
                value: "bell3"
            }
            Option {
                text: "Boxing bell 1"
                value: "boxing1"
            }
            Option {
                text: "Boxing bell 2"
                value: "boxing2"
            }
            Option {
                text: "Boxing bell 3"
                value: "boxing3"
            }
            Option {
                text: "Sci fi 1"
                value: "scifi1"
            }
            Option {
                text: "Sci fi 2"
                value: "scifi2"
            }
        }
        Button {
            imageSource: "asset:///images/contrast/play.png"
            maxWidth: 90.0
            onClicked: {
                if (sound.selectedValue.length > 0) {
                    var soundExt = settingsManager.soundExt
                    var filename = "asset:///sounds/" + sound.selectedValue + soundExt
                    playSound(filename)
                }
            }
        }
    }
}
