CapnpInfo = provider(fields = {
    "srcs": "srcs capnp files for this target (non-transitive)",
    "srcs_transitive": "depset of capnp files",
    "includes": "includes for this target (non-transitive)",
    "includes_transitive": "depset of includes",
    "embed_files": "list of files that are embedded in srcs",
    "embed_files_transitive": "depset of files that are embedded in srcs_transitive",
})
