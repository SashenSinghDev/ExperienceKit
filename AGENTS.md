# ExperienceKit Agent Guide

This repo is the source of truth for AI work. Keep provider-specific files thin; canonical guidance lives in `AGENTS.md` and `docs/architecture/`.

## Start

- Read this file before changing code.
- Before editing code, reviewing changes, or planning implementation, read [docs/architecture/README.md](docs/architecture/README.md) and follow its routing guidance to the narrowest relevant reference document.
- Read every architecture reference that matches the task surface before implementation, review, or refactoring.
- Treat `docs/architecture/` as the authoritative architecture guidance for ExperienceKit components, example experiences, and repo workflow.

## Quick Reference

**Components**: See [docs/architecture/COMPONENTCREATION.md](docs/architecture/COMPONENTCREATION.md) before adding, wiring, or reviewing a component.

**Generated component scaffolds**: Create new components from the repo root with `./generate_component.sh`. Do not hand-create the initial component file set when the generator can do it.

**Example catalogue**: When adding a component, expose it through the example app and add a list entry in `Example/Example/AppExperience/Interactors/ExperienceListInteractor.swift`.

**Verification**: Prefer focused package and example-app checks for the touched surface. Document any skipped build or verification step, including the reason.

## Architecture References

Architecture references are the mandatory first stop for implementation, review, refactoring, and documentation changes. Start with [docs/architecture/README.md](docs/architecture/README.md), then read the matching reference docs before using workflow shortcuts or making changes.
