# Defino el SG para los webservers, con acceso al purto 80 y salida a internet. 

resource "aws_security_group" "webservers" {
    name    = "webserver-policy"
    vpc_id  = aws_vpc.srv_vpc.id

    ingress {
        description     = "Expongo el puerto 80 hacia el exterior"
        security_groups = [aws_security_group.alb.id]
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        
    }
   egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
        
}

# Defino el SG para el load balancer.

resource "aws_security_group" "alb" {
    name    = "alb-sg"
    vpc_id  = aws_vpc.srv_vpc.id

    ingress {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Acceso al puerto 80 desde el exterior"
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"      
    } 
    egress {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Acceso al puerto 80 de nuestras instancias"
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"      
    } 
}