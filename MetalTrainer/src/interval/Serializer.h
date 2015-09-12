//
// Serializer reads and writes data types to disk
//

#ifndef _SERIALIZER_H_
#define _SERIALIZER_H_

#include <fstream>
#include <string>

#define INTERVALS_VERSION 2
#define SETTINGS_VERSION 6

#define COMPARE_HEADER(x, header) (x[0] == header[0] && x[1] == header[1] && x[2] == header[2] && x[3] == header[3])

class Serializer {
public:
	static bool writeBool(std::ofstream &outfile, bool write);
	static bool writeChar(std::ofstream &outfile, char write);
	static bool writeInt(std::ofstream &outfile, int write);
	static bool writeString(std::ofstream &outfile, std::string write);
	static bool writeCharArray(std::ofstream &outfile, const char *write, int len);
	
	static bool readBool(std::ifstream &infile, bool &ret);
	static bool readChar(std::ifstream &infile, char &ret);
	static bool readInt(std::ifstream &infile, int &ret);
	static bool readString(std::ifstream &infile, std::string &ret);
	static bool readCharArray(std::ifstream &infile, char *ret, int len);
};

#endif // _SERIALIZER_H_
