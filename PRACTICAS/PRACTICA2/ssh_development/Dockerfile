# ssh_development/Dockerfile
FROM debian:bullseye

RUN apt update && apt install -y openssh-server libpam-google-authenticator sudo

RUN useradd -m john && echo 'john:john' | chpasswd && usermod -aG sudo john
RUN mkdir /var/run/sshd

# Configurar SSH para usar Google Authenticator y contraseña
RUN sed -i 's/^#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^UsePAM no/UsePAM yes/' /etc/ssh/sshd_config

# Configurar PAM para Google Authenticator
RUN echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

