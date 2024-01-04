#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QQuickStyle>
#include "httputils.h"
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/icons/images/music.png"));

//    QString styleName = (platform == "android")
//                            ? "Material"
//                            : (platform == "windows")
//                                  ? "Universal"
//                                  : "Fusion";
    qmlRegisterType<HttpUtils>("MyUtils",1,0,"HttpUtils");//注册网络
    QQuickStyle::setStyle("Universal");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
