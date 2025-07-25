# Automated Testing Suite

> **A comprehensive test automation framework using Robot Framework for API and web UI testing**

[![Tests](https://img.shields.io/badge/tests-28%2F28%20passing-brightgreen)](./tests)
[![Python](https://img.shields.io/badge/python-3.8%2B-blue)](https://python.org)
[![Robot Framework](https://img.shields.io/badge/robot%20framework-6.1.1-orange)](https://robotframework.org)

This project demonstrates modern test automation practices through a comprehensive testing suite that validates both REST API endpoints and web user interfaces. Built as a learning exercise to explore automated testing methodologies and best practices.

## 🚀 Quick Start

Get the test suite running in under 3 minutes:

```bash
# Clone and navigate to project
git clone <repository-url>
cd pixelbro

# Set up Python environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run all tests
robot tests/
```

## 📋 What's Inside

### API Test Suite (5 modules)

Comprehensive testing of the **REST Countries API** covering:

- **`countries_all.robot`** - Full country dataset validation and structure verification
- **`countries_search.robot`** - Name-based search functionality with edge cases
- **`countries_region.robot`** - Regional filtering (Europe, Asia, Africa) and population analysis
- **`countries_currency.robot`** - Currency-based filtering with data structure validation
- **`countries_code.robot`** - Country code lookups (ISO Alpha-2/3) and consistency checks

### Web UI Test Suite (1 module)

Browser automation testing for:

- **`youtube_homepage.robot`** - Page load verification and search functionality testing

## 🔧 Prerequisites

- **Python 3.8+** (for Robot Framework compatibility)
- **Chrome browser** (for Selenium WebDriver)
- **Internet connection** (for API calls and web testing)

## 🏃‍♂️ Running Tests

### Run Everything

```bash
robot tests/
```

### Run Specific Test Suites

```bash
# API tests only (faster execution)
robot tests/api/

# Web UI tests only
robot tests/webui/

# Run by tags
robot --include smoke tests/        # Quick smoke tests
robot --include api tests/          # All API tests
robot --include negative tests/     # Error handling tests
```

### Test Reports

After running tests, you'll find detailed reports in:

- **`report.html`** - Test execution summary with pass/fail status
- **`log.html`** - Detailed step-by-step execution log
- **`output.xml`** - Machine-readable results for CI/CD integration

## 📁 Project Structure

```
pixelbro/
├── tests/
│   ├── api/                    # REST API test modules
│   │   ├── countries_all.robot
│   │   ├── countries_search.robot
│   │   ├── countries_region.robot
│   │   ├── countries_currency.robot
│   │   └── countries_code.robot
│   └── webui/                  # Web UI test modules
│       └── youtube_homepage.robot
├── resources/
│   └── common.robot           # Shared keywords and variables
├── requirements.txt           # Python dependencies
└── README.md                 # This file
```

## 🎯 Test Coverage

| Test Type    | Test Cases   | Coverage Areas                                               |
| ------------ | ------------ | ------------------------------------------------------------ |
| API Tests    | 26 cases     | CRUD operations, data validation, error handling, edge cases |
| Web UI Tests | 2 cases      | Page loading, search functionality                           |
| **Total**    | **28 cases** | **100% pass rate**                                           |

## 🛠️ Built With

- **[Robot Framework 6.1.1](https://robotframework.org)** - Test automation framework
- **[Selenium Library](https://github.com/robotframework/SeleniumLibrary)** - Web browser automation
- **[Requests Library](https://github.com/MarketSquare/robotframework-requests)** - HTTP API testing
- **[REST Countries API](https://restcountries.com)** - Free API for testing purposes

## 💡 Key Features

- **Page Object Model** implementation for maintainable web tests
- **Data-driven testing** with multiple test scenarios
- **Negative testing** for error handling validation
- **Parallel execution** support for faster test runs
- **Comprehensive reporting** with detailed logs and screenshots
- **CI/CD ready** with XML output for integration pipelines

## 🔍 Test Philosophy

This project emphasizes:

- **Reliability** - Tests are stable and produce consistent results
- **Maintainability** - Clean code structure with reusable components
- **Coverage** - Both happy path and edge case scenarios
- **Documentation** - Clear test descriptions and reporting
