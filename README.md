# rules_capnproto

Bazel rules for [capnproto](https://capnproto.org/)

For a list of releases and changes see the [CHANGELOG](CHANGELOG.md)

## Installing

Add the following lines to your WORKSPACE file to download and initialize rules_capnproto in your repo:

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_capnproto",
    sha256 = "c75b4ebcd4f7db7ac2a2a6a5be3c64599c97a26934db67de51d3935304ab6e8c",
    strip_prefix = "rules_capnproto-0.1.0",
    urls = ["https://github.com/kgreenek/rules_capnproto/archive/refs/tags/v0.1.0.tar.gz"],
)

load(
    "@rules_capnproto//capnp:repositories.bzl",
    "capnp_cc_toolchain",
    "capnp_dependencies",
    "capnp_toolchain",
)

capnp_dependencies()
capnp_toolchain()
capnp_cc_toolchain()
```

## Usage

### Create a capnp_library

These targets define the dependency relationships between your capnp files, which are used by all the other language-specific rules.

```bzl
load("@rules_capnproto//capnproto:capnp_library.bzl", "capnp_library")

capnp_library(
    name = "foo_capnp",
    srcs = ["foo.capnp"],
)
```

In order to import a capnp file from one capnp_library from another capnp file in a different capnp_library, the former must be listed in the deps of the latter.

For example, if we create a second capnp file called bar.capnp that imports foo.capnp, we might define a capnp_library like so:

```bzl
capnp_library(
    name = "bar_capnp",
    srcs = ["bar.capnp"],
    deps = [":foo_capnp"],
)
```

NOTE: You do not need to create a separate capnp_library for each capnp source file. That is done here for illustration purposes. However, the more granularly you define your capnp_libraries, the better bazel will be able to speed up your builds, since it can be smarter about only generating / compiling sources that are actually imported. 

### Create a C++ capnproto library

This is an example of creating a cc_capnp_library target. This target generates the C++ headers using the capnp compiler, including resolving all transitive dependencies. This target can be used in the deps of any normal cc_library or cc_binary target.

```bzl
load("@rules_capnproto//capnproto:cc_capnp_library.bzl", "cc_capnp_library")

cc_capnp_library(
    name = "foo_cc_capnp",
    deps = [":foo_capnp"],
)
```

Include paths for all generated C++ headers mirror the corresponding capnp file's location in the mono-repo. For example, if you create a capnp file called `//foo/bar/baz.capnp`, the generated C++ header will be imported like so: `#include "foo/bar/baz.capnp.h"`.

It is highly recommended to choose namespaces in your capnp files so that they match the bazel workspace hierarchy. This will create consistency in how you use the generated files across all languages.

In this case, the namespace in `//foo/bar/baz.capnp` would be declared as:

```
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("foo::bar");
```

The generated C++ class / namespace would be e.g. `::foo::bar::Baz`

Language targets such as cc_capnp_library can only depend on existing capnp_library targets.

## Full examples

For full examples for all supported languages, browse through the [examples](examples) package.
