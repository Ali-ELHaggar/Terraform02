output "Apache-EC2-IP" {
value = aws_instance.ec2-Apache.private_ip
}


output "Nginx-EC2-IP" {
value = aws_instance.ec2-Nginx.public_ip
}