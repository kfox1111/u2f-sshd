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

RUN \
  git clone https://github.com/open-policy-agent/contrib && \
  apt-get install -y libjansson-dev libcurl4-gnutls-dev file && \
  cd contrib/pam_opa/pam/ && \
  rm -f /usr/lib/x86_64-linux-gnu/libjansson.a && \
  sed -i 's/shared/shared -lpam/' Makefile && \
  make clean && \
  make && \
  ls -l pam_opa.so && \
  file pam_opa.so && \
  ldd pam_opa.so && \
  cp -a pam_opa.so /lib/x86_64-linux-gnu/security/pam_opa.so

ADD sshd_config /usr/local/etc/
ADD start.sh /start.sh
ADD sshd /etc/pam.d/sshd

ENV SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.so
entrypoint ["/usr/local/bin/ssh"]
