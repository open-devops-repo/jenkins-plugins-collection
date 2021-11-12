# syntax=docker/dockerfile:1
FROM ubuntu:latest
WORKDIR /root/
RUN echo "----- ubuntu:latest" >> /root/resultfile1
RUN date >> /root/resultfile1
RUN cat /etc/os-release >> /root/resultfile1
RUN ls -l /etc/ >> /root/resultfile1

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /root/resultfile1 /root/resultfile2
RUN echo "----- alpine:latest" >> /root/resultfile2
RUN date >> /root/resultfile2
RUN cat /etc/os-release >> /root/resultfile2
RUN ls -l /etc/ >> /root/resultfile2
CMD ["/bin/sh", "-c", "ls -l /root; cat /root/resultfile2"]
