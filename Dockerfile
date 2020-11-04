FROM cimg/ruby:2.6.6-node

LABEL maintainer="Vincent Franco <vince@freshivore.net>"

RUN sudo apt-get update && sudo apt-get install libsasl2-dev imagemagick libmagickcore-dev libmagickwand-dev -y
