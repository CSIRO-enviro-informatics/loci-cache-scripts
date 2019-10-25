FROM python:3

RUN apt-get update
RUN apt-get install -y git
RUN pip3 install awscli==1.16.218
RUN apt-get install -y wget
RUN apt-get install -y gettext-base

ENV APP_HOME='/usr/src/app'
WORKDIR ${APP_HOME}
COPY resources/ .

CMD ["/bin/bash", "-c", "${APP_HOME}/main.sh"]