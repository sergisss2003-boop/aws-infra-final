aws_region   = "us-east-1"
project_name = "aws-infra-final"
environment  = "production"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

instance_type     = "t2.micro"
db_instance_class = "db.t3.micro"

db_name     = "appdb"
db_username = "dbadmin"
db_password = "MiPassword123!"

ami_id = "ami-0c02fb55956c7d316"