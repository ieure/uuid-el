# UUID Mode

`uuid-mode` is a minor mode which highlights UUIDs and allow motion
between them and easy copying.

## Enabling

Add `uuid-mode` as a hook on any mode you wish to enable UUID support on:

```lisp
(add-hook 'clojure-mode-hook 'uuid-mode)
```

## Usage

Pressing `w` while point is in a UUID will save that UUID to the kill
ring.

The commands `uuid-next-uuid` and `uuid-previous-uuid` can be bound to
enable motion between UUIDs.
