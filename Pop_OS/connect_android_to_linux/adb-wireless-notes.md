# ADB over Wi-Fi — reference notes

## How it works

- `adbd` is the ADB daemon running on the phone. By default it only listens over **USB**.
- `adb tcpip 5555` (sent over USB) tells adbd to restart and **also listen on TCP port 5555**
  on the phone's Wi-Fi interface.
- `adb connect <ip>:5555` makes the adb server on the PC open a TCP connection to that port.
  From then on, every adb command (shell, install, uiautomator2...) goes over Wi-Fi.
- The USB cable is only needed to flip that switch. Once adbd is listening, the cable can go.

### Why it failed before
- `Connection refused` = the PC reached the phone's IP, but nothing was listening on 5555.
  Either adbd wasn't in TCP mode (phone rebooted), or that IP belongs to a different device.
- The phone's IP had changed (.101 -> .143). The router hands out addresses dynamically (DHCP).

### What resets it
- **Phone reboot** -> adbd goes back to USB-only. Need `adb tcpip 5555` over USB again.
- **Router gives a new IP** -> old `adb connect` address stops working.
- Turning USB debugging off.

## Setup (classic, port 5555)

```fish
# 1. plug phone in via USB, accept the "Allow USB debugging" prompt
adb devices

# 2. switch adbd to TCP mode
adb tcpip 5555

# 3. get the phone's Wi-Fi IP
adb shell ip -f inet addr show wlan0        # look for: inet 192.168.1.xxx/24

# 4. unplug, then connect
adb connect 192.168.1.xxx:5555
adb devices                                 # should list 192.168.1.xxx:5555  device
```

### One-shot fish version
```fish
adb tcpip 5555
sleep 2
set ip (adb shell ip -f inet addr show wlan0 | string match -rg 'inet (\d+\.\d+\.\d+\.\d+)')
adb connect $ip:5555
```

## Multiple devices

With more than one device attached, adb needs `-s <serial-or-ip:port>`:

```fish
adb devices                                  # lists serials (USB) and ip:port (Wi-Fi)
adb -s R5GL74546KY tcpip 5555                # target a specific USB device
adb -s 192.168.1.143:5555 shell              # target a specific Wi-Fi device
```

uiautomator2 (Python):
```python
import uiautomator2 as u2
d = u2.connect("192.168.1.143:5555")         # be explicit when >1 device is attached
```

## Alternative: Android 11+ "Wireless debugging" (no cable ever)

- Settings -> Developer options -> **Wireless debugging** -> on.
- Uses a **random port**, not 5555, and the port changes each time it's toggled.

```fish
# first time only: "Pair device with pairing code"
adb pair 192.168.1.xxx:<pairing-port>        # enter the 6-digit code

# then use the IP:port shown on the main Wireless debugging screen
adb connect 192.168.1.xxx:<connect-port>
```

## Troubleshooting

| Symptom | Cause / fix |
|---|---|
| `Connection refused` | adbd not in TCP mode (reboot?) or wrong IP. Replug USB, `adb tcpip 5555`, recheck IP. |
| Refused right after `tcpip` | adbd still restarting. Wait 2-3 s and retry. |
| `unauthorized` | Unlock phone, accept the debugging prompt. |
| `more than one device/emulator` | Add `-s <serial>` or unplug the USB cable. |
| Connect hangs / times out | Different networks, guest Wi-Fi, or router client isolation. |
| Weird state | `adb kill-server; adb start-server` |
| Disconnect a Wi-Fi device | `adb disconnect 192.168.1.xxx:5555` |

## Make it stick

- Give each phone a **DHCP reservation** (static IP) in the router so the address never changes.
- After a phone reboot, the TCP mode is gone: plug in once and `adb tcpip 5555` again
  (or use Wireless debugging, which survives without a cable but needs the new port).
