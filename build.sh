#!/bin/bash
git pull
export GIT_COMMIT=$(git rev-parse --short HEAD)
docker compose build --no-cache frontend
docker compose up -d