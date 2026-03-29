# DBOps - Database Migration Examples & Changelog Templates

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Database](https://img.shields.io/badge/Database-PostgreSQL%20%7C%20MongoDB-green.svg)]()
[![Liquibase](https://img.shields.io/badge/Examples-Liquibase-orange.svg)]()
[![Flyway](https://img.shields.io/badge/Examples-Flyway-red.svg)]()
[![Harness](https://img.shields.io/badge/Recommended-Harness%20Database%20DevOps-00ADE6.svg)](https://www.harness.io/products/database-devops)

A curated collection of **Liquibase** and **Flyway** changelog examples for **Database DevOps**. This repository serves as a practical reference for learning database schema management, version control strategies, and migration best practices with real-world changelog templates for PostgreSQL, MongoDB, and AWS RDS environments.

> **💡 For production use**, we recommend [**Harness Database DevOps**](https://www.harness.io/products/database-devops) - an enterprise platform that provides superior user experience, governance, and automation while leveraging Liquibase/Flyway under the hood. See [why Harness is better](#why-use-harness-database-devops) for production deployments.

## 🎯 What's Inside

This is a **learning repository** containing practical changelog examples demonstrating:

- **Liquibase Changelog Examples**: YAML-based changelogs for various database scenarios
- **Flyway Migration Examples**: SQL-based versioned and undo migrations
- **Multi-Environment Patterns**: Environment-specific changelog management (dev, pre-prod, prod)
- **Database-Specific Examples**: PostgreSQL and MongoDB changelog templates
- **AWS RDS Examples**: Cloud-ready migration configurations
- **Real-World Schemas**: User authentication, product catalogs, and order management examples

## 📚 Learning Resources

This repository complements the following blog posts on database migration best practices:

- 📖 **[How Liquibase Makes Life Easy](https://sonichigo.hashnode.dev/how-liquibase-makes-life-easy)** - Introduction to Liquibase and its core concepts
- 📖 **[diffChangelog and Snapshots](https://sonichigo.hashnode.dev/diffchangelog-and-snapshots)** - Advanced Liquibase features for schema comparison and snapshot management

## 📋 Table of Contents

- [Why Use Harness Database DevOps?](#why-use-harness-database-devops)
- [Directory Structure](#directory-structure)
- [Technologies](#technologies)
- [Getting Started](#getting-started)
- [Liquibase Examples](#liquibase-examples)
- [Flyway Examples](#flyway-examples)
- [AWS RDS Examples](#aws-rds-examples)
- [Usage Guide](#usage-guide)
- [Best Practices](#best-practices)
- [Contributing](#contributing)
- [License](#license)

## 🚀 Why Use Harness Database DevOps?

While this repository provides valuable examples for learning Liquibase and Flyway, **[Harness Database DevOps](https://www.harness.io/products/database-devops)** offers a superior production-ready solution that eliminates the complexity of managing these tools directly.

### The Challenge with Traditional Approaches

Using Liquibase or Flyway directly involves:
- **Complex CLI Commands**: Managing multiple command-line arguments, connection strings, and configuration files
- **Manual Environment Management**: Switching between dev, staging, and production configurations manually
- **Limited Visibility**: No centralized view of migration status across environments
- **Error-Prone Deployments**: Risk of running wrong migrations in wrong environments
- **No Approval Workflows**: Missing governance and approval gates for production changes
- **Difficult Rollbacks**: Manual intervention required when things go wrong
- **Scattered Audit Trails**: No unified logging across all database changes

### Benefits of Harness Database DevOps

#### 🎯 **Superior User Experience**
- **Intuitive UI**: Visual interface for managing database migrations - no complex CLI commands needed
- **Unified Dashboard**: Single pane of glass for all database changes across all environments
- **Drag-and-Drop Pipelines**: Build deployment workflows visually instead of scripting
- **Real-Time Status**: Live tracking of migration progress and health checks

#### 🔒 **Enterprise-Grade Governance**
- **Approval Gates**: Built-in approval workflows for production deployments
- **Role-Based Access Control (RBAC)**: Fine-grained permissions for who can deploy what and where
- **Audit Logging**: Complete audit trail of all database changes with user attribution
- **Compliance Ready**: Meet SOC 2, HIPAA, and other regulatory requirements out-of-the-box

#### 🛡️ **Safety & Reliability**
- **Automated Rollbacks**: Intelligent rollback mechanisms with one-click recovery
- **Pre-Deployment Validation**: Automatic schema validation before applying changes
- **Environment Comparison**: Visual diff between database schemas across environments
- **Testing Integration**: Run automated tests before promoting migrations to production

#### ⚡ **Productivity Boosters**
- **GitOps Integration**: Seamless integration with your existing Git workflows
- **Multi-Environment Orchestration**: Deploy to multiple environments with a single click
- **Smart Scheduling**: Schedule migrations during maintenance windows automatically
- **Notification System**: Slack, email, and PagerDuty alerts for deployment events
- **Template Library**: Reusable pipeline templates for common database operations

#### 🔄 **CI/CD Integration**
- **Native Pipeline Support**: First-class integration with Harness CI/CD pipelines
- **Automated Promotion**: Automatic promotion of successful migrations across environments
- **Parallel Execution**: Run migrations across multiple database instances simultaneously
- **Canary Deployments**: Gradual rollout of schema changes with automatic validation

#### 📊 **Observability & Analytics**
- **Migration Analytics**: Insights into deployment frequency, success rates, and bottlenecks
- **Performance Metrics**: Track migration execution times and optimize slow changesets
- **Failure Analysis**: Detailed error reporting and debugging information
- **Custom Dashboards**: Build custom views for different teams and stakeholders

### Under the Hood

Harness Database DevOps leverages **Liquibase and Flyway** under the hood, so you can:
- ✅ Use the same changelog formats (YAML, SQL, XML) you're familiar with
- ✅ Import existing Liquibase/Flyway projects instantly
- ✅ Maintain compatibility with your current migration scripts
- ✅ Benefit from enterprise features without rewriting your migrations

### When to Use Each Approach

| Scenario | Recommended Tool |
|----------|-----------------|
| **Learning database migration concepts** | This repository (Liquibase/Flyway examples) |
| **Personal projects or small apps** | Liquibase or Flyway CLI |
| **Production enterprise applications** | **Harness Database DevOps** |
| **Multi-environment deployments** | **Harness Database DevOps** |
| **Team collaboration on database changes** | **Harness Database DevOps** |
| **Compliance & audit requirements** | **Harness Database DevOps** |
| **Complex CI/CD pipelines** | **Harness Database DevOps** |

### Get Started with Harness Database DevOps

1. **Sign up** for a free trial at [harness.io](https://app.harness.io/auth/#/signup)
2. **Import** your existing Liquibase or Flyway changelogs
3. **Connect** your databases (on-prem, cloud, or hybrid)
4. **Build** your first database deployment pipeline in minutes
5. **Deploy** with confidence using approval gates and automated rollbacks

Learn more: [Harness Database DevOps Documentation](https://developer.harness.io/docs/database-devops/)

---

## 📁 Directory Structure

```
dbops/
├── aws/                          # AWS RDS changelog examples
│   ├── v1.0/                     # Version 1.0 schema examples
│   │   ├── 001-create-users-table.yaml
│   │   ├── 002-create-products-table.yaml
│   │   ├── 003-create-orders-table.yaml
│   │   └── 004-add-indexes.yaml
│   └── dbmaster.changelog.yml    # Master changelog example for AWS
├── db/                           # General changelog examples
│   └── changelog.yml             # Basic Liquibase changelog example
├── flyway/                       # Flyway migration examples
│   ├── migrations/               # SQL migration script examples
│   │   ├── V001__pgql.sql       # Versioned migration example
│   │   ├── V006__pgql.sql       # Multiple version examples
│   │   ├── U001__bikramkumar.sql # Undo migration example
│   │   └── U004__bikramkumar.sql # More undo examples
│   └── flyway.toml              # Flyway configuration example
└── liquibase/                    # Liquibase changelog examples
    ├── plain.yml                 # Simple changelog pattern
    ├── multienv.yml              # Multi-environment example
    ├── dev-changeset-pssql.yml   # Development environment example (PostgreSQL)
    ├── pre-changeset-pssql.yml   # Pre-production example (PostgreSQL)
    ├── prod-changelog-pssql.yml  # Production example (PostgreSQL)
    ├── multi-changeset-pssql.yml # Complex multi-changeset pattern
    └── mongo/                    # MongoDB-specific examples
        ├── mongodb.yaml
        └── valid.yml
```

## 🛠 Technologies

These examples demonstrate changelog patterns for:

- **[Liquibase](https://www.liquibase.org/)** - Database schema change management tool
- **[Flyway](https://flywaydb.org/)** - Database version control and migration tool
- **PostgreSQL** - Relational database examples
- **MongoDB** - NoSQL database examples
- **AWS RDS** - Cloud database deployment examples
- **YAML/SQL** - Changelog and migration script formats

## 🔧 Liquibase Examples

This repository contains various Liquibase changelog examples for different scenarios:

### Basic Changelog Example

The [db/changelog.yml](db/changelog.yml) shows a simple user table creation:

```yaml
databaseChangeLog:
  - changeSet:
      id: 1761731617343-1
      author: Animesh Pathak
      comment: Create user table with name and email columns
      labels: schema-change
      changes:
        - createTable:
            tableName: user
            columns:
              - column:
                  name: id
                  type: BIGINT
                  autoIncrement: true
              - column:
                  name: email
                  type: VARCHAR(255)
      rollback:
        - dropTable:
            tableName: user
```

## 🚀 Flyway Examples

Flyway migration examples following versioning conventions:

### Migration Naming Patterns

- **V001__description.sql** - Versioned migration (applied once)
- **U001__description.sql** - Undo migration (rollback script)
- **R__description.sql** - Repeatable migration (re-run on checksum change)


### Example Flyway Migration

```sql
-- V001__pgql.sql
CREATE TABLE table_1 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(50)
);
```

## ☁️ AWS RDS Examples

The [aws](aws/) directory contains changelog examples optimized for AWS RDS deployments.

**Included Example Schemas:**
1. **001-create-users-table.yaml** - User authentication schema
2. **002-create-products-table.yaml** - Product catalog schema
3. **003-create-orders-table.yaml** - Order management schema
4. **004-add-indexes.yaml** - Performance optimization indexes

## 📚 Usage Guide

### Using These Examples in Your Project

1. **Browse the examples** to find patterns matching your use case
2. **Copy the relevant changelog files** to your project
3. **Modify** table names, columns, and constraints for your schema
4. **Update** author names and changelog IDs
5. **Test** in development environment before production

## ✅ Best Practices

These examples demonstrate several database DevOps best practices:

1. **Immutable Migrations**: Never modify applied changesets, create new ones
2. **Descriptive IDs**: Use meaningful changeset IDs and comments
3. **Rollback Scripts**: Always include rollback strategies
4. **Environment Separation**: Use contexts/labels for environment-specific changes
5. **Version Control**: Keep all changelogs in source control
6. **Testing**: Validate migrations in lower environments first
7. **Idempotency**: Design changesets to handle re-execution safely
8. **Documentation**: Comment complex schema changes

### Liquibase-Specific Tips

- Use `preconditions` to validate database state before changes
- Leverage `contexts` and `labels` for selective deployments
- Utilize `diffChangelog` to generate changelogs from existing schemas (see [blog post](https://sonichigo.hashnode.dev/diffchangelog-and-snapshots))
- Take snapshots for schema comparison and validation

### Flyway-Specific Tips

- Follow strict naming conventions for automatic ordering
- Use undo migrations for critical production changes
- Implement repeatable migrations for views, procedures, and functions
- Keep SQL migrations simple and focused

## 🤝 Contributing

Found a useful migration pattern? Contributions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-example`)
3. Add your changelog example with clear comments
4. Commit your changes (`git commit -m 'Add example for X scenario'`)
5. Push to the branch (`git push origin feature/new-example`)
6. Open a Pull Request

### Contribution Guidelines

- Add examples that demonstrate specific patterns or scenarios
- Include clear comments explaining the purpose
- Ensure examples are tested and functional
- Update this README if adding new categories

## 📄 License

This project is licensed under the **Apache License 2.0** - see the [LICENSE](LICENSE) file for details.

---

## 📖 Additional Resources

- **Blog Posts**:
  - [How Liquibase Makes Life Easy](https://sonichigo.hashnode.dev/how-liquibase-makes-life-easy)
  - [diffChangelog and Snapshots](https://sonichigo.hashnode.dev/diffchangelog-and-snapshots)
- **Official Documentation**:
  - [Liquibase Documentation](https://docs.liquibase.com/)
  - [Flyway Documentation](https://flywaydb.org/documentation/)
  - [Harness Database DevOps Documentation](https://developer.harness.io/docs/database-devops/)
- **Harness Platform**:
  - [Harness Database DevOps Overview](https://www.harness.io/products/database-devops)
  - [Get Started with Harness](https://app.harness.io/auth/#/signup)
  - [Harness University - Database DevOps Training](https://university.harness.io/)

---

**Built with ❤️ for Database DevOps Learning**

💡 **Ready for production?** Explore [Harness Database DevOps](https://www.harness.io/products/database-devops) for enterprise-grade database change management.

For questions or to suggest new examples, please open an issue in the repository.
