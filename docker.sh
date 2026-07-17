#!/usr/bin/env bash
#
# Docker networking lab — run each section and observe the output.
# Start the lab first:  docker compose up -d
#
set -uo pipefail

pause() {
  echo
  read -rp "--- Press Enter to continue ---"
  echo
}

section() {
  echo
  echo "=============================================================="
  echo "  $1"
  echo "=============================================================="
}

section "1. List Docker networks"
echo "The default networks are: bridge, host, none."
echo "Compose created an extra bridge network for this project (labnet)."
docker network ls
pause

section "2. Inspect the lab bridge network"
echo "Note the subnet, the gateway and which containers are attached."
docker network inspect "$(docker network ls --filter name=labnet -q)"
pause

section "3. Interfaces inside each container"
echo "--- client (bridge): eth0 with a private IP from the labnet subnet ---"
docker exec client ip addr show
echo
echo "--- hostnet (host mode): sees ALL the host's interfaces ---"
docker exec hostnet ip addr show
echo
echo "--- nonet (none mode): only loopback, nothing else ---"
docker exec nonet ip addr show
pause

section "4. DNS between containers on the same bridge network"
echo "Docker runs an embedded DNS server (127.0.0.11) inside each container"
echo "on a user-defined bridge, so containers resolve each other by name."
echo "Note the 'search' line: it is copied from the HOST's resolv.conf."
docker exec client cat /etc/resolv.conf
echo
echo "Resolve via the libc resolver (what ping/wget actually use):"
docker exec client getent hosts web
echo
echo "Gotcha: busybox nslookup appends the search domain (e.g. 'web.home')"
echo "and fails; a trailing dot makes the name fully qualified:"
docker exec client nslookup web.
pause

section "5. Ping between containers (bridge)"
docker exec client ping -c 3 web
pause

section "6. HTTP from client to web by service name"
docker exec client wget -qO- http://web | head -n 5
pause

section "7. Port mapping: reach 'web' from the HOST via published port 8080"
echo "The bridge NATs host:8080 -> web:80 (see 'ports:' in the compose file)."
curl -s http://localhost:8080 | head -n 5
pause

section "8. Host mode: hostnet shares the host's network stack"
echo "Its hostname and IPs are the host's. It can reach localhost services"
echo "directly — e.g. the published port 8080 of 'web':"
docker exec hostnet wget -qO- http://localhost:8080 | head -n 5
pause

section "9. None mode: nonet has no connectivity at all"
echo "Pinging anything external fails (only loopback exists):"
docker exec nonet ping -c 2 -W 2 8.8.8.8 && echo "UNEXPECTED: it worked!" \
  || echo "As expected: no network access."
echo
echo "But loopback works:"
docker exec nonet ping -c 2 127.0.0.1
pause

section "10. Isolation: default bridge vs user-defined bridge"
echo "Containers on DIFFERENT bridge networks cannot reach each other."
echo "Launch a throwaway container on the DEFAULT bridge and try to reach web:"
docker run --rm alpine sh -c 'ping -c 2 -W 2 web || echo "Cannot resolve web: different network + no DNS on default bridge"'
pause

section "11. Routing table inside a bridge container"
echo "Default route points to the bridge gateway on the host."
docker exec client ip route
pause

section "12. See the bridge from the HOST side"
echo "Docker creates a virtual bridge interface on the host (br-<id>),"
echo "plus one veth pair per container attached to it:"
ip link show type bridge
echo
ip link show type veth 2>/dev/null || echo "(veth listing needs iproute2 on the host)"
pause

section "13. Connect / disconnect a container to a network at runtime"
NET_ID=$(docker network ls --filter name=labnet --format '{{.Name}}' | head -n1)
echo "Disconnecting client from $NET_ID..."
docker network disconnect "$NET_ID" client
echo "Now ping fails:"
docker exec client ping -c 2 -W 2 web || echo "As expected: disconnected."
echo
echo "Reconnecting..."
docker network connect "$NET_ID" client
docker exec client ping -c 2 web && echo "Back online."

echo
echo "Done! Tear down the lab with: docker compose down"
