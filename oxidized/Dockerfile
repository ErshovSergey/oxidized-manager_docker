FROM debian:stretch
#FROM oxidized/oxidized:latest

RUN echo 'debconf debconf/frontend select teletype' | debconf-set-selections


RUN cd /tmp/ \
  && apt-get update -qqy \
  && apt-get dist-upgrade -yq 

RUN cd /tmp/ \
  && apt-get -qqy install ruby ruby-dev libsqlite3-dev libssl-dev pkg-config cmake libssh2-1-dev libicu-dev zlib1g-dev g++ \
  && apt-get -qqy install sudo git sqlite3 curl nginx

RUN cd /tmp/ \
  && gem install  --no-ri --no-rdoc --no-document oxidized oxidized-script oxidized-web sequel sqlite3


## 3
RUN cd /tmp/ \
  && useradd --shell /sbin/nologin -m oxidized \
## 4 Clone the oxidized-manager repository
  && cd /home/oxidized \
  && sudo -u oxidized -H git clone https://github.com/justinjahn/oxidized-manager.git 

RUN cd /tmp/ \
  && gem install bundler --no-document 

RUN cd /tmp/ \
  && cd /home/oxidized/oxidized-manager \
  && chown -R oxidized /home/oxidized/oxidized-manager \
  && sudo -u oxidized -H  bundle install --path vendor/bundle \
  && bundle install --without development \
  && bundle update

RUN apt-get install -yqq --no-install-recommends \
        telnet nano

COPY oxidized.init.d /etc/init.d/oxidized
COPY auto-reload-config.runit /etc/init.d/
# файлы по умолчанию
RUN mkdir -p /home/oxidized/.config/oxidized.default/
COPY config router.db.sql /home/oxidized/.config/oxidized.default/
COPY oxidized.nginx /etc/nginx/sites-enabled/default

#CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
CMD exec /bin/bash -c "/etc/init.d/oxidized start"




#RUN apt-get install -yqq --no-install-recommends \
#  sqlite3 libpq-dev libmariadbclient-dev-compat

#apt-get -y install \
#     sudo ruby-dev libssl-dev pkg-config \
#     cmake libssh2-1-dev libicu-dev zlib1g-dev g++ \
#     git sudo libsqlite3-dev libsqlite3-0 nginx sqlite3

## 5
#  && cp oxidized-manager/share/oxidized.service /etc/systemd/system/oxidized.service


## 6 

## 2
#RUN cd /tmp/ \
#  && gem cleanup \
#  && gem pristine rake 
#RUN cd /tmp/ \
#  && gem update --system 
#RUN cd /tmp/ \
#  && bundle install --without development
#  && bundle update 

#RUN cd /tmp/ \
#  && gem pristine rake

#RUN cd /tmp/ \
#  && gem install oxidized oxidized-script oxidized-web sequel sqlite3 puma --no-document \
#  && gem install oxidized-script oxidized-web sequel sqlite3
## 8
#RUN cd /tmp/ \
#  && gem install bundler \
#  && cd /home/oxidized/oxidized-manager \
#  && apt-get -qqy install sudo \
#  && sudo -u oxidized -H bundle install --without development
#  && bundle install --without development



## 10-11
#RUN mkdir -p /etc/service/oxidized-manager /etc/service/nginx
## пока не запускаем менеджер, отладим oxodized
#COPY "add/oxidized-manager-run.sh" /etc/service/oxidized-manager/run
#COPY "add/nginx-run.sh" /etc/service/nginx/run
#COPY "add/db_sqlite_add.sh" /

## 9 
#RUN cd /tmp/ \
# && cp /home/oxidized/oxidized-manager/config/config.yml.dist /home/oxidized/oxidized-manager/config/config.yml
## 7
#COPY "config" "/home/oxidized/.config/oxidized/config"



## 12 
#COPY "nginx.conf" /etc/nginx/sites-enabled/default
#COPY "nginx.conf" /etc/nginx/sites-enabled/

#RUN cd /tmp/ \
#  && cp -R /home/oxidized/oxidized-manager /home/oxidized/oxidized-manager.orig \
#  && chown -R oxidized /home/oxidized \
#  && sed -i -e "s|exec setuser root oxidized|exec setuser oxidized oxidized|"           /etc/service/oxidized/run

#/etc/service/oxidized/run
#  && rm /root/.config/oxidized/config \
#  && ln -s /home/oxidized/.config/oxidized/config  /root/.config/oxidized/config

