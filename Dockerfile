FROM cimg/base:2020.05

LABEL maintainer="Vincent Franco <vince@freshivore.net>"

ENV RUBY_VERSION=2.6.6 \
	RUBY_MAJOR=2.6

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
          autoconf \
          bison \
          dpkg-dev \
          libffi-dev \
          libgdbm5 \
          libgdbm-dev \
          #remove once on cimg/base:2020.06 or later
          libmariadb-dev \
          #remove once on cimg/base:2020.06 or later
          libmariadb-dev-compat \
          #remove once on cimg/base:2020.06 or later
          libpq-dev \
          libncurses5-dev \
          libreadline6-dev \
          libssl-dev \
          libyaml-dev \
          libsasl2-dev \ 
          imagemagick \
          libmagickcore-dev \
          libmagickwand-dev \
          #remove once on cimg/base:2020.06 or later
          tzdata \
          zlib1g-dev && \
  # Skip installing gem docs
  echo "gem: --no-document" > ~/.gemrc && \
  mkdir -p ~/ruby && \
  downloadURL="https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR}/ruby-$RUBY_VERSION.tar.gz" && \
  curl -sSL $downloadURL | tar -xz -C ~/ruby --strip-components=1 && \
  cd ~/ruby && \
  autoconf && \
  ./configure && \
  make -j "$(nproc)" && \
  sudo make install && \
  mkdir ~/.rubygems && \
  sudo rm -rf ~/ruby /var/lib/apt/lists/* && \
  cd && \

  ruby --version && \
  gem --version && \
  sudo gem update --system && \
  gem --version && \
  bundle --version

  ENV GEM_HOME /home/circleci/.rubygems
  ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH

# Dockerfile will pull the latest LTS release from cimg-node.
RUN curl -sSL "https://raw.githubusercontent.com/CircleCI-Public/cimg-node/master/ALIASES" -o nodeAliases.txt && \
  NODE_VERSION=$(grep "lts" ./nodeAliases.txt | cut -d "=" -f 2-) && \
  curl -L -o node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" && \
  sudo tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
  rm node.tar.xz nodeAliases.txt && \
  sudo ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENV YARN_VERSION 1.22.4
RUN curl -L -o yarn.tar.gz "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz" && \
  sudo tar -xzf yarn.tar.gz -C /opt/ && \
  rm yarn.tar.gz && \
  sudo ln -s /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn && \
  sudo ln -s /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg
