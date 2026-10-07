# Oracle APEX Application Blueprint

## Shared components
- Authentication: APEX Accounts or enterprise SSO adapter
- Authorization schemes: OPERATIONS_MANAGER, DISPATCHER, TECHNICIAN, VIEWER
- LOVs: active technicians, asset status, work-order priority/status
- REST Data Source: optional FieldOps v1 ORDS module

## Page 1 — Operations Dashboard
Cards source: `v_operations_dashboard`. Add charts grouping active work orders by priority and technician.

## Page 10 — Work Orders
Interactive Report over `work_orders` joined to assets and technicians. Faceted search: status, priority, technician, location.

## Page 11 — Work Order Detail
Form with optimistic-lock `version_no`. Assignment and state changes call `pkg_work_orders`; UI does not directly bypass workflow rules.

## Page 20 — Service Requests
Interactive report + modal create form. "Convert to Work Order" process calls `pkg_work_orders.create_from_request`.

## Page 30 — Assets
Master/detail asset page showing open work and service history.

## Page 40 — Technician Dispatch
Cards/grid of active technicians and current assignments. Dispatcher action calls `assign_technician`.

## Security
Escape output by default; bind variables for SQL; authorization checks on mutating pages; database package revalidates workflow invariants.
