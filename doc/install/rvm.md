# Install RVM

If no package is available, install from sources

Setup from sources
------------------

follow procedure described by [this post](http://toddmahoney.com/post/65020455496/ubuntu-13-10-installing-rvm-ruby)

```sh
sudo apt-get update

sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config libgdbm-dev libffi-dev libreadline-dev

curl -L https://get.rvm.io | bash -s stable

echo 'source ~/.rvm/scripts/rvm' >> ~/.bash_aliases && bash
```

Test
----

```sh
type rvm | head -n 1
```
and if you get
```sh
rvm is a function
```
installation is ok
