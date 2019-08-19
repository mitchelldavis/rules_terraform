TerraformContext = provider()

def _terraform_context_data(ctx):
    return struct(
        _terraform_exec = ctx.attr.terraform_exec
    )

terraform_context_data = rule(
    _terraform_context_data,
    attrs = {
        "terraform_exec": attr.label(
            allow_files = True,
            default = "@terraform_exec//:terraform_executable"
        )
    }
)
