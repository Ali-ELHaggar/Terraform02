data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "ec2-Apache" {
    ami                         = data.aws_ami.ubuntu.id
    instance_type               = "t2.micro"
    subnet_id                   = aws_subnet.subnet-private.id
    vpc_security_group_ids      = [aws_security_group.allow_All.id]
    # associate_public_ip_address = true
    source_dest_check           = false
    user_data                   = file("installApache.sh")
    
}

resource "aws_instance" "ec2-Nginx" {
    ami                         = data.aws_ami.ubuntu.id
    instance_type               = "t2.micro"
    subnet_id                   = aws_subnet.subnet-public.id
    vpc_security_group_ids      = [aws_security_group.allow_All.id]
    associate_public_ip_address = true
    source_dest_check           = false
    user_data                   = file("installNginx.sh")
    
}