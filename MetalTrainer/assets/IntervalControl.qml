import bb.cascades 1.0

Container {
    layout: StackLayout {
    }
    
    property bool isValid : false
    property alias headerText : header.title
    property bool isRest
    property alias intervalName : intervalNameText.text
    
    property alias isTimed : timed.checked
    
    property int intervalTime
    property int intervalReps
    
    function requestFocus() {
        intervalNameText.requestFocus()
    }
    
    function checkValid() {
        isValid = (intervalNameText.text.length > 0 || isRest) && visible
    }
    
    onIntervalTimeChanged: {
        if (intervalTime > 0)
        	intervalTimeDropDown.selectedIndex = getTimeIndex(intervalTime)
    }
    
    onIntervalRepsChanged: {
        if (intervalReps > 0)
        	intervalRepsDropDown.selectedIndex = getRepsIndex(intervalReps)
        timed.checked = (intervalReps <= 0)
    }
    
    onVisibleChanged: {
        checkValid()
    }
    
    onIsRestChanged: {
        restCheckBox.checked = isRest
        intervalNameText.visible = !isRest
        restContainer.visible = isRest
        checkValid()
    }
    
    function getTimeIndex(time) {
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
    
    function getRepsIndex(reps) {
        var index = 0
        
        if (reps <= 40)
        	index = reps - 1
        else
        	index = (reps - 40) / 5 + 39
        	
        return index
    }
    
    function getDropDownTime() {
        // Get the index of the drop down control
        var index = intervalTimeDropDown.selectedIndex
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
    
    function getDropDownReps() {
        var index = intervalRepsDropDown.selectedIndex
        var reps = 0
        
        if (index <= 39)
        	reps = index + 1
        else
        	reps = (index - 39) * 5 + 40
        	
        return reps
    }
    
    Header {
        id: header
    }
    
    Container {
        id: restContainer
        
        topMargin: 20.0
        bottomMargin: 20.0
        visible: false
        
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        CheckBox {
        	id: restCheckBox
        	checked: false
        	onCheckedChanged: {
            	if (checked) {
                    timed.checked = true
                    timed.visible = false
            	}
            	else {
            	    timed.visible = true
            	    isRest = false
            	}
            }
        }
        
        Label {
            id: restLabel
            text: "Rest"
            topMargin: 20.0
            leftMargin: 20.0
        }
    }
    
    TextField {
        id: intervalNameText
        hintText: "Enter interval name"
        topMargin: 20.0
        horizontalAlignment: HorizontalAlignment.Fill
        onTextChanging: {
            checkValid()
        }
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        CheckBox {
            id: timed
            text: "Timed"
            verticalAlignment: VerticalAlignment.Center
            topMargin: 20.0
            
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1.0
            }
            
            onCheckedChanged: {
                intervalRepsDropDown.visible = !checked
                intervalTimeDropDown.visible = checked
            }
        }
        
        DropDown {
            id: intervalRepsDropDown
            title: "Reps"
            visible: false
            selectedIndex: 9
            topMargin: 20.0
            
            layoutProperties: StackLayoutProperties {
                spaceQuota: 2.0
            }
            
            onSelectedIndexChanged: {
                intervalReps = getDropDownReps()
            }

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
                    text: "11"
                },
                Option {
                    text: "12"
                },
                Option {
                    text: "13"
                },
                Option {
                    text: "14"
                },
                Option {
                    text: "15"
                },
                Option {
                    text: "16"
                },
                Option {
                    text: "17"
                },
                Option {
                    text: "18"
                },
                Option {
                    text: "19"
                },
                Option {
                    text: "20"
                },
                Option {
                    text: "21"
                },
                Option {
                    text: "22"
                },
                Option {
                    text: "23"
                },
                Option {
                    text: "24"
                },
                Option {
                    text: "25"
                },
                Option {
                    text: "26"
                },
                Option {
                    text: "27"
                },
                Option {
                    text: "28"
                },
                Option {
                    text: "29"
                },
                Option {
                    text: "30"
                },
                Option {
                    text: "31"
                },
                Option {
                    text: "32"
                },
                Option {
                    text: "33"
                },
                Option {
                    text: "34"
                },
                Option {
                    text: "35"
                },
                Option {
                    text: "36"
                },
                Option {
                    text: "37"
                },
                Option {
                    text: "38"
                },
                Option {
                    text: "39"
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

		DropDown {
            id: intervalTimeDropDown
            title: "Time"
            selectedIndex: 5
            topMargin: 20.0
            
            layoutProperties: StackLayoutProperties {
                spaceQuota: 2.0
            }

            onSelectedIndexChanged: {
                intervalTime = getDropDownTime()
            }

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
    }

}
