# bash <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/docker_compose_django.sh)

############# MORE-> https://docs.docker.com/compose/django/
docker_engine=$(which docker)

if [ -z "$docker_engine" ]; then
  bash <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/install_docker_and_compose.sh)
fi
workdir=/tmp/dkdj
project=localtuk
DB_NAME=django
DB_USR=admin
DB_PASS=4dm1n

if [ ! -d "$workdir" ]; then
  mkdir $workdir
fi
cd $workdir

cat <<-EOF > Dockerfile
FROM python:3
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
EOF

cat <<-EOF > requirements.txt
Django>=2.0,<3.0
psycopg2-binary>=2.8
EOF

cat << EOF > docker-compose.yml
version: '3'

services:
  db:
    image: postgres
    environment:
      - POSTGRES_DB=$DB_NAME
      - POSTGRES_USER=$DB_USR
      - POSTGRES_PASSWORD=$DB_PASS
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/code
    ports:
      - "8000:8000"
    depends_on:
      - db
EOF

sudo docker-compose run web django-admin startproject $project .

sudo chown -R $USER:$USER .

anchor_line=$(awk '/# Database/{ print NR; exit }' $project/settings.py)
start_line=$((anchor_line+2))
end_line=$((start_line+6))
sed -i "$start_line,${end_line}d" $project/settings.py


cat > /tmp/HereFile << EOF
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '$DB_NAME',
        'USER': '$DB_USR',
        'PASSWORD': '$DB_PASS',
        'HOST': 'db',
        'PORT': 5432,
    }
}
EOF

sed -i "$start_line r /tmp/HereFile" $project/settings.py










#
