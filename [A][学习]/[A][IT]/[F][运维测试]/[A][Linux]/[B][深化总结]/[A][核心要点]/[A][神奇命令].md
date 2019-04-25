# [A][Linux][B][深化总结][A][核心要点][A][核心命令]

## [文件]

* [[rsync](https://www.cyberciti.biz/faq/unix-linux-bsdosx-copying-directory-structures-trees-rsync/)]

``` cmd
rsync -av -f"+ */" -f"- *" /path/to/src /path/to/dest/
rsync -av -f"+ */" -f"- *" /path/to/apache/logs/ root@www433.nixcraft.net.in:/path/to/apache/logs/
```
