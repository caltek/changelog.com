defmodule Changelog.Album do
  defstruct [:name, :slug, :volume, :tagline, :description, :apple_id, :spotify_id, :bandcamp_url]

  def all do
    [theme_songs(), next_level()]
  end

  def get_by_slug(slug) do
    Enum.find(all(), fn album -> album.slug == slug end)
  end

  def theme_songs do
    %__MODULE__{
      name: "Theme Songs",
      slug: "theme-songs",
      volume: "00",
      tagline: "There's no place like $HOME",
      description: "This album kicks off with our classic podcast opening themes, carries through with some remixes & outros, then shifts gears to a brand  new set of Sonic-inspired theme remixes!",
      apple_id: "1712599257",
      spotify_id: "6MbcbUgjzk6B56U2xocLpH",
      bandcamp_url: "https://breakmastercylinder.bandcamp.com/album/changelog-beats-volumes-0-theme-songs"
    }
  end

  def next_level do
    %__MODULE__{
      name: "Next Level",
      slug: "next-level",
      volume: "01",
      tagline: "It's dangerous to go alone!",
      description: "From Castlevania to Contra to Zelda & many more... This album is inspired by the nostalgic soundtracks from the games of our youth!",
      apple_id: "1712372577",
      spotify_id: "5Kb5EvYAgQ40BkTEXbhZ4k",
      bandcamp_url: "https://breakmastercylinder.bandcamp.com/album/changelog-beats-volumes-1-next-level"
    }
  end
end
