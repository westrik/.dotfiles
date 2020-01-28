# matt's dotfiles

```bash
# run bootstrap script to generate an SSH key
bash <(curl -s https://raw.githubusercontent.com/westrik/.dotfiles/master/install/bootstrap.sh)
# [...add SSH key to GitHub...]
git clone --recurse-submodules -j8 git@github.com:westrik/.dotfiles.git
bash .dotfiles/setup.sh
```
