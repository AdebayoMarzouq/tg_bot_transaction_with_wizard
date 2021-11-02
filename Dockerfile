FROM amd64/ubuntu:21.04
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
WORKDIR /app

ADD . /app

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates --assume-yes --no-install-recommends apt-utils
RUN apt-get update && apt-get install -y locales --assume-yes && rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-get update && apt-get install -y xvfb libssl-dev curl xauth --assume-yes --no-install-recommends apt-utils
RUN apt-get update && apt-get install -y build-essential --assume-yes --no-install-recommends apt-utils
RUN apt-get update && apt-get install --assume-yes --no-install-recommends apt-utils

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
RUN mkdir $NVM_DIR
ENV NODE_VERSION 15.2.0

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
	&& nvm install $NODE_VERSION \
	&& nvm alias default $NODE_VERSION \
	&& nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


# Install pm2
RUN npm config set unsafe-perm true && npm config set registry http://registry.npmjs.org/ && npm install pm2 -g

# Install project dependencies
RUN npm config set unsafe-perm true && npm config set registry http://registry.npmjs.org/ && npm install

CMD ["pm2-runtime", ".pm2-process.json"]
