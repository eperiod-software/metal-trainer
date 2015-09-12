/*
 * QMLIntervalManager.cpp
 *
 *  Created on: Jul 6, 2013
 *      Author: Vaughn Friesen
 */

#include "QMLIntervalManager.h"
#include "WorkoutThread.h"
#include "interval/IntervalManager.h"

#include <iostream>

QMLIntervalManager::QMLIntervalManager() {
	workoutAccess = -1;
	intervalAccess = -1;

	// Start up the interval manager
	IntervalManager::setup();
}

QMLIntervalManager::~QMLIntervalManager() {
	IntervalManager::shutdown();
}

bool QMLIntervalManager::saveToFile(QString filename) {
	IntervalManager *mgr = IntervalManager::getInstance();
	return IntervalManager::saveToFile(*mgr, filename.toUtf8().constData());
}

bool QMLIntervalManager::loadFromFile(QString filename) {
	IntervalManager *mgr = IntervalManager::getInstance();
	return IntervalManager::restoreFromFile(*mgr, filename.toUtf8().constData());
}

bool QMLIntervalManager::saveWorkoutToFile(QString filename, int index) {
	IntervalManager *mgr = IntervalManager::getInstance();
	if (index >= mgr->getNumWorkouts())
		return false;

	return Workout::saveToFile(mgr->getWorkout(index), filename.toUtf8().constData());
}

bool QMLIntervalManager::loadWorkoutFromFile(QString filename) {
	IntervalManager *mgr = IntervalManager::getInstance();

	Workout workout;
	bool success = Workout::restoreFromFile(workout, filename.toUtf8().constData());

	if (success)
		mgr->pushWorkout(workout);

	return success;
}

bool QMLIntervalManager::trialVersion() {
	return IntervalManager::getInstance()->trialVersion();
}

bool QMLIntervalManager::workoutsFull() {
	return IntervalManager::getInstance()->workoutsFull();
}

bool QMLIntervalManager::beginAccessWorkout(int index) {
	endAccessWorkout();

	// Make sure the workout exists
	IntervalManager *mgr = IntervalManager::getInstance();
	if (index >= mgr->getNumWorkouts() || index < 0)
		return false;

	workoutAccess = index;

	return true;
}

int QMLIntervalManager::addAndBeginAccessWorkout() {
	endAccessWorkout();

	Workout workout;
	IntervalManager *mgr = IntervalManager::getInstance();

	if (mgr->workoutsFull())
		return -1;

	mgr->pushWorkout(workout);
	workoutAccess = mgr->getNumWorkouts() - 1;

	return workoutAccess;
}

void QMLIntervalManager::moveUpAndEndAccessWorkout() {
	endAccessInterval();

	if (workoutAccess <= 0) // Can't move up
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	Workout workout = mgr->updWorkout(workoutAccess);
	mgr->deleteWorkout(workoutAccess);
	mgr->pushWorkout(workout, workoutAccess - 1);

	workoutAccess = -1;
}

void QMLIntervalManager::moveDownAndEndAccessWorkout() {
	endAccessInterval();
	IntervalManager *mgr = IntervalManager::getInstance();

	if (workoutAccess >= mgr->getNumWorkouts() - 1) // Can't move down
		return;

	Workout workout = mgr->getWorkout(workoutAccess);
	mgr->deleteWorkout(workoutAccess);
	mgr->pushWorkout(workout, workoutAccess + 1);

	workoutAccess = -1;
}

void QMLIntervalManager::endAccessWorkout() {
	endAccessInterval();
	workoutAccess = -1;
}

void QMLIntervalManager::deleteAndEndAccessWorkout() {
	endAccessInterval();

	if (workoutAccess < 0)
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->deleteWorkout(workoutAccess);

	workoutAccess = -1;
}

void QMLIntervalManager::duplicateAndEndAccessWorkout() {
	if (workoutAccess < 0)
		return;

	// Copy the workout and duplicate it at the end
	IntervalManager *mgr = IntervalManager::getInstance();
	Workout workout = mgr->getWorkout(workoutAccess);
	mgr->pushWorkout(workout);

	workoutAccess = -1;
}

bool QMLIntervalManager::beginAccessInterval(int index) {
	endAccessInterval();

	if (workoutAccess < 0)
		return false;

	// Make sure the interval exists
	IntervalManager *mgr = IntervalManager::getInstance();
	if (index >= mgr->getWorkout(workoutAccess).getNumIntervals() || index < 0)
		return false;

	intervalAccess = index;

	return true;
}

int QMLIntervalManager::addAndBeginAccessInterval() {
	endAccessInterval();

	if (workoutAccess < 0)
		return -1;

	Interval interval;
	IntervalManager *mgr = IntervalManager::getInstance();
	Workout &workout = mgr->updWorkout(workoutAccess);
	workout.pushInterval(interval);
	intervalAccess = workout.getNumIntervals() - 1;

	return intervalAccess;
}

void QMLIntervalManager::endAccessInterval() {
	intervalAccess = -1;
}

