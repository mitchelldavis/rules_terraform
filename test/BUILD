package(default_visibility = ["//visibility:public"])
load("//rules_terraform:terraform.bzl", "terraform_plan")

terraform_plan(
	name = "test",
	srcs = glob(["*.tf"])
)
