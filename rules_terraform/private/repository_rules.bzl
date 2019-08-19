load("@io_bazel_rules_terraform//rules_terraform/private:defs.bzl",
    "terraform_sums_url_template",
    "terraform_sums_sig_url_template",
    "terraform_url_template",
    "terraform_filename_template",
    "terraform_provider_sums_url_template",
    "terraform_provider_sums_sig_url_template",
    "terraform_provider_url_template",
    "terraform_provider_filename_template",
    "toolchains"
)

def _get_toolchain(ctx):
    if ctx.os.name == "linux":
        toolchain_name = "terraform_linux"
    elif ctx.os.name == "mac os x":
        toolchain_name = "terraform_osx"
    else:
        fail("Unsupported operating system: " + ctx.os.name)

    return toolchains()[toolchain_name]

def _download_terraform(ctx):
    toolchain = _get_toolchain(ctx)
    version = ctx.attr.version
    host = toolchain["host"]
    arch = toolchain["arch"]

    # Download The SHA256SUM File
    ctx.download(
        url = terraform_sums_url_template.format(version, host),
        output = "terraform_SHA256SUM",
        executable = False
    )

    # Download The SHA256SUM.sig File
    ctx.download(
        url = terraform_sums_sig_url_template.format(version, host),
        output = "terraform_SHA256SUM.sig",
        executable = False
    )
    # Verify the SHA256SUM File Signature.
    result = ctx.execute(
        [
            "./hashicorp_verifier",
            "signature",
            "-key=hashicorp.pub",
            "-sig=terraform_SHA256SUM.sig",
            "-target=terraform_SHA256SUM"
        ],
        quiet = False
    )
    if result.return_code != 0:
        fail("Unable to verify the Terraform executable: {0}".format(result.stderr))

    # Extract the SHA256SUM for Terraform.
    result = ctx.execute(
        [
            "./hashicorp_verifier",
            "extract",
            "-filename={0}".format(
                terraform_filename_template.format(
                    version,
                    host,
                    arch
                )
            ),
            "-shasum=terraform_SHA256SUM"
        ],
        quiet = False
    )
    if result.return_code != 0:
        fail("Unable to extract the Terraform checksum: {0}".format(result.stderr))
    checksum = result.stdout

    # Download the Terraform Executable
    ctx.download_and_extract(
        url = terraform_url_template.format(version, host, arch),
        sha256 = checksum.strip(),
        output = "terraform",
        type = "zip",
    )

def _download_provider(provider_name, version, ctx):
    toolchain = _get_toolchain(ctx)
    host = toolchain["host"]
    arch = toolchain["arch"]

    # Download The SHA256SUM File
    ctx.download(
        url = terraform_provider_sums_url_template.format(provider_name, version, host),
        output = "terraform-provider-{0}_SHA256SUM".format(provider_name),
        executable = False
    )

    # Download The SHA256SUM.sig File
    ctx.download(
        url = terraform_provider_sums_sig_url_template.format(provider_name, version, host),
        output = "terraform-provider-{0}_SHA256SUM.sig".format(provider_name),
        executable = False
    )

    # Verify the SHA256SUM File Signature.
    result = ctx.execute(
        [
            "./hashicorp_verifier",
            "signature",
            "-key=hashicorp.pub",
            "-sig=terraform-provider-{0}_SHA256SUM.sig".format(provider_name),
            "-target=terraform-provider-{0}_SHA256SUM".format(provider_name)
        ],
        quiet = False
    )
    if result.return_code != 0:
        fail("Unable to verify the Terraform executable: {0}".format(result.stderr))

    # Extract the SHA256SUM for Provider.
    result = ctx.execute(
        [
            "./hashicorp_verifier",
            "extract",
            "-filename={0}".format(
                terraform_provider_filename_template.format(
                    provider_name,
                    version,
                    host,
                    arch
                )
            ),
            "-shasum=terraform-provider-{0}_SHA256SUM".format(provider_name)
        ],
        quiet = False
    )
    if result.return_code != 0:
        fail("Unable to extract the Terraform checksum: {0}".format(result.stderr))
    checksum = result.stdout

    # Download the Terraform Executable
    ctx.download_and_extract(
        url = terraform_provider_url_template.format(provider_name, version, host, arch),
        sha256 = checksum.strip(),
        output = "terraform",
        type = "zip",
    )

def _setup_terraform_impl(ctx):
    toolchain = _get_toolchain(ctx)
    version = ctx.attr.version
    providers = ctx.attr.providers
    host = toolchain["host"]
    arch = toolchain["arch"]

    # Setup Build File
    ctx.file("BUILD.bazel",
"""
filegroup(
    name = "terraform_files",
    srcs = ["**/*"],
    visibility = ["//visibility:public"]
)

filegroup(
    name = "terraform_executable",
    srcs = ["terraform/terraform"],
    visibility = ["//visibility:public"]
)
""",
        executable=False
    )

    # Setup Verifier
    ctx.download(
        url = toolchain["verifier_url"],
        sha256 = toolchain["verifier_checksum"],
        output = "hashicorp_verifier",
        executable = True
    )

    # Setup the Public Key
    ctx.symlink(
        Label("@io_bazel_rules_terraform//rules_terraform:hashicorp.pub"),
        "hashicorp.pub"
    )

    _download_terraform(ctx)

    for name, version in providers.items():
        _download_provider(name, version, ctx)

setup_terraform = repository_rule(
    implementation = _setup_terraform_impl,
    attrs = {
        "version": attr.string(
            mandatory = True
        ),
        "providers": attr.string_dict(
            mandatory = True
        )
    }
)
