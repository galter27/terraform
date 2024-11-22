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
    # Allow SSH access (for management and troubleshooting)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow access to Kubernetes API (Master Node)
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow communication between nodes (pods need to communicate across nodes)
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow communication for Flannel VXLAN (if using Flannel CNI)
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow communication for NodePort services
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
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


