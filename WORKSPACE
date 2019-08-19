workspace(name = "io_bazel_rules_terraform")

load("@io_bazel_rules_terraform//rules_terraform:def.bzl", 
	 "terraform_register_toolchains"
)

terraform_register_toolchains(providers={"tls":"1.2.0"})
