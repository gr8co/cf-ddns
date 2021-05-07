FROM debian:stable-slim as prod
COPY run.sh /usr/bin/run.sh
RUN apt-get -y update && apt-get install -y jq curl && chmod +x /usr/bin/run.sh &&\
    apt-get clean autoclean &&\
    apt-get autoremove --yes &&\
    rm -rf /var/lib/{apt,dpkg,cache,log}/
ENTRYPOINT ["/bin/bash"]
CMD ["-c", "/usr/bin/run.sh"]

FROM prod as dev
RUN apt-get install -y git