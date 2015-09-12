import bb.cascades 1.0
import bb.system 1.0

Page {
    id: workoutPage
    
    titleBar: TitleBar {
        title: "Workout"
        dismissAction: ActionItem {
            title: "Cancel"
            onTriggered: {
                if (newWorkout) {
                    if (intervalManager.beginAccessWorkout(currentIndex) == true)
                        intervalManager.deleteAndEndAccessWorkout()
                }
                
                navigationPane.pop()
            }
        }
    }
    
    property int currentIndex
    property bool newWorkout
    
    function loadPage(workoutIndex) {
        if (intervalManager.beginAccessWorkout(workoutIndex) == true)
        	newWorkout = false
        else {
            workoutIndex = intervalManager.addAndBeginAccessWorkout()
            newWorkout = true
        }
        
        currentIndex = workoutIndex
        
        workoutName.text = intervalManager.getWorkoutName()
        numRounds.selectedIndex = intervalManager.getNumRounds() - 1
        intervalManager.endAccessWorkout()
        
        loadIntervals()
    }
    
    function savePage() {
        // Save the workout name
        if (intervalManager.beginAccessWorkout(currentIndex) == true) {
	        intervalManager.setWorkoutName(workoutName.text)
	        intervalManager.setWorkoutRounds(numRounds.selectedIndex + 1)
	        intervalManager.endAccessWorkout()
         }
        
        mainPage.loadWorkouts()
    }
    
    function loadIntervals() {
        // Clear list of workouts
        var x = 0
        
        intervalsDataModel.clear()
        
        if (intervalManager.beginAccessWorkout(currentIndex) != true)
        	return
        
        while (intervalManager.beginAccessInterval(x) == true) {
            var name
            if (intervalManager.getIntervalRest())
            	name = "Rest"
            else
            	name = intervalManager.getIntervalName()
            	
            var reps = intervalManager.getIntervalReps()
            var time = intervalManager.timeToString(intervalManager.getIntervalTime())
            
            var subtitle
            
            if (reps > 0)
            	subtitle = "Reps: " + reps
            else
            	subtitle = "Time: " + time
            
            intervalsDataModel.append({
                    "title" : name,
                    "subtitle" : subtitle
            })
            
            intervalManager.endAccessInterval()
            x++
        }
        
        intervalManager.endAccessWorkout()
        
        if (x == 0) {
            intervalsList.visible = false
            noIntervalsLabel.visible = true
        }
        else {
            intervalsList.visible = true
            noIntervalsLabel.visible = false
        }
    }
    
    actions: [
        ActionItem {
            title: "Add Intervals"
            onTriggered: {
                var newPage = multiIntervalsPageDefn.createObject()
                newPage.loadPage(currentIndex)
                navigationPane.push(newPage)
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/gray/add_workout.png"
        },
        ActionItem {
            title: "Add Rest"
            onTriggered: {
                var newPage = intervalPageDefn.createObject()
                newPage.loadPage(true, currentIndex, -1)
                navigationPane.push(newPage)
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "images/gray/add_rest.png"
        }
    ]
    
    Container {
        layout: DockLayout {
        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        Label {
            id: noIntervalsLabel
            text: "No Intervals"
            textStyle.base: SystemDefaults.TextStyles.BigText
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.color: Color.LightGray
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
            
            Container {
                layout: StackLayout {
                }
                horizontalAlignment: HorizontalAlignment.Fill
                TextField {
                    id: workoutName
                    hintText: "Enter workout name"
                }
                DropDown {
                    id: numRounds
                    selectedIndex: 0
                    title: "Rounds"
                    topMargin: 20.0
                    horizontalAlignment: HorizontalAlignment.Fill
                    
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
                        }
                    ]
                }
            }
            ListView {
                id: intervalsList
                dataModel: ArrayDataModel {
                    id: intervalsDataModel
                }
                
                horizontalAlignment: HorizontalAlignment.Fill
                topMargin: 20.0

                function editInterval(index) {
                    var intIndex = intervalManager.toInt(index)
                    var newPage = intervalPageDefn.createObject()
                    newPage.loadPage(true, currentIndex, intIndex)
                    navigationPane.push(newPage)
                }
                
                function moveIntervalDown(index) {
                    var intIndex = intervalManager.toInt(index)
                    
                    if (intervalManager.beginAccessWorkout(currentIndex)) {
                        if (intervalManager.beginAccessInterval(intIndex))
                        	intervalManager.moveDownAndEndAccessInterval()
                        	
                        intervalManager.endAccessWorkout()
                        
                        workoutPage.loadIntervals()
                    }
                }
                
                function moveIntervalUp(index) {
                    var intIndex = intervalManager.toInt(index)
                    
                    if (intervalManager.beginAccessWorkout(currentIndex)) {
                        if (intervalManager.beginAccessInterval(intIndex))
                            intervalManager.moveUpAndEndAccessInterval()
                        
                        intervalManager.endAccessWorkout()
                        
                        workoutPage.loadIntervals()
                    }
                }

                function deleteInterval(index) {
                    var intIndex = intervalManager.toInt(index)
                    if (intervalManager.beginAccessWorkout(currentIndex)) {
                        if (intervalManager.beginAccessInterval(intIndex))
                            intervalManager.deleteAndEndAccessInterval()

                        intervalManager.endAccessWorkout()
                    }

                    workoutPage.loadIntervals()
                }

                listItemComponents: [
                    ListItemComponent {
                        type: ""
                        Container {
                            id: intervalListItemComponent
                            StandardListItem {
                                title: ListItemData.title
                                description: ListItemData.subtitle
                                status: ListItemData.status
                            }
                            contextActions: [
                                ActionSet {
                                    title: "Actions"
                                    subtitle: "Choose an action"
                                    
                                    ActionItem {
                                        title: "Edit"
                                        onTriggered: {
                                            var selection = intervalListItemComponent.ListItem.view.selectionList()
                                            intervalListItemComponent.ListItem.view.editInterval(selection)
                                        }
                                        imageSource: "asset:///images/ic_edit.png"
                                    }
                                    ActionItem {
                                        title: "Move up"
                                        onTriggered: {
                                            var selection = intervalListItemComponent.ListItem.view.selectionList()
                                            intervalListItemComponent.ListItem.view.moveIntervalUp(selection)
                                        }
                                        imageSource: "asset:///images/gray/move_up.png"
                                    }
                                    ActionItem {
                                        title: "Move down"
                                        onTriggered: {
                                            var selection = intervalListItemComponent.ListItem.view.selectionList()
                                            intervalListItemComponent.ListItem.view.moveIntervalDown(selection)
                                        }
                                        imageSource: "asset:///images/gray/move_down.png"
                                    }
                                    DeleteActionItem {
                                        title: "Delete"
                                        onTriggered: {
                                            var selection = intervalListItemComponent.ListItem.view.selectionList()
                                            intervalListItemComponent.ListItem.view.deleteInterval(selection)
                                        }
                                    }
                                }
                            ]
                        }
                    }
                ]
            }
        }
        
    }
    attachedObjects: [
        // Create ComponentDefinitions that represent the custom
        // components
        ComponentDefinition {
            id: intervalPageDefn
            source: "interval.qml"
        },
        ComponentDefinition {
            id: multiIntervalsPageDefn
            source: "multiIntervals.qml"
        }
    ]
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                if (workoutName.text.length == 0) {
                    workoutNameRequired.show()
                    workoutName.requestFocus()
                }
                else {
                    savePage()
                    navigationPane.pop()
                    workoutSaved.show()
                }
            }
            attachedObjects: [
                SystemToast {
                    id: workoutNameRequired
                    body: "Workout name required."
                    icon: "asset:///images/toast_error.png"
                },
                SystemToast {
                    id: workoutSaved
                    body: "Workout saved."
                }
            ]
        }
    }
}
