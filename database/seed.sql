INSERT INTO technicians(employee_code,full_name,email,skill_group) VALUES('TECH-101','Jordan Lee','jordan.lee@example.com','Electrical');
INSERT INTO technicians(employee_code,full_name,email,skill_group) VALUES('TECH-102','Morgan Reed','morgan.reed@example.com','Mechanical');
INSERT INTO assets(asset_tag,asset_type,location_name) VALUES('AST-1001','HVAC Unit','North Facility');
INSERT INTO assets(asset_tag,asset_type,location_name) VALUES('AST-1002','Generator','Operations Center');
INSERT INTO service_requests(asset_id,requested_by,summary,priority)
SELECT asset_id,'Operations Desk','Intermittent shutdown requires inspection','HIGH' FROM assets WHERE asset_tag='AST-1002';
COMMIT;
