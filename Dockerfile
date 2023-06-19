# Copyright (C) 2023  Dirk Stolle
#
# SPDX-License-Identifier: LGPL-3.0-or-later

FROM debian:12-slim
LABEL maintainer="Dirk Stolle <striezel-dev@web.de>"
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libavif-bin
RUN useradd --create-home avif
USER avif
WORKDIR /home/avif
# Test that executable is reachable via PATH variable.
RUN avifdec --version
CMD sleep 86400
