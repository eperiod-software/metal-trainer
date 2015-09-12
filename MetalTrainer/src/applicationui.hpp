#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QObject>

#include "QMLIntervalManager.h"
#include "QMLIntervalPoller.h"
#include "QMLSettingsManager.h"

namespace bb
{
    namespace cascades
    {
        class Application;
        class LocaleHandler;
    }
}

class QTranslator;

/*!
 * @brief Application object
 *
 *
 */

class ApplicationUI : public QObject
{
    Q_OBJECT
public:
    ApplicationUI(bb::cascades::Application *app);
    virtual ~ApplicationUI();

    Q_INVOKABLE void launchBBWorld();
private slots:
    void onSystemLanguageChanged();
private:
    QTranslator* m_pTranslator;
    bb::cascades::LocaleHandler* m_pLocaleHandler;

    QMLIntervalManager *intervalManager;
    QMLIntervalPoller *intervalPoller;
    QMLSettingsManager *settingsManager;
};

#endif /* ApplicationUI_HPP_ */
