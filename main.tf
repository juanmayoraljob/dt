provider "aws" {
    region = "sa-east-1"
}

resource "aws_instance" "srv1_apache" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.priv_subnet_ws.id
    vpc_security_group_ids = [aws_security_group.webservers.id]
    user_data = "${file("install_apache.sh")}"

  tags = {
    Name = var.instance_name_apache
  }
  }

resource "aws_instance" "srv2_nginx" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.priv_subnet_ws.id
    vpc_security_group_ids = [aws_security_group.webservers.id]
    user_data = "${file("install_nginx.sh")}"
  tags = {
    Name = var.instance_name_nginx
  }
  }

resource "aws_lb" "alb" {
    load_balancer_type = "application"
    name = "lb"
    security_groups = [aws_security_group.alb.id]
    subnets = [ aws_subnet.pub_subnet_sa1a.id,aws_subnet.pub_subnet_sa1c.id ]
}

resource "aws_lb_target_group" "this" {
    name = "alb-target-group"
    port = 80
    vpc_id = aws_vpc.srv_vpc.id
    protocol = "HTTP"

    health_check {
      enabled = "true"
      matcher = "200"
      path = "/"
      port = "80"
      protocol = "HTTP"
    }
}

resource "aws_lb_target_group_attachment" "apache" {
    target_group_arn     = aws_lb_target_group.this.arn
    target_id            = aws_instance.srv1_apache.id  
    port = 80
}
resource "aws_lb_target_group_attachment" "nginx" {
    target_group_arn     = aws_lb_target_group.this.arn
    target_id            = aws_instance.srv2_nginx.id  
    port = 80
}

resource "aws_lb_listener" "this" {
    load_balancer_arn    = aws_lb.alb.arn
    port                 = 80
    protocol             = "HTTP"
    
    default_action {
        target_group_arn = aws_lb_target_group.this.arn
        type             = "forward"

    }
}