# Ash-Authentication - Providers

**Pages:** 2

---

## AshAuthentication.BcryptProvider (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.BcryptProvider.html

**Contents:**
- AshAuthentication.BcryptProvider (ash_authentication v4.12.0)
- Summary
- Functions
- Functions
- hash(input)
- Example
- simulate()
- Example
- valid?(input, hash)
- Example

Provides the default implementation of AshAuthentication.HashProvider using Bcrypt.

Given some user input as a string, convert it into it's hashed form using Bcrypt.

Simulate a password check to help avoid timing attacks.

Check if the user input matches the hash.

Given some user input as a string, convert it into it's hashed form using Bcrypt.

Simulate a password check to help avoid timing attacks.

Check if the user input matches the hash.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> {:ok, hashed} = hash("Marty McFly")
...> String.starts_with?(hashed, "$2b$04$")
true
```

Example 2 (unknown):
```unknown
iex> simulate()
false
```

Example 3 (unknown):
```unknown
iex> valid?("Marty McFly", "$2b$04$qgacrnrAJz8aPwaVQiGJn.PvryldV.NfOSYYvF/CZAGgMvvzhIE7S")
true
```

---

## AshAuthentication.HashProvider behaviour (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.HashProvider.html

**Contents:**
- AshAuthentication.HashProvider behaviour (ash_authentication v4.12.0)
- Summary
- Callbacks
- Callbacks
- hash(input)
- simulate()
- valid?(input, hash)

A behaviour providing password hashing.

Given some user input as a string, convert it into it's hashed form.

Attempt to defeat timing attacks by simulating a password hash check.

Check if the user input matches the hash.

Given some user input as a string, convert it into it's hashed form.

Attempt to defeat timing attacks by simulating a password hash check.

See Bcrypt.no_user_verify/1 for more information.

Check if the user input matches the hash.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---
