FROM continuumio/miniconda3:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gcc build-essential
RUN conda install -c conda-forge -y pkg-config git cmake postgresql
RUN conda install -c tango-controls -y tango cpptango
RUN git clone --recurse-submodules https://github.com/tango-controls-hdbpp/hdbpp-timescale-project.git
RUN mkdir -p hdbpp-timescale-project/build
RUN cd hdbpp-timescale-project/build && cmake -DCMAKE_PREFIX_PATH=/opt/conda/lib -DPKG_CONFIG_EXECUTABLE=/opt/conda/bin/pkg-config .. && make project && make install
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/conda/lib:/hdbpp-timescale-project/build
RUN cd hdbpp-timescale-project/build && cp hdb++cm-srv /usr/bin/HdbConfigurationManager && cp hdb++es-srv /usr/bin/HdbEventSubscriber
