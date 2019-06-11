data "template_file" "asg-template" {

  template = "${file("${path.module}/userdata_shell")}"

}

