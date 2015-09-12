//
// An interval has a description and a time
//

#ifndef _INTERVAL_H_
#define _INTERVAL_H_

#include <string>

#include "PlatformSpecific.h"

class Interval {
public:
	Interval();
	Interval(std::string name, bool rest = false);
	Interval(const Interval &other);
	
	std::string getName() const;
	bool setName(std::string name);
	
	bool isRest() const;
	void setRest(bool rest);
	
	TimeMs getTime() const;
	bool setTime(TimeMs time);
	
	int getReps() const;
	void setReps(int reps);

	bool serialize(std::ofstream &outfile, const unsigned int version) const;
	bool serialize(std::ifstream &infile, const unsigned int version);
	
protected:
	std::string name;
	TimeMs time;
	int reps;
};

#endif // _INTERVAL_H_
