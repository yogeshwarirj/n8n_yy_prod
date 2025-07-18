# Use Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install n8n globally
RUN npm install -g n8n@latest

# Create n8n user for security
RUN addgroup -g 1000 n8n && \
    adduser -u 1000 -G n8n -s /bin/sh -D n8n

# Create .n8n directory with proper permissions
RUN mkdir -p /home/n8n/.n8n && \
    chown -R n8n:n8n /home/n8n

# Switch to n8n user
USER n8n

# Set environment variables
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=https
ENV N8N_USER_FOLDER=/home/n8n/.n8n

# Expose port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

# Start n8n
CMD ["n8n", "start"]
