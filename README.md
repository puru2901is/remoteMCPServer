# Weather MCP Server

A Model Context Protocol (MCP) server that provides weather forecasts and alerts using the National Weather Service (NWS) API. This server is built with FastMCP and can be deployed as a remote HTTP service.

## Features

- **Weather Forecasts**: Get detailed weather forecasts for any US location using latitude/longitude coordinates
- **Weather Alerts**: Retrieve active weather alerts for any US state
- **Remote HTTP Server**: Stateless HTTP server that can be deployed remotely and accessed by MCP clients
- **Docker Support**: Containerized deployment with health checks
- **High Performance**: Built with FastMCP for efficient request handling

## Tools Available

### `get_forecast`
Get a detailed weather forecast for a specific location.

**Parameters:**
- `latitude` (float): Latitude of the location
- `longitude` (float): Longitude of the location

**Returns:** 5-period weather forecast with temperature, wind, and detailed conditions

### `get_alerts`
Get active weather alerts for a US state.

**Parameters:**
- `state` (string): Two-letter US state code (e.g., "CA", "NY", "TX")

**Returns:** List of active weather alerts with severity, description, and instructions

## Installation

### Prerequisites
- Python 3.12+
- [uv](https://docs.astral.sh/uv/) package manager

### Local Development

1. Clone the repository:
```bash
git clone <repository-url>
cd RemoteMcpServer/weather
```

2. Install dependencies:
```bash
uv sync
```

3. Run the server:
```bash
uv run weather.py
```

The server will start on `http://localhost:8000` by default.

### Docker Deployment

1. Build the Docker image:
```bash
docker build -t weather-mcp-server .
```

2. Run the container:
```bash
docker run -p 8000:8000 weather-mcp-server
```

3. The server will be available at `http://localhost:8000`

## Configuration

The server can be configured using environment variables:

- `MCP_HTTP_PORT`: Port to run the server on (default: 8000)
- `MCP_HTTP_HOST`: Host to bind the server to (default: 127.0.0.1, use 0.0.0.0 for Docker)

## Usage Examples

### Using with MCP Client

Once the server is running, you can connect to it using any MCP client. The server exposes two tools:

#### Getting a Weather Forecast
```python
# Request forecast for San Francisco (37.7749, -122.4194)
result = await client.call_tool("get_forecast", {
    "latitude": 37.7749,
    "longitude": -122.4194
})
```

#### Getting Weather Alerts
```python
# Get alerts for California
result = await client.call_tool("get_alerts", {
    "state": "CA"
})
```

### HTTP API Endpoints

The server exposes standard MCP HTTP endpoints:

- `GET /health` - Health check endpoint
- `POST /mcp/v1/tools/list` - List available tools
- `POST /mcp/v1/tools/call` - Call a specific tool

## API Data Source

This server uses the **National Weather Service (NWS) API**, which provides:
- High-quality weather data for the United States
- No API key required
- Free public access
- Reliable government data source

## Development

### Project Structure
```
weather/
├── weather.py          # Main MCP server implementation
├── main.py            # Alternative entry point
├── pyproject.toml     # Project dependencies
├── Dockerfile         # Container configuration
├── uv.lock           # Locked dependency versions
└── README.md         # This file
```

### Dependencies
- `fastmcp>=2.10.1` - FastMCP framework for building MCP servers
- `httpx>=0.28.1` - Async HTTP client for API requests
- `mcp[cli]>=1.10.1` - MCP CLI tools

### Error Handling
The server includes robust error handling:
- HTTP request timeouts (30 seconds)
- Graceful degradation when API is unavailable
- Proper user agent headers for NWS API compliance
- JSON parsing error handling

## Health Monitoring

The Docker container includes a health check that verifies the server is responding:
- Interval: 30 seconds
- Timeout: 10 seconds
- Start period: 5 seconds
- Retries: 3 attempts




## Support

For issues and questions:
- Check the [MCP documentation](https://modelcontextprotocol.io/)
- Review the [FastMCP documentation](https://fastmcp.com/)
- Open an issue in this repository