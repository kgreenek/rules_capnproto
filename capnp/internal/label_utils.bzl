def package_dir(label):
    package_dir = label.workspace_root
    if label.package != "":
        package_dir += "/" + label.package
    return package_dir
