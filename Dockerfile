FROM ubuntu

RUN \
  apt-get update && \
  apt-get install -y git cmake make gcc autoconf automake libz-dev libcurl4-openssl-dev libssl-dev pkg-config libcbor-dev libudev-dev libpam0g-dev

RUN \
  git clone https://github.com/openssh/openssh-portable && \
  git clone https://github.com/Yubico/libfido2 && \
  adduser sshd --system --disabled-login && \
  cd /openssh-portable && \
  git rev-parse HEAD > /openssh.rev && \
  autoreconf && \
  ./configure --with-pam && \
  make && \
  make install && \
  cd /libfido2 && \
  git rev-parse HEAD > /libfido2.rev && \
  cmake . && \
  make && \
  make install && \
  rm -rf /openssh-portable /libfido2 && \
  mkdir -p /var/empty && \
  ldconfig

ADD sshd_config /usr/local/etc/
ADD start.sh /start.sh

ENV SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.so
CMD ["/start.sh"]
