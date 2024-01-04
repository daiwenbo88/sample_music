#include "httputils.h"

HttpUtils::HttpUtils(QObject *parent)
    : QObject{parent}
{
    manager=new QNetworkAccessManager(this);
    connect(manager,&QNetworkAccessManager::finished,this,&HttpUtils::doFinished);
}

void HttpUtils::doFinished(QNetworkReply *reply)
{
    emit replySignal(reply->readAll());//读取请求返回数据
}

void HttpUtils::doConnet(QString url)
{
    QNetworkRequest request;
    request.setUrl(QUrl(BASE_URL+url));
    manager->get(request);

}
