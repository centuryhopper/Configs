# uiautomator2 in WSL with adb on Windows

## Summary

Install adb on **Windows**, not in WSL. You only need **platform-tools** (`adb`), not the full Android SDK.

- The phone is plugged into Windows, and WSL2 can't see USB devices without an extra tool.
- Windows owns the device and runs the adb server. WSL talks to that server over the network.

**Why aliasing alone isn't enough:** uiautomator2 doesn't run the `adb` command.
It uses `adbutils`, a Python client that connects straight to the adb server on
`127.0.0.1:5037`. A shell alias does nothing for the Python app. What matters is
whether WSL can reach the Windows adb server, and mirrored networking takes care of that.

---

## Setup

### 1. Install platform-tools on Windows

```powershell
winget install Google.PlatformTools
adb start-server
```

(Or download platform-tools manually and add it to your PATH.)

### 2. Turn on mirrored networking

Add to `C:\Users\leoth\.wslconfig`:

```ini
[wsl2]
networkingMode=mirrored
```

Restart WSL from PowerShell:

```powershell
wsl --shutdown
```

### 3. Use Windows' adb from WSL for manual commands

Add to `~/.config/fish/config.fish`:

```fish
alias adb adb.exe
```

> Don't also install `adb` inside WSL. If two different adb versions share
> port 5037, they keep killing each other's server, and you'll see
> `adb server version doesn't match this client` errors.

### 4. Test from Python in WSL

```python
import uiautomator2 as u2

d = u2.connect()
print(d.info)
```

Without mirrored networking, set `ANDROID_ADB_SERVER_HOST` to the Windows host IP
instead, so adbutils knows where the server is.

---

## What `networkingMode=mirrored` does

**Default (NAT mode):** WSL2 runs inside a small VM behind its own virtual network.
It gets its own private IP (like `172.x.x.x`), separate from Windows.
`localhost` inside WSL means the Linux VM only, not Windows. To reach a server on Windows,
you have to look up the Windows host IP, and that IP can change each time WSL restarts.

**Mirrored mode:** WSL uses the same network interfaces as Windows.

- `127.0.0.1` / `localhost` reaches the same place from both sides. WSL can reach
  services on Windows (adb server on `5037`, databases, etc.), and Windows can
  reach services in WSL.
- WSL has the same IP as Windows on your LAN, so other devices (phone, Pi) can
  reach servers in WSL directly, with no port forwarding.
- It handles VPNs better, and IPv6 works.

**For uiautomator2:**

- **NAT mode:** `127.0.0.1:5037` points to the Linux VM, where no adb server is running, so the connection fails.
- **Mirrored mode:** it reaches the adb server on Windows, so `u2.connect()` just works.

**Watch out:** WSL and Windows now share the same ports. If both try to listen on
the same port (e.g. a dev server on `:8080` on each side), the second one fails
because the port is already in use.

Requires Windows 11 22H2 or newer.

---

## Other options

- **Wireless debugging:** use `adb pair` and `adb connect <phone-ip>:port` over Wi-Fi.
  It doesn't matter where the phone is plugged in, and it's convenient for a bot that
  runs for a long time. It's a little less stable than USB, though.
- **usbipd-win:** passes the USB device through to WSL so you can install
  platform-tools only in WSL. It works, but the device has to be re-attached every
  time it reconnects. That's only worth it if you want WSL to be fully self-contained.
