# Use Python 3.12 slim image as base
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install uv (fast Python package manager)
RUN pip install uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
RUN uv sync --frozen

# Copy application code
COPY . .

# Expose port 8001 (default for FastMCP HTTP server)
EXPOSE 8000
# Set environment variable for HTTP server
ENV MCP_HTTP_PORT=8000
ENV MCP_HTTP_HOST=0.0.0.0

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Install curl for health check
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Run the weather MCP server
CMD ["uv", "run", "weather.py"]
