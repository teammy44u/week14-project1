resource "aws_iam_role" "ec2-access-to-s3" {
  name = "ec2-access-to-s3"
  assume_role_policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach-s3-policy" {
  role       = aws_iam_role.ec2-access-to-s3.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "allow-s3-to-ec2" {
  name = "allow-s3-to-ec2"
  role = aws_iam_role.ec2-access-to-s3.name
}