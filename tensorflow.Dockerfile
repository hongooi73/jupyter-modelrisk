FROM hongooi/jupytermodelrisk:1.0.1

RUN mamba create -n tensorflow

RUN mamba install -n tensorflow -y \
    'tensorflow=2.4.3' \
    keras \
    imbalanced-learn \
    matplotlib \
    nb_conda_kernels \
    ipykernel

