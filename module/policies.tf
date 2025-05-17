# Latest addition
resource "aws_iam_policy" "autoscaling" {
  name        = "${var.clusterName}-autoscaling"
  description = "My autoscaling policy"
  policy      = file("./policy/autoscale-policy.json")
}

resource "aws_iam_policy" "loadBalancing" {
  name        = "${var.clusterName}-loadBalancing"
  description = "My loadBalancing policy"
  policy      = file("./policy/alb-policy.json")
}