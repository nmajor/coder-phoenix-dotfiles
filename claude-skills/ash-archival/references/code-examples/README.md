# Tunez App - Complete Tutorial Code Examples

**Source:** Ash Framework: Create Declarative Elixir Web Apps
**Publisher:** Pragmatic Programmers (Beta 7.0, August 2025)
**Authors:** Rebecca Le & Zach Daniel (Ash Framework creator!)
**Chapter:** Final state (Chapter 10)

---

## What is the Tunez App?

Tunez is a **complete, working Ash application** built throughout the Pragmatic Ash Framework book. It's a music management application demonstrating real-world Ash patterns and best practices.

This code represents the **final, complete state** from Chapter 10, incorporating all features built throughout the book.

---

## Application Structure

### Domains

**Music Domain** (`tunez/music.ex`)
- Manages artists, albums, and tracks
- Handles artist followers (many-to-many relationships)
- Custom business logic for updating artist names

**Accounts Domain** (`tunez/accounts.ex`)
- User authentication and accounts
- Notification system for new albums
- User preferences and settings

---

## Resources

### Music Resources

**`tunez/music/artist.ex`** - Artist Resource
- **Demonstrates:** Complete resource definition, relationships, actions, policies
- **Relationships:**
  - `has_many :albums` - One artist has many albums
  - `many_to_many :followers` - Fans can follow artists
- **Key Features:** Custom validations, identities, lifecycle callbacks

**`tunez/music/album.ex`** - Album Resource
- **Demonstrates:** Belongs-to relationships, nested resources
- **Relationships:**
  - `belongs_to :artist` - Each album belongs to an artist
  - `has_many :tracks` - One album has many tracks
- **Key Features:** Automatic timestamp tracking, policies

**`tunez/music/artist_follower.ex`** - ArtistFollower Resource
- **Demonstrates:** Many-to-many join resource pattern
- **Pattern:** Classic join table for artist-user relationships
- **Key Features:** Composite identities, relationship management

### Account Resources

**`tunez/accounts/notification.ex`** - Notification Resource
- **Demonstrates:** User notifications, read/unread tracking
- **Relationships:** `belongs_to :user`
- **Key Features:** Boolean flags, filtering unread notifications

---

## Custom Changes (Business Logic)

**`tunez/music/changes/update_previous_names.ex`**
- **Demonstrates:** Custom change modules for business logic
- **Purpose:** Track artist name changes over time
- **Pattern:** before_action callback to update historical data

**`tunez/accounts/changes/send_new_album_notifications.ex`**
- **Demonstrates:** Side-effect changes (sending notifications)
- **Purpose:** Notify followers when artist releases new album
- **Pattern:** after_action callback for async operations

---

## Phoenix Integration

**`tunez_web/live/notifications_live.ex`** - Notifications LiveView
- **Demonstrates:** Phoenix LiveView with Ash
- **Features:** Real-time notification display, mark as read
- **Pattern:** Loading data with Ash queries in LiveView

**`tunez_web/components/layouts.ex`** - Layout Components
- **Demonstrates:** Phoenix components with Ash data
- **Pattern:** Displaying Ash resource data in templates

---

## Key Patterns Demonstrated

### 1. Resource Relationships
```elixir
# One-to-many
has_many :albums, Album, destination_attribute: :artist_id

# Many-to-many with join resource
many_to_many :followers, User do
  through ArtistFollower
  source_attribute_on_join_resource :artist_id
  destination_attribute_on_join_resource :user_id
end
```

### 2. Custom Change Modules
```elixir
# Encapsulate business logic
defmodule UpdatePreviousNames do
  use Ash.Resource.Change

  def change(changeset, _opts, _context) do
    # Business logic here
  end
end
```

### 3. Lifecycle Callbacks
```elixir
changes do
  change after_action(SendNotifications), on: [:create]
end
```

### 4. Phoenix LiveView Integration
```elixir
# Load Ash data in LiveView
def mount(_params, _session, socket) do
  notifications = Notification
    |> Ash.Query.filter(read == false)
    |> Accounts.read!()

  {:ok, assign(socket, :notifications, notifications)}
end
```

---

## How AI Enhancement Uses This Code

When building skills, the AI enhancement process:

1. **Scans all code files** looking for patterns relevant to each skill
2. **Extracts examples** that demonstrate specific features
3. **Adds context** from the book chapters explaining why code works this way
4. **Preserves structure** showing how real applications are organized

### Example: ash-core Skill
- Uses `artist.ex` to show complete resource definition
- Uses `artist_follower.ex` to demonstrate many-to-many
- Uses domain files to show organization

### Example: ash-phoenix Skill
- Uses LiveView files to show Phoenix integration
- Uses component files for UI patterns
- References authentication setup

### Example: ash-authentication Skill
- Looks for user resources with authentication
- Extracts auth configuration if present
- Shows real-world auth patterns

---

## Why This Code is Valuable

✅ **Authoritative** - Written by Zach Daniel (Ash creator himself!)
✅ **Complete** - Real application, not toy examples
✅ **Current** - Beta 7.0 (August 2025), latest Ash patterns
✅ **Tested** - From published book, reviewed and working
✅ **Practical** - Shows actual development patterns

---

## File Inventory

```
tunez/
├── music.ex                                    # Music domain definition
├── music/
│   ├── artist.ex                              # Artist resource
│   ├── album.ex                               # Album resource
│   ├── artist_follower.ex                     # Many-to-many join
│   └── changes/
│       └── update_previous_names.ex           # Custom change
├── accounts.ex                                 # Accounts domain
└── accounts/
    ├── notification.ex                         # Notification resource
    └── changes/
        └── send_new_album_notifications.ex    # Notification sender

tunez_web/
├── components/
│   └── layouts.ex                             # Layout components
└── live/
    └── notifications_live.ex                  # Notifications UI
```

---

## Using These Examples

The AI will automatically:
- Extract relevant code for each skill
- Add proper context and explanations
- Show how pieces fit together
- Reference book chapters for deeper learning

**You don't need to do anything** - just ensure these files are in the `references/code-examples/` folder when running the scraper!
