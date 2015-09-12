/*
 * WorkoutThread.cpp
 *
 *  Created on: Jul 9, 2013
 *      Author: Vaughn Friesen
 */

#include <QThread>
#include <iostream>

#include "WorkoutThread.h"
#include "interval/IntervalManager.h"

using namespace std;

WorkoutThread::WorkoutThread(int workout) {
	this->workout = workout;
}

WorkoutThread::~WorkoutThread() {
	// TODO Auto-generated destructor stub
}

WorkoutThread *WorkoutThread::startThread(int workout) {
	QThread *thread = new QThread();
	WorkoutThread *worker = new WorkoutThread(workout);
	worker->moveToThread(thread);
	connect(thread, SIGNAL(started()), worker, SLOT(process()));
	connect(worker, SIGNAL(finished()), thread, SLOT(quit()));
	connect(worker, SIGNAL(finished()), worker, SLOT(deleteLater()));
	connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
	thread->start();

	return worker;
}

void WorkoutThread::process() {
	IntervalManager *mgr = IntervalManager::getInstance();

	if (!mgr->launchWorkout(workout))
		cout << "Launching workout failed" << endl;

	cout << "Finishing launcher thread" << endl;

	emit finished();
}
