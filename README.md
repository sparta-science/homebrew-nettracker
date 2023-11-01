# nettracker

🔗 A dynamic port monitoring tool written in Go that listens for connections and seamlessly establishes tunnels, proxying traffic between a client and the tunnel.

## Features
- Monitors specified ports for incoming connections.
- Automatically establishes a tunnel upon connection.
- Proxies all traffic between the client and the tunnel.
- Lightweight and efficient, thanks to Go's concurrent design.

## Getting Started

### Prerequisites
- Go (version 1.x or higher)

### Installation
1. Clone the repository:
```bash
git clone https://github.com/sparta-science/nettrucker.git
```

2. Navigate to the `nettrucker` directory and build the project:
```bash
cd nettrucker
go build
```

### Usage
```bash
./nettrucker -port <LISTEN_PORT> -host <LISTEN_HOST> -tunnelPort <TUNNEL_PORT> -cmdStr "<TUNNEL_COMMAND>"
```

- `LISTEN_PORT`: The port `nettrucker` should monitor for incoming connections.
- `LISTEN_HOST` (optional): The host where `nettrucker` listens for connections.
- `TUNNEL_COMMAND`: The bash command that `nettrucker` should execute to establish a tunnel when a connection is detected.
- `TUNNEL_PORT`: Local port with tunnel connection.

### Example
```bash
./nettrucker -port 8080 -host localhost -tunnelPort 9090 -cmdStr "ssh -L 9090:localhost:5432 remoteuser@remotehost"
```

In this example, `nettrucker` will monitor port `8080`. Upon connection, it will execute the specified SSH command to set up a tunnel from port `9090` to `localhost:5432` on `remotehost`.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

## License
This project is licensed under the MIT License.
