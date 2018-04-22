#!/bin/bash
# update magento (composer update and all commands that are usually run after making changes to magento code)
ansible-playbook /ansible/update.yml -i 127.0.0.1, -c local