/*
 * QMLSettingsManager.cpp
 *
 *  Created on: Jul 12, 2013
 *      Author: Vaughn Friesen
 */

#include <fstream>
#include <string>
#include <bb/cascades/Application>
#include <bb/cascades/Window>
#include <bb/cascades/ScreenIdleMode>
#include <bb/cascades/Theme>
#include <bb/cascades/ThemeSupport>
#include <bb/cascades/VisualStyle>

#include "QMLSettingsManager.h"
#include "interval/Serializer.h"

using namespace std;
using namespace bb::cascades;

static const char *SETTINGS_HEADER = "MTSM";
#define SOUND_EXT ".mp3"

QMLSettingsManager::QMLSettingsManager()
	: keepScreenOn(true), useLightTheme(false), warningTime(0), defaultIntervalTime(0), defaultIntervalReps(0), workoutDelay(0) {
}

QMLSettingsManager::~QMLSettingsManager() {
}

bool QMLSettingsManager::loadSettings(QString filename) {
	// Defaults
	keepScreenOn = true;
	useLightTheme = false;
	startSound = "";
	finishSound = "alarm1";
	intervalSound = "bell1";
	restSound = "bell2";
	warningSound = "alarm2";
	warningTime = 5;
	defaultIntervalTime = 30;
	defaultIntervalReps = 10;
	workoutDelay = 15;

	ifstream ifs(filename.toUtf8().constData(), ios_base::binary | ios_base::in);
	if (!ifs.is_open())
		return false;

	string header;

	// Old header was a string, new header is a char array
	char headerBuf[4];
	if (!Serializer::readCharArray(ifs, headerBuf, 4) || !COMPARE_HEADER(headerBuf, SETTINGS_HEADER)) {
		// May be old style header - try again
		ifs.seekg(0, ifs.beg);

		// Read and check the header
		if (!Serializer::readString(ifs, header) || header != SETTINGS_HEADER) {
			ifs.close();
			return false;
		}
	}

	// Read the version
	int version;
	if (!Serializer::readInt(ifs, version)) {
		ifs.close();
		return false;
	}

	// Read the sound files
	if (version >= 2) {
		if (!Serializer::readString(ifs, startSound)) {
			ifs.close();
			return false;
		}
		if (!Serializer::readString(ifs, finishSound)) {
			ifs.close();
			return false;
		}
	}

	if (!Serializer::readString(ifs, intervalSound)) {
		ifs.close();
		return false;
	}
	if (!Serializer::readString(ifs, restSound)) {
		ifs.close();
		return false;
	}

	if (version >= 4) {
		if (!Serializer::readString(ifs, warningSound)) {
			ifs.close();
			return false;
		}

		// Read the warning sound time
		if (!Serializer::readInt(ifs, warningTime)) {
			ifs.close();
			return false;
		}
	}

	// Read whether to keep the screen on
	if (version >= 3) {
		if (!Serializer::readBool(ifs, keepScreenOn)) {
			ifs.close();
			return false;
		}
	}

	// Read the default interval time
	if (version >= 5) {
		if (!Serializer::readInt(ifs, defaultIntervalTime)) {
			ifs.close();
			return false;
		}
	}

	// Read the default interval reps
	if (version >= 6) {
		if (!Serializer::readInt(ifs, defaultIntervalReps)) {
			ifs.close();
			return false;
		}
	}

	// Read a value indicating whether the light theme should be used
	if (version >= 7) {
		if (!Serializer::readBool(ifs, useLightTheme)) {
			ifs.close();
			return false;
		}

		// Make sure we set the proper theme
		setUseLightTheme(useLightTheme);
	}

	// Read the workout delay
	if (!Serializer::readInt(ifs, workoutDelay)) {
		ifs.close();
		return false;
	}

	ifs.close();

	return true;
}

bool QMLSettingsManager::saveSettings(QString filename) {
	ofstream ofs(filename.toUtf8().constData(), ios_base::binary | ios_base::out);
	if (!ofs.is_open())
		return false;

	// Write the header
	if (!Serializer::writeCharArray(ofs, SETTINGS_HEADER, 4)) {
		ofs.close();
		return false;
	}

	// Write the version
	int version = SETTINGS_VERSION;
	if (!Serializer::writeInt(ofs, version)) {
		ofs.close();
		return false;
	}

	// Write the two sound files
	if (version >= 2) {
		if (!Serializer::writeString(ofs, startSound)) {
			ofs.close();
			return false;
		}
		if (!Serializer::writeString(ofs, finishSound)) {
			ofs.close();
			return false;
		}
	}

	if (!Serializer::writeString(ofs, intervalSound)) {
		ofs.close();
		return false;
	}
	if (!Serializer::writeString(ofs, restSound)) {
		ofs.close();
		return false;
	}

	if (version >= 4) {
		if (!Serializer::writeString(ofs, warningSound)) {
			ofs.close();
			return false;
		}

		// Write the warning sound time
		if (!Serializer::writeInt(ofs, warningTime)) {
			ofs.close();
			return false;
		}
	}

	// Write whether to keep the screen on
	if (version >= 3) {
		if (!Serializer::writeBool(ofs, keepScreenOn)) {
			ofs.close();
			return false;
		}
	}

	// Write the default interval time
	if (version >= 5) {
		if (!Serializer::writeInt(ofs, defaultIntervalTime)) {
			ofs.close();
			return false;
		}
	}

	// Write the default interval reps
	if (version >= 6) {
		if (!Serializer::writeInt(ofs, defaultIntervalReps)) {
			ofs.close();
			return false;
		}
	}

	// Write a value indicating whether the light theme should be used
	if (version >= 7) {
		if (!Serializer::writeBool(ofs, useLightTheme)) {
			ofs.close();
			return false;
		}
	}

	// Write the workout delay
	if (!Serializer::writeInt(ofs, workoutDelay)) {
		ofs.close();
		return false;
	}

	ofs.close();

	return true;
}

