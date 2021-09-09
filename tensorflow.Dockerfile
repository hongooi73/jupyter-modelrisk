FROM hongooi/jupytermodelrisk:1.0.0

RUN conda create --name tensorflow --clone base

# Make RUN commands use the new environment
RUN echo "conda activate tensorflow" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

RUN mamba install -y 'tensorflow=2.4.3' && \
	conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

