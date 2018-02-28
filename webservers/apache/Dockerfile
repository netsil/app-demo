FROM httpd:2.4
RUN apt-get update && apt-get -y install curl
COPY . /root
CMD ["/root/start.sh"]
