%title: My musings on remote access
%author: heywoodlh

-> ## Remote access to your Linux machines <-

-> An introduction on securely accesing your machines remotely <-

---

-> ## Secure Shell (SSH) <-

SSH is the common way to remotely access almost every non-Windows system.
The concept behind SSH is simple: access the command line of a remote machine.

You can login to a remote SSH server using the `ssh` command on your machine:

```
ssh heywoodlh@192.168.2.66
```

---

-> SSH demo <-

Fun demo, you can login to the user group's Discord and send messages using SSH:

```
ssh chat.culug.group
```

---

-> Remote desktop <-

There are multiple servers+clients for accessing a desktop remotely:
- Microsoft Remote Desktop (RDP): built into Windows, available for MacOS+Linux
- VNC: the protocol used by MacOS' Screen Sharing, available for MacOS+Linux
- Many more: https://en.wikipedia.org/wiki/Comparison_of_remote_desktop_software

RDP is the usual method Windows admins use to remotely manage Windows servers.

---

-> ## VPN (Virtual Private Network) <-

A VPN provides a way to remotely access a network you are not physically connected to. You can run a VPN server on your own hardware or use a VPN service provider.

Reasons people run a VPN:
- Secure access to remote networks
- Privacy/anonymity

Some common VPN protocols (that you can run on your own hardware, even):
- WireGuard (my preference)
- OpenVPN
- IPSec
- OpenSSH: https://wiki.archlinux.org/title/VPN_over_SSH

---

-> ## VPN pt. 2 <-

| Hosted VPN | Function                          |
|------------|-----------------------------------|
| Tailscale  | Remote access                     |
| Cloudflare | Remote access + anonymity         |
| ProtonVPN  | Anonymity                         |
| NordVPN    | Being a sponsor of Youtube videos |

I recommend Tailscale for remote access because it's so simple to setup.

Cloudflare has multiple VPN products that overlap between remote access and anonymity. That's why I didn't list just one of their VPN products.

---
