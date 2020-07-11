After updates sometimes dmenu is missing some entries from $PATH, this can normally be fixed by removing the cache.
See also https://wiki.archlinux.org/index.php/Dmenu#Missing_menu_entries

In Manjaro I3wm, do the following to remove the cache:

```bash
# remove cache
rm -rf ~/.cache/dmenu-recent

# Restart I3
[SUP]+Shift+R   # super key is often Alt or Windows/Mac key, depending on your configuration of I3wm
```

