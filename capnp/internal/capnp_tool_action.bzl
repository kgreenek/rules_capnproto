load("//capnp/internal:string_utils.bzl", "capitalize_first_char")

def _include_args_from_depset(includes_depset):
    # Always include the workspace root.
    include_args = ["-I", "."]
    for include in includes_depset.to_list():
        include_args.append("-I{}".format(include))
    return include_args

def capnp_tool_action(
        ctx,
        target,
        capnp_toolchain,
        capnp_lang_toolchain,
        srcs,
        srcs_transitive,
        includes_transitive,
        embed_files_transitive,
        outputs):
    capnp_tool = capnp_toolchain.capnp_tool.files_to_run.executable
    plugin = capnp_lang_toolchain.plugin.files_to_run.executable
    output_prefix = ctx.genfiles_dir.path
    mnemonic = "Capnp{}Gen".format(capitalize_first_char(capnp_lang_toolchain.lang_shortname))
    progress_message = "Generating capnp {} files for {}:".format(
        capnp_lang_toolchain.lang_shortname,
        ctx.label,
    )
    inputs = depset(transitive = [srcs_transitive, embed_files_transitive])
    genrule_args = \
        ["compile", "--no-standard-import", "--output={}:{}".format(plugin.path, output_prefix)] + \
        _include_args_from_depset(includes_transitive) + \
        [src.path for src in srcs]
    ctx.actions.run(
        inputs = inputs,
        outputs = outputs,
        executable = capnp_tool,
        tools = [capnp_tool, plugin],
        arguments = genrule_args,
        mnemonic = mnemonic,
        progress_message = progress_message,
    )
