def capitalize_first_char(string):
    if len(string) == 0:
        return string
    if len(string) == 1:
        return string.upper()
    return string[0].upper() + string[1:]
