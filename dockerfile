FROM python:latest

RUN apt-get update && \
    apt-get install -y bash fzf && \
    rm -rf /var/lib/apt/lists/*

# make sure bin dir exists
RUN mkdir -p /root/.local/bin

# copy script as if download via curl
COPY src/pytivate.sh /root/.local/bin/pytivate

# executable
RUN chmod +x /root/.local/bin/pytivate

# setup test dir
WORKDIR /test

# create venv
RUN python -m venv venv

# default command
CMD ["bash", "-l", "-c", "source /root/.local/bin/pytivate && echo 'success!'"]
#TODO
# pip install stuff, deactivate, reactivate and run a python script that imports a thing to prove the venv is setup
