#include <vector>
#include <iostream>
#include <fstream>

#include "IntervalManager.h"
#include "PlatformSpecific.h"
#include "Serializer.h"
#include "Util.h"

// Need this because TimeMs (size_t) is unsigned so we can't check for < 0
#define POSITIVE_TIME(x) ((x) < 1073741824)

using namespace std;

IntervalManager *IntervalManager::instance = NULL;
bool IntervalManager::instCreated = false;

static const char *INTERVALS_HEADER = "MTIM";

void IntervalManager::setup() {
	// Create the instance
	instance = new IntervalManager();
	instCreated = true;
}

void IntervalManager::shutdown() {
	if (instCreated) {
		delete instance;
		instance = NULL;
		instCreated = false;
	}
}

IntervalManager *IntervalManager::getInstance() {
	if (!instCreated)
		setup();

	return instance;
}

bool IntervalManager::trialVersion() {
	return (bool)TRIAL_VERSION;
}

bool IntervalManager::workoutsFull() {
	return (MAX_WORKOUTS > 0 && workouts.size() == MAX_WORKOUTS);
}

void IntervalManager::pushWorkout(const Workout &workout, int index) {
	if (workoutsFull())
		return;

	if (index < 0)
		workouts.push_back(workout);
	else
		workouts.insert(workouts.begin() + index, workout);
}

void IntervalManager::deleteWorkout(int index) {
	workouts.erase(workouts.begin() + index);
}

Workout &IntervalManager::updWorkout(int index) {
	return workouts[index];
}

const Workout &IntervalManager::getWorkout(int index) const {
	return workouts[index];
}

int IntervalManager::getNumWorkouts() {
	return workouts.size();
}

bool IntervalManager::launchWorkout(size_t index) {
	TimeMs time;
	return launchWorkout(index, time);
}

