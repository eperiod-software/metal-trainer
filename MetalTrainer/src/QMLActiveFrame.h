/*
 * QMLActiveFrame.h
 *
 *  Created on: Jul 13, 2013
 *      Author: Vaughn Friesen
 */

#include <QObject>
#include <bb/cascades/Label>
#include <bb/cascades/SceneCover>

#ifndef QMLACTIVEFRAME_H_
#define QMLACTIVEFRAME_H_

class QMLActiveFrame : public bb::cascades::SceneCover {
	Q_OBJECT

public:
	QMLActiveFrame(QObject *parent = NULL);
	virtual ~QMLActiveFrame();

public slots:
	Q_INVOKABLE void update(QString timeText, QString interval, QString nextInterval);

private:
	bb::cascades::Label *timeLabel;
	bb::cascades::Label *intervalLabel;
	bb::cascades::Label *nextIntervalLabel;
};

#endif /* QMLACTIVEFRAME_H_ */
