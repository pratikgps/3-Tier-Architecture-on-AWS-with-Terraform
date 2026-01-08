resource "aws_db_subnet_group" "this" {
  name_prefix = "${var.name}-subnet-"
  subnet_ids  = var.subnets

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.name}-rds-sg-"
  vpc_id      = var.vpc_id

  # ✅ Allow DB access ONLY from ECS SG (recommended)
  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-rds-sg"
  }
}

resource "aws_db_instance" "this" {
  identifier              = var.name
  engine                  = var.engine
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage

  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds.id]

  username                = var.db_username
  password                = var.db_password
  port                    = var.port

  publicly_accessible     = false
  multi_az                = true
  skip_final_snapshot     = true

  tags = {
    Name = var.name
  }
}