bool IntervalManager::launchWorkout(size_t index, TimeMs &totalTime) {
	if (index >= workouts.size()) {
		resultsMutex.lock();
		results.numWorkoutsRun++;
		resultsMutex.unlock();
		return false;
	}

	cancelWorkout = false;
	workoutPaused = false;
	nextInterval = false;

	const Workout &workout = workouts[index];

	resultsMutex.lock();
	results.working = true;
	results.workoutIndex = index;
	results.workoutName = workout.getName();
	results.round = -1;
	results.intervalIndex = -1;
	results.intervalName = "";
	results.intervalRest = false;
	results.intervalReps = -1;
	results.intervalCurTime = 0;
	results.intervalRemainingTime = 0;
	resultsMutex.unlock();

	// Get start time
	Time beginWorkout = TimeManager::getTime();

	// Storage for times
	TimeMs workoutTime = 0;
	vector<TimeMs> roundTimes;

	TimeMs sleepTime, delta;
	const TimeMs pauseSleepTime = 200, repsSleepTime = 200;

	bool timedInterval = false;

	// Loop through rounds
	for (int x = 0; x < workout.getRounds(); x++) {
		Time beginRound = TimeManager::getTime();
		TimeMs target = 0, beginInterval;

		resultsMutex.lock();
		results.round = x;
		resultsMutex.unlock();

		// Loop through each interval
		for (int y = 0; y < workout.getNumIntervals(); y++) {
			sleepTime = 50, delta = sleepTime * 2;
			const Interval &interval = workout.getInterval(y);

			resultsMutex.lock();
			results.intervalIndex = y;
			results.intervalName = interval.getName();
			results.intervalRest = interval.isRest();
			results.intervalCurTime = 0;
			results.intervalReps = interval.getReps();

			timedInterval = (results.intervalReps <= 0);

			if (timedInterval)
				results.intervalRemainingTime = interval.getTime();
			else
				results.intervalRemainingTime = 0;

			if (y + 1 < workout.getNumIntervals())
				results.nextIntervalName = workout.getInterval(y + 1).getName();
			else {
				if (x == workout.getRounds() - 1)
					results.nextIntervalName = "Finished";
				else
					results.nextIntervalName = workout.getInterval(0).getName();
			}

			resultsMutex.unlock();

			beginInterval = target;
			target += interval.getTime();

			// Sleep 50 ms until the time is close (within 100 ms)
			TimeMs cur;
			while (1) {
				cur = TimeManager::timeElapsed(beginRound);

				if (workoutPaused) {
					// Get the start time
					Time beginPaused = TimeManager::getTime();

					// Pause
					while (workoutPaused) {
						TimeManager::sleep(pauseSleepTime);
						if (cancelWorkout) {
							TimeManager::destroyTime(beginPaused);
							break;
						}
					}

					// Add the elapsed time to the target
					TimeMs elapsedPaused = TimeManager::timeElapsed(beginPaused);
					target += elapsedPaused;

					TimeManager::destroyTime(beginPaused);
				}
				else if (!timedInterval) {
					// Get the start time
					Time beginReps = TimeManager::getTime();

					// Pause
					while (!nextInterval) {
						TimeManager::sleep(repsSleepTime);
						if (cancelWorkout) {
							TimeManager::destroyTime(beginReps);
							break;
						}
					}

					// Add the elapsed time to the target
					TimeMs elapsedReps = TimeManager::timeElapsed(beginReps);
					target += elapsedReps;

					TimeManager::destroyTime(beginReps);
				}

				if (nextInterval)
					break;

				if (cancelWorkout)
					break;

				if (timedInterval) {
					if (!POSITIVE_TIME(target - cur - delta))
						break;

					resultsMutex.lock();
					results.intervalCurTime = cur - beginInterval;
					if (!POSITIVE_TIME(results.intervalCurTime))
						results.intervalCurTime = 0;
					results.intervalRemainingTime = target - cur;
					resultsMutex.unlock();
				}
				TimeManager::sleep(sleepTime);
			}

			if (nextInterval) {
				nextInterval = false;
				continue;
			}

			if (cancelWorkout)
				break;

			// Now just sleep 10 ms until the right time
			if (timedInterval) {
				sleepTime = 10;
				delta = 10;
				while (POSITIVE_TIME(cur = target - TimeManager::timeElapsed(beginRound) - delta))
					TimeManager::sleep(sleepTime);
			}
			else {

			}
		}

		if (cancelWorkout) {
			TimeManager::destroyTime(beginRound);
			break;
		}

		roundTimes.push_back(TimeManager::timeElapsed(beginRound));
		TimeManager::destroyTime(beginRound);
	}

	workoutTime = TimeManager::timeElapsed(beginWorkout);
	TimeManager::destroyTime(beginWorkout);

	totalTime = workoutTime;

	cout << "Finished in " << (double)totalTime / 1000.0 << " sec" << endl;

	resultsMutex.lock();
	results.working = false;
	results.numWorkoutsRun++;
	resultsMutex.unlock();

	return true;
}

void IntervalManager::killWorkout() {
	cancelWorkout = true;
}

void IntervalManager::nextWorkout() {
	nextInterval = true;
}

void IntervalManager::pauseWorkout(bool paused) {
	workoutPaused = paused;
}

PollResults IntervalManager::pollResults() {
	resultsMutex.lock();
	PollResults copy(results);
	resultsMutex.unlock();

	return copy;
}

bool IntervalManager::saveToFile(const IntervalManager &mgr, const string filename) {
	ofstream ofs(filename.c_str(), ios_base::binary | ios_base::out);
	if (!ofs.is_open())
		return false;

	int version = INTERVALS_VERSION;

	// Write the header
	if (!Serializer::writeCharArray(ofs, INTERVALS_HEADER, 4)) {
		ofs.close();
		return false;
	}

	// Write the version
	if (!Serializer::writeInt(ofs, version)) {
		ofs.close();
		return false;
	}

	bool status = mgr.serialize(ofs, version);
	if (ofs.is_open())
		ofs.close();

	return status;
}

