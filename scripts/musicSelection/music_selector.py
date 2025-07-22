#!/usr/bin/env python3
# /// script
# dependencies = ["python-mpd2"]
# ///

import argparse
import os
import random
import re
import subprocess
import sys
from typing import List, Tuple, Optional
import mpd


class MusicSelector:
    def __init__(self):
        self.client = mpd.MPDClient()
        try:
            self.client.connect("localhost", 6600)
        except mpd.ConnectionError as e:
            print(f"Failed to connect to MPD: {e}")
            sys.exit(1)

    def __del__(self):
        if hasattr(self, 'client'):
            self.client.close()
            self.client.disconnect()

    def rofi_select(self, items: List[str], prompt: str, selected_row: int = 0, use_column_formatting: bool = False) -> Tuple[Optional[str], bool]:
        """Use rofi to select an item. Returns (selected_item, is_queue_mode)"""
        if not items:
            return None, False
        
        input_text = "\n".join(items)
        
        # Use column formatting if requested (for tabular data)
        if use_column_formatting:
            try:
                column_cmd = ["column", "-o", "           ", "-s", "\t", "-t"]
                column_result = subprocess.run(column_cmd, input=input_text, text=True, capture_output=True)
                if column_result.returncode == 0:
                    formatted_input = column_result.stdout
                else:
                    formatted_input = input_text
            except subprocess.CalledProcessError:
                formatted_input = input_text
        else:
            formatted_input = input_text
        
        cmd = [
            "rofi", "-i", "-dmenu", "-no-custom", "-format", "d",
            "-kb-custom-1", "Ctrl+Return", "-p", prompt,
            "-selected-row", str(selected_row)
        ]
        
        try:
            result = subprocess.run(cmd, input=formatted_input, text=True, capture_output=True)
            exit_code = result.returncode
            
            if exit_code == 1:  # User canceled
                return None, False
            
            if result.stdout.strip():
                index = int(result.stdout.strip()) - 1
                selected = items[index] if 0 <= index < len(items) else None
                is_queue = exit_code == 10  # Ctrl+Return pressed
                return selected, is_queue
            else:
                return None, False
                
        except (subprocess.CalledProcessError, ValueError, IndexError):
            return None, False

    def get_artists(self) -> List[str]:
        """Get all artists from MPD database"""
        try:
            artists = self.client.list("albumartist")
            return [artist["albumartist"] for artist in artists if artist["albumartist"].strip()]
        except mpd.CommandError as e:
            print(f"Error getting artists: {e}")
            return []

    def get_albums(self, artist: Optional[str] = None) -> List[Tuple[str, str]]:
        """Get albums, optionally filtered by artist. Returns (artist, album) tuples"""
        try:
            if artist:
                albums = self.client.find("albumartist", artist)
            else:
                albums = self.client.listallinfo()
            
            album_set = set()
            for track in albums:
                if 'albumartist' in track and 'album' in track:
                    album_set.add((track['albumartist'], track['album']))
            
            return list(album_set)
        except mpd.CommandError as e:
            print(f"Error getting albums: {e}")
            return []

    def get_songs(self, artist: str, album: str) -> List[str]:
        """Get songs from a specific album by artist"""
        try:
            songs = self.client.find("albumartist", artist, "album", album)
            return [song.get('title', '') for song in songs if 'title' in song]
        except mpd.CommandError as e:
            print(f"Error getting songs: {e}")
            return []

    def play_song(self, artist: str, album: str, title: str, queue_mode: bool = False):
        """Play or queue a song"""
        try:
            if not queue_mode:
                # Clear playlist and add entire album
                subprocess.run(["mpc", "clear"], check=True)
                subprocess.run(["mpc", "findadd", "album", album, "albumartist", artist], check=True)
                
                # Find the song position in playlist
                playlist = subprocess.run(["mpc", "playlist", "-f", "%title%"], 
                                       capture_output=True, text=True, check=True)
                songs = playlist.stdout.strip().split('\n')
                
                try:
                    position = songs.index(title) + 1
                    subprocess.run(["mpc", "play", str(position)], check=True)
                    print(f"Playing:\n{artist}\n{album}\n{title}")
                except ValueError:
                    print(f"Could not find song '{title}' in playlist")
                    subprocess.run(["mpc", "play"], check=True)
            else:
                # Queue the specific song
                subprocess.run(["mpc", "findadd", "albumartist", artist, "album", album, "title", title], check=True)
                print(f"Queued:\n{artist}\n{album}\n{title}")
                
        except subprocess.CalledProcessError as e:
            print(f"Error playing song: {e}")

    def show_notification(self, artist: str, album: str, title: str = None):
        """Show desktop notification for now playing"""
        try:
            if title:
                message = f"{artist}\n{album}\n{title}"
                summary = "Now Playing"
            else:
                message = f"{artist}\n{album}"
                summary = "Now Playing Album"
            
            subprocess.run([
                "notify-send", "-t", "3000", summary, message
            ], check=False)
        except subprocess.CalledProcessError:
            pass

    def play_random_album(self):
        """Play a random album without user interaction"""
        albums = self.get_albums()
        if not albums:
            print("No albums found")
            return
        
        artist, album = random.choice(albums)
        
        try:
            subprocess.run(["mpc", "clear"], check=True)
            subprocess.run(["mpc", "findadd", "album", album, "albumartist", artist], check=True)
            subprocess.run(["mpc", "play"], check=True)
            
            print(f"Playing random album:\n{artist}\n{album}")
            self.show_notification(artist, album)
            
        except subprocess.CalledProcessError as e:
            print(f"Error playing random album: {e}")

    def load_quarantine_albums(self) -> List[Tuple[str, str]]:
        """Load albums from ~/music/quarantine file. Returns (artist, album) tuples"""
        quarantine_file = os.path.expanduser("~/music/quarantine")
        albums = []
        
        try:
            with open(quarantine_file, 'r') as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    
                    # Parse format: "Artist Name", "Album Name"
                    match = re.match(r'^"([^"]*)",\s*"([^"]*)"$', line)
                    if match:
                        artist, album = match.groups()
                        albums.append((artist, album))
            
            return albums
        except FileNotFoundError:
            print(f"Quarantine file not found: {quarantine_file}")
            return []
        except IOError as e:
            print(f"Error reading quarantine file: {e}")
            return []

    def select_quarantine_album(self, random_mode: bool = False) -> Optional[Tuple[str, str, bool]]:
        """Select album from quarantine list. Returns (artist, album, queue_mode)"""
        albums = self.load_quarantine_albums()
        if not albums:
            print("No quarantine albums found")
            return None
        
        if random_mode:
            # Random selection without user prompt
            artist, album = random.choice(albums)
            return artist, album, False
        else:
            # Interactive selection with rofi
            tab_separated_items = [f"{artist}\t{album}" for artist, album in albums]
            selected_display, queue_mode = self.rofi_select(tab_separated_items, "Quarantine Album:", use_column_formatting=True)
            
            if selected_display:
                index = tab_separated_items.index(selected_display)
                artist, album = albums[index]
                return artist, album, queue_mode
        
        return None

    def play_random_quarantine_album(self):
        """Play a random quarantine album without user interaction"""
        result = self.select_quarantine_album(random_mode=True)
        if not result:
            return
        
        artist, album, _ = result
        
        try:
            subprocess.run(["mpc", "clear"], check=True)
            subprocess.run(["mpc", "findadd", "album", album, "albumartist", artist], check=True)
            subprocess.run(["mpc", "play"], check=True)
            
            print(f"Playing random quarantine album:\n{artist}\n{album}")
            self.show_notification(artist, album)
            
        except subprocess.CalledProcessError as e:
            print(f"Error playing random quarantine album: {e}")

    def show_playlist(self):
        """Show current playlist with rofi, with current song preselected"""
        try:
            # Get current playlist
            playlist = self.client.playlistinfo()
            if not playlist:
                print("Playlist is empty")
                return
            
            # Get current song position
            status = self.client.status()
            current_pos = int(status.get('song', -1)) if 'song' in status else -1
            
            # Format playlist items
            playlist_items = []
            for i, track in enumerate(playlist):
                artist = track.get('albumartist', track.get('artist', 'Unknown Artist'))
                title = track.get('title', 'Unknown Title')
                
                # Add track number if available
                track_field = track.get('track', '')
                if isinstance(track_field, list):
                    track_num = track_field[0] if track_field else ''
                else:
                    track_num = str(track_field).split('/')[0] if track_field else ''
                if track_num:
                    display_title = f"{track_num.zfill(2)} {title}"
                else:
                    display_title = title
                
                playlist_items.append(f"{artist}\t{display_title}")
            
            # Show rofi with current song preselected
            selected_display, _ = self.rofi_select(
                playlist_items, 
                "Playlist:", 
                selected_row=current_pos,
                use_column_formatting=True
            )
            
            if selected_display:
                # Get the selected position and jump to that song
                index = playlist_items.index(selected_display)
                subprocess.run(["mpc", "play", str(index + 1)], check=True)
                
                # Show notification
                track = playlist[index]
                artist = track.get('albumartist', track.get('artist', 'Unknown Artist'))
                album = track.get('album', 'Unknown Album')
                title = track.get('title', 'Unknown Title')
                self.show_notification(artist, album, title)
                
        except (mpd.CommandError, subprocess.CalledProcessError) as e:
            print(f"Error showing playlist: {e}")

    def select_artist(self) -> Optional[str]:
        """Artist selection workflow"""
        artists = self.get_artists()
        if not artists:
            print("No artists found")
            return None
        
        random.shuffle(artists)
        selected, _ = self.rofi_select(artists, "Artist:")
        return selected

    def select_album(self, artist: Optional[str] = None) -> Optional[Tuple[str, str, bool]]:
        """Album selection workflow. Returns (artist, album, queue_mode)"""
        albums = self.get_albums(artist)
        if not albums:
            print("No albums found")
            return None
        
        random.shuffle(albums)
        
        if artist:
            # Show only album names when artist is pre-selected
            album_names = [album for _, album in albums]
            selected_album, queue_mode = self.rofi_select(album_names, "Album:")
            if selected_album:
                return artist, selected_album, queue_mode
        else:
            # Show "artist\talbum" format for column formatting
            tab_separated_items = [f"{artist}\t{album}" for artist, album in albums]
            selected_display, queue_mode = self.rofi_select(tab_separated_items, "Album:", use_column_formatting=True)
            
            if selected_display:
                # Find the corresponding album from the original items
                index = tab_separated_items.index(selected_display)
                artist, album = albums[index]
                return artist, album, queue_mode
        
        return None

    def select_song(self, artist: str, album: str, preselect_index: int = 0) -> Optional[Tuple[str, bool]]:
        """Song selection workflow. Returns (title, queue_mode)"""
        songs = self.get_songs(artist, album)
        if not songs:
            print("No songs found")
            return None
        
        selected, queue_mode = self.rofi_select(songs, "Choose a song:", preselect_index)
        if selected:
            return selected, queue_mode
        return None


