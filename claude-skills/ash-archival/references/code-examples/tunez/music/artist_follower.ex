#---
# Excerpted from "Ash Framework",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/ldash for more book information.
#---
# The final version of this file at the end of this chapter can be found at
# https://github.com/sevenseacat/tunez/blob/end-of-chapter-10/lib/tunez/music/artist_follower.ex

# ------------------------------------------------------------------------------
# Context: Adding a read action for fetching artist followers, that allows streaming
read :for_artist do
  argument :artist_id, :uuid do
    allow_nil? false
  end

  filter expr(artist_id == ^arg(:artist_id))
  pagination keyset?: true, required?: false
end
# ------------------------------------------------------------------------------
