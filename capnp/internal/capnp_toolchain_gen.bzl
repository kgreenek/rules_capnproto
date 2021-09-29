def _capnp_toolchain_gen_impl(ctx):
    ctx.template(
        "toolchain/BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = {
            "{capnp_tool}": str(ctx.attr.capnp_tool),
        },
    )

capnp_toolchain_gen = repository_rule(
    implementation = _capnp_toolchain_gen_impl,
    attrs = {
        "capnp_tool": attr.label(
            allow_single_file = True,
            cfg = "host",
            executable = True,
        ),
        "_build_tpl": attr.label(
            default = "@rules_capnproto//capnp/internal:BUILD.toolchain.tpl",
        ),
    },
    doc = "Creates the Capnp toolchain that will be used by all capnp_library targets",
)
