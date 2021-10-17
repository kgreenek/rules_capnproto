CAPNPROTO_COPTS = [
    "--std=c++14",
    "-Wall",
    "-Wextra",
    "-Wno-deprecated-declarations",
    "-Wno-maybe-uninitialized",
    "-Wno-strict-aliasing",
    "-Wno-sign-compare",
    "-Wno-unused-parameter",
]

CAPNPROTO_LINKOPTS = ["-lpthread"]

CAPNPROTO_INCLUDES = ["c++/src"]

def capnroto_cc_library(**kwargs):
    native.cc_library(
        copts = CAPNPROTO_COPTS + kwargs.pop("copts", []),
        linkopts = CAPNPROTO_LINKOPTS + kwargs.pop("linkopts", []),
        includes = CAPNPROTO_INCLUDES + kwargs.pop("includes", []),
        **kwargs
    )

def capnroto_cc_binary(**kwargs):
    native.cc_binary(
        copts = CAPNPROTO_COPTS + kwargs.pop("copts", []),
        linkopts = CAPNPROTO_LINKOPTS + kwargs.pop("linkopts", []),
        includes = CAPNPROTO_INCLUDES + kwargs.pop("includes", []),
        **kwargs
    )

def capnroto_cc_test(**kwargs):
    native.cc_test(
        copts = CAPNPROTO_COPTS + kwargs.pop("copts", []),
        linkopts = CAPNPROTO_LINKOPTS + kwargs.pop("linkopts", []),
        includes = CAPNPROTO_INCLUDES + kwargs.pop("includes", []),
        **kwargs
    )
