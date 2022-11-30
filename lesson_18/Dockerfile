# create a directory to work in
mkdir example
cd example

# create an example file
touch somefile.txt

FROM ubuntu:20.04
COPY somefile.txt ./
RUN  apt-get update 
RUN apt-get install  -y curl nginix vim mc 
CMD  bash
