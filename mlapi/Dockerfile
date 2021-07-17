ARG mlbase_version
FROM slayerus/mlbase:${mlbase_version}

ARG version
ARG DEBIAN_FRONTEND="noninteractive"

ENV \
    MLAPI_VERSION="${version}" \
    MLAPI_DIR="/mlapi"

RUN \
    apt-get update && \
    # Install dependenceis
    apt-get install -y --no-install-recommends \
      libev-dev \
      libevdev2 \
      build-essential \
      git \
      python${PYTHON_VERSION}-dev \
    && \
    # Install mlapi https://github.com/pliablepixels/mlapi
    git clone --depth 1 -b "${MLAPI_VERSION}" \
      "https://github.com/pliablepixels/mlapi" ${MLAPI_DIR} && \
    python3 -m pip install --no-cache-dir -r ${MLAPI_DIR}/requirements.txt --upgrade && \
    # Cleanup
    apt-get remove -y \
      build-essential \
      git \
      python${PYTHON_VERSION}-dev \
    && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache && \
    truncate -s 0 /var/log/*log

WORKDIR ${MLAPI_DIR}

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends gettext-base wget && \
    # Download models
    ./get_models.sh && \
    # Cleanup
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache && \
    truncate -s 0 /var/log/*log

COPY ./secrets.ini ${MLAPI_DIR}/secrets.ini.in
COPY mlapiconfig.ini ${MLAPI_DIR}/mlapiconfig.ini.in

# RUN mkdir /etc/zm && \
#     ln -s ${MLAPI_DIR}/secrets.ini /etc/zm/secrets.ini

# RUN ls -l /mlapi && \
#     cat /mlapi/mlapiconfig.ini && \
#     ls -l /etc/zm

COPY ./init_user.py ${MLAPI_DIR}/
COPY ./entrypoint.sh /entrypoint.sh

#VOLUME [ "${MLAPI_DIR}/images", "${MLAPI_DIR}/known_faces", "${MLAPI_DIR}/unknown_faces", "${MLAPI_DIR}/db" ]
EXPOSE 5000
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python3", "./mlapi.py", "-c", "./mlapiconfig.ini" ]