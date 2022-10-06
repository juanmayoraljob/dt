output "load_balacer" {
    description = "Dominio de nginx"
    value = "http://${aws_lb.alb.dns_name}"
}