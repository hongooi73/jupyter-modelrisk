# REF: docker-stacks/all-spark-notebook/
FROM jupyter/pyspark-notebook

LABEL maintainer="Hong Ooi <khay.ooi@westpac.com.au>"

USER root

# RSpark config
ENV R_LIBS_USER $SPARK_HOME/R/lib
RUN fix-permissions $R_LIBS_USER

# R and Teradata pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gdebi-core \
    openssh-client \
    sshfs \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc \
    dpkg \
    cifs-utils \
    vim \
    libcairo2-dev \
    unixodbc-dev  \
    lib32stdc++6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/*

RUN rm -rf /opt/conda/var/cache/*

USER $NB_UID

# R packages
# Install additional R packages here
RUN conda install --quiet --yes \
    'r-base=4.0.5' \
	r-essentials \
	'r-ggplot2=3.3*' \
    'r-irkernel=1.1*' \
    'r-rcurl=1.98*' \
    'r-sparklyr=1.6*' \
	jupyter_contrib_nbextensions \
	rpy2 \
	altair \
	vega \
	jira \
	tzlocal \
	saspy \
	sas_kernel \
	colorama \
	feather-format \
	pyarrow \
	pandas-profiling \
  	qgrid \
  	simplegeneric \
  	tqdm \
	pyodbc \
	python-docx && \
    conda clean -a -y

# End of all-spark-notebook

#RUN conda config --append channels conda-forge &&\
#    conda config --append channels r &&\
#    conda update --yes --all &&\
#	conda clean -a -y

#RUN conda install -y 'nodejs=10.*'
RUN conda install -c conda-forge -y nodejs && \
	conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
	
RUN jupyter labextension install --no-build @jupyterlab/toc && \
 jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager && \
 jupyter labextension install --no-build @jupyterlab/hub-extension && \
 jupyter lab build

RUN pip install jupyterlab_templates &&\
  jupyter labextension install jupyterlab_templates && \
  jupyter serverextension enable --py jupyterlab_templates

RUN pip install pytest

# More R packages
  RUN conda install \
    r-tidyverse \
    r-fs \
    r-reticulate \
    r-hmisc \
    r-rcpp \
    r-odbc \
    r-evaluate \
    r-data.table \
    r-expm \
    r-rlang \
    r-remotes \
    r-flextable \
    r-mlr \
    r-ranger \
    r-rcurl \
    r-feather \
    r-jsonlite \
    r-gbm \
    r-xgboost \
    r-randomforest 


#setup R configs
RUN echo ".libPaths('/opt/conda/lib/R/library')" >> ~/.Rprofile &&\
    echo "local({r <- getOption('repos'); r['CRAN'] <- 'https://mran.microsoft.com/snapshot/2021-04-30'; options(repos = r)})" >> /home/$NB_USER/.Rprofile
EXPOSE 8787

# Install additional R packages here
COPY install_packages.R /tmp/install_packages.R 
RUN R --no-save </tmp/install_packages.R 

RUN rm -rf /home/$NB_USER/.local
WORKDIR /home/$NB_USER

#RUN jupyter labextension install @ijmbarr/jupyterlab_spellchecker

# Enable Jupyter extensions here
RUN jupyter nbextension enable collapsible_headings/main && \
 jupyter nbextension enable snippets_menu/main && \
 jupyter nbextension enable toc2/main && \
 jupyter nbextension enable varInspector/main && \
 jupyter nbextension enable highlighter/highlighter && \
 jupyter nbextension enable hide_input/main && \
 jupyter nbextension enable python-markdown/main && \
 jupyter nbextension enable spellchecker/main && \
 jupyter nbextension enable hide_input_all/main && \
 jupyter nbextension enable execute_time/ExecuteTime && \
 jupyter nbextension enable export_embedded/main && \
 jupyter nbextension enable tree-filter/index

# extra packages for individual projects
RUN mamba install --quiet --yes \
    'tensorflow=2.4.1' && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN mamba install --yes r-rjava -c conda-forge && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN mamba install -y -c conda-forge imbalanced-learn && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN mamba install -y -c conda-forge \
    xgboost \
    shap \
    python-graphviz \
    fastparquet \
    pydotplus \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
