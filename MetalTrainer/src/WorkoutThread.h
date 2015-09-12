/*
 * WorkoutThread.h
 *
 *  Created on: Jul 9, 2013
 *      Author: Vaughn Friesen
 */

#include <QObject>

#ifndef WORKOUTTHREAD_H_
#define WORKOUTTHREAD_H_

class WorkoutThread : public QObject {
	Q_OBJECT

public:
	WorkoutThread(int workout);
	virtual ~WorkoutThread();

	static WorkoutThread *startThread(int workout);

public slots:
	void process();

signals:
	void workingChanged(bool working);
	void finished();

protected:
	int workout;
};

#endif /* WORKOUTTHREAD_H_ */
