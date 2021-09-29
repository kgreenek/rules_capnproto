DEFAULT_CAPNP_TOOL = "@capnproto//:capnp_tool"

CapnpToolchainInfo = provider(fields = {
    "capnp_tool": "capnp_tool compiler target",
})

def _capnp_toolchain_impl(ctx):
    return CapnpToolchainInfo(
        capnp_tool = ctx.attr.capnp_tool,
    )

capnp_toolchain = rule(
    implementation = _capnp_toolchain_impl,
    attrs = {
        "capnp_tool": attr.label(
            default = DEFAULT_CAPNP_TOOL,
            allow_single_file = True,
            cfg = "host",
            executable = True,
        ),
    },
)
