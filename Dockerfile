FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
      systemd \
      systemd-sysv \
      curl \
      dbus \
      kmod \
      iproute2 \
      iputils-ping \
      net-tools \
      openssh-server \
      rng-tools \
      sudo \
      udev \
      vim-tiny \
      apt-transport-https \
      ca-certificates \
      wget \
      telnet \
      inetutils-traceroute \
      dnsutils \
      netcat \
      tcpdump \
      cloud-init && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install VSCode Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Configure systemd and SSH
RUN echo "" > /etc/machine-id && echo "" > /var/lib/dbus/machine-id

RUN sed -i -e 's/^AcceptEnv LANG LC_\*$/#AcceptEnv LANG LC_*/' /etc/ssh/sshd_config
RUN echo "root:root" | chpasswd
RUN sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Copy the cloud-init configuration file
COPY cloud-init/cloud-init-config.yaml /etc/cloud/cloud.cfg.d/99_docker.cfg

# Copy the startup script
COPY scripts/startup.sh /usr/local/bin/startup.sh

# Copy the systemd service file
COPY systemd/code-server.service /etc/systemd/system/code-server.service

RUN chmod +x /usr/local/bin/startup.sh

# Mask unnecessary services to avoid errors
RUN systemctl mask systemd-logind.service getty.target

EXPOSE 8080 22

CMD ["/usr/local/bin/startup.sh"]
