# WiFi

UBC Offers students with `ubcsecure`, `eduroam`, `ubcprivate`, and `ubcvisitor` WiFi SSIDs.

They are all 802.11n and 802.11ac. No 802.11ax deployment is found yet.

A new SSID called `ubcIoT` was discovered in late Aug 2024, but I'm unclear for its uses.

## `ubcsecure` and `eduroam` RADIUS

WPA-Enterprise (WPA-EAP) + PEAP + MSCHAPV2.

RADIUS server cert:

* Issuer: `C=US, O=DigiCert Inc, OU=www.digicert.com, CN=DigiCert Global Root CA`
* Subject: `secure.wireless.ubc.ca`

Username: CWL (for `ubcsecure`) or `CWL@ubc.ca` (for `eduroam`).

eduroam needs the domain part in the username to forward RADIUS traffic to the UBC servers.
Depending on the school providing eduroam, they may present additional certs before connecting to UBC servers. Accept them.

Note that you have to use `phase1="peaplabel=0"` if using wpa_supplicant. This makes it impossible to use iwd.

Sample conf:

```
network={
	ssid="eduroam"
	scan_ssid=1
	key_mgmt=WPA-EAP
	eap=PEAP
	identity="yuutaw@ubc.ca"
	password=P""
	ca_cert="/etc/ssl/public/DigiCertGlobalRootCA.crt.pem"
	domain_match="secure.wireless.ubc.ca"
	phase1="peaplabel=0"
	phase2="auth=MSCHAPV2"
	mesh_fwding=1
	ieee80211w=1
}

network={
	ssid="ubcsecure"
	scan_ssid=1
	key_mgmt=WPA-EAP
	eap=PEAP
	identity="yuutaw"
	password=P""
	ca_cert="/etc/ssl/public/DigiCertGlobalRootCA.crt.pem"
	domain_match="secure.wireless.ubc.ca"
	phase1="peaplabel=0"
	phase2="auth=MSCHAPV2"
	ieee80211w=1
}
```

> The `P` after `password=` escapes any special characters (excluding `"`) in the password string. Read more on wpa_supplicant manual.

## 802.11w

A few APs (namely the ones in SWNG building) require 802.11w to be enabled. By default, `wpa_supplicant` disables this feature, so it cannot connect to `ubcsecure` or `eduroam` in SWNG with error `skip RSN IE - no mgmt frame protection enabled but AP requires it`. We need to set `ieee80211w=` to `1` or `2` to enable this feature. Read more on https://wiki.archlinux.org/title/Wpa_supplicant#Debugging_connection_failures and the default wpa_supplicant.conf comments.

## IP

Both `ubcsecure` and `eduroam` assign public IPs to the client, and there is no NAT (the external IP is the same as the IP assigned to the NIC). It is quite rare in 2024 to see globally routable IPs directly assigned to even mobile devices. Good job!

All public IPs have rDNS in the form of `dhcp-aaa-bbb-ccc-ddd.ubcsecure.wireless.ubc.ca`. We can easily discover all `ubcsecure` ranges by looking at the rDNS records for AS393249 announced prefixes. The ranges are:

* 128.189.24.0/22 (announced within 128.189.0.0/16)
* 128.189.16.0/20 (announced within 128.189.16.0/20)
* 128.189.64.0/19 (announced within 128.189.64.0/19)
* 128.189.128.0/18 (announced within 128.189.128.0/18), partially used for ResNet
* 128.189.192.0/18 (announced within 128.189.192.0/18)
* 206.12.40.0/21 (announced within 206.12.40.0/21)
* 206.12.52.0/22 (announced within 206.12.52.0/22)
* 206.12.64.0/20 (announced within 206.12.64.0/20)
* 206.12.136.0/21 (announced within 206.12.136.0/21)
* 206.12.160.0/21 (announced within 206.12.160.0/21)
* 206.87.96.0/19 (announced within 206.87.96.0/19)
* 206.87.128.0/19 (announced within 206.87.128.0/19)
* 206.87.192.0/19 (announced within 206.87.192.0/19)

