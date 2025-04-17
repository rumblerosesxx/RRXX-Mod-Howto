Xenia Canary allows patching the xex in RAM using the patches mechanism, so in general you should not need to modify the default.xex directly, unless you want to make the patches availabe on
an RGH console or older xenia build that doesn't support patches
.
A bunch of patches have already been created by Rumble XX over at https://github.com/Rumble-XX/Rumble-Roses-XX

You can use Cheat Engine or just direct memory editing with HxD to identify new patches or edit existing ones, and implement them as xenia
patches or bake the change directly into default.xex

We will look at the process of editing the default.xex here.

Use xextool.exe to work with default.xex

```
  xextool.exe -l default.xex
```

You should see something like this:

```
XexTool v6.3  -  xorloser 2006-2011 (Build Fri Oct 14 16:31:54 2011)
Reading and parsing input xex file...

Xex Info
  Retail
  Uncompressed
  Encrypted
  Title Module
  XGD2 Only
  Uses Game Voice Channel
  Xbox360 Logo Data Present

Basefile Info
  Original PE Name:   default.pe
  Load Address:       82000000
  Entry Point:        82066F10
  Image Size:           AC0000
  Page Size:             10000
  Checksum:           004FA8CB
  Filetime:           43F732D1 - Sat Feb 18 23:44:33 2006
  Stack Size:           180000

...

```

The important parts here are Xex Info section which tells us the xex is encrypted and uncompressed, so we first need to make sure to decrypt it.

```
  xextool.exe -e 0 -o uncrypted.xex default.xex
```

This preserves the original default.xex and creates uncrypted.xex which we can now edit.

The other imporant piece of info is the Load Address of 0x82000000, which will be the offset in RAM where Xenia will be loading it. We will need to subtract this value to get true offset into
our executable. In addition the xex header takes up 0x3000 bytes so we need to further adjust the offset we get in the running Xenia process by adding 0x3000 when looking for the same location
inside uncrypted.xex

Essentially what you wnat to do is take an existing xenia patch, e.g.

```
[[patch]]
    name = "Change Ratio to 21:9"
    desc = "HUD will be stretch but not the characters. Must set present_letterbox to false"
    author = "Rumble XX"
    is_enabled = false

    [[patch.be32]]
        address = 0x82012d00
        value = 0x4018e38e

```

Here we have address 0x82012d00 being updated with the value 0x4018e38e. In this case this is a bigendian float value of 2.39 that roughly corresponds to the resolution ratio of 21:9.
We can also replace this with 0x4018e38e (or 2.1) for 21:10 ratio, but that's not important for this document.

What we want to do is bake this patch directly into our xex. For that we need to subtract 0x82000000 from the address which gives us 0x00012d00 and then add 0x3000 to get the location
of this value inside the xex. In this case it should be 0x00015d00. Keep in mind we cannot modify the encrypted default.xex and need to update the uncrypted.xex we generated earlier.
It should be the same size as default.xex but the embedded executable will be unencrypted and possible to modify.

Use a hex editor of your choice, e.g. HxD, to make the change at the appropriate address after doing the math described above and test your change by launching uncrypted.xex with Xenia.
