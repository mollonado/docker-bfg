FROM amazoncorretto:11.0.2@sha256:540e99c7ce892b86613c349c4c4d3f72c2413bdfe2b30d85ce2a4be25fd36fb2
LABEL maintainer "Koen Rouwhorst <info@koenrouwhorst.nl>"

# NOTE: https://rtyley.github.io/bfg-repo-cleaner/
ENV BFG_VERSION="1.13.0"
ENV BFG_CHECKSUM="bf22bab9dd42d4682b490d6bc366afdad6c3da99f97521032d3be8ba7526c8ce"

RUN yum upgrade -y && \
  yum install -y shadow-utils

ENV HOME /home/bfg
RUN useradd --create-home --home-dir $HOME bfg \
  && chown -R bfg:bfg $HOME

COPY ./entrypoint.sh /home/bfg/
RUN chmod +x /home/bfg/entrypoint.sh

WORKDIR /tmp

RUN curl "https://repo1.maven.org/maven2/com/madgag/bfg/$BFG_VERSION/bfg-$BFG_VERSION.jar" \
  -o "bfg-$BFG_VERSION.jar" \
  && echo "$BFG_CHECKSUM  bfg-$BFG_VERSION.jar" | sha256sum -c - \
  && mv "bfg-$BFG_VERSION.jar" /home/bfg/bfg.jar

WORKDIR "$HOME"
USER bfg

ENTRYPOINT ["/home/bfg/entrypoint.sh", "/home/bfg/bfg.jar"]