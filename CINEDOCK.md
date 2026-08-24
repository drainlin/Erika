# CineDock fork

This repository is a maintained fork of
[`AimesSoft/Erika`](https://github.com/AimesSoft/Erika). The `cinedock` branch
starts from upstream Erika `v0.1.7` (`7cd97dd9dd8b050e158e7d43efd05c116e272c2a`)
and contains the native and Flutter integration used by CineDock.

## Why this branch exists

- Apple FFmpeg builds enable HLS plus HTTP, HTTPS, TCP, TLS, and
  SecureTransport so nested playlists and media segments can be opened.
- The iOS pod builds the native engine from this checkout, keeping the Flutter
  package and native implementation on the same revision.
- Rebuffer recovery is configurable through the C ABI and Flutter API.
- iOS and macOS preserve Erika's native failure detail instead of reporting
  only a numeric `ErikaStatus`.
- iOS performs remote media probing away from Flutter's platform thread.

## Use from Flutter

Pin a tested commit instead of tracking a moving branch:

```yaml
dependencies:
  erika_flutter:
    git:
      url: https://github.com/drainlin/Erika.git
      ref: <tested-commit-sha>
      path: packages/erika_flutter
```

The default iOS build requires Rust and builds the fork's native source. Set
`ERIKA_IOS_CAPI_STATICLIB` only when intentionally supplying a compatible
prebuilt static library.

## Sync upstream

Configure the remotes once:

```sh
git remote add upstream https://github.com/AimesSoft/Erika.git
git fetch upstream --tags
```

Then update in a temporary branch, resolve and test the fork-specific changes,
and merge the result into `cinedock`:

```sh
git switch -c sync-upstream-<version> cinedock
git merge upstream/main
```

Do not force-push `cinedock`: downstream apps pin commit SHAs, and preserving
history makes upgrades and rollback reproducible across machines.
