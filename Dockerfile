# 1st container: download plugins listed in plugins.txt (big jenkins container)
FROM jenkins/jenkins:2.332.3-lts-jdk11
WORKDIR /
RUN mkdir -p /tmp/transfer
COPY plugins.txt /tmp/transfer/plugins.txt
# OLD variant to download plugins:
#RUN sh -c "REF=/tmp/transfer /usr/local/bin/install-plugins.sh < /tmp/transfer/plugins.txt"
# NEW variant to download plugins:
RUN sh -c "java -jar /opt/jenkins-plugin-manager.jar --plugin-file /tmp/transfer/plugins.txt --plugin-download-directory /tmp/transfer/plugins --list"

# 2nd container: copy plugins into /plugins (tiny alpine container)
FROM alpine:latest  
WORKDIR /
COPY . /src/
COPY --from=0 /tmp/transfer/plugins /plugins/
RUN sh -c             "ls -l /plugins"
CMD ["/bin/sh", "-c", "ls -l /plugins"]

