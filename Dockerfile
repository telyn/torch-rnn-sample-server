FROM ubuntu:14.04
MAINTAINER Telyn

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Required packages
RUN apt-get update \
 && apt-get -y install \
    python \
    build-essential \
    python2.7-dev \
    python-pip \
    git \
    libhdf5-dev \
    software-properties-common \
 && git clone https://github.com/torch/distro.git /root/torch --recursive \
 && cd /root/torch \
 && bash install-deps \
 && ./install.sh -b

ENV LUA_PATH='/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/root/torch/install/share/lua/5.1/?.lua;/root/torch/install/share/lua/5.1/?/init.lua;./?.lua;/root/torch/install/share/luajit-2.1.0-beta1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua'
ENV LUA_CPATH='/root/.luarocks/lib/lua/5.1/?.so;/root/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so'
ENV PATH=/root/torch/install/bin:$PATH
ENV LD_LIBRARY_PATH=/root/torch/install/lib:$LD_LIBRARY_PATH
ENV DYLD_LIBRARY_PATH=/root/torch/install/lib:$DYLD_LIBRARY_PATH
ENV LUA_CPATH='/root/torch/install/lib/?.so;'$LUA_CPATH

RUN cd /root && git clone https://github.com/jcjohnson/torch-rnn \
 && pip install -r torch-rnn/requirements.txt

RUN luarocks install torch && \
    luarocks install nn && \
    luarocks install optim && \
    luarocks install lua-cjson

RUN git clone https://github.com/deepmind/torch-hdf5 /root/torch-hdf5 \
 && cd /root/torch-hdf5 \
 && luarocks make hdf5-0-0.rockspec
    
# at this point torch-rnn is installed
# now we just need luvit

RUN curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh \
 && chmod +x luvi luvit lit \
 && mv luvi luvit lit /usr/local/bin

#Done!
WORKDIR /root/torch-rnn