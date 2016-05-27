FROM bgruening/galaxy-stable
MAINTAINER Eric Rasche <esr@tamu.edu>

ENV GALAXY_CONFIG_BRAND=Apollo \
    GALAXY_LOGGING=full

WORKDIR /galaxy-central


RUN install-repository "--url https://toolshed.g2.bx.psu.edu/ -o iuc --name jbrowse --panel-section-name JBrowse"

ADD tool_conf.xml /etc/config/apollo_tool_conf.xml
ENV GALAXY_CONFIG_TOOL_CONFIG_FILE /galaxy-central/config/tool_conf.xml.sample,/galaxy-central/config/shed_tool_conf.xml,/etc/config/apollo_tool_conf.xml
# overwrite current welcome page
ADD welcome.html $GALAXY_CONFIG_DIR/web/welcome.html

# Mark folders as imported from the host.
VOLUME ["/export/", "/apollo-data/", "/var/lib/docker"]

ADD postinst.sh /bin/postinst
RUN postinst && \
    chmod 777 /apollo-data

RUN git clone https://github.com/TAMU-CPT/galaxy-apollo tools/apollo && \
    cd tools/apollo && \
    git checkout 2f6589780d3b8344884e18f4c90d7495bd1f26b9

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
