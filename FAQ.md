# FAQ

RGeo is not supported?
---------------------

If the command below in `rails console` returns `false`

```
RGeo::Geos.supported?
=> false
```

Remove previous rgeo installation

`gem uninstall rgeo`

Install GEOS packages

`sudo apt-get install libgeos-dev libgeos-x.y.z`

Create a symbolic link named libgeos.so that points to the newly installed version of libgeos

```
cd /usr/lib
ln -s libgeos-x.y.z.so libgeos.so
```

Clone again the rails project in other location and

`bundle install`

Now `RGeo::Geos.supported?` will return `true`

*source: https://github.com/rgeo/rgeo/issues/86#issuecomment-72109525*
