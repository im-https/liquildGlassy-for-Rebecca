# LiquildGlassy for Rebecca

Custom subscription page templates for **TX-UI / Rebecca Panel**, designed by the TX Community.

## Quick Install

Install a pre-designed subscription theme with one command:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/im-https/liquildGlassy-for-Rebecca/main/install.sh)
```

## Supported Languages

* 🇬🇧 English — Default
* 🇮🇷 فارسی

## Supported Protocols

The subscription templates can be used with services supporting:

* VMess
* VLESS
* OpenVPN
* WireGuard
* L2TP/IPsec
* PPTP
* IKEv2
* AnyConnect
* SSH

## Available Variables

| Variable       | Description                       |
| -------------- | --------------------------------- |
| `result`       | Vmess/Vless subscription URI      |
| `emails`       | Client emails in the subscription |
| `total`        | Total traffic                     |
| `expire`       | Expiration date as timestamp      |
| `upload`       | Uploaded traffic                  |
| `download`     | Downloaded traffic                |
| `totalByte`    | Total traffic in bytes            |
| `uploadByte`   | Uploaded traffic in bytes         |
| `downloadByte` | Downloaded traffic in bytes       |
| `sId`          | Subscription user ID              |
| `subUrl`       | Full subscription URL             |
| `jsonUrl`      | Subscription JSON URL             |

### Example

```html
<div>Subscription URL: {{ .subUrl }}</div>
```

## Installation

1. Create your custom HTML template and name it:

```text
sub.html
```

2. Copy it to:

```text
/var/lib/rebecca/templates/subscription
```

3. Open the panel settings.

4. Go to **Subscription** and enable **Custom Template**.

5. Save the settings and restart the panel service.

Your custom subscription page should now be displayed instead of the default page.

## Themes

### liquildGlassy — Green / English / Light

![liquildGlassy green theme](./screenshots/liquildGlassy-green.png)

### liquildGlassy — Pink / English / Light

![liquildGlassy English light theme](./screenshots/liquildGlassy.png)

### liquildGlassy — Green / فارسی / Dark / Mobile

![liquildGlassy Persian dark mobile theme](./screenshots/liquildGlassy-fa-dark.png)

## Credits

Designed by **[Incognito-Coder](https://github.com/Incognito-Coder)**.
