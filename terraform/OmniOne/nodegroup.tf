resource "aws_iam_role" "eks_node" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_security_group" "node_group_sg" {
  name = "${var.cluster_name}-worker"
  description = "Allow inboud traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow nodes to communicate with each other"
    from_port = 0
    to_port = 65535
    protocol = "-1"
  }

ingress {
    from_port = 1025
    to_port = 65535
    protocol = "tcp"
  }

ingress {
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  security_groups = [aws_eks_cluster.main.vpc_config[0].cluster_security_group_id]
}

ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to your specific needs
}

egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = "${var.cluster_name}-node"
    "kubernetes.io/cluster/${var.cluster_name}-cluster" = "owned"
  }
}

resource "aws_key_pair" "this" {
  count      = length(var.ssh_pub_key) > 0 ? 1 : 0
  key_name   = "${var.cluster_name}-key"
  public_key = var.ssh_pub_key
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = module.vpc.private_subnets
  #capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = var.instance_types

  update_config {
    max_unavailable = 1
  }

  dynamic "remote_access" {
    for_each = var.ec2_key_name != "" ? [1] : []
    content {
      ec2_ssh_key = var.ec2_key_name
      # Optional: restrict who can SSH by providing SGs that allow port 22 from your IPs
      # source_security_group_ids = [aws_security_group.ssh_from_me.id]
    }
  }

  tags = {
    "Name" = "${var.cluster_name}-ng"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_eks_cluster.main
  ]
}