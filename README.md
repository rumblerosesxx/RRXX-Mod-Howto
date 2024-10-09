# RRXX-Mod-Howto
This repository contains a collection of docs explaining how to mod Rumble Roses XX.

All the tools necessary should be available from other repositories under this account. These are all just copies that are hosted here, I did not create any of them myself, and you should probably get them from official sources instead. They're only provided here for convenience.

First step in modding the game is getting the game files, obviously. You can obtain these legally by purchasing the game digitally from Microsoft or getting a second hand disc version. You will then be able to fairly easily move the game files to your PC. This can be done either by copying the game files from your Xbox 360 to a USB stick, taking the Xbox 360 hard drive and reading the files off of it on your PC, or by simply downloading it directly from the Xbox Marketplace on your PC. If you don't own an Xbox 360 I strongly advise getting the digital version rather than disc, but if you already own a 360 getting the game from the disc is pretty straightforward as well.

For the digital version, the download link is:

http://download.xboxlive.com/content/4b4e07d1/f942257d9a6a6dcf2630fb93895880019b17e0d7.xcp

Note: it will only work if you own the game on Xbox Marketplace and are signed in to your Microsoft account.

Once you obtain the xcp you can convert it to GOD format using a tool called "XBL Marketplace for PC", again this will only work if you bought the game and downloaded a legit xcp yourself.

If you're copying the game from your Xbox 360 it will already be in GOD format.

Once you have the game in GOD format you will need to unpack it. 

The easiest way to unpack the game is to use Xenia canary File/Install option. This will put the unpacked game files in your Documents/Xenia/content folder.

Your next step should be to unpack the .pac files found in the game directory. The best tool for that currently is to use my batch script that recursively opens the entire .pac archive, found at:

https://github.com/rumblerosesxx/rrxx-packer

Character related files are in the ch/ directory, and there is a rough guide to what character files are located where here:

https://github.com/rumblerosesxx/RRXX-Mod-Howto/blob/main/Model%20File%20Locations

There is a lot of different things you can do once you have access to these, such as replace textures or edit the model files.

Textures are generally kept in the same directory as the model files and you can replace them and repack the archive using the batch script mentioned above. Game textures are generally in DDS format but you can just use PNG files instead, as long as you name them the same as the originals. Just make sure you don't exlode the size too much as it may cause the game to crash, but PNG is generally smaller so should probably be fine.

You can also edit the YOBJ model files. This can be done by loading them into Blender or hex editing directly.

Both approaches have their merits and limitations. To load the YOBJ into blender you can use the import script:

https://github.com/rumblerosesxx/rrxx_tools_addon

The only edits you will be able to do however is hiding certain meshes, you cannot currently modify or add vertices due to limitations in the export functionality.

If you want to hex edit directly, I recommend using ImHex alongside the hexpat file I made that allows you to easily navigate the binary structure. Simply open the YOBJ in ImHex then right-click inside Patter Editor window and choose "Browse" to select the hexpat file found here:

https://raw.githubusercontent.com/rumblerosesxx/RRXX-Mod-Howto/refs/heads/main/yobj.hexpat

(Obviously save it to your PC first)

Once you do this you have nicely highlighted and browseable YOBJ you can easily explore and modify.
