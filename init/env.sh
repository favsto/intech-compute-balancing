#!/usr/bin/env bash

# custom variables
echo SQL_USERNAME=$(curl -s "http://metadata/computeMetadata/v1/instance/attributes/sql-username" \
    -H "Metadata-Flavor: Google") >> config
echo SQL_PASSWORD=$(curl -s "http://metadata/computeMetadata/v1/instance/attributes/sql-password" \
    -H "Metadata-Flavor: Google") >> config
echo DESTINATION_BUCKET=$(curl -s "http://metadata/computeMetadata/v1/instance/attributes/destination-bucket" \
    -H "Metadata-Flavor: Google") >> config
echo SQL_CONNECTION_NAME=$(curl -s "http://metadata/computeMetadata/v1/instance/attributes/sql-connection-name" \
    -H "Metadata-Flavor: Google") >> config


# update env variables
echo export DESTINATION_BUCKET >> config
echo export SQL_USERNAME >> config
echo export SQL_PASSWORD >> config
echo export SQL_CONNECTION_NAME >> config