param(
    [string]$Filename
)

class video{
    [string]$Filename
    [string]$MajorBrand
    [string]$MinorVersion
    [string]$CompatibleBrands
    [string]$CreationTime
    [psobject]$Duration
    [string]$Start
    [string]$BitRate
    [array]$VideoStream
    [array]$AudioStream
    [array]$HandlerName
}

# class time{
#     [int]$Hours
#     [int]$Minutes
#     [int]$Seconds
#     [int]$Milliseconds
# }

# Assigning ffprobe information to variable via redirection is required in bash systems?
# $ffmpeg = ffprobe -i /home/david/Videos/furiadeloskaratecas1983.mp4 2>&1

# Sample output of ffprobe data provided. Uncomment above, if you have the ffmpeg suite, and comment out below.
$ffmpeg = @"
ffprobe version 4.1.4-1+rpt1~deb10u1 Copyright (c) 2007-2019 the FFmpeg developers
  built with gcc 8 (Raspbian 8.3.0-6+rpi1)
  configuration: --prefix=/usr --extra-version='1+rpt1~deb10u1' --toolchain=hardened --libdir=/usr/lib/arm-linux-gnueabihf --incdir=/usr/include/arm-linux-gnueabihf --arch=arm --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-avisynth --enable-gnutls --enable-ladspa --enable-libaom --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opengl --enable-sdl2 --enable-omx-rpi --enable-mmal --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared
  libavutil      56. 22.100 / 56. 22.100
  libavcodec     58. 35.100 / 58. 35.100
  libavformat    58. 20.100 / 58. 20.100
  libavdevice    58.  5.100 / 58.  5.100
  libavfilter     7. 40.101 /  7. 40.101
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  3.100 /  5.  3.100
  libswresample   3.  3.100 /  3.  3.100
  libpostproc    55.  3.100 / 55.  3.100
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'furiadeloskaratecas1983.mp4':
  Metadata:
    major_brand     : mp42
    minor_version   : 0
    compatible_brands: isommp42
    creation_time   : 2015-11-27T06:39:43.000000Z
  Duration: 01:25:56.97, start: 0.000000, bitrate: 1590 kb/s
    Stream #0:0(und): Video: h264 (High) (avc1 / 0x31637661), yuv420p, 1280x720 [SAR 1:1 DAR 16:9], 1395 kb/s, 25 fps, 25 tbr, 25 tbn, 50 tbc (default)
    Metadata:
      handler_name    : VideoHandler
    Stream #0:1(und): Audio: aac (LC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 192 kb/s (default)
    Metadata:
      creation_time   : 2015-11-27T06:40:23.000000Z
      handler_name    : IsoMedia File Produced by Google, 5-11-2011
"@

$ffmpeg = $ffmpeg -split ("`n")

[video]$ThisVideo = @{
    "FileName" = $((Get-ChildItem $Filename).ToString())
    "MajorBrand" = $null
    "MinorVersion" = $null
    "CompatibleBrands" = $null
    "CreationTime" = $null
    "Duration" = $null
    "Start" = $null
    "BitRate" = $null
    "VideoStream" = $null
    "AudioStream" = $null
    "HandlerName" = $null
}

$ffmpeg.ForEach({
    if($PSItem -match "major_brand"){
        $ThisVideo.MajorBrand = $($PSItem.Trim() -replace "major_brand     : ","")
    }
    if($PSItem -match "minor_version"){
        $ThisVideo.MinorVersion = $($PSItem.Trim() -replace "minor_version   : ","")
    }
    if($PSItem -match "compatible_brands"){
        $ThisVideo.CompatibleBrands = $($PSItem.Trim() -replace "compatible_brands: ","")
    }

    if($PSItem -match "handler_name"){
        $ThisVideo.HandlerName += $($PSItem.Trim() -replace "handler_name    : ","")
    }
    #Only capture the first creation time, until streams are better understood
    if($PSItem -match "creation_time" -and $ThisVideo.CreationTime -eq ""){
        $ThisVideo.CreationTime = $($PSItem.Trim() -replace "creation_time   : ","")
    }
    if($PSItem -match "Duration"){
        $Duration = ([regex]::Match($PSItem,"Duration: [0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{1,}")).Value
        $Duration = $Duration -replace "Duration: ",""
        $Duration = $Duration -replace "\.",":"
        $Duration = $Duration -split ":"
        $Duration = @{
            "Hours" = $Duration[0]
            "Minutes" = $Duration[1]
            "Seconds" = $Duration[2]
            "Milliseconds" = $Duration[3]
        }
        $ThisVideo.Duration = $Duration
    }
    if($PSItem -match "start"){
        $Start = ([regex]::Match($PSItem,"start: [0-9]{1,}\.[0-9]{1,6}")).Value
        $Start = $Start -replace "start: ",""
        $ThisVideo.Start = $Start
    }
    if($PSItem -match "bitrate"){
        $BitRate = ([regex]::Match($PSItem,"bitrate: [0-9]{1,4}\s[a-z]b/s")).Value
        $BitRate = $BitRate -replace "bitrate: ",""
        $ThisVideo.BitRate = $BitRate
    }
    if($PSItem -match "Video: "){
        $VideoStream = ([regex]::Match($PSItem,"Video: .{1,}$")).Value
        $VideoStream = $VideoStream -replace "Video: ",""
        $VideoStream = $VideoStream -split ","
        $ThisVideo.VideoStream = $VideoStream
    }
    if($PSItem -match "Audio: "){
        $AudioStream = ([regex]::Match($PSItem,"Audio: .{1,}$")).Value
        $AudioStream = $AudioStream -replace "Audio: ",""
        $AudioStream = $AudioStream -split ","
        $ThisVideo.AudioStream = $AudioStream
    }
})
