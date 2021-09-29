load("@rules_cc//cc:action_names.bzl", "CPP_COMPILE_ACTION_NAME")
load("@rules_cc//cc:toolchain_utils.bzl", "find_cpp_toolchain")
load("//capnp:capnp_info.bzl", "CapnpInfo")
load("//capnp/internal:capnp_lang_toolchain.bzl", "CapnpLangToolchainInfo")
load("//capnp/internal:capnp_toolchain.bzl", "CapnpToolchainInfo")
load("//capnp/internal:capnp_tool_action.bzl", "capnp_tool_action")
load("//capnp/internal:label_utils.bzl", "package_dir")
load("//capnp/toolchain_defs:cc_defs.bzl", "CC_LANG_TOOLCHAIN")
load("//capnp/toolchain_defs:toolchain_defs.bzl", "CAPNP_TOOLCHAIN")

CC_SRC_FILE_EXTENSION = "c++"
CC_HDR_FILE_EXTENSION = "h"

CapnpCcInfo = provider(fields = {
    "cc_srcs": "c++ source files for this target (non-transitive)",
    "cc_srcs_transitive": "depset of generated c++ source files",
    "cc_hdrs": "header files for this target (non-transitive)",
    "cc_hdrs_transitive": "depset of generated cc_hdrs",
    "cc_includes": "includes for this target (non-transitive)",
    "cc_includes_transitive": "depset of includes",
})

def _cc_include_full_path(ctx, include):
    return package_dir(ctx.label) + "/" + include

def _capnp_cc_aspect_impl(target, ctx):
    cc_srcs = [
        ctx.actions.declare_file(src.basename + "." + CC_SRC_FILE_EXTENSION, sibling = src)
        for src in target[CapnpInfo].srcs
    ]
    cc_srcs_transitive = depset(
        direct = cc_srcs,
        transitive = [dep[CapnpCcInfo].cc_srcs_transitive for dep in ctx.rule.attr.deps],
    )
    cc_hdrs = [
        ctx.actions.declare_file(src.basename + "." + CC_HDR_FILE_EXTENSION, sibling = src)
        for src in target[CapnpInfo].srcs
    ]
    cc_hdrs_transitive = depset(
        direct = cc_hdrs,
        transitive = [dep[CapnpCcInfo].cc_hdrs_transitive for dep in ctx.rule.attr.deps],
    )
    cc_includes = [
        _cc_include_full_path(ctx, include)
        for include in target[CapnpInfo].includes
    ] + [ctx.genfiles_dir.path]
    cc_includes_transitive = depset(
        direct = cc_includes,
        transitive = [dep[CapnpCcInfo].cc_includes_transitive for dep in ctx.rule.attr.deps],
    )

    # Create an action to generate cc sources from the capnp files.
    capnp_tool_action(
        ctx = ctx,
        target = ctx.label,
        capnp_toolchain = ctx.attr._capnp_toolchain[CapnpToolchainInfo],
        capnp_lang_toolchain = ctx.attr._capnp_lang_toolchain[CapnpLangToolchainInfo],
        srcs = target[CapnpInfo].srcs,
        srcs_transitive = target[CapnpInfo].srcs_transitive,
        includes_transitive = target[CapnpInfo].includes_transitive,
        embed_files_transitive = target[CapnpInfo].embed_files_transitive,
        outputs = cc_srcs + cc_hdrs,
    )

    # Create actions to compile and link the generated sources.
    capnp_lang_toolchain = ctx.attr._capnp_lang_toolchain[CapnpLangToolchainInfo]
    cc_toolchain = find_cpp_toolchain(ctx)
    runtime = capnp_lang_toolchain.runtime[CcInfo]
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    compilation_context, compilation_outputs = cc_common.compile(
        name = ctx.rule.attr.name + "_cc_compile",
        actions = ctx.actions,
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        srcs = cc_srcs,
        public_hdrs = cc_hdrs,
        includes = cc_includes,
        compilation_contexts = [runtime.compilation_context] +
                               [dep[CcInfo].compilation_context for dep in ctx.rule.attr.deps],
        #compilation_contexts = [dep[CcInfo].compilation_context for dep in ctx.rule.attr.deps],
    )
    linking_context, linking_outputs = cc_common.create_linking_context_from_compilation_outputs(
        name = ctx.rule.attr.name + "_cc_link",
        actions = ctx.actions,
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        compilation_outputs = compilation_outputs,
        linking_contexts = [runtime.linking_context] +
                           [dep[CcInfo].linking_context for dep in ctx.rule.attr.deps],
        #linking_contexts = [dep[CcInfo].linking_context for dep in ctx.rule.attr.deps],
    )

    return [
        CcInfo(
            compilation_context = compilation_context,
            linking_context = linking_context,
        ),
        CapnpCcInfo(
            cc_srcs = cc_srcs,
            cc_srcs_transitive = cc_srcs_transitive,
            cc_hdrs = cc_hdrs,
            cc_hdrs_transitive = cc_hdrs_transitive,
            cc_includes = cc_includes,
            cc_includes_transitive = cc_includes_transitive,
        ),
    ]

def _cc_capnp_library_impl(ctx):
    return [
        cc_common.merge_cc_infos(
            direct_cc_infos = [dep[CcInfo] for dep in ctx.attr.deps],
            #cc_infos = [ctx.attr._capnp_lang_toolchain[CapnpLangToolchainInfo].runtime[CcInfo]],
        ),
    ]

capnp_cc_aspect = aspect(
    implementation = _capnp_cc_aspect_impl,
    attr_aspects = ["deps"],
    attrs = {
        "_capnp_toolchain": attr.label(
            providers = [CapnpToolchainInfo],
            default = CAPNP_TOOLCHAIN,
        ),
        "_capnp_lang_toolchain": attr.label(
            providers = [CapnpLangToolchainInfo],
            default = CC_LANG_TOOLCHAIN,
        ),
        "_cc_toolchain": attr.label(
            providers = [cc_common.CcToolchainInfo],
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain"),
        ),
    },
    fragments = ["cpp"],
)

cc_capnp_library = rule(
    attrs = {
        "deps": attr.label_list(
            aspects = [capnp_cc_aspect],
            providers = [CapnpInfo],
        ),
        "_capnp_toolchain": attr.label(
            providers = [CapnpToolchainInfo],
            default = CAPNP_TOOLCHAIN,
        ),
        "_capnp_lang_toolchain": attr.label(
            providers = [CapnpLangToolchainInfo],
            default = CC_LANG_TOOLCHAIN,
        ),
        "_cc_toolchain": attr.label(
            providers = [cc_common.CcToolchainInfo],
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain"),
        ),
    },
    output_to_genfiles = True,
    implementation = _cc_capnp_library_impl,
    fragments = ["cpp"],
)
