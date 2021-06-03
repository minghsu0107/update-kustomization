# Update Kustomization
A Drone CI plugin for updating an image tag using kustomize.

Environment variables:
- `SSH_KEY`: Base64-encoded private key of your manifest repo
- `MANIFEST_HOST`: Git server host
- `MANIFEST_USER`: Git user
- `MANIFEST_REPO`: Git repository
- `IMAGE_REPO`: Image repository
- `IMAGE_TAG`: Image tag generated in current build
- `SVC_PATH`: Service kustomization path relative to the project root

Example usage in a Drone pipeline:
```yaml
...
- name: push-registry
  image: plugins/docker
  settings:
    context: .
    dockerfile: ./Dockerfile
    username:
      from_secret: docker_username
    password:
      from_secret: docker_password
    registry: harbor.mycompany.com
    repo: harbor.mycompany.com/myuser/mysvc
    tags:
      - ${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA:0:7}
      - latest
  when:
    event: push
- name: update-kustomization
  pull: if-not-exists
  image: minghsu0107/update-kustomization:v1.0.2
  environment:
    SSH_KEY:
      from_secret: ssh_key
    MANIFEST_HOST: git.mycompany.com
    MANIFEST_USER: myuser
    MANIFEST_REPO: mysvc
    IMAGE_REPO: harbor.mycompany.com/myuser/mysvc
    IMAGE_TAG: ${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA:0:7}
    SVC_PATH: staging/mysvc
  when:
    event: push
  depends_on:
    - push-registry
```
In the above example, the image tag is in the form of `${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA:0:7}`, where `DRONE_COMMIT_BRANCH` and `DRONE_COMMIT_SHA` are environment variables provided by Drone at run time. 
