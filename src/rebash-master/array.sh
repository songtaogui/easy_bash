#!/usr/bin/env bash
# shellcheck source=./core.sh
source $(dirname ${BASH_SOURCE[0]})/core.sh
# shellcheck disable=SC2034
array_get_index() {
    # shellcheck disable=SC2016
    local __doc__='
    Get index of value in an array

    >>> local a=(one two three)
    >>> array_get_index one "${a[@]}"
    0
    >>> local a=(one two three)
    >>> array_get_index two "${a[@]}"
    1
    >>> array_get_index bar foo bar baz
    1
    '
    local value="$1"
    shift
    local array=("$@")
    local -i index=-1
    local i
    for i in "${!array[@]}"; do
        if [[ "${array[$i]}" == "${value}" ]]; then
            local index="${i}"
        fi
    done
    echo "$index"
    if (( index == -1 )); then
        return 1
    fi
}
array_filter() {
    # shellcheck disable=SC2016,SC2034
    local __doc__='
    Filters values from given array by given regular expression.

    >>> local a=(one two three wolf)
    >>> local b=( $(array.filter ".*wo.*" "${a[@]}") )
    >>> echo ${b[*]}
    two wolf
    '
    local pattern="$1"
    shift
    local array=( $@ )
    local element
    for element in "${array[@]}"; do
        echo "$element"
    done | grep --extended-regexp "$pattern"
}
array_slice() {
    # shellcheck disable=SC2016,SC2034
    local __doc__='
    Returns a slice of an array (similar to Python).

    From the Python documentation:
    One way to remember how slices work is to think of the indices as pointing
    between elements, with the left edge of the first character numbered 0.
    Then the right edge of the last element of an array of length n has
    index n, for example:
    ```
    +---+---+---+---+---+---+
    | 0 | 1 | 2 | 3 | 4 | 5 |
    +---+---+---+---+---+---+
    0   1   2   3   4   5   6
    -6  -5  -4  -3  -2  -1
    ```

    >>> local a=(0 1 2 3 4 5)
    >>> echo $(array.slice 1:-2 "${a[@]}")
    1 2 3
    >>> local a=(0 1 2 3 4 5)
    >>> echo $(array.slice 0:1 "${a[@]}")
    0
    >>> local a=(0 1 2 3 4 5)
    >>> [ -z "$(array.slice 1:1 "${a[@]}")" ] && echo empty
    empty
    >>> local a=(0 1 2 3 4 5)
    >>> [ -z "$(array.slice 2:1 "${a[@]}")" ] && echo empty
    empty
    >>> local a=(0 1 2 3 4 5)
    >>> [ -z "$(array.slice -2:-3 "${a[@]}")" ] && echo empty
    empty
    >>> local a=(0 1 2 3 4 5)
    >>> [ -z "$(array.slice -2:-2 "${a[@]}")" ] && echo empty
    empty

    Slice indices have useful defaults; an omitted first index defaults to
    zero, an omitted second index defaults to the size of the string being
    sliced.
    >>> local a=(0 1 2 3 4 5)
    >>> # from the beginning to position 2 (excluded)
    >>> echo $(array.slice 0:2 "${a[@]}")
    >>> echo $(array.slice :2 "${a[@]}")
    0 1
    0 1

    >>> local a=(0 1 2 3 4 5)
    >>> # from position 3 (included) to the end
    >>> echo $(array.slice 3:"${#a[@]}" "${a[@]}")
    >>> echo $(array.slice 3: "${a[@]}")
    3 4 5
    3 4 5

    >>> local a=(0 1 2 3 4 5)
    >>> # from the second-last (included) to the end
    >>> echo $(array.slice -2:"${#a[@]}" "${a[@]}")
    >>> echo $(array.slice -2: "${a[@]}")
    4 5
    4 5

    >>> local a=(0 1 2 3 4 5)
    >>> echo $(array.slice -4:-2 "${a[@]}")
    2 3

    If no range is given, it works like normal array indices.
    >>> local a=(0 1 2 3 4 5)
    >>> echo $(array.slice -1 "${a[@]}")
    5
    >>> local a=(0 1 2 3 4 5)
    >>> echo $(array.slice -2 "${a[@]}")
    4
    >>> local a=(0 1 2 3 4 5)
    >>> echo $(array.slice 0 "${a[@]}")
    0
    >>> local a=(0 1 2 3 4 5)
    >>> echo $(array.slice 1 "${a[@]}")
    1
    >>> local a=(0 1 2 3 4 5)
    >>> array.slice 6 "${a[@]}"; echo $?
    1
    >>> local a=(0 1 2 3 4 5)
    >>> array.slice -7 "${a[@]}"; echo $?
    1
    '
    local start end array_length length
    if [[ "$1" == *:* ]]; then
        IFS=":"; read -r start end <<<"$1"
        shift
        array_length="$#"
        # defaults
        [ -z "$end" ] && end=$array_length
        [ -z "$start" ] && start=0
        (( start < 0 )) && let "start=(( array_length + start ))"
        (( end < 0 )) && let "end=(( array_length + end ))"
    else
        start="$1"
        shift
        array_length="$#"
        (( start < 0 )) && let "start=(( array_length + start ))"
        let "end=(( start + 1 ))"
    fi
    let "length=(( end - start ))"
    (( start < 0 )) && return 1
    # check bounds
    (( length < 0 )) && return 1
    (( start < 0 )) && return 1
    (( start >= array_length )) && return 1
    # parameters start with $1, so add 1 to $start
    let "start=(( start + 1 ))"
    echo "${@: $start:$length}"
}
alias array.slice="array_slice"
alias array.get_index="array_get_index"
alias array.filter="array_filter"
