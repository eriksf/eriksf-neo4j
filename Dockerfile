FROM neo4j:2025.09.0-community-bullseye
LABEL maintainer="Erik Ferlanti <eferlanti@tacc.utexas.edu>"

# system updates
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    vim-tiny \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install apoc-core and graph-data-science from image
RUN cp /var/lib/neo4j/labs/apoc-* /var/lib/neo4j/plugins
RUN cp /var/lib/neo4j/products/neo4j-graph-data-science-* /var/lib/neo4j/plugins

# install apoc-extended from url
RUN wget -P /var/lib/neo4j/plugins https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/2025.09.0/apoc-2025.09.0-extended.jar

# edit neo4j.conf to enable unrestricted access to dbms for apoc.*, gds.*
RUN /bin/bash -c 'echo -e "\ndbms.security.procedures.unrestricted=apoc.*,gds.*" >> /var/lib/neo4j/conf/neo4j.conf'
