module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "jh-terraform-asg"

  min_size                  = 2
  max_size                  = 10
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [aws_subnet.jh-public-subnet-1.id, aws_subnet.jh-public-subnet-2.id]
  security_groups           = [aws_security_group.jh-public-sg.id]

  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "jh-asg-template"
  launch_template_description = "jh-terraform-Launch template example"
  update_default_version      = true

  //Ubuntu Server 18.04 LTS (HVM)
  image_id         = "ami-0ed11f3863410c386"
  instance_type    = "t2.micro"
  user_data_base64 = base64encode(file("user-data.sh"))

  target_group_arns = [aws_lb_target_group.jh-terraform-asg-lb-target-group.arn]
}
