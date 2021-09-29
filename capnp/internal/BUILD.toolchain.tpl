load("@rules_capnproto//capnp/internal:capnp_toolchain.bzl", "capnp_toolchain")

capnp_toolchain(
    name = "toolchain",
    capnp_tool = "{capnp_tool}",
    visibility = ["//visibility:public"],
)
