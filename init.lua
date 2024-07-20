print('Hello World')
package.path = package.path .. ";/usr/share/lua/5.1/?.lua"
package.cpath = package.cpath .. ";/usr/lib/lua/5.1/?/core.so"
require "init"
