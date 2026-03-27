# Contributing to AutoUX

Thanks for your interest in contributing to AutoUX!

## How to Contribute

### Reporting Issues

- Open an issue describing the problem, including your Claude Code version and setup
- For judge evaluation issues, include the judgment JSON if possible
- For Playwright issues, note your browser and MCP configuration

### Suggesting Features

- Open an issue with the `enhancement` label
- Describe the use case and why it would be valuable
- If proposing a new judge persona or rubric dimension, explain what it evaluates and why the existing dimensions don't cover it

### Submitting Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test by running the commands in a real frontend project
5. Submit a pull request

### What to Contribute

- **New judge personas** — Specialized evaluation dimensions (performance, animation, dark mode, i18n)
- **Framework-specific scope patterns** — Better auto-detection for frameworks not yet covered
- **Rubric improvements** — More precise score anchors, better gate criteria
- **Workflow improvements** — Better loop strategies, smarter ideation priorities
- **Documentation** — Usage examples, tutorials, best practices

### Code Style

- All skill/command files are Markdown with YAML frontmatter
- Follow the existing patterns in `SKILL.md` and `references/` files
- Keep instructions actionable and specific — avoid vague guidance
- Use tables for structured information
- Include examples for any new protocol or format

### Testing

Since AutoUX is a Claude Code skill (pure Markdown), there are no unit tests. Test your changes by:

1. Installing the modified skill in a real frontend project
2. Running each affected command
3. Verifying the agent follows the updated protocol correctly
4. Checking that judgment outputs match the expected format

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
