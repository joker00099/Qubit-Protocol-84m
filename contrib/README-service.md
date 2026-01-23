This folder contains helper files to run the Axiom node as a persistent service.

Files:
- axiom.service: systemd unit template (adjust WorkingDirectory and ExecStart before installing).
- run_axiom.sh: lightweight supervisor script to restart the node if it exits. Use this when systemd is not available.
- axiom.logrotate: logrotate config template for `node.log` (replace the path before installing).

Quick usage (systemd available and running):

1. Adjust `contrib/axiom.service` paths.
2. Install and enable:

```sh
sudo cp contrib/axiom.service /etc/systemd/system/axiom.service
sudo systemctl daemon-reload
sudo systemctl enable --now axiom.service
sudo journalctl -u axiom.service -f
```

Quick usage (no systemd):

1. Build the release: `cargo build --release`
2. Start the supervisor in background:

```sh
nohup contrib/run_axiom.sh &> /dev/null &
```

Quick install for logrotate (optional):

```sh
# Edit contrib/axiom.logrotate and replace /path/to/... with the repository path
sudo cp contrib/axiom.logrotate /etc/logrotate.d/axiom
sudo logrotate -f /etc/logrotate.d/axiom
```
