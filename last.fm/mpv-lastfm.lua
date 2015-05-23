-- last.fm scrobbler for mpv
--
-- Usage:
-- put this file in ~/.config/mpv/scripts
-- put lastfm.pl somewhere in your PATH
-- create a file ~/.config/lastfm with the following content:
-- $login = 'vpupkin';
-- $password = 'mycoolpassword';

local msg = require 'mp.msg'

function mkmetatable()
	local m = {}
	for i = 0, mp.get_property("metadata/list/count") - 1 do
		local p = "metadata/list/"..i.."/"
		m[mp.get_property(p.."key")] = mp.get_property(p.."value")
	end
	return m
end

function scrobble()
	mp.resume_all()
	-- Parameter escaping function. Works with POSIX shells; idk if there's a better way to call stuff portably in Lua.
	function esc(s)
		return string.gsub(s, "'", "'\\''")
	end

	msg.info(string.format("Scrobbling %s - %s", artist, title))

	-- Using https://github.com/l29ah/w3crapcli/blob/master/last.fm/lastfm.pl
	os.execute(string.format("lastfm.pl '%s' '%s' '%s' %d", esc(artist), esc(title), esc(album), length))
end

function enqueue()
	mp.resume_all()
	if artist and title then
		if not album then
			album = ""
		end
		if not length then
			length = 30	-- FIXME the old API sucks: it returns OK if the length is not specified/is 0/is -1, but doesn't scrobble anything.
		end

		if tim then tim.kill(tim) end
		tim = mp.add_timeout(math.min(240, length / 2), scrobble)
	end
end

function on_metadata()
	local m = mkmetatable()
	local icy = m["icy-title"]
	if icy then
		-- TODO better magic
		artist, title = string.gmatch(icy, "(.+) %- (.+)")()
		album = nil
		length = nil
	else
		length = mp.get_property("duration")
		if length and tonumber(length) < 30 then return end	-- last.fm doesn't allow scrobbling short tracks
		artist = m["artist"]
		if not artist then
			artist = m["ARTIST"]
		end
		album = m["album"]
		if not album then
			album = m["ALBUM"]
		end
		title = m["title"]
		if not title then
			title = m["TITLE"]
		end
	end
	enqueue()
end

mp.register_event("metadata-update", on_metadata)
mp.register_event("file-loaded", on_metadata)
