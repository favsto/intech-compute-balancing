CLOUD_SQL_SA=$(gcloud sql instances describe intech17 | grep serviceAccount | awk '{ print $2; }')
echo "the SQL service account is: $CLOUD_SQL_SA"
gsutil acl ch -u $CLOUD_SQL_SA:W gs://intech
gsutil acl ch -u $CLOUD_SQL_SA:R gs://intech/schema_dump_v2.gz
gcloud sql instances import intech17 gs://intech/schema_dump_v2.gz --quiet
gsutil acl ch -d $CLOUD_SQL_SA gs://intech/schema_dump_v2.gz
gsutil acl ch -d $CLOUD_SQL_SA gs://intech