void QMLIntervalManager::moveUpAndEndAccessInterval() {
	if (intervalAccess <= 0 || workoutAccess < 0) // Can't move up
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	Workout &workout = mgr->updWorkout(workoutAccess);
	Interval interval = workout.getInterval(intervalAccess);
	workout.deleteInterval(intervalAccess);
	workout.pushInterval(interval, intervalAccess - 1);

	intervalAccess = -1;
}

void QMLIntervalManager::moveDownAndEndAccessInterval() {
	if (intervalAccess < 0 || workoutAccess < 0)
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	Workout &workout = mgr->updWorkout(workoutAccess);

	if (intervalAccess >= workout.getNumIntervals() - 1) // Can't move down
		return;

	Interval interval = workout.getInterval(intervalAccess);
	workout.deleteInterval(intervalAccess);
	workout.pushInterval(interval, intervalAccess + 1);

	intervalAccess = -1;
}

void QMLIntervalManager::deleteAndEndAccessInterval() {
	if (intervalAccess < 0 || workoutAccess < 0)
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->updWorkout(workoutAccess).deleteInterval(intervalAccess);

	intervalAccess = -1;
}

void QMLIntervalManager::setWorkoutName(QString name) {
	if (workoutAccess < 0)
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->updWorkout(workoutAccess).setName(name.toStdString());
}

QString QMLIntervalManager::getWorkoutName() {
	if (workoutAccess < 0)
		return "";

	IntervalManager *mgr = IntervalManager::getInstance();
	return QString::fromStdString(mgr->getWorkout(workoutAccess).getName());
}

void QMLIntervalManager::setIntervalName(QString name) {
	if (intervalAccess < 0 || workoutAccess < 0)
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->updWorkout(workoutAccess).updInterval(intervalAccess).setName(name.toStdString());
}

QString QMLIntervalManager::getIntervalName() {
	if (intervalAccess < 0 || workoutAccess < 0)
		return "";

	IntervalManager *mgr = IntervalManager::getInstance();
	return QString::fromStdString(mgr->getWorkout(workoutAccess).getInterval(intervalAccess).getName());
}

void QMLIntervalManager::setIntervalTime(int time) {
	if (intervalAccess < 0 || workoutAccess < 0)
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->updWorkout(workoutAccess).updInterval(intervalAccess).setTime((TimeMs)(time * 1000));
}

int QMLIntervalManager::getIntervalTime() {
	if (intervalAccess < 0 || workoutAccess < 0)
		return 0;

	IntervalManager *mgr = IntervalManager::getInstance();
	return mgr->getWorkout(workoutAccess).getInterval(intervalAccess).getTime() / 1000;
}

void QMLIntervalManager::setIntervalRest(bool rest) {
	if (intervalAccess < 0 || workoutAccess < 0)
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->updWorkout(workoutAccess).updInterval(intervalAccess).setRest(rest);
}

bool QMLIntervalManager::getIntervalRest() {
	if (intervalAccess < 0 || workoutAccess < 0)
		return false;

	IntervalManager *mgr = IntervalManager::getInstance();
	return mgr->getWorkout(workoutAccess).getInterval(intervalAccess).isRest();
}

void QMLIntervalManager::setIntervalReps(int reps) {
	if (intervalAccess < 0 || workoutAccess < 0)
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->updWorkout(workoutAccess).updInterval(intervalAccess).setReps(reps);
}

int QMLIntervalManager::getIntervalReps() {
	if (intervalAccess < 0 || workoutAccess < 0)
		return false;

	IntervalManager *mgr = IntervalManager::getInstance();
	return mgr->getWorkout(workoutAccess).getInterval(intervalAccess).getReps();
}

void QMLIntervalManager::setWorkoutRounds(int rounds) {
	if (workoutAccess < 0)
		return;

	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->updWorkout(workoutAccess).setRounds(rounds);
}

int QMLIntervalManager::getNumIntervals() {
	if (workoutAccess < 0)
		return 0;

	IntervalManager *mgr = IntervalManager::getInstance();
	return mgr->getWorkout(workoutAccess).getNumIntervals();
}

int QMLIntervalManager::getNumRounds() {
	if (workoutAccess < 0)
		return 0;

	IntervalManager *mgr = IntervalManager::getInstance();
	return mgr->getWorkout(workoutAccess).getRounds();
}

int QMLIntervalManager::getRoundTime() {
	if (workoutAccess < 0)
		return 0;

	IntervalManager *mgr = IntervalManager::getInstance();
	return mgr->getWorkout(workoutAccess).getRoundTime() / 1000;
}

int QMLIntervalManager::getRoundReps() {
	if (workoutAccess < 0)
		return 0;

	IntervalManager *mgr = IntervalManager::getInstance();
	return mgr->getWorkout(workoutAccess).getRoundReps();
}

bool QMLIntervalManager::launchWorkout(int index) {
	WorkoutThread::startThread(index);
	return true;
}

void QMLIntervalManager::killWorkout() {
	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->killWorkout();
}

void QMLIntervalManager::nextWorkout() {
	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->nextWorkout();
}

void QMLIntervalManager::pauseWorkout(bool paused) {
	IntervalManager *mgr = IntervalManager::getInstance();
	mgr->pauseWorkout(paused);
}
