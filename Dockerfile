FROM alpine:3.8 as build1

RUN apk --no-cache add gcc
RUN apk --no-cache add g++
RUN apk --no-cache add libc-dev
RUN apk --no-cache add zlib-dev
RUN apk --no-cache add openssl-dev
RUN apk --no-cache add git
RUN apk --no-cache add autoconf automake make

RUN cd /usr/lib && ln -s libboost_thread-mt.so libboost_thread.so

WORKDIR /
RUN git clone https://github.com/yshurik/notbit.git
WORKDIR /notbit
RUN git checkout smtp
RUN ./autogen.sh --prefix=/ # || cat config.log

WORKDIR /
COPY notbit-alpine.patch /1.patch
RUN patch -p0 < 1.patch

WORKDIR /notbit
RUN make
RUN make install

RUN notbit -h || echo ok
RUN ldd /bin/notbit

FROM alpine:3.8 as notbit1

RUN apk --no-cache add zlib
RUN apk --no-cache add openssl

COPY --from=build1 /bin/notbit /bin/notbit
COPY --from=build1 /bin/notbit-keygen /bin/notbit-keygen
COPY --from=build1 /bin/notbit-sendmail /bin/notbit-sendmail
RUN ldd /bin/notbit

COPY entrypoint.sh /entrypoint.sh

RUN mkdir /data
RUN mkdir /data/notbit
RUN mkdir /data/maildir

EXPOSE 8444 2525 143

RUN apk --no-cache add dovecot
COPY dovecot.conf /etc/dovecot/dovecot.conf
RUN adduser -D bm
RUN echo bm:bm | chpasswd 
RUN cd /home/bm && ln -s /data/maildir
RUN chown -R -c bm:bm /data
RUN ls -al /data
VOLUME ["/data"]
RUN ls -al /data
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]

