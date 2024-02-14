resource "null_resource" "ssh_target" {
    connection {
      type = "ssh"
      user = var.ssh_user
      host = var.ssh_host
      private_key = file(var.ssh_key)
    }
    provisioner "remote-exec" {
        inline = [ 
            "sudo apt update --qq > /dev/null",
            "curl -fsSL https://get.docker.com -o get-docker.sh",
            "sudo chmod 775 get-docker.sh",
            "sudo ./get-docker.sh > /dev/null"
        ]
      
    }
    provisioner "file" {
      source =  "${path.module}/startup-options.conf"
      destination = "/tmp/startup-options.conf"
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo mkdir -p /etc/systemd/system/docker.system.d",
            "sudo cp /tmp/startup-options.conf /etc/systemd/system/docker.system.d/startup-options.conf",
            "sudo systemctl daemon-reload",
            "sudo systemctl restart docker",
            "sudo usermod -aG docker ${var.ssh_user}"
         ]
      
    }
}