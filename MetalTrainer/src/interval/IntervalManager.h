//
// Interval manager keeps track of workouts
//

#ifndef _INTERVAL_MANAGER_H_
#define _INTERVAL_MANAGER_H_

#include <vector>
#include <string>
#include <fstream>

#include "Workout.h"
#include "PlatformSpecific.h"

struct PollResults {
	PollResults();
	PollResults(const PollResults &other);

	PollResults &operator=(const PollResults &other);

	static void printDiffs(const PollResults &older, const PollResults &newer);

	int numWorkoutsRun;
	bool working;
	int workoutIndex;
	std::string workoutName;
	int round;
	int intervalIndex;
	std::string intervalName;
	bool intervalRest;
	TimeMs intervalCurTime;
	TimeMs intervalRemainingTime;
	int intervalReps;
	std::string nextIntervalName;
};

class IntervalManager {
public:
	static void setup();
	static void shutdown();

	static IntervalManager *getInstance();

	bool trialVersion();
	bool workoutsFull();

	void pushWorkout(const Workout &workout, int index = -1);
	void deleteWorkout(int index);
	Workout &updWorkout(int index);
	const Workout &getWorkout(int index) const;
	int getNumWorkouts();

	bool launchWorkout(size_t index);
	bool launchWorkout(size_t index, TimeMs &totalTime);

	void killWorkout();
	void nextWorkout();
	void pauseWorkout(bool paused);

	PollResults pollResults();

	static bool saveToFile(const IntervalManager &mgr, const std::string filename);
	static bool restoreFromFile(IntervalManager &mgr, const std::string filename);

	bool serialize(std::ofstream &outfile, const unsigned int version) const;
	bool serialize(std::ifstream &infile, const unsigned int version);

protected:
	std::vector<Workout> workouts;
	PollResults results;
	Mutex resultsMutex;

	volatile bool cancelWorkout;
	volatile bool workoutPaused;
	volatile bool nextInterval;

private:
	IntervalManager();

	static IntervalManager *instance;
	static bool instCreated;
};

#endif // _INTERVAL_MANAGER_H_
