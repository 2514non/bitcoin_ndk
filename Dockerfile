FROM debian:stretch@sha256:0a5fcee6f52d5170f557ee2447d7a10a5bdcf715dd7f0250be0b678c556a501b
COPY /stretch_deps.sh /
RUN /stretch_deps.sh