def main():
    parser = argparse.ArgumentParser(description="Music selection tool")
    parser.add_argument("--artist", help="Pre-select artist")
    parser.add_argument("--album", help="Pre-select album (requires --artist)")
    parser.add_argument("--preselect", type=int, default=0, help="Pre-select song index")
    
    subparsers = parser.add_subparsers(dest="command", help="Commands")
    subparsers.add_parser("artist", help="Select artist then album then song")
    subparsers.add_parser("album", help="Select album then song")
    subparsers.add_parser("song", help="Select song from all songs")
    subparsers.add_parser("random", help="Play a random album without prompts")
    subparsers.add_parser("quarantine", help="Select album from quarantine list")
    subparsers.add_parser("random-quarantine", help="Play a random quarantine album without prompts")
    subparsers.add_parser("playlist", help="Show current playlist and jump to selected song")
    
    args = parser.parse_args()
    
    selector = MusicSelector()
    
    if args.command == "artist":
        # Artist -> Album -> Song workflow
        artist = selector.select_artist()
        if not artist:
            sys.exit(1)
        
        result = selector.select_album(artist)
        if not result:
            sys.exit(1)
        artist, album, queue_mode = result
        
        if queue_mode:
            # Queue entire album
            subprocess.run(["mpc", "findadd", "album", album, "albumartist", artist])
        else:
            # Go to song selection
            song_result = selector.select_song(artist, album, args.preselect)
            if song_result:
                title, song_queue_mode = song_result
                selector.play_song(artist, album, title, song_queue_mode)
    
    elif args.command == "album":
        # Album -> Song workflow
        if args.artist and args.album:
            # Direct album specification
            artist, album = args.artist, args.album
            song_result = selector.select_song(artist, album, args.preselect)
            if song_result:
                title, queue_mode = song_result
                selector.play_song(artist, album, title, queue_mode)
        else:
            # Interactive album selection
            result = selector.select_album(args.artist)
            if not result:
                sys.exit(1)
            artist, album, queue_mode = result
            
            if queue_mode:
                # Queue entire album
                subprocess.run(["mpc", "findadd", "album", album, "albumartist", artist])
            else:
                # Go to song selection
                song_result = selector.select_song(artist, album, args.preselect)
                if song_result:
                    title, song_queue_mode = song_result
                    selector.play_song(artist, album, title, song_queue_mode)
    
    elif args.command == "random":
        # Random album playback
        selector.play_random_album()
    
    elif args.command == "quarantine":
        # Quarantine album selection
        result = selector.select_quarantine_album()
        if not result:
            sys.exit(1)
        artist, album, queue_mode = result
        
        if queue_mode:
            # Queue entire album
            subprocess.run(["mpc", "findadd", "album", album, "albumartist", artist])
        else:
            # Go to song selection
            song_result = selector.select_song(artist, album, args.preselect)
            if song_result:
                title, song_queue_mode = song_result
                selector.play_song(artist, album, title, song_queue_mode)
    
    elif args.command == "random-quarantine":
        # Random quarantine album playback
        selector.play_random_quarantine_album()
    
    elif args.command == "playlist":
        # Show current playlist
        selector.show_playlist()
    
    else:
        # Default: album selection
        result = selector.select_album()
        if not result:
            sys.exit(1)
        artist, album, queue_mode = result
        
        if queue_mode:
            # Queue entire album
            subprocess.run(["mpc", "findadd", "album", album, "albumartist", artist])
        else:
            # Go to song selection
            song_result = selector.select_song(artist, album)
            if song_result:
                title, song_queue_mode = song_result
                selector.play_song(artist, album, title, song_queue_mode)


if __name__ == "__main__":
    main()
