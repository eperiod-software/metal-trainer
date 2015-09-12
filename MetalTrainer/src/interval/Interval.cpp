#include "Interval.h"
#include "Serializer.h"

using namespace std;

#define DEFAULT_NAME "Untitled"
#define REST_NAME "Rest"

Interval::Interval() : time(0), reps(0) {
	Interval("", false);
}

Interval::Interval(string name, bool rest)
	: name(name), time(0), reps(0) {
	if (rest)
		setRest(true);
	if (name.length() == 0)
		name = DEFAULT_NAME;
}

Interval::Interval(const Interval &other)
	: name(other.name), time(other.time), reps(other.reps) { }

string Interval::getName() const {
	return name;
}

bool Interval::setName(string name) {
	if (name.length() > 0) {
		this->name = name;
		return true;
	}
	
	return false;
}

bool Interval::isRest() const {
	return (name == REST_NAME);
}

void Interval::setRest(bool rest) {
	if (rest)
		setName(REST_NAME);
	else {
		if (isRest())
			setName(DEFAULT_NAME);
	}
}

TimeMs Interval::getTime() const {
	if (reps > 0)
		return 0;

	return time;
}

bool Interval::setTime(TimeMs time) {
	this->time = time;
	return true;
}

int Interval::getReps() const {
	return reps;
}

void Interval::setReps(int reps) {
	if (reps >= 0)
		this->reps = reps;
}

bool Interval::serialize(ofstream &outfile, const unsigned int version) const {
	if (!Serializer::writeBool(outfile, isRest()))
		return false;
	if (!isRest()) {
		if (!Serializer::writeString(outfile, name))
			return false;
	}
	if (!Serializer::writeInt(outfile, time))
		return false;

	if (version >= 2) {
		if (!Serializer::writeInt(outfile, reps))
			return false;
	}
	
	return true;
}

bool Interval::serialize(ifstream &infile, const unsigned int version) {
	bool rest;
	if (!Serializer::readBool(infile, rest))
		return false;
	
	setRest(rest);
	
	if (!rest) {
		// Load the name
		if (!Serializer::readString(infile, name))
			return false;
	}
	
	int newTime;
	if (!Serializer::readInt(infile, newTime))
		return false;
	
	time = (TimeMs)newTime;
	
	if (version >= 2) {
		if (!Serializer::readInt(infile, reps))
			return false;
	}

	return true;
}
