FROM registry.access.redhat.com/ubi7/ubi:7.7-140

MAINTAINER ggianini@redhat.com

COPY ["/assets/app.py","/assets/python-app.conf", "./"]

ENTRYPOINT ["/usr/sbin/httpd"]

CMD ["-D", "FOREGROUND"]

RUN yum -y install httpd mod_wsgi --nogpgcheck && \
    mkdir -p /var/www/python && \
    mv /python-app.conf /etc/httpd/conf.d/ && \
    mv /app.py /var/www/python && \
    chown -R apache:apache /var/www/python && \
    sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf && \
    sed -i 's/#ServerName www.example.com:80/Servername localhost/g' /etc/httpd/conf/httpd.conf && \
    chmod -R 777 /run/httpd/ /etc/httpd/logs/ /var/log/http || :

EXPOSE 1234:8080

USER 12345
