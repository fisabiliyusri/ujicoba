# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=indonesia
locality=indonesia
organization=infinity
organizationalunit=infinity
commonname=localhost
email=infinity@facebook.com


# Settings SSLH
cat > /etc/default/sslh <<-END
# Default options for sslh initscript
# sourced by /etc/init.d/sslh

# Disabled by default, to force yourself
# to read the configuration:
# - /usr/share/doc/sslh/README.Debian (quick start)
# - /usr/share/doc/sslh/README, at "Configuration" section
# - sslh(8) via "man sslh" for more configuration details.
# Once configuration ready, you *must* set RUN to yes here
# and try to start sslh (standalone mode only)

RUN=yes

# binary to use: forked (sslh) or single-thread (sslh-select) version
# systemd users: don't forget to modify /lib/systemd/system/sslh.service
DAEMON=/usr/sbin/sslh

DAEMON_OPTS="--user sslh --listen 0.0.0.0:2053 --ssl 127.0.0.1:500 --ssh 127.0.0.1:300 --openvpn 127.0.0.1:650 --openvpn 127.0.0.1:600 --pidfile /var/run/sslh/sslh.pid"

END

# Restart Service SSLH
service sslh restart
systemctl restart sslh
/etc/init.d/sslh restart

# Stunnel5
# Download Config Stunnel5
cat > /etc/stunnel5/stunnel5.conf <<-END
cert = /etc/stunnel5/stunnel5.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[openvpn]
accept = 900
connect = 127.0.0.1:2053

[openssh]
accept = 500
connect = 127.0.0.1:2053

[stunnelws]
accept = 555
connect = 650

[stunnelws]
accept = 222
connect = 700

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel5/stunnel5.pem

#

