load("@io_bazel_rules_terraform//rules_terraform/private:toolchains.bzl",
     _setup_terraform_toolchains = "setup_terraform_toolchains",
     _terraform_register_toolchains = "terraform_register_toolchains"
)
load("@io_bazel_rules_terraform//rules_terraform/private:rules.bzl",
     _terraform_plan = "terraform_plan"
)
setup_terraform_toolchains = _setup_terraform_toolchains
terraform_register_toolchains = _terraform_register_toolchains
terraform_plan = _terraform_plan

