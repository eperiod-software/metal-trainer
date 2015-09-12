import bb.cascades 1.0
import bb.system 1.0
import bb.cascades.pickers 1.0

NavigationPane {
    id: navigationPane
    peekEnabled: false
    
    function canOpenMenu() {
        if (intervalPoller.isStarted() && !intervalPoller.isFinished()) {
            // Show a toast
            duringWorkout.show()
            
            return false
        }
        
        return true
    }
    
    // Add the application menu using a MenuDefinition
    Menu.definition: MenuDefinition {
        settingsAction: SettingsActionItem {
            onTriggered: {
                // Make sure there are no workouts running
                if (!canOpenMenu())
                	return;
                
                var newPage = settingsPageDefn.createObject()
                navigationPane.push(newPage)
            }
        }
        helpAction: HelpActionItem {
            onTriggered: {
                // Make sure there are no workouts running
                if (!canOpenMenu())
                    return;
                
                var newPage = helpPageDefn.createObject()
                navigationPane.push(newPage)
            }
        }
        actions: [
            ActionItem {
                title: "About"
                imageSource: "images/ic_info.png"
                
                onTriggered: {
                    // Make sure there are no workouts running
                    if (!canOpenMenu())
                        return;
                    
                    var newPage = aboutPageDefn.createObject()
                    navigationPane.push(newPage)
                }
            }/*,
            ActionItem {
                title: "Theme"
                imageSource: "images/gray/theme.png"
                
                onTriggered: {
                    var newPage = themePageDefn.createObject()
                    navigationPane.push(newPage)
                }
            }*/
        ] // end of actions list
    } // end of MenuDefinition
    
    Page {
        id: mainPage
        
        onCreationCompleted: {
            isActiveFrame = false
            trialText.visible = intervalManager.trialVersion()
            
            loadFromDisk()
            loadWorkouts()
            
            intervalManager.quitting.connect(mainPage.quitting)
            Application.thumbnail.connect(mainPage.backgrounded)
            Application.fullscreen.connect(mainPage.foregrounded)
        }

		function quitting() {
		    // Kill any running workouts
		    intervalManager.killWorkout()
		    
		    saveToDisk()
		}
        
        function loadFromDisk() {
            // Load settings
            if (!settingsManager.loadSettings("data/settings.dat"))
            	console.log("Error loading settings from file 'data/settings.dat'")
            	
            // Load workouts
            if (!intervalManager.loadFromFile("data/workouts.dat"))
                console.log("Error loading workouts from file 'data/workouts.dat'")
        }
        
        function saveToDisk() {
            // Save settings
            if (!settingsManager.saveSettings("data/settings.dat"))
            	console.log("Error saving settings to file 'data/settings.dat'")
            	
            // Save workouts
            if (!intervalManager.saveToFile("data/workouts.dat"))
                console.log("Error saving workouts to file 'data/workouts.dat'")
        }
        
        function loadWorkouts() {
            // Clear list of workouts
            var x = 0
            
            workoutsDataModel.clear()

            while (intervalManager.beginAccessWorkout(x) == true) {
                var numRounds = intervalManager.getNumRounds()
                var name = intervalManager.getWorkoutName()
                var info = "Rounds: " + numRounds
                var info2 = ", Intervals: " + intervalManager.getNumIntervals()
                var time = intervalManager.getRoundTime() * numRounds
                var reps = intervalManager.getRoundReps() * numRounds
                var status = "Total: " + intervalManager.timeToString(time)
                if (reps > 0)
                	status += " + " + reps + " reps"
                
                workoutsDataModel.append({
                    "title" : name,
                    "subtitle" : info + info2,
                    "status" : status
                    })
                intervalManager.endAccessWorkout()
                x++
            }

            if (x == 0) {
                workoutsList.visible = false
                noWorkoutsLabel.visible = true
            }
            else {
                workoutsList.visible = true
                noWorkoutsLabel.visible = false
            }
        }
        
        // If this is a trial version and the workouts are full gives an error
        function tryAddWorkout() {
            if (intervalManager.trialVersion() && intervalManager.workoutsFull()) {
                trialDialog.show()
                return false
            }
            else
            	return true
        }
        
        function launchBBWorld() {
            app.launchBBWorld()
        }
        
        function backgrounded() {
            isActiveFrame = true
        }
        
        function foregrounded() {
            isActiveFrame = false
        }
        
        property int isActiveFrame
        
        actions: [
            ActionItem {
                title: "New Workout"
                onTriggered: {
                    if (!mainPage.tryAddWorkout())
                    	return;
                    	
                    var newPage = workoutPageDefn.createObject()
                    newPage.loadPage(-1)
                    navigationPane.push(newPage)
                }
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///images/gray/add_workout.png"
            },
            ActionItem {
                title: "Import Workout"
                onTriggered: {
                    if (!mainPage.tryAddWorkout())
                        return;
                    
                    openFilePicker.open()
                }
                ActionBar.placement: ActionBarPlacement.InOverflow
                imageSource: "asset:///images/gray/import.png"
                
                attachedObjects: [
                    SystemToast {
                        id: importFailed
                        body: "Import failed."
                        icon: "images/toast_error.png"
                    }
                ]
            }
        ]
        
        Container {
            layout: DockLayout {
            }
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            topPadding: 20.0
            rightPadding: 20.0
            leftPadding: 20.0
            bottomPadding: 20.0
            Label {
                id: noWorkoutsLabel
                text: "No Workouts"
                textStyle.base: SystemDefaults.TextStyles.BigText
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.color: Color.LightGray
            }
            Container {
                layout: StackLayout {
                }
                
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                topPadding: 20.0
                
                TextArea {
                    id: trialText
                    editable: false
                    visible: false
                    focusHighlightEnabled: false
                    text: "<p><strong>Metal Trainer Free</strong></p>" //<p>Tap here to buy the full version.</p>"
                    textFormat: TextFormat.Html
                    textStyle.textAlign: TextAlign.Center
                    textStyle.color: Color.Yellow
                    bottomPadding: 20.0
                    onTouch: {
                        mainPage.launchBBWorld()
                    }
                }
                
                ListView {
                    id: workoutsList
                    dataModel: ArrayDataModel {
                        id: workoutsDataModel
                    }
                    
                    function editWorkout(index) {
                        var intIndex = intervalManager.toInt(index)
                        var newPage = workoutPageDefn.createObject()
                        newPage.loadPage(intIndex)
                        navigationPane.push(newPage)
                    }
                    
                    function moveWorkoutDown(index) {
                        var intIndex = intervalManager.toInt(index)
                        
                        if (intervalManager.beginAccessWorkout(intIndex))
                            intervalManager.moveDownAndEndAccessWorkout()
                        
                        mainPage.loadWorkouts()
                    }
                    
                    function moveWorkoutUp(index) {
                        var intIndex = intervalManager.toInt(index)
                        
                        if (intervalManager.beginAccessWorkout(intIndex))
                            intervalManager.moveUpAndEndAccessWorkout()
                        
                        mainPage.loadWorkouts()
                    }
                    
                    function exportWorkout(index) {
                        var intIndex = intervalManager.toInt(index)
                        
                        saveFilePicker.workoutIndex = intIndex
                        
                        saveFilePicker.open()
                    }
                    
                    function deleteWorkout(index) {
                        var intIndex = intervalManager.toInt(index)
                        if (intervalManager.beginAccessWorkout(intIndex) == true)
                            intervalManager.deleteAndEndAccessWorkout()
                        
                        mainPage.loadWorkouts()
                    }
                    
                    function duplicateWorkout(index) {
                        if (!mainPage.tryAddWorkout())
                            return;
                            
                        var intIndex = intervalManager.toInt(index)
                        if (intervalManager.beginAccessWorkout(intIndex) == true)
                            intervalManager.duplicateAndEndAccessWorkout()
                        
                        mainPage.loadWorkouts()
                    }
                    
                    function launchWorkoutStarter(index) {
                        var intIndex = intervalManager.toInt(index)
                        
                        if (intervalManager.beginAccessWorkout(intIndex) == true) {
                            if (!intervalManager.beginAccessInterval(0)) {
                                // No intervals
                                workoutEmpty.show()
                                intervalManager.endAccessWorkout()
                                return
                            }
                            
                            intervalManager.endAccessWorkout()
                        }
                        
                        var newPage = workoutStarterPageDefn.createObject()
                        newPage.load(index)
                        navigationPane.push(newPage)
                    }
                    
                    onTriggered: {
                        var selection = indexPath
                        launchWorkoutStarter(intervalManager.toInt(selection))
                    }
                    
                    listItemComponents: [
                        ListItemComponent {
                            type: ""
                            Container {
                                id: workoutListItemComponent
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
                                                var selection = workoutListItemComponent.ListItem.view.selectionList()
                                                workoutListItemComponent.ListItem.view.editWorkout(selection)
                                            }
                                            imageSource: "images/ic_edit.png"
                                        }
                                        ActionItem {
                                            title: "Move up"
                                            onTriggered: {
                                                var selection = workoutListItemComponent.ListItem.view.selectionList()
                                                workoutListItemComponent.ListItem.view.moveWorkoutUp(selection)
                                            }
                                            imageSource: "asset:///images/gray/move_up.png"
                                        }
                                        ActionItem {
                                            title: "Move down"
                                            onTriggered: {
                                                var selection = workoutListItemComponent.ListItem.view.selectionList()
                                                workoutListItemComponent.ListItem.view.moveWorkoutDown(selection)
                                            }
                                            imageSource: "asset:///images/gray/move_down.png"
                                        }
                                        ActionItem {
                                            title: "Export Workout"
                                            onTriggered: {
                                                var selection = workoutListItemComponent.ListItem.view.selectionList()
                                                workoutListItemComponent.ListItem.view.exportWorkout(selection)
                                            }
                                            imageSource: "images/gray/export.png"
                                        }
                                        ActionItem {
                                            title: "Duplicate Workout"
                                            onTriggered: {
                                                var selection = workoutListItemComponent.ListItem.view.selectionList()
                                                workoutListItemComponent.ListItem.view.duplicateWorkout(selection)
                                            }
                                            imageSource: "images/gray/duplicate.png"
                                        }
                                        DeleteActionItem {
                                            title: "Delete"
                                            onTriggered: {
                                                var selection = workoutListItemComponent.ListItem.view.selectionList()
                                                workoutListItemComponent.ListItem.view.deleteWorkout(selection)
                                            }
                                        }
                                    }
                                ]
                            }
                        }
                    ]
                    
                    attachedObjects: [
                        SystemToast {
                            id: exportFailed
                            body: "Export failed."
                            icon: "images/toast_error.png"
                        }
                    ]
                }
            }
        }
        attachedObjects: [
            // Create ComponentDefinitions that represent the custom
            // components
            ComponentDefinition {
                id: workoutPageDefn
                source: "workout.qml"
            },
            ComponentDefinition {
                id: workoutStarterPageDefn
                source: "workoutStarter.qml"
            }
        ]
    }

    attachedObjects: [
        ComponentDefinition {
            id: settingsPageDefn
            source: "settings.qml"
        },
        ComponentDefinition {
            id: aboutPageDefn
            source: "about.qml"
        },
        ComponentDefinition {
            id: helpPageDefn
            source: "help.qml"
        },
        ComponentDefinition {
            id: themePageDefn
            source: "theme.qml"
        },
        FilePicker {
            id: openFilePicker
            type: FileType.Other
            title: "Select File"
            directories: [ "/accounts/1000/shared/misc" ]
            onFileSelected: {
                if (!intervalManager.loadWorkoutFromFile(selectedFiles))
                    importFailed.show()

                mainPage.loadWorkouts()
            }
        },
        FilePicker {
            id: saveFilePicker
            title: "Select File"
            mode: FilePickerMode.Saver
            type: FileType.Other
            viewMode: FilePickerViewMode.ListView
            directories: [ "/accounts/1000/shared/misc" ]
            onFileSelected: {
                if (!intervalManager.saveWorkoutToFile(selectedFiles, workoutIndex))
                    exportFailed.show()
            }

            property int workoutIndex
        },
        SystemDialog {
            id: trialDialog
            title: "Free Version"
            body: "The free version of Metal Trainer has a 2 workout limit. Purchase the full version?"
            onFinished: {
                if (trialDialog.result == SystemUiResult.ConfirmButtonSelection) {
                    mainPage.launchBBWorld()
                }
            }
        },
        SystemToast {
            id: workoutEmpty
            body: "Workout has no intervals."
            icon: "asset:///images/toast_error.png"
        },
        SystemToast {
            id: duringWorkout
            body: "Workout in progress."
            icon: "asset:///images/toast_error.png"
        }
    ]
}
