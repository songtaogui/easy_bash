# easy_bash
My common bash functions to make pipelining with bash more smooooth ~

## Installation

Most of my bash scripts start with loading the common functions listed in this repository.
So, inorder to smoothly use my pipelines, it is recommended to clone this repository, then
assign the `$EASYBASH` env to it:

```bash
git clone https://github.com/songtaogui/easy_bash.git
cd easy_bash
# assign $EASYBASH to this dir:
echo "export EASYBASH=$PWD" >> ~/.bashrc && source ~/.bashrc
```

Now, you can use my other bash scripts smoothly, have fun!

What's more, if you find my functions useful, you could also include them in your bash
scripts, by adding the following script:

```bash
# >>>>>>>>>>>>>>>>>>>>>>>> Load Common functions >>>>>>>>>>>>>>>>>>>>>>>>
export quiet=FALSE
export verbose=TRUE
source $EASYBASH/lib/common.sh
if [ $? -ne 0 ];then 
    echo -e "\033[31m\033[7m[ERROR]\033[0m --> Cannot load common functions from easybash lib: $EASYBASH" >&2
    exit 1;
fi
# <<<<<<<<<<<<<<<<<<<<<<<< Common functions <<<<<<<<<<<<<<<<<<<<<<<<
```

You could also find useful tools to make bash programming happier, in the `/bin` dir of this repo,
these are collections of various bash packages created by talented programmers. Please refer to
the usages of these packages in their original repository:

- [bushful](https://github.com/jmcantrell/bashful)
- [has](https://github.com/kdabir/has)
- [is,sh](https://github.com/qzb/is.sh)
- [rebash](https://github.com/jandob/rebash)
- [sub](https://github.com/qrush/sub)
- [shunit2](https://github.com/kward/shunit2)
- 
