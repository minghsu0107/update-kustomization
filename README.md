# Update Kustomization
An CI image for updating image tags using kustomize.

Environment variables:
- `SSH_KEY`: Base64-encoded private key of your manifest repo
- `MANIFEST_HOST`: Manifest git server host
- `MANIFEST_USER`: Manifest git user
- `MANIFEST_REPO`: Manifest git repository
- `MANIFEST_BRANCH`: Manifest repository branch
- `IMAGES`: Updated images (comma-separated list)
- `IMAGE_TAG`: Image tag generated in current build
- `KUSTOMIZATION`: Kustomization path relative to the project root

Example usage in a Drone pipeline:
```yaml
kind: pipeline
name: publish-mysvc1
steps:
- name: publish
  image: plugins/docker
  settings:
    context: mysvc1
    dockerfile: mysvc1/Dockerfile
    username:
      from_secret: docker_username
    password:
      from_secret: docker_password
    registry: harbor.mycompany.com
    repo: harbor.mycompany.com/myuser/mysvc1
    tags:
    - ${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA:0:7}
    - latest
  when:
    event: push

---
kind: pipeline
name: publish-mysvc2
steps:
- name: publish
  image: plugins/docker
  settings:
    context: mysvc2
    dockerfile: mysvc2/Dockerfile
    username:
      from_secret: docker_username
    password:
      from_secret: docker_password
    registry: harbor.mycompany.com
    repo: harbor.mycompany.com/myuser/mysvc2
    tags:
    - ${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA:0:7}
    - latest
  when:
    event: push
    
---
kind: pipeline
name: update-kustomization
steps:
- name: kustomization
  pull: if-not-exists
  image: minghsu0107/update-kustomization:v1.0.3
  environment:
    SSH_KEY:
      from_secret: ssh_key
    MANIFEST_HOST: git.mycompany.com
    MANIFEST_USER: myuser
    MANIFEST_REPO: myapp-manifests
    MANIFEST_BRANCH: ${DRONE_COMMIT_BRANCH}
    IMAGES: harbor.mycompany.com/myuser/mysvc1,harbor.mycompany.com/myuser/mysvc2
    IMAGE_TAG: ${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA:0:7}
    KUSTOMIZATION: overlays/${DRONE_COMMIT_BRANCH}
  when:
    event: push
depends_on:
 - publish-mysvc1
 - publish-mysvc2
```
In the above example, the image tag is in the form of `${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA:0:7}`, where `DRONE_COMMIT_BRANCH` and `DRONE_COMMIT_SHA` are environment variables provided by Drone at run time. 
