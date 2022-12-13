

# create a custom image for ubuntu:20.04


#Pull base image.
FROM ubuntu:20.04

# Install.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install vim mc nginx curl -y


# Define default command.
CMD ["bash"]
