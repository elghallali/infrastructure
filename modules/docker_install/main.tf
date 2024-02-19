resource "null_resource" "ssh_target" {
    connection {
      type = "ssh"
      user = var.ssh_user
      host = var.ssh_host
      private_key = file(var.ssh_key)
    }
    provisioner "remote-exec" {
        inline = [
          "echo ${var.pw} | sudo -S apt-get update",
          "for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done",
          # Add Docker's official GPG key:
          "sudo apt-get update",
          "sudo apt-get install ca-certificates curl",
          "sudo install -m 0755 -d /etc/apt/keyrings",
          "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
          "sudo chmod a+r /etc/apt/keyrings/docker.asc",

          # Add the repository to Apt sources:
          "echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu   jammy stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
          "sudo apt-get update",
          "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
          
        ]
      
    }
    provisioner "file" {
      source =  "${path.module}/startup-options.conf"
      destination = "/tmp/startup-options.conf"
    }

    provisioner "remote-exec" {
        inline = [ 
            "echo ${var.pw} | sudo -S apt-get update",
            "sudo mkdir -p /etc/systemd/system/docker.system.d",
            "sudo cp /tmp/startup-options.conf /etc/systemd/system/docker.system.d/startup-options.conf",
            "sudo systemctl daemon-reload",
            "sudo systemctl restart docker",
            "sudo usermod -aG docker ${var.ssh_user}"
         ]
      
    }
}