output "rancher_public_dns" {
    value = aws_instance.rancher.public_dns
}