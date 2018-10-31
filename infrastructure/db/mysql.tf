data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

data "aws_security_group" "prototype" {
  name = "sg_prototype"
}

module "mysql" {
  source = "terraform-aws-modules/rds/aws"
  version = "1.22.0"

  identifier = "${var.namespace}-${var.stage_env}"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.medium"
  allocated_storage = 15
  name              = "infrastructure"
  username          = "${var.db_username}"
  password          = "${var.db_password}"
  port              = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [
    "${data.aws_security_group.default.id}",
    "${data.aws_security_group.prototype.id}"
  ]

  multi_az           = true
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"


  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "${var.namespace}-RDSMonitoringRole"
  create_monitoring_role = true

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  tags = {
    Owner       = "${var.namespace}"
    Environment = "${var.stage_env}"
  }

  # DB subnet group
  subnet_ids = ["${data.aws_subnet_ids.all.ids}"]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.namespace}-db-${var.stage_env}"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name = "character_set_client"
      value = "utf8"
    },
    {
      name = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
