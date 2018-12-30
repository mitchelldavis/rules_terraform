package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")

go_library(
    name = "go_default_library",
    srcs = ["main.go"],
    importpath = "github.com/mitchelldavis/go_pgp",
    deps = [
        "@org_golang_x_crypto//openpgp:go_default_library",
        "@org_golang_x_crypto//openpgp/armor:go_default_library",
        "@org_golang_x_crypto//openpgp/packet:go_default_library",
    ],
)

go_binary(
    name = "go_pgp",
    embed = [":go_default_library"],
)
