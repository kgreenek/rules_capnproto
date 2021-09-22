load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def capnp_dependencies():
    maybe(
        http_archive,
        name = "capnproto",
        build_file = "@rules_capnproto//capnp/internal:BUILD.capnp.bazel",
        sha256 = "a156efe56b42957ea2d118340d96509af2e40c7ef8f3f8c136df48001a5eb2ac",
        strip_prefix = "capnproto-0.9.0",
        urls = [
            # TODO(kgreenek): Mirror this somewhere in case github is down.
            # Ideally mirror.bazel.build (ping @philwo on github).
            "https://github.com/capnproto/capnproto/archive/refs/tags/v0.9.0.tar.gz",
        ],
    )
