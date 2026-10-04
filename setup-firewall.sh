#!/usr/bin/env bash
set -euo pipefail

ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw --force enable
ufw status verbose
