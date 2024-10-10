set env vars
set -o allexport; source .env; set +o allexport;

SECRET_KEY=`openssl rand -hex 16`
cat << EOT >> ./.env

SECRET_KEY=${SECRET_KEY}
EOT

cat << EOT > ./create_admin.py
from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.conf import settings

class Command(BaseCommand):
    def handle(self, *args, **options):
        if not User.objects.filter(username='admin').exists():
            User.objects.create_superuser(
                username='admin',
                email='${ADMIN_EMAIL}',
                password='${ADMIN_PASSWORD}'
            )
            self.stdout.write(self.style.SUCCESS('Successfully created superuser'))


EOT

cat <<EOT > ./servers.json
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 49327,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "postgres",
            "PassFile": "/pgpass"
        }
    }
}
EOT
