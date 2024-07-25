FROM ghcr.io/kamalsaleh/gap-sympy-docker:latest

# Ensure the following commands run as the root user
USER root

# Install Python3 and venv
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y python3 python3-dev python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a virtual environment and install SymPy
RUN python3 -m venv /opt/venv \
    && . /opt/venv/bin/activate \
    && pip install --upgrade pip \
    && pip install sympy \
    && pip install matplotlib \
    && pip install setuptools \
    && pip install cython

# Set the virtual environment as the default Python environment
ENV VIRTUAL_ENV /opt/venv
ENV PATH /opt/venv/bin:$PATH

USER gap

RUN cd /home/gap/.gap/pkg/ \
    && git clone --depth 1 -vv https://github.com/gap-packages/AutoDoc.git \
    && git clone --depth 1 -vv https://github.com/homalg-project/homalg_project.git \
    && git clone --depth 1 -vv https://github.com/homalg-project/CAP_project.git \
    && git clone --depth 1 -vv https://github.com/homalg-project/CategoricalTowers.git \
    && git clone --depth 1 -vv https://github.com/homalg-project/MachineLearningForCAP.git \
    && cp ./MachineLearningForCAP/dev/ci_gaprc /home/gap/.gap/gaprc \
    && if [ -d "CAP_project/CAP" ]; then make -C "CAP_project/CAP" doc; fi \
    && if [ -d "CAP_project/MonoidalCategories" ]; then make -C "CAP_project/MonoidalCategories" doc; fi \
    && if [ -d "CAP_project/CartesianCategories" ]; then make -C "CAP_project/CartesianCategories" doc; fi \
    && if [ -d "MachineLearningForCAP" ]; then make -C "MachineLearningForCAP" doc; fi
