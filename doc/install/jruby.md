# Install JRuby 1.6.8 

Download JRuby on http://www.jruby.org/download
```sh
mkdir application
```
Copy jruby-bin-1.6.8.tar.gz in application
```sh
cd application
tar xfz jruby-bin-1.6.8.tar.gz
```
Create a repository jruby-1.6.8
```sh
ln -s jruby-1.6.8 jruby
```

Add to path application/jruby/bin
```sh
cd
vi .profile
```
Add this in the file : 
```sh 
if [ -d "$HOME/application/jruby/bin" ] ; then
   PATH="$HOME/application/jruby/bin":$PATH
fi
```

Apply Profile
```sh
. .profile
```

Test JRuby
```sh
jruby -v
```