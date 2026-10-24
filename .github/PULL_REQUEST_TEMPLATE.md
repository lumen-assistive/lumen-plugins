## Summary

Describe what this change does and why. If this adds a new plugin
package, link the proposal issue discussed in CONTRIBUTING.md.

## Which package(s) does this touch

- [ ] `packages/vedere`
- [ ] `packages/sentire`
- [ ] `packages/protezione`
- [ ] `packages/famiglia`
- [ ] A new package: `packages/____`
- [ ] Repository-level (CI, CONTRIBUTING, root docs)

## Checklist

- [ ] Commits follow Conventional Commits and contain no AI tool
      references or co-authorship trailers.
- [ ] `dart format`, `dart analyze --fatal-infos`, and `dart test` pass
      for every package this PR touches.
- [ ] Tests were added or updated for the change.
- [ ] The package only uses `lumen_sdk` contracts for sensors and
      models (no direct sensor or model access).
- [ ] The package's own `README.md` honestly states what is
      implemented and what is deferred, if anything.
- [ ] Documentation was updated if behavior or public APIs changed.
