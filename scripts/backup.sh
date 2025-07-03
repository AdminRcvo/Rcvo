#!/bin/bash
set -e
aws s3 sync src    s3://rcvo-officiel/backups/src    --region eu-west-3
aws s3 sync config s3://rcvo-officiel/backups/config --region eu-west-3
