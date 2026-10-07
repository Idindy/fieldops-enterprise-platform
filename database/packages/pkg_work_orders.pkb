CREATE OR REPLACE PACKAGE BODY pkg_work_orders AS
  PROCEDURE log_change(p_id NUMBER, p_old VARCHAR2, p_new VARCHAR2,
                       p_user VARCHAR2, p_notes VARCHAR2) IS
  BEGIN
    INSERT INTO work_order_audit(work_order_id, old_status, new_status, changed_by, notes)
    VALUES (p_id, p_old, p_new, p_user, p_notes);
  END;

  PROCEDURE create_from_request(p_request_id NUMBER, p_changed_by VARCHAR2,
                                p_work_order_id OUT NUMBER) IS
    l_req service_requests%ROWTYPE;
  BEGIN
    SELECT * INTO l_req FROM service_requests
     WHERE request_id = p_request_id FOR UPDATE;
    IF l_req.request_status NOT IN ('NEW','APPROVED') THEN
      raise_application_error(-20001, 'Request cannot be converted.');
    END IF;

    INSERT INTO work_orders(request_id, asset_id, title, priority)
    VALUES(l_req.request_id, l_req.asset_id, l_req.summary, l_req.priority)
    RETURNING work_order_id INTO p_work_order_id;

    UPDATE service_requests SET request_status = 'CONVERTED'
     WHERE request_id = p_request_id;
    log_change(p_work_order_id, NULL, 'OPEN', p_changed_by, 'Created from service request');
  END;

  PROCEDURE assign_technician(p_work_order_id NUMBER, p_technician_id NUMBER,
                              p_changed_by VARCHAR2) IS
    l_active technicians.active_flag%TYPE;
    l_old work_orders.status%TYPE;
  BEGIN
    SELECT active_flag INTO l_active FROM technicians
     WHERE technician_id = p_technician_id;
    IF l_active <> 'Y' THEN raise_application_error(-20002, 'Technician is inactive.'); END IF;

    SELECT status INTO l_old FROM work_orders
     WHERE work_order_id = p_work_order_id FOR UPDATE;
    IF l_old <> 'OPEN' THEN raise_application_error(-20003, 'Only OPEN work orders can be assigned.'); END IF;

    UPDATE work_orders SET assigned_technician_id=p_technician_id,
      status='ASSIGNED', updated_at=SYSTIMESTAMP, version_no=version_no+1
     WHERE work_order_id=p_work_order_id;
    log_change(p_work_order_id, l_old, 'ASSIGNED', p_changed_by, 'Technician assigned');
  END;

  PROCEDURE transition_status(p_work_order_id NUMBER, p_new_status VARCHAR2,
                              p_changed_by VARCHAR2, p_notes VARCHAR2 DEFAULT NULL) IS
    l_old work_orders.status%TYPE;
    l_new VARCHAR2(30) := UPPER(p_new_status);
    l_allowed BOOLEAN := FALSE;
  BEGIN
    SELECT status INTO l_old FROM work_orders WHERE work_order_id=p_work_order_id FOR UPDATE;
    l_allowed := (l_old='ASSIGNED' AND l_new='IN_PROGRESS')
              OR (l_old='IN_PROGRESS' AND l_new='COMPLETED')
              OR (l_old IN ('OPEN','ASSIGNED') AND l_new='CANCELLED');
    IF NOT l_allowed THEN raise_application_error(-20004, 'Invalid work-order transition.'); END IF;

    UPDATE work_orders SET status=l_new, updated_at=SYSTIMESTAMP,
      completed_at=CASE WHEN l_new='COMPLETED' THEN SYSTIMESTAMP ELSE completed_at END,
      version_no=version_no+1 WHERE work_order_id=p_work_order_id;
    log_change(p_work_order_id, l_old, l_new, p_changed_by, p_notes);
  END;
END pkg_work_orders;
/
