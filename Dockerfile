FROM python:3.9.7-buster as setup

WORKDIR /

# Install cmake
RUN echo \
    && apt-get update \
    && apt-get --yes install cmake

# For OpenCV
RUN apt-get --yes install ffmpeg libsm6 libxext6

# Upgrade pip
RUN pip3 install --upgrade pip

ARG USER=nobody
RUN usermod -aG sudo $USER


FROM setup as libs

COPY . .

RUN pip install h5py
RUN pip install tensorflow==2.7.0 -f https://tf.kmtea.eu/whl/stable.html

RUN pip3 --no-cache-dir install -r requirements.txt
RUN python3 setup.py install

# FIXES: ImportError: cannot allocate memory in static TLS block
ENV LD_PRELOAD='/usr/local/lib/python3.9/site-packages/scikit_image.libs/libgomp-d22c30c5.so.1.0.0'

CMD ["/bin/bash"]
