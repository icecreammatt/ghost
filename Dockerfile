#
# Ghost Dockerfile
#
# https://github.com/dockerfile/ghost
#

# Pull base image.
FROM dockerfile/nodejs

# Install Ghost
RUN \
  cd /tmp && \
  git clone --recursive https://github.com/tryghost/ghost.git /ghost && \
  cd /ghost && \
  git checkout stable && \
  npm install --production && \
  sed 's/127.0.0.1/0.0.0.0/' /ghost/config.example.js > /ghost/config.js

# Define working directory.
WORKDIR /ghost

RUN npm install -g grunt-cli
RUN npm install
RUN sed -i s':bower update ghost-ui:bower update ghost-ui --allow-root:g' Gruntfile.js
RUN grunt prod

# Add files.
ADD start.bash /ghost-start

# Set environment variables.
ENV NODE_ENV production

# Define mountable directories.
VOLUME ["/data", "/ghost-override"]

# Define default command.
CMD ["bash", "/ghost-start"]

# Expose ports.
EXPOSE 2368
