-- ORDS/APEX REST workshop example. Enable the schema in ORDS before defining modules.
BEGIN
  ORDS.DEFINE_MODULE(p_module_name=>'fieldops.v1', p_base_path=>'/fieldops/v1/', p_items_per_page=>25);

  ORDS.DEFINE_TEMPLATE(p_module_name=>'fieldops.v1', p_pattern=>'work-orders/');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'fieldops.v1', p_pattern=>'work-orders/',
    p_method=>'GET', p_source_type=>ORDS.source_type_collection_feed,
    p_source=>'SELECT work_order_id, title, priority, status, scheduled_for FROM work_orders ORDER BY created_at DESC'
  );

  ORDS.DEFINE_TEMPLATE(p_module_name=>'fieldops.v1', p_pattern=>'work-orders/:id/');
  ORDS.DEFINE_HANDLER(
    p_module_name=>'fieldops.v1', p_pattern=>'work-orders/:id/',
    p_method=>'GET', p_source_type=>ORDS.source_type_collection_item,
    p_source=>'SELECT * FROM work_orders WHERE work_order_id = :id'
  );
  COMMIT;
END;
/
