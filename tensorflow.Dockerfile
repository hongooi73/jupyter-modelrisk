FROM hongooi/jupytermodelrisk:1.0.0

RUN conda create -n tensorflow --clone base

# Make RUN commands use the new environment
RUN echo "conda activate tensorflow" >> ~/.bashrc

SHELL ["/bin/bash", "--login", "-c"]

RUN conda install -y 'tensorflow=2.4.3'
