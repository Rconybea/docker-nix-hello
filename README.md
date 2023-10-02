```
$ cd ~/proj/docker-nix-hello  # directory containing this file
$ nix build
```

upload to docker
```
$ docker load <./result
```


To get github personal access token:

- on github.com/${myusername}:
  - visit profile (upper rhs or github.com)
    - developer settings (bottom of sidebar)
      - personal access tokens
        - tokens (classic)
          'generate a personal access token'

          scopes needed:
          - read:packages
          - write:packages
          - delete:packages
          
```
$ export CR_PAT=${token}
$ echo $CR_PAT | docker login ghcr.io -u rconybea --password-stdin
Login Succeeded
```

tag image the way github expects,  i.e. format ghcr.io/${username}/${imagename}:${tag}

```
$ docker image tag docker-nix-hello:v1 ghcr.io/rconybea/docker-nix-hello:v1
```

push to github container registry:
```
$ docker image push ghcr.io/rconybea/docker-nix-hello:v1
The push refers to repository [ghcr.io/rconybea/docker-nix-hello]
...omitted...
v1: digest: sha256:5fe294bd6073b162b26596f6fc16899da6da4257bb311106575a3ca327a52f0e size: 1782
```

verify it's arrived by inspecting the gihub 'packages' tab [https://github.com/Rconybea?tab=packages]

image (github package) is initially private;  make it public from the package's 'setting' link


