# Update Kustomization
A Drone CI plugin for updating an image tag using kustomize.

Environment variables:
- `SSH_KEY`: Base64-encoded private key of your manifest repo
- `MANIFEST_HOST`: Git server host
- `MANIFEST_USER`: Git user
- `MANIFEST_REPO`: Git repository
- `CONTAINER_REPO`: Container repository
- `SVC_PATH`: Relative path to the target service manifest

Example usage in a Drone pipeline:
```yaml
...
- name: update-kustomization
  pull: if-not-exists
  image: minghsu0107/update-kustomization:v1.0.0
  environment:
    SSH_KEY:
      from_secret: ssh_key
    MANIFEST_HOST: git.mycompany.com
    MANIFEST_USER: myuser
    MANIFEST_REPO: mysvc
    CONTAINER_REPO: harbor.mycompany.com/myuser/mysvc
    SVC_PATH: staging/mysvc
  when:
    event: push
```
Where `staging/mysvc` is the kustomization folder path relative to the project root.
