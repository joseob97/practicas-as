# ssh_development/Dockerfile
FROM debian:bullseye

RUN apt update && apt install -y openssh-server libpam-google-authenticator sudo iputils-ping dnsutils iproute2

RUN useradd -m john && echo 'john:john' | chpasswd && usermod -aG sudo john
RUN mkdir /var/run/sshd

# Configurar SSH para usar Google Authenticator y contraseña
RUN sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#*UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config

# Configurar PAM para Google Authenticator
RUN echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

