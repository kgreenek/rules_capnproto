KJ_COPTS = [
    "--std=c++14",
    "-Wall",
    "-Wextra",
    "-Wno-strict-aliasing",
    "-Wno-sign-compare",
    "-Wno-unused-parameter",
]

KJ_LINKOPTS = ["-lpthread"]

KJ_INCLUDES = ["c++/src"]

def kj_cc_library(**kwargs):
    native.cc_library(
        copts = KJ_COPTS + kwargs.pop("copts", []),
        linkopts = KJ_LINKOPTS + kwargs.pop("linkopts", []),
        includes = KJ_INCLUDES + kwargs.pop("includes", []),
        **kwargs
    )

def kj_cc_binary(**kwargs):
    native.cc_binary(
        copts = KJ_COPTS + kwargs.pop("copts", []),
        linkopts = KJ_LINKOPTS + kwargs.pop("linkopts", []),
        includes = KJ_INCLUDES + kwargs.pop("includes", []),
        **kwargs
    )

def kj_cc_test(**kwargs):
    native.cc_test(
        copts = KJ_COPTS + kwargs.pop("copts", []),
        linkopts = KJ_LINKOPTS + kwargs.pop("linkopts", []),
        includes = KJ_INCLUDES + kwargs.pop("includes", []),
        **kwargs
    )
