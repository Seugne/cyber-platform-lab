# -----------------------------------------------------------------------------
# Identity and Region information used by governance resources
# -----------------------------------------------------------------------------

data "aws_caller_identity" "governance" {}

data "aws_region" "governance" {}

data "aws_partition" "governance" {}
