def _terraform_plan(ctx):
    deps = depset(ctx.files.srcs)
    ctx.actions.run(
        executable = ctx.executable._exec,
        inputs = deps.to_list(),
        outputs = [
            ctx.outputs.init
        ],
        mnemonic = "TerraformInitialize",
        arguments = [
            "init",
            "-plugin-dir={0}".format(ctx.executable._exec.dirname),
            "-get-plugins=false",
            deps.to_list()[0].dirname
        ]
    )
    ctx.actions.run(
        executable = ctx.executable._exec,
        inputs = deps.to_list(),
        outputs = [ctx.outputs.plan],
        mnemonic = "TerraformPlan",
        arguments = [
            "plan",
            "-out={0}".format(ctx.outputs.plan.path), 
            deps.to_list()[0].dirname
        ]
    )

    return [DefaultInfo(
        runfiles = ctx.runfiles(files = ctx.files.srcs),
    )]

terraform_plan = rule(
    implementation = _terraform_plan,
    attrs = {
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = True
        ),
        "_exec": attr.label(
            default = Label("@terraform_exec//:terraform_executable"),
            allow_files = True,
            executable = True,
            cfg = "host"
        )
    },
    toolchains = ["@io_bazel_rules_terraform//:toolchain_type"],
    outputs = {
        "init": ".terraform/plugin_path",
        "plan": "%{name}.plan"
    },
)
