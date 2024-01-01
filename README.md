# iadiscordia [![luacheck][luacheck badge]][luacheck workflow]  
IA Discordia Magick System
==========

[![Tip Me via PayPal](https://img.shields.io/badge/paypal-donate-FF1100.svg?logo=paypal&logoColor=FF1133&style=plastic)](https://www.paypal.me/InnovAnon)

----------

- Adds craftable Discordian novelties used for spellcasting.
- Adds a Chaos Magick player skill.
- Use the craftitems on books and see what happens 3:)
- How spells work:
  - Player must write a title and text.
    The title is the name of the spell.
  - Spell formula is expected spell text salted with the book owner and hashed.
  - Player must correctly guess some number of hash digits for spell success,
    depending on Chaos Magick skill.
  - Now supporting spells with same title, different formulae => different results
- Spells sold separately.
- Learn painful lessons in security models, including:
  - Something you know
  - Something you have
  - Something you are
  - Salt
  - One-way/trapdoor functions
- In-game documentation system
  - It's a magick book that hints at
    whether an item can be used for spellcasting and
    how to use it.
- Magick books that are just like normal books
  except that they randomize parameters in the spellcasting computation
- Suicide/dud spells (you don't know what a spell will do until you cast it... good luck)
- Various spellcasting methods:
  - "OG API"
    - write in a book node; use a magick item on the book node
      (salt `owner` is the book `owner`)
    - `engrave` a magick item; use the magick item
      (salt `owner` is the spellcaster)
  - "Extended API"
    - `engrave` a normal item; use the normal item on a magick node
      (salt `owner` is the spellcaster)
    - `pencil_redo` a normal node; use a magick item on the normal node
      (salt `owner` is the spellcaster)

<<<<<<< HEAD
TODO
- on_use_node should allow to replace or alter node
- a magick item to act on players instead of nodes
- recipes for the stickers
=======
## How it works
- Pay spell cost
  - Drain mana bar
  - Drain some amount of HP
  - This effectively rate limits the hashing computations that players will do
- Check secret incantation
  - The number of digits matched depends on the spellcaster level
  - salt (seed + owner + text)
  - This makes spells unique per player+world
- Compute new itemstack count
  - The new itemstack count depends on the spellcaster level
  - This makes transmutations (and spells in general) more costly
- Do spell logic
- Optionally replace itemstack

Magick is a game-breaking concept,
so I've made it extremely difficult to discover spells.

Spells are likely to fizzle once discovered.

With high spellcaster levels and big and expensive itemstacks,
spell logic will finally trigger,
and will be relatively weak.
Epic spellcaster levels have the potential to destroy areas of the map
and neutralize any number of players.

There will be thousands of spells.
The goal is to create a system where a player will be happy even if he only learns one spell...
and his only spell is literally shitty.
This shitwizard will be a valued member of society,
vertically integrating with the `biofuel` mod, the fuelcrafting `working_villager` and `iaflyingships` or `technic`.

## Summary
- Effectively, magick exists in the world
- it is very difficult to actually learn
- it is very weak once you get it right
- but there's a non-zero chance that a
  powerful wizard will usher in a sinister aeon.

## TODO
- on_use_node should allow to replace or alter node
- a magick item to act on players instead of nodes
- recipes for the stickers
- add wear to items
- potions, scrolls, magic circles, specific wands
- server-specific spell-storage to enable spells like: grant me a badge via a rest api (technically a consumable item that contains the elevated perms in another mod)

## Easter Eggs
- Player named "wizard"
  - starts at epic level
  - spells cost 1 MP, 1 HP
  - expected plaintext is salted with his name
    => he writes his spells in plaintext without worry about the hashing
>>>>>>> 02df97c251da3645c8387b88dd5c28f41fc97d8e

[luacheck badge]: https://github.com/InnovAnon-Inc/iadiscordia/workflows/luacheck/badge.svg
[luacheck workflow]: https://github.com/InnovAnon-Inc/iadiscordia/actions?query=workflow%3Aluacheck

----------

# InnovAnon, Inc. Proprietary (Innovations Anonymous)
> "Free Code for a Free World!"
----------

![Corporate Logo](https://innovanon-inc.github.io/assets/images/logo.gif)

