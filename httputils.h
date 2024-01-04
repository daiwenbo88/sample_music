#ifndef HTTPUTILS_H
#define HTTPUTILS_H
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>

class HttpUtils : public QObject
{
    Q_OBJECT
public:
    explicit HttpUtils(QObject *parent = nullptr);
    //Q_INVOKABLE 方便qml调用
    Q_INVOKABLE void doFinished(QNetworkReply *reply);
    Q_INVOKABLE void doConnet(QString url);

signals:
    void replySignal(QString reply);
private:
    QNetworkAccessManager *manager;
    QString BASE_URL="http://localhost:3000/";
};

#endif // HTTPUTILS_H
