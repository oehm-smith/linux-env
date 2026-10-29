# Read by every zsh (scripts included), so keep this minimal.
# PATH itself is set in .zprofile: macOS /etc/zprofile runs path_helper after
# this file and would push anything set here behind the system paths.

# Keep path/PATH free of duplicates in every shell, including nested ones.
typeset -U path PATH
