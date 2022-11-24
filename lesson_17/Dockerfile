
#
# Ubuntu Dockerfile


# Pull base image.
FROM ubuntu:20.04

# Install.
RUN \
  apt-get -y update && \
  apt-get -y upgrade && \
  apt-get install -y vim  && \
  apt-get install -y mc && \
  apt-get install -y nginx && \
  apt-get install -y curl


# Define default command.
CMD ["bash"]
