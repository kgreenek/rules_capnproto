def toolchain_target_for_repo(repo):
    return "@" + repo + "//toolchain"

CAPNP_TOOLCHAIN_REPO = "rules_capnproto_toolchain"
CAPNP_TOOLCHAIN = toolchain_target_for_repo(CAPNP_TOOLCHAIN_REPO)
CAPNP_TOOLCHAIN_DEFAULT_CAPNP_TOOL = "@capnproto//:capnp_tool"
