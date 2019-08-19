package(default_visibility = ["//visibility:public"])
load("@io_bazel_rules_terraform//rules_terraform:def.bzl", 
	 "setup_terraform_toolchains"
)

setup_terraform_toolchains()

filegroup(
    name = "hashicorp_pub",
    srcs = [
        ":hashicorp.pub"
    ]
)
