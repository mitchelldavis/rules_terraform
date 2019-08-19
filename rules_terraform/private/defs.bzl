terraform_sums_url_template = "https://releases.hashicorp.com/terraform/{0}/terraform_{0}_SHA256SUMS"
terraform_sums_sig_url_template = "https://releases.hashicorp.com/terraform/{0}/terraform_{0}_SHA256SUMS.sig"
terraform_url_template = "https://releases.hashicorp.com/terraform/{0}/terraform_{0}_{1}_{2}.zip"
terraform_filename_template = "terraform_{0}_{1}_{2}.zip"
terraform_provider_sums_url_template = "https://releases.hashicorp.com/terraform-provider-{0}/{1}/terraform-provider-{0}_{1}_SHA256SUMS"
terraform_provider_sums_sig_url_template = "https://releases.hashicorp.com/terraform-provider-{0}/{1}/terraform-provider-{0}_{1}_SHA256SUMS.sig"
terraform_provider_url_template = "https://releases.hashicorp.com/terraform-provider-{0}/{1}/terraform-provider-{0}_{1}_{2}_{3}.zip"
terraform_provider_filename_template = "terraform-provider-{0}_{1}_{2}_{3}.zip"

def toolchains(): 
    return {
    "terraform_linux": {
        "name": "terraform_linux",
        "exec_compatible_with": [
            "@bazel_tools//platforms:linux",
            "@bazel_tools//platforms:x86_64",
        ],
        "target_compatible_with": [
            "@bazel_tools//platforms:linux",
            "@bazel_tools//platforms:x86_64",
        ],
        "verifier_url":"https://github.com/mitchelldavis/hashicorp_verifier/releases/download/v0.0.5/hashicorp_verifier_linux_amd64",
        "verifier_checksum":"0c90e08dd9ef21dd6fbca275488ca5b722a8d0a5d8b9ae13e34585277ad46702",
        "toolchain":":terraform_linux",
        "toolchain_type":"@io_bazel_rules_terraform//:toolchain_type",
        "host": "linux",
        "arch": "amd64"
    },
    "terraform_osx": {
        "name": "terraform_osx",
        "exec_compatible_with": [
            "@bazel_tools//platforms:osx",
            "@bazel_tools//platforms:x86_64",
        ],
        "target_compatible_with": [
            "@bazel_tools//platforms:osx",
            "@bazel_tools//platforms:x86_64",
        ],
        "verifier_url":"https://github.com/mitchelldavis/hashicorp_verifier/releases/download/v0.0.5/hashicorp_verifier_darwin_amd64",
        "verifier_checksum":"cee435dbbaf3a66ca74da3449e3c315610dea01d7d812e3b667c1a734fe10dcd",
        "toolchain":":terraform_osx",
        "toolchain_type":"@io_bazel_rules_terraform//:toolchain_type",
        "host": "darwin",
        "arch": "amd64"
    }
}