Note:

1. That's a LOT. UBC is indeed wasting lots of public IPv4's on their WiFi though.
2. I got the results from bgp.he.net, which truncates DNS results to the first 1000 IPs within a range. The results may not be accurate, but it should be similar.

## Firewall

All IPs drop inbound traffic except for ICMP echo request. ~~They are making you believe that you can open up servers in your dorm but soon you will discover that it's only ICMP.~~

## DHCP

| Environment                 | Address          | DHCP Relay Agent IP | Server Id  | Router         | DNS                      | Time Server + NTP Server                                                      | Lease Time | Domain Name     |
|-----------------------------|-----------------|----------------|------------|----------------|--------------------------|-------------------------------------------------------------------------------|------------|-----------------|
| Brock Commons South eduroam | 206.87.128.0/21 | 206.87.135.224 | 137.82.1.2 | 206.87.135.224 | 137.82.1.2, 143.103.1.42 | 137.82.1.82, 206.87.30.209, 137.82.1.1, 142.103.1.1, 137.82.1.2, 142.103.1.42 | 600        | wireless.ubc.ca |
| SWING eduroam | 128.189.232.0/21 | 128.189.239.254 | 137.82.1.2 | 128.189.239.254 | 137.82.1.2, 143.103.1.42 | Not requested | 600        | wireless.ubc.ca |
| SWING ubcvisitor | 10.43.0.0/16 | 128.189.239.254 | 137.82.1.2 | 10.43.255.254 | 137.82.1.2, 143.103.1.42 | 137.82.1.82, 206.87.30.209, 137.82.1.1, 142.103.1.1, 137.82.1.2, 142.103.1.42 | 476        | ubcvisitor.wireless.ubc.ca |

DHCP requests with `ciaddr != associated 802.11 station MAC` will be dropped.

Seems like `eduroam` is giving really long leases. Like, the leases themselves are short but machines tend to get the same IP after renewal.

## `ubcvisitor`

After the portal, the client will be disassociated with `reason=252`. You have to associate again to get network access.

DHCP IP: `10.43.227.188/16`

External IP: `206.12.14.206`

Access to `ubcsecure` IPs are blocked, even including ICMP echo request packets are dropped.

## Access Points

APs seem to be all Cisco. TODO document all AP names and MAC addrs.

| Location | AP Name | AP Model | ubcsecure BSSIDs | eduroam BSSIDs | ubcvisitor BSSIDs | ubcIoT BSSIDs |
|----------|---------|----------|------------------|----------------|-------------------|---------------|
|          |         |          |                  |                |                   |               |
|          |         |          |                  |                |                   |               |
|          |         |          |                  |                |                   |               |

Scan result in SWING 121 on Sept. 6 / 2024:

