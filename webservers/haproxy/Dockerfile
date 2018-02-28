FROM haproxy:1.8
RUN apt-get update && apt-get -y install curl
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY . /root
CMD ["/root/start.sh"]
