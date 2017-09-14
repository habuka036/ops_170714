resource "null_resource" "gogs" {
  
  provisioner "file" {
    source = "../modules/gogs/gogs-0.11.19-linux_amd64.tar.gz"
    destination = "/tmp/gogs-0.11.19-linux_amd64.tar.gz"
    connection {
      type = "ssh"
      host = "${var.gogs_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
  }

  provisioner "file" {
    source = "../modules/gogs/gogs.service"
    destination = "/tmp/gogs.service"
    connection {
      type = "ssh"
      host = "${var.gogs_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
  }

  provisioner "file" {
    source = "../modules/gogs/gogs-data.tar.gz"
    destination = "/tmp/gogs-data.tar.gz"
    connection {
      type = "ssh"
      host = "${var.gogs_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = "${var.gogs_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
    inline = [
      "cd /var/lib/",
      "sudo tar -xzf /tmp/gogs-0.11.19-linux_amd64.tar.gz",
      "sudo groupadd -r gogs",
      "sudo useradd -r -g gogs -d /var/lib/gogs -s /sbin/nologin gogs",
      "sudo chown gogs. -R /var/lib/gogs",
      "sudo mv /tmp/gogs.service /etc/systemd/system/gogs.service",
      "sudo tar -xzf /tmp/gogs-data.tar.gz -C /var/lib/gogs/",
      "sudo setcap CAP_NET_BIND_SERVICE+ep /var/lib/gogs/gogs",
      "sudo systemctl enable gogs",
      "sudo systemctl start gogs"
    ]
  }
}
