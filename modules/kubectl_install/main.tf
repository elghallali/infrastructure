resource "null_resource" "ssh_target" {
    connection {
      type = "ssh"
      user = var.ssh_user
      host = var.ssh_host
      private_key = file(var.ssh_key)
    }
    provisioner "remote-exec" {
        inline = [ 
            "curl -LO 'https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl'",
            "curl -LO 'https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256'",
            "echo '$(cat kubectl.sha256)  kubectl' | sha256sum --check",
            "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl"
        ]
      
    }
}