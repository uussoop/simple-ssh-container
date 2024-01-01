FROM alpine:latest 

ARG SSH_PORT=2222
ARG allowed_ip=*
# Create user

RUN adduser --disabled-password sshuser  && \
    echo 'sshuser:123' | chpasswd && \
    mkdir -p /home/sshuser/.ssh  && \
    chown -R sshuser:sshuser /home/sshuser/.ssh && \
    chmod go-w /home/sshuser && \
    chmod 700 /home/sshuser/.ssh && \
    touch /home/sshuser/.ssh/authorized_keys && \
    chown sshuser:sshuser /home/sshuser/.ssh/authorized_keys && \
    chmod 600 /home/sshuser/.ssh/authorized_keys
    

# Install SSH 
RUN apk add --update openssh && \
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i "s/#Port 22/Port ${SSH_PORT}/" /etc/ssh/sshd_config
    
RUN echo "AllowUsers sshuser@${allowed_ip}" >> /etc/ssh/sshd_config 

RUN ssh-keygen -A
RUN chown -R sshuser:sshuser /etc/ssh 
RUN passwd -d root
USER sshuser




ENTRYPOINT ["/usr/sbin/sshd", "-D","-e"]