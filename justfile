# Read package metadata from typst.toml
pkg_name    := `grep '^name'    typst.toml | sed 's/name = "\(.*\)"/\1/'`
pkg_version := `grep '^version' typst.toml | sed 's/version = "\(.*\)"/\1/'`
install_dir := env_var('HOME') + "/.local/share/typst/packages/local/" + \
               pkg_name + "/" + pkg_version

# Package files (non-directory)
pkg_files := "lib.typ utils.typ pyrforos.svg github-mark-white.svg typst.toml LICENSE"

# List available recipes
default:
    @just --list

# Copy package files to the typst local packages directory
install:
    @echo "Installing {{pkg_name}} v{{pkg_version}} -> {{install_dir}}"
    mkdir -p "{{install_dir}}"
    rm -f {{install_dir}}/lib.typ {{install_dir}}/utils.typ \
          {{install_dir}}/pyrforos.svg {{install_dir}}/github-mark-white.svg \
          {{install_dir}}/typst.toml
    rm -rf "{{install_dir}}/template"
    cp {{pkg_files}} "{{install_dir}}/"
    cp -r template "{{install_dir}}/"
    @echo "Done."

# Re-copy all files, overwriting the current installation
update: install

# Remove the package from the typst local packages directory
uninstall:
    @echo "Removing {{pkg_name}} v{{pkg_version}} from {{install_dir}}"
    rm -rf "{{install_dir}}"
    @echo "Done."

# Show the current installation status
status:
    @echo "Package:  {{pkg_name}} v{{pkg_version}}"
    @echo "Location: {{install_dir}}"
    @if [ -d "{{install_dir}}" ]; then \
        echo "Status:   installed"; \
        ls -la "{{install_dir}}"; \
    else \
        echo "Status:   not installed"; \
    fi
