load("//capnp/toolchain_defs:toolchain_defs.bzl", "toolchain_target_for_repo")

CC_LANG_REPO = "rules_capnproto_cc_toolchain"
CC_LANG_TOOLCHAIN = toolchain_target_for_repo(CC_LANG_REPO)
CC_LANG_SHORTNAME = "cc"
CC_LANG_PLUGIN = "@capnproto//:capnpc_cpp"
CC_LANG_RUNTIME = "@capnproto//:capnp"
