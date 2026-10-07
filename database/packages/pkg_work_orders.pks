CREATE OR REPLACE PACKAGE pkg_work_orders AS
  PROCEDURE create_from_request(
    p_request_id IN NUMBER,
    p_changed_by IN VARCHAR2,
    p_work_order_id OUT NUMBER
  );

  PROCEDURE assign_technician(
    p_work_order_id IN NUMBER,
    p_technician_id IN NUMBER,
    p_changed_by IN VARCHAR2
  );

  PROCEDURE transition_status(
    p_work_order_id IN NUMBER,
    p_new_status IN VARCHAR2,
    p_changed_by IN VARCHAR2,
    p_notes IN VARCHAR2 DEFAULT NULL
  );
END pkg_work_orders;
/