bool IntervalManager::restoreFromFile(IntervalManager &mgr, const string filename) {
	ifstream ifs(filename.c_str(), ios_base::binary | ios_base::in);
	if (!ifs.is_open())
		return false;

	int version = 1;

	// Try to read the header
	char headerBuf[4];
	if (!Serializer::readCharArray(ifs, headerBuf, 4) || !COMPARE_HEADER(headerBuf, INTERVALS_HEADER)) {
		// May be old style header - try again
		ifs.seekg(0, ifs.beg);
	}
	else {
		// Read the version
		if (!Serializer::readInt(ifs, version)) {
			ifs.close();
			return false;
		}
	}

	bool status = mgr.serialize(ifs, version);
	if (ifs.is_open())
		ifs.close();

	return status;
}

bool IntervalManager::serialize(ofstream &outfile, const unsigned int version) const {
	// Write the number of workouts and then each workout
	if (!Serializer::writeInt(outfile, workouts.size()))
		return false;

	for (size_t x = 0; x < workouts.size(); x++) {
		if (!workouts[x].serialize(outfile, version))
			return false;
	}

	return true;
}

bool IntervalManager::serialize(ifstream &infile, const unsigned int version) {
	// Read the number of workouts and then each workout
	int numWorkouts;
	if (!Serializer::readInt(infile, numWorkouts))
		return false;

	workouts.clear();

	for (int x = 0; x < numWorkouts; x++) {
		Workout workout;
		if (!workout.serialize(infile, version))
			return false;
		workouts.push_back(workout);
	}

	return true;
}

IntervalManager::IntervalManager() : cancelWorkout(false), workoutPaused(false) {

}

PollResults::PollResults()
	: numWorkoutsRun(0), working(false), workoutIndex(-1), round(-1),
	intervalIndex(-1), intervalRest(false), intervalCurTime(0), intervalRemainingTime(0),
	intervalReps(-1) {

}

PollResults::PollResults(const PollResults &other) {
	numWorkoutsRun = other.numWorkoutsRun;
	working = other.working;
	workoutIndex = other.workoutIndex;
	workoutName = other.workoutName;
	round = other.round;
	intervalIndex = other.intervalIndex;
	intervalName = other.intervalName;
	intervalRest = other.intervalRest;
	intervalCurTime = other.intervalCurTime;
	intervalRemainingTime = other.intervalRemainingTime;
	intervalReps = other.intervalReps;
	nextIntervalName = other.nextIntervalName;
}

PollResults &PollResults::operator=(const PollResults &other) {
	numWorkoutsRun = other.numWorkoutsRun;
	working = other.working;
	workoutIndex = other.workoutIndex;
	workoutName = other.workoutName;
	round = other.round;
	intervalIndex = other.intervalIndex;
	intervalName = other.intervalName;
	intervalRest = other.intervalRest;
	intervalCurTime = other.intervalCurTime;
	intervalRemainingTime = other.intervalRemainingTime;
	intervalReps = other.intervalReps;
	nextIntervalName = other.nextIntervalName;

	return *this;
}

void PollResults::printDiffs(const PollResults &older, const PollResults &newer) {
	if (newer.working && !older.working) {
		cout << "Beginning workout " << newer.workoutIndex + 1 << ": ";
		cout << newer.workoutName << endl;
	}
	else if (older.working && !newer.working)
		cout << "Finished workout" << endl;

	if (newer.round != older.round)
		cout << "Beginning round " << newer.round + 1 << endl;

	if (newer.intervalIndex != older.intervalIndex) {
		cout << "Beginning interval " << newer.intervalIndex + 1 << ": ";
		cout << newer.intervalName << endl;
	}

	/*if (newer.intervalCurTime != older.intervalCurTime) {
		cout << "Time: " << newer.intervalCurTime << " remaining: ";
		cout << newer.intervalRemainingTime << endl;
	}*/
}
