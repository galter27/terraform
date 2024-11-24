resource "aws_instance" "k8s_node1" {
  ami                    = "ami-02cefb184066d69d9" 
  instance_type          = "t3.micro"
  key_name = "terraform-key"
  associate_public_ip_address = true
  vpc_security_group_ids     = [aws_security_group.k8s_sg.id]
  tags = {
    Name        = "k8s-node1"
    Environment = "dev"
    Role        = "k8s"
  }
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  dynamic "ebs_block_device" {
    for_each = var.create_ebs ? [1] : []
    content {
      device_name = "/dev/xvdf"
      volume_size = var.ebs_volume_size
      volume_type = "gp3"
    }
  }
}

resource "aws_instance" "k8s_node2" {
  ami                    = "ami-02cefb184066d69d9" 
  instance_type          = "t3.micro"
  key_name = "terraform-key"
  associate_public_ip_address = true
  vpc_security_group_ids     = [aws_security_group.k8s_sg.id]
  tags = {
    Name        = "k8s-node2"
    Environment = "dev"
    Role        = "k8s"
  }
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  dynamic "ebs_block_device" {
    for_each = var.create_ebs ? [1] : []
    content {
      device_name = "/dev/xvdg"
      volume_size = var.ebs_volume_size
      volume_type = "gp3"
    }
  }
}


resource "aws_security_group" "k8s_sg" {
  name        = "k8s-cluster-sg"
  description = "Security group for Kubernetes EC2 instances"

  ingress {
    # Allow SSH access 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    # Kubernetes API
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Etcd server client API
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Kubelet API
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Kube-Scheduler
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Kube-controller manager
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Kube-proxy manager
    from_port   = 10256
    to_port     = 10256
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    # Allow communication for NodePort services
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Calico Border Gateway Protocol
    from_port   = 179
    to_port     = 179
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Calico VXLAN
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # Allow all outbound traffic (default behavior)
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "K8s Cluster Security Group"
    Environment = "dev"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-k8s-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-k8s-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_policy" "k8s_policy" {
  name = "k8s-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:ListBucket", "ec2:DescribeInstances"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "custom_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.k8s_policy.arn
}


