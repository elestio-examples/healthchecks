# set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting for software to be ready ..."
sleep 45s;

docker-compose exec -T healthchecks sh -c "/opt/healthchecks/manage.py create_admin"