output "url-image" {
  value = module.gozem-test.image-url
}


output "public_ip" {
  value = module.instance-module.public_ip
}

output "public_dns" {
  value = module.instance-module.public_dns
}