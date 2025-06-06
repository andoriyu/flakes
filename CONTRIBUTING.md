# Contributing to Personal Flakes

## Important Notice

**This is a personal-use-first repository.** These flakes are primarily designed for my own development needs and workflows. While you're welcome to use, fork, or contribute to this repository, please understand that:

- **No guarantees**: If something breaks when you use these flakes, that's on you
- **Personal priorities**: Changes will be made based on my needs first
- **Limited support**: I may not be able to help troubleshoot issues in your environment
- **Breaking changes**: I may introduce breaking changes without extensive deprecation notices

That said, contributions that improve the flakes without breaking my workflows are welcome!

## Getting Started

### Prerequisites

- Nix with flakes enabled
- Basic understanding of Nix flakes and development environments

### Using These Flakes

```bash
# Use a development shell
nix develop

# Add to your flake inputs
inputs.andoriyu-flakes.url = "github:andoriyu/flakes";
```

## Development Workflow

### Commit Message Format

This repository uses conventional commits format:

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `add`: Adding new packages or features
- `update`: Updating existing packages or dependencies
- `remove`: Removing packages or features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `refactor`: Code refactoring without functional changes
- `chore`: Maintenance tasks, CI/CD changes

**Scopes:**
- Package names (e.g., `bark`, `neo4j-mcp`)
- `overlay` for overlay modifications
- `deps` for dependency updates

**Examples:**
```
add(bark): AI voice synthesis package
update(neo4j-mcp): bump to version 1.2.0
remove(strongdm-cli): no longer needed
fix(overlay): correct package export
docs: update README with new packages
chore: update flake inputs
```

### Code Quality

This repository uses pre-commit hooks:
- **alejandra**: Nix code formatting
- **shellcheck**: Shell script linting  
- **statix**: Nix static analysis

The development shell automatically sets up these hooks.

### Adding New Packages

1. Create a new directory under `packages/`
2. Add a `default.nix` file with your package definition
3. Update `packages.nix` to include your package
4. Test the package builds: `nix build .#your-package`
5. Update the overlay if the package should be available system-wide

## Pull Requests

### Before Submitting

- [ ] Code follows the existing style (alejandra formatting)
- [ ] Pre-commit hooks pass
- [ ] Package builds successfully
- [ ] No breaking changes to existing functionality (unless discussed)
- [ ] Documentation updated if needed

### PR Guidelines

- Keep changes focused and atomic
- Provide clear description of what and why
- Test on your own system first
- Be prepared that PRs may be rejected if they don't align with my use cases

## Package Organization

### Directory Structure

```
packages/
├── package-name/
│   ├── default.nix
│   └── [additional files]
└── default.nix (imports all packages)
```

### Naming Conventions

- Use kebab-case for package directories
- Package names should be descriptive but concise
- Group related packages when it makes sense (e.g., `neo4j-mcp/`)

## Platform Support

These flakes support:
- `aarch64-darwin` (Apple Silicon)
- `aarch64-linux`
- `x86_64-linux`

When adding packages, consider cross-platform compatibility and use conditional logic when needed.

## Questions or Issues?

Remember: this is personal-use-first. While I may respond to issues or questions, there's no guarantee of support. Your best bet is to:

1. Read the code to understand how things work
2. Test thoroughly in your own environment
3. Fork and modify for your needs if something doesn't work

## License

This repository is provided as-is. Check individual packages for their specific licenses.
