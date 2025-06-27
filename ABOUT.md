
## Build & Test Commands

```bash
# Create and activate Python virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate.bat  # Windows

# Install dependencies
pip install -r requirements.txt

# Run all Robot Framework tests
robot test_cases/

# Run a single Robot test file
robot test_cases/login_mobile.robot

# Run a specific test case by name
robot -t "Test case name" test_cases/login_mobile.robot

# Run tests with specific tag
robot -i usuario test_cases/login_mobile.robot

# Generate report and log
robot --outputdir results test_cases/
```

## Code Style Guidelines

- **Robot Framework**: Use Gherkin-style (Given/When/Then) for test cases
- **Resources**: Modularize test resources by feature area
- **Naming**: Use descriptive names for tests, variables, and keywords
- **Formatting**: Use consistent indentation (4 spaces for Robot Framework files)
- **Variables**: Define variables in resource files for reusability
- **Keywords**: Create custom keywords for repetitive test steps
- **Documentation**: Add comments for complex Robot Keywords and test cases
- **Git**: Add large files (APKs) to .gitignore or use Git LFS for binaries