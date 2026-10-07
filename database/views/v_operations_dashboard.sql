CREATE OR REPLACE VIEW v_operations_dashboard AS
SELECT
  COUNT(*) total_work_orders,
  SUM(CASE WHEN status='OPEN' THEN 1 ELSE 0 END) open_orders,
  SUM(CASE WHEN status='IN_PROGRESS' THEN 1 ELSE 0 END) in_progress_orders,
  SUM(CASE WHEN status='COMPLETED' THEN 1 ELSE 0 END) completed_orders,
  SUM(CASE WHEN priority='CRITICAL' AND status NOT IN ('COMPLETED','CANCELLED') THEN 1 ELSE 0 END) critical_active
FROM work_orders;
