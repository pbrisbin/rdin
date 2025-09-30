> [!NOTE]
> All of my GitHub repositories have been **archived** and will be migrated to
> Codeberg as I next work on them. This repository either now lives, or will
> live, at:
>
> https://codeberg.org/pbrisbin/rdin
>
> If you need to report an Issue or raise a PR, and this migration hasn't
> happened yet, send an email to me@pbrisbin.com.

# Rdin

Import music into Rdio from a plain text file. We don't all use iTunes.

## Installation

~~~
$ git clone https://github.com/pbrisbin/rdin
$ cd rdin && cabal install
~~~

## Usage

Generate a text file containing one line per item you wish to import. 
That line should be of the form `artist album`.

Then:

~~~
$ rdin that-file.txt
~~~

`rdin` will execute an Album search via the Rdio API for each 
artist-album string and add the first result to your collection.

To add to your collection, you must grant `rdin` access. Upon running 
the tool, a url will be printed. Visit that link, grant access, and 
enter the provided PIN back into `rdin`.

## Options

*TODO*

| Option         | Description                                         | Default
| ---            | ---                                                 | ---
| `--exact-only` | Only add exact matches to your collection           | Add everything
| `--dry-run`    | Print matches but don't add them to your collection | Actually add

## Importing from MPD

To create a collection file from [MPD][], we'll put all or our music in 
one playlist then print and format that playlist:

[mpd]: https://en.wikipedia.org/wiki/Music_Player_Daemon

~~~
$ mpc clear
$ mpc listall | mpc add
$ mpc --format '%artist% %album%' lsplaylist | uniq > collection.txt
~~~

If you don't want to edit the collection file before passing to `rdin` 
you can also pass it directly via process substitution:

~~~
$ rdin <(mpc --format '%artist% %album%' lsplaylist | uniq)
~~~
