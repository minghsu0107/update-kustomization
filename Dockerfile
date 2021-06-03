FROM line/kubectl-kustomize:1.20.2-3.9.1

RUN mkdir -p /app
WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENV SSH_KEY=
ENV CONTAINER_REPO=
ENV MANIFEST_HOST=
ENV MANIFEST_USER=
ENV MANIFEST_REPO=
ENV SVC_PATH=

ENTRYPOINT ["/app/entrypoint.sh"]