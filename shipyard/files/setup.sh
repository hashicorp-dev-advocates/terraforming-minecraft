#!/bin/bash -xe
TOKEN=$(curl -s --data "grant_type=password&username=root&password=${GITLAB_PASSWORD}" -XPOST ${GITLAB_URL}/oauth/token | jq -r .access_token)

# Create a demo group
GROUP=$(curl -s -XPOST -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"path\": \"demo\", \"name\": \"Demo\", \"visibility\": \"public\"}" \
  ${GITLAB_URL}/api/v4/groups/ | jq -r .id)

# Create a minecraft project
PROJECT=$(curl -s -XPOST -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"Minecraft\", \"path\": \"minecraft\", \"namespace_id\": \"${GROUP}\", \"initialize_with_readme\": \"false\"}" \
  ${GITLAB_URL}/api/v4/projects/ | jq -r .id)

# Create a user
USER=$(curl -s -XPOST -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"Demo User\", \"username\": \"demo-user\", \"email\": \"demo@hashicraft.com\", \"password\": \"supersecret\", \"skip_confirmation\": \"true\"}" \
  ${GITLAB_URL}/api/v4/users/ | jq -r .id)

curl -s -XPOST -H "Authorization: Bearer ${TOKEN}" \
  -d "user_id=${USER}&access_level=30" \
  ${GITLAB_URL}/api/v4/groups/${GROUP}/members

curl -s -XPUT -H "Authorization: Bearer ${TOKEN}" \
  -d "default_branch=main" \
  ${GITLAB_URL}/api/v4/projects/${PROJECT}
