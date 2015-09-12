/*
 * QMLIntervalPoller.h
 *
 *  Created on: Jul 10, 2013
 *      Author: Vaughn Friesen
 */

#include <QObject>
#include <QString>

#include "interval/IntervalManager.h"

#ifndef QMLINTERVALPOLLER_H_
#define QMLINTERVALPOLLER_H_

class QMLIntervalPoller : public QObject {
	Q_OBJECT

public:
	QMLIntervalPoller();
	virtual ~QMLIntervalPoller();

	Q_INVOKABLE void init();
	Q_INVOKABLE void poll();

	Q_INVOKABLE void setWarningTimeSeconds(int seconds);

	Q_INVOKABLE bool isStarted();
	Q_INVOKABLE bool isFinished();
	Q_INVOKABLE bool isNewInterval();
	Q_INVOKABLE bool isNewRest();
	Q_INVOKABLE bool isNewWarning();

	Q_INVOKABLE QString getWorkoutName();
	Q_INVOKABLE int getRound();
	Q_INVOKABLE int getInterval();
	Q_INVOKABLE QString getIntervalName();
	Q_INVOKABLE QString getNextIntervalName();
	Q_INVOKABLE int getIntervalReps();
	Q_INVOKABLE int getIntervalRemainingTime();

protected:
	PollResults *lastResults;

	int warningTimeSeconds;
	bool started;
	bool finished;
	bool newInterval;
	bool newRest;
	bool newWarning;

	bool doneWarning;
};

#endif /* QMLINTERVALPOLLER_H_ */
