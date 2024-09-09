# Routing

## UBC RIPE Atlas Probe

UBC hosts a RIPE Atlas probe at https://atlas.ripe.net/probes/21001/. It may be possible to use it to trace or ping IP addresses that are generally not possible to ping from eduroam WiFi.

## External <-> UBC

### `ubcvisitor` (206.87.130.254/21) -> external

Outbound (To external):

1. 10.43.225.254 (Gateway): Does NAT for ubcvisitor?
2. 10.20.216.30: Common gateway for WiFi?
3. 142.103.204.198: Common router for WiFi that makes routing decisions to various UBC subnets or external router?
4. 137.82.88.125: External outbound that peers with BCNet and has IPv4 full table?
5. 134.87.0.58 (345-ix-cr1-ubcab.vncv1.bc.net)
6. (Hops after BCNet removed for simplicity)

### `eduroam` (206.87.130.254/21) <-> external

Outbound (To external):

1. 206.87.135.254 (Gateway): On-link gateway
2. 10.20.216.30: Common gateway for WiFi?
3. 142.103.204.198: Common router for WiFi that makes routing decisions to various UBC subnets or external router?
4. 137.82.88.125: External outbound that peers with BCNet and has IPv4 full table?
5. 134.87.0.58 (345-ix-cr1-ubcab.vncv1.bc.net): Upstream
6. (Hops after BCNet removed for simplicity)

Selecting a different destination IP will replace the 4th hop above (after leaving UBC 137.82.88.125). This indicates that 137.82.88.125 is peered with BCNet and receives a full IPv4 table that directs routes to diffrerent BCNet transit servers.

Inbound (From external):

1. (Hops prior to BCNet removed for simplicity)
2. 134.87.0.57 (345-ix-ubcab-cr1.vncv1.bc.net): Upstream
3. 137.82.88.122: External inbound that peers with BCNet?
4. 142.103.204.197: Similar to 142.103.204.198, WiFi router, but for inbound?
5. ???: Guess to be 10/8 gateway for WiFi?
7. 206.87.130.254 (eduroam)

### pender.students.cs.ubc.ca (198.162.33.17/24) <-> external

Note: this server (pender.students.cs.ubc.ca) has two IP addresses: `198.162.33.17` and `198.162.33.37`. We are using former as src IP because it is the default route on this server, although remote.students.cs.ubc.ca resolves to the later IP. Both IPs drop ICMP echo requests after a0-a3.net.ubc.ca.

Outbound (To external):

1. 198.162.33.253 (Gateway, cs-net-33-router2.cs.ubc.ca): On-link gateway?
2. 137.82.73.5: ???
3. 142.103.78.250 (a0-a1.net.ubc.ca): Common router that makes routing decisions?
4. 137.82.88.125: External outbound that peers with BCNet and has IPv4 full table?
5. 134.87.0.58 (345-ix-cr1-ubcab.vncv1.bc.net): Upstream
6. (Hops after BCNet removed for simplicity)

Inbound (From external): Complete inbound impossible because hops after a0-a1.net.ubc.ca are dropped.

1. (Hops prior to BCNet removed for simplicity)
2. 134.87.0.57 (345-ix-ubcab-cr1.vncv1.bc.net): Upstream
3. 137.82.88.122: External inbound that peers with BCNet?
3. 142.103.78.250 (a0-a1.net.ubc.ca): Common router that makes routing decisions?
5. (Hops after a1-a0.net.ubc.ca are dropped)

### External -> dsci-100-instructor.stat.ubc.ca (142.103.37.173)

1. (Hops prior to BCNet removed for simplicity)
2. 134.87.0.57 (345-ix-ubcab-cr1.vncv1.bc.net): Upstream
3. 137.82.88.121: External inbound that peers with BCNet?
5. 142.103.78.121: Some dept routers?
6. 137.82.221.70: Some dept routers?
7. ???: Some dept routers?
8. ???: Some dept routers?
9. 142.103.37.253 (gw-37pri.stat.ubc.ca)
10. 142.103.37.173 (dsci-100-instructor.stat.ubc.ca)

## `eduroam` <-> dept servers

### pender.students.cs.ubc.ca (198.162.33.17/24) <-> `eduroam` (206.87.130.254/21)

To eduroam:

1. 198.162.33.253 (Gateway, cs-net-33-router2.cs.ubc.ca): On-link gateway?
2. 137.82.73.5: ???
3. 142.103.78.250 (a0-a1.net.ubc.ca): Common router that makes routing decisions?
4. 142.103.204.197: Similar to 142.103.204.198, WiFi router, but for inbound?
5. 10.45.25.134: Yet-another gateway for WiFi?
7. 206.87.130.254 (eduroam)

From eduroam:

1. 206.87.135.254 (Gateway): On-link gateway
2. 10.20.216.30: Common gateway for WiFi?
3. 142.103.204.198: Common router for WiFi that makes routing decisions to various UBC subnets or external router?
4. 142.103.78.249 (a1-a0.net.ubc.ca)
5. (Hops after a1-a0.net.ubc.ca are dropped)

### `eduroam` (206.87.130.254/21) -> www.cs.ubc.ca (142.103.6.5)

1. 206.87.135.254 (Gateway): On-link gateway
2. 10.20.216.30: Common gateway for WiFi?
3. 142.103.204.198: Common router for WiFi that makes routing decisions to various UBC subnets or external router?
4. 142.103.78.250 (a0-a1.net.ubc.ca): Common router that makes routing decisions?
5. 137.82.73.13
6. 142.103.6.5 (www.cs.ubc.ca)

### `eduroam` (206.87.130.254/21) -> phys119.phas.ubc.ca (142.103.51.11)

1. 206.87.135.254 (Gateway): On-link gateway
2. 10.20.216.30: Common gateway for WiFi?
3. 142.103.204.198: Common router for WiFi that makes routing decisions to various UBC subnets or external router?
4. 142.103.78.2 (l0-a0.net.ubc.ca): Common router that makes routing decisions?
5. 142.103.78.121: Some dept routers?
6. 137.82.221.174: Some dept routers?
7. ???: Some dept routers?
8. ???: Some dept routers?
9. 142.103.51.253: Some dept routers?
10. 142.103.51.11 (phys119.phas.ubc.ca)

### `eduroam` (206.87.130.254/21) -> dsci-100-instructor.stat.ubc.ca (142.103.37.173)

1. 206.87.135.254 (Gateway): On-link gateway
2. 10.20.216.30: Common gateway for WiFi?
3. 142.103.204.198: Common router for WiFi that makes routing decisions to various UBC subnets or external router?
4. 142.103.78.2 (l0-a0.net.ubc.ca): Common router that makes routing decisions?
5. 142.103.78.121: Some dept routers?
6. 137.82.221.70: Some dept routers?
7. ???: Some dept routers?
8. ???: Some dept routers?
9. 142.103.37.253 (gw-37pri.stat.ubc.ca)
10. 142.103.37.173 (dsci-100-instructor.stat.ubc.ca)


We can conclude that:

1. All outbound traffics go through `137.82.88.125`, which is peered with BCNet. From BGP.HE.NET, BCNet (AS271) is the only upstream UBC uses.
2. `ubcvisitor` likely does SNAT on its first hop (direct gateway on-link). Although this can't be seen from the traceroute, I would design in such way if I were the IT.

