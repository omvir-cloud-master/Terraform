#!/bin/bash

apt-get update -y
apt-get install -y apache2

systemctl enable apache2
systemctl start apache2

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Frontend Server ${server_number}</title>
</head>
<body style="font-family: Arial; text-align: center; margin-top: 100px;">
    <h1>Welcome to Frontend Server ${server_number}</h1>
    <h3>Hostname: $(hostname)</h3>
</body>
</html>
EOF