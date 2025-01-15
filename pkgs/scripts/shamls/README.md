## shamls

`shamls` (_ˈSHāmləs_) is a YAML-based declarative micro-task runner designed for project automation, interactive shell applications, app launchers, and more.

### Usage

```yaml
docker:
  containers: sudo docker ps | sed '1d'
  container: echo "<containers>" | gum choose | awk '{print $1}'
  sh: sudo docker exec -ti "<container>" "/bin/sh"
  logs: sudo docker logs -f "<container>"
  prune: sudo docker system prune -a
```

```bash
$ shamls config.yaml
docker.container: sudo docker ps | sed '1d' | gum choose | awk '{print $1}'
docker.sh: sudo docker exec -ti "<container>" "/bin/sh"
docker.logs: sudo docker logs -f "<container>"
docker.prune: sudo docker system prune -a
```

## related projects

quicksilver
navi
cmdkit
