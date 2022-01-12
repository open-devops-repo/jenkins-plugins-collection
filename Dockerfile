# 1st container: download plugins listed in plugins.txt (big jenkins container)
FROM jenkins/jenkins:2.319.1-jdk11
WORKDIR /
RUN mkdir -p /tmp/transfer
COPY plugins.txt /tmp/transfer/plugins.txt
RUN sh -c "REF=/tmp/transfer /usr/local/bin/install-plugins.sh < /tmp/transfer/plugins.txt"

# 2nd container: copy plugins into /plugins (tiny alpine container)
FROM alpine:latest  
WORKDIR /
COPY . /src/
COPY --from=0 /tmp/transfer/plugins /plugins/
CMD ["/bin/sh", "-c", "ls -l /plugins"]

