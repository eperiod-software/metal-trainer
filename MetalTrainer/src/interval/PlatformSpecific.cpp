#include <QThread>
#include <QMutex>
#include <unistd.h>

#include "PlatformSpecific.h"

class Sleeper : public QThread {
public:
	static void sleepMs(TimeMs amount) {
		QThread::msleep(amount);
	}
};

void TimeManager::sleep(TimeMs amount) {
	Sleeper::sleepMs(amount);
}

Mutex::Mutex() {
	QMutex *mutex = new QMutex();
	data = (void *)mutex;
}

Mutex::~Mutex() {
	QMutex *mutex = (QMutex *)data;
	delete mutex;
}

void Mutex::lock() {
	QMutex *mutex = (QMutex *)data;
	mutex->lock();
}

void Mutex::unlock() {
	QMutex *mutex = (QMutex *)data;
	mutex->unlock();
}
