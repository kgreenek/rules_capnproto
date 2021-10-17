CapnpLangToolchainInfo = provider(fields = {
    "lang_shortname": "short name for the toolchain / language, e.g. 'cc', 'java', 'rust', etc.",
    "plugin": "plugin target to pass to capnp_tool for this language",
    "runtime": "language-dependent runtime target to e.g. link with compiled libraries",
})

def _capnp_lang_toolchain_impl(ctx):
    return CapnpLangToolchainInfo(
        lang_shortname = ctx.attr.lang_shortname,
        plugin = ctx.attr.plugin,
        runtime = ctx.attr.runtime,
    )

capnp_lang_toolchain = rule(
    implementation = _capnp_lang_toolchain_impl,
    attrs = {
        "lang_shortname": attr.string(),
        "plugin": attr.label(
            allow_single_file = True,
            cfg = "exec",
            executable = True,
        ),
        "runtime": attr.label(
            cfg = "target",
        ),
    },
)
