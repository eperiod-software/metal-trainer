/*
 * QMLIntervalManager.h
 *
 *  Created on: Jul 6, 2013
 *      Author: Vaughn Friesen
 */

#ifndef QMLINTERVALMANAGER_H_
#define QMLINTERVALMANAGER_H_

#include <QObject>
#include <QString>

class QMLIntervalManager : public QObject {
	Q_OBJECT

public:
	QMLIntervalManager();
	virtual ~QMLIntervalManager();

	Q_INVOKABLE bool saveToFile(QString filename);
	Q_INVOKABLE bool loadFromFile(QString filename);

	Q_INVOKABLE bool saveWorkoutToFile(QString filename, int index);
	Q_INVOKABLE bool loadWorkoutFromFile(QString filename);

	Q_INVOKABLE bool trialVersion();
	Q_INVOKABLE bool workoutsFull();

	Q_INVOKABLE bool beginAccessWorkout(int index);
	Q_INVOKABLE int addAndBeginAccessWorkout();
	Q_INVOKABLE void endAccessWorkout();
	Q_INVOKABLE void moveUpAndEndAccessWorkout();
	Q_INVOKABLE void moveDownAndEndAccessWorkout();
	Q_INVOKABLE void deleteAndEndAccessWorkout();
	Q_INVOKABLE void duplicateAndEndAccessWorkout();

	Q_INVOKABLE bool beginAccessInterval(int index);
	Q_INVOKABLE int addAndBeginAccessInterval();
	Q_INVOKABLE void endAccessInterval();
	Q_INVOKABLE void moveUpAndEndAccessInterval();
	Q_INVOKABLE void moveDownAndEndAccessInterval();
	Q_INVOKABLE void deleteAndEndAccessInterval();

	Q_INVOKABLE void setWorkoutName(QString name);
	Q_INVOKABLE QString getWorkoutName();

	Q_INVOKABLE void setIntervalName(QString name);
	Q_INVOKABLE QString getIntervalName();

	Q_INVOKABLE void setIntervalTime(int time);
	Q_INVOKABLE int getIntervalTime();

	Q_INVOKABLE void setIntervalRest(bool rest);
	Q_INVOKABLE bool getIntervalRest();

	Q_INVOKABLE void setIntervalReps(int reps);
	Q_INVOKABLE int getIntervalReps();

	Q_INVOKABLE void setWorkoutRounds(int rounds);

	Q_INVOKABLE int getNumIntervals();

	Q_INVOKABLE int getNumRounds();

	Q_INVOKABLE int getRoundTime();
	Q_INVOKABLE int getRoundReps();

	Q_INVOKABLE bool launchWorkout(int index);

	Q_INVOKABLE void killWorkout();
	Q_INVOKABLE void nextWorkout();
	Q_INVOKABLE void pauseWorkout(bool paused);

	Q_INVOKABLE inline QString timeToString(int time) {
		int seconds = time % 60;
		int minutes = time / 60;
		QString zero = seconds < 10 ? ":0" : ":";

		return QString::number(minutes) + zero + QString::number(seconds);
	}

	Q_INVOKABLE inline QString timeMsToString(int time) {
		int ms = time % 1000 / 100; // Only the first part
		time /= 1000;

		return timeToString(time) + ":" + QString::number(ms);
	}

	// This is a ridiculous hack but I have no idea how to get around it.
	// Apparently QML can't cast a QVariantList to an int property but when
	// it passes the variable to a C++ function it can
	Q_INVOKABLE inline int toInt(int num) {
		return num;
	}

signals:
	void quitting();

protected:
	int workoutAccess, intervalAccess;
};

#endif /* QMLINTERVALMANAGER_H_ */
