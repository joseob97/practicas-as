# ssh_services/Dockerfile
FROM debian:bullseye

RUN apt update && apt install -y openssh-server sudo
RUN useradd -m john && mkdir -p /home/john/.ssh && chmod 700 /home/john/.ssh
COPY authorized_keys /home/john/.ssh/authorized_keys
RUN chown -R john:john /home/john/.ssh && chmod 600 /home/john/.ssh/authorized_keys

RUN mkdir /var/run/sshd

# Deshabilita el login por contraseña
RUN sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

