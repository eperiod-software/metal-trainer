#include "applicationui.hpp"

#include <bb/cascades/AbstractPane>
#include <bb/cascades/Application>
#include <bb/cascades/Color>
#include <bb/cascades/LocaleHandler>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/ThemeSupport>
#include <bb/cascades/VisualStyle>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <iostream>

using namespace bb::cascades;
using namespace bb::system;

ApplicationUI::ApplicationUI(bb::cascades::Application *app) :
        QObject(app)
{
    // prepare the localization
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);
    if(!QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this, SLOT(onSystemLanguageChanged()))) {
        // This is an abnormal situation! Something went wrong!
        // Add own code to recover here
        qWarning() << "Recovering from a failed connect()";
    }
    // initial load
    onSystemLanguageChanged();

    // Set the colouring
    Application::instance()->themeSupport()->setPrimaryColor(QVariant::fromValue<Color>(Color::Red), QVariant::fromValue<Color>(Color::DarkRed));

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    // Create the interval manager that will go between QML and the IntervalManager class
    intervalManager = new QMLIntervalManager();
    qml->setContextProperty("intervalManager", intervalManager);

    intervalPoller = new QMLIntervalPoller();
	qml->setContextProperty("intervalPoller", intervalPoller);

    settingsManager = new QMLSettingsManager();
	qml->setContextProperty("settingsManager", settingsManager);

	qml->setContextProperty("app", this);

    qmlRegisterType<QTimer>("bb.cascades", 1, 0, "QTimer");

    QObject::connect(QCoreApplication::instance(), SIGNAL(aboutToQuit()), intervalManager, SIGNAL(quitting()));

    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    app->setScene(root);
}

ApplicationUI::~ApplicationUI() {
	delete intervalManager;
	delete intervalPoller;
	delete settingsManager;
}

void ApplicationUI::launchBBWorld() {
	InvokeManager invokeManager;
	InvokeRequest request;
	request.setTarget("sys.appworld");
	request.setAction("bb.action.OPEN");
	request.setUri(QUrl("appworld://content/32950887"));
	invokeManager.invoke(request);
}

void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("MetalTrainer_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}
