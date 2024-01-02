
# SSH Tunnel Docker Compose

This Docker Compose file sets up an SSH tunnel container to allow access to private networks. 

## Services

The `ssh-proxy` service builds a Docker image from the Dockerfile in the current directory. It exposes port 2222 and maps it to the container's port 2222.

Environment variables:

- `ALLOWED_IPS` - Allows SSH access only from the specified IP addresses.

Configs:

- `ssh_authorized_keys` - Mounts the `./auth/authorized_keys` file into the container at `/authorized_keys`. This allows only the specified SSH keys to login.

## Usage

Clone this repo and run:

```
docker-compose up -d
```

You can then SSH into the tunnel:

```
ssh -p 2222 tunnel@localhost
```

From there, you can access any private hosts and networks allowed by your SSH keys.

## Security

- Only allow SSH access from trusted IP addresses
- Only allow SSH keys stored in `./auth/authorized_keys` 
- Container runs as an unprivileged user

## Improvements

- Use SSH certificates instead of keys
- Add logging to see who logs in and when
- Run regular security audits on keys and creds
