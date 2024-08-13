# libreswan-deb-pkg-cloud-config
Create a LibreSwan Debian/Ubuntu Package via a temporary VM/VPS using cloud-config.

## How to use
1. Copy and paste the cloud-init `.yml` contents where applicable for your cloud.  (I make use of Hetzner Cloud, though your cloud may work without any changes necessary.)
2. The LibreSwan source code will be downloaded and compiled.
3. A .DEB package will be generated and served up for download over HTTP/HTTPS.
