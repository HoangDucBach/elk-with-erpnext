@echo off
echo Cleaning...
docker compose -f docker-elk\docker-compose.yml down -v

docker compose -f frappe_docker\pwd.yml down -v

echo All containers and volumes have been removed.