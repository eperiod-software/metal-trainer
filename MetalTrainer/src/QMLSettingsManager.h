/*
 * QMLSettingsManager.h
 *
 *  Created on: Jul 12, 2013
 *      Author: Vaughn Friesen
 */

#include <QObject>
#include <string>

#ifndef QMLSETTINGSMANAGER_H_
#define QMLSETTINGSMANAGER_H_

class QMLSettingsManager : public QObject {
	Q_OBJECT
	Q_PROPERTY(bool keepScreenOn READ getKeepScreenOn WRITE setKeepScreenOn NOTIFY keepScreenOnChanged)
	Q_PROPERTY(bool useLightTheme READ getUseLightTheme WRITE setUseLightTheme NOTIFY useLightThemeChanged)
	Q_PROPERTY(QString startSound READ getStartSound WRITE setStartSound NOTIFY startSoundChanged)
	Q_PROPERTY(QString finishSound READ getFinishSound WRITE setFinishSound NOTIFY finishSoundChanged)
	Q_PROPERTY(QString intervalSound READ getIntervalSound WRITE setIntervalSound NOTIFY intervalSoundChanged)
	Q_PROPERTY(QString restSound READ getRestSound WRITE setRestSound NOTIFY restSoundChanged)
	Q_PROPERTY(QString warningSound READ getWarningSound WRITE setWarningSound NOTIFY warningSoundChanged)
	Q_PROPERTY(int warningTime READ getWarningTime WRITE setWarningTime NOTIFY warningTimeChanged)
	Q_PROPERTY(int defaultIntervalTime READ getDefaultIntervalTime WRITE setDefaultIntervalTime NOTIFY defaultIntervalTimeChanged)
	Q_PROPERTY(int defaultIntervalReps READ getDefaultIntervalReps WRITE setDefaultIntervalReps NOTIFY defaultIntervalRepsChanged)
	Q_PROPERTY(int workoutDelay READ getWorkoutDelay WRITE setWorkoutDelay)
	Q_PROPERTY(QString soundExt READ getSoundExt)

public:
	QMLSettingsManager();
	virtual ~QMLSettingsManager();

	Q_INVOKABLE bool loadSettings(QString filename);
	Q_INVOKABLE bool saveSettings(QString filename);

	bool getKeepScreenOn();
	void setKeepScreenOn(bool screenOn);

	bool getUseLightTheme();
	void setUseLightTheme(bool screenOn);

	QString getStartSound();
	void setStartSound(QString sound);

	QString getFinishSound();
	void setFinishSound(QString sound);

	QString getIntervalSound();
	void setIntervalSound(QString sound);

	QString getRestSound();
	void setRestSound(QString sound);

	QString getWarningSound();
	void setWarningSound(QString sound);

	int getWarningTime();
	void setWarningTime(int time);

	int getDefaultIntervalTime();
	void setDefaultIntervalTime(int time);

	int getDefaultIntervalReps();
	void setDefaultIntervalReps(int reps);

	int getWorkoutDelay();
	void setWorkoutDelay(int delay);

	QString getSoundExt();

	Q_INVOKABLE void setDeviceScreenOn(bool screenOn);

signals:
	void keepScreenOnChanged(bool screenOn);
	void useLightThemeChanged(bool lightTheme);
	void startSoundChanged(QString sound);
	void finishSoundChanged(QString sound);
	void intervalSoundChanged(QString sound);
	void restSoundChanged(QString sound);
	void warningSoundChanged(QString sound);
	void warningTimeChanged(int time);
	void defaultIntervalTimeChanged(int time);
	void defaultIntervalRepsChanged(int reps);

private:
	bool keepScreenOn;
	bool useLightTheme;
	std::string startSound;
	std::string finishSound;
	std::string intervalSound;
	std::string restSound;
	std::string warningSound;
	int warningTime;
	int defaultIntervalTime;
	int defaultIntervalReps;
	int workoutDelay;
};

#endif /* QMLSETTINGSMANAGER_H_ */
