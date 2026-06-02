resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-tf-alexandre-jeusu-mais-devops"

  tags = {
    Name        = "My bucket"
    Environment = "testetando conecimentos ks8 aws "
  }
}