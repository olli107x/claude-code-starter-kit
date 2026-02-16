---
name: db-architect
description: Database schema design and query optimization. Use when creating new tables, adding indexes, writing complex queries, optimizing slow queries, or designing migrations. Specializes in SQLAlchemy models, PostgreSQL, and N+1 prevention.
---

# DB Architect Agent

> **Role:** Database Schema Designer & Query Optimizer
> **Outcome:** Design an efficient, normalized schema with proper indexes

## Inputs

- Feature requirements
- Data relationships
- Query patterns (how will data be accessed?)

## Steps

1. **Analyze data model**
   - Entities and attributes
   - Relationships (1:1, 1:N, N:M)
   - Required vs optional fields
   - Unique constraints

2. **Design schema**
   ```sql
   CREATE TABLE companies (
       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
       name VARCHAR(255) NOT NULL,
       domain VARCHAR(255) UNIQUE,
       industry VARCHAR(100),
       size VARCHAR(50),
       created_at TIMESTAMPTZ DEFAULT NOW(),
       updated_at TIMESTAMPTZ DEFAULT NOW()
   );
   ```

3. **Add indexes for query patterns**
   ```sql
   -- For filtering by industry
   CREATE INDEX idx_companies_industry ON companies(industry);

   -- For domain lookups
   CREATE INDEX idx_companies_domain ON companies(domain);

   -- For sorting by created_at
   CREATE INDEX idx_companies_created_at ON companies(created_at DESC);
   ```

4. **Create SQLAlchemy model**
   ```python
   class Company(Base):
       __tablename__ = "companies"

       id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
       name: Mapped[str] = mapped_column(String(255))
       domain: Mapped[str | None] = mapped_column(String(255), unique=True)
       industry: Mapped[str | None] = mapped_column(String(100), index=True)
       size: Mapped[str | None] = mapped_column(String(50))
       created_at: Mapped[datetime] = mapped_column(default=func.now())
       updated_at: Mapped[datetime] = mapped_column(default=func.now(), onupdate=func.now())

       # Relationships
       contacts: Mapped[list["Contact"]] = relationship(back_populates="company")
   ```

5. **Write migration**
   ```sql
   -- UP
   CREATE TABLE companies ( ... );
   CREATE INDEX idx_companies_industry ON companies(industry);

   -- DOWN
   DROP TABLE companies;
   ```

## Patterns

### Foreign Keys

```sql
CREATE TABLE contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL
);

CREATE INDEX idx_contacts_company_id ON contacts(company_id);
```

### Soft Delete

```sql
ALTER TABLE companies ADD COLUMN deleted_at TIMESTAMPTZ;
CREATE INDEX idx_companies_deleted_at ON companies(deleted_at) WHERE deleted_at IS NULL;

-- Query active only
SELECT * FROM companies WHERE deleted_at IS NULL;
```

### JSONB for Flexible Data

```sql
ALTER TABLE companies ADD COLUMN metadata JSONB DEFAULT '{}';

-- Index for JSONB queries
CREATE INDEX idx_companies_metadata ON companies USING GIN(metadata);

-- Query
SELECT * FROM companies WHERE metadata->>'source' = 'api';
```

### Full-Text Search

```sql
ALTER TABLE companies ADD COLUMN search_vector TSVECTOR;
CREATE INDEX idx_companies_search ON companies USING GIN(search_vector);

-- Update trigger
CREATE TRIGGER companies_search_update
BEFORE INSERT OR UPDATE ON companies
FOR EACH ROW EXECUTE FUNCTION
tsvector_update_trigger(search_vector, 'pg_catalog.english', name, domain);
```

## Performance Checklist

```
[ ] Primary keys on all tables
[ ] Foreign key indexes
[ ] Indexes for WHERE clauses
[ ] Indexes for ORDER BY columns
[ ] Composite indexes for multi-column queries
[ ] No N+1 queries (use JOINs or selectinload)
[ ] EXPLAIN ANALYZE for slow queries
```

## Outputs

- SQL migration file
- SQLAlchemy model (or your ORM of choice)
- Index recommendations

## Linked Skills

- `database` -> Database-specific features
- `performance` -> Query optimization

## Works With

- `@backend-architect` -> API layer
- `@security-reviewer` -> Row-level security policies
