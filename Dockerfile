#FROM debian:stretch
FROM oxidized/oxidized:latest

RUN echo 'debconf debconf/frontend select teletype' | debconf-set-selections


RUN cd /tmp/ \
  && apt-get update -qqy \
  && apt-get dist-upgrade -yqq

RUN cd /tmp/ \
  && apt-get -y install \
     sudo ruby-dev libssl-dev pkg-config \
     cmake libssh2-1-dev libicu-dev zlib1g-dev g++ \
     git sudo libsqlite3-dev libsqlite3-0 nginx sqlite3

## 3
RUN cd /tmp/ \
  && useradd --shell /sbin/nologin -m oxidized \
## 4
#RUN cd /tmp/ \
  && cd /home/oxidized \
  && sudo -u oxidized -H git clone https://github.com/justinjahn/oxidized-manager.git 
## 5
#  && cp oxidized-manager/share/oxidized.service /etc/systemd/system/oxidized.service


## 6 

## 2
RUN cd /tmp/ \
  && gem cleanup \
#  && gem pristine rake 
#RUN cd /tmp/ \
  && gem update --system 
RUN cd /tmp/ \
  && bundle install --without development
#  && bundle update 

#RUN cd /tmp/ \
#  && gem pristine rake

RUN cd /tmp/ \
  && gem install bundler --no-document \
  && gem install oxidized oxidized-script oxidized-web sequel sqlite3 puma --no-document \
#  && gem install oxidized-script oxidized-web sequel sqlite3
## 8
#RUN cd /tmp/ \
#  && gem install bundler \
  && cd /home/oxidized/oxidized-manager \
  && sudo -u oxidized -H bundle install --without development
#  && bundle install --without development


RUN apt-get install -yqq --no-install-recommends \
        telnet nano

## 10-11
RUN mkdir -p /etc/service/oxidized-manager /etc/service/nginx
COPY "add/oxidized-manager-run.sh" /etc/service/oxidized-manager/run
COPY "add/nginx-run.sh" /etc/service/nginx/run
COPY "add/db_sqlite_add.sh" /

## 9 
RUN cd /tmp/ \
 && cp /home/oxidized/oxidized-manager/config/config.yml.dist /home/oxidized/oxidized-manager/config/config.yml
## 7
COPY "config" "/home/oxidized/.config/oxidized/config"



## 12 
#COPY "nginx.conf" /etc/nginx/sites-enabled/default
COPY "nginx.conf" /etc/nginx/sites-enabled/

RUN cd /tmp/ \
  && cp -R /home/oxidized/oxidized-manager /home/oxidized/oxidized-manager.orig \
  && chown -R oxidized /home/oxidized \
  && sed -i -e "s|exec setuser root oxidized|exec setuser oxidized oxidized|"           /etc/service/oxidized/run

#/etc/service/oxidized/run
#  && rm /root/.config/oxidized/config \
#  && ln -s /home/oxidized/.config/oxidized/config  /root/.config/oxidized/config

