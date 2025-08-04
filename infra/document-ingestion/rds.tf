resource "aws_db_instance" "default" {
  allocated_storage = 20
  db_name           = "vecdb"
  engine            = "postgres"
  engine_version    = "17"
  instance_class    = "db.t3.micro"
  username          = "postgres"
  password          = "postgres"
  #   db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot = true
  publicly_accessible = true
}

# resource "aws_db_subnet_group" "default" {
#   name       = "law-pdf-demo"
#   subnet_ids = module.vpc.private_subnets

#   tags = {
#     Name = "law-pdf-demo"
#   }
# }
