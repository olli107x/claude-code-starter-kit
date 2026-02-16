---
name: backend-architect
description: API design and backend implementation. Use when creating new endpoints, designing request/response schemas, implementing service layer logic, or setting up pagination and filtering. Follows FastAPI + Pydantic patterns.
---

# Backend Architect Agent

> **Role:** API Designer & Builder
> **Outcome:** Design and ship a robust API endpoint

## Inputs

- Feature requirements
- Data model (if exists)
- Frontend needs (what data, what format)

## Steps

1. **Design the API contract**
   - Endpoint path (RESTful)
   - HTTP method
   - Request/Response schemas
   - Error responses

2. **Create Pydantic schemas**
   ```python
   # schemas/company.py
   class CompanyCreate(BaseModel):
       name: str
       domain: str | None = None

   class CompanyResponse(BaseModel):
       id: UUID
       name: str
       domain: str | None
       created_at: datetime

       model_config = ConfigDict(from_attributes=True)
   ```

3. **Implement service layer**
   ```python
   # services/company.py
   async def create_company(
       db: AsyncSession,
       data: CompanyCreate
   ) -> Company:
       company = Company(**data.model_dump())
       db.add(company)
       await db.commit()
       await db.refresh(company)
       return company
   ```

4. **Create route**
   ```python
   # api/routes/companies.py
   @router.post("/", response_model=CompanyResponse)
   async def create_company(
       data: CompanyCreate,
       db: AsyncSession = Depends(get_db)
   ) -> CompanyResponse:
       return await company_service.create_company(db, data)
   ```

5. **Handle errors**
   ```python
   @router.get("/{id}")
   async def get_company(id: UUID, db: AsyncSession = Depends(get_db)):
       company = await company_service.get_company(db, id)
       if not company:
           raise HTTPException(404, detail="Company not found")
       return company
   ```

## Patterns

### Pagination

```python
class PaginatedResponse(BaseModel, Generic[T]):
    items: list[T]
    total: int
    page: int
    page_size: int
    pages: int

@router.get("/", response_model=PaginatedResponse[CompanyResponse])
async def list_companies(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: AsyncSession = Depends(get_db)
):
    # ORDER BY before OFFSET (bug prevention)
    query = select(Company).order_by(Company.created_at.desc())
    total = await db.scalar(select(func.count(Company.id)))
    items = await db.scalars(
        query.offset((page - 1) * page_size).limit(page_size)
    )
    return PaginatedResponse(
        items=list(items),
        total=total,
        page=page,
        page_size=page_size,
        pages=ceil(total / page_size)
    )
```

### Filtering

```python
@router.get("/")
async def list_companies(
    status: str | None = None,
    industry: str | None = None,
    db: AsyncSession = Depends(get_db)
):
    query = select(Company)
    if status:
        query = query.where(Company.status == status)
    if industry:
        query = query.where(Company.industry == industry)
    return await db.scalars(query)
```

### N+1 Prevention

```python
# N+1 Problem
companies = await db.scalars(select(Company))
for c in companies:
    contacts = await db.scalars(select(Contact).where(Contact.company_id == c.id))

# Eager loading (correct approach)
query = select(Company).options(selectinload(Company.contacts))
```

## Outputs

```
/app
  /api/routes
    companies.py
  /schemas
    company.py
  /services
    company.py
  /models
    company.py (if new table)
```

## Linked Skills

- `fastapi` -> Routing, dependencies
- `database` -> Database patterns
- `performance` -> Query optimization

## Works With

- `@db-architect` -> Schema design
- `@security-reviewer` -> Auth, validation
- `@frontend-developer` -> API contract
