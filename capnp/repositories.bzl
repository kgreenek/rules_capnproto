load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def capnp_dependencies():
    maybe(
        http_archive,
        name = "capnproto",
        build_file = "@rules_capnproto//third_party/capnproto:BUILD.capnp.bazel",
        sha256 = "a156efe56b42957ea2d118340d96509af2e40c7ef8f3f8c136df48001a5eb2ac",
        strip_prefix = "capnproto-0.9.0",
        urls = [
            # TODO(kgreenek): Mirror this somewhere in case github is down.
            # Ideally mirror.bazel.build (ping @philwo on github).
            "https://github.com/capnproto/capnproto/archive/refs/tags/v0.9.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "zlib",
        build_file = "@rules_capnproto//third_party:BUILD.zlib.bazel",
        sha256 = "629380c90a77b964d896ed37163f5c3a34f6e6d897311f1df2a7016355c45eff",
        strip_prefix = "zlib-1.2.11",
        urls = [
            # TODO(kgreenek): Mirror this somewhere in case github is down.
            # Ideally mirror.bazel.build (ping @philwo on github).
            "https://github.com/madler/zlib/archive/v1.2.11.tar.gz",
        ],
    )
