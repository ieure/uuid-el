# UUID Mode

`uuid-mode` is a minor mode which highlights UUIDs and allow motion
between them and easy copying.

## Enabling

Add `uuid-mode` as a hook on any mode you wish to enable UUID support on:

```lisp
(add-hook 'clojure-mode-hook 'uuid-mode)
```

## Usage

Pressing `w` while point is in a UUID will save it to the kill ring.

The commands `forward-uuid` and `backward-uuid` can be bound to
enable motion between UUIDs.

This mode also adds a `'uuid` type for `thing-at-point`.
