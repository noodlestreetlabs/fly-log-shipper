FROM timberio/vector:0.29.1-debian

COPY vector-configs /etc/vector/

# If using the google logs sink, copy your service account credentials
# file to a known location and set the GOOGLE_APPLICATION_CREDENTIALS
# environment variable to point to this file.
COPY gcp_logging_user_credentials.json /etc/google_creds/

COPY ./start-fly-log-transporter.sh .

CMD ["bash", "start-fly-log-transporter.sh"]

ENTRYPOINT []
