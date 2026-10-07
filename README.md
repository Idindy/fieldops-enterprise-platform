# FieldOps Enterprise Platform

Portfolio implementation of an enterprise field-service and work-order system designed around Oracle Database, PL/SQL, REST integration, and Oracle APEX-friendly data models.

## Why this project
Field operations applications require transactional integrity, controlled workflow transitions, traceability, and clear separation between database business logic and presentation. FieldOps models those concerns for technicians, assets, service requests, work orders, assignments, and audit history.

## Architecture
- **Oracle SQL** — normalized operational schema, constraints, indexes, sequences
- **PL/SQL** — packaged business logic, validation, work-order state transitions, assignment logic
- **Oracle APEX-ready views** — dashboard/report/form queries intended for APEX pages
- **REST** — ORDS-style endpoint examples for application integration
- **JavaScript** — lightweight client-side validation and dashboard behavior
- **Testing** — executable PL/SQL smoke tests and workflow assertions
- **GitHub Actions** — static validation of SQL/PLSQL source structure

## Core workflows
1. Create a service request against an asset.
2. Convert an approved request into a work order.
3. Assign an available technician.
4. Progress work through OPEN → ASSIGNED → IN_PROGRESS → COMPLETED.
5. Record status changes in an immutable audit trail.
6. Surface operational KPIs through reporting views.

## Repository layout
```
database/
  schema.sql
  seed.sql
  packages/
  views/
rest/
  ords_endpoints.sql
apex/
  page_design.md
web/
  fieldops.js
tests/
  test_work_orders.sql
.github/workflows/
  validate.yml
```

## Oracle APEX implementation
The `apex/page_design.md` blueprint maps the schema and views to an APEX application containing an operations dashboard, interactive work-order report, technician assignment form, asset detail page, and service-request workflow.

## Run locally
Use Oracle Database Free/XE or an Oracle Autonomous Database workspace.

```sql
@database/schema.sql
@database/packages/pkg_work_orders.pks
@database/packages/pkg_work_orders.pkb
@database/views/v_operations_dashboard.sql
@database/seed.sql
@tests/test_work_orders.sql
```

## Engineering decisions
Business-critical state transitions live in PL/SQL rather than only in UI code. Foreign keys and check constraints enforce invariants at the database layer, while an audit table records workflow changes. Package APIs provide a stable interface for APEX or REST clients.

## Skills demonstrated
Oracle Database • PL/SQL packages • SQL • Oracle APEX application design • REST/ORDS concepts • JavaScript • relational modeling • auditability • transactional workflows • Git/version control • automated validation
