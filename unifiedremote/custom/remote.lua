local kb = libs.keyboard;
local script = libs.script;


-- Documentation
-- http://www.unifiedremote.com/api

-- Script Library
-- http://www.unifiedremote.com/api/libs/script


--@help Volume up
actions.volumeUp = function ()
	script.default("pactl set-sink-volume @DEFAULT_SINK@ +4%");
end


--@help Volume down
actions.volumeDown = function ()
	script.default("pactl set-sink-volume @DEFAULT_SINK@ -4%");
end

--@help Toggle playback state
actions.videoPlayPause = function()
	kb.stroke("space");
end

--@help Navigate left
actions.videoRewind = function()
	kb.stroke("left");
end

--@help Navigate right
actions.videoForward = function()
	kb.stroke("right");
end

--@help Next track
actions.musicNext = function()
    os.script("mpc next");
end

--@help Previous track
actions.musicPrevious = function()
    os.script("mpc prev");
end

--@help Toggle playback state
actions.musicPlayPause = function()
    os.script("mpc toggle");
end