bool QMLSettingsManager::getKeepScreenOn() {
	return keepScreenOn;
}

void QMLSettingsManager::setKeepScreenOn(bool screenOn) {
	bool changed = (keepScreenOn != screenOn);
	keepScreenOn = screenOn;
	if (changed)
		emit keepScreenOnChanged(screenOn);
}

bool QMLSettingsManager::getUseLightTheme() {
	return useLightTheme;
}

void QMLSettingsManager::setUseLightTheme(bool lightTheme) {
	bool changed = (useLightTheme != lightTheme);
	useLightTheme = lightTheme;

	VisualStyle::Type style = (lightTheme ? VisualStyle::Bright : VisualStyle::Dark);
	Application::instance()->themeSupport()->setVisualStyle(style);

	if (changed)
		emit useLightThemeChanged(lightTheme);
}

QString QMLSettingsManager::getStartSound() {
	return QString::fromStdString(startSound);
}

void QMLSettingsManager::setStartSound(QString sound) {
	bool changed = (startSound != string(sound.toUtf8().constData()));
	startSound = sound.toUtf8().constData();
	if (changed)
		emit startSoundChanged(sound);
}

QString QMLSettingsManager::getFinishSound() {
	return QString::fromStdString(finishSound);
}

void QMLSettingsManager::setFinishSound(QString sound) {
	bool changed = (finishSound != string(sound.toUtf8().constData()));
	finishSound = sound.toUtf8().constData();
	if (changed)
		emit finishSoundChanged(sound);
}

QString QMLSettingsManager::getIntervalSound() {
	return QString::fromStdString(intervalSound);
}

void QMLSettingsManager::setIntervalSound(QString sound) {
	bool changed = (intervalSound != string(sound.toUtf8().constData()));
	intervalSound = sound.toUtf8().constData();
	if (changed)
		emit intervalSoundChanged(sound);
}

QString QMLSettingsManager::getRestSound() {
	return QString::fromStdString(restSound);
}

void QMLSettingsManager::setRestSound(QString sound) {
	bool changed = (restSound != string(sound.toUtf8().constData()));
	restSound = sound.toUtf8().constData();
	if (changed)
		emit restSoundChanged(sound);
}

QString QMLSettingsManager::getWarningSound() {
	return QString::fromStdString(warningSound);
}

void QMLSettingsManager::setWarningSound(QString sound) {
	bool changed = (warningSound != string(sound.toUtf8().constData()));
	warningSound = sound.toUtf8().constData();
	if (changed)
		emit warningSoundChanged(sound);
}

int QMLSettingsManager::getWarningTime() {
	return warningTime;
}

void QMLSettingsManager::setWarningTime(int time) {
	bool changed = warningTime != time;
	warningTime = time;
	if (changed)
		emit warningTimeChanged(time);
}

int QMLSettingsManager::getDefaultIntervalTime() {
	return defaultIntervalTime;
}

void QMLSettingsManager::setDefaultIntervalTime(int time) {
	bool changed = defaultIntervalTime != time;
	defaultIntervalTime = time;
	if (changed)
		emit defaultIntervalTimeChanged(time);
}

int QMLSettingsManager::getDefaultIntervalReps() {
	return defaultIntervalReps;
}

void QMLSettingsManager::setDefaultIntervalReps(int reps) {
	bool changed = defaultIntervalReps != reps;
	defaultIntervalReps = reps;
	if (changed)
		emit defaultIntervalRepsChanged(reps);
}

int QMLSettingsManager::getWorkoutDelay() {
	return workoutDelay;
}

void QMLSettingsManager::setWorkoutDelay(int delay) {
	workoutDelay = delay;
}

QString QMLSettingsManager::getSoundExt() {
	return SOUND_EXT;
}

void QMLSettingsManager::setDeviceScreenOn(bool screenOn) {
	ScreenIdleMode::Type mode = (screenOn ? ScreenIdleMode::KeepAwake : ScreenIdleMode::Normal);
	Application::instance()->mainWindow()->setScreenIdleMode(mode);
}

