load("//capnp:capnp_info.bzl", "CapnpInfo")
load("//capnp/internal:capnp_lang_toolchain.bzl", "CapnpLangToolchainInfo")
load("//capnp/internal:capnp_toolchain.bzl", "CapnpToolchainInfo")
load("//capnp/internal:label_utils.bzl", "package_dir")
load("//capnp/toolchain_defs:toolchain_defs.bzl", "CAPNP_TOOLCHAIN")

def _capnp_include_full_path(ctx, include):
    full_path = package_dir(ctx.label)
    if include != "":
        full_path += "/" + include
    return full_path

def _capnp_library_impl(ctx):
    # Add the capnp_capnp library as a dependency by default, since it is so commonly used.
    deps = ctx.attr.deps
    if hasattr(ctx.attr, "_capnp_capnp") and ctx.attr._capnp_capnp != None:
        deps = deps + [ctx.attr._capnp_capnp]
    srcs_transitive = depset(
        direct = ctx.files.srcs,
        transitive = [dep[CapnpInfo].srcs_transitive for dep in deps],
    )

    # Always add the workspace root to the include path.
    includes = [ctx.label.workspace_root] if ctx.label.workspace_root != "" else []
    includes += [_capnp_include_full_path(ctx, include) for include in ctx.attr.includes]
    includes_transitive = depset(
        direct = includes,
        transitive = [dep[CapnpInfo].includes_transitive for dep in deps],
    )
    embed_files_transitive = depset(
        direct = ctx.files.embed_files,
        transitive = [dep[CapnpInfo].embed_files_transitive for dep in deps],
    )
    return [
        CapnpInfo(
            srcs = ctx.files.srcs,
            srcs_transitive = srcs_transitive,
            includes = includes,
            includes_transitive = includes_transitive,
            embed_files = ctx.attr.embed_files,
            embed_files_transitive = embed_files_transitive,
        ),
    ]

capnp_library = rule(
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "embed_files": attr.label_list(allow_files = True),
        "includes": attr.string_list(),
        "deps": attr.label_list(providers = [CapnpInfo]),
        "_capnp_capnp": attr.label(
            providers = [CapnpInfo],
            default = "@capnproto//:capnp_capnp",
        ),
        "_capnp_toolchain": attr.label(
            providers = [CapnpToolchainInfo],
            default = CAPNP_TOOLCHAIN,
        ),
    },
    output_to_genfiles = True,
    implementation = _capnp_library_impl,
)

# This is a bit of a hack that is just used for the capnp_capnp library. Otherwise, the capnp_capnp
# library would depend on itself merely by having it as a default value in the attr list.
capnp_capnp_library = rule(
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "embed_files": attr.label_list(allow_files = True),
        "includes": attr.string_list(),
        "deps": attr.label_list(providers = [CapnpInfo]),
        "_capnp_toolchain": attr.label(
            providers = [CapnpToolchainInfo],
            default = CAPNP_TOOLCHAIN,
        ),
    },
    output_to_genfiles = True,
    implementation = _capnp_library_impl,
)
