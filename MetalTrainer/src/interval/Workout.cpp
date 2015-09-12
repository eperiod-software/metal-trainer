#include "Workout.h"
#include "Serializer.h"

using namespace std;

static const char *WORKOUT_HEADER = "MTWK";

Workout::Workout()
	: name(""), rounds(1) {

}

Workout::Workout(string name, int rounds)
	: name(name), rounds(rounds) {
	
}

Workout::Workout(const Workout &other)
	: name(other.name), rounds(other.rounds), intervals(other.intervals) {
	
}

string Workout::getName() const {
	return name;
}

bool Workout::setName(string name) {
	if (name.length() > 0) {
		this->name = name;
		return true;
	}
	
	return false;
}

int Workout::getRounds() const {
	return rounds;
}

bool Workout::setRounds(int rounds) {
	if (rounds > 0) {
		this->rounds = rounds;
		return true;
	}
	
	return false;
}

size_t Workout::getRoundTime() const {
	size_t roundTime = 0;
	for (vector<Interval>::const_iterator iter = intervals.begin(); iter != intervals.end(); iter++)
		roundTime += (*iter).getTime();
	
	return roundTime;
}

int Workout::getRoundReps() const {
	int reps = 0;
	for (vector<Interval>::const_iterator iter = intervals.begin(); iter != intervals.end(); iter++)
		reps += (*iter).getReps();

	return reps;
}

size_t Workout::getTotalTime() const {
	return getRoundTime() * rounds;
}

void Workout::pushInterval(const Interval &interval, int index) {
	if (index < 0)
		intervals.push_back(interval);
	else
		intervals.insert(intervals.begin() + index, interval);
}

void Workout::deleteInterval(int index) {
	intervals.erase(intervals.begin() + index);
}

Interval &Workout::updInterval(int index) {
	return intervals[index];
}

const Interval &Workout::getInterval(int index) const {
	return intervals[index];
}

int Workout::getNumIntervals() const {
	return intervals.size();
}

bool Workout::saveToFile(const Workout &workout, const string filename) {
	ofstream ofs(filename.c_str(), ios_base::binary | ios_base::out);
	if (!ofs.is_open())
		return false;

	int version = INTERVALS_VERSION;

	// Write the header
	if (!Serializer::writeCharArray(ofs, WORKOUT_HEADER, 4)) {
		ofs.close();
		return false;
	}

	// Write the version
	if (!Serializer::writeInt(ofs, version)) {
		ofs.close();
		return false;
	}

	bool status = workout.serialize(ofs, version);
	if (ofs.is_open())
		ofs.close();

	return status;
}

bool Workout::restoreFromFile(Workout &workout, const string filename) {
	ifstream ifs(filename.c_str(), ios_base::binary | ios_base::in);
	if (!ifs.is_open())
		return false;

	int version = 1;

	// Try to read the header
	char headerBuf[4];
	if (!Serializer::readCharArray(ifs, headerBuf, 4) || !COMPARE_HEADER(headerBuf, WORKOUT_HEADER)) {
		ifs.close();
		return false;
	}

	// Read the version
	if (!Serializer::readInt(ifs, version)) {
		ifs.close();
		return false;
	}

	bool status = workout.serialize(ifs, version);
	if (ifs.is_open())
		ifs.close();

	return status;
}

bool Workout::serialize(ofstream &outfile, const unsigned int version) const {
	if (!Serializer::writeString(outfile, name))
		return false;
	if (!Serializer::writeInt(outfile, rounds))
		return false;
	if (!Serializer::writeInt(outfile, intervals.size()))
		return false;
	
	for (size_t x = 0; x < intervals.size(); x++) { 
		if (!intervals[x].serialize(outfile, version))
			return false;
	}
	
	return true;
}

bool Workout::serialize(ifstream &infile, const unsigned int version) {
	if (!Serializer::readString(infile, name))
		return false;
	if (!Serializer::readInt(infile, rounds))
		return false;
	
	int numIntervals;
	if (!Serializer::readInt(infile, numIntervals))
		return false;
	
	intervals.clear();
	
	for (int x = 0; x < numIntervals; x++) {
		Interval interval;
		if (!interval.serialize(infile, version))
			return false;
		intervals.push_back(interval);
	}
	
	return true;
}
