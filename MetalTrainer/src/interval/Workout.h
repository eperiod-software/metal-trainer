//
// A workout has several intervals, some may be rests. It also has a number of rounds.
//

#ifndef _WORKOUT_H_
#define _WORKOUT_H_

#include <string>
#include <vector>

#include "Interval.h"

class Workout {
public:
	Workout();
	Workout(std::string name, int rounds = 1);
	Workout(const Workout &other);
	
	std::string getName() const;
	bool setName(std::string name);
	
	int getRounds() const;
	bool setRounds(int rounds);
	
	size_t getRoundTime() const;
	int getRoundReps() const;
	size_t getTotalTime() const;
	
	void pushInterval(const Interval &interval, int index = -1);
	void deleteInterval(int index);
	Interval &updInterval(int index);
	const Interval &getInterval(int index) const;
	int getNumIntervals() const;
	
	static bool saveToFile(const Workout &workout, const std::string filename);
	static bool restoreFromFile(Workout &workout, const std::string filename);

	bool serialize(std::ofstream &infile, const unsigned int version) const;
	bool serialize(std::ifstream &infile, const unsigned int version);
	
protected:
	std::string name;
	int rounds;
	std::vector<Interval> intervals;
};

#endif // _WORKOUT_H_
