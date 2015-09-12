/*
 * QMLActiveFrame.cpp
 *
 *  Created on: Jul 13, 2013
 *      Author: Vaughn Friesen
 */

#include "QMLActiveFrame.h"

#include <bb/cascades/SceneCover>
#include <bb/cascades/Container>
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>

using namespace bb::cascades;

QMLActiveFrame::QMLActiveFrame(QObject *parent) : SceneCover(parent) {
	QmlDocument *qml = QmlDocument::create("asset:///appCover.qml")
	            .parent(parent);
	Container *mainContainer = qml->createRootObject<Container>();
	setContent(mainContainer);

	intervalLabel = mainContainer->findChild<Label *>("IntervalLabel");
	intervalLabel->setParent(mainContainer);

	timeLabel = mainContainer->findChild<Label *>("TimeLabel");
	timeLabel->setParent(mainContainer);

	nextIntervalLabel = mainContainer->findChild<Label *>("NextIntervalLabel");
	nextIntervalLabel->setParent(mainContainer);
}

QMLActiveFrame::~QMLActiveFrame() {

}

void QMLActiveFrame::update(QString timeText, QString interval, QString nextInterval) {
	if (timeLabel)
		timeLabel->setText(timeText);
	if (intervalLabel)
		intervalLabel->setText(interval);
	if (nextIntervalLabel)
		nextIntervalLabel->setText(nextInterval);
}
