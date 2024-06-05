#!/bin/bash

# Clean up any previous systemd configurations
rm -f /run/nologin

# Initialize systemd
exec /lib/systemd/systemd
