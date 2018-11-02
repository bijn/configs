FROM ubuntu

ENV CONFIGS_DIR /home/test/configs
ENV CONFIGS_INSTALLER /home/test/configs/misc/scripts/install.sh
ENV BATS /home/test/configs/modules/bats/bin/bats

WORKDIR /home/test
COPY . /home/test/configs
RUN apt-get dist-upgrade \
        && apt-get update \
        && apt-get upgrade -y \
        && apt-get install -y git curl \
        && useradd test \
        && chown -R test /home/test \
        && cd /home/test/configs/shell/config/tmp \
        && git clean -fdX

USER test

CMD /bin/bash -c "$(cat $CONFIGS_INSTALLER)"  -- -c configs && bash
CMD /bin/bash -c "$BATS --tap configs/tests/install.bats"
