#include "Serializer.h"

using namespace std;

#define ONE_SHIFT_ZERO 1
#define ONE_SHIFT_ONE 256
#define ONE_SHIFT_TWO 65536
#define ONE_SHIFT_THREE 16777216

bool Serializer::writeBool(ofstream &outfile, bool write) {
	return writeChar(outfile, (write ? 1 : 0));
}

bool Serializer::writeChar(ofstream &outfile, char write) {
	outfile.put(write);
	if (!outfile.good())
		return false;
	
	return true;
}

bool Serializer::writeInt(ofstream &outfile, int write) {
	char *buf = new char[4];
	bool negative = write < 0;

	buf[3] = (char)(write / ONE_SHIFT_ZERO);
	buf[2] = (char)(write / ONE_SHIFT_ONE);
	buf[1] = (char)(write / ONE_SHIFT_TWO);
	buf[0] = (char)(write / ONE_SHIFT_THREE);

	if (negative)
		buf[0] &= (char)0x80;
	
	outfile.write(buf, 4);
	if (!outfile.good())
		return false;
	
	return true;
}

bool Serializer::writeString(ofstream &outfile, string write) {
	// Write the length and then the string
	writeInt(outfile, write.length());
	
	const char *buf = write.c_str();
	for (size_t x = 0; x < write.length(); x++) {
		if (!writeChar(outfile, buf[x]))
			return false;
	}
	
	return true;
}

bool Serializer::writeCharArray(std::ofstream &outfile, const char *write, int len) {
	outfile.write(write, len);
	if (!outfile.good())
		return false;

	return true;
}

bool Serializer::readBool(ifstream &infile, bool &ret) {
	char c;
	if (!readChar(infile, c))
		return false;
	
	ret = (c == 0 ? false : true);
	
	return true;
}

bool Serializer::readChar(ifstream &infile, char &ret) {
	char buf;
	infile.read(&buf, 1);
	if (!infile.good())
		return false;

	ret = buf;

	return true;
}

bool Serializer::readInt(ifstream &infile, int &ret) {
	unsigned char buf[4];
	infile.read((char *)buf, 4);
	if (!infile.good())
		return false;

	// Integer is stored in big-endian format

	// See if it's positive or negative. If the first bit is 1 then it's negative
	bool neg = ((buf[0] >> 7) == 1);
	buf[0] = buf[0] & 0x7f;

	int newRet = 0;
	newRet += buf[3] * ONE_SHIFT_ZERO;
	newRet += buf[2] * ONE_SHIFT_ONE;
	newRet += buf[1] * ONE_SHIFT_TWO;
	newRet += buf[0] * ONE_SHIFT_THREE;

	if (neg)
		newRet = -newRet;

	ret = newRet;

	return true;
}

bool Serializer::readString(ifstream &infile, string &ret) {
	int len;
	if (!readInt(infile, len))
		return false;

	char *buf = new char[len + 1];
	infile.read(buf, len);
	if (!infile.good()) {
		delete []buf;
		return false;
	}

	// Strings aren't null terminated
	buf[len] = '\0';
	ret = buf;
	delete buf;

	return true;
}

bool Serializer::readCharArray(std::ifstream &infile, char *ret, int len) {
	char *buf = new char[len];
	infile.read(buf, len);
	if (!infile.good())
		return false;

	memcpy(ret, buf, len);

	delete buf;

	return true;
}
