import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents
import "plasmapackage:code/lib.js" as Lib

Item {
	property int minimumWidth:200
	property int minimumHeight:200
	
	PlasmaComponents.PageStack {
		id: pageStack
		anchors.fill: parent
		initialPage: [ resultPage, formPage ]
	}
	
	PlasmaComponents.Page {
		id: formPage
		anchors.fill: parent
		
		PlasmaComponents.Label {
			id: summaryLabel
			text: "Summary: "
		
			anchors{
				left: parent.left
				top: parent.top
			}
		}
		
		PlasmaComponents.TextField {
			id: summaryTextField
		
			anchors{
				left: summaryLabel.right
				verticalCenter: summaryLabel.verticalCenter
				right: parent.right
			}
		}
		
		PlasmaComponents.Label {
			id: descriptionLabel
			text: "Description:"
		
			anchors{
				left: parent.left
				right: parent.right
				top: summaryTextField.bottom
			}
		}
		
		PlasmaComponents.TextArea {
			id: descriptionTextArea
		
			anchors{
				left: parent.left
				right: parent.right
				top: descriptionLabel.bottom
				bottom: addToCalendarButton.top
			}
		}
		
		PlasmaComponents.Button {
			id: addToCalendarButton
			text: "Add to Calendar"
		
			anchors{
				left: parent.left
				right: parent.right
				bottom: parent.bottom
			}
			
			onClicked:{
				resultPage.result = Lib.addToCalendar(summaryTextField.text,descriptionTextArea.text);
				pageStack.pop();
			}
		}
	}
	
	PlasmaComponents.Page {
		id: resultPage
		
		// the result of adding events to calendar.
		// it is a bool value, where true stands for
		// success and false stands for failed
		property bool result: false
			
		Column {
			spacing: 5
			anchors.centerIn: parent
			
			QtExtraComponents.QIconItem {
				icon: resultPage.result?"dialog-ok":"dialog-error"
				anchors.horizontalCenter: parent.horizontalCenter
				width: 80
				height: 80
			}
			
			PlasmaComponents.Label {
				anchors.horizontalCenter: parent.horizontalCenter
				text: resultPage.result?"Success":"Failed"
			}
			
			PlasmaComponents.Button {
				visible: !resultPage.result
				anchors.horizontalCenter: parent.horizontalCenter
				text: "Cancel"
				
				onClicked:
					pageStack.push([addingPage,formPage]);
			}
		}
		
		// If the result is success, the result
		// page will close automatically after
		// some time.  On the contrary, if the
		// result is failed, users have to close
		// the result page by clicking the Cancel
		// button
		Timer {
			id: resultPageAutoCloseTimer
			running: false
			repeat: false
			interval: 1000
			triggeredOnStart: false
			onTriggered: {
				running = false;
				pageStack.push([formPage]);
			}
		}
		
		onStatusChanged: {
			if(result && status == PlasmaComponents.PageStatus.Active)
				resultPageAutoCloseTimer.running = true;
		}
	}
}