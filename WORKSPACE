workspace(name = "io_bazel_rules_terraform")

#load("@bazel_tools//tools/build_defs/repo:http.bzl", 
#	 "http_archive", "http_file")
## THIRD PARTY TOOLS
###################################
#http_archive(
#	name = "terraform_linux",
#	url = "https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_linux_amd64.zip",
#	build_file_content = """
#filegroup(
#	name = "terraform_linux_tool",
#	srcs = ["terraform"],
#	visibility = ["//visibility:public"]
#)
#""", sha256 = "f728fa73ff2a4c4235a28de4019802531758c7c090b6ca4c024d48063ab8537b"
#) 
#http_archive(
#	name = "terraform_darwin",
#	url = "https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_darwin_amd64.zip",
#	build_file_content = """
#filegroup(
#	name = "terraform_darwin_tool",
#	srcs = ["terraform"],
#	visibility = ["//visibility:public"]
#)
#""",
#	sha256 = "ff5c3c4bcfe84e011b96a2232704b2db196383ce5d4a32e47956c883ddc94bac"
#)

load("//rules_terraform:terraform.bzl", "terraform_register_toolchains")

terraform_register_toolchains()
