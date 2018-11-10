FROM ubuntu

ENV CONFIGS_DIR /home/test/configs
ENV CONFIGS_BGPTHEMES $CONFIGS_DIR/modules/bash-git-prompt/themes
ENV BATS /home/test/configs/modules/bats/bin/bats

WORKDIR /home/test
COPY . /home/test/configs
RUN apt-get dist-upgrade \
        && apt-get update \
        && apt-get upgrade -y \
        && apt-get install -y git curl \
        && useradd test \
        && chown -R test /home/test \
        && cd $CONFIGS_DIR/shell/config/tmp \
        && git clean -fdX \
        && rm -rf $CONFIGS_BGPTHEMES/my-theme.bgptheme

USER test

CMD /bin/bash -c "$(curl -fsL https://git.io/fxKQ2)" -- -c $CONFIGS_DIR
CMD /bin/bash -c "$BATS --tap $CONFIGS_DIR/tests/install.bats"
