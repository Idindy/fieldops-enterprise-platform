SET SERVEROUTPUT ON;
DECLARE
  l_request_id NUMBER;
  l_tech_id NUMBER;
  l_work_order_id NUMBER;
  l_status VARCHAR2(30);
  l_audits NUMBER;
BEGIN
  SELECT request_id INTO l_request_id FROM service_requests WHERE ROWNUM=1;
  SELECT technician_id INTO l_tech_id FROM technicians WHERE active_flag='Y' AND ROWNUM=1;

  pkg_work_orders.create_from_request(l_request_id, 'TEST_RUNNER', l_work_order_id);
  pkg_work_orders.assign_technician(l_work_order_id, l_tech_id, 'TEST_RUNNER');
  pkg_work_orders.transition_status(l_work_order_id, 'IN_PROGRESS', 'TEST_RUNNER', 'Started');
  pkg_work_orders.transition_status(l_work_order_id, 'COMPLETED', 'TEST_RUNNER', 'Verified');

  SELECT status INTO l_status FROM work_orders WHERE work_order_id=l_work_order_id;
  IF l_status <> 'COMPLETED' THEN raise_application_error(-20990,'Expected COMPLETED'); END IF;

  SELECT COUNT(*) INTO l_audits FROM work_order_audit WHERE work_order_id=l_work_order_id;
  IF l_audits <> 4 THEN raise_application_error(-20991,'Expected four audit events'); END IF;
  DBMS_OUTPUT.PUT_LINE('PASS: work-order lifecycle and audit history');
  ROLLBACK;
END;
/
