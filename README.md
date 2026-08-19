# sysbreak

A local break/fix Linux game. A script sabotages a throwaway container.
You get a root shell. You diagnose and repair the box. A check script
grades the end state.

The engine is not built yet. The base image and one scenario exist.
You can build the image and run that scenario by hand.

The repository name is `brokenbox`. The working name of the game is
`sysbreak`.

## Requirements

- Host OS: Ubuntu 22.04+ or Debian 12+
- Rootless `podman`. No Docker. No daemon.

## Build the image

```bash
podman build -t localhost/sysbreak:latest -f image/Containerfile image
```

The image is Debian 13. systemd is PID 1. Man pages are present.
Common server tools are preinstalled. One image is shared by every
scenario.

## Run a scenario by hand

Start a box. Wait until systemd is running.

```bash
podman run -d --name box --systemd=always --network=none localhost/sysbreak:latest
podman exec box systemctl is-system-running
```

Pipe the break script in over stdin. Do not copy scripts onto the box.

```bash
podman exec -i -e SEED=1 -e DIFFICULTY=2 box bash -s \
  < scenarios/web-server-unreachable/break.sh
```

Read the brief. Then enter the box.

```bash
cat scenarios/web-server-unreachable/brief.md
podman exec -it box bash
```

Grade the end state. Remove the box when you finish.

```bash
podman exec -i box bash -s < scenarios/web-server-unreachable/check.sh
podman rm -f box
```

`check.sh` prints one assertion per line (`PASS`, `FAIL`, or `INFO`).
It exits 0 only when there are no `FAIL` lines.

`solve.sh` is the reference fix. Use it to verify the scenario. Do not
use it while you play.

## Scenario layout

```
scenarios/<id>/
  brief.md      symptom as a user would report it
  break.sh      sabotages the box (reads SEED and DIFFICULTY)
  check.sh      read-only grader
  solve.sh      reference fix, for verification only
  meta.yaml     id, title, difficulty, tags
```

Scenario scripts run as root on Linux. They must not name `podman`,
`docker`, or any container runtime.

## Current scenarios

| id | title |
| --- | --- |
| `web-server-unreachable` | Web server unreachable |
