resource "aws_iam_role" "iam_for_lambda" {
  name = "tf-${terraform.workspace}-iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dynamoDB-put" {
  name        = "tf-${terraform.workspace}-dynamoDB-put"
  role   = "${aws_iam_role.iam_for_lambda.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamoDB:putItem"
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.calculator-db.arn}"
    }
  ]
}
EOF
}


resource "aws_iam_role" "iam_for_sfn" {
  name = "tf-${terraform.workspace}-iam_for_sfn"

  assume_role_policy = "${data.aws_iam_policy_document.sfn_assume_role_policy_document.json}"
}



// Assume role policy document
data "aws_iam_policy_document" "sfn_assume_role_policy_document" {

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "states.amazonaws.com",
        "events.amazonaws.com"
      ]
    }
  }
}



resource "aws_iam_role_policy" "lambda-execution" {
  name        = "tf-${terraform.workspace}-lambda-execution"
  role   = "${aws_iam_role.iam_for_sfn.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:InvokeFunction",
        "states:StartExecution"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}