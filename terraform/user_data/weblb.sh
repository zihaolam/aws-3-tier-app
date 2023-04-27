#! /bin/bash

sudo apt-get update -y && \
sudo apt-get install -y haproxy && \
echo "ENABLED=1" | sudo tee -a /etc/default/haproxy > /dev/null && \
sudo touch /etc/haproxy/haproxy.cfg && \
echo "
global
    log 127.0.0.1 local0 notice
    maxconn 2000
    user haproxy
    group haproxy

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    retries 3
    option redispatch
    timeout connect  5000
    timeout client  10000
    timeout server  10000

listen appname
    bind 0.0.0.0:80
    mode http
    stats enable
    stats uri /haproxy?stats
    stats realm Strictly\ Private
    stats auth zihaolam:Passw0rd
    stats auth Another_User:passwd
    balance roundrobin
    option httpclose
    option forwardfor
    server app1 10.0.3.80:80 check
    server app2 10.0.4.80:80 check
" | sudo tee /etc/haproxy/haproxy.cfg > /dev/null

sudo systemctl restart haproxy