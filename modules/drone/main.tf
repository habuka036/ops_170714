resource "null_resource" "drone" {

  provisioner "file" {
    source = "../modules/drone/docker-install.sh"
    destination = "/tmp/docker-install.sh"
    connection {
      type = "ssh"
      host = "${var.drone_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
  }

  provisioner "file" {
    source = "../modules/drone/docker-compose"
    destination = "/tmp/docker-compose"
    connection {
      type = "ssh"
      host = "${var.drone_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
  }

  provisioner "file" {
    source = "../modules/drone/drone"
    destination = "/tmp/drone"
    connection {
      type = "ssh"
      host = "${var.drone_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
  }

  provisioner "file" {
    source = "../modules/drone/drone.sqlite"
    destination = "/tmp/drone.sqlite"
    connection {
      type = "ssh"
      host = "${var.drone_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
  }

  provisioner "file" {
    source = "../modules/drone/drone-server.service"
    destination = "/tmp/drone-server.service"
    connection {
      type = "ssh"
      host = "${var.drone_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
  }

  provisioner "file" {
    source = "../modules/drone/drone-agent.service"
    destination = "/tmp/drone-agent.service"
    connection {
      type = "ssh"
      host = "${var.drone_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = "${var.drone_host}"
      user = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
    }
    inline = [
      "sudo chmod +x /tmp/docker-install.sh",
      "sudo /tmp/docker-install.sh",
      "sudo mv /tmp/docker-compose /usr/local/bin/",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo mv /tmp/drone /usr/local/bin/drone",
      "sudo chmod +x /usr/local/bin/drone",
      "sudo mkdir -p /var/lib/drone",
      "sudo mv /tmp/drone.sqlite /var/lib/drone/drone.sqlite",
      "sed -i -e 's/_DRONE_SECRET/${var.drone_secret}/g' /tmp/drone-server.service",
      "sed -i -e 's/_DRONE_HOST/${var.drone_host}/g' /tmp/drone-server.service",
      "sed -i -e 's/_GOGS_HOST/${var.gogs_host}/g' /tmp/drone-server.service",
      "sudo mv /tmp/drone-server.service /etc/systemd/system/drone-server.service",
      "sudo systemctl enable drone-server",
      "sudo systemctl start drone-server",
      "sed -i -e 's/_DRONE_SECRET/${var.drone_secret}/g' /tmp/drone-agent.service",
      "sudo mv /tmp/drone-agent.service /etc/systemd/system/drone-agent.service",
      "sudo systemctl enable drone-agent",
      "sudo systemctl start drone-agent"
    ]
  }

}

