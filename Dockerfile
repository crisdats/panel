FROM ghcr.io/lescai-teaching/rstudio-docker-amd64:latest

# Set environment variables
ENV PASSWORD='rstudio'
ENV PATH=${PATH}:/opt/software/bin
ENV PORT=8787
ENV DISABLE_AUTH=true

# Set working directory
WORKDIR /home/rstudio

# Install necessary packages and the latest version of Node.js
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y sudo git ffmpeg wget mc imagemagick curl && \
    curl -sL https://deb.nodesource.com/setup_current.x | bash - && \
    apt install -y nodejs && \
    npm i -g pm2

# Add sudo privileges to the RStudio user
RUN echo "rstudio ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set correct file permissions
RUN chmod -R 777 /home/rstudio && \
    chown -R rstudio:rstudio /home/rstudio

# Expose the necessary port
EXPOSE 8787

# Copy entrypoint script (defined below)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set entrypoint
CMD ["sh", "/usr/local/bin/entrypoint.sh"]
