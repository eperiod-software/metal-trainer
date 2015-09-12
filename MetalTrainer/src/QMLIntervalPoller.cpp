/*
 * QMLIntervalPoller.cpp
 *
 *  Created on: Jul 10, 2013
 *      Author: Vaughn Friesen
 */

#include "QMLIntervalPoller.h"

QMLIntervalPoller::QMLIntervalPoller()
	: lastResults(NULL), warningTimeSeconds(5), started(false), finished(false),
	  newInterval(false), newRest(false), newWarning(false), doneWarning(false) {

}

QMLIntervalPoller::~QMLIntervalPoller() {
	if (lastResults)
		delete lastResults;
}

void QMLIntervalPoller::init() {
	started = finished = newInterval = newRest = newWarning = doneWarning = false;

	if (lastResults) {
		delete lastResults;
		lastResults = NULL;
	}
}

void QMLIntervalPoller::poll() {
	IntervalManager *mgr = IntervalManager::getInstance();
	PollResults newResults = mgr->pollResults();

	// First run
	if (!lastResults)
		lastResults = new PollResults(newResults);

	// TODO get the diffs
	if (newResults.working)
		started = true;
	else if (lastResults->working)
		finished = true;

	// See if we need a warning
	if (started && !finished) {
		newWarning = (newResults.intervalRemainingTime < (unsigned int)warningTimeSeconds * 1000 &&
			!doneWarning && (newResults.intervalReps <= 0));

		if (newWarning && newResults.intervalCurTime < 3000) {
			newWarning = false;
			doneWarning = true;
		}

		if (newWarning)
			doneWarning = true;

		bool newThing = (newResults.intervalIndex != lastResults->intervalIndex ||
				newResults.round != lastResults->round);

		newInterval = newThing && !newResults.intervalRest;
		newRest = newThing && newResults.intervalRest;

		if (newInterval || newRest)
			doneWarning = false;
	}

	*lastResults = newResults;
}

void QMLIntervalPoller::setWarningTimeSeconds(int seconds) {
	warningTimeSeconds = seconds;
}

bool QMLIntervalPoller::isStarted() {
	return started;
}

bool QMLIntervalPoller::isFinished() {
	return finished;
}

bool QMLIntervalPoller::isNewInterval() {
	return newInterval;
}

bool QMLIntervalPoller::isNewRest() {
	return newRest;
}

bool QMLIntervalPoller::isNewWarning() {
	return newWarning;
}

QString QMLIntervalPoller::getWorkoutName() {
	return QString::fromStdString(lastResults->workoutName);
}

int QMLIntervalPoller::getRound() {
	return lastResults->round + 1;
}

int QMLIntervalPoller::getInterval() {
	return lastResults->intervalIndex + 1;
}

QString QMLIntervalPoller::getIntervalName() {
	return QString::fromStdString(lastResults->intervalName);
}

QString QMLIntervalPoller::getNextIntervalName() {
	return QString::fromStdString(lastResults->nextIntervalName);
}

int QMLIntervalPoller::getIntervalReps() {
	return lastResults->intervalReps;
}

int QMLIntervalPoller::getIntervalRemainingTime() {
	return lastResults->intervalRemainingTime;
}