```
bssid / frequency / signal level / flags / ssid
e4:38:7e:42:18:e9	5745	-49	[ESS]	ubcvisitor
38:91:b7:8a:13:ed	5320	-39	[WPA2-PSK-CCMP][ESS]	ubcIoT
38:91:b7:8a:13:ef	5320	-40	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	eduroam
38:91:b7:8a:13:ee	5320	-40	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
38:91:b7:8a:13:eb	5320	-40	[WPA2-PSK-CCMP][ESS]	
38:91:b7:8a:13:ea	5320	-40	[WPA2-EAP+FT/EAP-CCMP][ESS]	ubcprivate
34:5d:a8:f5:9e:4a	5500	-48	[WPA2-EAP+FT/EAP-CCMP][ESS]	ubcprivate
34:5d:a8:f5:9e:4f	5500	-49	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	eduroam
34:5d:a8:f5:9e:4e	5500	-49	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
e4:38:7e:42:18:ed	5745	-49	[WPA2-PSK-CCMP][ESS]	ubcIoT
e4:38:7e:42:18:ea	5745	-49	[WPA2-EAP+FT/EAP-CCMP][ESS]	ubcprivate
e4:38:7e:42:18:ef	5745	-50	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	eduroam
e4:38:7e:42:18:ee	5745	-50	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
38:91:b7:8a:13:e0	2437	-46	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	eduroam
38:91:b7:8a:13:e1	2437	-47	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
34:5d:a8:f5:9e:40	2462	-55	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	eduroam
34:5d:a8:f5:9e:41	2462	-55	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
34:5d:a8:f5:9e:42	2462	-55	[WPA2-PSK-CCMP][ESS]	ubcIoT
34:5d:a8:f5:9e:45	2462	-55	[WPA2-EAP+FT/EAP-CCMP][ESS]	ubcprivate
34:5d:a8:f5:9e:44	2462	-55	[WPA2-PSK-CCMP][ESS]	
e4:38:7e:42:18:e0	2412	-56	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	eduroam
e4:38:7e:42:18:e1	2412	-56	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
e4:38:7e:42:18:e2	2412	-56	[WPA2-PSK-CCMP][ESS]	ubcIoT
e4:38:7e:42:18:e5	2412	-56	[WPA2-EAP+FT/EAP-CCMP][ESS]	ubcprivate
e4:38:7e:42:18:e4	2412	-56	[WPA2-PSK-CCMP][ESS]	
c8:28:e5:b6:70:0d	5180	-77	[WPA2-PSK-CCMP][ESS]	ubcIoT
c8:28:e5:b6:70:0a	5180	-77	[WPA2-EAP+FT/EAP-CCMP][ESS]	ubcprivate
38:91:b7:8d:2e:8f	5805	-77	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	eduroam
38:91:b7:8d:2e:8e	5805	-77	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
38:91:b7:8d:2e:84	2412	-70	[WPA2-PSK-CCMP][ESS]	
c8:28:e5:b6:70:00	2412	-70	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	eduroam
c8:28:e5:b6:70:01	2412	-70	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
c8:28:e5:b6:70:02	2412	-70	[WPA2-PSK-CCMP][ESS]	ubcIoT
c8:28:e5:b6:70:04	2412	-70	[WPA2-PSK-CCMP][ESS]	
c8:28:e5:b6:70:05	2412	-70	[WPA2-EAP+FT/EAP-CCMP][ESS]	ubcprivate
c8:28:e5:b6:70:0b	5180	-78	[WPA2-PSK-CCMP][ESS]	
c8:28:e5:b6:70:0e	5180	-78	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
38:91:b7:8d:2e:80	2412	-71	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	eduroam
38:91:b7:8d:2e:81	2412	-71	[WPA2-EAP+FT/EAP+EAP-SHA256-CCMP][ESS]	ubcsecure
38:91:b7:8d:2e:85	2412	-72	[WPA2-EAP+FT/EAP-CCMP][ESS]	ubcprivate
38:91:b7:8d:2e:82	2412	-72	[WPA2-PSK-CCMP][ESS]	ubcIoT
38:91:b7:8d:2e:8d	5805	-79	[WPA2-PSK-CCMP][ESS]	ubcIoT
38:91:b7:8d:2e:8b	5805	-79	[WPA2-PSK-CCMP][ESS]	
38:91:b7:8a:13:e9	5320	-40	[ESS]	ubcvisitor
34:5d:a8:f5:9e:49	5500	-48	[ESS]	ubcvisitor
34:5d:a8:f5:9e:46	2462	-55	[ESS]	ubcvisitor
e4:38:7e:42:18:e6	2412	-56	[ESS]	ubcvisitor
c8:28:e5:b6:70:09	5180	-77	[ESS]	ubcvisitor
c8:28:e5:b6:70:06	2412	-70	[ESS]	ubcvisitor
38:91:b7:8d:2e:86	2412	-72	[ESS]	ubcvisitor
38:91:b7:8d:2e:89	5805	-79	[ESS]	ubcvisitor
```
