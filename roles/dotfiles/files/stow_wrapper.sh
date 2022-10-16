#!/bin/bash

usage() {
cat <<EOU
This script checks for existing files and archives them before
running stow on the selected repo and target to create symlinks.
${0##*/} [stow dir/repo] [target dir/HOME] [package dir]
Example:
${0##*/} "${HOME}/.dotfiles" "$HOME" "vim"
EOU
exit 1
}

[[ $# -eq 3 ]] || usage
stow_dir="$1"
target_dir="$2"
package_dir="$3"
[[ -d "$stow_dir" ]] || { printf "Selected stow directory %s: not a directory.\n" "$stow_dir" ; exit 1 ; }
[[ -d "$target_dir" ]] || { printf "Selected target directory %s: not a directory.\n" "$target_dir" ; exit 1 ; }
[[ -d "${stow_dir%/}/${package_dir}" ]] || { printf "Selected package directory %s: not a directory.\n" "$package_dir" ; exit 1 ; }

while read -r -d $'\0' line ; do
  files+=("$line")
done < <(find "${stow_dir%/}/${package_dir##*/}" -type f -printf "%P\0")

for file in "${files[@]}" ; do
  if [[ ! -L "${target_dir%/}/${file}" && -f "${target_dir%/}/${file}" ]] ; then
    if [[ "${file}" != "${file%/*}" ]] ; then
      dest="${file%/*}/.old_ansible_${file##*/}$(date -I)"
    else
      dest=".old_ansible_${file}$(date -I)"
    fi
    mv -v "${target_dir%/}/${file}" "${target_dir%/}/${dest}" || \
      { printf "Error backing up %s.\n" "${target_dir%/}/${file}" ; exit 1 ; }
# Make old scripts non-executable
    chmod -x "${target_dir%/}/${dest}"
  fi
  if [[ "${target_dir%/}/${file%/*}" != "${target_dir%/}/${file}" && ! -d "${target_dir%/}/${file%/*}" ]] ; then
# Create any missing parent directories before symlinking
    mkdir -p "${target_dir%/}/${file%/*}" || \
      { printf "Error creating parent directory %s.\n" "${target_dir%/}/${file%/*}" ; exit 1 ; }
  fi
done

stow -v -d "$stow_dir" -t "$target_dir" -R "$package_dir"
