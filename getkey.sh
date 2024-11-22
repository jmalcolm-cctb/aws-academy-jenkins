#!/bin/bash
terraform output private_key > key.pem
chmod 400 key.pem
