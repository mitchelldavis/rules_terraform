package(default_visibility = ["//visibility:public"])
load("//rules_terraform:def.bzl", "terraform_plan")

terraform_plan(
	name = "test",
	srcs = glob(["*.tf"])
)
