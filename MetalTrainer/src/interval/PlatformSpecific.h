//
// Time manager takes care of platform-specific time functions
//

#ifndef _PLATFORM_SPECIFIC_H_
#define _PLATFORM_SPECIFIC_H_

#include <stdlib.h>
#include <sys/time.h>

typedef void *Time;
typedef size_t TimeMs;

class TimeManager {
public:
	inline static Time getTime() {
		timeval *time = new timeval();
		gettimeofday(time, NULL);
		return time;
	}

	inline static TimeMs timeElapsed(Time beginTime) {
		Time cur = getTime();
		TimeMs ret = timeDiff(beginTime, cur);
		destroyTime(cur);
		return ret;
	}

	inline static TimeMs timeDiff(Time time1, Time time2) {
		timeval *first = (timeval *)time1;
		timeval *second = (timeval *)time2;
		
		TimeMs result = (second->tv_sec - first->tv_sec) * 1000.0;
		result += (second->tv_usec - first->tv_usec) / 1000.0;
		
		return result;
	}

	inline static void destroyTime(Time time) {
		delete (timeval *)time;
	}
	
	static void sleep(TimeMs amount);
};

class Mutex {
public:
	Mutex();
	~Mutex();
	
	void lock();
	void unlock();
	
private:
	void *data;
};

#endif // _PLATFORM_SPECIFIC_H_
