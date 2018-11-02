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
        && cd $CONFIGS_DIR/shell/config/tmp \
        && git clean -fdX \
        && rm -rf $CONFIGS_DIR/modules/bash-git-prompt/themes/my-theme.bgptheme

USER test

CMD /bin/bash -c "$(cat $CONFIGS_INSTALLER)"  -- -c $CONFIGS_DIR && bash
CMD /bin/bash -c "$BATS --tap configs/tests/install.bats"
# CMD /bin/bash -c "$(cat $CONFIGS_INSTALLER)"  -- -f $CONFIGS_DIR \
#         && cat ~/.config/tmp/install.manifest \
#         && /bin/bash -c "$(cat $CONFIGS_INSTALLER)"  -- -f $CONFIGS_DIR \
#         && cat ~/.config/tmp/install.manifest \
#         && ls -a ~/.config/tmp/\
# && ls -a $CONFIGS_DIR/modules/bash-git-prompt/themes \
#         && /bin/bash -c "$(cat $CONFIGS_INSTALLER)"  -- -u $CONFIGS_DIR \
# && ls -a $CONFIGS_DIR/modules/bash-git-prompt/themes \
#         && ls -a $CONFIGS_DIR/shell/config/tmp/backup
