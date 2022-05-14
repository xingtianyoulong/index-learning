###############################################################
# https://blog.csdn.net/qq_41856814/article/details/103636807
###############################################################

# ffmpeg -i 'a.mp4' -ss 00:00:35.00 -y -acodec copy 'audio.aac'
ffmpeg -i 'a.mp4' -y -acodec copy 'audio.aac'
ffmpeg -i 'b.mp4' -i 'audio.aac' -y -c copy -shortest 'rs.mp4'
