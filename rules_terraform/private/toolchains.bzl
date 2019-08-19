load("@io_bazel_rules_terraform//rules_terraform/private:defs.bzl",
    "terraform_sums_url_template",
    "terraform_sums_sig_url_template",
    "terraform_url_template",
    "terraform_filename_template",
    "toolchains"
)

load("@io_bazel_rules_terraform//rules_terraform/private:repository_rules.bzl",
    "setup_terraform"
)

TerraformInfo = provider(
    doc = "Information on how to call terraform",
    fields = [
        "executable"
    ],
)

def _terraform_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        terraforminfo = TerraformInfo(
            executable = ctx.attr.executable,
        ),
    )
    return [toolchain_info]

terraform_toolchain = rule(
    implementation = _terraform_toolchain_impl,
    attrs = {
        "executable": attr.string()
    }
)

def setup_terraform_toolchains():
    for name, toolchain in toolchains().items():
        terraform_toolchain(
            name = toolchain["name"],
            executable = "",
        )
        native.toolchain(
            name = "{0}_toolchain".format(toolchain["name"]),
            exec_compatible_with = toolchain["exec_compatible_with"],
            target_compatible_with = toolchain["target_compatible_with"],
            toolchain = toolchain["toolchain"],
            toolchain_type = toolchain["toolchain_type"]
        )

def terraform_register_toolchains(version="0.11.11", providers={ }):
    if "download_terraform" not in native.existing_rules():
        setup_terraform(
            name = "terraform_exec",
            version = version,
            providers = providers
        )

    for name, toolchain in toolchains().items():
        native.register_toolchains(
            "//rules_terraform:{0}_toolchain".format(toolchain["name"]),
        )
