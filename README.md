
python -V
sudo yum install epel-release
If not installed : yum install python3.11
sudo ln -sf /usr/bin/python3.11 /usr/bin/python
python -m pip install --upgrade pip

python -m venv .venv --prompt="Med_Virtual"

## Database PostgreSQL

If there is no DB server : sudo dnf install postgresql13 postgresql13-server

sudo systemctl status postgresql-13
sudo -u postgres psql
\l : to see all databases
CREATE DATABASE factura WITH OWNER = postgres;
ALTER USER postgres WITH PASSWORD 'Med@database@2025';
\c factura;
ALTER SEQUENCE dossier_id_seq RESTART WITH 1;

## Get requirements.txt from local machine using

. .venv/bin/activate
pip install -r requirements.txt  # pip freeze > requirements.txt

python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py collectstatic --no-input
python manage.py runserver 0.0.0.0:8000

### To Test the Dev Project

sudo yum install screen
sudo screen -d -m python manage.py runserver 0.0.0.0:80& # Without env for Dev
screen -ls
screen -r
python manage.py check --deploy
python manage.py shell # Quick tests

sudo systemctl status httpd
sudo yum install python311-mod_wsgi.x86_64
sudo yum install httpd
sudo yum install nano
sudo nano /etc/httpd/conf.d/django.conf

## In the file django.conf Write

<VirtualHost *:80>
    ServerName  django_project.localhost
    ServerAlias www.django_project.localhost
    DocumentRoot /home/Factura
    Alias /assets /home/Factura/template/assets
    <Directory /home/Factura/template/assets>
      Require all granted
    </Directory>

    Alias /media /home/Factura/template/media
    <Directory /home/Factura/template/media>
      Require all granted
    </Directory>

    <Directory /home/Factura/application>
      <Files wsgi.py>
        Require all granted
      </Files>
    </Directory>

    WSGIDaemonProcess django_project python-path=/home/Factura:/home/Factura/.venv/lib/python3.11/site-packages
    WSGIProcessGroup django_project
    WSGIScriptAlias / /home/Factura/application/wsgi.py
    
    Header set Access-Control-Allow-Origin "*"
    Header set Access-Control-Allow-Methods "GET, POST, PUT,PATCH, DELETE, OPTIONS"
    Header set Access-Control-Allow-Headers "Content-Type"

    ErrorLog  /home/Factura/apache_error.log
    CustomLog /home/Factura/apache_access.log combined
</VirtualHost>

## Launching the server

sudo chown apache:apache /home/Factura/
sudo usermod -a -G root apache
chmod 710 /home/
sudo chmod -R 777 /home/Factura/
sudo setsebool -P httpd_can_network_connect 1
sudo systemctl restart httpd
sudo systemctl enable httpd
sudo systemctl reload httpd

## application/wsgi.py

    import os,sys,site
    from django.core.wsgi import get_wsgi_application
    site.addsitedir('/home/Factura/.venv/lib/python3.11/site-packages/')
    sys.path.append('/home/Factura')
    sys.path.append('/home/Factura/application/')
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "application.settings")
    application = get_wsgi_application()

## Add in settings.py

    'DIRS': ['template' , os.path.join(BASE_DIR, 'template')],

### Update the config of apache


sudo systemctl restart httpd
sudo reboot